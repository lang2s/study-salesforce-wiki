---
tags: [team-protocol, governance, squad, seam, handoff, raci]
source: forceNote-wiki 팀 운영 — TEAM_PROTOCOL.md 보강
created: 2026-05-24
aliases: [seam map, 핸드오프 계약, 책임 지도, RACI, squad boundary, 스쿼드 경계, seam contract]
---

# SEAM_MAP — 스쿼드 경계 + 핸드오프 계약 + 책임 지도

> 5개 스쿼드 + 조율층 사이의 **입력 계약 / 출력 DoD / 책임 RACI / 무주공산 처리**의 정본.
> [[TEAM_PROTOCOL]]의 스쿼드 구조 표와 함께 읽는다. 멤버십·파이프라인은 TEAM_PROTOCOL이, 경계·계약·책임은 이 파일이 정한다.

---

## 1. 스쿼드 경계 — 입력 계약 + 출력 DoD

각 스쿼드는 **받을 자격(입력 계약)**과 **넘길 자격(출력 DoD)**을 동시에 가진다. 둘 다 충족 못 한 핸드오프는 반려된다.

### 1.1 기획 스쿼드 (question-clarifier, planner)

| 항목 | 정의 |
|---|---|
| **입력 계약 (받을 자격)** | 사용자 요청 또는 PM 재투입 요청. 빈 메시지·"뭐든지" 같은 0-context는 거절 |
| **출력 DoD (넘길 자격)** | 명확한 task spec 1개 (목표·범위·우선순위 + 검증 기준) 또는 research plan (소스 후보·예상 깊이·분할 단위) |
| **경계** | 콘텐츠 추출·작성 ❌ (소스 스쿼드로 위임). 추측·임시 답변 ❌ |
| **게이트키퍼** | 소스 스쿼드가 받아서 "이 spec으로 소스 추출 가능?" 판단. 모호하면 반려 |

### 1.2 소스 스쿼드 (scout, researcher, source-coverage-checker)

| 항목 | 정의 |
|---|---|
| **입력 계약** | task spec 또는 research plan (목표 + 소스 후보) |
| **출력 DoD** | **전수 추출된** raw content dump (요약 ❌, "주요 메서드 3개"·"등" 형식 금지). 소스 페이지 인용 + tier 표시 + missed source 보고 |
| **경계** | 분류·작성·검증 ❌. 파일 직접 생성 ❌ |
| **게이트키퍼** | 작성 스쿼드가 "이 dump로 누락 없이 작성 가능?" 판단. 얕으면 반려 → 소스 스쿼드 재추출 |

### 1.3 작성 스쿼드 (classifier, writer)

| 항목 | 정의 |
|---|---|
| **입력 계약** | researcher dump + (optional) classifier blueprint (분류·구조·시리즈 위치) |
| **출력 DoD** | CLAUDE.md 4단계 모두 완료한 .md 파일: ①파일 본문 ②`_index/{샤드}.md` 키워드 행 (잠정) ③폴더 index.md 행 (잠정) ④관련 노트 wikilink. L1 lint 통과 |
| **경계** | 라우터·샤드의 최종 쓰기는 index-manager만 (writer는 잠정만, index-manager가 최종 정합·키워드 보강) |
| **게이트키퍼** | 검증 스쿼드가 "내용 완전·정확?" 판단. 얕으면 writer 재작업, 틀리면 source-verifier가 수정 의뢰 |

### 1.4 검증 스쿼드 (completeness-validator, source-verifier, qa)

| 항목 | 정의 |
|---|---|
| **입력 계약** | 작성 스쿼드의 .md 파일 + 원본 dump |
| **출력 DoD** | gap report (누락 클래스·메서드·셀) 또는 discrepancy report (API name·signature·값 불일치) + QA 최종 verdict (pass/fail) |
| **경계** | 직접 수정 ❌ — 작성 스쿼드에 fix 의뢰. 단, qa는 마지막에 단일 verdict만 |
| **게이트키퍼** | 탐색·정비 스쿼드가 "이 파일을 탐색망에 편입 가능?" 판단 |

### 1.5 탐색·정비 스쿼드 (index-manager, cross-linker, wiki-linter)

| 항목 | 정의 |
|---|---|
| **입력 계약** | 검증 통과한 .md 파일 |
| **출력 DoD** | 라우터·샤드·MOC·index.md 최종 정합 + 양방향 wikilink (형제 + 상위 카탈로그 포함, [[cross-linker]] 룰 참조) + lint 통과 |
| **경계** | 콘텐츠 본문 수정 ❌ — wikilink 삽입과 키워드 행 작성에만 한정 |
| **게이트키퍼** | 사용자 (또는 PM 보고) — 키워드로 도달 가능? 탐색 1회로 발견? |

### 1.6 조율층 (pm, wiki-retrospective)

| 멤버 | 역할 |
|---|---|
| **pm** | 런타임 라우팅 — 작업 분해·에이전트 호출 순서·skip 판단·결과 종합 보고. 무주공산 임시 소유 |
| **wiki-retrospective** | seam 순찰 — MODE A(작업 종료 직후 잡힌 누락) + MODE B(주기 회고로 전체 부채 점검). 이 SEAM_MAP의 RACI 업데이트 권한 보유 |

