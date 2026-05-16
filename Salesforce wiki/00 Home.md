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

### [[Flow MOC|Flow]]
Salesforce Flow — 자동화, Screen Flow, Autolaunched Flow, Apex 액션

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Flow 종류와 변수]] | processType, isInput/isOutput, $Flow |
| [[Flow 요소 참조]] | recordLookups/Creates/decisions/actionCalls |
| [[Screen Flow 설계]] | flowruntime:, LWC 삽입, faultConnector |
| [[Autolaunched Flow 패턴]] | 헤드리스, Agent Action, Apex에서 호출 |
| [[@InvocableMethod 패턴]] | bulkInvoke, InputParameters, OutputParameters |

### 통합
외부 시스템 연동 — Named Credential, Callout, REST/SOAP

| 하위 주제 | 핵심 키워드 |
|---|---|
| [[Named Credential]] | External Credential, callout: 접두어 |
| [[RestClient 패턴]] | virtual class, PATCH 우회 |
| [[Custom REST Endpoint]] | @RestResource, RestContext |

### [[Release MOC|Release Notes]]
Salesforce 연 3회 릴리즈 추적 — 신규 기능, Deprecated, 거버너 한도 변경

| 릴리즈 | API 버전 | 상태 |
|---|---|---|
| [[Winter '26]] | v64.0 | 🔲 미작성 |
| [[Summer '25]] | v63.0 | 🔲 미작성 |
| [[Spring '25]] | v62.0 | 🔲 미작성 |

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
