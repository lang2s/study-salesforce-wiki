---
tags: [home, index, salesforce]
created: 2026-05-17
---

# Salesforce 개발자 두 번째 뇌

> Salesforce 공식 프로젝트(apex-recipes, lwc-recipes, dreamhouse-lwc 등) 분석 기반의 검증된 패턴 모음.

---

## 📂 카테고리

### [[Apex MOC|Apex]]
Salesforce Apex 백엔드 개발 — 패턴, 보안, 테스트, 비동기, 통합

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[비동기 컨텍스트 선택]] | @future, Queueable, Batch, Scheduled |
| [[DML 패턴]] | insert as user, Safely, AccessLevel |
| [[SOQL 패턴]] | WITH USER_MODE, SOQL for loop |
| [[Dynamic SOQL]] | queryWithBinds, 인젝션 방어 |
| [[TriggerHandler 패턴]] | abstract class, bypass, ServiceLayer |
| [[CMDT 메타데이터 트리거]] | MetadataTriggerHandler, 동적 디스패치 |
| [[Safely]] | DML Fluent API |
| [[CanTheUser]] | CRUD 체크 |
| [[StripInaccessible]] | AccessType, FLS 필드 제거 |
| [[RestClient 패턴]] | virtual class, Named Credential, PATCH 우회 |
| [[Custom REST Endpoint]] | @RestResource, global, RestContext |
| [[Comparator 인터페이스]] | List.sort, null 처리, ASCENDING/DESCENDING |
| [[StubProvider]] | System.StubProvider, Test.createStub |
| [[testVisible 회로차단기]] | @testVisible, Boolean/Exception 회로 차단기 |
| [[QuiddityGuard]] | 실행 컨텍스트 가드, trusted/untrusted |
| [[Log 싱글턴 패턴]] | add/publish, Platform Event 기반 |
| [[서비스 레이어 패턴]] | TriggerHandler-ServiceLayer 브로커 |

### [[LWC MOC|LWC]]
Lightning Web Component — Wire 어댑터, LDS, 컴포넌트 통신, Flow Screen

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Wire vs Imperative 선택]] | @wire, async/await, 결정 매트릭스 |
| [[Wire 패턴]] | property/function 바인딩, reactive $변수 |
| [[Imperative 호출 패턴]] | try/catch/finally, isLoading |
| [[@api 패턴]] | property, method, getter/setter, lwc:spread |
| [[CustomEvent 패턴]] | detail, bubbles, composed |
| [[Lightning Message Service]] | publish/subscribe, MessageContext |
| [[Record Form 선택]] | record-form vs edit-form vs view-form |
| [[ldsUtils reduceErrors]] | 8가지 에러 타입 정규화 |
| [[LWC 보안 패턴]] | customPermission, CSP, DOM XSS |
| [[Flow Screen LWC 패턴]] | FlowAttributeChangeEvent, validate() |
| [[모바일 기능 패턴]] | getBarcodeScanner, getLocationService, isAvailable() |
| [[Static Resource 로딩]] | loadScript/loadStyle, renderedCallback 3-state |
| [[파일 업로드와 이미지 처리]] | processImage, refreshApex, ContentVersion |

### [[Flow MOC|Flow]]
Salesforce Flow — 자동화, Screen Flow, Autolaunched Flow, Apex 액션

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Flow 종류와 변수]] | processType, isInput/isOutput, $Flow |
| [[Flow 요소 참조]] | recordLookups/Creates/decisions/actionCalls |
| [[Screen Flow 설계]] | flowruntime:, LWC 삽입, faultConnector |
| [[Autolaunched Flow 패턴]] | 헤드리스, Agent Action, Apex에서 호출 |
| [[@InvocableMethod 패턴]] | bulkInvoke, InputParameters, OutputParameters |

### Architecture(아키텍처)
설계 패턴 / 플랫폼 기초 개념 — 서비스 레이어, 권한 설계, Salesforce 개요

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce 플랫폼 개요]] | Org, Object, Record, Cloud 종류, 환경 |
| [[서비스 레이어 패턴]] | TriggerHandler-ServiceLayer 브로커 |
| [[Permission Set 설계]] | objectPermissions, fieldPermissions |
| [[Approval Namespace]] | ProcessSubmitRequest, ProcessWorkitemRequest |
| [[Schema Namespace 상세]] | DescribeSObjectResult, RecordTypeInfo |

