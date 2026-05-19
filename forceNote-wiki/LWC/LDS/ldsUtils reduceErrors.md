---
tags: [lwc, lds, error, utility, pattern]
source: lwc-recipes/ldsUtils, errorPanel
created: 2026-05-17
aliases: [reduceErrors, ldsUtils, 에러 정규화]
---

# ldsUtils — reduceErrors 에러 정규화

> LDS, UI API, Apex, 네트워크 에러 등 다양한 형식의 에러를 단일 `string[]`으로 통합하는 유틸리티.

---

## 개념 — 다양한 에러 형식을 단일 string[]으로 정규화한다

LWC에서 에러를 처리할 때 가장 큰 문제는 **에러 객체의 구조가 소스마다 다르다**는 점이다.

- `@wire`로 LDS 데이터를 읽다 실패하면 `error.body[]` 배열이 온다.
- DML 저장 실패(`saveRecord`)는 `error.body.output.errors[]`와 `error.body.output.fieldErrors{}`가 섞여 온다.
- Imperative Apex 호출 실패는 `error.body.message` 단일 문자열이다.
- 순수 JS 오류는 `error.message`만 있다.

각 소스마다 별도로 분기 처리하면 코드가 반복되고 빠뜨리는 케이스가 생긴다. `reduceErrors`는 이 모든 케이스를 **단일 함수 하나**로 처리해 `string[]` 형태로 반환한다. 이를 `.join(', ')`하면 Toast 메시지로, 배열 그대로 전달하면 `c-error-panel`로 사용할 수 있다.

---

## 언제 쓰나

| 상황 | 사용 방법 |
|---|---|
| `@wire` 핸들러에서 에러 처리 | `reduceErrors(error)` 호출 후 Toast 또는 errorPanel 전달 |
| Imperative Apex `catch` 블록 | `reduceErrors(error).join(', ')` → Toast message |
| `createRecord` / `updateRecord` 실패 | DML 필드 에러까지 포함해 자동 추출 |
| 에러 종류를 알 수 없는 범용 핸들러 | `reduceErrors`가 내부적으로 타입별 분기 처리 |

---

## 주의사항

- **빈 배열 반환 가능**: 에러 객체 구조가 위 케이스 중 어느 것도 아니면 `[]`가 반환될 수 있다. UI에 메시지를 표시하기 전 `messages.length > 0` 검사를 권장한다.
- **필드 에러 순서 비결정적**: `fieldErrors`는 객체 키 기준으로 순회하므로 필드 순서가 매번 다를 수 있다. 특정 필드 에러를 먼저 표시해야 하는 경우 수동 정렬이 필요하다.
- **c-ldsUtils는 직접 수정 자제**: `reduceErrors` 함수 자체를 수정하면 에러 패널 컴포넌트(`c-error-panel`) 등 이를 사용하는 모든 컴포넌트에 영향을 준다. 케이스 추가가 필요하면 래퍼 함수로 확장한다.

---

## 에러 타입별 구조

| 에러 소스 | 구조 |
|---|---|
| UI API 읽기 | `error.body[]` (배열) |
| 페이지 레벨 | `error.body.pageErrors[].message` |
| 필드 레벨 | `error.body.fieldErrors[field][].message` |
| DML 페이지 | `error.body.output.errors[].message` |
| DML 필드 | `error.body.output.fieldErrors[field][].message` |
| Apex/네트워크 | `error.body.message` |
| JS Error | `error.message` |
| HTTP | `error.statusText` |

---

## reduceErrors 구현

```javascript
// ldsUtils.js
export function reduceErrors(errors) {
    if (!Array.isArray(errors)) {
        errors = [errors];
    }
    return (
        errors
            .filter((error) => !!error)
            .map((error) => {
                if (Array.isArray(error.body)) {
                    return error.body.map((e) => e.message);
                } else if (error?.body?.pageErrors?.length > 0) {
                    return error.body.pageErrors.map((e) => e.message);
                } else if (error?.body?.fieldErrors && Object.keys(error.body.fieldErrors).length > 0) {
                    const msgs = [];
                    Object.values(error.body.fieldErrors).forEach(arr =>
                        msgs.push(...arr.map(e => e.message))
                    );
                    return msgs;
                } else if (error?.body?.output?.errors?.length > 0) {
                    return error.body.output.errors.map((e) => e.message);
                } else if (error?.body?.message) {
                    return error.body.message;
                } else if (error?.message) {
                    return error.message;
                }
                return error.statusText;
            })
            .reduce((prev, curr) => prev.concat(curr), [])
            .filter((msg) => !!msg)
    );
}
```

---

## 사용 패턴

```javascript
import { reduceErrors } from 'c/ldsUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Toast에서 에러 메시지 표시
catch (error) {
    this.dispatchEvent(new ShowToastEvent({
        title: 'Error',
        message: reduceErrors(error).join(', '),
        variant: 'error'
    }));
}

// errorPanel 컴포넌트로 전달
// c-error-panel 내부에서 reduceErrors 자동 호출
<c-error-panel errors={error}></c-error-panel>
```

---

## errorPanel 컴포넌트

```javascript
// errorPanel.js — reduceErrors를 내부에서 호출
@api errors;
@api friendlyMessage = 'Error retrieving data';
@api type; // 'inlineMessage' | undefined (기본: 일러스트레이션)

get errorMessages() {
    return reduceErrors(this.errors); // string[] 반환
}
```

```html
<!-- 표시 타입 선택 -->
<c-error-panel errors={error} type="inlineMessage"></c-error-panel>
<c-error-panel errors={error}></c-error-panel>  <!-- 기본: SVG 일러스트레이션 -->
```

---

## 관련 노트

- [[uiRecordApi]]
- [[getRecord 패턴]]
- [[에러 패널 패턴]]
