# SEARCH INDEX
> 이 파일 하나로 전체 wiki 탐색. 키워드 → 파일 경로 직접 매핑.
> 질문 받으면 여기서 파일 경로 확인 → 해당 파일 바로 읽기.

---

## LWC — Apex 호출 / 데이터 로드

| 키워드 | 파일 |
|---|---|
| @wire, wire 어댑터, cacheable, 자동 데이터 로드, reactive property, $변수 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| wire vs imperative, 언제 wire, 언제 직접 호출 | `LWC/ApexIntegration(Apex통합)/Wire vs Imperative 선택.md` |
| imperative, async await, 버튼 클릭 호출, 직접 Apex 호출, isLoading | `LWC/ApexIntegration(Apex통합)/Imperative 호출 패턴.md` |

## LWC — 컴포넌트 통신 / 이벤트

| 키워드 | 파일 |
|---|---|
| CustomEvent, 자식→부모, dispatchEvent, detail, bubbles, composed, 이벤트 버블링 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
| LMS, Lightning Message Service, 형제 컴포넌트, 크로스 컴포넌트, publish, subscribe, MessageContext, pubsub | `LWC/Events(이벤트)/Lightning Message Service.md` |
| @api property, @api method, 부모→자식, querySelector, getter setter, lwc:spread | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` |
| 다른 컴포넌트 함수 호출, 컴포넌트 간 함수 실행 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 상태 관리, @lwc/state, atom, computed, 공유 상태, fromContext | `LWC/Events(이벤트)/상태 관리.md` |
| 컨테이너 컴포넌트, 프레젠테이션, 컴포지션, for:each, lwc:if | `LWC/ComponentAPI(컴포넌트API)/컴포지션 패턴.md` |

## LWC — LDS / 레코드 조작

| 키워드 | 파일 |
|---|---|
| lightning-record-form, record-edit-form, record-view-form, 레코드 폼 선택 | `LWC/LDS/Record Form 선택.md` |
| getRecord, getFieldValue, static schema, @salesforce/schema | `LWC/LDS/getRecord 패턴.md` |
| createRecord, updateRecord, deleteRecord, uiRecordApi, notifyRecordUpdateAvailable, 레코드 생성 수정 삭제, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
| reduceErrors, 에러 정규화, ldsUtils | `LWC/LDS/ldsUtils reduceErrors.md` |
| getPicklistValues, Picklist 옵션 로드, 동적 Picklist, 종속 Picklist, validFor, controllerValues, LWC에서 콤보박스 옵션 | `LWC/LDS/getPicklistValues 패턴.md` |

## LWC — UI / 네비게이션 / 모달

| 키워드 | 파일 |
|---|---|
| Toast, ShowToastEvent, variant, success error warning info | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| 모달, LightningModal, modal open close, 확인 다이얼로그 | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| LightningAlert, alert.open, 단순 경고 다이얼로그, 차단 알림, OK 클릭 대기 | `LWC/UIPatterns(UI패턴)/Toast & 모달 패턴.md` |
| 에러 패널, errorPanel, 에러 표시 컴포넌트 | `LWC/UIPatterns(UI패턴)/에러 패널 패턴.md` |
| 공유 JS, 유틸리티 함수, named export, isExposed false | `LWC/UIPatterns(UI패턴)/공유 JS 모듈.md` |
| NavigationMixin, 페이지 이동, 레코드 페이지 이동, pageReference | `LWC/Navigation(네비게이션)/NavigationMixin 패턴.md` |
| Static Resource, loadScript, loadStyle, 서드파티 라이브러리, renderedCallback | `LWC/UIPatterns(UI패턴)/Static Resource 로딩.md` |
| 파일 업로드, 이미지 처리, processImage, FileReader, ContentVersion | `LWC/UIPatterns(UI패턴)/파일 업로드와 이미지 처리.md` |

## LWC — 보안 / 모바일

| 키워드 | 파일 |
|---|---|
| LWC 보안, CSP 브라우저, 권한 기반 UI, userId | `LWC/Security(보안)/LWC 보안 패턴.md` |
| 모바일, getBarcodeScanner, 바코드, getLocationService, GPS, isAvailable | `LWC/Mobile(모바일)/모바일 기능 패턴.md` |

## LWC — Jest 테스트

| 키워드 | 파일 |
|---|---|
| LWC Jest 테스트, jest wire mock, @wire 테스트, registerTestWireAdapter, emit, emitError | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |
| LWC DOM 이벤트 테스트, querySelector, dispatchEvent, CustomEvent 검증, 버튼 클릭 테스트 | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |
| @salesforce/apex mock, jest.mock, mockResolvedValue, mockRejectedValue, virtual true, Apex 모킹 LWC | `LWC/Testing(테스트)/Jest 테스트 패턴.md` |

---

## Apex — 아키텍처 / 트리거

| 키워드 | 파일 |
|---|---|
| 서비스 레이어, ServiceLayer, TriggerHandler, Trigger 계층, 비즈니스 로직 분리 | `Architecture(아키텍처)/서비스 레이어 패턴.md` |
| TriggerHandler, beforeInsert afterInsert, Trigger.new, 트리거 패턴 | `Apex/Trigger(트리거)/TriggerHandler 패턴.md` |
| CMDT, Custom Metadata, 트리거 on/off, 메타데이터 트리거 제어 | `Apex/Trigger(트리거)/CMDT 메타데이터 트리거.md` |
| Permission Set, 권한 설계 | `Architecture(아키텍처)/Permission Set 설계.md` |

## Apex — 보안 / FLS / DML (Auth 추가)

| 키워드 | 파일 |
|---|---|
| Safely, FLS, CRUD 보안, with sharing, 안전한 DML, 필드 레벨 보안, 공유 규칙 | `Apex/Security(보안)/Safely.md` |
| CanTheUser, 권한 확인, 삭제 가능 여부, isUpdatable | `Apex/Security(보안)/CanTheUser.md` |
| StripInaccessible, 접근 불가 필드 제거, POST 바디 보안 | `Apex/Security(보안)/StripInaccessible.md` |
| WITH USER_MODE, USER_MODE, SYSTEM_MODE, SOQL 보안 모드 | `Apex/Security(보안)/WITH USER_MODE.md` |
| DML, insert update delete, allOrNothing, SaveResult, 부분 성공 | `Apex/Data(데이터)/DML 패턴.md` |
| Auth.JWT, Auth.JWS, Auth.JWTBearerTokenExchange, OAuth JWT bearer token, JWT 서명, JWT 클레임, JWT flow, getAccessToken, getCompactSerialization | `Apex/Security(보안)/Auth Namespace.md` |
| Auth.SessionManagement, 세션 관리, MFA, TOTP, validateTotpTokenForUser, getQrCode, setSessionLevel, finishLoginFlow, generateVerificationUrl, inOrgNetworkRange, 커스텀 로그인 | `Apex/Security(보안)/Auth Namespace.md` |
| Auth.RegistrationHandler, SSO 프로비저닝, Auth.UserData, createUser updateUser, 사용자 자동 생성 | `Apex/Security(보안)/Auth Namespace.md` |

## Apex — 데이터 / SOQL

| 키워드 | 파일 |
|---|---|
| SOQL, 쿼리 패턴, 벌크 쿼리, 거버너 한도, Database.query, 데이터 조회, SELECT FROM WHERE | `Apex/Data(데이터)/SOQL 패턴.md` |
| SOSL, FIND 구문, 전문 검색, IN NAME FIELDS, RETURNING, 여러 오브젝트 검색, List<List<SObject>>, WITH SNIPPET, WITH HIGHLIGHT, SOSL vs SOQL | `Apex/Data(데이터)/SOSL 패턴.md` |
| FormulaEval, Formula.builder, 동적 수식 평가, 포뮬러 필드 재계산, DML 없이 수식 계산, getReferencedFields, 수식 평가 Apex, 템플릿 수식, FormulaReturnType, FormulaGlobal | `Apex/Data(데이터)/FormulaEval Namespace.md` |
| Reports namespace, ReportManager, runReport, runAsyncReport, ReportResults, ReportMetadata, ReportFact, ReportFactWithDetails, SummaryValue, FactMap, 보고서 Apex 실행, 비동기 보고서, 보고서 필터 재정의, getFactMap, ReportFilter, BucketField, ReportInstance | `Apex/Data(데이터)/Reports Namespace.md` |
| BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 준수 여부, 업무시간 경과, isWithin, nextStartDate, SLA 초과 | `Apex/Data(데이터)/BusinessHours 패턴.md` |
| Dynamic SOQL, 동적 쿼리, String.escapeSingleQuotes, 바인딩 변수 | `Apex/Data(데이터)/Dynamic SOQL.md` |
| 페이징, PagedResult, 오프셋, OFFSET LIMIT, 페이지네이션 | `Apex/Data(데이터)/PagedResult 패턴.md` |

## Apex — 비동기

| 키워드 | 파일 |
|---|---|
| 비동기 선택, 언제 future 언제 queueable 언제 batch, Cursor vs Batch, Database.Cursor 비동기, 페이지 기반 대용량 처리 | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` |
| @future, future 메서드, fire and forget, callout=true | `Apex/Async(비동기)/Future 메서드.md` |
| Queueable, AllowsCallouts, 큐어블, SObject 파라미터 비동기 | `Apex/Async(비동기)/Queueable.md` |
| Queueable 체이닝, 연속 비동기, 다음 잡 실행 | `Apex/Async(비동기)/Queueable 체이닝.md` |
| Batch Apex, Database.Batchable, 대용량 처리, QueryLocator, Stateful, 수만건 처리, 배치 | `Apex/Async(비동기)/Batch Apex.md` |
| Scheduled Apex, Schedulable, 정기 실행, cron, 스케줄, 자동 실행, 매일 매주 | `Apex/Async(비동기)/Scheduled Apex.md` |

