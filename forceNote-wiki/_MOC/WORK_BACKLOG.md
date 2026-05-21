---
tags: [backlog, coverage, work-tracking]
created: 2026-05-18
updated: 2026-05-22
---

# WORK_BACKLOG — 커버리지 공백 추적 대장

> **wiki-retrospective(모드 B)는 분석 시작 전 이 파일을 반드시 읽는다.**
> 이전 주기에서 P2/P3로 분류된 항목이 완료됐는지 확인하고, 미완료 항목은 보고서에 재포함시킨다.

---

## 커버리지 현황 (2026-05-22 재산출 ✅)

| 소스 | 공개 대상 | 커버됨 | 작성 대상 누락 | 커버리지 |
|---|---|---|---|---|
| Apex Reference v67.0 (~70 네임스페이스) | 68개 (내부 전용 2개 제외) | 63개 | 6개 | **~93%** |

> ⚠️ 이전 수치("29개 / 42%")는 낡았음. 2026-05-22 PDF↔위키 재대조 결과 핵심 네임스페이스(System·Database·Schema·Auth·ConnectApi 등) 전부 커버. 누락은 니치 산업/커머스 6개뿐. 상세는 아래 "C — 커버리지 재산출".

---

## 사용 방법

- 새 항목 추가: wiki-retrospective(모드 B)가 추가
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
| P3-30 | Sfdc_Checkout | p.3558 | B2B Commerce 전문 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-31 | Sfdc_Enablement | p.3563 | Enablement 앱 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-32 | sfdc_surveys | p.3573 | Surveys 기능 | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-33 | renew_assets_summary | p.3285 | Revenue Cloud | ✅ 완료(2026-05-21) — 스텁(2개 클래스 인벤토리, Revenue Cloud 개발자 가이드 참조) | 2026-05-19 |
| P3-34 | fsccashflow | p.2894 | Financial Services Cloud | ✅ 완료(2026-05-21) | 2026-05-19 |
| P3-35 | ind_mfg_sample_mgmt_apex | p.2925 | Manufacturing Cloud | ✅ 완료(2026-05-20) — 스텁(3개 클래스 인벤토리, Manufacturing Cloud 개발자 가이드 참조) | 2026-05-19 |

---

### 신규 소스 PDF — 즉시 작성 권장

> **배경:** 2026-05-21 `Salesforce Documents/` 신규 PDF 13개 발견. Apex Reference 외 첫 대규모 소스 확장.

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N1-01 | SOQL/SOSL 기초 문법 (SELECT, WHERE, 관계 쿼리, 집계 함수, SOSL 구문 전체) | `salesforce_soql_sosl.pdf` (v67.0 Summer '26) | `Apex/Data(데이터)/SOQL 문법 레퍼런스.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N1-02 | Governor Limits 빠른 참조 (SOQL 한도, DML 한도, Heap, CPU, Callout, API 한도 전체) | `salesforce_app_limits_cheatsheet.pdf` (Summer '26) | `Architecture(아키텍처)/Governor Limits 빠른 참조.md` | ✅ 완료(2026-05-21) | 2026-05-21 |

---

