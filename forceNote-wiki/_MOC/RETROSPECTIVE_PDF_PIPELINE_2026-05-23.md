---
tags: [retrospective, pipeline, quality, pattern, PDF-authoring, 회고, 품질개선]
source: 작업 회고 (Task #1·#2 · pkg2_dev.pdf 기반)
created: 2026-05-23
aliases: [PDF 작성 파이프라인 회고, 4 패턴 진화, Pattern A·B·C·D, Task #1 #2 회고, pipeline quality evolution]
---

# 회고 — PDF 기반 작성 파이프라인 4 패턴 진화 (2026-05-23)

> Task #1·#2 (pkg2_dev.pdf 기반 2GP Managed Package 페이지 작성)에서 발견된 정확도 오류와 그 원인 패턴, 도입한 예방 protocol, 측정된 효과, 그리고 남은 격차의 회고. 매 작업이 protocol을 진화시키는 continuous improvement loop의 첫 두 사이클 기록.

---

## 1. Timeline — 무엇이 일어났는가

### 1-1. Task #1 (개발 환경과 사전 준비, p.6-14)

- 작성: 첫 draft 완료 (357줄, 9 main sections, 18 code blocks, 7 valid wikilinks)
- 평가 요청 시 발견된 5건 결함:
  - 🔴 Dependency matrix 4×4의 Unmanaged 컬럼 3 cells가 ❌ → 실제는 "권장 안 함"
  - 🔴 footnote ¹ 핵심 정보 누락 (override path + Partner Support case 등록 경로)
  - 🟡 ASCII tree 다이어그램 fabricate (마커 없음, PDF에는 다이어그램이 이미지로 존재)
  - 🟡 Section 2(사전 체크리스트) ↔ Section 9(종합 체크리스트) 거의 중복
  - 🟡 Section 3-2 (Namespace Org) 2줄만 → 깊이 불균형
- Severity: HIGH (factual error 2건) + MEDIUM 3건

### 1-2. 4 패턴 식별과 protocol 도입

- 4 패턴으로 묶음:
  - **Pattern A** — Source 재추출 누락 (메모리 의존 → matrix 셀 오기재 + footnote 1줄 요약)
  - **Pattern B** — Matrix transpose 시 셀별 검증 누락 (PDF row=dependency, my row=depender 변환에서 셀별 확인 안 함)
  - **Pattern C** — pdftotext 시각자료 blind spot ("see figure" 단서 무시 + 추측 ASCII art + 마커 없음)
  - **Pattern D** — Structure rigidity (PDF TOC 그대로 옮겨 redundancy/imbalance)
- 보관 3중망:
  - `forceNote-wiki/CLAUDE.md` 0-2 검증 표에 마커 의무 + 매트릭스 검증 + pdftoppm 명시
  - `forceNote-wiki/.claude/agents/writer.md` PDF 사전 protocol 섹션 신설
  - `memory/feedback_pdf_wiki_authoring.md` (이 머신 전용 빠른 recall — 본문은 위 두 git파일이 single source of truth)
- Task #1 5건 수정 + Step 4 적용

### 1-3. Portability 위기 발견

- 사용자 지적: "memory는 다른 환경에서 못 쓰는 거 아닌가?"
- 실제 진단: memory만 그런 게 아니라 **`.claude/settings.json` + `scripts/lint-md-file.sh` 가 git에 추적조차 안 됨** → L1 훅 자체가 다른 환경에서 동작 안 함
- 복구: `.gitignore` 업데이트(settings.local.json 제외) + 신규 파일 모두 git add + memory는 포인터 형태로 슬림화

### 1-4. Pipeline 강화 (Task #14)

- writer만 강화하면 앞단 추출 오류가 통과 → pipeline 전체에 패턴별 owner 배분:
  - scout.md: Pattern C (시각자료 사전 식별 + 출력에 visual content 경고)
  - researcher.md: Pattern A·B·C (raw sed 출력 포함, 매트릭스 unique 값 나열, 시각자료 flag)
  - classifier.md: Pattern D (독자 path 우선, redundancy/depth balance 사전 점검, 결정 근거 명시)
  - source-verifier.md: Pattern B·C audit (5번째·6번째 검증 항목 추가)
  - completeness-validator.md: Pattern A·B 보강 (matrix cell 완전성, footnote/note/callout 완전성)
  - writer.md: 4 패턴 사전 protocol + 6 패턴 reference (기존 강화)

### 1-5. Task #2 (Scratch Org 워크플로, p.15-23)

- 강화된 protocol 적용: 시각자료 사전 스캔(pdfimages -list, "see figure" grep) + 섹션별 재추출 + reader path 구조 설계
- 첫 draft 완료 (413줄, 26 code blocks, 9 valid wikilinks, 31 table lines)
- 평가 요청 시 발견된 3건 결함:
  - 🔴 Section 6-2 Snapshot 할당량 daily 값 오기재 (300/40 → 실제 150/20)
  - 🟡 "RAG·Retrievers·BYO LLM 쓰면" → PDF는 "such as" (예시) — 조건처럼 옮김
  - 🟡 ancestor seeding warning "즉시" 강도 과함
- Severity: MEDIUM 1건 + LOW 2건 (Task #1 대비 개선)

### 1-6. Protocol 2차 진화

- Task #2의 Snapshot 할당량 오류 분석 → Pattern A·B의 사각지대 발견:
  - Pattern A의 "무작위 spot check 3-5개"가 critical claim을 놓침
  - Pattern B의 "matrix"가 산문형 numeric mapping(single value → N metrics)을 못 잡음
- 2차 강화:
  - **Pattern A**: 무작위 → **6 카테고리 강제 검증** (numeric / list / footnote / "such as" / 강조어 / single→N mapping)
  - **Pattern B**: 격자형 매트릭스 + 산문형 numeric mapping (B-1·B-2·B-3 세분화)
  - writer.md + source-verifier.md(5-A/5-B/5-C 분할) 반영

---

## 2. Patterns — 4 패턴의 정착

### 2-1. Pattern A — Source 재추출 discipline

- **현상**: 작업 초반 한 번만 추출하고 메모리로 작성 → matrix 셀 오기재, footnote 한 줄 요약, ancestry tree 추측
- **원인**: 컨텍스트 절약 본능 + "작성 흐름 끊김" 회피 + "기억으로 충분" 자기 합리화
- **Protocol**:
  - 메이저 섹션 작성 직전 `sed -n 'X,Yp'` 재추출 (writer)
  - raw sed 출력을 dump에 포함 (researcher)
  - 작성 후 6 카테고리 spot check (writer)
- **owner**: researcher(1차) + writer(2차) + completeness-validator(audit)

### 2-2. Pattern B — Tabular AND numeric mapping 셀별 검증

- **현상**: 4×4 matrix transposition에서 3 cells wrong + 산문형 single value → N metrics에서 잘못된 symmetric 가정
- **원인**: "transpose는 한 번만 매핑하면 자동으로 맞다"는 잘못된 신뢰 + ✅/❌로 미묘한 상태("Not recommended") 손실
- **Protocol**:
  - 격자형: PDF→내 표 매핑 명시적으로 작성, unique 값 모두 나열
  - 산문형: "the same as" / "equal to" / "matches" 식 reference 표현 식별, symmetric 가정 차단
  - numeric value는 PDF 원문 인용 함께 두기
- **owner**: researcher(1차) + writer(2차) + source-verifier·completeness-validator(audit)

### 2-3. Pattern C — pdftotext 시각 자료 blind spot

- **현상**: PDF에 ancestry tree 다이어그램이 있는데 텍스트로 "see figure" 단서가 있는 걸 무시하고 추측 ASCII art 작성, 마커도 누락
- **원인**: 시각 자료 처리 protocol 부재 + "정보 채워야지" 유혹 + CLAUDE.md 마커 규칙을 코드에만 한정 해석
- **Protocol**:
  - scout: `pdfimages -list` + "see figure/diagram/tree" grep → visual content 경고 출력
  - researcher: scout 경고를 dump에 ⚠️ 표시, 텍스트 단서만 추출
  - writer: 직접 만든 모든 구조물(코드·다이어그램·ASCII·JSON)에 `// 구조 예시 — 실제 [동작 코드 / 원본 다이어그램] 아님` 마커 의무
  - source-verifier: ASCII art 마커 audit
- **owner**: scout(감지) + researcher(표시) + writer(마커) + source-verifier(audit)

### 2-4. Pattern D — Structure rigidity 회피

- **현상**: PDF TOC를 그대로 위키 섹션으로 옮겨서 Section 2/9 중복 + Section 3-2 빈약(2줄)
- **원인**: TOC 권위 본능 + 구조 재검토 단계 없음 + "PDF에 있으니 페이지에도" false equivalence
- **Protocol**:
  - classifier: 독자 path 우선, redundancy/depth balance 사전 점검, 결정 근거 명시
  - writer: 첫 draft 후 `grep '^#' file.md`로 outline view 점검, 너무 짧은 섹션 합치기
- **owner**: classifier(1차) + writer(사후 점검)

---

## 3. Protocol 도입 history

| 시점 | 추가/변경 | 위치 |
|---|---|---|
| Task #1 발견 직후 | 4 패턴 식별 + memory 저장 | `memory/feedback_pdf_wiki_authoring.md` |
| 1차 영구화 | 4 패턴 핵심 규칙 | `CLAUDE.md` 0-2 검증 표 확대 |
| 1차 에이전트화 | 4 패턴 PDF 사전 protocol | `writer.md` |
| Portability 위기 | git add 누락 자산 + .gitignore | `.gitignore`, `.claude/settings.json`, `scripts/lint-md-file.sh` |
| Pipeline 전체 강화 (#14) | 패턴별 owner 분배 | `scout/researcher/classifier/source-verifier/completeness-validator.md` 모두 |
| Task #2 발견 직후 | Pattern A: 6 카테고리 spot check | `writer.md` Pattern A 섹션 |
| Task #2 발견 직후 | Pattern B 일반화 (산문형 numeric mapping) | `writer.md` B-1/B-2/B-3 + `source-verifier.md` 5-A/5-B/5-C |
| memory 슬림화 | 본문은 git repo로, memory는 포인터 | `memory/feedback_pdf_wiki_authoring.md` |

---

## 4. 효과 측정 — Task #1 vs Task #2

```
지표                  Task #1            Task #2          개선
─────────────────────────────────────────────────────────────────
결함 수              5건                3건              ↓ 40%
Severity 분포        HIGH 2 / MEDIUM 3   MEDIUM 1 / LOW 2  ↓ 1 단계
─────────────────────────────────────────────────────────────────
Matrix 셀 오류        3 cells wrong      0건              완전 해결
Marker 위반          1건 (ASCII tree)   0건              완전 해결
구조 redundancy      2건 (sec 2·3-2)    0건              완전 해결
Spot check 결과      사용자 평가로 발견   자체 5/5 통과     ↑ 자체 탐지
Critical 사실 오류   3 matrix cells     1 numeric value   ↓ scope 축소
─────────────────────────────────────────────────────────────────
분량                 357 lines          413 lines        +56줄 (더 깊음)
포함 wikilinks       7개                9개              +2 (더 풍부)
코드 블록            18개                26개             +8 (더 구체적)
```

★ 효과 분석 (어떤 패턴이 잘 작동했나):

| Pattern | Task #1 결함 | Task #2 결과 | 평가 |
|---|---|---|---|
| C (시각자료) | ASCII tree fabricate + 마커 누락 | 사전 스캔 → fabricate 0건 | ✅ 완전히 작동 |
| D (구조) | Section 2/9 중복 + 빈약 sec 3-2 | 중복·불균형 0건 | ✅ 완전히 작동 |
| B (matrix) | 4×4 matrix 3 cells wrong | 격자형 매트릭스 없어 적용 못 함 | ⚠️ 격자형엔 effective, 산문형엔 1건 누락(2차 진화) |
| A (재추출) | matrix 셀 오기재 (3) + footnote 누락 | 무작위 5/5 통과, but Snapshot 할당량 누락 | ⚠️ 무작위 spot check 한계 (2차 진화) |

---

## 5. 남은 격차 — Pipeline은 정의되었으나 invoke 안 됨

### 5-1. 핵심 격차

```
agent 정의 (강화됨, git에 staged)
     ↓
실제 호출/사용 (X — 거의 모두 manual 작성)
```

| 에이전트 | 정의 강화? | Task #1·#2에서 실제 호출? |
|---|---|---|
| writer | ✅ 4 패턴 + 6 카테고리 | ❌ (저 혼자 manual 작성) |
| scout | ✅ Pattern C (시각자료) | ❌ (저 혼자 `pdfimages -list`·grep 실행) |
| researcher | ✅ Pattern A·B·C | ❌ (저 혼자 sed 추출) |
| classifier | ✅ Pattern D | ❌ (저 혼자 구조 설계) |
| source-verifier | ✅ B·C audit + 5-A·5-B·5-C | ❌ (저 혼자 사후 spot check) |
| completeness-validator | ✅ A·B 보강 | ❌ (저 혼자 완전성 점검) |
| pm·planner·qa·cross-linker·index-manager | (변경 없음) | ❌ |

→ Protocol은 **저(작성자)의 의식적 행동 가이드**로 동작 중. **팀 파이프라인 자체는 0회 invoke**.

### 5-2. 격차가 의미하는 것

**Pro**:
- protocol을 의식적으로 따른 결과 Task #1 → Task #2 결함 40% 감소 — 효과는 실증.
- 다른 환경(Windows·다른 Mac)에서 같은 protocol이 자동 적용 (git-committed).

**Con**:
- 에이전트 정의의 새 protocol이 실제 invocation 시 잘 작동하는지 검증 안 됨.
- 예: scout의 "시각 자료 경고" 출력 형식이 researcher가 받아 쓰기 좋은 형태인지 미검증.
- 예: source-verifier의 5-A/5-B/5-C 검증 항목이 LLM context에서 실제로 모든 cell을 점검하는지 미검증 (read window 한계).
- 에이전트 간 handoff(scout→researcher→classifier→writer)에서 정보 손실 없는지도 미검증.

### 5-3. 검증 방법 옵션

| 옵션 | 작업량 | 가치 |
|---|---|---|
| A. Task #3에서 PM 호출 → 표준 파이프라인 실행 | 중간 (token 비용) | 실제 invocation 효과 측정 |
| B. Task #3은 manual 유지, 다음 큰 작업에서 PM 호출 | 작음 | 작은 작업으로 risk-free 진행 |
| C. 한 에이전트씩 격리 테스트 (예: scout만 invoke해 visual content 경고 확인) | 작음 | 단계별 검증 |
| D. invocation 검증 없이 다음 작업 계속 | 0 | 격차 그대로 남음 |

---

## 6. 다른 미해결 사항

### 6-1. PDF 시각 자료의 적극적 활용 부재
- pdftotext가 못 잡는 다이어그램은 protocol이 "마커 + skip"으로 처리. 그러나 진짜 필요한 다이어그램은 `pdftoppm`으로 이미지화 후 Read하는 옵션이 protocol에 있으나 한 번도 실제 사용 안 됨.
- 위키 자체에 이미지 첨부 정책 부재 — 다이어그램이 정말 필요한 페이지는 PDF의 figure 캡처를 위키에 첨부할 수 있어야 함. 별도 결정 필요.

### 6-2. L1 훅이 못 잡는 의미 오류 — Phase 2 도입 안 됨
- L1 훅은 구조만 검사. Snapshot 할당량 같은 numeric error는 사용자 요청 시에만 발견.
- Phase 2(source-verifier 자동 invocation)가 protocol 강화 후에도 도입 안 된 상태.
- ROI: numeric error 1건 = 사용자 피드백 cycle 1회 = 토큰·시간 비용. Phase 2의 자동 source-verifier 호출이 비용 회수 가능한지 측정 필요.

### 6-3. Components Available 같은 거대 카탈로그 처리 protocol 부재
- Task #4 (Components Available 카탈로그, ~288쪽)는 현 protocol로 처리하기 어려운 규모.
- 1 페이지에 300+ 메타데이터 타입 카탈로그 vs 분할 — 결정 protocol이 없음.
- 기존 `MetadataAPI/Metadata Types — *.md` 시리즈와 중복 가능 — 분업 protocol 명시 필요.

### 6-4. 다른 PDF로의 전이
- 4 패턴은 `pkg2_dev.pdf` 사례에서 추출됐지만 generalize되었음 (PDF 일반에 적용 가능 명시).
- 그러나 다른 PDF(예: `salesforce_apex_reference_guide.pdf`, `api_meta.pdf`)에서 발현되는 다른 패턴이 있을 수 있음 → 다음 PDF 작업 시 새 패턴 발견 가능성 열어둠.

---

## 7. 추천 다음 단계

```
A. Task #3 (Workflow, 2쪽)
   → 짧은 페이지로 strengthened protocols의 small-scale validation
   → manual 작성 유지 (효율)

B. Task #4 직전 — 카탈로그 protocol 결정
   → Components Available 분할 vs 단일 페이지 결정
   → 기존 Metadata Types 시리즈와 분업 명시

C. 중기 — Phase 2 (LLM-level source-verifier 자동 invocation) 검토
   → settings.json hook으로 wiki 콘텐츠 .md 작성 시 자동 호출
   → ROI 시뮬레이션 (numeric error 1건 비용 vs 자동 호출 토큰 비용)

D. 장기 — 다른 PDF 작업에서 새 패턴 수집
   → api_meta.pdf · 다른 reference guide 작업 시 발견되는 패턴을 5번째·6번째 Pattern으로 추가
```

---

## 관련 노트

- [[WIKI_RULES]] — wiki 작성 규칙 전반
- [[2GP Managed Package 개념과 1GP 비교]] — Task #1 결과물
- [[2GP Managed Package 개발 환경과 사전 준비]] — Task #1 결과물
- [[2GP Managed Package Scratch Org 워크플로]] — Task #2 결과물

---

## 부록 — AP-04: cross-linker 허브 누락 (2026-05-24)

### 문제
2GP Components 8분할(4a~4h) 8개 파일 작업 후 다각도 검사에서 다음 누락 발견:
- MetadataAPI 역링크 4건 누락: Einstein & Analytics, Integration & Platform, UI & Layout, Other
- `2GP Managed Package — Workflow.md` → 8개 형제 링크 중 7건 누락 (Apex & Code 1개만 있었음)

### 원인
cross-linker가 형제 노트(같은 시리즈 다른 파일) 역링크는 100% 챙기나, **상위 허브·카탈로그 페이지**(MetadataAPI 도메인 파일·Workflow MOC 등) 역링크는 가끔 빠짐. 형제 중심으로 동작하느라 "이미 존재하던 카탈로그"를 잊는 경향.

### 영향
- 콘텐츠 섬은 아님 (형제 간 링크로 다른 형제로 도달 가능)
- 하지만 사용자가 카탈로그 페이지(예: `Metadata Types — Other.md`)를 보고 있을 때 같은 도메인의 2GP 패키징 동작 페이지로 점프 불가 → 발견성 저하

### 처리
- 누락된 11건 모두 보완 (2026-05-24)
- `.claude/agents/cross-linker.md`에 "허브·카탈로그 페이지 우선 점검 (시리즈 작업 필수)" 섹션 추가:
  - 시리즈 작성 시 형제 + 상위 카탈로그 양쪽 점검 의무화
  - 적용 대상 허브 매트릭스 명시 (2GP Components·Metadata Types·Apex Namespace·Trailhead·LWC LDS)
  - 자가 체크 명령 패턴 제공

### 검증
- 5개 수정 파일 L1 lint 통과 ✅
- 11건 역링크 grep 재검증 ✅
