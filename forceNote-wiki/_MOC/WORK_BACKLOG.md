---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-05-20
---

# WORK_BACKLOG — 커버리지 공백 추적 대장

> **coverage-analyst는 분석 시작 전 이 파일을 반드시 읽는다.**
> 이전 주기에서 P2/P3로 분류된 항목이 완료됐는지 확인하고, 미완료 항목은 보고서에 재포함시킨다.

---

## 커버리지 현황 (2026-05-20 기준)

| 소스 | 총 작성 대상 | 커버됨 | 미작성 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (71 네임스페이스) | 69개 (내부 전용 2개 제외) | 29개 | 40개 | 42.0% |

---

## 사용 방법

- 새 항목 추가: coverage-analyst 또는 agent-improver가 추가
- 상태 업데이트: 해당 작업을 완료한 에이전트 또는 PM이 업데이트
- 완료 항목 정리: 분기마다 (약 30개 누적 시) archive 섹션으로 이동

---

## 현재 백로그

### P1 — 즉시 작성 권장 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P1-04 | Flow | p.2880 | `Apex/Integration(통합)/Flow Namespace.md` | ✅ 완료(2026-05-19) | 2026-05-19 |
| P1-05 | TxnSecurity | p.4445 | `Apex/Security(보안)/TxnSecurity Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-06 | Support | p.3580 | `Apex/Integration(통합)/Support Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-07 | Context | p.2688 | `Architecture(아키텍처)/Context Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P1-08 | Datacloud | p.2741 | `Apex/Data(데이터)/Datacloud Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |

---

### P2 — 다음 사이클 (Apex Ref v67.0)

| # | 네임스페이스 | PDF 페이지 | 권장 파일 경로 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|---|
| P2-02 | `Release/Spring '26.md` (v66.0) | 로컬 PDF 미확보 | — | 🔲 대기 | 2026-05-18 | — |
| P2-05 | ApexPages | p.10 | `Architecture(아키텍처)/ApexPages Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-06 | AppLauncher | p.43 | `Architecture(아키텍처)/AppLauncher Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-07 | LxScheduler | p.2980 | `Apex/Integration(통합)/LxScheduler Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-08 | VisualEditor | p.4462 | `Architecture(아키텍처)/VisualEditor Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-09 | Wave | p.4476 | `Apex/Data(데이터)/Wave Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-10 | UserProvisioning | p.4454 | `Apex/Security(보안)/UserProvisioning Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-11 | TerritoryMgmt | p.4441 | `Apex/Integration(통합)/TerritoryMgmt Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-12 | Slack | p.3578 | `Apex/Integration(통합)/Slack Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |
| P2-13 | PlaceQuote | p.3208 | `Apex/Integration(통합)/PlaceQuote Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 | 2026-05-20 |

---

### P3 — 장기 계획 (Apex Ref v67.0 — 특수/Industries)

| # | 네임스페이스 | PDF 페이지 | 대상 | 상태 | 추가일 |
|---|---|---|---|---|---|
| P3-05 | LWC BaseComponents 확장 (lightning-tree, lightning-tab, lightning-pill 등) | LWC Component Ref (미확보) | LWC 개발자 | 🔲 대기 | 2026-05-18 |
| P3-06 | Canvas | p.279 | `Architecture(아키텍처)/Canvas Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-07 | ChatterAnswers | p.299 | `Apex/Integration(통합)/ChatterAnswers Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-08 | CommerceBuyGrp | p.301 | `Apex/Integration(통합)/CommerceBuyGrp Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-09 | CommerceExtension | p.307 | `Apex/Integration(통합)/CommerceExtension Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-10 | CommerceOrders | p.316 | `Apex/Integration(통합)/CommerceOrders Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-11 | CommercePayments | p.317 | `Apex/Integration(통합)/CommercePayments Namespace.md` | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-12 | CommerceTax | p.527 | Tax Integration ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-13 | ComplianceMgmt | p.646 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(PDF 클래스 인벤토리만 수록, FSC 가이드 참조 필요) | 2026-05-19 |
| P3-14 | embeddedai | p.2859 | Einstein 내장 개발자 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-15 | Functions | p.2905 | Salesforce Functions org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-16 | ise_bots_apex | p.2921 | Einstein Bot 고급 커스텀 | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-17 | IssueCreditMemo | p.2925 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-18 | InvoiceWriteOff | p.2966 | Revenue Cloud | ✅ 완료(2026-05-20) — 스텁(5개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-19 | IsvPartners | p.2966 | AppExchange ISV | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-20 | IndustriesDigitalLending | p.2928 | Financial Services Cloud | ✅ 완료(2026-05-20) — 스텁(5개 callable 클래스 인벤토리, industriesDigitalLending 공식 문서 참조) | 2026-05-19 |
| P3-21 | industriesNlpSvc | p.2926 | Industries AI | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-22 | Pref_center | p.3208 | Privacy Center org | ✅ 완료(2026-05-20) | 2026-05-19 |
| P3-23 | RichMessaging | p.3408 | Messaging for Web/In-App | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-24 | RevSignaling | p.3408 | Revenue Lifecycle Mgmt | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-25 | RevSalesTrxn | p.3408 | Revenue Cloud / CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-26 | RulesAppIn | p.3457 | Revenue Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-27 | runtime_industries_cpq | p.3458 | Industries CPQ | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-28 | runtime_industries_insurance | p.3458 | Insurance Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-29 | Sfc | p.3554 | Files 커스텀 처리 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-30 | Sfdc_Checkout | p.3558 | B2B Commerce 전문 | 🔲 대기 | 2026-05-19 |
| P3-31 | Sfdc_Enablement | p.3563 | Enablement 앱 | 🔲 대기 | 2026-05-19 |
| P3-32 | sfdc_surveys | p.3573 | Surveys 기능 | 🔲 대기 | 2026-05-19 |
| P3-33 | renew_assets_summary | p.3285 | Revenue Cloud | 🔲 대기 | 2026-05-19 |
| P3-34 | fsccashflow | p.2894 | Financial Services Cloud | 🔲 대기 | 2026-05-19 |
| P3-35 | ind_mfg_sample_mgmt_apex | p.2925 | Manufacturing Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Manufacturing Cloud 개발자 가이드 참조) | 2026-05-19 |

