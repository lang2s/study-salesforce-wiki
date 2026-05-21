# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 팀 시스템 (멀티에이전트)

이 wiki는 **팀 단위 에이전트 시스템**으로 운영된다. 비자명한 작업은 반드시 팀 파이프라인을 거친다.

- **팀 구성 및 워크플로우:** `TEAM_PROTOCOL.md` 참조
- **에이전트 정의 (15):** `.claude/agents/` 폴더 (pm, question-clarifier, planner, scout, source-coverage-checker, researcher, classifier, writer, completeness-validator, source-verifier, index-manager, cross-linker, wiki-linter, qa, wiki-retrospective)

### 팀 투입 기준

| 상황 | 처리 방식 |
|---|---|
| 요청이 모호함 | `question-clarifier` → `pm` |
| 새 네임스페이스/섹션 추가 | `pm` → 표준 파이프라인 (writer + source-coverage-checker 병렬) |
| 기존 파일 보완 | `pm` → 빠른 파이프라인 |
| `/lint` 또는 "wiki 점검해줘" | `wiki-linter` → `qa` |
| "뭐가 없어?" / 큰 그림 공백 파악 | `wiki-retrospective`(모드 B) → `pm` |
| 간단한 질문 답변 | 직접 답변 (팀 불필요) |

---

## 작업 전 환경 부트스트랩 (Mac / Windows)

이 위키는 Mac·Windows 양쪽에서 작업될 수 있다. **소스 추출·파일 생성 같은 콘텐츠 작업을 시작하기 전 항상 환경을 확인**한다. 경로는 절대경로 하드코딩이 아니라 레포 루트 기준 상대경로(`forceNote-wiki/`, `Salesforce Documents/`)와 PATH의 `pdftotext`를 쓴다.

```
1. forceNote-wiki/CLAUDE.local.md 존재 확인
   · 있으면  → 읽고 "0. 환경 감지" 실행 → 해당 env 파일(.claude/env/{windows|mac}.md) 확인
   · 없으면  → 아래 2번으로 자동 생성

2. 자동 생성 (CLAUDE.local.md 가 없을 때)
   a. 감지:  uname -s · pwd · command -v pdftotext · "Salesforce Documents"/forceNote-wiki 폴더 존재 확인
   b. forceNote-wiki/CLAUDE.local.md 생성 — 표준 구조(환경 감지 → env 라우팅, 상대경로 변수표, 프리플라이트 체크리스트)
   c. 감지된 OS에 맞는 forceNote-wiki/.claude/env/{windows|mac}.md 가 없으면 생성/갱신
      (uname 결과, 레포 루트 절대경로, pdftotext 위치, 확인한 폴더, 확인 날짜 기록)
   d. "환경 파일이 없어 자동 생성했습니다" 한 줄 보고 후 작업 진행

3. 감지 실패(레포 루트 아님 / pdftotext 없음 / 폴더 없음) → 작업 중단하고 사용자에게 보고
```

`CLAUDE.local.md`·`.claude/env/*.md`는 OS 비종속(상대경로)이라 커밋해도 무방하나, 없는 머신에서도 위 절차로 자연스럽게 재생성된다.

---

이 디렉토리는 **Salesforce 백과사전**이다. Apex·LWC·Flow에 국한하지 않고 Salesforce 개발자와 어드민이 알아야 할 모든 것 — Admin/Setup, Sales Cloud, Service Cloud, Experience Cloud, Data Cloud, Slack, Agentforce/Einstein, DevOps/CLI, Security, Architecture, Release Updates — 을 다룬다.
새 자료 추가·수정 시 아래 규칙을 반드시 따른다.

---

## 레포 구조 (5층 탐색 아키텍처)

```
Layer 0  00 Home.md              — 전체 진입점 (사람용 큐레이션)
Layer 1  00 SEARCH_INDEX.md      — 라우터 (도메인 → 샤드 매핑만, 개별 페이지 나열 안 함)
Layer 2  _index/{도메인}.md      — 키워드 → 파일 경로 샤드 (frontend/apex-core/apex-namespaces/platform/release/questions)
         Apex/Apex MOC.md        — Apex 섹션 전체 목차 (사람용 브라우즈)
         LWC/LWC MOC.md / Flow/Flow MOC.md / Integration(통합)/통합 MOC.md
Layer 3  */index.md              — 각 subfolder 로컬 인덱스 (파일 목록 + 빠른 선택)
Layer 4  개별 패턴 노트 (.md)
```

섹션: `Apex/`, `LWC/`, `Flow/`, `Integration(통합)/`, `Architecture(아키텍처)/`, `Release/`
유틸: `_index/` (키워드 샤드), `_templates/` (노트 템플릿), `_MOC/WIKI_RULES.md` (규칙 상세)

