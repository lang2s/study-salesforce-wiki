# forceNote-wiki 팀 프로토콜

> 이 문서는 PM 에이전트가 작업 시작 시 반드시 읽는다. 모든 에이전트의 역할, 파이프라인, 핸드오프 규칙을 정의한다.

---

## 팀 구성 (15명)

| 역할 | 에이전트 ID | 핵심 책임 | 파일 쓰기 권한 |
|---|---|---|---|
| PM | `pm` | 작업 분해, 에이전트 조율, 최종 보고 | ❌ |
| 질문 명확화 | `question-clarifier` | 모호한 요청 → 명확한 스펙 | ❌ |
| 리서치 플래너 | `planner` | 소스 파악, 리서치 플랜 생성 | ❌ |
| 소스 탐색 | `scout` | 소스 위치 탐색 (파일 경로, 라인 번호) | ❌ |
| **소스 커버리지 검사** | `source-coverage-checker` | 놓친 소스 탐색 (writer와 병렬) | ❌ |
| 자료 조사 | `researcher` | 소스에서 모든 내용 추출 | ❌ |
| 자료 분류 | `classifier` | 폴더·Tier·구조·wikilink 결정 | ❌ |
| 작성 | `writer` | 위키 .md 파일 생성/수정 | ✅ (콘텐츠 파일만) |
| 완전성 검증 | `completeness-validator` | 누락된 클래스/메서드 탐지 | ❌ |
| 출처 검증 | `source-verifier` | API명·코드·Tier 정확성 검증 | ❌ |
| 인덱스 관리 | `index-manager` | SEARCH_INDEX·MOC·index.md 업데이트 | ✅ (탐색 파일만) |
| **교차 링크** | `cross-linker` | 기존 페이지 → 새 페이지 양방향 링크 | ✅ (관련 노트 섹션만) |
| 위키 점검 | `wiki-linter` | 전체 위키 건강 검사 | ❌ |
| QA | `qa` | 최종 검토 및 승인/반려 | ❌ |
| **회고·인덱스 강화** | `retrospective-analyst` | 누락 원인 분석, SEARCH_INDEX·aliases 강화 | ✅ (frontmatter·SEARCH_INDEX만) |
| **커버리지 분석** | `coverage-analyst` | 위키 전체 공백 분석, 작업 우선순위 제안 | ❌ |

---

## 파이프라인

### A. 표준 파이프라인 — 새 콘텐츠 추가

```
question-clarifier (요청 모호시)
        ↓
      pm (작업 분해)
        ↓
    planner (리서치 플랜)
        ↓
     scout (소스 위치 탐색)
        ↓
  researcher (전체 내용 추출)
        ↓
  classifier (분류·구조 결정)
        ↓
┌─────────────────────────────────────────┐
│           병렬 실행                       │
│  writer              source-coverage-    │
│  (파일 작성)          checker            │
│                      (놓친 소스 탐색)    │
└─────────────────────────────────────────┘
        ↓ (둘 다 완료 후)
  [coverage-checker가 놓친 소스 발견시 → PM 판단 → 추가 researcher 사이클]
        ↓
completeness-validator (누락 검사)
        ↓
  [누락 있으면 → writer 재작업]
        ↓
source-verifier (정확성 검사)
        ↓
  [오류 있으면 → writer 수정]
        ↓
 index-manager (탐색 파일 업데이트)
        ↓
  cross-linker (양방향 링크 구축)
        ↓
       qa (최종 검토)
        ↓
retrospective-analyst (회고 + 인덱스 강화)
        ↓
      pm (사용자 보고)
```

### B. 빠른 파이프라인 — 기존 파일 보완

```
planner → scout → researcher → writer → completeness-validator
       → source-verifier → index-manager → retrospective-analyst
```

### C. 점검 파이프라인 — 위키 건강 검사 (/lint)

```
wiki-linter → qa → pm (보고)
```

### D. 커버리지 분석 파이프라인 — 큰 그림 공백 파악

```
coverage-analyst → pm (우선순위 보고 → 다음 작업 결정)
```

