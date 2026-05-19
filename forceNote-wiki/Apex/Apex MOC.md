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

## 🔒 보안

- [[Safely]] — DML Fluent API (allOrNothing, throwIfRemovedFields)
- [[CanTheUser]] — CRUD/FLS 체크 (create/edit/destroy/flsAccessible)
- [[StripInaccessible]] — AccessType별 FLS 필드 제거
- [[WITH USER_MODE]] — SOQL/DML 인라인 보안 키워드
- [[Auth Namespace]] — JWT/JWS OAuth bearer token flow, MFA TOTP, SessionManagement, RegistrationHandler
- [[TxnSecurity Namespace]] — EventCondition/AsyncCondition으로 Transaction Security Policy Apex 구현, Real-Time Event Monitoring 기반 차단·알림 정책

## 📊 데이터 (SOQL / DML)

- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop, 청크 반복
- [[SOSL 패턴]] — FIND 구문, IN SearchGroup, RETURNING, 여러 Object 전문 검색
- [[DML 패턴]] — insert as user/system, Database.*(accessLevel)
- [[Dynamic SOQL]] — queryWithBinds, SOQL 인젝션 방어
- [[PagedResult 패턴]] — 페이지네이션 DTO, scope='global', ?? null coalescing, LIMIT+OFFSET
- [[BusinessHours 패턴]] — BusinessHours.diff(), isWithin(), nextStartDate(), SLA 경과 시간 계산
- [[Database Namespace 상세]] — SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert
- [[Search Namespace]] — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter
- [[FormulaEval Namespace]] — Formula.builder() 동적 수식 평가, getReferencedFields(), 템플릿 모드
- [[Reports Namespace]] — ReportManager.runReport/runAsyncReport, ReportMetadata 필터 재정의, FactMap 탐색

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
- [[KbManagement Namespace]] — KbManagement.PublishingService, 아티클 게시·번역·보관·삭제 라이프사이클 API
- [[Flow Namespace]] — Flow.Interview 클래스 — Apex에서 Flow 실행, createInterview(정적/동적), start(), getVariableValue()

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
