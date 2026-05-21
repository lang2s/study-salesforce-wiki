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
| L-04 | `[[lightning-tabset]]` | LWC BaseComponents index | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` | P3 (→ P3-05 연관) | ✅ 완료(2026-05-22) | 2026-05-21 |
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
| C-01 | DataRetrieval | 상담원-고객 engagement 상세 + 대화 transcript (Engagement·RecordTranscripts 등) | P2 | `Apex/Integration(통합)/DataRetrieval Namespace.md` | ✅ 완료(2026-05-22) — 스텁(PDF p.2761 클래스 인벤토리만 수록, 상세는 Service Cloud 개발자 가이드 참조) |
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

### SO — sObject Reference 챕터 세부 페이지 확장 (object_reference.pdf v67.0)

> **배경:** 2026-05-22. 기존 `sObject/Ch1~Ch6` 챕터 요약 페이지를 PDF 원문 기준 세부 서브페이지로 분화.
> Ch1~Ch5는 각 개념·오브젝트별 개별 세부 페이지(문서 많아도 OK), Ch6는 서비스 클라우드 도메인별 분류 페이지.
> 소스: `Salesforce Documents/object_reference.pdf` (v67.0) — 물리 페이지 = 문서 페이지 + 42 (오프셋).
> **작성 순서:** Ch1 → Ch2 → Ch3 → Ch4 → Ch5 순서로 진행. Ch6는 도메인 분류만 (상세 설명 불필요).

---
> #### ▶ 다음 세션 재개 지점
>
> **Ch1 완료 (10/10)** — `sObject/` 폴더에 10개 서브페이지 + 챕터 개요 `1 Overview.md` 링크 연결 완료.
>
> **다음 작업: SO-C2-01** — `sObject/Object Groups.md` 작성 (doc pp.40–44 / 물리 pp.82–86)
>
> **PDF 준비:**
> ```
> pdftotext -f 82 -l 96 "Salesforce Documents/object_reference.pdf" /tmp/sobject_ch2.txt
> ```
> *(tmp 파일은 세션 간 유지 안 됨 — 매 세션 시작 시 재추출)*
>
> **Ch2 완료 후 처리할 것:**
> - `sObject/2 Object Behavior.md` 각 섹션 제목에 `→ [[서브페이지명]]` 링크 추가
> - `sObject/index.md` Ch2 세부 페이지 표 추가
> - `_index/sobject-reference.md` Ch2 키워드 행 업데이트
> - `WORK_BACKLOG.md` SO-C2-01~03 상태 ✅ 완료로 변경
---

#### SO-Ch1 — Overview of Salesforce Objects and Fields (doc pp.1–39 / 물리 pp.43–81)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C1-01 | Primitive Data Types — base64·boolean·byte·date·dateTime·double·int·long·string·time 10개 타입 전수 설명 | p.1–3 | `sObject/Primitive Data Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-02 | Field Types — address·anyType·calculated·combobox·currency·DataCategoryGroupReference·email·encryptedstring·ID·JunctionIdList·location·masterrecord·multipicklist·percent·phone·picklist·reference·textarea·url + reserved 2개 전수 | p.4–10 | `sObject/Field Types.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-03 | API Field Properties — Aggregatable·Autonumber·Create·Defaulted on create·Delete·Filter·Group·idLookup·Namepointing·Nillable·Query·Restricted picklist·Retrieve·Sort·Update 15개 전수 | p.11–12 | `sObject/API Field Properties.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-04 | System Fields & Required Fields — Id·IsDeleted·LastReferencedDate·LastViewedDate·CreatedById·CreatedDate·LastModifiedById·LastModifiedDate·SystemModstamp + Audit Fields 규칙 + Frequently Occurring Fields (OwnerId·RecordTypeId·CurrencyIsoCode) | p.12–15 | `sObject/System Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-05 | Compound Fields — Address 복합 필드 (서브필드 전수·SOQL GEOLOCATION 활용·DISTANCE 예제), Geolocation 복합 필드 (Location 타입·`__latitude__s`/`__longitude__s` 표기), 복합 필드 제한사항 전수 | p.15–20 | `sObject/Compound Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-06 | Custom Objects — 이름 규칙·관계(Master-Detail 불가 표준 오브젝트 목록)·Audit Fields 설정 절차·Sharing 오브젝트(__Share)·Tags 오브젝트(__Tag)·Required Fields(nillable)·Managed Packages 네임스페이스 prefix | p.21–23 | `sObject/Custom Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-07 | Custom Fields — 이름 규칙·External ID(text/number/email 전용)·Uniqueness(caseSensitive)·Default Values 수식 제한·Managed Packages prefix 변환 | p.24–25 | `sObject/Custom Fields.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-08 | Object Relationships & Data Access — Master-Detail·Many-to-many(Junction)·Lookup 비교표, 데이터 접근 팩터(OLS·FLS·User Permissions·Sharing·Referential Integrity·Page Layouts 비적용), View All / Modify All 권한 | p.25–29 | `sObject/Object Relationships.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-09 | External Objects — Salesforce Connect 어댑터(Cross-org·OData 2.0·OData 4.0·Custom Apex), Files Connect 어댑터(Google Drive·Box·SharePoint·OneDrive), External Object 관계(External Lookup·Indirect Lookup) | p.29–31 | `sObject/External Objects.md` | ✅ 완료 | 2026-05-22 |
| SO-C1-10 | Big Objects — Standard(__b) vs Custom(__b), Use Cases(360° 뷰·감사·Historical Archive), sObject와 차이(비트랜잭션·분산DB), Metadata 정의 XML 전수(CustomObject·CustomField·Index·IndexField), Deploy·View 절차 | p.31–38 | `sObject/Big Objects.md` | ✅ 완료 | 2026-05-22 |

#### SO-Ch2 — Salesforce Object Behavior (doc pp.40–54 / 물리 pp.82–96)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C2-01 | Object Groups — Common Objects (Original·Base Platform·Setup Platform·Custom), Cloud Objects, High-Scale Objects, External Data; 데이터 도메인별·트랜잭션 유형별(ACID/OLTP/OLAP) 분류 | p.40–44 | `sObject/Object Groups.md` | 🔲 대기 | 2026-05-22 |
| SO-C2-02 | Data Cloud Objects — DLO·DMO·UDLO·UDMO·CIO·Data Graphs·Unified Objects·Zero Copy 정의 + DMO/UDMO 생성 흐름(DLO→DMO→Identity Resolution→UDMO→CIO→DG) | p.44–51 | `sObject/Data Cloud Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C2-03 | Object Types Reference & Cheatsheet — suffix 표 전수(__b·__c·__ChangeEvent·__chn·__cio·__dg·__DataCategorySelection·__dlm·__dlo·__dmo·__dso·__e·__Feed·__hd·__History·__mdt·__x 등), 오브젝트 타입별 Cheatsheet(Customizable·Cloud·Packaging·Documentation) | p.51–54 | `sObject/Object Types Reference.md` | 🔲 대기 | 2026-05-22 |

