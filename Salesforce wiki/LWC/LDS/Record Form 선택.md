---
tags: [lwc, lds, record-form, pattern]
source: lwc-recipes/recordFormDynamicContact, recordEditFormDynamicContact, recordViewFormDynamicContact
created: 2026-05-17
aliases: [lightning-record-form, record-edit-form, record-view-form, 레코드 폼]
---

# Record Form 선택

> 레코드 표시/편집에 3가지 표준 컴포넌트. 필드 제어 수준과 편집 여부에 따라 선택.

---

## 결정 매트릭스

| 컴포넌트 | 저장 방식 | 편집 가능 | 필드 제어 | 사용 시점 |
|---|---|---|---|---|
| `lightning-record-form` | 자동 커밋 | ✅ (선택) | 낮음 (fields 배열) | 기본 CRUD 빠르게 |
| `lightning-record-edit-form` | 명시적 Submit | ✅ | 높음 (개별 input-field) | 복잡한 유효성, 다중 필드 |
| `lightning-record-view-form` | 읽기 전용 | ❌ | 낮음 (output-field) | 레코드 표시만 |

---

## lightning-record-form (가장 단순)

```html
<!-- 동적 objectApiName -->
<lightning-record-form
    object-api-name={objectApiName}
    record-id={recordId}
    fields={fields}
    layout-type="Full"
    columns="2"
    mode="view"
>
</lightning-record-form>
```

```javascript
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

fields = [NAME_FIELD, PHONE_FIELD];
objectApiName = CONTACT_OBJECT;
```

**mode 옵션:**
- `view` — 보기 (편집 버튼 있음)
- `edit` — 편집 상태로 시작
- `readonly` — 완전 읽기 전용

---

## lightning-record-edit-form (세밀한 제어)

```html
<lightning-record-edit-form
    object-api-name={objectApiName}
    record-id={recordId}
    onsuccess={handleSuccess}
    onerror={handleError}
>
    <lightning-messages></lightning-messages>
    <lightning-input-field field-name="Name"></lightning-input-field>
    <lightning-input-field field-name="Phone"></lightning-input-field>
    <lightning-button type="submit" label="Save" variant="brand"></lightning-button>
    <lightning-button label="Cancel" onclick={handleCancel}></lightning-button>
</lightning-record-edit-form>
```

```javascript
handleSuccess(event) {
    const updatedRecord = event.detail.id;
    this.dispatchEvent(new ShowToastEvent({
        title: 'Success',
        message: 'Record saved',
        variant: 'success'
    }));
    // 폼 초기화
    this.template.querySelectorAll('lightning-input-field')
        .forEach(f => f.reset());
}
```

> [!tip] lightning-messages 필수
> `<lightning-messages>` 없으면 서버 측 유효성 에러가 UI에 표시되지 않음.

---

## lightning-record-view-form (읽기 전용)

```html
<lightning-record-view-form
    object-api-name={objectApiName}
    record-id={recordId}
>
    <lightning-output-field field-name="Name"></lightning-output-field>
    <lightning-output-field field-name="Phone"></lightning-output-field>
    <lightning-output-field field-name="Email"></lightning-output-field>
</lightning-record-view-form>
```

> `lightning-output-field`는 날짜, 전화번호, 이메일 등 Salesforce 형식 자동 적용.

---

## Dynamic vs Static Fields

```javascript
// Dynamic — 런타임 결정
fields = ['Name', 'Phone', 'Email', 'Title'];

// Static — @salesforce/schema import (권장: 컴파일 타임 검증)
import NAME_FIELD from '@salesforce/schema/Contact.Name';
fields = [NAME_FIELD, PHONE_FIELD];
```

---

## 관련 노트

- [[uiRecordApi]] — 프로그래밍 방식 CRUD
- [[getRecord 패턴]] — wire 기반 레코드 조회
- [[ldsUtils reduceErrors]] — 에러 정규화
