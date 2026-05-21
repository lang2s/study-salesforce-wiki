---
tags: [lwc, moc, index]
created: 2026-05-17
---

# LWC — Map of Content

> 출처: [lwc-recipes](https://github.com/trailheadapps/lwc-recipes) (Salesforce 공식 학습 앱) 133개 컴포넌트 분석

---

## ⚡ Apex 통합

- [[Wire vs Imperative 선택]] — @wire(property/function) vs async/await 결정 매트릭스
- [[Wire 패턴]] — property 바인딩, function 바인딩, reactive property ($변수)
- [[Imperative 호출 패턴]] — async/await, try/catch/finally, isLoading 패턴

## 🧩 컴포넌트 API & 컴포지션

- [[@api 패턴]] — property, method, getter/setter, lwc:spread
- [[컴포지션 패턴]] — Container vs Presentational, for:each, lwc:if/lwc:elseif/lwc:else
- [[LWC API 버전 관리]] — .js-meta.xml apiVersion 규칙, 버전별 기능, 동적 임포트

## 📡 이벤트 & 통신

- [[CustomEvent 패턴]] — detail 전달, bubbles, composed, 이벤트 위임
- [[Lightning Message Service]] — publish/subscribe, MessageContext, pubsub 대체
- [[상태 관리]] — @lwc/state, setter 기반 reactive, 단방향 데이터 흐름

## 🗃 LDS & 레코드 폼

- [[UI API 개요]] — UI API REST 엔드포인트 전체 + wire 어댑터 매핑 (v67.0 Summer '26)
- [[Record Form 선택]] — lightning-record-form vs edit-form vs view-form 결정
- [[uiRecordApi]] — createRecord, updateRecord, deleteRecord, notifyRecordUpdateAvailable
- [[getRecord 패턴]] — static import, dynamic string, getFieldValue, getRecords
- [[ldsUtils reduceErrors]] — 에러 정규화 유틸리티
- [[getPicklistValues 패턴]] — Record Type별 Picklist 옵션 로드, 종속 Picklist validFor 필터링

## 📚 Base Components 상세 레퍼런스

> 각 컴포넌트의 속성·이벤트·코드 예시·접근성·사용 고려사항이 담긴 상세 페이지.

- [[lightning-accordion]] — 접고 펼치는 아코디언, sectiontoggle 이벤트, 다중 열기
- [[lightning-tabset]] — 탭 컨테이너, ontabchange 이벤트, variant(default/scoped/vertical)
- [[lightning-input]] — 14가지 type 변형, 유효성 검사, change·commit 이벤트
- [[lightning-combobox]] — 단일 선택 드롭다운, options 배열, Picklist 연동
- [[lightning-datatable]] — 정렬·인라인 편집·행 액션·커스텀 타입, columns 전체 type 목록
- [[lightning-modal]] — LightningModal 상속, open/close, LightningAlert·Confirm·Prompt
- [[lightning-record-form]] — record-form·record-edit-form·record-view-form 3종
- [[lightning-record-picker]] — 레코드 검색 선택, filter, 다중 선택 패턴, dynamic target
- [[lightning-button]] — button·button-icon·button-menu·button-group·stateful 패밀리
- [[lightning-card]] — 카드 컨테이너, actions·footer 슬롯
- [[lightning-spinner]] — isLoading 패턴, try/finally, 인라인·오버레이

## 🧭 네비게이션 & UI

- [[Lightning Base Components 레퍼런스]] — lightning-* 전체 컴포넌트 목록 및 속성 빠른 참조
- [[NavigationMixin 패턴]] — pageReference 타입별 사용법
- [[Toast & 모달 패턴]] — ShowToastEvent, variant, 모달 구현
- [[에러 패널 패턴]] — errorPanel, reduceErrors, 에러 타입별 처리
- [[공유 JS 모듈]] — c/ 네임스페이스 공유 함수, named export, isExposed: false

## 🔒 보안 & 권한

- [[LWC 보안 패턴]] — 권한 기반 UI, @api 노출 범위, userId, CSP

## 📱 모바일

- [[모바일 기능 패턴]] — getBarcodeScanner, getLocationService, isAvailable() 가드, mobile/browser fallback

## 📦 Static Resource & 파일

- [[Static Resource 로딩]] — loadScript/loadStyle, renderedCallback 3-state (NOT_LOADED/LOADING/READY)
- [[파일 업로드와 이미지 처리]] — processImage, FileReader→base64, refreshApex, ContentVersion URL

---

## 🔧 LWC 내부 구조 (Internals)

> 소스: `lwc-master/` (salesforce/lwc 오픈소스, Tier 1)

- [[LWC 오픈소스 아키텍처]] — 패키지 전체 구조, Compiler/Runtime/SSR 분리, static content optimization
- [[@api 데코레이터 내부 구조]] — `createPublicPropertyDescriptor`, vm.cmpProps, 반응성 연결
- [[@track 데코레이터 내부 구조]] — `internalTrackDecorator`, vm.cmpFields, observable-membrane reactive proxy
- [[LWC VM 내부 구조]] — VM 인터페이스 전체, VMState/RenderMode/ShadowMode enum, lifecycle 함수
- [[@wire 어댑터 내부 구조]] — WireAdapter 인터페이스, createConnector, configWatcher, legacy register()
- [[LWC Signals]] — Signal 인터페이스, SignalBaseClass, addTrustedSignal, setTrustedSignalSet
- [[LWC 런타임 Feature Flags]] — 13개 플래그 전체 목록, setFeatureFlag(), lwcRuntimeFlags 글로벌
- [[LWC 템플릿 컴파일러 파이프라인]] — compile() API, parse→codegen 2단계, RENDER_APIS, static content optimization
- [[LWC Shadow DOM 모드]] — Native/Synthetic/Light DOM 비교, shadowSupportMode, Shadow Migrate Mode

---

## 🧪 테스트

- [[Jest 테스트 패턴]] — @wire 어댑터 mock, DOM 이벤트 검증, @salesforce/apex mock 3종 패턴

---

## 빠른 의사결정

```
어떤 컴포넌트 쓸지?    → [[Lightning Base Components 레퍼런스]]
Apex 호출?             → [[Wire vs Imperative 선택]]
@wire 에러?            → [[Wire 패턴]] → function 바인딩
컴포넌트 통신?         → 부모↔자식: [[CustomEvent 패턴]] | 크로스 컴포넌트: [[Lightning Message Service]]
레코드 표시?           → [[Record Form 선택]] → lightning-record-form
레코드 수정?           → [[uiRecordApi]] → updateRecord 또는 [[Record Form 선택]]
상태 공유?             → [[상태 관리]] → @lwc/state
서드파티 라이브러리?   → [[Static Resource 로딩]] → loadScript/loadStyle
파일 업로드?           → [[파일 업로드와 이미지 처리]] → processImage
모바일 기기?           → [[모바일 기능 패턴]] → isAvailable() 먼저
LWC 컴포넌트 테스트?   → [[Jest 테스트 패턴]] → wire mock, DOM 이벤트, apex mock
```
