---
tags: [lwc, signals, internals, reactive, SignalBaseClass, Signal, ENABLE_EXPERIMENTAL_SIGNALS]
source: lwc-master/packages/@lwc/signals/src/index.ts; lwc-master/packages/@lwc/shared/src/signals.ts
created: 2026-05-22
aliases: [LWC Signals, @lwc/signals, Signal 인터페이스, SignalBaseClass, addTrustedSignal, setTrustedSignalSet, LWC 시그널, LWC 반응성 신호]
---

# LWC Signals (@lwc/signals)

> LWC 엔진이 추적할 수 있는 외부 반응형 값(Signal) 인터페이스와 추상 기반 클래스. `ENABLE_EXPERIMENTAL_SIGNALS` 플래그로 활성화.

**상위:** [[Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 개요

Signals는 LWC 컴포넌트가 **외부 상태**를 구독하고, 그 값이 변경될 때 자동으로 재렌더링되도록 하는 메커니즘이다.  
`@track`·`@api` 같은 내부 반응성과 달리, 컴포넌트 외부(예: 공유 상태 스토어)에서 선언된 값을 사용한다.

> [!warning] **EXPERIMENTAL** — `ENABLE_EXPERIMENTAL_SIGNALS` 플래그를 활성화한 경우에만 동작. 프로덕션 사용 금지.

---

## 타입 정의

```typescript
// @lwc/signals/src/index.ts
export type OnUpdate = () => void;
export type Unsubscribe = () => void;

export interface Signal<T> {
    get value(): T;                          // 현재 값 (getter)
    subscribe(onUpdate: OnUpdate): Unsubscribe; // 변경 구독 → 구독 해제 함수 반환
}
```

---

## SignalBaseClass — 커스텀 Signal 구현 기반 클래스

```typescript
// @lwc/signals/src/index.ts
export abstract class SignalBaseClass<T> implements Signal<T> {
    constructor() {
        addTrustedSignal(this); // ← 엔진의 "신뢰 목록"에 이 인스턴스 등록
    }

    abstract get value(): T; // 서브클래스에서 구현

    private subscribers: Set<OnUpdate> = new Set();

    subscribe(onUpdate: OnUpdate): Unsubscribe {
        this.subscribers.add(onUpdate);
        return () => {
            this.subscribers.delete(onUpdate); // 구독 해제
        };
    }

    protected notify() {
        for (const subscriber of this.subscribers) {
            subscriber(); // 모든 구독자에게 변경 알림
        }
    }
}
```

---

## 신뢰 메커니즘 — setTrustedSignalSet / addTrustedSignal

LWC 엔진은 임의 객체가 Signal인지 검증하기 위해 **신뢰 목록(WeakSet)** 을 사용한다.

```typescript
// @lwc/shared/src/signals.ts
let trustedSignals: WeakSet<object> | undefined;

// 엔진 초기화 시 1회 호출 — 어떤 객체가 신뢰할 수 있는 Signal인지 등록할 WeakSet 설정
export function setTrustedSignalSet(signals: WeakSet<object>) {
    isFalse(trustedSignals, 'Trusted Signal Set is already set!');
    trustedSignals = signals;
}

// SignalBaseClass 생성자가 자동 호출 — 이 인스턴스를 신뢰 목록에 추가
export function addTrustedSignal(signal: object) {
    trustedSignals?.add(signal);
}

// 엔진 렌더링 시 — 이 객체가 신뢰할 수 있는 Signal인지 확인
export function isTrustedSignal(target: object): boolean {
    if (!trustedSignals) return false;
    return trustedSignals.has(target);
}
```

**흐름:**
```
엔진 초기화
  └── setTrustedSignalSet(new WeakSet())  ← 신뢰 목록 WeakSet 생성
      ↓
new MySignal()  (SignalBaseClass extends)
  └── addTrustedSignal(this)              ← WeakSet에 등록
      ↓
템플릿에서 signal.value 접근
  └── isTrustedSignal(signal) === true    ← 엔진이 subscribe 및 추적 가능
```

---

## 커스텀 Signal 구현 예제

```typescript
import { SignalBaseClass } from '@lwc/signals';

class CounterSignal extends SignalBaseClass<number> {
    #count = 0;

    get value(): number {
        return this.#count;
    }

    increment() {
        this.#count++;
        this.notify(); // ← 구독자(= 엔진 렌더링 observer)에게 변경 알림
    }
}

// 공유 상태로 사용
export const counter = new CounterSignal();
```

```html
<!-- 컴포넌트 템플릿 -->
<template>
    <p>{counter.value}</p>
    <button onclick={handleClick}>+1</button>
</template>
```

```javascript
// 컴포넌트 JS
import { LightningElement } from 'lwc';
import { counter } from 'c/counterSignal';

export default class MyComp extends LightningElement {
    counter = counter; // signal 인스턴스를 프로퍼티로 노출
    handleClick() { counter.increment(); }
}
```

---

## @lwc/state와의 관계

`@lwc/state` 모듈(상태 관리 패턴)의 내부 구현이 Signal 메커니즘 위에 구축되어 있다.  
Signal은 저수준 primitive이고, `@lwc/state`는 그 위에 `atom`, `computed`, `fromContext` 같은 고수준 API를 제공한다.

→ [[상태 관리]]

---

## 활성화 방법

```javascript
// 앱 초기화 코드
import { setFeatureFlag } from '@lwc/features';
setFeatureFlag('ENABLE_EXPERIMENTAL_SIGNALS', true);
```

→ [[LWC 런타임 Feature Flags]]

---

## 관련 노트

- [[LWC 런타임 Feature Flags]] — ENABLE_EXPERIMENTAL_SIGNALS 플래그
- [[LWC 오픈소스 아키텍처]] — @lwc/signals 패키지 역할
- [[LWC VM 내부 구조]] — 엔진 렌더링 reactive observer
- [[상태 관리]] — @lwc/state (Signal 기반 고수준 API)
