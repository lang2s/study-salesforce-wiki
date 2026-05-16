---
tags: [lwc, apex, imperative, async, pattern]
source: lwc-recipes/apexImperativeMethod, apexImperativeMethodWithParams
created: 2026-05-17
aliases: [Imperative Apex, async/await LWC]
---

# Imperative 호출 패턴

> 사용자 액션(버튼 클릭 등)에 반응해 Apex를 명시적으로 호출. `async/await` + `try/catch/finally` 패턴.

---

## 기본 패턴

```javascript
import getContactList from '@salesforce/apex/ContactController.getContactList';

export default class ApexImperative extends LightningElement {
    contacts;
    error;
    isLoading = false;

    async handleLoad() {
        this.isLoading = true;
        try {
            this.contacts = await getContactList();
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.contacts = undefined;
        } finally {
            this.isLoading = false; // 성공/실패 무관하게 항상 실행
        }
    }
}
```

```html
<lightning-spinner lwc:if={isLoading} alternative-text="Loading"></lightning-spinner>
<template lwc:if={contacts}>...</template>
<template lwc:if={error}>
    <c-error-panel errors={error}></c-error-panel>
</template>
```

---

## 파라미터 전달

```javascript
// 단순 타입
async handleSearch() {
    try {
        this.contacts = await findContacts({
            searchKey: this.searchKey
        });
        this.error = undefined;
    } catch (error) {
        this.error = error;
        this.contacts = undefined;
    }
}

// 복잡한 객체 (Apex Wrapper 클래스에 매핑)
async handleSubmit() {
    const wrapper = {
        someString: this.stringValue,
        someInteger: parseInt(this.numberValue),
        someList: this.listItems.split(',')
    };
    try {
        this.result = await checkApexTypes({ wrapper });
    } catch (error) {
        this.error = error;
    }
}
```

> [!note] 객체 파라미터 필드명 일치
> Apex Wrapper 클래스의 public 필드명과 LWC 객체의 키 이름이 **정확히 일치**해야 한다. camelCase 주의.

---

## debouncing — 입력 지연 처리

```javascript
const DELAY = 300;

handleKeyChange(event) {
    window.clearTimeout(this.delayTimeout);
    const searchKey = event.target.value;
    // 300ms 동안 추가 입력 없으면 Apex 호출
    this.delayTimeout = setTimeout(async () => {
        try {
            this.contacts = await findContacts({ searchKey });
            this.error = undefined;
        } catch (error) {
            this.error = error;
            this.contacts = undefined;
        }
    }, DELAY);
}
```

---

## 외부 REST API 호출 (fetch)

```javascript
// Apex 대신 직접 fetch — CSP Trusted Sites 등록 필수
const BASE_URL = 'https://api.example.com/';

async handleSearchClick() {
    try {
        this.isLoading = true;
        const response = await fetch(BASE_URL + this.searchKey);
        if (!response.ok) {
            throw Error('HTTP error: ' + response.status);
        }
        this.data = await response.json();
        this.error = undefined;
    } catch (error) {
        this.error = error;
        this.data = undefined;
    } finally {
        this.isLoading = false;
    }
}
```

> [!warning] fetch vs Apex 어댑터
> `fetch()`는 FLS/CRUD 자동 검증 없음. 외부 API 토큰 관리도 직접 해야 함. 가능하면 Apex + Named Credential 조합을 사용할 것.

---

## Apex 어노테이션 요건

```apex
// Imperative는 cacheable 없어도 됨 (CUD 포함 가능)
@AuraEnabled
public static void updateContact(Id recordId, String name) { ... }

// 읽기 전용이면 cacheable=true 권장
@AuraEnabled(cacheable=true)
public static List<Contact> getContactList() { ... }
```

---

## 관련 노트

- [[Wire vs Imperative 선택]]
- [[Wire 패턴]]
- [[에러 패널 패턴]]
