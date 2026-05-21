---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — Apex 코어
> Apex 언어·데이터/SOQL·비동기·보안·테스트·System·Schema·트리거·컬렉션·한도·표준클래스 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## 플랫폼 한도 / API 한도

| 키워드 | 파일 |
|---|---|
| Governor Limits 빠른 참조, API 한도, Concurrent API, 동시 API 요청, Total API 호출 수, 일일 API 한도, API 요청 할당, Enterprise API 한도, Unlimited API 한도 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Bulk API 한도, Bulk API 2.0 한도, 배치 할당, Ingest Job 한도, Query Job 한도, 15000 배치, 150000000 레코드, Bulk API 파일 크기 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOAP API 한도, create 200, merge 200, describeSObjects 100, query 배치 크기 2000, SOAP call limit | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| Metadata 한도, 배포 파일 10000, zip 39MB, 600MB, Change Set 10000, rootTypesWithDependencies | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOQL 쿼리 길이, SOQL 100000자, junction IDs 500, WHERE 절 4000자, 관계 쿼리 한도, child-to-parent 55, parent-to-child 20, 5단계 깊이 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |
| SOQL query timeout 32분, QUERY_TOO_COMPLICATED, Visualforce 한도, VF 뷰스테이트 170KB, VF 응답 15MB, StandardSetController 10000 | `Apex/ExecutionContext(실행컨텍스트)/Governor Limits.md` |

## Apex — 아키텍처 / 트리거

| 키워드 | 파일 |
|---|---|
| 서비스 레이어, ServiceLayer, TriggerHandler, Trigger 계층, 비즈니스 로직 분리 | `Architecture(아키텍처)/서비스 레이어 패턴.md` |
| TriggerHandler, beforeInsert afterInsert, Trigger.new, 트리거 패턴 | `Apex/Trigger(트리거)/TriggerHandler 패턴.md` |
| CMDT, Custom Metadata, 트리거 on/off, 메타데이터 트리거 제어 | `Apex/Trigger(트리거)/CMDT 메타데이터 트리거.md` |
| Custom Metadata Types 상세, __mdt, CustomMetadata__mdt, getAll, getInstance, 커스텀 메타데이터 Apex 조회, Metadata.CustomMetadata, Metadata.DeployContainer, enqueueDeployment, CMDT 배포, CMDT 캐시, 커스텀 메타데이터 타입 vs 커스텀 설정, 기능 플래그, Feature Flag, 요율표, 매핑 테이블, Protected Custom Metadata | `Architecture(아키텍처)/Custom Metadata Types.md` |
| Permission Set, 권한 설계 | `Architecture(아키텍처)/Permission Set 설계.md` |
| Validation Rules, 검증 규칙, REGEX 수식, SSN 형식 검증, 우편번호 ZIP 검증, 전화번호 검증, 날짜 검증 평일, 숫자 MOD 짝수 홀수, 소유자 검증, ISCHANGED, PRIORVALUE, ISNEW, ISPICKVAL, ISNUMBER, VLOOKUP 역할 한도, $User 커스텀 필드, $Profile.Name, 크로스 오브젝트 검증, IP 주소 검증, 신용카드 번호 검증, California 운전면허, 계정 번호 검증, 연간 매출 범위 | `Architecture(아키텍처)/Validation Rules 예제.md` |

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
| TxnSecurity.EventCondition, TxnSecurity.AsyncCondition, Transaction Security Apex, 트랜잭션 보안 정책, evaluate() 정책 조건, Real-Time Event Monitoring 보안, ApiEvent 차단, 로그인 이벤트 차단, 실시간 이벤트 보안 정책, Apex 보안 정책 | `Apex/Security(보안)/TxnSecurity Namespace.md` |
| TxnSecurity.PolicyCondition, TxnSecurity.Event, 레거시 트랜잭션 보안, PolicyCondition evaluate, 구형 트랜잭션 보안 | `Apex/Security(보안)/TxnSecurity Namespace.md` |
| UserProvisioning Namespace, UserProvisioningLog, UserProvisioningPlugin, ConnectorTestUtil, 사용자 프로비저닝 Apex, 커넥티드 앱 프로비저닝, SCIM 프로비저닝, 아웃바운드 프로비저닝 | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| UserProvisioning.UserProvisioningLog.log, 프로비저닝 로그, UPR 로깅, userProvisioningRequestId externalUserId | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| UserProvisioningPlugin invoke buildDescribeCall, Process.PluginResult, reconOffset nextReconOffset reconState, 10000 DML 한도 우회 프로비저닝, Flow Builder 프로비저닝 플러그인 | `Apex/Security(보안)/UserProvisioning Namespace.md` |
| ConnectorTestUtil.createConnectedApp, 프로비저닝 테스트, UserProvisioningRequest, @isTest 커넥티드 앱 시뮬레이션 | `Apex/Security(보안)/UserProvisioning Namespace.md` |

