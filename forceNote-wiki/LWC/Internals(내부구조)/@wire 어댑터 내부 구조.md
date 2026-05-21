---
tags: [lwc, wire, adapter, internals, WireAdapter, WireAdapterConstructor, createConnector, configWatcher, reactive-observer, legacy-wire]
source: lwc-master/packages/@lwc/engine-core/src/framework/wiring/wiring.ts, types.ts; lwc-master/packages/@lwc/wire-service/src/index.ts
created: 2026-05-22
aliases: [@wire 내부, WireAdapter 인터페이스, WireAdapterConstructor, createConnector, createConfigWatcher, ENABLE_WIRE_SYNC_EMIT, legacy register, WireEventTarget, ValueChangedEvent]
---

# @wire 어댑터 내부 구조

> `@wire`가 어댑터를 인스턴스화하고, 반응형 파라미터를 감지해 `update()`를 호출하는 방식. 현대 API와 레거시 API 모두 설명.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## WireAdapter 인터페이스 (현대 API)

```typescript
// wiring/types.ts
export interface WireAdapter<
    Config extends ConfigValue = ConfigValue,
    Context extends ContextValue = ContextValue,
> {
    update(config: Config, context?: Context): void;
    connect(): void;
    disconnect(): void;
}

export interface WireAdapterConstructor<Config, Value, Context> {
    new (
        callback: DataCallback<Value>,   // 데이터를 컴포넌트에 푸시하는 콜백
        sourceContext?: { tagName: string }
    ): WireAdapter<Config, Context>;

    configSchema?: Record<keyof Config, 'optional' | 'required'>;
    contextSchema?: Record<keyof Context, 'optional' | 'required'>;
}

export type DataCallback<T = any> = (value: T) => void;
```

어댑터는 `new AdapterClass(callback, sourceContext)` 형태로 인스턴스화된다.  
데이터를 준비했을 때 `callback(value)`를 호출하면, 엔진이 해당 컴포넌트 필드 또는 메서드를 업데이트한다.

---

## @wire 내부 처리 흐름

```
컴포넌트 VM 생성
    ↓
installWireAdapters(vm)
    ├── WireMetaMap에서 wireDef 조회 (adapter, configCallback, dynamic)
    ├── createConnector(vm, fieldOrMethodName, wireDef)
    │     ├── new adapter(dataCallback, { tagName })  ← 어댑터 인스턴스 생성
    │     ├── createConfigWatcher(component, configCallback, updateConnectorConfig)
    │     └── contextSchema 있으면 createContextWatcher 설정
    └── connect/disconnect 콜백을 context.wiredConnecting/Disconnecting에 등록

connectedCallback 후
    ↓
connectWireAdapters(vm)
    └── connector.connect() + computeConfigAndUpdate()

disconnectedCallback
    ↓
disconnectWireAdapters(vm)
    └── connector.disconnect() + resetConfigWatcher()
```

---

## createConfigWatcher — 반응형 파라미터 추적

`$prop` 형태의 동적 파라미터 변경을 감지해 micro-task로 `update()` 호출을 배치한다.

```typescript
// wiring/wiring.ts — createConfigWatcher(component, configCallback, callbackWhenConfigIsReady)
function createConfigWatcher(...) {
    let hasPendingConfig = false;
    const ro = createReactiveObserver(() => {
        if (!hasPendingConfig) {
            hasPendingConfig = true;
            Promise.resolve().then(() => {   // ← micro-task로 배치 (동기 아님!)
                hasPendingConfig = false;
                ro.reset();
                computeConfigAndUpdate();
            });
        }
    });

    const computeConfigAndUpdate = () => {
        let config: ConfigValue;
        ro.observe(() => (config = configCallback(component)));  // configCallback 실행 중 읽기 추적
        callbackWhenConfigIsReady(config);  // → connector.update(config, context)
    };
}
```

- `configCallback(component)`: 컴파일러가 생성하는 함수. `$bookId` → `component.bookId` 읽기.
- `ro.observe(fn)`: fn 실행 중 접근된 reactive 프로퍼티를 구독.
- 구독된 프로퍼티 변경 → ro 콜백 호출 → micro-task로 `update()` 재호출.

---

## ENABLE_WIRE_SYNC_EMIT 플래그