## Apex — 테스트

| 키워드 | 파일 |
|---|---|
| 테스트 전략, @isTest, TestSetup, Assert, startTest stopTest, 테스트 구조 | `Apex/Testing(테스트)/테스트 전략.md` |
| HttpCalloutMock, Callout 테스트, HTTP 모킹, Test.setMock | `Apex/Testing(테스트)/HttpCalloutMock.md` |
| StubProvider, 클래스 모킹, Test.createStub, 의존성 모킹 | `Apex/Testing(테스트)/StubProvider.md` |
| @testVisible, 회로차단기, 테스트 전용 플래그, private 접근 | `Apex/Testing(테스트)/testVisible 회로차단기.md` |
| SOSL 테스트, Test.setFixedSearchResults | `Apex/Testing(테스트)/SOSL 테스트 패턴.md` |

## Apex — Metadata Namespace

| 키워드 | 파일 |
|---|---|
| Metadata namespace, CustomMetadata, DeployCallback, DeployContainer, enqueueDeployment, CMT 배포, 메타데이터 배포 Apex, Operations.retrieve, Operations.enqueueDeployment, DeployResult, DeployStatus, 커스텀 메타데이터 레코드 생성 | `Apex/Integration(통합)/Metadata Namespace.md` |
| Compression Namespace, ZipWriter, ZipReader, ZipEntry, Apex Zip, zip 파일, 압축 Apex, addEntry, getArchive, extract, ZipWriter.getArchive, Spring 25 GA 압축 | `Apex/Integration(통합)/Compression Namespace.md` |
| DataWeave Namespace, DataWeave in Apex, DataWeave.Script, createScript, execute, DataWeave.Result, getValueAsString, dwl 스크립트, JSON 변환 Apex, XML 변환 Apex | `Apex/Integration(통합)/DataWeave Namespace.md` |
| CustomMetadataValue, fullName CMT, protected_x, CMT 필드 값 Apex, MetadataType enum | `Apex/Integration(통합)/Metadata Namespace.md` |
| KbManagement Namespace, PublishingService, Knowledge Article API, 아티클 게시 Apex, 아티클 번역 Apex, 아티클 보관 Apex, publishArticle, archiveOnlineArticle, submitForTranslation, editOnlineArticle, editArchivedArticle, restoreOldVersion, scheduleForPublication, completeTranslation, deleteDraftArticle, deleteArchivedArticle, 지식 문서 라이프사이클 | `Apex/Integration(통합)/KbManagement Namespace.md` |