### Aura(오라)
Aura 컴포넌트 — 레거시 컴포넌트 프레임워크 (신규 개발은 LWC 권장)

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Aura 컴포넌트 구조]] | aura:component, Controller/Helper 번들 |
| [[Aura 이벤트]] | Component/Application Event, $A.get |
| [[Aura vs LWC]] | 기능 비교, 마이그레이션 전략 |

### Admin(어드민)
일반 사용자 / 관리자 가이드 — 네비게이션, 인증, 기초 개념

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce 네비게이션]] | App Launcher, 전역 검색, 리스트뷰 |
| [[Salesforce ID 인증]] | MFA, Salesforce Authenticator, Trusted IP |

### DevOps(데브옵스)
Salesforce DX — 소스 중심 개발, Scratch Org, Unlocked Package, CI/CD

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Salesforce DX 개요]] | sfdx-project.json, sf CLI, Source Format |
| [[Scratch Org 패턴]] | Dev Hub, org create scratch, Snapshot |
| [[Unlocked Package 패턴]] | sf package create/install, 2GP |
| [[CI CD 패턴]] | Jenkins, CircleCI, JWT 인증 자동화 |
| [[2GP — Prepare to Distribute]] | sf package version promote, AppExchange 등록, 코드 커버리지 75%, Installation Key |

### [[통합 MOC|Integration(통합)]]
외부 시스템 연동 — Named Credential, Callout, REST/SOAP

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Named Credential]] | External Credential, callout: 접두어 |
| [[RestClient 패턴]] | virtual class, PATCH 우회 |
| [[CSP와 RemoteSite]] | CspTrustedSite, RemoteSiteSetting, LWC vs Apex 외부 연동 |
| [[Custom REST Endpoint]] | @RestResource, RestContext |

### [[sObject/index|sObject Reference]]
Salesforce Platform Object Reference v67.0 — Field 타입, Object 그룹, 표준 Object 카탈로그

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[1 Overview]] | Primitive 타입, Field 타입, Compound Fields, Big Objects, External Objects |
| [[2 Object Behavior]] | Object 그룹, Data Cloud, DLO·DMO·CIO·DG, Object Types 접미사 |
| [[3 Associated Objects]] | Feed·History·Share·OwnerSharingRule·ChangeEvent(CDC) 패턴 |
| [[4 Custom Objects]] | __mdt 필드, __c 표준 필드, __Feed 표준 필드 |
| [[5 Object Interfaces]] | PriceAdjustmentGroup·PriceAdjustmentItem·SalesTransaction |
| [[6 Standard Objects]] | Account·Case·Opportunity·ApexClass 등 도메인별 카탈로그 |

### [[_active/index|Active — 진행 중]]
지금 집중해서 공부 중인 노트. 완성되면 도메인 폴더로 이동.

---

### [[Release MOC|Release Notes]]
Salesforce 연 3회 릴리즈 추적 — 신규 기능, Deprecated, 거버너 한도 변경

| 릴리즈 | API 버전 | 상태 |
|---|---|---|
| [[Summer '26]] | v67.0 | ✅ |
| [[Winter '26]] | v65.0 | ✅ |
| [[Summer '25]] | v64.0 | ✅ |
| [[Spring '25]] | v63.0 | ✅ |
| [[Winter '25]] | v62.0 | ✅ |
| [[Summer '24]] | v61.0 | ✅ |
| [[Spring '24]] | v60.0 | ✅ |
| [[Winter '24]] | v59.0 | ✅ |

---

## 🔖 태그 인덱스

- `#pattern` — 검증된 구현 패턴
- `#anti-pattern` — 피해야 할 구현
- `#decision` — 의사결정 매트릭스
- `#security` — 보안 관련
- `#async` — 비동기 처리
- `#testing` — 테스트 패턴
- `#integration` — 외부 연동
- `#release/apex` — Apex 릴리즈 변경
- `#release/lwc` — LWC 릴리즈 변경
- `#release/flow` — Flow 릴리즈 변경
- `#release/deprecated` — Deprecated 항목

---

## 📌 자주 찾는 패턴

| 상황 | 바로가기 |
|---|---|
| DML 앞에 보안 적용 | [[Safely]] · [[StripInaccessible]] |
| 비동기 방식 선택 | [[비동기 컨텍스트 선택]] |
| 동적 SOQL 안전하게 | [[Dynamic SOQL]] |
| 트리거 구조 잡기 | [[TriggerHandler 패턴]] |
| HTTP 호출 추상화 | [[RestClient 패턴]] |
| 외부 의존성 모킹 | [[StubProvider]] |
| 실행 환경 확인 | [[QuiddityGuard]] · [[OrgShape]] |