### 탐색 인덱스 구조 (장기 확장 규칙)

키워드 인덱스를 한 파일에 두면 페이지가 늘수록 파일이 커져 결국 1회 읽기 한도를 넘긴다(truncation → 누락). 그래서 **라우터 + 도메인 샤드** 트리로 운영한다. 검색 1회 = 라우터(작고 고정) + 샤드 1개(상한 있음) → 위키 크기와 무관하게 일정.

| 규칙 | 내용 |
|---|---|
| 라우터 불변 | `00 SEARCH_INDEX.md`는 **도메인→샤드만** 매핑. 개별 페이지를 나열하지 않으므로 크기가 페이지 수와 무관하게 일정. |
| 샤드 상한 | 각 `_index/*.md`는 **~300줄 / ~12k 토큰** 초과 금지. 초과 시 하위 샤드로 분할(`apex-namespaces-commerce.md` 등)하고 라우터에 1줄 추가. |
| 단일 쓰기 주체 | 라우터·샤드·MOC·index.md 등 모든 탐색 파일은 **index-manager만** 수정. |
| 1 페이지 = 1 홈 샤드 | 한 노트는 주 도메인 샤드 1곳에만 키워드 행을 둔다. 중복 행 금지. (폴더 배치가 애매하면 주 도메인 기준으로 결정) |

---

## 탐색 방법 (질문 받으면 항상 이 순서)

| 상황 | 읽는 파일 |
|---|---|
| 키워드로 찾을 때 | `00 SEARCH_INDEX.md`(라우터)에서 도메인→샤드 확인 → `_index/{샤드}.md` → 해당 파일 |
| 섹션 전체를 훑을 때 | Section MOC (`Apex/Apex MOC.md` 등) |
| 폴더 내에서 탐색할 때 | 해당 `subfolder/index.md` |

**규칙:**
1. 키워드가 있으면 → 라우터에서 도메인 판단 → **샤드 1개만** 읽는다 (전체 샤드를 다 읽지 않는다)
2. 섹션 개요가 필요하면 → Section MOC
3. 특정 폴더 내 파일 목록이 필요하면 → `폴더명/index.md`
4. grep/find 로 탐색하지 않는다

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

## 새 파일 추가 프로세스 — 검증 후 4단계

### Step 0 — 추가 전 검증 (파일 생성 전에 반드시 완료)

파일을 만들기 전, 아래 4가지 검증을 순서대로 수행한다. 하나라도 통과 못 하면 파일을 만들지 않고 사용자에게 보고한다.

#### 0-1. 출처 검증

| 출처 등급 | 조건 | 처리 |
|---|---|---|
| **Tier 1** (검증됨) | 로컬 소스 코드 직접 발췌 (`TrailheadApp/`, `Salesforce Documents/` 등) | 그대로 사용 |
| **Tier 2** (검증됨) | Salesforce 공식 문서 PDF, 공식 GitHub | 그대로 사용 |
| **Tier 3** (미검증) | 훈련 데이터 기반 외부 지식 | `source: external-knowledge` 명시 + 노트 상단에 `> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.` 추가 |

- `source:` frontmatter는 구체적인 파일명이나 문서명을 적는다. (`automation-components/src-data/SaveRecordsAsync.cls`, `Salesforce-Flow-Best-Practices-White-Paper-June-2025` 등)
- `source: 없음` 또는 `source: 일반 지식` 은 금지.

#### 0-2. 코드 검증

코드 예제를 작성하기 전, 원본과 대조한다.

| 코드 유형 | 검증 방법 |
|---|---|
| 로컬 소스 코드 발췌 | 해당 파일을 Read 도구로 열어 메서드명·파라미터·반환 타입이 실제와 일치하는지 확인 |
| 공식 문서 발췌 | PDF에서 인용한 코드 블록과 작성 내용 대조 |
| 직접 작성한 구조 예시 | 코드 블록 첫 줄에 `// 구조 예시 — 실제 동작 코드 아님` 주석 추가 |

- API명, 메서드명, 파라미터 순서, 반환 타입은 원본과 **정확히** 일치해야 한다.
- 확인 없이 기억에 의존해 작성한 코드는 Tier 3 취급.

#### 0-3. 위키링크 검증

`## 관련 노트`와 본문에 추가할 `[[wikilink]]` 목록을 먼저 작성한 뒤, 각 링크에 대해 Read 도구로 실제 파일이 존재하는지 확인한다.