## Apex — System Namespace

| 키워드 | 파일 |
|---|---|
| System Namespace, System 네임스페이스, Apex 코어 네임스페이스, AccessLevel, AccessType, Assert 클래스, AsyncInfo, AsyncOptions, Callable, Domain, FeatureManagement, UserInfo, UUID, Request class, System.debug, System.enqueueJob, System.now, System.today, System.schedule | `Architecture(아키텍처)/System Namespace.md` |
| AccessLevel.USER_MODE, AccessLevel.SYSTEM_MODE, DML 실행 모드, 보안 모드 DML, Database.insert AccessLevel | `Architecture(아키텍처)/System Namespace.md` |
| AccessType CREATABLE READABLE UPDATABLE UPSERTABLE, stripInaccessible 접근 체크 타입 | `Architecture(아키텍처)/System Namespace.md` |
| AsyncInfo 스택 깊이, AsyncOptions 중복 시그니처, QueueableDuplicateSignature, enqueueJob 파라미터 | `Architecture(아키텍처)/System Namespace.md` |
| Request.getCurrent, getQuiddity, getRequestId, 현재 요청 컨텍스트 Apex | `Architecture(아키텍처)/System Namespace.md` |
| UserInfo.getUserId, getUserEmail, getOrganizationId, getTimeZone, isMultiCurrencyOrganization, 현재 사용자 정보 Apex | `Architecture(아키텍처)/System Namespace.md` |
| UUID.randomUUID, 랜덤 UUID 생성, Version 4 UUID Apex | `Architecture(아키텍처)/System Namespace.md` |
| Callable interface, 패키지 간 느슨한 결합, Type.forName 인스턴스화, 동적 호출 Apex | `Architecture(아키텍처)/System Namespace.md` |
| FeatureManagement, checkPackageBooleanValue, checkPackageIntegerValue, checkPermission, 커스텀 퍼미션 확인, Feature Parameter | `Architecture(아키텍처)/System Namespace.md` |
| DomainCreator, getVisualforceHostname, URL.getOrgDomainUrl, URL.getSalesforceBaseUrl, Org URL 조회 | `Architecture(아키텍처)/System Namespace.md` |
| withPermissionSetId, AccessLevel 권한 세트, DML 권한 세트 지정 | `Architecture(아키텍처)/System Namespace.md` |


## Architecture — Site Namespace

| 키워드 | 파일 |
|---|---|
| Site Namespace, Site.UrlRewriter, UrlRewriter, Sites URL 재작성, Force.com Sites, URL rewriting, generateUrlFor, mapRequestUrl, SEO 친화적 URL, Salesforce Sites URL | `Architecture(아키텍처)/Site Namespace.md` |
| Site.ExternalUserCreateException, 외부 사용자 생성 예외, getDisplayMessages, 커뮤니티 사용자 생성 실패 | `Architecture(아키텍처)/Site Namespace.md` |
| Site namespace와 Experience Cloud 차이, UrlRewriter 등록 방법, Sites URL rewrite setup | `Architecture(아키텍처)/Site Namespace.md` |

## Apex — Flowtesting Namespace

| 키워드 | 파일 |
|---|---|
| flowtesting namespace, Flow Builder 테스트, Flow 단위 테스트, sf flow run test, Flow test CLI, 동적 Apex 클래스, flow test 실행 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Flow Builder flow test, Flow Interview 테스트 비교, Flow 검증, Decision 경로 테스트, Flow 출력변수 검증 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Apex에서 Flow 테스트하는 방법, flowtesting vs Flow.Interview, @isTest Flow 실행 패턴 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |

## DevOps — Salesforce DX

| 키워드 | 파일 |
|---|---|
| Salesforce DX, sfdx-project.json, sf CLI, sf project deploy, sf project retrieve, source format, .forceignore, sourceApiVersion, packageDirectories, DevOps | `DevOps(데브옵스)/Salesforce DX 개요.md` |
| Scratch Org, org create scratch, project-scratch-def.json, Dev Hub, Scratch Org 생성, Org Shape, Snapshot, org create snapshot, source tracking | `DevOps(데브옵스)/Scratch Org 패턴.md` |
| Unlocked Package, sf package create, sf package version create, sf package install, 2GP, packageAliases, org-dependent, 패키지 버전, 내부 앱 패키징 | `DevOps(데브옵스)/Unlocked Package 패턴.md` |
| CI/CD, Jenkins, Jenkinsfile, CircleCI, JWT 인증 자동화, org login jwt, 자동화 파이프라인, 지속적 통합, 패키지 CI 빌드, Connected App JWT | `DevOps(데브옵스)/CI CD 패턴.md` |

## Apex — 통합 / HTTP

