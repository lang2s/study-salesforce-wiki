---
tags: [lwc, apex, wire, imperative, pattern]
source: lwc-recipes/apexWireMethodToProperty, apexImperativeMethod
created: 2026-05-17
aliases: [Wire vs Imperative, Apex 호출 방식 선택]
---

# Wire vs Imperative 선택

> `@wire`는 컴포넌트 생명주기에 자동으로 묶이고, Imperative는 사용자 동작에 반응. 두 방식은 상호 보완적으로 함께 쓸 수 있다.

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

## 관련 노트

- [[Wire 패턴]]
- [[Imperative 호출 패턴]]
