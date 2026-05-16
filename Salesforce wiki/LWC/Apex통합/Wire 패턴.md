---
tags: [lwc, apex, wire, reactive, pattern]
source: lwc-recipes/apexWireMethodToProperty, apexWireMethodToFunction, apexWireMethodWithParams
created: 2026-05-17
aliases: [@wire, Wire 어댑터, Reactive Property]
---

# Wire 패턴

> `@wire`는 컴포넌트 연결 시 자동 실행되는 선언적 데이터 바인딩. property 바인딩(단순)과 function 바인딩(제어 필요) 두 가지 형태.

---

## 패턴 1: Property 바인딩 (가장 단순)

```javascript
import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ContactList extends LightningElement {
    @wire(getContactList)
    contacts; // { data: [...], error: undefined } 또는 { data: undefined, error: {...} }
}
```

```html
<!-- 템플릿에서 .data / .error로 접근 -->
<template lwc:if={contacts.data}>
    <template for:each={contacts.data} for:item="contact">
        <p key={contact.Id}>{contact.Name}</p>
    </template>
</template>
<template lwc:elseif={contacts.error}>
    <c-error-panel errors={contacts.error}></c-error-panel>
</template>
<!-- 둘 다 undefined = 로딩 중 -->
```

---

## 패턴 2: Function 바인딩 (데이터 변환 / 추가 로직)

```javascript
@wire(getContactList)
wiredContacts({ error, data }) {
    if (data) {
        // 변환, 필터링 등 추가 로직 가능
        this.contacts = data.filter(c => c.Phone);
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.contacts = undefined;
    }
}
```

```html
<!-- 템플릿은 this.contacts 직접 접근 (더 간결) -->
<template lwc:if={contacts}>
    <template for:each={contacts} for:item="contact">
        <p key={contact.Id}>{contact.Name}</p>
    </template>
</template>
```

| | Property 바인딩 | Function 바인딩 |
|---|---|---|
| 코드량 | 최소 | 더 많음 |
| 데이터 변환 | ❌ | ✅ |
| 템플릿 접근 | `{contacts.data}` | `{contacts}` |
| 선택 기준 | 단순 표시 | 가공 필요 시 |

---

## 패턴 3: Reactive Property (`$` 접두사)

```javascript
export default class SearchComponent extends LightningElement {
    searchKey = ''; // reactive property

    // searchKey 변경 시 자동 재호출
    @wire(findContacts, { searchKey: '$searchKey' })
    contacts;

    handleKeyChange(event) {
        // debouncing 필수 — 입력마다 Apex 호출 방지
        window.clearTimeout(this.delayTimeout);
        const value = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = value; // 300ms 후 변경 → @wire 재실행
        }, 300);
    }
}
```

> [!warning] 객체/배열 reactive property — 참조 변경 필수
> 객체 속성만 수정하면 `@wire`가 재실행되지 않음. 반드시 새 객체를 생성해야 함.
>
> ```javascript
> // ❌ @wire 재실행 안 됨
> this.params.name = newValue;
>
> // ✅ 새 객체 생성 → @wire 재실행
> this.params = { ...this.params, name: newValue };
> ```

---

## Static Schema Import (타입 안전)

```javascript
import { getSObjectValue } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

@wire(getSingleContact)
contact;

get name() {
    return this.contact.data
        ? getSObjectValue(this.contact.data, NAME_FIELD)
        : '';
}
```

> `@salesforce/schema/Object.Field` import — 컴파일 타임에 필드명 검증. 필드 삭제/변경 시 배포 단계에서 오류 감지.

---

## Apex 어노테이션 요건

```apex
// @wire에서 사용 → cacheable=true 필수
@AuraEnabled(cacheable=true)
public static List<Contact> getContactList() { ... }

// cacheable=true면 CUD 불가 → 읽기 전용만
```

---

## 관련 노트

- [[Wire vs Imperative 선택]]
- [[Imperative 호출 패턴]]
- [[getRecord 패턴]]