| 키워드 | 파일 |
|---|---|
| RestClient, HTTP 호출 추상화, makeApiCall, HttpVerb, PATCH 우회 | `Apex/Integration(통합)/RestClient 패턴.md` |
| @RestResource, Inbound REST, HttpGet HttpPost, urlmapping, 외부→SF | `Apex/Integration(통합)/Custom REST Endpoint.md` |
| ConnectApi, Chatter 게시, postFeedItemWithRichText, Chatter 멘션, ConnectApiHelper, 리치 텍스트 피드, getCommunities, getCommunity, ConnectApi.Communities, ConnectApi.UserProfiles, getUserProfile, getPhoto, getBannerPhoto, Experience Cloud 사이트 조회, 사용자 프로필 사진 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` |
| ConnectApi Namespace, Connect in Apex, ConnectApi 개요, ChatterFeeds, ChatterGroups, ChatterUsers, EinsteinLLM, CdpQuery, ConnectApi 클래스 목록, Communities, ManagedContent, CommerceCart, 커넥트API 네임스페이스 | `Apex/Integration(통합)/ConnectApi Namespace 개요.md` |
| Dom.Document, Dom.XmlNode, XML 파싱, XML 생성, DOM XML, createRootElement, addChildElement, load, toXmlString, getChildElement, getText, SOAP XML | `Apex/Integration(통합)/Dom Namespace.md` |
| DataSource.Connection, DataSource.Provider, Salesforce Connect, External Objects, 커스텀 어댑터, sync, query, search, upsertRows, deleteRows, TableResult, UpsertResult | `Apex/Integration(통합)/DataSource Namespace.md` |
| ExternalService, OpenAPI Apex, 타입 안전 외부 호출, External Service Registration, 외부 서비스 등록, ExternalService namespace | `Apex/Integration(통합)/ExternalService Namespace.md` |
| Invocable.Action, createStandardAction, createCustomAction, Apex에서 Flow 액션 호출, 동적 액션 호출, invoke invocable, addInvocation, setInvocationParameter, getDescribe, 액션 메타데이터 | `Apex/Integration(통합)/Invocable Namespace.md` |
| Process.Plugin, PluginDescribeResult, PluginRequest, PluginResult, 레거시 플로우 플러그인, deprecated 플러그인, Flow 플러그인 Apex | `Apex/Integration(통합)/Process Namespace.md` |
| QuickAction, performQuickAction, performQuickActions, describeAvailableQuickActions, describeQuickActions, QuickActionRequest, QuickActionResult, QuickActionDefaultsHandler, SendEmailQuickActionDefaults, Case Feed 이메일 기본값, 퀵 액션 실행, 퀵 액션 메타데이터 조회 | `Apex/Integration(통합)/QuickAction Namespace.md` |

## Apex — 보안 / FLS / DML (Auth 추가)

| 키워드 | 파일 |
|---|---|
| Apex 표준 클래스, 표준 클래스 목록, Apex API 레퍼런스, 클래스 레퍼런스 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| String 메서드, String.format, String.join, String.escapeSingleQuotes, String.template, 문자열 조작 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| List 메서드, List.sort, List.add, List.remove, 리스트 정렬 | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Map 메서드, Map.get, Map.put, Map.containsKey, Map.keySet, Map.values | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Set 메서드, Set.add, Set.contains, Set.retainAll, Set.removeAll | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Database 클래스, Database.insert, Database.update, Database.query, Database.getCursor, SaveResult, UpsertResult, AccessLevel | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Crypto 클래스, 암호화, generateAESKey, encryptWithManagedIV, decryptWithManagedIV, generateDigest, generateMac, sign | `Apex/Apex 표준 클래스 레퍼런스.md` |
| JSON 클래스, JSON.serialize, JSON.deserialize, JSON.deserializeUntyped, JSON.createParser | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Schema 클래스, SObjectType, DescribeSObjectResult, DescribeFieldResult, getGlobalDescribe | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Limits 클래스, Limits.getQueries, Limits.getDMLRows, 거버너 한도 확인, 남은 DML | `Apex/Apex 표준 클래스 레퍼런스.md` |
| System 클래스, System.now, System.today, System.enqueueJob, System.scheduleBatch, System.debug | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Math 클래스, Math.max, Math.min, Math.abs, Math.random, Math.floor, Math.ceil | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Date DateTime Time, Date.today, DateTime.now, addDays addMonths daysBetween | `Apex/Apex 표준 클래스 레퍼런스.md` |
| UUID, UUID.randomUUID, Compression, Deflater, Inflater, DataWeave, DataWeaveScriptResource | `Apex/Apex 표준 클래스 레퍼런스.md` |
| Comparator, Collator, 로케일 정렬, Collator.getInstance, STRENGTH_PRIMARY | `Apex/Apex 표준 클래스 레퍼런스.md` |

## Apex — 기타

| 키워드 | 파일 |
|---|---|
| Log 싱글턴, 로깅 패턴, Logger, 디버그 로그 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| Platform Cache, 캐시, CacheBuilder, Org Cache Session Cache | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| Cache Namespace, Cache.Org, Cache.Session, Cache.OrgPartition, Cache.SessionPartition, Cache.Visibility, 플랫폼 캐시 네임스페이스, doLoad, CacheBuilder 인터페이스 | `Apex/PlatformCache(플랫폼캐시)/Cache Namespace.md` |
| OrgShape, Org 설정 조회, 샌드박스 여부, 네임스페이스 | `Apex/ExecutionContext(실행컨텍스트)/OrgShape.md` |
| QuiddityGuard, Quiddity, 실행 컨텍스트, REST Trigger Batch 구분 | `Apex/ExecutionContext(실행컨텍스트)/QuiddityGuard.md` |
| Governor Limits, 거버너 한도, 실행 한도, SOQL 한도, DML 한도, Heap size, CPU time, Callout 한도, Limits 클래스, getQueries, getDmlStatements, getLimitQueries, getLimitDmlStatements, 거버너 리밋, Apex 실행 한도, 한도 초과 예외, LimitException, Per-Transaction Limits, 비동기 동기 한도 차이, Platform Apex Limits, Static Apex Limits | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Platform Event 발행, EventBus.publish, 이벤트 트리거 수신 | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event 발행.md` |
| ChangeEventHeader, CDC, Change Data Capture, changetype, recordids, changedfields, nulledfields, 변경 데이터 캡처, TriggerContext, RetryableException, TestBroker | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| EventPublishFailureCallback, EventPublishSuccessCallback, 이벤트 발행 콜백, 발행 실패 콜백, 발행 성공 콜백, onFailure, onSuccess, getEventUuids, setResumeCheckpoint, 이벤트 부분 처리 재개, Automated Process 콜백 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Publish Callbacks.md` |
| EventBus Namespace, EventBus.publish 메서드 목록, TriggerContext, RetryableException, setResumeCheckpoint, publishWithAccessLevel, getOperationId, 이벤트버스 네임스페이스, 트리거 재시도, 이벤트 재개 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` |
| Approval.process, ProcessSubmitRequest, ProcessWorkitemRequest, 승인 제출, 승인 프로세스 Apex, Approval.lock, Approval.unlock, LockResult, UnlockResult | `Architecture(아키텍처)/Approval Namespace.md` |
| Messaging.sendEmail, SingleEmailMessage, 이메일 발송 Apex, setToAddresses, setHtmlBody, setTemplateId, setTargetObjectId, EmailFileAttachment, 첨부파일 이메일 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| CustomNotification, 커스텀 알림, 인앱 알림, Messaging.CustomNotification, setNotificationTypeId, send 알림, 알림 발송 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| Messaging Namespace, InboundEmail, InboundEmailHandler, InboundEmailResult, InboundEnvelope, 인바운드 이메일, 이메일 서비스, Email Service, ActionableNotification, MassEmailMessage, PushNotification, 인앱 알림 모바일 | `Apex/Messaging(메시징)/Messaging Namespace.md` |
| Flow.Interview, createInterview, 플로우 Apex 호출, Apex에서 Flow 실행, getVariableValue, Flow.Interview.start | `Flow/Flow Interview API.md` |
| SaveResult, UpsertResult, DeleteResult, MergeResult, UndeleteResult, EmptyRecycleBinResult, DML 결과, Database.Error, isSuccess, getErrors, getId, isCreated | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Database.Cursor, getCursor, fetch, getNumRecords, PaginationCursor, fetchPage, CursorFetchResult, QueryLocator, QueryLocatorIterator, DMLOptions, LeadConvert, convertLead | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Search.find, SOSL Apex, dynamic SOSL, SearchResult, SearchResults, getSObject, Search.suggest, SuggestionResult, KnowledgeSuggestionFilter, QuestionSuggestionFilter | `Apex/Data(데이터)/Search Namespace.md` |
| DescribeSObjectResult, DescribeFieldResult, getDescribe, getFields, isAccessible, isCreateable, getLabel, getKeyPrefix, getPicklistValues, RecordTypeInfo, getRecordTypeInfosByDeveloperName, ChildRelationship, getChildRelationships, Schema.getGlobalDescribe, DisplayType | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| Collections, CollectionUtils, 컬렉션 유틸 | `Apex/Collections(컬렉션)/CollectionUtils.md` |
| Comparator, 정렬, List.sort, 커스텀 정렬, 리스트 정렬, 오름차순 내림차순 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| Iterable, Iterator, 커스텀 이터레이터 | `Apex/Collections(컬렉션)/Iterable Iterator.md` |