```
확인 방법: Read("섹션/폴더/파일명.md") 시도
→ 파일 있음: 링크 추가 OK
→ 파일 없음: 링크 제거 또는 [[파일명]] (미작성) 으로 표시
```

존재하지 않는 파일로의 silent broken link 금지.

#### 0-4. 구조 체크리스트

파일 작성 완료 후 아래 항목을 순서대로 확인한다. 모두 통과해야 Step 1로 진행.

```
□ frontmatter: tags / source / created / aliases 모두 있음
□ source 가 Tier 1 또는 Tier 2 이거나, Tier 3이면 경고 표시 추가됨
□ > 한 줄 요약 있음
□ 코드 블록 최소 1개 있음 (구조 예시 주석 포함)
□ ## 관련 노트 섹션 있음
□ 모든 [[wikilink]] 가 실제 파일을 가리킴
□ 깊이: 클래스를 나열만 하지 않고 각 클래스의 메서드/프로퍼티/enum을 소스 대비 전수 작성 (아래 "내용 깊이 원칙" 참조)
□ 양방향 링크: 본문이 [[B]]를 링크하면 B 파일에도 이 파일로의 역링크가 있는지 (없으면 cross-linker에 위임)
```

#### 내용 깊이 원칙 (요약 방지)

소스를 **요약하지 않는다.** 큰 네임스페이스(Database, System 등)일수록 "주요 클래스만", "대표 메서드만" 추리는 함정에 빠지기 쉽다.

| ❌ 얕음 (금지) | ✅ 깊음 (목표) |
|---|---|
| 클래스 이름만 한 줄 나열 | 각 클래스마다 메서드 표 + 시그니처 + 설명 |
| "주요 메서드 3개" 발췌 | 소스에 있는 메서드 전수 |
| enum 값 일부 + "등" | 모든 enum 값 |
| "이하 동일/생략" | 생략 없이 작성 |

- 깊이의 천장은 researcher의 추출 깊이가 결정한다. researcher는 요약 추출 금지(전수 추출), completeness-validator는 개수가 아니라 **깊이(클래스별 충실도)** 까지 판정한다.
- 한 파일이 너무 커지면 분할을 고려하되, **분할 전에 내용을 줄이지 않는다.** 깊이 우선, 구조는 그다음.

---

### Step 1–4 — 파일 추가 4단계 (검증 통과 후 실행)

```
1. 파일 생성              — 위 구조 준수
2. 키워드 샤드 업데이트     — 주 도메인 `_index/{샤드}.md`에 키워드 행 추가 (영어 + 한국어 + 자연어 질문). 샤드가 상한 초과면 분할 + 라우터 1줄 추가
3. 섹션 MOC 업데이트       — 섹션 MOC에 링크 추가
4. 폴더 index.md 업데이트  — 해당 subfolder/index.md 파일 목록 행 추가
```

Step 0 검증 + 4단계를 모두 완료해야 추가 작업이 끝난 것으로 본다.

## 새 폴더 생성 시 필수 작업

```
1. 폴더명 규칙 준수     — English(한글) 형식
2. index.md 생성       — _templates/폴더 인덱스.md 템플릿 사용
3. 상위 MOC 업데이트    — 섹션 MOC에 새 폴더 섹션 추가
```

### 키워드 샤드 작성 원칙

한 행에 영어 API명 + 한국어 표현 + 자연어 질문을 모두 포함한다. 행은 그 페이지의 **주 도메인 샤드 한 곳**에만 둔다.

```
| deleteRecord, updateRecord, 레코드 삭제, 레코드 수정, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
```

---

## 탐색 파일 위치

### 글로벌 탐색 (Layer 0–2)

| 역할 | 파일 |
|---|---|
| 전체 진입점 | `00 Home.md` |
| 키워드 라우터 | `00 SEARCH_INDEX.md` (도메인 → 샤드) |
| 키워드 샤드 | `_index/frontend.md` · `_index/apex-core.md` · `_index/apex-namespaces.md` · `_index/platform.md` · `_index/release.md` · `_index/questions.md` |
| Apex 섹션 | `Apex/Apex MOC.md` |
| LWC 섹션 | `LWC/LWC MOC.md` |
| Flow 섹션 | `Flow/Flow MOC.md` |
| Integration 섹션 | `Integration(통합)/통합 MOC.md` |
| 작성 규칙 상세 | `_MOC/WIKI_RULES.md` |

### 폴더 로컬 인덱스 (Layer 3)

