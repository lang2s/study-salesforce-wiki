---
tags: [lwc, vm, virtual-machine, internals, VMState, RenderMode, ShadowMode, lifecycle, cmpProps, cmpFields]
source: lwc-master/packages/@lwc/engine-core/src/framework/vm.ts
created: 2026-05-22
aliases: [LWC VM, Virtual Machine LWC, VMState, RenderMode, ShadowMode, ViewModelReflection, LWC 컴포넌트 인스턴스 내부, LWC 생명주기 내부]
---

# LWC VM 내부 구조

> 모든 LWC 컴포넌트 인스턴스는 하나의 `VM` 객체로 관리된다. `vm.ts`에 정의된 인터페이스와 enum, 생명주기 함수 전체.

**상위:** [[Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 핵심 enum

### VMState — 컴포넌트 연결 상태

```typescript
export const enum VMState {
    created      = 0, // 인스턴스 생성, DOM 미연결
    connected    = 1, // connectedCallback 호출 완료
    disconnected = 2, // disconnectedCallback 호출 완료
}
```

### RenderMode — 렌더링 모드

```typescript
export const enum RenderMode {
    Light  = 0, // Light DOM (style scoping만, shadow root 없음)
    Shadow = 1, // Shadow DOM (기본값)
}
```

### ShadowMode — Shadow DOM 구현 방식

```typescript
export const enum ShadowMode {
    Native    = 0, // 브라우저 네이티브 Shadow DOM
    Synthetic = 1, // @lwc/synthetic-shadow polyfill
}
```

- `shadowSupportMode: 'any' | 'reset' | 'native'`: 컴포넌트가 지원하는 shadow 방식 선언
- `shadowMigrateMode: boolean`: native shadow에 synthetic 유사 수정이 적용된 상태

---

## VM 인터페이스 전체

```typescript
export interface VM<N = HostNode, E = HostElement> {
    // ──── 식별 ─────────────────────────────────────────
    readonly elm: HostElement;     // 호스트 커스텀 엘리먼트
    readonly tagName: string;      // 컴포넌트 태그명
    readonly def: ComponentDef;    // 컴포넌트 정의 (메서드, props, wire 메타)
    readonly owner: VM | null;     // 부모 VM (루트는 null)
    idx: number;                   // 생성 순서 인덱스

    // ──── 상태 ─────────────────────────────────────────
    state: VMState;                // created / connected / disconnected
    isScheduled: boolean;          // 재렌더링 스케줄 여부
    isDirty: boolean;              // 내부 재렌더링 필요 여부
    readonly hydrated: boolean;    // SSR 하이드레이션 여부

    // ──── 렌더링 모드 ───────────────────────────────────
    renderMode: RenderMode;        // Light | Shadow
    shadowMode: ShadowMode;        // Native | Synthetic
    shadowMigrateMode: boolean;    // native + synthetic 유사 수정
    mode: 'open' | 'closed';       // Shadow DOM mode

    // ──── 저장소 ────────────────────────────────────────
    cmpProps: { [name: string]: any };   // @api 공개 프로퍼티
    cmpFields: { [name: string]: any };  // @track / @wire 내부 필드
    cmpSlots: SlotSet;                   // 슬롯 할당 정보
    cmpTemplate: Template | null;        // 현재 렌더링 중인 템플릿

    // ──── VDOM ──────────────────────────────────────────
    children: VNodes;              // shadow tree VNodes
    aChildren: VNodes;             // adopted children VNodes
    velements: VCustomElement[];   // 마운트된 커스텀 엘리먼트 VNode들

    // ──── 참조 ──────────────────────────────────────────
    refVNodes: RefVNodes | null;   // lwc:ref 참조 (template refs)
    attachedEventListeners: WeakMap<Element, Record<string, EventListener | undefined>>;  // lwc:on

    // ──── Shadow Root ────────────────────────────────────
    shadowRoot: LightningElementShadowRoot | null;
    renderRoot: LightningElementShadowRoot | HostElement;  // Shadow: shadowRoot / Light: elm

    // ──── 반응성 ─────────────────────────────────────────
    tro: ReactiveObserver;         // template reactive observer

    // ──── 컴포넌트 인스턴스 ───────────────────────────────
    component: LightningElement;   // 실제 컴포넌트 인스턴스

    // ──── Locker 훅 ─────────────────────────────────────
    setHook: (cmp, prop, newValue) => void;
    getHook: (cmp, prop) => any;
    callHook: (cmp, fn, args?) => any;

    // ──── 기타 ──────────────────────────────────────────
    renderer: RendererAPI;                   // DOM 조작 추상화 API
    readonly context: Context;              // 스타일 토큰, wire 훅 등
    stylesheets: Stylesheets | null;
    apiVersion: APIVersion;
    debugInfo?: Record<string, any>;         // dev 전용 디버그 정보
}
```

---

## Context 인터페이스

```typescript
export interface Context {
    // CSS 스코핑 토큰 (합성 shadow + light DOM)
    stylesheetToken: string | undefined;
    legacyStylesheetToken: string | undefined;      // 레거시 토큰 (TODO: 제거 예정)
    hasTokenInClass: boolean | undefined;
    hasTokenInAttribute: boolean | undefined;
    hasLegacyTokenInClass: boolean | undefined;
    hasLegacyTokenInAttribute: boolean | undefined;
    hasScopedStyles: boolean | undefined;
    styleVNodes: VNode[] | null;

    // 템플릿 캐시 (렌더 사이클 간 공유 가능한 데이터)
    tplCache: TemplateCache;

    // @wire 생명주기 훅 (installWireAdapters가 등록)
    wiredConnecting: Array<() => void>;
    wiredDisconnecting: Array<() => void>;
}
```

---

## SlotSet 인터페이스

```typescript
export interface SlotSet {
    slotAssignments: { [slotName: string]: VNodes }; // 이름별 슬롯 할당 VNode
    owner?: VM;                                       // 슬롯 콘텐츠 소유자
}
```

---

## ViewModelReflection — VM 조회

```typescript
// vm.ts
const ViewModelReflection = new WeakMap<any, VM>();

// 사용
const vm = getAssociatedVM(componentOrElement); // WeakMap에서 VM 조회
```

모든 `LightningElement` 인스턴스와 호스트 엘리먼트는 `ViewModelReflection` WeakMap을 통해 대응 VM을 찾을 수 있다.

---

## 주요 생명주기 함수

| 함수 | 역할 |
|---|---|
| `connectRootElement(elm)` | 루트 요소를 DOM에 연결 (connectedCallback + 첫 렌더) |
| `disconnectRootElement(elm)` | 루트 요소를 DOM에서 분리 |
| `rerenderVM(vm)` | dirty VM 재렌더링 |
| `removeVM(vm)` | VDOM diff에서 제거된 VM 정리 |
| `appendVM(vm)` | 새 VM을 DOM에 추가 |
| `resetComponentStateWhenRemoved(vm)` | 분리 시 ReactiveObserver 리셋 + disconnectedCallback |

---

## VM 필드와 데코레이터 연결

```
@api myProp    →  vm.cmpProps['myProp']   (createPublicPropertyDescriptor)
@track myObj   →  vm.cmpFields['myObj']   (internalTrackDecorator)
@wire(…) data  →  vm.cmpFields['data']    (internalWireFieldDecorator)
```

---

## 관련 노트

- [[@api 데코레이터 내부 구조]] — cmpProps 저장 방식
- [[@track 데코레이터 내부 구조]] — cmpFields + reactive proxy
- [[@wire 어댑터 내부 구조]] — wiredConnecting/wiredDisconnecting 등록
- [[LWC 오픈소스 아키텍처]] — engine-core 전체 구조
