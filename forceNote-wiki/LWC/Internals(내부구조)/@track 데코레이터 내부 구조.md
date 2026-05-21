---
tags: [lwc, track, decorator, internals, cmpFields, reactive-proxy, observable-membrane, getReactiveProxy]
source: lwc-master/packages/@lwc/engine-core/src/framework/decorators/track.ts, register.ts
created: 2026-05-22
aliases: [@track 내부, internalTrackDecorator, getReactiveProxy, observable-membrane, vm.cmpFields, @track 동작 원리, LWC 반응성 내부]
---

# @track 데코레이터 내부 구조

> `@track`이 `vm.cmpFields`에 reactive proxy를 저장하고 중첩 객체 변경까지 추적하는 방식.

**상위:** [[Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 개요

`@track`은 두 가지 방식으로 사용할 수 있다.

```javascript
// 1. 데코레이터로 사용 (컴파일러가 internalTrackDecorator 적용)
@track myObj = { count: 0 };

// 2. 함수로 직접 호출 (reactive proxy 래퍼 반환)
const reactiveValue = track(someObject);
```

---

## internalTrackDecorator(key)

`registerDecorators()` 내에서 `@track` 필드마다 아래 디스크립터로 프로토타입이 교체된다.

```typescript
// decorators/track.ts — internalTrackDecorator(key)
{
    get(this: LightningElement): any {
        const vm = getAssociatedVM(this);
        const val = vm.cmpFields[key];        // ← vm.cmpFields에서 읽기
        componentValueObserved(vm, key, val); // ← 반응성 추적 등록
        return val;
    },
    set(this: LightningElement, newValue: any) {
        const vm = getAssociatedVM(this);
        const reactiveOrAnyValue = getReactiveProxy(newValue); // ← reactive proxy 래핑
        if (process.env.NODE_ENV !== 'production') {
            trackTargetForMutationLogging(key, newValue);
        }
        updateComponentValue(vm, key, reactiveOrAnyValue); // ← dirty 마킹 + cmpFields 저장
    },
    enumerable: true,
    configurable: true,
}
```

---

## getReactiveProxy — observable-membrane

`getReactiveProxy(value)`는 `@lwc/engine-core`의 `membrane.ts`에서 가져온다.  
내부적으로 [`observable-membrane`](https://github.com/salesforce/observable-membrane) 라이브러리를 사용한 Proxy를 반환한다.

```javascript
// 동작 방식 개념
const obj = { a: { b: 1 } };
const proxy = getReactiveProxy(obj);

proxy.a.b = 2; // 중첩 프로퍼티 변경도 감지 → 컴포넌트 재렌더링 트리거
```

| 값 유형 | getReactiveProxy 결과 |
|---|---|
| 객체 / 배열 | Proxy 반환 (중첩 변경 추적 가능) |
| 원시값 (string, number 등) | 그대로 반환 |
| null / undefined | 그대로 반환 |

---

## 함수형 호출

```typescript
// decorators/track.ts
export default function track(target: undefined, context: ClassFieldDecoratorContext): void;
export default function track<T>(target: T, context?: never): T;
export default function track(target: unknown, context?: ClassFieldDecoratorContext): unknown {
    if (arguments.length === 1) {
        return getReactiveProxy(target); // ← 함수 호출: reactive proxy 반환
    }
    // 데코레이터로 호출: 컴파일러가 처리해야 할 것이 없으면 에러
    assert.fail(`@track decorator can only be used with one argument...`);
}
```

---

## @track vs @api — 저장 위치 비교

| 항목 | `@api` | `@track` |
|---|---|---|
| 저장 위치 | `vm.cmpProps[key]` | `vm.cmpFields[key]` |
| 초기화 주체 | 부모 컴포넌트 | 컴포넌트 자신 |
| reactive proxy | 없음 (단순 저장) | `getReactiveProxy()` 래핑 |
| 중첩 객체 추적 | 불가 | 가능 |

---

## API 버전과 @track 필요성

LWC API 39.0+부터 클래스 필드는 **자동으로 반응형**이 된다. 즉, 원시값(string, number, boolean)의 경우 `@track` 없이도 템플릿이 변경을 감지한다.

`@track`이 **여전히 필요한 경우**:
- 객체·배열의 **중첩 프로퍼티** 변경을 추적할 때
- `track(value)` 함수 형태로 reactive proxy가 필요할 때

```javascript
// @track 불필요 (원시값)
count = 0;  // count 변경 시 자동 재렌더링

// @track 필요 (중첩 객체)
@track config = { visible: true, size: 10 };
// this.config.visible = false → 템플릿 업데이트 ✅
```

---

## 보호 로직 (dev 전용)

`@api`와 동일하게 render·template update 중 set 시도 시 에러 로그를 출력한다.

---

## 관련 노트

- [[@api 데코레이터 내부 구조]] — vm.cmpProps, 공개 프로퍼티
- [[LWC VM 내부 구조]] — cmpFields 위치
- [[@wire 어댑터 내부 구조]] — wire 결과도 cmpFields에 저장