| 폴더 | index.md |
|---|---|
| Architecture(아키텍처) | `Architecture(아키텍처)/index.md` |
| Apex/Async(비동기) | `Apex/Async(비동기)/index.md` |
| Apex/Collections(컬렉션) | `Apex/Collections(컬렉션)/index.md` |
| Apex/Data(데이터) | `Apex/Data(데이터)/index.md` |
| Apex/ExecutionContext(실행컨텍스트) | `Apex/ExecutionContext(실행컨텍스트)/index.md` |
| Apex/Integration(통합) | `Apex/Integration(통합)/index.md` |
| Apex/Logging(로깅) | `Apex/Logging(로깅)/index.md` |
| Apex/PlatformCache(플랫폼캐시) | `Apex/PlatformCache(플랫폼캐시)/index.md` |
| Apex/PlatformEvents(플랫폼이벤트) | `Apex/PlatformEvents(플랫폼이벤트)/index.md` |
| Apex/Messaging(메시징) | `Apex/Messaging(메시징)/index.md` |
| Apex/Security(보안) | `Apex/Security(보안)/index.md` |
| Apex/Testing(테스트) | `Apex/Testing(테스트)/index.md` |
| Apex/Trigger(트리거) | `Apex/Trigger(트리거)/index.md` |
| LWC/ApexIntegration(Apex통합) | `LWC/ApexIntegration(Apex통합)/index.md` |
| LWC/ComponentAPI(컴포넌트API) | `LWC/ComponentAPI(컴포넌트API)/index.md` |
| LWC/Events(이벤트) | `LWC/Events(이벤트)/index.md` |
| LWC/LDS | `LWC/LDS/index.md` |
| LWC/Mobile(모바일) | `LWC/Mobile(모바일)/index.md` |
| LWC/Navigation(네비게이션) | `LWC/Navigation(네비게이션)/index.md` |
| LWC/Security(보안) | `LWC/Security(보안)/index.md` |
| LWC/Testing(테스트) | `LWC/Testing(테스트)/index.md` |
| LWC/UIPatterns(UI패턴) | `LWC/UIPatterns(UI패턴)/index.md` |
| LWC/BaseComponents(베이스컴포넌트) | `LWC/BaseComponents(베이스컴포넌트)/index.md` |
| LWC/Internals(내부구조) | `LWC/Internals(내부구조)/index.md` |
| Flow | `Flow/index.md` |

---

## wiki 답변 원칙

- wiki 내용을 우선 사용한다. 외부 지식과 섞지 않는다.
- 코드 예제는 wiki 파일의 코드를 그대로 인용한다.
- wiki에 없는 내용은 "wiki에 없다"고 명시하고 추가 여부를 묻는다.

---

## wiki Lint — 건강 검사 (주기적 실행)

사용자가 "wiki 점검해줘" 또는 "/lint" 라고 하면 아래 항목을 순서대로 검사하고 보고한다.

```
1. 깨진 wikilink 탐지   — [[파일명]] 이 실제로 존재하는 파일을 가리키는지 확인
2. 단방향 링크 탐지     — A→[[B]] 인데 B→[[A]] 가 없는 쌍 (콘텐츠 섬). 의미상 상호 관련이면 양방향으로 보완
3. 고아 파일 탐지       — 어느 `_index/*.md` 샤드에도 등록되지 않은 .md 파일
4. 오래된 경로 참조     — 샤드/라우터/CLAUDE.md 내 이동·삭제된 파일 경로
5. MOC 누락 항목       — 파일이 존재하지만 상위 MOC나 index.md에 링크가 없는 경우
6. 샤드 건강           — 각 `_index/*.md` 가 ~300줄/~12k토큰 상한 이내인지 + 라우터↔샤드 정합성(라우터의 모든 샤드가 실재, 모든 샤드가 라우터에 등재)
7. 개선 제안           — 자주 참조되지만 페이지가 없는 개념, 채울 수 있는 데이터 공백
```

보고 형식: 항목별 `✅ 정상` / `⚠️ 경고` / `❌ 문제` 표로 출력. 문제가 있으면 수정 여부를 묻는다.

---

## 탐색·분석 결과 보존

질문에 대한 답변, 비교 분석, 의사결정 기록이 가치 있다고 판단되면 wiki 파일로 보존한다.

- 대화 중에 생성된 비교표, 설계 결정, 심층 분석은 chat에 두지 않고 적절한 폴더에 `.md` 파일로 저장한다.
- 파일명 예: `Apex/Architecture(아키텍처)/비동기 방식 비교.md`, `Flow/Screen Flow vs LWC 비교.md`
- 저장 전 Step 0 검증(출처·코드·링크·구조)을 동일하게 적용한다.
- 단순 질의응답은 저장하지 않는다. "이 분석이 나중에도 참조할 가치가 있는가"를 기준으로 판단한다.
