---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-05-24
---

> **세션 인계 메모 (2026-05-25 세션 종료 시점):**
> 2GP-12(AppExchange App Analytics, pkg2_dev.pdf p.428-504) 완료 — 4분할(Part1 Overview&Setup·Part2 Best Practices&Query·Part3 Data Types&Schemas·Part4 Developer Cookbook). 전체 스키마 필드 전수(Package Usage Logs ~65개·Summaries 13개·Subscriber Snapshots 12개), log_record_type 20종, SAQL 6개, CRM Analytics 레시피 2개. 역링크 5건·platform.md(4행)·index.md 업데이트. 다음 세션은 **2GP-13**(1GP vs 2GP Feature Gaps, p.505-517)부터 시작.

# WORK_BACKLOG — 활성 작업 추적

> **wiki-retrospective(모드 B)는 분석 시작 전 이 파일을 반드시 읽는다.**
> 이 파일에는 **열린 항목(🔲/🟡)·lint 이력·프로토콜 개선만** 둔다. 완료된(✅) 작업은 즉시 [[WORK_BACKLOG_ARCHIVE]]로 이동한다 → 파일이 무한정 길어지지 않게 유지.

---

## 커버리지 현황 (2026-05-22 재산출 ✅)

| 소스 | 공개 대상 | 커버됨 | 누락 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (~70 네임스페이스) | 68개 (내부 전용 2개 제외) | 68개 | 0개 | **~100%** |
| sObject Reference v67.0 (object_reference.pdf) | Ch1~Ch6 | 31개 서브페이지 | 0개 | **완료** |
| Salesforce DX Guide v67.0 (sfdx_dev.pdf) | 16개 챕터 | 16개 챕터 | 0개 | **완료** |

> 완료 상세(네임스페이스별·챕터별 행, 소스 페이지, 완료일)는 [[WORK_BACKLOG_ARCHIVE]] 참조.

---

## 사용 방법

- 새 항목 추가: wiki-retrospective(모드 B)가 추가 — **🔲/🟡 열린 항목만**
- 완료 시: 상태를 ✅로 표시한 뒤 **즉시 [[WORK_BACKLOG_ARCHIVE]]로 이동** (이 파일에 ✅ 누적 금지)
- lint 실행: 아래 "Lint 실행 이력"에 **실행 1회당 1행** 추가 (발견 세부는 행 안에 압축, 미해결분만 "열린 항목"으로 승격)

---

## 열린 항목 (🔲 대기 / 🟡 진행중)

### 🔴 P0 — 즉시 (다음 작업 진행을 위해 필요)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-2 | `writer.md` frontmatter에 `Bash` 도구 추가 | 강화된 Pattern A의 "메이저 섹션 직전 sed 재추출"을 writer가 직접 실행할 수 있게 함. 현재 writer는 Read/Write/Edit만 가능 → researcher dump의 raw 인용에 강제 의존. | 🔲 대기 | 2026-05-23 |
| 2GP-3 | `2GP Managed Package — Workflow.md` 작성 (pkg2_dev.pdf p.23-25) | 강화된 protocol(6 카테고리 spot check + Pattern B-2 산문형 numeric mapping)의 소형 페이지 validation 기회. | 🔲 대기 | 2026-05-23 |

### 🟡 P1 — Task #4(대형 카탈로그) 전 필요

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| DEC-1 | ~~Components Available 카탈로그(288쪽) 분할 전략 결정~~ | **✅ 결정 완료 (2026-05-23)**: 도메인 8분할 — MetadataAPI/Metadata Types 구조 미러. 파일명: `2GP — Components: Apex & Code.md` 등 8개. MetadataAPI는 API 구조, 2GP Components는 패키징 동작(Manageability+Editable Properties) 역할 분업. | ✅ 완료 | 2026-05-23 |
| PIPE-3 | researcher dump 정책 — large PDF 시 raw inline vs file reference | 강화 protocol이 "raw sed 출력을 dump에 포함" 의무인데 큰 PDF에서 LLM context 한계 초과 위험. file reference 방식 보완 필요. | 🔲 대기 | 2026-05-23 |
| PIPE-4 | scout ↔ researcher handoff contract 명시 | 두 agent 모두 강화됐지만 "시각 자료 경고" 정확한 출력 형식과 researcher의 ⚠️ 표시 형식 사이 인터페이스 계약이 별도 문서로 정리 안 됨. | 🔲 대기 | 2026-05-23 |
| PIPE-5 | classifier `D-3 depth balance` 한계 명시 | classifier는 콘텐츠 미작성 단계라 섹션 분량 예측 정확도가 낮음. protocol에 "writer 사후 점검과 함께 운영"이라는 안내 필요. | 🔲 대기 | 2026-05-23 |