---

### 1.7 표준 핸드오프 메시지 형식

```
// 구조 예시 — 실제 동작 코드 아님 (에이전트 간 메시지 템플릿)
{
  "from": "scout",
  "to": "researcher",
  "task_id": "2GP-4f",
  "deliverable": {
    "source_map": [
      { "pdf": "pkg2_dev.pdf", "physical_pages": "89-90, 95-97", "doc_pages": "78-79, 84-86", "section": "Components Available — Security" }
    ],
    "tier": 2,
    "visual_warning": "p.95 다이어그램 1개 — pdftotext 추출 누락 가능, pdfimages 확인 요"
  },
  "gate_checklist": {
    "전수 추출 범위 명시": true,
    "tier 표시": true,
    "missed source 보고": "없음 (확인 완료)"
  }
}
```

받는 쪽(researcher)이 `gate_checklist` 모든 항목이 truthy인지 확인 → 하나라도 false면 보낸 쪽으로 반려.

---

## 2. 핸드오프 계약 — 게이트 매트릭스

| 보내는 쪽 → 받는 쪽 | 전달물 | 받는 쪽 게이트 (이걸 못 만족하면 반려) |
|---|---|---|
| 사용자 → 기획 | 요청 문장 | "목표·범위 1줄 추출 가능?" — 모호하면 question-clarifier |
| 기획 → 소스 | task spec / research plan | "소스 후보 명시? 깊이 기준 명시?" |
| 소스 → 작성 | content dump | "전수 추출 (요약 ❌)? 페이지 인용? tier 표시?" |
| 작성 → 검증 | .md 파일 + 잠정 인덱스 | "CLAUDE.md 4단계 시도? L1 lint 통과? 자체 깊이 점검?" |
| 검증 → 탐색·정비 | 검증 통과 .md + qa verdict | "qa pass? gap·discrepancy 0건?" |
| 탐색·정비 → 사용자 | 완성 보고 | "라우터→샤드→파일 도달 가능? 양방향 (형제 + 상위 카탈로그)?" |
| 회고 → 조율층 | 개선 권고 | "재발 방지 룰 1개 구체적으로 명시?" |

---

## 3. RACI — 반복 책임 지도

| 책임 | R(주담당) | A(승인) | C(자문) | I(통보) |
|---|---|---|---|---|
| 새 콘텐츠 추가 (표준 파이프라인) | writer | qa | researcher, classifier | index-manager |
| 기존 파일 보완 (빠른 파이프라인) | writer | qa | researcher | cross-linker |
| 키워드 샤드·라우터 쓰기 | index-manager | index-manager | (writer 잠정 행) | wiki-linter |
| 형제 노트 역링크 | cross-linker | qa | writer | wiki-linter |
| **상위 카탈로그 역링크 (허브·MetadataAPI·MOC)** | cross-linker | qa | writer | wiki-linter |
| L1 구조 lint (PostToolUse 훅) | lint-md-file.sh | writer | — | writer |
| L2 의미 lint (주기 /lint) | wiki-linter | pm | — | qa |
| 검증 실패 시 수정 (얕음) | writer | completeness-validator | researcher | qa |
| 검증 실패 시 수정 (틀림) | writer | source-verifier | scout | qa |
| **시리즈 분할 결정** | pm | 사용자 | classifier | writer |
| 회고 MODE A (작업 직후) | wiki-retrospective | pm | qa | (전 스쿼드) |
| 회고 MODE B (주기 — 10+ 작업 후) | wiki-retrospective | pm | — | (전 스쿼드) |
| 무주공산 발생 | pm (임시) | wiki-retrospective | — | (RACI 행 추가) |
| 에이전트 정의 (.md) 개선 | wiki-retrospective | pm | (해당 agent) | 전 squad |

> **무주공산 처리:** 위 표에 없는 책임이 발생하면 PM이 임시 소유 → 회고 MODE A에서 행 추가 + 배정. 배정 전까지 PM 책임.

---

## 4. 3겹 안전장치 — 동작 메커니즘

### 4.1 핸드오프 계약 (1겹)

**받는 쪽이 게이트키퍼.** 불완전 핸드오프는 거절 → 넘기는 쪽이 끝까지 책임. 위 §2 매트릭스가 모든 쌍의 게이트 정의.

예: source가 "주요 메서드 3개만"으로 dump를 넘기면 writer가 거절 → researcher 재투입. 작성 스쿼드가 책임지지 않는다.

### 4.2 책임 지도 RACI (2겹)

**지도에 없는 일 = 무주공산** → 회고가 행 추가하며 배정. 회고 MODE A 종료 시점에 "이번에 PM이 임시 소유한 건이 있었나?" 점검 → 있으면 §3에 RACI 행 추가.

예: 2026-05-24 — cross-linker가 "상위 카탈로그 역링크"를 시리즈 작업에서 잊는 경향 발견 → §3에 별도 행 추가 + cross-linker.md에 룰 보강. AP-04 회고 참조.

