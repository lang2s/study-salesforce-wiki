---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-05-23
---

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

| # | 항목 | 소스/사유 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P2-02 | `Release/Spring '26.md` (v66.0) 작성 | 로컬 PDF 미확보 (lint L-01과 동일 항목) | P2 | 🔲 대기 | 2026-05-18 |
| P3-05 | LWC BaseComponents 확장 (lightning-tree·tab·pill 등) | LWC Component Ref PDF 미확보 | P3 | 🔲 대기 | 2026-05-18 |

> **다음 후보(미등록):** N3 시리즈 — Experience Cloud · Reports API · Tooling API 등. 소스 PDF 확보 시 행으로 승격.

---

## 에이전트 프로토콜 개선 이력

> 커버리지 공백이 아닌 **에이전트 규칙 수정**(wiki-retrospective 모드 B)을 기록한다. (누적되어도 작으므로 활성 파일에 유지)

| # | 개선 | 수정 파일 | 상태 | 일자 |
|---|---|---|---|---|
| AP-01 | 단방향 링크 재발(콘텐츠 섬) 차단 — writer 자가 체크리스트에 형제 노트 역링크 규칙 추가(진짜 상호 관계만, specific→일반 허브는 단방향 유지), wiki-retrospective 모드 B 근본원인 표에 해당 행 추가 | `writer.md`, `wiki-retrospective.md` | ✅ 완료 | 2026-05-23 |
| AP-02 | fan-in 허브 휴리스틱이 nav 링크(index·MOC·00 Home·SEARCH_INDEX)로 오염돼 실패(진짜 허브도 nav 포함 시 raw 3~4, nav 제외 spoke fan-in은 2~3뿐이라 "≥5" 밴드가 오분류) → 이름/역할 1차 + nav 제외 spoke fan-in(≥2 형제) 2차로 정정, raw 단방향 총량 헤드라인 금지(실행마다 흔들려 비교 불가)·3분류 보고 규칙 추가. check #6 일관성 잠금(writer↔linter) 유지 | `wiki-linter.md` | ✅ 완료 | 2026-05-23 |

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
