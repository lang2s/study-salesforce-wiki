---
tags: [index, apex, integration, http]
created: 2026-05-17
---

# Integration(통합) — 로컬 인덱스

> Apex HTTP 연동 — 외부 호출 추상화, 인바운드 REST 엔드포인트

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[RestClient 패턴]] | virtual class, Named Credential callout:, PATCH 우회 | #pattern |
| [[Custom REST Endpoint]] | @RestResource, global inherited sharing, RestContext | #pattern |
| [[ConnectApi Chatter 패턴]] | postFeedItemWithRichText, @멘션, Flow 리치 텍스트 변환 | #pattern |
| [[ConnectApi Namespace 개요]] | Connect in Apex 전체 클래스 목록 — ChatterFeeds/EinsteinLLM/CdpQuery/CommerceCart/Communities, setTest* 패턴 | #reference |
| [[Dom Namespace]] | Dom.Document + Dom.XmlNode — XML 생성·파싱, HTTP 연동 | #reference |
| [[DataSource Namespace]] | Salesforce Connect 커스텀 어댑터 — Provider/Connection/sync/query/search/upsert | #reference |
| [[ExternalService Namespace]] | OpenAPI 스펙 기반 타입 안전 외부 서비스 호출 — ExternalService.<ServiceName> | #reference |
| [[Invocable Namespace]] | Apex에서 Flow Action 동적 호출 — createStandardAction, addInvocation, invoke, getDescribe | #reference |
| [[Process Namespace]] | 레거시 Flow 플러그인 — Process.Plugin 인터페이스 (deprecated, @InvocableMethod 권장) | #reference |
| [[QuickAction Namespace]] | Quick Action 실행·조회, Case Feed 이메일 기본값 커스터마이징 — performQuickAction, describeAvailableQuickActions | #reference |
| [[Metadata Namespace]] | CMT 레코드 Apex 배포·조회 — CustomMetadata, DeployContainer, Operations.enqueueDeployment, DeployCallback | #reference |
| [[Compression Namespace]] | Apex Zip 압축·해제 — ZipWriter.addEntry/getArchive, ZipReader.extract, Spring '25 GA | #reference |
| [[DataWeave Namespace]] | Apex에서 DataWeave 스크립트 실행 — Script.createScript, execute, Result.getValueAsString | #reference |
| [[KbManagement Namespace]] | Knowledge Article 라이프사이클 API — PublishingService, 게시·번역·보관·삭제 전체 메서드 | #reference |
| [[Flow Namespace]] | Flow.Interview 클래스 — Apex에서 Flow 실행, createInterview(정적/동적), start(), getVariableValue() | #reference |
| [[Support Namespace]] | Case Feed 이메일 기본 템플릿 선택(Classic), Entitlement 마일스톤 동적 트리거 시간 계산 | #reference |
| [[LxScheduler Namespace]] | Salesforce Scheduler 외부 캘린더 연동 — GetAppointmentCandidates/GetAppointmentSlots, ServiceResourceScheduleHandler | #reference |
| [[TerritoryMgmt Namespace]] | Enterprise Territory Management — OpportunityTerritory2AssignmentFilter 인터페이스로 Opportunity Territory 배정 로직 커스터마이즈 | #reference |
| [[Slack Namespace]] | Salesforce 플랫폼 Slack SDK — RunnableHandler, BotClient/UserClient/AppClient, 43개 클래스 그룹 인벤토리 | #reference |
| [[PlaceQuote Namespace]] | Salesforce CPQ Quote 생성·수정 Apex — 가격 책정 설정·구성 옵션 포함 Quote 프로그래밍적 처리 | #reference |
| [[ChatterAnswers Namespace]] | Chatter Answers 포털 사용자 Account 생성 인터페이스 — AccountCreator.createAccount (⚠️ deprecated) | #reference |
| [[CommerceBuyGrp Namespace]] | B2B/D2C Commerce Buyer Group 동적 배정 — BuyerGroupEvaluationService.getBuyerGroupIds, BuyerGroupRequest/Response | #reference |
| [[CommerceExtension Namespace]] | B2B/D2C Commerce 확장 포인트 해결 전략 — ResolutionStrategy.resolve(), Resolution, ResolutionStates, ExtensionInfo | #reference |
| [[CommerceOrders Namespace]] | B2B/D2C Commerce 주문 생성 Apex — 통합 가격 책정·구성·유효성 검사 (PDF 스텁) | #reference |
| [[CommercePayments Namespace]] | Payment Gateway ISV 어댑터 SDK — PaymentGatewayAdapter/AsyncAdapter, 45개 클래스, SalesforceResultCode 7개, AdyenAdapter 비동기 예시 | #reference |
| [[CommerceTax Namespace]] | Tax Engine ISV 어댑터 SDK — TaxEngineAdapter.processRequest, CalculateTaxRequest/Response, TaxLineItemRequest, TaxDetailsResponse, Avalara 전체 예시 | #reference |
| [[ComplianceMgmt Namespace]] | FSC 규정 준수 룰 프로세서 Apex — ComplianceEvaluation Interface (⚠️ 스텁: 상세 API는 FSC 개발자 가이드 참조) | #reference |
| [[embeddedai Namespace]] | Embedded AI 레코드 직렬화 — ApexMap 키-값 쌍, RecordApexRepresentation 계층 구조, toRecordApexRep JSON 역직렬화 | #reference |
| [[Functions Namespace]] | Salesforce Functions Apex SDK — Function.get/invoke 동기·비동기, FunctionCallback, FunctionInvokeMock+MockFunctionInvocationFactory 테스트 모킹 | #reference |
| [[ise_bots_apex Namespace]] | Einstein Bot 동적 메뉴 항목 — DynamicMenuItem 10개 프로퍼티(설계 시점+런타임 Value 쌍) | #reference |
| [[industriesNlpSvc Namespace]] | Industries Einstein NLP 서비스 — NlpResponse(summarizationResult·errors), NlpSummarizationResult(summary), transformNlpActionResult 출력 | #reference |
| [[IssueCreditMemo Namespace]] | Revenue Cloud 크레딧 메모 생성·적용 — CreditLineRequestInputRepresentations, CreditRequestInputRepresentations, CreditResponseOutputRepresentations (스텁) | #reference |
| [[ind_mfg_sample_mgmt_apex Namespace]] | Manufacturing Cloud 제품 요구사양 관리 — ProductRequirementSpecification·Item·Version (스텁) | #reference |
| [[IndustriesDigitalLending Namespace]] | FSC Digital Lending callable Apex — DigitalLendingIntakeRecordsWrapper, DigitalLendingProductsApi, PricingExecutionWrapper 외 5개 (스텁) | #reference |
| [[InvoiceWriteOff Namespace]] | Revenue Cloud 인보이스 전체 상각 크레딧 메모 — WriteOffInvoiceInput·InputList·Response·ResponseList·ResponseError (스텁) | #reference |
| [[IsvPartners Namespace]] | AppExchange ISV App Analytics 커스텀 상호작용 로깅 — AppAnalytics.logCustomInteraction 3 오버로드, enum 라벨 필수, Id/UUID 해시·토큰화 | #reference |
| [[Pref_center Namespace]] | Privacy Center Preference Manager Apex SDK — PreferenceCenterApexHandler(load/submit), LoadFormData, TokenUtility.generateToken, TokenType(EMAIL/STANDARD) | #reference |
| [[RichMessaging Namespace]] | Enhanced Messaging 채널 Apex SDK — AuthRequestHandler/ProcessFormHandler/ProcessPaymentHandler, 22개 클래스, _Value suffix 이중 프로퍼티 패턴 | #reference |
| [[RevSignaling Namespace]] | Revenue Lifecycle Management Procedure Plan 커스텀 로직 확장 — ProcedurePlan, SignalingApexProcessor, TransactionRequest/Response (⚠️ 스텁) | #reference |
| [[RevSalesTrxn Namespace]] | 가격·구성 통합 판매 트랜잭션(Quote/Order) 생성 Apex — PlaceSalesTransactionExecutor, ConfigurationOptionsInput, GraphRequest, RecordResource (⚠️ 스텁) | #reference |
| [[RulesAppIn Namespace]] | 규칙 기반 결제·크레딧 적용 출력 클래스 — RulesApplicationResponse/SummaryResponse/ErrorResponse, applyPaymentsAndCreditsByRules Invocable Action 연동 (⚠️ 스텁) | #reference |
| [[runtime_industries_cpq Namespace]] | Industries CPQ 제품 검색·카탈로그·카테고리 관리 Apex (managed package, 외부 문서 참조) (⚠️ 스텁) | #reference |
| [[runtime_industries_insurance Namespace]] | Industries Insurance 보험 견적·조항·레이팅 옵션 클래스 5개 (managed package) (⚠️ 스텁) | #reference |
| [[Sfc Namespace]] | Salesforce Files 다운로드 커스터마이징 — ContentDownloadHandlerFactory 팩토리 패턴, ContentDownloadContext 7개 값, isDownloadAllowed/redirectUrl/downloadErrorMessage | #reference |