### 🟢 P2 — 2GP 시리즈 연속 작업 (Task #3 통과 후 본격 진행)

| # | 항목 | 소스 | 상태 | 추가일 |
|---|---|---|---|---|
| 2GP-4 | `2GP — Components: Apex & Code.md` (도메인 8분할 중 1번째) | pkg2_dev.pdf p.25-313 전체에서 Apex Class·Trigger·Sharing Reason 등 추출 | 🔲 대기 | 2026-05-23 |
| 2GP-4b | `2GP — Components: Automation.md` (Flow/Process/Workflow) | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4c | `2GP — Components: Einstein & Analytics.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4d | `2GP — Components: Integration & Platform.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4e | `2GP — Components: Objects & Fields.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4f | `2GP — Components: Security & Access.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4g | `2GP — Components: UI & Layout.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-4h | `2GP — Components: Other.md` | pkg2_dev.pdf p.25-313 | 🔲 대기 | 2026-05-23 |
| 2GP-5 | `2GP — Specific Metadata Behavior` (Apex/Protected/Permission Sets/Profile) | pkg2_dev.pdf p.314-333 | ✅ 완료 | 2026-05-23 |
| 2GP-6 | `2GP — Develop (Apex·버전 생성)` | pkg2_dev.pdf p.334-347 | ✅ 완료 | 2026-05-23 |
| 2GP-7 | `2GP — Install · Uninstall` | pkg2_dev.pdf p.348-359 | ✅ 완료 | 2026-05-23 |
| 2GP-8 | `2GP — Prepare to Distribute` | pkg2_dev.pdf p.360-363 | ✅ 완료 | 2026-05-23 |
| 2GP-9 | `2GP — Push Upgrade` | pkg2_dev.pdf p.364-373 | ✅ 완료 | 2026-05-23 |
| 2GP-10 | `2GP — Advanced Features` | pkg2_dev.pdf p.374-406 | ✅ 완료 | 2026-05-23 |
| 2GP-11 | `2GP — Best Practices + License Management + Feature Management` | pkg2_dev.pdf p.407-427 | ✅ 완료 | 2026-05-23 |
| 2GP-12 | `2GP — AppExchange App Analytics` (~76쪽 — 분할 검토) | pkg2_dev.pdf p.428-504 | ✅ 완료 | 2026-05-23 |
| 2GP-13 | `2GP — 1GP vs 2GP Feature Gaps` | pkg2_dev.pdf p.505-517 | 🔲 대기 | 2026-05-23 |

### 🔵 P3 — 중기 (다른 작업 사이에 의식적 실험)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-1 | 강화된 pipeline agent 실제 invocation 1회 시도 | 6개 agent 정의가 모두 강화됐으나 Task #1·#2 모두 manual 작성 → 실제 PM 호출로 파이프라인 작동 데이터 1회 확보. PIPE-3·4·5의 가설 검증. | 🔲 대기 | 2026-05-23 |
| DEC-2 | 위키 이미지 첨부 정책 결정 | pdftotext가 못 잡는 다이어그램을 정말 보존해야 할 페이지가 있다면 PDF figure 캡처 첨부 정책 필요. 현재 없음 → 모든 시각 자료는 "마커 + skip" 또는 "텍스트 재현" 만. | 🔲 대기 | 2026-05-23 |
| 기존 P2-02 | `Release/Spring '26.md` (v66.0) 작성 | 로컬 PDF 미확보 (lint L-01과 동일 항목) | 🔲 대기 | 2026-05-18 |
| 기존 P3-05 | LWC BaseComponents 확장 (lightning-tree·tab·pill 등) | LWC Component Ref PDF 미확보 | 🔲 대기 | 2026-05-18 |

### ⚪ P4 — 장기 (큰 인프라 결정)

| # | 항목 | 소스/사유 | 상태 | 추가일 |
|---|---|---|---|---|
| PIPE-6 | Phase 2 — LLM-level source-verifier 자동 invocation 도입 | L1 훅은 구조만 검사 → 의미 오류(Snapshot 할당량 같은 numeric error)는 사용자 평가로만 발견. settings.json에 SubagentStop 훅으로 source-verifier 자동 호출 검토. ROI 시뮬레이션 필요. | 🔲 대기 | 2026-05-23 |

> **다음 후보(미등록):** N3 시리즈 — Experience Cloud · Reports API · Tooling API 등. 소스 PDF 확보 시 행으로 승격.

---

## 에이전트 프로토콜 개선 이력

> 커버리지 공백이 아닌 **에이전트 규칙 수정**(wiki-retrospective 모드 B)을 기록한다. (누적되어도 작으므로 활성 파일에 유지)