```typescript
// wiring/wiring.ts — installWireAdapters()
ArrayPush.call(wiredConnecting, () => {
    connector.connect();
    if (!lwcRuntimeFlags.ENABLE_WIRE_SYNC_EMIT) {
        if (hasDynamicParams) {
            Promise.resolve().then(computeConfigAndUpdate); // ← 비동기
            return;
        }
    }
    computeConfigAndUpdate(); // ← 동기
});
```

| 플래그 | 동적 파라미터 첫 config 호출 |
|---|---|
| 미설정 (기본) | connect 후 micro-task에서 비동기 처리 |
| `ENABLE_WIRE_SYNC_EMIT = true` | connect 즉시 동기 처리 |

---

## Context 지원

`adapter.contextSchema`가 정의된 어댑터는 상위 컴포넌트로부터 context를 받을 수 있다.

```typescript
// wiring/wiring.ts
if (!isUndefined(adapter.contextSchema)) {
    createContextWatcher(vm, wireDef, (newContext: ContextValue) => {
        if (context !== newContext) {
            context = newContext;
            if (vm.state === VMState.connected) {
                computeConfigAndUpdate(); // context 변경 시 config와 함께 update 재호출
            }
        }
    });
}
```

어댑터의 `update(config, context)` 두 번째 인자로 전달된다.

---

## WireMetaMap — 어댑터 메타 저장소

```typescript
const WireMetaMap: Map<PropertyDescriptor, WireDef> = new Map();

export interface WireDef {
    method?: (data: any) => void;   // @wire on method
    adapter: WireAdapterConstructor;
    dynamic: string[];              // 반응형 파라미터 이름 목록
    configCallback: ConfigCallback; // 컴파일러 생성 config 계산 함수
}
```

- `storeWiredFieldMeta()`: @wire 필드의 메타 저장
- `storeWiredMethodMeta()`: @wire 메서드의 메타 저장
- 키: 해당 필드/메서드의 `PropertyDescriptor`

---

## 레거시 API (`@lwc/wire-service` — deprecated)

```typescript
// wire-service/src/index.ts

// 레거시 어댑터 등록 (현재는 사용 안 함)
register(adapterId, adapterEventTargetCallback);

// WireEventTarget 이벤트 타입
const CONNECT    = 'connect';
const DISCONNECT = 'disconnect';
const CONFIG     = 'config';
```

### LegacyWireAdapterBridge (내부 클래스)

레거시 어댑터를 현대 `WireAdapter` 인터페이스로 브릿지한다.

```typescript
class LegacyWireAdapterBridge implements WireAdapter {
    connect() { this.connecting.forEach(fn => fn()); }
    disconnect() { this.disconnecting.forEach(fn => fn()); }
    update(config: WireConfigValue) {
        // 동적 파라미터가 모두 undefined면 첫 업데이트 무시 (레거시 동작)
        // config 변경 시만 configuring 리스너 호출
    }
}
```

### ValueChangedEvent

```typescript
// 레거시 어댑터에서 데이터 푸시
eventTarget.dispatchEvent(new ValueChangedEvent(data));
// → adapter의 dataCallback(value) 호출로 변환됨
```

---

## 현대 어댑터 구현 예시

```typescript
class MyWireAdapter {
    #callback;
    #config = {};
    #interval;

    constructor(callback, { tagName }) {
        this.#callback = callback;
    }

    connect() {
        this.#fetchData();
    }

    update(config, context) {
        if (this.#config.recordId !== config.recordId) {
            this.#config = config;
            this.#fetchData();
        }
    }

    disconnect() {
        clearInterval(this.#interval);
    }

    #fetchData() {
        if (!this.#config.recordId) return;
        fetchRecord(this.#config.recordId)
            .then(data => this.#callback(data))
            .catch(err => this.#callback({ error: err }));
    }
}
MyWireAdapter.configSchema = { recordId: 'required' };
```

---

## 관련 노트

- [[Wire 패턴]] — @wire 실무 사용 패턴
- [[LWC VM 내부 구조]] — wiredConnecting/wiredDisconnecting 위치
- [[@api 데코레이터 내부 구조]] — 데코레이터 등록 공통 패턴
- [[LWC 오픈소스 아키텍처]] — @lwc/wire-service 패키지 역할