## Apex — 데이터 / SOQL

| 키워드 | 파일 |
|---|---|
| SOQL, 쿼리 패턴, 벌크 쿼리, 거버너 한도, Database.query, 데이터 조회, SELECT FROM WHERE | `Apex/Data(데이터)/SOQL 패턴.md` |
| SOQL 문법 레퍼런스, SOQL SELECT 전체 문법, FIELDS ALL CUSTOM STANDARD, 날짜 리터럴, TODAY YESTERDAY LAST_N_DAYS THIS_FISCAL_YEAR, 날짜 함수, CALENDAR_YEAR DAY_ONLY HOUR_IN_DAY, GROUP BY ROLLUP CUBE, GROUPING 함수, 세미조인, 안티조인, 관계 쿼리, 자식→부모 dot, 부모→자식 서브쿼리, TYPEOF 다형성, TYPEOF 제한사항, USING SCOPE, ContentDocumentLink 제한, Big Object 쿼리, SOQL 오브젝트 제한, FORMAT() SOQL, toLabel() SOQL, convertCurrency() SOQL, DISTANCE GEOLOCATION 위치 기반 쿼리, Location-Based SOQL, 관계 쿼리 제한사항, child-to-parent 55개 제한, KnowledgeArticleVersion 바인딩변수 불가, Data 360 SOQL 제한, UserRecordAccess 쿼리, Vote 쿼리, ContentHubItem 쿼리 | `Apex/Data(데이터)/SOQL 문법 레퍼런스.md` |
| SOSL, FIND 구문, 전문 검색, IN NAME FIELDS, RETURNING, 여러 오브젝트 검색, List<List<SObject>>, WITH SNIPPET, WITH HIGHLIGHT, SOSL 레퍼런스, SOSL 전체 문법, FIND 와일드카드, SOSL 예약문자 이스케이프, SearchQuery 문자수 제한, SOSL ORDER BY, SOSL OFFSET, SOSL FORMAT(), SOSL toLabel, SOSL convertCurrency, USING Listview SOSL, UPDATE TRACKING SOSL, UPDATE VIEWSTAT SOSL, WITH HIGHLIGHT 지원 필드, WITH METADATA LABELS, WITH DivisionFilter, WITH PricebookId, WITH SPELL_CORRECTION, SOSL 검색 알고리즘, SOSL External Object 제한, SOSL WHERE 연산자, SOSL 이스케이프 시퀀스, SOSL vs SOQL | `Apex/Data(데이터)/SOSL 패턴.md` |
| FormulaEval, Formula.builder, 동적 수식 평가, 포뮬러 필드 재계산, DML 없이 수식 계산, getReferencedFields, 수식 평가 Apex, 템플릿 수식, FormulaReturnType, FormulaGlobal | `Apex/Data(데이터)/FormulaEval Namespace.md` |
| Reports namespace, ReportManager, runReport, runAsyncReport, ReportResults, ReportMetadata, ReportFact, ReportFactWithDetails, SummaryValue, FactMap, 보고서 Apex 실행, 비동기 보고서, 보고서 필터 재정의, getFactMap, ReportFilter, BucketField, ReportInstance | `Apex/Data(데이터)/Reports Namespace.md` |
| BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 준수 여부, 업무시간 경과, isWithin, nextStartDate, SLA 초과 | `Apex/Data(데이터)/BusinessHours 패턴.md` |
| Datacloud Namespace, Datacloud.FindDuplicates, FindDuplicatesByIds, DuplicateResult, MatchResult, MatchRecord, FieldDiff, findDuplicates, 중복 레코드 탐지 Apex, Duplicate Management Apex, 중복 규칙 Apex, 중복 차단 처리, DuplicateError 처리, 레코드 중복 검사 | `Apex/Data(데이터)/Datacloud Namespace.md` |
| Wave Namespace, wave namespace, CRM Analytics SDK, SAQL 빌더, SAQL 쿼리 Apex, QueryBuilder, QueryNode, ProjectionNode, CRM Analytics 쿼리 Apex, 애널리틱스 쿼리 | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.QueryBuilder.load, Wave.QueryBuilder.count, Wave.QueryBuilder.get, union, cogroup, 데이터셋 스트림 로드, SAQL union cogroup Apex | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.QueryNode, build, foreach, group by all, order SAQL, cap, filter predicate, execute ConnectApi.LiteralJson | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.ProjectionNode, sum avg min max unique alias, 집계 함수 체이닝 Apex, SAQL projection | `Apex/Data(데이터)/Wave Namespace.md` |
| Wave.Templates, getTemplate, getTemplateConfig, getTemplates, TemplatesSearchOptions, CRM Analytics 템플릿 조회, filterGroup options type | `Apex/Data(데이터)/Wave Namespace.md` |
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


