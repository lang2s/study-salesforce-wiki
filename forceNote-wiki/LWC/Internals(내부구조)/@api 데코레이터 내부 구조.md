---
tags: [lwc, api, decorator, internals, cmpProps, reactivity, registerDecorators]
source: lwc-master/packages/@lwc/engine-core/src/framework/decorators/api.ts, register.ts
created: 2026-05-22
aliases: [@api 내부, createPublicPropertyDescriptor, createPublicAccessorDescriptor, vm.cmpProps, @api 동작 원리, LWC 데코레이터 구현]
---

# @api 데코레이터 내부 구조

> `@api` 데코레이터가 내부적으로 `vm.cmpProps`에 값을 저장하고 반응성 시스템과 연결되는 방식.

**상위:** [[Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 개요

`@api`는 LWC 컴포넌트의 공개(public) 프로퍼티·메서드를 선언하는 데코레이터다.  
런타임에서는 컴파일러가 삽입한 `registerDecorators()` 호출을 통해 클래스 프로토타입에 커스텀 PropertyDescriptor가 정의된다.

```
[컴파일러 출력]
registerDecorators(MyComponent, {
    publicProps: { myProp: { config: 0, type: 'String' } },
    publicMethods: ['myMethod'],
})
```

---

## 두 종류의 @api 디스크립터

### 1. 필드 (PropType.Field = 0)

```typescript
// decorators/api.ts — createPublicPropertyDescriptor(key)
{
    get(this: LightningElement): any {
        const vm = getAssociatedVM(this);
        if (isBeingConstructed(vm)) {
            return; // 생성자에서 읽으면 undefined 반환 (부모가 아직 값 미설정)
        }
        const val = vm.cmpProps[key];        // ← vm.cmpProps에서 읽기
        componentValueObserved(vm, key, val); // ← 반응성 시스템에 읽기 추적 등록
        return val;
    },
    set(this: LightningElement, newValue: any) {
        const vm = getAssociatedVM(this);
        vm.cmpProps[key] = newValue;     // ← vm.cmpProps에 쓰기
        componentValueMutated(vm, key);  // ← 반응성 시스템에 변경 알림
    },
    enumerable: true,
    configurable: true,
}
```

### 2. 접근자 (PropType.Get=2, GetSet=3)

```typescript
// decorators/api.ts — createPublicAccessorDescriptor(key, descriptor)
{
    get(this: LightningElement): any {
        return get.call(this); // 원본 getter 그대로 호출 (VM 검증만 추가)
    },
    set(this: LightningElement, newValue: any) {
        const vm = getAssociatedVM(this);
        if (set) {
            set.call(this, newValue); // 원본 setter 호출
        } else {
            logError(`...no setter...`, vm); // setter 없는 접근자에 set 시도 시 에러
        }
    },
}
```

---

## 보호 로직 (dev 전용)

| 상황 | 조건 | 동작 |
|---|---|---|
| 생성자에서 get | `isBeingConstructed(vm)` | `undefined` 반환 + 에러 로그 |
| render 도중 set | `isInvokingRender` | 에러 로그 (`render()` side effect 경고) |
| 템플릿 업데이트 도중 set | `isUpdatingTemplate` | 에러 로그 (template side effect 경고) |

생성자에서 `@api` 프로퍼티를 읽으면 `undefined`가 반환되는 이유: **부모 컴포넌트가 아직 값을 넘기지 않았기 때문.** 초기값은 생성자에서 직접 설정해야 한다.

---

## PropType enum

```typescript
// decorators/register.ts
export const enum PropType {
    Field   = 0,  // 일반 필드 (get/set 없음)
    Set     = 1,  // setter만 있음
    Get     = 2,  // getter만 있음
    GetSet  = 3,  // getter + setter 모두 있음
}
```

- `config = 0`: 일반 필드 → `createPublicPropertyDescriptor` 사용
- `config > 0`: 접근자 → `createPublicAccessorDescriptor` 사용

---

## registerDecorators() 처리 흐름

```typescript
// decorators/register.ts — registerDecorators(Ctor, meta)
// 컴파일러가 클래스 정의 직후 자동 호출

for (const fieldName in publicProps) {
    const propConfig = publicProps[fieldName];
    if (propConfig.config > 0) {
        // @api get myProp() {...} 형태
        descriptor = createPublicAccessorDescriptor(fieldName, descriptor);
    } else if (!isUndefined(descriptor) && !isUndefined(descriptor.get)) {
        // [W-9927596] 하위 호환: public prop + private getter/setter 동명 시 accessor로 처리
        descriptor = createPublicAccessorDescriptor(fieldName, descriptor);
    } else {
        descriptor = createPublicPropertyDescriptor(fieldName);
    }
    defineProperty(proto, fieldName, descriptor); // 프로토타입에 교체 등록
}
```

---

## vm.cmpProps vs vm.cmpFields

| 저장소 | 데코레이터 | 역할 |
|---|---|---|
| `vm.cmpProps` | `@api` | 부모가 넘기는 **공개** 입력 값 |
| `vm.cmpFields` | `@track`, `@wire` | 컴포넌트 **내부** 반응형 상태 |

---

## 관련 노트

- [[@track 데코레이터 내부 구조]] — vm.cmpFields, getReactiveProxy
- [[LWC VM 내부 구조]] — VM 인터페이스 전체 (cmpProps 위치)
- [[@wire 어댑터 내부 구조]] — wire 필드도 cmpFields에 저장
- [[@api 패턴]] — @api 실무 사용 패턴