## Apex — Best Practices

| 키워드 | 파일 |
|---|---|
| Apex best practices, Apex 모범 사례, Apex 베스트 프랙티스, bulkify, 벌크화, 루프 내 DML 금지, SOQL 루프 금지, 하드코딩 ID 금지, with sharing, 단일 트리거, SOQL for 루프, 모듈화, 테스트 시나리오, 중첩 루프 금지, 네이밍 컨벤션, 트리거 비즈니스 로직 금지, AuraEnabled JSON 반환 금지, Apex 코딩 표준, Apex 성능, governor limits | `Apex/Apex Best Practices.md` |

---

## Aura(오라) — Aura 컴포넌트

| 키워드 | 파일 |
|---|---|
| Aura 컴포넌트, aura:component, .cmp, Controller.js, Helper.js, aura:attribute, aura:handler, aura:registerEvent, Aura 번들 구조, aura:iteration, aura:if | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura 이벤트, Component Event, Application Event, aura:registerEvent, aura:handler, $A.get, force:navigateToSObject, force:showToast, 시스템 이벤트 init change render | `Aura(오라)/Aura 이벤트.md` |
| Aura vs LWC, Aura 마이그레이션, Aura 비교, 언제 LWC 언제 Aura, Aura 레거시, LWC 우선 정책 | `Aura(오라)/Aura vs LWC.md` |

---

## Admin(어드민) — 일반 사용자 / 관리자

| 키워드 | 파일 |
|---|---|
| Salesforce 기초, Org, Object, Record, Field, App, Tab, Cloud, 플랫폼 개요, Sales Cloud, Service Cloud, Agentforce, 환경 종류, Sandbox, Scratch Org, Developer Edition | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Salesforce 네비게이션, App Launcher, 앱 런처, 전역 검색, Global Search, 탐색바, 리스트뷰, 레코드 페이지, Lightning Experience, 홈 페이지 | `Admin(어드민)/Salesforce 네비게이션.md` |
| MFA, Multi-Factor Authentication, 다중 인증, Salesforce Authenticator, TOTP, 보안 키, FIDO2, Trusted IP Ranges, 신원 확인, 이중 인증, MFA 의무화 | `Admin(어드민)/Salesforce ID 인증.md` |

---

## Integration(통합) — 외부 시스템 연동

| 키워드 | 파일 |
|---|---|
| Named Credential, callout:, 네임드 크레덴셜, 외부 URL 인증 | `Integration(통합)/Named Credential.md` |
| CSP Trusted Site, Remote Site, 외부 이미지 로드, 외부 API 브라우저 | `Integration(통합)/CSP와 RemoteSite.md` |
| Queueable Callout, 비동기 외부 호출, DML+Callout 조합 | `Integration(통합)/Queueable + Callout 패턴.md` |
| Platform Event 통합, 이벤트 기반 통합, 시스템 간 느슨한 결합, LWC empApi | `Integration(통합)/Platform Event 통합 패턴.md` |

---

## Flow

