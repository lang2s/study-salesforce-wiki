---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
---

# WORK_BACKLOG — 커버리지 공백 추적 대장

> **coverage-analyst는 분석 시작 전 이 파일을 반드시 읽는다.**
> 이전 주기에서 P2/P3로 분류된 항목이 완료됐는지 확인하고, 미완료 항목은 보고서에 재포함시킨다.

---

## 사용 방법

- 새 항목 추가: coverage-analyst 또는 agent-improver가 추가
- 상태 업데이트: 해당 작업을 완료한 에이전트 또는 PM이 업데이트
- 완료 항목 정리: 분기마다 (약 30개 누적 시) archive 섹션으로 이동

---

## 현재 백로그

### P1 — 즉시 작성 권장

| # | 주제 | 소스 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| P1-01 | `Apex/Integration(통합)/Compression Namespace.md` | Apex Ref v67.0 p.646 | ✅ 완료 | 2026-05-18 | 2026-05-18 |
| P1-02 | `LWC/Testing(테스트)/` Jest 테스트 3종 (wire mock, DOM 이벤트, @salesforce/apex mock) | LWC Dev Guide (미확보, Tier 3) | ✅ 완료 | 2026-05-18 | 2026-05-18 |
| P1-03 | `Apex/Integration(통합)/DataWeave Namespace.md` | Apex Ref v67.0 p.2841 | ✅ 완료 | 2026-05-18 | 2026-05-18 |

---

### P2 — 다음 사이클

| # | 주제 | 소스 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| P2-01 | `Release/Winter '25.md` (v62.0) | 로컬 PDF 미확보 → Tier 3 (external-knowledge)로 작성 | ✅ 완료 | 2026-05-18 | 2026-05-18 |
| P2-02 | `Release/Spring '26.md` (v66.0) | 로컬 PDF 미확보 | 🔲 대기 | 2026-05-18 | — |
| P2-03 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` (namespace 개요) | Apex Ref v67.0 p.2865 | ✅ 완료 | 2026-05-18 | 2026-05-18 |
| P2-04 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | Apex Ref v67.0 p.663 | ✅ 완료 | 2026-05-18 | 2026-05-18 |

---

### P3 — 장기 계획

| # | 주제 | 소스 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| P3-01 | System Namespace 상세 레퍼런스 | Apex Ref v67.0 p.3584 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| P3-02 | KbManagement Namespace | Apex Ref v67.0 p.2968 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| P3-03 | Site Namespace | Apex Ref v67.0 p.3576 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| P3-04 | Flowtesting Namespace 개념 노트 | Apex Ref v67.0 p.2885 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| P3-05 | LWC BaseComponents 확장 (lightning-tree, lightning-tab, lightning-pill 등) | LWC Component Ref (미확보) | 🔲 대기 | 2026-05-18 | — |

---

### 보완 필요 기존 파일

| # | 파일 | 부족한 부분 | 상태 | 추가일 |
|---|---|---|---|---|
| F-01 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` | Chatter만 있음. Communities/UserProfiles/Files 미커버 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| F-02 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` | Apex Cursor(Summer '24 GA)와 비교 없음 | ✅ 완료 | 2026-05-18 | 2026-05-19 |

---

## 상태 범례

| 아이콘 | 의미 |
|---|---|
| 🔲 대기 | 아직 작업 시작 전 |
| 🟡 진행중 | 현재 작업 중 |
| ✅ 완료 | 작업 완료 + wiki 반영 확인 |
| ❌ 보류 | 소스 미확보 등의 이유로 보류 |

---

## 완료 아카이브

| # | 주제 | 완료일 | 비고 |
|---|---|---|---|
| — | 이전 완료 항목 없음 | — | — |

---

## 관련 에이전트

- [[coverage-analyst]] — 이 백로그를 분석 시작 전에 읽음
- [[agent-improver]] — 이 백로그를 업데이트하고 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
