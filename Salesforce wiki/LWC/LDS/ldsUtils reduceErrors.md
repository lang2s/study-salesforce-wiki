---
tags: [lwc, lds, error, utility, pattern]
source: lwc-recipes/ldsUtils, errorPanel
created: 2026-05-17
aliases: [reduceErrors, ldsUtils, 에러 정규화]
---

# ldsUtils — reduceErrors 에러 정규화

> LDS, UI API, Apex, 네트워크 에러 등 다양한 형식의 에러를 단일 `string[]`으로 통합하는 유틸리티.

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