| 키워드 | 파일 |
|---|---|
| @InvocableMethod, Flow Action, bulkInvoke, Flow에서 Apex 호출 | `Flow/@InvocableMethod 패턴.md` |
| Autolaunched Flow, 헤드리스 Flow, 레코드 CRUD Flow | `Flow/Autolaunched Flow 패턴.md` |
| Screen Flow, 다단계 마법사, 화면 Flow 설계 | `Flow/Screen Flow 설계.md` |
| Flow Screen LWC, FlowAttributeChangeEvent, @api validate, Flow 안 LWC | `Flow/Flow Screen LWC 패턴.md` |
| Flow 종류, processType, AutoLaunchedFlow, 변수 isInput isOutput | `Flow/Flow 종류와 변수.md` |
| Flow 요소, XML, recordLookups, decisions, assignments, actionCalls | `Flow/Flow 요소 참조.md` |
| 멀티 패키지, sfdx-project.json, 도메인별 패키지 | `Flow/멀티 패키지 구조.md` |
| AggregateRecordList, FilterRecords, DedupeRecordList, Flow 컬렉션 조작, Flow 리스트 필터 집계 정렬 | `Flow/Flow 레코드 컬렉션 조작.md` |
| ExecuteSOQLQuery, SaveRecordsAsync, Flow 동적 SOQL, Flow 비동기 저장, IsRecordLocked, SetRecordLock, 레코드 잠금 | `Flow/Flow 데이터 & 보안 액션.md` |
| quickChoice, Flow Screen 선택기, render() 멀티 템플릿, Custom Property Editor, 카드 라디오 드롭다운 Flow | `Flow/quickChoice Screen Component.md` |
| CalculateBusinessHours, 영업시간 계산, GetRandomValue, FormatStringListAsCsv, PostRichChatter, GenerateFlowLink, LaunchAutolaunchedFlow | `Flow/Flow 유틸리티 액션 모음.md` |
| Flow 이름 규칙, Flow 네이밍, API 이름 접두어, Get_ Update_ Insert_ APEX_ SUB_ SC01_, Flow 요소 이름, 이벤트 약어 BI BU AI AU BD | `Flow/Flow 네이밍 컨벤션.md` |
| Flow 에러 처리, faultConnector, FaultMessage, Flow fault, Flow 오류 화면, Flow 에러 이메일, 에러 로그 레코드 | `Flow/Flow 에러 처리.md` |
| Flow 베스트 프랙티스, Fast Field Update, Flow 바이패스, 하드코딩 ID 금지, Flow 거버너, Mixed DML, Asynchronous Path, Flow 서킷 브레이커, Entry Criteria, Flow Trigger Explorer | `Flow/Flow 설계 베스트 프랙티스.md` |

---

## LWC Base Components 상세 레퍼런스 (개별 페이지)

