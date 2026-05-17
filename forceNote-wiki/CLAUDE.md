# Salesforce Wiki — Claude 작업 규칙

이 디렉토리는 Salesforce 개발 패턴을 정리한 개인 학습 wiki다.
새 자료 추가·수정 시 아래 규칙을 반드시 따른다.

---

## 탐색 방법 (질문 받으면 항상 이 순서)

1. `00 SEARCH_INDEX.md` 를 먼저 읽는다 — 키워드 → 파일 경로 직접 매핑
2. 매핑된 파일만 읽는다
3. grep/find 로 탐색하지 않는다

---

## 폴더명 규칙

**반드시 `English(한글)` 형식.**

| ❌ 금지 | ✅ 올바른 형식 |
|---|---|
| `보안` | `Security(보안)` |
| `비동기` | `Async(비동기)` |
| `데이터` | `Data(데이터)` |
| `통합` | `Integration(통합)` |
| `테스트` | `Testing(테스트)` |
| `트리거` | `Trigger(트리거)` |
| `컬렉션` | `Collections(컬렉션)` |
| `아키텍처` | `Architecture(아키텍처)` |
| `실행컨텍스트` | `ExecutionContext(실행컨텍스트)` |
| `로깅` | `Logging(로깅)` |
| `플랫폼이벤트` | `PlatformEvents(플랫폼이벤트)` |
| `플랫폼캐시` | `PlatformCache(플랫폼캐시)` |
| `Apex통합` | `ApexIntegration(Apex통합)` |
| `컴포넌트API` | `ComponentAPI(컴포넌트API)` |
| `이벤트` | `Events(이벤트)` |
| `네비게이션` | `Navigation(네비게이션)` |
| `UI패턴` | `UIPatterns(UI패턴)` |
| `모바일` | `Mobile(모바일)` |

순수 한글, 영어+한글 혼합 모두 금지. 새 폴더 생성 시 즉시 적용.

---

## 파일 구조 규칙

모든 `.md` 파일은 아래 구조를 따른다.

```markdown
---
tags: [카테고리, 키워드...]
source: 출처_파일명 또는 프로젝트명
created: YYYY-MM-DD
aliases: [영어키워드, 한국어키워드, ...]
---

# 제목

> 한 줄 요약

---

## 개념 설명 + 실제 동작 코드 예제

## 비교표 (선택 기준이 있을 때 — 언제 A vs B)

## 관련 노트
- [[연결된 파일명]]
```

코드 예제 없이 글만 있는 파일은 불완전하다.

---

## 새 파일 추가 시 필수 3단계

```
1. 파일 생성          — 위 구조 준수
2. SEARCH_INDEX 업데이트 — 키워드 행 추가 (영어 + 한국어 + 자연어 질문)
3. 해당 MOC 업데이트   — 섹션 MOC에 링크 추가
```

3단계를 모두 완료해야 추가 작업이 끝난 것으로 본다.

### SEARCH_INDEX 키워드 작성 원칙

한 행에 영어 API명 + 한국어 표현 + 자연어 질문을 모두 포함한다.

```
| deleteRecord, updateRecord, 레코드 삭제, 레코드 수정, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
```

---

## 섹션별 MOC 위치

| 섹션 | MOC 파일 |
|---|---|
| 전체 검색 인덱스 | `00 SEARCH_INDEX.md` |
| Apex | `Apex/Apex MOC.md` |
| LWC | `LWC/LWC MOC.md` |
| Flow | `Flow/Flow MOC.md` |
| Integration | `Integration(통합)/통합 MOC.md` |
| 작성 규칙 상세 | `_MOC/WIKI_RULES.md` |

---

## wiki 답변 원칙

- wiki 내용을 우선 사용한다. 외부 지식과 섞지 않는다.
- 코드 예제는 wiki 파일의 코드를 그대로 인용한다.
- wiki에 없는 내용은 "wiki에 없다"고 명시하고 추가 여부를 묻는다.
