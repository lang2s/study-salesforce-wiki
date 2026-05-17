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

## 📡 이벤트 & 통신

- [[CustomEvent 패턴]] — detail 전달, bubbles, composed, 이벤트 위임
- [[Lightning Message Service]] — publish/subscribe, MessageContext, pubsub 대체
- [[상태 관리]] — @lwc/state, setter 기반 reactive, 단방향 데이터 흐름

## 🗃 LDS & 레코드 폼

- [[Record Form 선택]] — lightning-record-form vs edit-form vs view-form 결정
- [[uiRecordApi]] — createRecord, updateRecord, deleteRecord, notifyRecordUpdateAvailable
- [[getRecord 패턴]] — static import, dynamic string, getFieldValue, getRecords
- [[ldsUtils reduceErrors]] — 에러 정규화 유틸리티
- [[getPicklistValues 패턴]] — Record Type별 Picklist 옵션 로드, 종속 Picklist validFor 필터링

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
```