| 키워드 | 파일 |
|---|---|
| lightning-accordion 아코디언, sectiontoggle, allow-multiple-sections-open, 접고 펼치기, active-section-name | `LWC/BaseComponents(베이스컴포넌트)/lightning-accordion.md` |
| lightning-input, 입력 필드 type, text number date email checkbox toggle file search, 유효성 검사, change commit 이벤트 | `LWC/BaseComponents(베이스컴포넌트)/lightning-input.md` |
| lightning-combobox, 드롭다운 단일 선택, options 배열, label value, Picklist 드롭다운 | `LWC/BaseComponents(베이스컴포넌트)/lightning-combobox.md` |
| lightning-datatable 상세, columns type, 인라인 편집 onsave draftValues, 행 선택 rowselection, 행 액션 rowaction, 정렬 onsort, 커스텀 타입 customTypes | `LWC/BaseComponents(베이스컴포넌트)/lightning-datatable.md` |
| lightning-modal 상세, LightningModal extends, open size, close 반환값, LightningAlert LightningConfirm LightningPrompt | `LWC/BaseComponents(베이스컴포넌트)/lightning-modal.md` |
| lightning-record-form 상세, lightning-record-edit-form, lightning-record-view-form, lightning-input-field, lightning-output-field, onsubmit onsuccess onerror | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-form.md` |
| lightning-record-picker 상세, filter criteria, clearSelection, displayInfo matchingInfo, 다중 선택 pills, dynamic target | `LWC/BaseComponents(베이스컴포넌트)/lightning-record-picker.md` |
| lightning-button 상세, variant brand destructive inverse, button-icon, button-menu, menu-item, button-stateful, onselect | `LWC/BaseComponents(베이스컴포넌트)/lightning-button.md` |
| lightning-card 상세, title icon-name, actions 슬롯, footer 슬롯, variant narrow | `LWC/BaseComponents(베이스컴포넌트)/lightning-card.md` |
| lightning-spinner 상세, isLoading 패턴, alternative-text, size variant, try finally, 오버레이 스피너 | `LWC/BaseComponents(베이스컴포넌트)/lightning-spinner.md` |

## LWC Base Components (베이스 컴포넌트)

| 키워드 | 파일 |
|---|---|
| lightning-input, lightning-textarea, lightning-combobox, lightning-select, 입력 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-button, lightning-button-icon, lightning-button-menu, lightning-button-group | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-card, lightning-layout, lightning-accordion, lightning-tabset, 레이아웃 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-datatable, lightning-tree-grid, 데이터 테이블, columns 정의, key-field | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-record-form, lightning-record-edit-form, lightning-record-view-form | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-icon, 아이콘 이름, utility standard action doctype custom | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-modal, LightningModal, 모달, lightning-modal-header body footer | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-spinner, lightning-badge, lightning-avatar, lightning-progress-bar | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-formatted-number, lightning-formatted-date-time, 포맷팅 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-file-upload, 파일 업로드 컴포넌트, 첨부 파일 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-map, 지도, 위치 표시 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-breadcrumbs, lightning-vertical-navigation, 네비게이션 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| ShowToastEvent, lightning-toast, 토스트 알림 컴포넌트 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-dual-listbox, lightning-radio-group, lightning-checkbox-group, 다중선택 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning-rich-text, 리치텍스트 에디터, WYSIWYG | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| lightning/stateManager, lightning/logger, lightning/platformShowToastEvent, 유틸리티 모듈 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |
| 베이스 컴포넌트 목록, 어떤 컴포넌트 쓸지, LWC 컴포넌트 종류 | `LWC/UIPatterns(UI패턴)/Lightning Base Components 레퍼런스.md` |

---

## Release Notes (릴리즈 노트)

| 키워드 | 파일 |
|---|---|
| Summer '24, 서머 24, v61.0, 2024년 6월 릴리즈 | `Release/Summer '24.md` |
| Apex Cursor, Database.getCursor, 대용량 SOQL, 5천만 행, Cursor Beta, Batch 대안 | `Release/Summer '24.md` |
| 5단계 부모자식 SOQL, Five-Level SOQL, 관계 쿼리 깊이 | `Release/Summer '24.md` |
| Dynamic Formula Apex, FormulaEval, Formula.builder, 동적 수식 평가 | `Release/Summer '24.md` |
| InvocableVariable defaultValue placeholderText, Flow 파라미터 기본값 | `Release/Summer '24.md` |
| Data Cloud SOQL Apex, DMO Static SOQL, UnifiedIndividual__dlm, SOQL Stub | `Release/Summer '24.md` |
| Einstein Build Flow Beta, Let Einstein Build Draft Flow, AI Flow 생성 | `Release/Summer '24.md` |
| Transform Element GA, Flow 데이터 변환 정식 출시 | `Release/Summer '24.md` |
| Repeater Component GA, 반복 입력 수집, 화면 Flow 목록 생성 | `Release/Summer '24.md` |
| URL Addressable LWC, lightning__UrlAddressable, LWC URL 접근 | `Release/Summer '24.md` |
| Scratch Org Snapshot GA, 스크래치 Org 스냅샷, org create snapshot | `Release/Summer '24.md` |
| External Client App Manager, OAuth 2.0 Token Exchange, 외부 클라이언트 앱 | `Release/Summer '24.md` |
| RAG Retrieval Augmented Generation, Prompt Builder RAG, Data Cloud 벡터 검색 | `Release/Summer '24.md` |
| ICU Locale Formats Release Update, Summer 24 강제 적용, Release Updates | `Release/Summer '24.md` |
| Platform API v21-30 폐기, Streaming API 폐기, Salesforce Functions 폐기 | `Release/Summer '24.md` |
| LWC API 61.0, Light DOM Slot Forwarding, SLDS 내부 변경 | `Release/Summer '24.md` |
| Salesforce Backup 커스텀 스케줄, Event Log File Browser GA, Data Detect | `Release/Summer '24.md` |
| Einstein Copilot Topics, Prompt Builder Flex Template, Anthropic Claude 3 Haiku | `Release/Summer '24.md` |
| Search Manager GA, FLS in Search, Search Analytics Pilot | `Release/Summer '24.md` |
| Connect REST API Rate Limit, updateOnly 파라미터, External ID 업데이트 | `Release/Summer '24.md` |
| Winter '25, 윈터 25, v62.0, API 62, 2024년 10월 릴리즈 | `Release/Winter '25.md` |
| Agentforce 2.0, Einstein Copilot 리브랜드, Agentforce Studio, Copilot → Agentforce | `Release/Winter '25.md` |
| Prompt Builder GA, Flex Template, Field Generation Template, Sales Email Template | `Release/Winter '25.md` |
| Compression Namespace Beta, Zip Beta Apex, ZipWriter Beta | `Release/Winter '25.md` |
| Restrict User Access to Run Flows, Flow 실행 권한 제한, Maintenance Work Rules | `Release/Winter '25.md` |
| Spring '25, 스프링 25, v63.0, API 63, 2025년 2월 릴리즈 | `Release/Spring '25.md` |
| Compression Namespace GA, ZipWriter, ZipReader, Apex 압축 | `Release/Spring '25.md` |
| FormulaEval GA, Formula.builder, withReturnType, withFormula, 동적 수식 평가 GA | `Release/Spring '25.md` |
| System.pauseJobById, pauseJobByName, resumeJobById, resumeJobByName, 스케줄 잡 일시정지 | `Release/Spring '25.md` |
| LWC Local Dev GA, apiVersion 필수화, Base Components DOM 변경, Native Shadow | `Release/Spring '25.md` |
| Einstein for Flow GA, Transform Element Join, Send Email 첨부파일 Flow, Flow 화면 진행 표시기 | `Release/Spring '25.md` |
| Instance URL My Domain 전환 필수, na44.salesforce.com 폐기, Bulk API V2 쿼리 이벤트 | `Release/Spring '25.md` |
| SLDS 2 Beta, Lightning Design System 2, Salesforce Cosmos 테마, slds-c-* 스타일 훅 | `Release/Spring '25.md` |
| LWS API Distortion, Lightning Web Security, requestStorageAccess, setHTMLUnsafe | `Release/Spring '25.md` |
| Flow Builder 키보드 단축키, Undo Redo Save As, Flow UX 개선 | `Release/Spring '25.md` |
| Prompt Flow Subflow, Autolaunched Flow in Prompt Flow | `Release/Spring '25.md` |
| Flow Runtime 변경, Data Table 반응성, 동명 변수 상속, API v63 Runtime | `Release/Spring '25.md` |
| Automation Lightning App Monitor, Flow Interview 실패 일시정지 조회 | `Release/Spring '25.md` |
| Flow Extensions, setCustomValidity, reportValidity, Flow Screen 컴포넌트 에러 커스텀 | `Release/Spring '25.md` |
| Flow Orchestration, Fault Path, 인터랙티브 스텝 이메일 알림, Orchestration Run Details | `Release/Spring '25.md` |
| Flow Approval Processes, Queue 배정 승인, 이메일 회신 승인, 동적 승인 워크플로우 | `Release/Spring '25.md` |
| MuleSoft for Flow Integration GA, 서드파티 커넥터, Connections 탭, External System Change-Triggered Flow | `Release/Spring '25.md` |
| Agentforce DX Beta, sf agent generate agent-spec, sf agent create, agent CLI | `Release/Spring '25.md` |
| Salesforce CLI data bulk, api request rest graphql, Windows ARM64 CLI | `Release/Spring '25.md` |
| DevOps Testing GA, AI 기반 테스트, 테스트 자산 관리 | `Release/Spring '25.md` |
| Data Mask Einstein, Run on Refresh, FedRAMP High, 샌드박스 마스킹 | `Release/Spring '25.md` |
| Database Access Debug Log, Developer Console 로그 카테고리 | `Release/Spring '25.md` |
| OpenAPI Document sObjects REST API Beta, OpenAPI Specification v63 | `Release/Spring '25.md` |
| Spring '24, 서프링 24, v60.0, 이전 릴리즈 | `Release/Spring '24.md` |
| 닐 연산자 ??, UUID, ReleaseSavepoint, Null 병합 연산자 Apex | `Release/Spring '24.md` |
| lightning-record-picker GA, Workspace API GA, lightning/logger GA | `Release/Spring '24.md` |
| Template Triggered Prompt Flow, Einstein Copilot GA, Prompt Builder GA | `Release/Spring '24.md` |
| Winter '24, 윈터 24, v59.0, 2023년 10월 릴리즈 | `Release/Winter '24.md` |
| DataWeave in Apex GA, DataWeave.Script.createScript, JSON XML CSV 변환 | `Release/Winter '24.md` |
| Comparator 인터페이스, Collator 클래스, 커스텀 정렬, 로케일 정렬 | `Release/Winter '24.md` |
| Screen Flow Reactive Components GA, 반응형 컴포넌트, HTTP Callout in Flow GA | `Release/Winter '24.md` |
| Einstein Work Summaries GA, Service Replies GA, Omni-Channel 라우팅 | `Release/Winter '24.md` |
| Summer '25, 서머 25, v64.0, 2025년 6월 릴리즈 | `Release/Summer '25.md` |
| FormulaBuilder.parseAsTemplate, 동적 수식 템플릿 평가 | `Release/Summer '25.md` |
| Agentforce 3, Agent API Apex Flow, 에이전트 API 호출 | `Release/Summer '25.md` |
| flowtesting 네임스페이스, Flow Approval Process GA, Flow 승인 프로세스 | `Release/Summer '25.md` |
| Claude Sonnet 4 GPT 5 Gemini 2.5, Einstein 지원 모델, AI 모델 | `Release/Summer '25.md` |
| Winter '26, 윈터 26, v65.0, 2025년 10월 릴리즈 | `Release/Winter '26.md` |
| Test Discovery API, runTestsAsynchronous, CI/CD Apex 테스트 REST | `Release/Winter '26.md` |
| LWC Local Actions Screen Flow, LWC 로컬 액션, Flow 로컬 액션 LWC | `Release/Winter '26.md` |
| Agentforce Agent Analytics GA, New Agentforce Builder Beta, MCP Server Beta | `Release/Winter '26.md` |
| DevOps Center MCP Tools, DX MCP Server, LWC MCP Tools, AI 머지 충돌 | `Release/Winter '26.md` |
| Summer '26, 서머 26, v67.0, 2026년 6월 릴리즈, 파괴적 변경 | `Release/Summer '26.md` |
| USER_MODE 기본값 변경, WITH SECURITY_ENFORCED 폐기, Database 기본 모드 | `Release/Summer '26.md` |
| with sharing 기본값 v67.0, 공유 선언 없는 클래스, Apex 기본 sharing | `Release/Summer '26.md` |
| MCP Servers GA, Agentforce Policies, Orchestrate Other Agents Beta | `Release/Summer '26.md` |
| SAML 단일구성 마이그레이션 강제, X Twitter Auth Provider 폐기, Release Update 강제 | `Release/Summer '26.md` |
| State Managers LWC GA, lightning/stateManager, LWC 상태 관리 | `Release/Summer '26.md` |
| String.template 문자열 보간, 멀티라인 문자열 리터럴 Apex | `Release/Summer '26.md` |

