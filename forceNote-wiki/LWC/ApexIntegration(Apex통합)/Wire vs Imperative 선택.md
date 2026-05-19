---
tags: [lwc, apex, wire, imperative, pattern]
source: lwc-recipes/apexWireMethodToProperty, apexImperativeMethod
created: 2026-05-17
aliases: [Wire vs Imperative, Apex 호출 방식 선택]
---

# Wire vs Imperative 선택

> `@wire`는 컴포넌트 생명주기에 자동으로 묶이고, Imperative는 사용자 동작에 반응. 두 방식은 상호 보완적으로 함께 쓸 수 있다.

---

## 개념

LWC가 Apex를 호출하는 방식은 크게 두 가지로 나뉜다. 이 분리가 필요한 이유는 **데이터 흐름의 성격이 근본적으로 다르기 때문**이다.

`@wire`는 LWC 프레임워크의 Reactive System에 통합된다. 컴포넌트가 DOM에 연결되는 순간 자동으로 실행되고, `$` 접두사 reactive property가 변경될 때마다 자동으로 재실행된다. 내부적으로 LDS(Lightning Data Service) 캐시를 활용하기 때문에 `@AuraEnabled(cacheable=true)` 로 표시된 Apex 메서드에만 사용할 수 있다. 캐시 덕분에 같은 파라미터로 여러 컴포넌트가 동시에 조회해도 Apex 호출은 한 번만 발생한다.

Imperative 방식은 일반 async/await JavaScript 함수 호출이다. 실행 시점을 개발자가 완전히 제어한다. `cacheable=false` Apex 메서드(Insert/Update/Delete 포함)도 호출할 수 있고, 호출 전 유효성 검사나 전처리 로직을 끼워 넣을 수 있다.

---

## 결정 매트릭스

| 기준 | @wire | Imperative (async/await) |
|---|---|---|
| 실행 시점 | 컴포넌트 연결 시 자동 | 코드에서 명시적 호출 |
| cacheable=true | ✅ 활용 가능 | ❌ 캐시 미활용 |
| 파라미터 반응 | reactive property (`$변수`) | 수동으로 재호출 |
| 에러 처리 | `{ data, error }` | try/catch |
| 로딩 표시 | data/error 둘 다 undefined | isLoading 플래그 |
| 사용 시점 | 컴포넌트 마운트 시 데이터 필요 | 버튼 클릭, 검색 등 |
| 재호출 제어 | 자동 (reactive property 변경) | 수동 |

---

## 언제 @wire?

```javascript
// ✅ 컴포넌트 로드 시 바로 데이터 필요
// ✅ 파라미터 변경 시 자동 재조회 필요
// ✅ cacheable=true Apex 메서드

@wire(getContactList)
contacts;

// 파라미터 있는 경우 — $ 접두사로 reactive
@wire(findContacts, { searchKey: '$searchKey' })
contacts;
```

## 언제 Imperative?

```javascript
// ✅ 버튼 클릭, 폼 제출 등 사용자 액션
// ✅ 조건부 실행 (특정 조건 충족 시에만)
// ✅ cacheable=false (CUD 작업)
// ✅ 실행 전 전처리 로직 필요

async handleSearch() {
    try {
        this.contacts = await findContacts({ searchKey: this.searchKey });
    } catch (error) {
        this.error = error;
    }
}
```

---

## 공통 에러 상태 관리 규칙

두 방식 모두 적용:

```javascript
// 성공 시 error clear
this.contacts = data;
this.error = undefined;

// 실패 시 data clear
this.error = error;
this.contacts = undefined;
```

> [!warning] 양쪽 clear 필수
> 이전 에러나 이전 데이터가 남아있으면 UI가 의도치 않게 렌더링됨. 성공 시 `error = undefined`, 실패 시 `data = undefined`를 항상 명시적으로 설정.

---

## 주의사항

- **`@wire`에 cacheable=false 메서드 금지** — `@AuraEnabled` 없이 `cacheable=true`를 붙이지 않은 메서드를 `@wire`로 호출하면 런타임 에러 발생. DML이 있는 메서드는 반드시 Imperative로 호출.
- **`@wire` 결과는 immutable** — `@wire`로 받은 `data`는 직접 수정할 수 없다. 수정이 필요하면 `JSON.parse(JSON.stringify(data))`로 깊은 복사 후 사용.
- **reactive property 초기값 undefined** — `$searchKey`가 `undefined`이면 `@wire`는 호출을 보류(hold)한다. 초기 상태에서 빈 문자열(`''`)을 쓰고 싶다면 명시적으로 빈 문자열로 초기화.
- **Imperative 호출의 중복 실행** — 버튼 클릭 시 `isLoading` 플래그 없이 Imperative를 쓰면 사용자가 빠르게 클릭할 때 호출이 중복된다. 반드시 로딩 상태 관리.
- **두 방식 동시 사용 가능** — 같은 컴포넌트에서 초기 조회는 `@wire`, 사용자 액션은 Imperative로 함께 쓸 수 있다.

## 관련 노트

- [[Wire 패턴]]
- [[Imperative 호출 패턴]]
