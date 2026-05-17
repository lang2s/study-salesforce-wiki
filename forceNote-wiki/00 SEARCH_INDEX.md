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

---

## Apex — 아키텍처 / 트리거

| 키워드 | 파일 |
|---|---|
| 서비스 레이어, ServiceLayer, TriggerHandler, Trigger 계층, 비즈니스 로직 분리 | `Apex/Architecture(아키텍처)/서비스 레이어 패턴.md` |
| TriggerHandler, beforeInsert afterInsert, Trigger.new, 트리거 패턴 | `Apex/Trigger(트리거)/TriggerHandler 패턴.md` |
| CMDT, Custom Metadata, 트리거 on/off, 메타데이터 트리거 제어 | `Apex/Trigger(트리거)/CMDT 메타데이터 트리거.md` |
| Permission Set, 권한 설계 | `Apex/Architecture(아키텍처)/Permission Set 설계.md` |

## Apex — 보안 / FLS / DML

| 키워드 | 파일 |
|---|---|
| Safely, FLS, CRUD 보안, with sharing, 안전한 DML, 필드 레벨 보안, 공유 규칙 | `Apex/Security(보안)/Safely.md` |
| CanTheUser, 권한 확인, 삭제 가능 여부, isUpdatable | `Apex/Security(보안)/CanTheUser.md` |
| StripInaccessible, 접근 불가 필드 제거, POST 바디 보안 | `Apex/Security(보안)/StripInaccessible.md` |
| WITH USER_MODE, USER_MODE, SYSTEM_MODE, SOQL 보안 모드 | `Apex/Security(보안)/WITH USER_MODE.md` |
| DML, insert update delete, allOrNothing, SaveResult, 부분 성공 | `Apex/Data(데이터)/DML 패턴.md` |

## Apex — 데이터 / SOQL

| 키워드 | 파일 |
|---|---|
| SOQL, 쿼리 패턴, 벌크 쿼리, 거버너 한도, Database.query, 데이터 조회, SELECT FROM WHERE | `Apex/Data(데이터)/SOQL 패턴.md` |
| BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 준수 여부, 업무시간 경과, isWithin, nextStartDate, SLA 초과 | `Apex/Data(데이터)/BusinessHours 패턴.md` |
| Dynamic SOQL, 동적 쿼리, String.escapeSingleQuotes, 바인딩 변수 | `Apex/Data(데이터)/Dynamic SOQL.md` |
| 페이징, PagedResult, 오프셋, OFFSET LIMIT, 페이지네이션 | `Apex/Data(데이터)/PagedResult 패턴.md` |

## Apex — 비동기

| 키워드 | 파일 |
|---|---|
| 비동기 선택, 언제 future 언제 queueable 언제 batch | `Apex/Async(비동기)/비동기 컨텍스트 선택.md` |
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

## Apex — 통합 / HTTP

| 키워드 | 파일 |
|---|---|
| RestClient, HTTP 호출 추상화, makeApiCall, HttpVerb, PATCH 우회 | `Apex/Integration(통합)/RestClient 패턴.md` |
| @RestResource, Inbound REST, HttpGet HttpPost, urlmapping, 외부→SF | `Apex/Integration(통합)/Custom REST Endpoint.md` |
| ConnectApi, Chatter 게시, postFeedItemWithRichText, Chatter 멘션, ConnectApiHelper, 리치 텍스트 피드 | `Apex/Integration(통합)/ConnectApi Chatter 패턴.md` |

## Apex — 기타

| 키워드 | 파일 |
|---|---|
| Log 싱글턴, 로깅 패턴, Logger, 디버그 로그 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| Platform Cache, 캐시, CacheBuilder, Org Cache Session Cache | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| OrgShape, Org 설정 조회, 샌드박스 여부, 네임스페이스 | `Apex/ExecutionContext(실행컨텍스트)/OrgShape.md` |
| QuiddityGuard, Quiddity, 실행 컨텍스트, REST Trigger Batch 구분 | `Apex/ExecutionContext(실행컨텍스트)/QuiddityGuard.md` |
| Platform Event 발행, EventBus.publish, 이벤트 트리거 수신 | `Apex/PlatformEvents(플랫폼이벤트)/Platform Event 발행.md` |
| Collections, CollectionUtils, 컬렉션 유틸 | `Apex/Collections(컬렉션)/CollectionUtils.md` |
| Comparator, 정렬, List.sort, 커스텀 정렬, 리스트 정렬, 오름차순 내림차순 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| Iterable, Iterator, 커스텀 이터레이터 | `Apex/Collections(컬렉션)/Iterable Iterator.md` |

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
| 시스템 간 이벤트 연동 | `Integration(통합)/Platform Event 통합 패턴.md` |
| 레코드 삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 정렬 Apex에서 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| 스케줄 자동 실행 Apex | `Apex/Async(비동기)/Scheduled Apex.md` |
| 로그 남기는 방법 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| 캐시 사용하는 방법 | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| 공유 규칙 보안 적용 | `Apex/Security(보안)/Safely.md` |
| 데이터 조회 쿼리 | `Apex/Data(데이터)/SOQL 패턴.md` |
