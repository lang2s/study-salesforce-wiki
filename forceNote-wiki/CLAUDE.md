# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

이 디렉토리는 **Salesforce 백과사전**이다. Apex·LWC·Flow에 국한하지 않고 Salesforce 개발자와 어드민이 알아야 할 모든 것 — Admin/Setup, Sales Cloud, Service Cloud, Experience Cloud, Data Cloud, Slack, Agentforce/Einstein, DevOps/CLI, Security, Architecture, Release Updates — 을 다룬다.
새 자료 추가·수정 시 아래 규칙을 반드시 따른다.

---

## 레포 구조 (4층 탐색 아키텍처)

```
Layer 0  00 Home.md              — 전체 진입점
Layer 1  00 SEARCH_INDEX.md      — 키워드 → 파일 경로 직접 매핑
         Apex/Apex MOC.md        — Apex 섹션 전체 목차
         LWC/LWC MOC.md          — LWC 섹션 전체 목차
         Flow/Flow MOC.md        — Flow 섹션 전체 목차
         Integration(통합)/통합 MOC.md
Layer 2  */index.md              — 각 subfolder 로컬 인덱스 (파일 목록 + 빠른 선택)
Layer 3  개별 패턴 노트 (.md)
```

섹션: `Apex/`, `LWC/`, `Flow/`, `Integration(통합)/`, `Release/`
유틸: `_templates/` (노트 템플릿), `_MOC/WIKI_RULES.md` (규칙 상세)

---

## 탐색 방법 (질문 받으면 항상 이 순서)

| 상황 | 읽는 파일 |
|---|---|
| 키워드로 찾을 때 | `00 SEARCH_INDEX.md` → 해당 파일 |
| 섹션 전체를 훑을 때 | Section MOC (`Apex/Apex MOC.md` 등) |
| 폴더 내에서 탐색할 때 | 해당 `subfolder/index.md` |

**규칙:**
1. 키워드가 있으면 → `00 SEARCH_INDEX.md` 먼저
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
```

---

### Step 1–4 — 파일 추가 4단계 (검증 통과 후 실행)

```
1. 파일 생성              — 위 구조 준수
2. SEARCH_INDEX 업데이트   — 키워드 행 추가 (영어 + 한국어 + 자연어 질문)
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

### SEARCH_INDEX 키워드 작성 원칙

한 행에 영어 API명 + 한국어 표현 + 자연어 질문을 모두 포함한다.

```
| deleteRecord, updateRecord, 레코드 삭제, 레코드 수정, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
```

---

## 탐색 파일 위치

### 글로벌 탐색 (Layer 0–1)

| 역할 | 파일 |
|---|---|
| 전체 진입점 | `00 Home.md` |
| 키워드 검색 | `00 SEARCH_INDEX.md` |
| Apex 섹션 | `Apex/Apex MOC.md` |
| LWC 섹션 | `LWC/LWC MOC.md` |
| Flow 섹션 | `Flow/Flow MOC.md` |
| Integration 섹션 | `Integration(통합)/통합 MOC.md` |
| 작성 규칙 상세 | `_MOC/WIKI_RULES.md` |

### 폴더 로컬 인덱스 (Layer 2)

| 폴더 | index.md |
|---|---|
| Apex/Architecture(아키텍처) | `Apex/Architecture(아키텍처)/index.md` |
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
| Flow | `Flow/index.md` |

---

## wiki 답변 원칙

- wiki 내용을 우선 사용한다. 외부 지식과 섞지 않는다.
- 코드 예제는 wiki 파일의 코드를 그대로 인용한다.
- wiki에 없는 내용은 "wiki에 없다"고 명시하고 추가 여부를 묻는다.