## Apex — Flowtesting Namespace

| 키워드 | 파일 |
|---|---|
| flowtesting namespace, Flow Builder 테스트, Flow 단위 테스트, sf flow run test, Flow test CLI, 동적 Apex 클래스, flow test 실행 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Flow Builder flow test, Flow Interview 테스트 비교, Flow 검증, Decision 경로 테스트, Flow 출력변수 검증 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |
| Apex에서 Flow 테스트하는 방법, flowtesting vs Flow.Interview, @isTest Flow 실행 패턴 | `Apex/Testing(테스트)/Flowtesting Namespace.md` |

## Apex — 표준 클래스 레퍼런스

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
| Change Data Capture 개발자 가이드, CDC 설정, CDC 구독 채널, AccountChangeEvent, ChangeEvent 트리거, after insert CDC, Automated Process 트리거, CDC 테스트 enableChangeDataCapture, Test.getEventBus().deliver, Gap Event, Overflow Event, GAP_OVERFLOW, 병합 이벤트, CDC 할당 한도, CDC 이벤트 전달 한도, 50000 이벤트, 25000 이벤트, CDC 보안 권한, EventBusSubscriber, CDC FLS, 실시간 데이터 동기화, CDC Reliability, replayId, 이벤트 신뢰성, 이벤트 보강, EnrichedFields, PlatformEventChannelMember enrichedFields, 필터 스트림, FilterExpression, 커스텀 채널 필터, 트랜잭션 복제, transactionKey sequenceNumber, 복합 필드 변경 이벤트, BillingAddress compound field, Pub/Sub API CDC, gRPC Avro 변경 이벤트, PlatformEventUsageMetric, CHANGE_EVENTS_DELIVERED, 이벤트 사용량 모니터링, diffFields, 대용량 텍스트 diff, 유니파이드 diff SHA-256, 표준 오브젝트 노트, Person Account 변경 이벤트, Lead Conversion 변경 이벤트, PricebookEntry CREATE, User preferences 변경 이벤트, GroupEventType 반복 활동, Event Invitees 이벤트, CDC 애드온 라이선스, 이벤트 전달 계산, API 버전 스키마, GetSchema RPC, 이벤트 스키마 조회 | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| EventPublishFailureCallback, EventPublishSuccessCallback, 이벤트 발행 콜백, 발행 실패 콜백, 발행 성공 콜백, onFailure, onSuccess, getEventUuids, setResumeCheckpoint, 이벤트 부분 처리 재개, Automated Process 콜백 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Publish Callbacks.md` |
| EventBus Namespace, EventBus.publish 메서드 목록, TriggerContext, RetryableException, setResumeCheckpoint, publishWithAccessLevel, getOperationId, 이벤트버스 네임스페이스, 트리거 재시도, 이벤트 재개 | `Apex/PlatformEvents(플랫폼이벤트)/EventBus Namespace.md` |
| Approval.process, ProcessSubmitRequest, ProcessWorkitemRequest, 승인 제출, 승인 프로세스 Apex, Approval.lock, Approval.unlock, LockResult, UnlockResult | `Architecture(아키텍처)/Approval Namespace.md` |
| Messaging.sendEmail, SingleEmailMessage, 이메일 발송 Apex, setToAddresses, setHtmlBody, setTemplateId, setTargetObjectId, EmailFileAttachment, 첨부파일 이메일 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| CustomNotification, 커스텀 알림, 인앱 알림, Messaging.CustomNotification, setNotificationTypeId, send 알림, 알림 발송 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| Messaging Namespace, InboundEmail, InboundEmailHandler, InboundEmailResult, InboundEnvelope, 인바운드 이메일, 이메일 서비스, Email Service, ActionableNotification, MassEmailMessage, PushNotification, 인앱 알림 모바일 | `Apex/Messaging(메시징)/Messaging Namespace.md` |
| Flow.Interview, createInterview, 플로우 Apex 호출, Apex에서 Flow 실행, getVariableValue, Flow.Interview.start | `Flow/Flow Interview API.md` |
| SaveResult, UpsertResult, DeleteResult, MergeResult, UndeleteResult, EmptyRecycleBinResult, DML 결과, Database.Error, isSuccess, getErrors, getId, isCreated | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Database.Cursor, getCursor, fetch, getNumRecords, PaginationCursor, fetchPage, CursorFetchResult, QueryLocator, QueryLocatorIterator, hasNext, next, DMLOptions, LeadConvert, convertLead | `Apex/Data(데이터)/Database Namespace 상세.md` |
| DMLOptions.AssignmentRuleHeader, useDefaultRule, assignmentRuleId, 배정 규칙, DMLOptions.DuplicateRuleHeader, allowSave, runAsCurrentUser, DMLOptions.EmailHeader, triggerAutoResponseEmail, localeOptions | `Apex/Data(데이터)/Database Namespace 상세.md` |
| Search.find, SOSL Apex, dynamic SOSL, SearchResult, SearchResults, getSObject, Search.suggest, SuggestionResult, KnowledgeSuggestionFilter, QuestionSuggestionFilter | `Apex/Data(데이터)/Search Namespace.md` |
| DescribeSObjectResult, DescribeFieldResult, getDescribe, getFields, isAccessible, isCreateable, getLabel, getKeyPrefix, getPicklistValues, RecordTypeInfo, getRecordTypeInfosByDeveloperName, ChildRelationship, getChildRelationships, Schema.getGlobalDescribe, DisplayType | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| SObjectType, SObjectField, newSObject, SObjectDescribeOptions, FieldDescribeOptions, SOAPType, SOAPType Enum, DescribeTabResult, DescribeTabSetResult, describeTabs, DataCategory, DescribeDataCategoryGroupResult, describeDataCategoryGroups, DescribeColorResult, DescribeIconResult | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| getAssociateEntityType, getAssociateParentEntity, isMruEnabled, getDataTranslationEnabled, getController 피클리스트, isDefaultedOnCreate, isHtmlFormatted, isIdLookup, isWriteRequiresMasterRead, isSearchPrefilterable | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| Collections, CollectionUtils, 컬렉션 유틸 | `Apex/Collections(컬렉션)/CollectionUtils.md` |
| Comparator, 정렬, List.sort, 커스텀 정렬, 리스트 정렬, 오름차순 내림차순 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| Iterable, Iterator, 커스텀 이터레이터 | `Apex/Collections(컬렉션)/Iterable Iterator.md` |

## Apex — Best Practices

| 키워드 | 파일 |
|---|---|
| Apex best practices, Apex 모범 사례, Apex 베스트 프랙티스, bulkify, 벌크화, 루프 내 DML 금지, SOQL 루프 금지, 하드코딩 ID 금지, with sharing, 단일 트리거, SOQL for 루프, 모듈화, 테스트 시나리오, 중첩 루프 금지, 네이밍 컨벤션, 트리거 비즈니스 로직 금지, AuraEnabled JSON 반환 금지, Apex 코딩 표준, Apex 성능, governor limits | `Apex/Apex Best Practices.md` |

---