#### SO-Ch3 — Associated Objects (doc pp.55–77 / 물리 pp.97–119)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C3-01 | Feed Objects (StandardObjectNameFeed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText 지원 HTML 태그·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), Type picklist 20+개 값 전수, SOQL 제한 | p.55–62 | `sObject/Feed Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-02 | History Objects (StandardObjectNameHistory) — 필드 참조표(StandardObjectNameId·DataType·Field·NewValue·OldValue), 지원 호출 전수, v42.0+ delete() 활성화 방법 | p.63–64 | `sObject/History Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-03 | Share & OwnerSharingRule Objects — Share 필드(AccessLevel·ParentId·RowCause·UserOrGroupId)·OwnerSharingRule 필드(AccessLevel·Description·DeveloperName·GroupId·Name·UserOrGroupId), RowCause=Manual 전용 쓰기 규칙 | p.65–67 | `sObject/Share Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |
| SO-C3-04 | ChangeEvent Objects (CDC) — 전체 필드·ChangeEventHeader 상세(entityName·recordIds·changeType·changeOrigin·transactionKey·sequenceNumber·commitTimestamp·commitUser), JSON 이벤트 메시지 예제, CDC 지원 오브젝트 목록 전수(100+개), replayId·schema 필드 | p.68–77 | `sObject/ChangeEvent Objects.md` | ✅ 완료(2026-05-22) | 2026-05-22 |