*10개 이상 새 작업 완료 후 또는 사용자가 "뭐가 없어?" 물을 때 실행*

### E. 답변 파이프라인 — 위키 내용 질문

```
question-clarifier (필요시) → (PM이 직접 위키 읽고 답변)
```

---

## 병렬 실행 규칙

### writer ↔ source-coverage-checker 병렬 실행

```
조건:   researcher 완료 후
동시에: writer(파일 작성) + source-coverage-checker(놓친 소스 탐색)
완료:   둘 다 완료되면 PM이 coverage-checker 보고를 받음
판단:   PM이 놓친 소스의 중요도를 평가
  → 중요: 현재 사이클에 추가 (writer 재작업)
  → 낮음: 차기 작업으로 등록
  → 무관: 무시
```

### completeness-validator ↔ source-verifier 병렬 실행 가능

두 검증은 독립적이므로 동시에 실행해도 무방:
```
writer 완료 → [completeness-validator + source-verifier] 병렬
           → 둘 다 ✅ 통과 → 다음 단계
           → 하나라도 ❌ → writer 수정 → 재검증
```

---

## 에이전트 간 핸드오프 규칙

### 1. 입력 명세 포함

에이전트를 호출할 때 반드시 다음을 포함한다:
- 이전 에이전트의 출력 결과 (요약 또는 전체)
- 작업 범위 제약 (사용자가 "~빼고" 말한 것 등)
- 완료 기준

### 2. 재작업 루프

```
completeness-validator ❌ → writer에게 갭 리포트 전달 → writer 수정 → 재검증
source-verifier ❌        → writer에게 오류 목록 전달 → writer 수정 → 재검증
qa ❌                     → 해당 에이전트에게 구체적 지시 → 재작업 → qa 재검토
```

재작업은 최대 2회. 그래도 해결 안 되면 PM이 사용자에게 보고하고 판단 요청.

### 3. retrospective-analyst 실행 조건

- qa ✅ 통과 후에만 실행
- 단순 오타 수정·링크 수정 같은 소규모 작업은 건너뜀
- 새 파일 생성 또는 대규모 보완 작업 후 반드시 실행

### 4. 건너뛰기 규칙

PM이 판단하여 에이전트를 건너뛸 수 있는 조건:

| 건너뛰는 에이전트 | 조건 |
|---|---|
| `question-clarifier` | 요청이 명확하고 구체적인 경우 |
| `scout` | 소스 위치가 이미 알려진 경우 |
| `source-coverage-checker` | 소스가 단 하나만 존재함이 확실한 경우 |
| `classifier` | 같은 파일을 보완하는 경우 |
| `completeness-validator` | 단순 오타 수정 등 내용 추가 없는 경우 |
| `cross-linker` | 주제가 매우 특화되어 기존 파일과 연관 없는 경우 |
| `coverage-analyst` | 매 작업마다 실행 X — 주기적으로만 실행 |

---

## 고정 제약 (모든 에이전트 공통)

1. **Tier 3 출처** — 항상 경고 블록 추가 필수
2. **폴더명** — English(한글) 형식 필수, 순한글 금지
3. **wikilink** — 존재 확인 없이 추가 금지

---

## 소스 위치 참조

```
PDF 소스:
/Users/a/Desktop/Study/Salesforce Documents/salesforce_apex_reference_guide.pdf
/Users/a/Desktop/Study/Salesforce Documents/lightningAura.pdf
/Users/a/Desktop/Study/Salesforce Documents/salesforce_soql_sosl.pdf

TrailheadApp 소스:
/Users/a/Desktop/Study/ (하위 폴더 ls로 확인)

PDF 추출 도구:
/opt/homebrew/bin/pdftotext

임시 파일 저장:
/tmp/ (세션 간 유지되지 않음 — Scout가 매번 새로 추출)
```

---

## 버전

- 프로토콜 버전: 1.1
- 최초 작성: 2026-05-18
- 마지막 업데이트: 2026-05-18 (source-coverage-checker, retrospective-analyst, cross-linker, coverage-analyst 추가)
- 다음 검토: 10개 이상 새 작업 완료 후