### 4.3 회고 seam 순찰 (3겹)

매 사이클 또는 주기 (10+ 작업 후) wiki-retrospective가 점검:
- **반려된 계약** — 어느 쌍에서? 왜? 게이트 강화 vs 보내는 쪽 protocol 보강
- **무주공산** — PM이 임시 소유한 건이 몇 건? RACI에 배정
- **2회 재발** — 같은 에이전트가 같은 실수 2회 → agent.md 보강 (강제)
- **그물 과부하** — 한 게이트가 너무 많은 반려 → 상류 protocol에 사전 검증 추가

---

## 5. 규칙 쌍 일관성 잠금 (rule-pair locks)

서로 다른 스쿼드가 소유한 규칙이 **같은 예외를 공유**하면, 한쪽만 바꿀 때 모순이 생긴다 — *한 스쿼드가 의도해서 만든 걸 다른 스쿼드가 결함으로 잡는다.* 아래 쌍은 **항상 함께** 바꾼다.

| 규칙 A (소유 스쿼드) | 규칙 B (소유 스쿼드) | 공유 예외 | 어기면 |
|---|---|---|---|
| writer 작성 시점 역링크 (작성) | wiki-linter 단방향 검사 #6 (탐색·정비) | spoke→hub 단방향은 정상 | linter가 writer 의도 단방향을 결함으로 재검출 → 가짜 경고 더미에 진짜 결함이 묻힘 |
| cross-linker 형제 역링크 (탐색·정비) | wiki-linter 양방향 검사 (탐색·정비) | **상위 카탈로그 페이지 역링크도 점검 대상** (2026-05-24 AP-04 추가) | 카탈로그에서 발견 불가능 → 부분 노출 |
| L1 lint 코드블록 룰 (작성·훅) | writer 새 파일 생성 (작성) | 거버넌스·MOC·README는 코드블록 면제 | governance 파일이 새로 생길 때마다 lint 차단 → exclusion 리스트 갱신 필요 |

> §4.3 회고 seam 순찰에 포함: 규칙을 추가·수정할 때 **"이 규칙과 짝을 이루는 검사가 다른 스쿼드에 있나?"** 를 확인하고, 있으면 같이 고친다.

---

## 6. 알려진 seam 사고 (씨앗 사례 — 이 지도가 막으려는 것)

| 사고 | 샜던 이유 | 지금 막는 행 |
|---|---|---|
| **단방향 링크 누적** | writer는 만들고 cross-linker만 사후 수거 → 작성 시점 무책임 | RACI "양방향 링크 보장" 주담당=작성 |
| **백로그 비대화** | ✅ 항목을 아무도 아카이브 안 함 | RACI "아카이브 이동" 주담당=회고 |
| **AP-04 cross-linker 허브 누락** (2026-05-24) | cross-linker가 형제만 챙기고 상위 카탈로그(MetadataAPI·Workflow MOC) 역링크 잊음 → 11건 누락 발견 | RACI에 "상위 카탈로그 역링크" 별도 행 + cross-linker.md 룰 보강 |
| **AP-04 escape backtick 1글자 오타** (2026-05-24) | index-manager가 `\``를 작성 → grep 경로 매칭 깨짐 → 고아 false positive | scripts/lint-md-file.sh에 escape backtick 감지 룰 추가 |
| **SEAM_MAP.md 2개 위치 중복** (2026-05-24) | `.claude/teams/SEAM_MAP.md` 기존 존재 미인지 → wiki root에 신규 작성. wikilink 스코프 차이로 발견 못 함 | 작성 전 `find -name {target}` 의무화 (PM·writer 공통) |

---

## 7. 변경 이력

| 날짜 | 변경 | 트리거 |
|---|---|---|
| 2026-05-18 | 5 스쿼드 + 조율층 도입, 3겹 안전장치 정의 | TEAM_PROTOCOL.md 최초 작성 |
| 2026-05-23 | seam 안전장치 3겹을 SEAM_MAP 한 문서로 통합 결정 (별도 헌장 파일 ❌, 중복·drift 방지) | TEAM_PROTOCOL.md 최초 정의 |
| 2026-05-24 | **SEAM_MAP.md 파일 생성** — TEAM_PROTOCOL의 4건 참조가 broken link였음. 위 정의를 통합 작성 | wiki-linter 2026-05-24 보고 |
| 2026-05-24 | RACI에 "상위 카탈로그 역링크" 행 추가 — cross-linker가 시리즈 작업에서 누락하는 경향 발견 | AP-04 회고 (2GP Components 8분할 작업) |

---

## 관련 노트

- [[TEAM_PROTOCOL]] — 스쿼드 멤버십 표, 파이프라인 정의
- [[WORK_BACKLOG]] — 활성 작업 추적, 무주공산 후보 발견 위치
- [[WORK_BACKLOG_ARCHIVE]] — 완료된 책임 이력
- [[RETROSPECTIVE_PDF_PIPELINE_2026-05-23]] — AP-04(cross-linker 허브 누락) 회고