---

## 자연어 질문 패턴 → 파일

| 질문 | 파일 |
|---|---|
| Apex에서 LWC로 데이터 보내는 방법 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| 자식 컴포넌트에서 부모로 데이터 전달 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
| 관계없는 컴포넌트끼리 통신 | `LWC/Events(이벤트)/Lightning Message Service.md` |
| 다른 LWC의 함수 호출 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 외부 API 호출하는 방법 | `Apex/Integration(통합)/RestClient 패턴.md` + `Integration(통합)/Named Credential.md` |
| 외부에서 Salesforce API 호출 | `Apex/Integration(통합)/Custom REST Endpoint.md` |
| Trigger에서 HTTP 호출 | `Integration(통합)/Queueable + Callout 패턴.md` |
| 레코드 저장/수정/삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 대용량 데이터 처리 | `Apex/Async(비동기)/Batch Apex.md` |
| 테스트에서 HTTP 호출 모킹 | `Apex/Testing(테스트)/HttpCalloutMock.md` |
| Flow에서 Apex 쓰는 방법 | `Flow/@InvocableMethod 패턴.md` |
| Apex에서 Flow 실행하는 방법 | `Flow/Flow Interview API.md` |
| Apex에서 이메일 보내는 방법 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| 사용자에게 알림 보내는 방법 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| 승인 프로세스 Apex로 제어 | `Architecture(아키텍처)/Approval Namespace.md` |
| CDC 트리거 변경 필드 확인 | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| DML 결과 에러 처리 방법 | `Apex/Data(데이터)/Database Namespace 상세.md` |
| 리드 전환 Apex | `Apex/Data(데이터)/Database Namespace 상세.md` |
| SOSL 검색 결과 Apex에서 | `Apex/Data(데이터)/Search Namespace.md` |
| 오브젝트 메타데이터 필드 목록 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 레코드 타입 ID 코드에서 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 피클리스트 값 Apex에서 가져오기 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 시스템 간 이벤트 연동 | `Integration(통합)/Platform Event 통합 패턴.md` |
| 레코드 삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 정렬 Apex에서 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| 스케줄 자동 실행 Apex | `Apex/Async(비동기)/Scheduled Apex.md` |
| 로그 남기는 방법 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| 캐시 사용하는 방법 | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| 공유 규칙 보안 적용 | `Apex/Security(보안)/Safely.md` |
| 데이터 조회 쿼리 | `Apex/Data(데이터)/SOQL 패턴.md` |
| 여러 오브젝트에서 키워드 검색 | `Apex/Data(데이터)/SOSL 패턴.md` |
| Aura 컴포넌트 만드는 방법 | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura에서 LWC로 전환하는 방법 | `Aura(오라)/Aura vs LWC.md` |
| Salesforce 처음 사용법 | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Salesforce 로그인 MFA 설정 | `Admin(어드민)/Salesforce ID 인증.md` |
| 앱 런처 사용 방법 | `Admin(어드민)/Salesforce 네비게이션.md` |
| Apex에서 Custom Metadata 레코드 만들기 | `Apex/Integration(통합)/Metadata Namespace.md` |
| DX 프로젝트 시작하는 방법 | `DevOps(데브옵스)/Salesforce DX 개요.md` |
| Scratch Org 만드는 방법 | `DevOps(데브옵스)/Scratch Org 패턴.md` |
| Jenkins로 Salesforce CI 구성 | `DevOps(데브옵스)/CI CD 패턴.md` |
| 패키지 만들고 설치하는 방법 | `DevOps(데브옵스)/Unlocked Package 패턴.md` |
| Knowledge 아티클 Apex로 게시하는 방법 | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 번역 제출 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 보관 스케줄 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