---

### 보완 필요 기존 파일

| # | 파일 | 부족한 부분 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| F-01 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` | Chatter만 있음. Communities/UserProfiles 미커버 | ✅ 완료 | 2026-05-18 | 2026-05-19 |
| F-02 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` | Apex Cursor(Summer '24 GA)와 비교 없음 | ✅ 완료 | 2026-05-18 | 2026-05-19 |

---

### V — 기존 파일 Apex Reference 검증 대기

> **규칙:** Apex Reference v67.0 PDF **하나만** 보면서 순서대로 검증. 다른 PDF 병행 금지.
> 검증 기준: 클래스 전체 포함 여부 / 메서드 시그니처 정확성 / 예제 코드 원문 수록 여부

| # | 파일 | Apex Ref PDF 페이지 | 상태 | 추가일 | 완료일 |
|---|---|---|---|---|---|
| V-01 | `Apex/Security(보안)/TxnSecurity Namespace.md` | p.4445~4453 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-02 | `Apex/Integration(통합)/Support Namespace.md` | p.3580~3583 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-03 | `Architecture(아키텍처)/Context Namespace.md` | p.2688 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-04 | `Apex/Data(데이터)/Datacloud Namespace.md` | p.2741~2760 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-05 | `Apex/Integration(통합)/Flow Namespace.md` | p.2880~2884 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-06 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | p.2885~2892 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-07 | `Architecture(아키텍처)/Site Namespace.md` | p.3576~3580 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-08 | `Apex/Integration(통합)/KbManagement Namespace.md` | p.2968~2979 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-09 | `Architecture(아키텍처)/System Namespace.md` | p.3584~4440 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-10 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | p.663~2687 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-11 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | p.2865~2879 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-12 | `Apex/Integration(통합)/DataWeave Namespace.md` | p.2841~2858 | ✅ 완료 | 2026-05-20 | 2026-05-20 |
| V-13 | `Apex/Integration(통합)/Compression Namespace.md` | p.646~662 | ✅ 완료 | 2026-05-20 | 2026-05-20 |

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
| P1-01 | `Apex/Integration(통합)/Compression Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.646 |
| P1-02 | `LWC/Testing(테스트)/` Jest 테스트 3종 | 2026-05-18 | Tier 3 (외부 지식) |
| P1-03 | `Apex/Integration(통합)/DataWeave Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2841 |
| P2-01 | `Release/Winter '25.md` (v62.0) | 2026-05-18 | Tier 3 (external-knowledge) |
| P2-03 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` | 2026-05-18 | Apex Ref v67.0 p.2865 |
| P2-04 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` | 2026-05-18 | Apex Ref v67.0 p.663 |
| P3-01 | `Architecture(아키텍처)/System Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3584 |
| P3-02 | `Apex/Integration(통합)/KbManagement Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2968 |
| P3-03 | `Architecture(아키텍처)/Site Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.3576 |
| P3-04 | `Apex/Testing(테스트)/Flowtesting Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2885 |
| F-01 | ConnectApi Communities/UserProfiles 보완 | 2026-05-19 | Apex Ref v67.0 p.1499, 1972 |
| F-02 | 비동기 컨텍스트 선택 — Apex Cursor 추가 | 2026-05-19 | Apex Ref v67.0 p.2692 |
| P1-04 | `Apex/Integration(통합)/Flow Namespace.md` | 2026-05-19 | Apex Ref v67.0 p.2880~2884 |
| P1-05 | `Apex/Security(보안)/TxnSecurity Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.4445~4453 |
| P1-06 | `Apex/Integration(통합)/Support Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.3580~3583 |
| P1-07 | `Architecture(아키텍처)/Context Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2688 (Industries Cloud 전용) |
| P1-08 | `Apex/Data(데이터)/Datacloud Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2741~2760 (Duplicate Management) |
| P2-05 | `Architecture(아키텍처)/ApexPages Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.10~42 (Visualforce 컨트롤러 8개 클래스) |
| P2-06 | `Architecture(아키텍처)/AppLauncher Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.43~47 (AppMenu 3개 메서드, 나머지 8개 internal only) |
| P2-07 | `Apex/Integration(통합)/LxScheduler Namespace.md` | 2026-05-20 | Apex Ref v67.0 p.2980~3022 (14개 클래스/인터페이스, Salesforce Scheduler 외부 캘린더 연동) |

---

## 관련 에이전트

- [[coverage-analyst]] — 이 백로그를 분석 시작 전에 읽음
- [[agent-improver]] — 이 백로그를 업데이트하고 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