### 신규 소스 PDF — 다음 사이클

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N2-01 | Change Data Capture — 변경 이벤트 구독·처리·갭 이벤트 | `salesforce_change_data_capture.pdf` (v66.0 Spring '26) | `Apex/PlatformEvents(플랫폼이벤트)/Change Data Capture.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-02 | Validation Rules 예제 모음 (Account, Contact, Opportunity 등 주요 객체) | `salesforce_useful_validation_formulas.pdf` (Spring '26) | `Architecture(아키텍처)/Validation Rules 예제.md` | ✅ 완료(2026-05-21) | 2026-05-21 |
| N2-03 | UI API 개요 (getRecord, getFieldValue, wire 어댑터 전체 목록 + LWC 통합) | `api_ui.pdf` (v67.0 Summer '26) | `LWC/LDS/UI API 개요.md` | ✅ 완료(2026-05-22) | 2026-05-21 |

---

### 신규 소스 PDF — 장기 계획

| # | 주제 | 소스 PDF | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| N3-01 | Experience Cloud 개발자 가이드 개요 (Guest 사용자, Apex 가시성, Communities) | `communities_dev.pdf` (v66.0 Spring '26) | `Architecture(아키텍처)/Experience Cloud 개발자 가이드.md` | 🔲 대기 | 2026-05-21 |
| N3-02 | Reports & Dashboards REST API 개요 (보고서 실행, 필터, 대시보드 갱신) | `salesforce_analytics_rest_api.pdf` (v67.0 Summer '26) | `Integration(통합)/Reports Dashboards REST API.md` | 🔲 대기 | 2026-05-21 |
| N3-03 | Lightning Aura Components 개요 (레거시 호환 참조 — 이벤트, 버스, 컴포넌트 구조) | `lightningAura.pdf` (v67.0 Summer '26) | `LWC/Aura/Lightning Aura 개요.md` | 🔲 대기 | 2026-05-21 |
| N3-04 | Tooling API 개요 (메타데이터 쿼리, 디버그 로그 생성, ApexClass 배포) | `api_tooling.pdf` (v67.0 Summer '26) | `Architecture(아키텍처)/Tooling API 개요.md` | 🔲 대기 | 2026-05-21 |
| N3-05 | Mobile & Offline 개발 가이드 개요 (오프라인 브리프케이스, GraphQL, priming) | `mobile_offline.pdf` (v67.0 Summer '26) | `LWC/Mobile(모바일)/Offline 개발 가이드.md` | 🔲 대기 | 2026-05-21 |
| N3-06 | LWC in CRM Analytics Dashboards (wave 어댑터, 필터 컨텍스트, 대시보드 삽입) | `bi_dev_guide_lwc_in_db.pdf` (Summer '26) | `LWC/LWC in CRM Analytics.md` | 🔲 대기 | 2026-05-21 |
| N3-07 | Enterprise Sales Management 개요 (Sales Program, Milestone, Engagement) | `esm_developer_guide.pdf` (v66.0 Spring '26) | `Architecture(아키텍처)/Enterprise Sales Management.md` | 🔲 대기 | 2026-05-21 |

---

### L — 깨진 wikilink — 신규 파일 필요 (wiki-linter 2026-05-21)

> 2026-05-21 `/lint` 결과. 6개 링크는 즉시 수정 완료. 아래 9개는 대상 파일 없어 신규 작성 필요.
> `[[Spring '26]]`은 P2-02와 동일 항목.

| # | 깨진 링크 | 참조 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| L-01 | `[[Spring '26]]` | Release MOC, Summer '26 | `Release/Spring '26.md` | P2 (→ P2-02 중복) | 🔲 대기 | 2026-05-21 |
| L-02 | `[[LWC API 버전 관리]]` | `Release/Winter '24.md` | `LWC/ComponentAPI(컴포넌트API)/LWC API 버전 관리.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-03 | `[[Custom Metadata Types]]` | `Release/Winter '24.md` 외 | `Architecture(아키텍처)/Custom Metadata Types.md` | P2 | ✅ 완료(2026-05-22) | 2026-05-21 |
| L-04 | `[[lightning-tabset]]` | LWC BaseComponents index | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` | P3 (→ P3-05 연관) | 🔲 대기 | 2026-05-21 |
| L-05 | `[[DevOps Center]]` | Release 노트 | `Architecture(아키텍처)/DevOps Center.md` | P3 | 🔲 대기 | 2026-05-21 |
| L-06 | `[[Enhanced Domains]]` | Release 노트 | `Architecture(아키텍처)/Enhanced Domains.md` | P3 | 🔲 대기 | 2026-05-21 |
| L-07 | `[[External Services]]` | `Release/Winter '26.md` | `Integration(통합)/External Services.md` | P3 | 🔲 대기 | 2026-05-21 |
| L-08 | `[[Platform Encryption]]` | Release 노트 | `Apex/Security(보안)/Platform Encryption.md` | P3 | 🔲 대기 | 2026-05-21 |
| L-09 | `[[SLDS / LWC 디자인 시스템]]` | LWC 관련 노트 | `LWC/UIPatterns(UI패턴)/SLDS LWC 디자인 시스템.md` | P3 | 🔲 대기 | 2026-05-21 |

---

### I — 깨진 인덱스 경로 — 샤드 등재됐으나 파일 없음 (lint 2026-05-21)

> 2026-05-21 `/lint` 결과. 키워드 샤드가 존재하지 않는 파일을 가리키던 8건.
> 2건은 실존 유사 파일로 **재연결 완료**(백로그 불필요): `Governor Limits 빠른 참조` → `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md`, `Change Data Capture` → `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md`.
> 아래 6건은 대상 파일 없어 샤드에서 행 제거 + 신규 작성 대기. (제거된 키워드는 작성 시 복원)

| # | 제거된 항목 | 제거 위치 | 권장 파일 경로 | 우선순위 | 상태 | 추가일 |
|---|---|---|---|---|---|---|
| I-01 | Validation Rules 예제 (키워드 7행: REGEX/SSN/우편번호/날짜/숫자/소유자 검증 등) | `_index/apex-core.md` | `Architecture(아키텍처)/Validation Rules 예제.md` | P2 | ✅ 완료(2026-05-22) — 파일 신규 작성 + 키워드 복원 | 2026-05-21 |
| I-02 | fsccashflow Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/fsccashflow Namespace.md` | P3 | 🔲 대기 | 2026-05-21 |
| I-03 | renew_assets_summary Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | P3 | 🔲 대기 | 2026-05-21 |
| I-04 | Sfdc_Checkout Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | P3 | 🔲 대기 | 2026-05-21 |
| I-05 | Sfdc_Enablement Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | P3 | 🔲 대기 | 2026-05-21 |
| I-06 | sfdc_surveys Namespace | `_index/apex-namespaces.md` | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | P3 | 🔲 대기 | 2026-05-21 |

---

### C — 커버리지 재산출 (2026-05-22, wiki-retrospective 모드 B)

> `pdftotext "Salesforce Documents/salesforce_apex_reference_guide.pdf"` → 네임스페이스 헤딩(`^X Namespace$`) 추출 ↔ `find forceNote-wiki -name "*Namespace*.md"` 대조.
> **~70개 중 63개 커버(~93%).** 핵심은 전부 있음. 누락은 니치뿐.

**내부 전용 — 작성 제외** (PDF가 "reserved for internal use only" 명시):
- `flowuiruntime`, `setup_flow_performance`

**작성 대상 누락 네임스페이스 6개:**

| # | 네임스페이스 | 설명 (PDF) | 우선순위 | 권장 경로 | 비고 |
|---|---|---|---|---|---|
| C-01 | DataRetrieval | 상담원-고객 engagement 상세 + 대화 transcript (Engagement·RecordTranscripts 등) | P2 | `Apex/Integration(통합)/DataRetrieval Namespace.md` | 신규 발견 |
| C-02 | Sfdc_Checkout | B2B Commerce 체크아웃 (AsyncCartProcessor·B2BCheckoutController 등) | P2 | `Apex/Integration(통합)/Sfdc_Checkout Namespace.md` | = I-04 |
| C-03 | fsccashflow | FSC CashFlow Flexcard 유틸 (FSCCashFlowUtil) | P3 | `Apex/Integration(통합)/fsccashflow Namespace.md` | = I-02 |
| C-04 | renew_assets_summary | 갱신 가능 자산 → 갱신 Opportunity (Revenue Cloud) | P3 | `Apex/Integration(통합)/renew_assets_summary Namespace.md` | = I-03 |
| C-05 | Sfdc_Enablement | Enablement/Sales Programs 학습 평가 (LearningEvaluation 등) | P3 | `Apex/Integration(통합)/Sfdc_Enablement Namespace.md` | = I-05 |
| C-06 | sfdc_surveys | 설문 초대 링크 단축 (SurveyInvitationLinkShortener) | P3 | `Apex/Integration(통합)/sfdc_surveys Namespace.md` | = I-06 |

**확인 사항:**
- `industriesNlpSvc`: 위키 커버 확인됨 (헤딩 추출엔 안 잡혔으나 페이지 존재).
- `RulesAppIn Namespace.md`: PDF 표기는 `RulesAppln` (Rules Application). 위키 파일명이 오타(`I`↔`l`)일 수 있음 — 내용은 커버됨. **파일명 검토 권장**.

**배치 실행 계획 (Step 2/3):**
- **배치 A (P2, 2개):** C-01 DataRetrieval, C-02 Sfdc_Checkout
- **배치 B (P3, 4개):** C-03 fsccashflow, C-04 renew_assets_summary, C-05 Sfdc_Enablement, C-06 sfdc_surveys
- 각 페이지: 표준 파이프라인 1회전 (scout→researcher→classifier→writer ∥ coverage-checker→completeness-validator(깊이)→source-verifier→index-manager(샤드 `apex-namespaces`)→cross-linker→qa→wiki-retrospective A). PDF 소스 라인은 위 grep 기준 — DataRetrieval≈98786, Sfdc_Checkout≈117968, fsccashflow≈101997, renew_assets_summary≈111194, Sfdc_Enablement≈118087, sfdc_surveys≈118337.

> ✅ **2026-05-22 깊이 감사 완료:** Database·Schema 두 파일 전수 보완 완료.
> - **Schema** (306 → 692줄): SObjectType·SObjectField·SObjectDescribeOptions·FieldDescribeOptions·SOAPType(전수)·DisplayType(누락 14개)·DescribeSObjectResult 누락 메서드 13개·DescribeFieldResult 누락 메서드 15개·DataCategory·DataCategoryGroupSobjectTypePair·DescribeColorResult·DescribeDataCategoryGroupResult·DescribeDataCategoryGroupStructureResult·DescribeIconResult·DescribeTabResult·DescribeTabSetResult 추가
> - **Database** (519 → 604줄): DMLOptions.localeOptions·AssignmentRuleHeader.assignmentRuleId·DuplicateRuleHeader.runAsCurrentUser·DMLOptions 프로퍼티 전수 표·QueryLocatorIterator 클래스 메서드 문서화 추가
> - System(V-09)·ConnectApi(V-10)·Auth 는 기존 검증 완료로 이번 사이클 스킵.
> 🔎 **다음 권장:** ConnectApi Namespace 개요(V-10)는 2,000페이지 분량 — 깊이보다 breadth 우선이므로 현재 유지. N2-03(UI API 개요), L-02·L-03(깨진 링크) 작성이 다음 P2.

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

- [[wiki-retrospective]] — 모드 B에서 이 백로그를 읽고 업데이트하며 에이전트 프로토콜 개선
- [[pm]] — 백로그 항목을 실제 작업으로 스케줄링