---

## 빠른 선택

- Apex에서 외부 API 호출? → [[RestClient 패턴]]
- 외부 시스템이 Salesforce를 REST로 호출? → [[Custom REST Endpoint]]
- Chatter 피드에 게시(리치 텍스트, @멘션)? → [[ConnectApi Chatter 패턴]]
- ConnectApi 어떤 클래스 써야 할지? → [[ConnectApi Namespace 개요]]
- HTTP 요청/응답 본문을 XML로 처리? → [[Dom Namespace]]
- 외부 시스템 데이터를 External Object로 연결? → [[DataSource Namespace]]
- OpenAPI 스펙으로 타입 안전 외부 호출? → [[ExternalService Namespace]]
- Apex에서 Flow Action / 표준 액션 호출? → [[Invocable Namespace]]
- Quick Action 프로그래밍적 실행? → [[QuickAction Namespace]]
- Case Feed 이메일 기본값 커스터마이징 (Classic)? → [[Support Namespace]] → EmailTemplateSelector
- Case Feed 이메일 기본값 커스터마이징 (Lightning)? → [[QuickAction Namespace]] → QuickActionDefaultsHandler
- Entitlement 마일스톤 트리거 시간 동적 계산? → [[Support Namespace]] → MilestoneTriggerTimeCalculator
- 레거시 Process.Plugin 마이그레이션? → [[Process Namespace]] (deprecated)
- Apex에서 CMT 레코드 만들거나 배포? → [[Metadata Namespace]]
- 파일 여러 개를 Zip으로 묶어야 할 때? → [[Compression Namespace]]
- JSON/XML/CSV 데이터 변환을 선언적으로? → [[DataWeave Namespace]]
- Knowledge 아티클 게시·번역·보관을 Apex로? → [[KbManagement Namespace]]
- Apex에서 Autolaunched Flow 실행? → [[Flow Namespace]] — Interview 클래스 전체 API
- Salesforce Scheduler 예약 후보 리소스 조회? → [[LxScheduler Namespace]] → SchedulerResources.getAppointmentCandidates
- 특정 리소스의 예약 가능 타임슬롯 조회? → [[LxScheduler Namespace]] → SchedulerResources.getAppointmentSlots
- 외부 캘린더 예약 불가 시간 반영? → [[LxScheduler Namespace]] → ServiceResourceScheduleHandler
- Opportunity Territory Assignment 잡의 배정 로직을 Apex로 재정의? → [[TerritoryMgmt Namespace]] → OpportunityTerritory2AssignmentFilter
- Salesforce에서 Slack 앱 Apex로 개발? → [[Slack Namespace]] → RunnableHandler, BotClient/UserClient/AppClient
- CPQ Quote를 Apex로 생성·수정? → [[PlaceQuote Namespace]] → CPQ 개발자 가이드 참조
- Chatter Answers 포털 사용자 등록 시 Account 커스텀 생성? → [[ChatterAnswers Namespace]] → AccountCreator
- B2B Commerce 사용자를 Buyer Group에 커스텀 배정? → [[CommerceBuyGrp Namespace]] → BuyerGroupEvaluationService
- B2B/D2C 확장 포인트에서 로케일별 로직 분기? → [[CommerceExtension Namespace]] → ResolutionStrategy.resolve()
- B2B/D2C Commerce 주문 생성 Apex? → [[CommerceOrders Namespace]] → B2B Commerce 개발자 가이드 참조
- Payment Gateway ISV 어댑터 구현? → [[CommercePayments Namespace]] → PaymentGatewayAdapter.processRequest()
- 비동기 결제 알림(Webhook) 처리? → [[CommercePayments Namespace]] → PaymentGatewayAsyncAdapter.processNotification()
- 결제 결과 코드를 Salesforce 표준으로 매핑? → [[CommercePayments Namespace]] → SalesforceResultCode 7개 값
- B2B/D2C Commerce 세금 엔진 ISV 어댑터 구현? → [[CommerceTax Namespace]] → TaxEngineAdapter.processRequest()
- 세금 계산 요청(CalculateTaxRequest) 파싱? → [[CommerceTax Namespace]] → TaxEngineContext.getRequest()
- 세금 라인별 rate/tax/jurisdiction 응답 조립? → [[CommerceTax Namespace]] → TaxDetailsResponse + LineItemResponse
- Apex에서 AI 서비스에 레코드 구조 전달? → [[embeddedai Namespace]] → RecordApexRepresentation + ApexMap
- Salesforce Functions를 Apex에서 호출? → [[Functions Namespace]] → Function.get/invoke, FunctionCallback
- Functions 테스트 모킹? → [[Functions Namespace]] → FunctionInvokeMock + MockFunctionInvocationFactory
- Einstein Bot 동적 메뉴 항목 Apex로 생성? → [[ise_bots_apex Namespace]] → DynamicMenuItem
- Industries NLP 요약 결과(transformNlpActionResult) 처리? → [[industriesNlpSvc Namespace]] → NlpResponse + NlpSummarizationResult
- Revenue Cloud 인보이스 크레딧 메모 Apex? → [[IssueCreditMemo Namespace]] → Revenue Cloud 개발자 가이드 참조
- Manufacturing Cloud 제품 요구사양 Apex? → [[ind_mfg_sample_mgmt_apex Namespace]] → Manufacturing Cloud 개발자 가이드 참조
- FSC Digital Lending OmniScript callable Apex? → [[IndustriesDigitalLending Namespace]] → industriesDigitalLending 네임스페이스 공식 문서 참조
- Revenue Cloud 인보이스 전체 상각(Write-Off) Apex? → [[InvoiceWriteOff Namespace]] → Revenue Cloud 개발자 가이드 참조
- AppExchange 패키지에서 App Analytics 커스텀 이벤트 기록? → [[IsvPartners Namespace]] → AppAnalytics.logCustomInteraction
- Privacy Center 동의 양식 로드/제출 로직을 Apex로 커스터마이징? → [[Pref_center Namespace]] → PreferenceCenterApexHandler
- Preference Center 양식 인증 토큰 생성? → [[Pref_center Namespace]] → TokenUtility.generateToken
- Enhanced Messaging 채널에서 결제 처리? → [[RichMessaging Namespace]] → ProcessPaymentHandler
- Revenue Lifecycle Management Procedure Plan 커스텀 로직? → [[RevSignaling Namespace]] → SignalingApexProcessor
- Revenue Cloud에서 Quote/Order를 Apex로 생성? → [[RevSalesTrxn Namespace]] → PlaceSalesTransactionExecutor
- 규칙 기반 결제/크레딧 적용 결과 Apex로 수신? → [[RulesAppIn Namespace]] → RulesApplicationResponse
- Industries CPQ에서 제품 검색·카탈로그 관리 Apex? → [[runtime_industries_cpq Namespace]] → 외부 문서 참조
- Industries Insurance 보험 견적/조항/레이팅 Apex? → [[runtime_industries_insurance Namespace]] → CreateInsuranceQuoteOptions 등
- Salesforce Files 다운로드를 모바일/컨텍스트별로 제어? → [[Sfc Namespace]] → ContentDownloadHandlerFactory
- 파일 다운로드 차단 시 커스텀 오류 메시지 또는 IRM 리디렉션? → [[Sfc Namespace]] → ContentDownloadHandler.downloadErrorMessage / redirectUrl
- 메시징 채널 폼 제출로 레코드 생성? → [[RichMessaging Namespace]] → ProcessFormHandler
- 메시징 채널 OAuth 인증 흐름? → [[RichMessaging Namespace]] → AuthRequestHandler
- 반복/지연 결제 타이밍 설정? → [[RichMessaging Namespace]] → RecurringTiming / DeferredTiming

## 관련 폴더

Named Credential 설정 → [[Integration(통합)/Named Credential]] | 비동기 HTTP → [[Apex/Async(비동기)/index|Async(비동기)]] → [[Queueable]]