| # | 개선 | 수정 파일 | 상태 | 일자 |
|---|---|---|---|---|
| AP-01 | 단방향 링크 재발(콘텐츠 섬) 차단 — writer 자가 체크리스트에 형제 노트 역링크 규칙 추가(진짜 상호 관계만, specific→일반 허브는 단방향 유지), wiki-retrospective 모드 B 근본원인 표에 해당 행 추가 | `writer.md`, `wiki-retrospective.md` | ✅ 완료 | 2026-05-23 |
| AP-02 | fan-in 허브 휴리스틱이 nav 링크(index·MOC·00 Home·SEARCH_INDEX)로 오염돼 실패(진짜 허브도 nav 포함 시 raw 3~4, nav 제외 spoke fan-in은 2~3뿐이라 "≥5" 밴드가 오분류) → 이름/역할 1차 + nav 제외 spoke fan-in(≥2 형제) 2차로 정정, raw 단방향 총량 헤드라인 금지(실행마다 흔들려 비교 불가)·3분류 보고 규칙 추가. check #6 일관성 잠금(writer↔linter) 유지 | `wiki-linter.md` | ✅ 완료 | 2026-05-23 |
| AP-03 | PDF 기반 작성 4 패턴(A·B·C·D) protocol 도입 — Pattern A(섹션별 재추출 + 6 카테고리 spot check), B(격자형 매트릭스 + 산문형 numeric mapping), C(pdftotext 시각자료 blind spot 대응), D(structure rigidity 회피) — 6개 agent에 역할별 protocol 분배. 1차(Task #1 발견)+2차 진화(Task #2 Snapshot 할당량 오류로 spot check를 무작위→6 카테고리, Pattern B를 산문형까지 확장) 적용. | `writer.md`, `scout.md`, `researcher.md`, `classifier.md`, `source-verifier.md`, `completeness-validator.md`, `CLAUDE.md` 0-2 표 | ✅ 완료 | 2026-05-23 |
| AP-04 | L1 wiki lint 훅 도입 — `.claude/settings.json` PostToolUse 훅이 `scripts/lint-md-file.sh` 호출, `.md` 파일 Write/Edit 시 자동 검증(frontmatter·요약·코드블록·관련 노트·source값·깨진 wikilink). 순수 bash(Mac/Win 공통). 의미 오류는 못 잡고 구조만 검사 — Phase 2(LLM source-verifier 자동 호출)는 PIPE-6 백로그. | `.claude/settings.json`, `scripts/lint-md-file.sh` | ✅ 완료 | 2026-05-23 |

---

## Lint 실행 이력

> `/lint` 실행 1회당 1행. 발견 세부는 행 안에 압축한다. 미해결 항목만 위 "열린 항목"으로 승격하고, 신규 작성이 필요한 깨진 링크 상세는 [[WORK_BACKLOG_ARCHIVE]]의 L·I 섹션에 보존.

| 일자 | 발견 | 수정/조치 | 남은 open |
|---|---|---|---|
| 2026-05-21 | 깨진 wikilink 15건 · 깨진 샤드 경로 8건 | 즉시 6건 수정 + 2건 재연결, 신규 작성 필요분은 아카이브 L·I 섹션으로 분류 | Spring '26 |
| 2026-05-23 | 깨진 링크 2건(SLDS 슬래시·Metadata 경로 prefix) · MOC 누락 5건 · 단방향 링크 317건 | 8건 수정(SLDS×2·경로×1·Apex MOC 신규 5) · 단방향 분석→신규 클러스터 18 역링크 추가, hub-spoke 다수는 의도적 단방향 보존 · 근본원인 프로토콜화(→AP-01) | Spring '26 |
| 2026-05-23 (3차) | ❌ genuine peer 36→0 확인(cross-linker 16건 역링크 후) · 잔여 단방향 17건은 전부 의도적(spoke→hub + 약한 관계, 휴리스틱-판단 일치) · fan-in 허브 휴리스틱 결함 발견(nav 링크 오염으로 진짜 허브 오분류) | ❌ 0 도달 확인 · fan-in 휴리스틱 정정(이름/역할 1차 + nav 제외 spoke fan-in 2차, raw 총량 헤드라인 금지·3분류 보고)→AP-02 | Spring '26 |

---

## 상태 범례

| 아이콘 | 의미 |
|---|---|
| 🔲 대기 | 아직 작업 시작 전 |
| 🟡 진행중 | 현재 작업 중 |
| ✅ 완료 | 작업 완료 + wiki 반영 확인 → [[WORK_BACKLOG_ARCHIVE]]로 이동 |
| ❌ 보류 | 소스 미확보 등의 이유로 보류 |

---

## 관련 파일·에이전트

- [[WORK_BACKLOG_ARCHIVE]] — 완료 항목 영속 대장 (append-only, 통독용 아님)
- [[wiki-retrospective]] — 모드 B에서 이 백로그를 읽고 업데이트하며 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
