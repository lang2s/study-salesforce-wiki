---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 프론트엔드 (LWC / Aura / Flow)
> LWC·Aura·Flow·Base Components 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

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
| LWC API 버전 관리, apiVersion, js-meta.xml, lwc:if, lwc:elseif, lwc:else, 동적 임포트, dynamic import, Lightning Web Security, LWS, if:true deprecated, createComponent, sfdx-project.json sourceApiVersion | `LWC/ComponentAPI(컴포넌트API)/LWC API 버전 관리.md` |
| 다른 컴포넌트 함수 호출, 컴포넌트 간 함수 실행 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 상태 관리, @lwc/state, atom, computed, 공유 상태, fromContext | `LWC/Events(이벤트)/상태 관리.md` |
| 컨테이너 컴포넌트, 프레젠테이션, 컴포지션, for:each, lwc:if | `LWC/ComponentAPI(컴포넌트API)/컴포지션 패턴.md` |

## LWC — LDS / 레코드 조작

| 키워드 | 파일 |
|---|---|
| UI API, User Interface API, ui-api, REST 엔드포인트, wire 어댑터 목록, uiRecordApi 모듈, uiObjectInfoApi, uiListsApi, uiRelatedListApi, RecordUI, ObjectInfo, getRelatedListInfo, getRelatedListRecords, getObjectInfo, getObjectInfos, getListUi, getListRecords, LDS REST API 전체 | `LWC/LDS/UI API 개요.md` |
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

## LWC — 내부 구조 (Internals, Tier 1 오픈소스 소스)

| 키워드 | 파일 |
|---|---|
| LWC 오픈소스 아키텍처, lwc monorepo, @lwc/compiler, @lwc/engine-core, @lwc/engine-dom, @lwc/ssr-compiler, @lwc/ssr-runtime, @lwc/template-compiler, static content optimization, virtual DOM LWC, shadow DOM light DOM, LWC 패키지 구조 | `LWC/Internals(내부구조)/LWC 오픈소스 아키텍처.md` |
| @api 내부 동작, createPublicPropertyDescriptor, createPublicAccessorDescriptor, vm.cmpProps, @api 반응성 구현, 생성자에서 @api 읽기 금지, registerDecorators, PropType Field Set Get GetSet | `LWC/Internals(내부구조)/@api 데코레이터 내부 구조.md` |
| @track 내부 동작, internalTrackDecorator, getReactiveProxy, observable-membrane, vm.cmpFields, @track vs @api 저장 위치, 중첩 객체 반응성, track 함수 호출 | `LWC/Internals(내부구조)/@track 데코레이터 내부 구조.md` |
| LWC VM 인터페이스, VMState created connected disconnected, RenderMode Light Shadow, ShadowMode Native Synthetic, ViewModelReflection WeakMap, cmpProps cmpFields cmpSlots, LWC 컴포넌트 인스턴스 내부 구조 | `LWC/Internals(내부구조)/LWC VM 내부 구조.md` |
| @wire 내부 동작, WireAdapter 인터페이스, WireAdapterConstructor, createConnector, createConfigWatcher, ReactiveObserver, ENABLE_WIRE_SYNC_EMIT, legacy register WireEventTarget ValueChangedEvent, wire 어댑터 구현 | `LWC/Internals(내부구조)/@wire 어댑터 내부 구조.md` |
| LWC Signals, @lwc/signals, Signal 인터페이스, SignalBaseClass, addTrustedSignal, setTrustedSignalSet, isTrustedSignal, ENABLE_EXPERIMENTAL_SIGNALS, LWC 시그널, 외부 반응형 상태 | `LWC/Internals(내부구조)/LWC Signals.md` |
| LWC 런타임 플래그, lwcRuntimeFlags, setFeatureFlag, setFeatureFlagForTest, DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, ENABLE_WIRE_SYNC_EMIT, DISABLE_SYNTHETIC_SHADOW, ENABLE_FROZEN_TEMPLATE, ENABLE_LEGACY_SCOPE_TOKENS, DISABLE_DETACHED_REHYDRATION, @lwc/features | `LWC/Internals(내부구조)/LWC 런타임 Feature Flags.md` |
| LWC 템플릿 컴파일러, @lwc/template-compiler, compile() 함수, TemplateCompileResult, RENDER_APIS, api_element api_custom_element api_text api_dynamic_text api_static_fragment, static content optimization, isStaticNode, optimizeStaticExpressions, stcN 호이스팅, LWC HTML 컴파일 출력 | `LWC/Internals(내부구조)/LWC 템플릿 컴파일러 파이프라인.md` |
| LWC Shadow DOM 모드, native shadow synthetic shadow light DOM 비교, RenderMode Light Shadow, ShadowMode Native Synthetic, shadowSupportMode any reset native, shadow migrate mode, applyShadowMigrateMode, DISABLE_SYNTHETIC_SHADOW, @lwc/synthetic-shadow 폴리필 | `LWC/Internals(내부구조)/LWC Shadow DOM 모드.md` |

---

## Aura(오라) — Aura 컴포넌트

| 키워드 | 파일 |
|---|---|
| Aura 컴포넌트, aura:component, .cmp, Controller.js, Helper.js, aura:attribute, aura:handler, aura:registerEvent, Aura 번들 구조, aura:iteration, aura:if | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura 이벤트, Component Event, Application Event, aura:registerEvent, aura:handler, $A.get, force:navigateToSObject, force:showToast, 시스템 이벤트 init change render | `Aura(오라)/Aura 이벤트.md` |
| Aura vs LWC, Aura 마이그레이션, Aura 비교, 언제 LWC 언제 Aura, Aura 레거시, LWC 우선 정책 | `Aura(오라)/Aura vs LWC.md` |

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
| lightning-tabset, 탭 컨테이너, 탭셋, ontabchange, active-tab-value, variant default scoped vertical, lightning-tab | `LWC/BaseComponents(베이스컴포넌트)/lightning-tabset.md` |
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

