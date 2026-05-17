---
tags: [apex, moc, index]
created: 2026-05-17
---

# Apex — Map of Content

> 출처: [apex-recipes](https://github.com/trailheadapps/apex-recipes) (Salesforce 공식 학습 앱) 74개 클래스 분석

---

## 🏗 아키텍처 패턴

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

## 📊 데이터 (SOQL / DML)

- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop, 청크 반복
- [[DML 패턴]] — insert as user/system, Database.*(accessLevel)
- [[Dynamic SOQL]] — queryWithBinds, SOQL 인젝션 방어
- [[PagedResult 패턴]] — 페이지네이션 DTO, scope='global', ?? null coalescing, LIMIT+OFFSET
- [[BusinessHours 패턴]] — BusinessHours.diff(), isWithin(), nextStartDate(), SLA 경과 시간 계산
- [[Database Namespace 상세]] — SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert
- [[Search Namespace]] — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter

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
- [[Dom Namespace]] — Dom.Document/XmlNode, XML 생성·파싱, HTTP 본문 처리
- [[DataSource Namespace]] — Salesforce Connect 커스텀 어댑터, Provider/Connection/sync/query/upsert
- [[ExternalService Namespace]] — OpenAPI 스펙 기반 타입 안전 외부 서비스 호출

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

## 🔭 실행 컨텍스트

- [[QuiddityGuard]] — trusted/untrusted Quiddity, testQuiddityOverride
- [[OrgShape]] — isSandbox, isMultiCurrencyEnabled, isPersonAccountEnabled

## 📋 로깅

- [[Log 싱글턴 패턴]] — add() 버퍼 → publish() 일괄 발행

## 📡 플랫폼 이벤트

- [[Platform Event 발행]] — EventBus.publish, 수신 트리거, ReplayId
- [[ChangeEventHeader]] — CDC 변경 이벤트 헤더, changetype/recordids/changedfields, TriggerContext

## 💾 플랫폼 캐시

- [[Platform Cache]] — Cache.Org/Session, Cache-Aside 패턴, @CacheBuilder

## 📨 메시징

- [[SingleEmailMessage]] — Apex에서 단일 이메일 발송, setToAddresses, setTemplateId, 첨부파일
- [[CustomNotification]] — 인앱 알림, setNotificationTypeId, send(), Actionable Notification

## 🏗 승인 프로세스 / 스키마

- [[Approval Namespace]] — ProcessSubmitRequest, ProcessWorkitemRequest, lock/unlock, LockResult
- [[Schema Namespace 상세]] — DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship

## 📖 레퍼런스

- [[Apex 표준 클래스 레퍼런스]] — String / List / Map / Database / Crypto / JSON / Schema / Limits 전체 API 빠른 참조

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
외부 모킹?             →  [[StubProvider]]
```