#### SO-Ch4 — Custom Objects (doc pp.78–94 / 물리 pp.120–136)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C4-01 | Custom Metadata Type (__mdt) — 전체 필드 참조표(Custom Field__c·DeveloperName·isProtected·Label·Language·MasterLabel·NamespacePrefix·QualifiedApiName·SystemModStamp), isProtected 관리 패키지 접근 규칙(동일 패키지·타 패키지·구독자 코드 규칙) | p.80–82 | `sObject/Custom Metadata Type (__mdt).md` | 🔲 대기 | 2026-05-22 |
| SO-C4-02 | Custom Object Standard Fields (__c) — 전체 표준 필드 참조표(ConnectionReceivedId·ConnectionSentId·CreatedById·CreatedDate·CurrencyIsoCode·Id·IsDeleted·LastActivityDate·LastModifiedDate·LastModifiedById·LastReferencedDate·LastViewedDate·Name·OwnerId·RecordTypeId·SystemModStamp) + 지원 호출 전수 | p.83–87 | `sObject/Custom Object Standard Fields (__c).md` | 🔲 대기 | 2026-05-22 |
| SO-C4-03 | Custom Object Feed (__Feed) — 전체 필드 참조표(BestCommentId·Body·CommentCount·ConnectionId·ContentData·ContentFileName·ContentSize·ContentType·FeedPostId·InsertedById·IsRichText·LikeCount·LinkUrl·NetworkScope·ParentId·RelatedRecordId·Title·Type·Visibility), SOQL 제한, 삭제 접근 규칙 | p.87–94 | `sObject/Custom Object Feed (__Feed).md` | 🔲 대기 | 2026-05-22 |

#### SO-Ch5 — Object Interfaces (doc pp.95–104 / 물리 pp.137–146)

| # | 주제 | PDF 페이지 (doc) | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|---|
| SO-C5-01 | PriceAdjustmentGroup Interface — 전체 필드 참조표(AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·Priority·SalesTransactionId·TotalAmount), AdjustmentSource picklist 값(Discretionary·Promotion·Rule·System), 사용 조건(Subscription Management / B2B Commerce) | p.96–97 | `sObject/PriceAdjustmentGroup.md` | 🔲 대기 | 2026-05-22 |
| SO-C5-02 | PriceAdjustmentItem Interface — 전체 필드 참조표(AdjustmentAmountScope·AdjustmentSource·AdjustmentType·AdjustmentValue·Description·ImplementorType·PriceAdjustmentCauseId·PriceAdjustmentGroupId·Priority·SalesTransactionItemId·TotalAmount), AdjustmentAmountScope (Total vs Unit) 수식 계산 예제 | p.98–102 | `sObject/PriceAdjustmentItem.md` | 🔲 대기 | 2026-05-22 |
| SO-C5-03 | SalesTransaction Interface — 전체 필드 참조표(ImplementorType·TotalAdjustmentAmount·TotalAdjustmentDistAmount·TotalAmount·TotalListAmount·TotalProductAmount), 사용 조건(Subscription Management / B2B Commerce), 구현체 오브젝트 패턴(Order·WebCart 등) | p.103–104 | `sObject/SalesTransaction.md` | 🔲 대기 | 2026-05-22 |

#### SO-Ch6 — Standard Objects 도메인 분류 (object_reference.pdf — Ch6 범위)

> Ch6는 각 Standard Object별 상세 설명 없이 **서비스 클라우드 도메인별 오브젝트 목록 분류**만 작성.

| # | 도메인 | 권장 파일 경로 | 상태 | 추가일 |
|---|---|---|---|---|
| SO-C6-01 | Core CRM — Account·Contact·Lead·Opportunity·Campaign·Case·Contract·Pricebook2·Product2·Quote 등 | `sObject/Core CRM Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-02 | Service Cloud — Entitlement·ServiceContract·SocialPost·LiveChatTranscript·MessagingSession·Knowledge__kav 등 | `sObject/Service Cloud Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-03 | B2B Commerce & Revenue — WebCart·CartItem·WebStore·OrderSummary·PendingOrderSummary 등 | `sObject/B2B Commerce Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-04 | Field Service — ServiceAppointment·ServiceResource·ServiceTerritory·WorkOrder·MaintenancePlan 등 | `sObject/Field Service Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-05 | Platform & Admin — User·Group·Profile·PermissionSet·RecordType·FlowRecord·CustomField·CustomObject 등 | `sObject/Platform Admin Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-06 | Files & Content — ContentDocument·ContentVersion·ContentDocumentLink·ContentFolder 등 | `sObject/Files Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-07 | Analytics & Data Cloud — WaveAutoInstallRequest·DataUsePurpose·DataUseLegalBasis 등 | `sObject/Analytics Objects.md` | 🔲 대기 | 2026-05-22 |
| SO-C6-08 | Experience Cloud & Collaboration — Network·CollaborationGroup·Topic·FeedItem 등 | `sObject/Experience Cloud Objects.md` | 🔲 대기 | 2026-05-22 |

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
