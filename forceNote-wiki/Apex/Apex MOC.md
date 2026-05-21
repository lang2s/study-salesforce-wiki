---
tags: [apex, moc, index]
created: 2026-05-17
---

# Apex — Map of Content

> 출처: [apex-recipes](https://github.com/trailheadapps/apex-recipes) (Salesforce 공식 학습 앱) 74개 클래스 분석

---

## 🏗 아키텍처 패턴

> 파일 위치: `Architecture(아키텍처)/` (루트 레벨 — Apex·LWC·Flow 공통)

- [[서비스 레이어 패턴]] — TriggerHandler → ServiceLayer 브로커 분리
- [[TriggerHandler 패턴]] — abstract class, bypass, 루프 방지
- [[CMDT 메타데이터 트리거]] — 배포 없이 핸들러 등록/비활성화
- [[Permission Set 설계]] — objectPermissions, fieldPermissions, classAccesses 구성 표준
- [[ApexPages Namespace]] — Visualforce 컨트롤러 전체 레퍼런스: Action·Component·Message·StandardController·StandardSetController·IdeaStandard*·KnowledgeArticleVersionStandardController
- [[AppLauncher Namespace]] — App Launcher 앱 가시성·정렬 제어: AppMenu.setAppVisibility, setOrgSortOrder, setUserSortOrder
- [[VisualEditor Namespace]] — Lightning App Builder 동적 피클리스트: DynamicPickList 상속, DataRow, DynamicPickListRows, DesignTimePageContext(pageType 분기)
- [[Canvas Namespace]] — 외부 웹 앱 임베드 Apex SDK: CanvasLifecycleHandler(excludeContextTypes/onRender), RenderContext, ApplicationContext, EnvironmentContext, Canvas.Test

## 🔒 보안

- [[Safely]] — DML Fluent API (allOrNothing, throwIfRemovedFields)
- [[CanTheUser]] — CRUD/FLS 체크 (create/edit/destroy/flsAccessible)
- [[StripInaccessible]] — AccessType별 FLS 필드 제거
- [[WITH USER_MODE]] — SOQL/DML 인라인 보안 키워드
- [[Auth Namespace]] — JWT/JWS OAuth bearer token flow, MFA TOTP, SessionManagement, RegistrationHandler
- [[TxnSecurity Namespace]] — EventCondition/AsyncCondition으로 Transaction Security Policy Apex 구현, Real-Time Event Monitoring 기반 차단·알림 정책
- [[UserProvisioning Namespace]] — 커넥티드 앱 아웃바운드 사용자 프로비저닝: ConnectorTestUtil/UserProvisioningLog/UserProvisioningPlugin(reconOffset 청크)

## 🔍 SOQL / SOSL

- [[SOQL SOSL 소개]] — SOQL vs SOSL 선택 기준, 언제 무엇을 쓸지, 성능 고려사항
- [[SOQL 문법 레퍼런스]] — SELECT 전체 문법, 날짜 리터럴, 집계 함수, 관계 쿼리, ROLLUP/CUBE, 세미조인, Object별 제한
- [[SOQL WITH DATA CATEGORY]] — Knowledge/Question 카테고리 필터, AT/ABOVE/BELOW/ABOVE_OR_BELOW, RecordVisibilityContext
- [[Syndication Feed SOQL]] — 커스텀 피드 동기화용 SOQL 매핑 문법
- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop, 청크 반복
- [[Dynamic SOQL]] — queryWithBinds, SOQL 인젝션 방어
- [[SOSL 패턴]] — FIND 구문, IN SearchGroup, RETURNING, 여러 Object 전문 검색

## 📊 데이터 (DML / Namespace)

- [[DML 패턴]] — insert as user/system, Database.*(accessLevel)
- [[PagedResult 패턴]] — 페이지네이션 DTO, scope='global', ?? null coalescing, LIMIT+OFFSET
- [[BusinessHours 패턴]] — BusinessHours.diff(), isWithin(), nextStartDate(), SLA 경과 시간 계산
- [[Database Namespace 상세]] — SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert
- [[Search Namespace]] — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter
- [[FormulaEval Namespace]] — Formula.builder() 동적 수식 평가, getReferencedFields(), 템플릿 모드
- [[Reports Namespace]] — ReportManager.runReport/runAsyncReport, ReportMetadata 필터 재정의, FactMap 탐색
- [[Datacloud Namespace]] — Duplicate Management Apex — FindDuplicates/FindDuplicatesByIds, DuplicateResult, MatchRecord (이름 주의: Salesforce Data Cloud 제품과 무관)
- [[Wave Namespace]] — CRM Analytics SDK — QueryBuilder/QueryNode/ProjectionNode로 SAQL 쿼리 빌드·실행, Templates 조회

## ⚡ 비동기

- [[비동기 컨텍스트 선택]] — @future vs Queueable vs Batch 결정 매트릭스
- [[Future 메서드]] — @future, callout=true
- [[Queueable]] — implements Queueable, Database.AllowsCallouts
- [[Queueable 체이닝]] — execute당 1개 enqueue 규칙
- [[Batch Apex]] — Database.Stateful, start/execute/finish
- [[Scheduled Apex]] — thin execute, System.scheduleBatch

## 🌐 통합

- [[RestClient 패턴]] — virtual class, PATCH 우회, callout: 접두어
- [[Custom REST Endpoint]] — @RestResource, global inherited sharing, RestContext
- [[Named Credential]] — External Credential → Principal → NC 순서
- [[ConnectApi Chatter 패턴]] — postFeedItemWithRichText, @멘션, Flow 리치 텍스트 변환
- [[ConnectApi Namespace 개요]] — Connect in Apex 전체 클래스 목록, ChatterFeeds/EinsteinLLM/CdpQuery/CommerceCart, 테스트 setTest* 패턴
- [[Dom Namespace]] — Dom.Document/XmlNode, XML 생성·파싱, HTTP 본문 처리
- [[DataSource Namespace]] — Salesforce Connect 커스텀 어댑터, Provider/Connection/sync/query/upsert
- [[ExternalService Namespace]] — OpenAPI 스펙 기반 타입 안전 외부 서비스 호출
- [[Invocable Namespace]] — Apex에서 Flow Action 동적 호출, createStandardAction/createCustomAction, invoke
- [[Process Namespace]] — 레거시 Flow 플러그인 인터페이스 (deprecated, @InvocableMethod 권장)
- [[QuickAction Namespace]] — performQuickAction, describeAvailableQuickActions, QuickActionDefaultsHandler, Case Feed 이메일 기본값
- [[Metadata Namespace]] — CMT 레코드 Apex 배포·조회, CustomMetadata/DeployContainer/Operations.enqueueDeployment/DeployCallback
- [[Compression Namespace]] — ZipWriter/ZipReader로 Apex Zip 압축·해제, Spring '25 GA
- [[DataWeave Namespace]] — DataWeave.Script.createScript/execute, JSON·XML·CSV 변환, Winter '24 GA
- [[DataRetrieval Namespace]] — Service Cloud Contact Center 상담원-고객 인게이지먼트 트랜스크립트 조회·기록 Apex (⚠️ 스텁)
- [[KbManagement Namespace]] — KbManagement.PublishingService, 아티클 게시·번역·보관·삭제 라이프사이클 API
- [[Flow Namespace]] — Flow.Interview 클래스 — Apex에서 Flow 실행, createInterview(정적/동적), start(), getVariableValue()
- [[Support Namespace]] — EmailTemplateSelector(Classic Case Feed 템플릿 자동 선택), MilestoneTriggerTimeCalculator(동적 SLA 트리거 시간)
- [[LxScheduler Namespace]] — Salesforce Scheduler 외부 캘린더 연동 API — GetAppointmentCandidates/Slots, ServiceResourceScheduleHandler
- [[TerritoryMgmt Namespace]] — Enterprise Territory Management: OpportunityTerritory2AssignmentFilter로 Opportunity Territory 배정 로직 커스터마이즈
- [[Slack Namespace]] — Salesforce 플랫폼 Slack SDK: RunnableHandler, BotClient/UserClient/AppClient, 43개 클래스 그룹 인벤토리
- [[PlaceQuote Namespace]] — Salesforce CPQ Quote 생성·수정: 가격 책정 설정·구성 옵션 포함 Quote 프로그래밍적 처리
- [[ChatterAnswers Namespace]] — Chatter Answers 포털 Account 생성 인터페이스: AccountCreator.createAccount (⚠️ deprecated)
- [[CommerceBuyGrp Namespace]] — B2B/D2C Commerce Buyer Group 동적 배정: BuyerGroupEvaluationService, BuyerGroupRequest/Response
- [[CommerceExtension Namespace]] — B2B/D2C Commerce 확장 포인트 해결 전략: ResolutionStrategy.resolve(), ResolutionStates(EXECUTE_DEFAULT/EXECUTE_REGISTERED/OFF), ExtensionInfo
- [[CommerceOrders Namespace]] — B2B/D2C Commerce 주문 생성 Apex: 통합 가격 책정·구성·유효성 검사 (PDF 스텁)
- [[CommercePayments Namespace]] — Payment Gateway ISV 어댑터 SDK: PaymentGatewayAdapter/AsyncAdapter, 45개 클래스, SalesforceResultCode 7개, AdyenAdapter 비동기 예시
- [[CommerceTax Namespace]] — Tax Engine ISV 어댑터 SDK: TaxEngineAdapter.processRequest, CalculateTaxRequest/Response, TaxLineItemRequest, TaxDetailsResponse, ImpositionResponse/JurisdictionResponse, 5개 Enum(TaxTransactionStatus/Type/CalculateTaxType/RequestType/ResultCode), Avalara 전체 예시
- [[ComplianceMgmt Namespace]] — FSC 규정 준수 제어 룰 프로세서 Apex: ComplianceEvaluation Interface, ControlEvaluationInput/ControlInput, ComplianceEvaluationResponse, EvaluationResult, ComplianceControlLog (⚠️ API 상세는 FSC 개발자 가이드 참조)
- [[embeddedai Namespace]] — Apex에서 Embedded AI 서비스에 레코드 데이터 전달: ApexMap(키-값 쌍), RecordApexRepresentation(레코드+관련 레코드 계층 구조), toRecordApexRep(JSON 역직렬화)
- [[Functions Namespace]] — Salesforce Functions 동기/비동기 호출 Apex SDK: Function.get/invoke, FunctionCallback.handleResponse, FunctionInvokeMock+MockFunctionInvocationFactory 테스트 모킹
- [[ise_bots_apex Namespace]] — Einstein Bot 동적 메뉴 항목 Apex: DynamicMenuItem(EntityId/Label/SummaryTextWithFormula/sortByDate + 런타임 Value 프로퍼티 10개)
- [[industriesNlpSvc Namespace]] — Industries Einstein NLP 서비스 Apex: NlpResponse(summarizationResult·errors), NlpSummarizationResult(summary), transformNlpActionResult Invocable Action 출력
- [[IssueCreditMemo Namespace]] — Revenue Cloud 크레딧 메모 생성·적용 Apex: CreditLineRequestInputRepresentations, CreditRequestInputRepresentations, CreditResponseOutputRepresentations (⚠️ 스텁)
- [[ind_mfg_sample_mgmt_apex Namespace]] — Manufacturing Cloud 제품 요구사양 생애주기 관리 Apex: ProductRequirementSpecification·Item·Version (⚠️ 스텁)
- [[IndustriesDigitalLending Namespace]] — FSC Digital Lending OmniScript·Integration Procedure callable Apex: DigitalLendingIntakeRecordsWrapper, DigitalLendingProductsApi, PricingExecutionWrapper 외 5개 (⚠️ 스텁)
- [[InvoiceWriteOff Namespace]] — Revenue Cloud 인보이스 전체 상각 크레딧 메모 Apex: WriteOffInvoiceInput·InputList·Response·ResponseList·ResponseError (⚠️ 스텁)
- [[IsvPartners Namespace]] — AppExchange ISV App Analytics 커스텀 상호작용 로깅: AppAnalytics.logCustomInteraction(3 오버로드), interactionLabel enum 필수, interactionId 해시·토큰화
- [[RichMessaging Namespace]] — Enhanced Messaging(Messaging for Web/In-App) 채널 Apex SDK: AuthRequestHandler/ProcessFormHandler/ProcessPaymentHandler 3대 인터페이스, 22개 클래스, _Value suffix 이중 프로퍼티 패턴(Flow/LWC 양측 지원)
- [[RevSignaling Namespace]] — Revenue Lifecycle Management Procedure Plan 커스텀 로직 확장: ProcedurePlan, SignalingApexProcessor, TransactionRequest/Response (⚠️ 스텁)
- [[RevSalesTrxn Namespace]] — 가격·구성 통합 판매 트랜잭션(Quote/Order) 생성 Apex: PlaceSalesTransactionExecutor, ConfigurationOptionsInput, GraphRequest, RecordResource (⚠️ 스텁)
- [[RulesAppIn Namespace]] — 규칙 기반 결제·크레딧 적용 출력 클래스: RulesApplicationResponse/SummaryResponse/ErrorResponse, applyPaymentsAndCreditsByRules Invocable Action 연동 (⚠️ 스텁)
- [[runtime_industries_cpq Namespace]] — Industries CPQ 제품 검색·카탈로그·카테고리 관리 Apex (managed package, 외부 문서 참조) (⚠️ 스텁)
- [[runtime_industries_insurance Namespace]] — Industries Insurance 보험 견적·조항·레이팅 옵션 클래스 5개: AddEligibleInsuranceClausesOptions, CreateInsuranceQuoteOptions 등 (⚠️ 스텁)
- [[Sfc Namespace]] — Salesforce Files 다운로드 커스터마이징: ContentDownloadHandlerFactory 팩토리 패턴, ContentDownloadContext 7개 값, isDownloadAllowed/redirectUrl/downloadErrorMessage
- [[Pref_center Namespace]] — Privacy Center Preference Manager 커스터마이징 Apex SDK: PreferenceCenterApexHandler(load/submit), LoadFormData/SubmitFormData, TokenUtility.generateToken(EMAIL/STANDARD), ValidationResult

## 📦 컬렉션

- [[Comparator 인터페이스]] — null 3단계 처리, ASCENDING/DESCENDING enum
- [[Iterable Iterator]] — 페이지네이션 REST for-each 추상화
- [[CollectionUtils]] — Type.forName 동적 Map, idMapFromCollectionByKey

## 🧪 테스트

- [[테스트 전략]] — 시나리오 기반, Given-When-Then, 75%는 결과
- [[StubProvider]] — System.StubProvider, Test.createStub, hasBeenCalledXTimes
- [[HttpCalloutMock]] — HttpCalloutMock 구현, Test.setMock
- [[testVisible 회로차단기]] — Boolean/Exception 회로 차단기
- [[SOSL 테스트 패턴]] — Test.setFixedSearchResults
- [[Flowtesting Namespace]] — Flow Builder 생성 flow test, flowtesting 동적 namespace, sf flow run test

## 🔭 실행 컨텍스트

- [[QuiddityGuard]] — trusted/untrusted Quiddity, testQuiddityOverride
- [[OrgShape]] — isSandbox, isMultiCurrencyEnabled, isPersonAccountEnabled
- [[Governor Limits]] — Per-Transaction/Platform/Static 한도 전체 표, Limits 클래스, Bulkify/SOQL 방어 패턴

## 📋 로깅

- [[Log 싱글턴 패턴]] — add() 버퍼 → publish() 일괄 발행

## 📡 플랫폼 이벤트

- [[Platform Event 발행]] — EventBus.publish, 수신 트리거, ReplayId
- [[ChangeEventHeader]] — CDC 변경 이벤트 헤더, changetype/recordids/changedfields, TriggerContext
- [[EventBus Publish Callbacks]] — 비동기 발행 최종 결과 콜백, EventPublishFailureCallback, setResumeCheckpoint
- [[EventBus Namespace]] — EventBus.publish 메서드 전체 서명, TriggerContext, RetryableException, publishWithAccessLevel, API v67 ACCESS_MODE 변경

## 💾 플랫폼 캐시

- [[Platform Cache]] — Cache.Org/Session, Cache-Aside 패턴, @CacheBuilder
- [[Cache Namespace]] — CacheBuilder, Cache.Org/Session, OrgPartition, Visibility Enum 전체 API

## 📨 메시징

- [[SingleEmailMessage]] — Apex에서 단일 이메일 발송, setToAddresses, setTemplateId, 첨부파일
- [[CustomNotification]] — 인앱 알림, setNotificationTypeId, send(), Actionable Notification
- [[Messaging Namespace]] — InboundEmailHandler, InboundEmail/Result/Envelope, ActionableNotification 전체 API

## 🏗 승인 프로세스 / 스키마

- [[Approval Namespace]] — ProcessSubmitRequest, ProcessWorkitemRequest, lock/unlock, LockResult
- [[Schema Namespace 상세]] — DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship

## 🌐 System Namespace 레퍼런스

- [[System Namespace]] — AccessLevel(USER_MODE/SYSTEM_MODE), AccessType, Assert, AsyncInfo/AsyncOptions, Callable, Domain/URL, FeatureManagement, Request/Quiddity, UserInfo, UUID, System 클래스 전체 API
- [[Site Namespace]] — Salesforce Sites URL 재작성, UrlRewriter Interface (generateUrlFor/mapRequestUrl), Site.ExternalUserCreateException
- [[Context Namespace]] — Industries Cloud Context Service Apex — IndustriesContext 클래스, 비즈니스 컨텍스트 데이터 공유·소비

## 📖 레퍼런스

- [[Apex 표준 클래스 레퍼런스]] — String / List / Map / Database / Crypto / JSON / Schema / Limits 전체 API 빠른 참조

## ✅ 모범 사례

- [[Apex Best Practices]] — Bulkify / 루프 내 DML·SOQL 금지 / 하드코딩 ID 금지 / 공유 모델 명시 / 단일 트리거 / SOQL for 루프 / 모듈화 / 테스트 시나리오 / 중첩 루프 금지 / 네이밍 / 트리거 로직 분리 / AuraEnabled JSON 금지 (12가지)

---

## 빠른 의사결정

```
비동기 방식?           →  [[비동기 컨텍스트 선택]]
DML 보안?              →  [[DML 패턴]] → as user 키워드 or [[Safely]]
쿼리 보안?             →  [[SOQL 패턴]] → WITH USER_MODE
동적 쿼리?             →  [[Dynamic SOQL]] → queryWithBinds
HTTP 호출?             →  [[RestClient 패턴]]
XML HTTP 연동?         →  [[Dom Namespace]]
OAuth JWT 토큰 교환?   →  [[Auth Namespace]] → JWT/JWS/JWTBearerTokenExchange
MFA / 로그인 플로우?   →  [[Auth Namespace]] → SessionManagement
외부 오브젝트 연결?    →  [[DataSource Namespace]] → Provider/Connection
OpenAPI 타입 호출?     →  [[ExternalService Namespace]]
동적 수식 평가?        →  [[FormulaEval Namespace]] → Formula.builder()
Flow Action Apex 호출? →  [[Invocable Namespace]] → createStandardAction
Apex에서 Flow 실행(API 레퍼런스)?  →  [[Flow Namespace]] → Interview.createInterview/start
이벤트 발행 결과 추적? →  [[EventBus Publish Callbacks]] → EventPublishFailureCallback
ConnectApi 클래스 목록?   →  [[ConnectApi Namespace 개요]] → ChatterFeeds/EinsteinLLM/CdpQuery
EventBus API 시그니처?   →  [[EventBus Namespace]] → TriggerContext, publishWithAccessLevel
Quick Action 실행?      →  [[QuickAction Namespace]] → performQuickAction
보고서 Apex 실행?       →  [[Reports Namespace]] → ReportManager.runReport
외부 모킹?             →  [[StubProvider]]
```
