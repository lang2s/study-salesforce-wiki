---
tags: [lwc, lds, getRecord, wire, schema, pattern]
source: lwc-recipes/wireGetRecord, wireGetRecordDynamicContact, wireGetRecords, wireGetObjectInfo
created: 2026-05-17
aliases: [getRecord, getFieldValue, wireGetRecord]
---

# getRecord 패턴

> `@wire(getRecord)` — recordId + fields로 레코드 조회. Schema import(정적)와 문자열 배열(동적) 두 방식.

---

## Static Fields (권장)

```javascript
import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import PHONE_FIELD from '@salesforce/schema/Contact.Phone';

const FIELDS = [NAME_FIELD, PHONE_FIELD];

export default class WireGetRecord extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    contact;

    // getFieldValue로 안전하게 값 추출
    get name() {
        return getFieldValue(this.contact.data, NAME_FIELD);
    }
    get phone() {
        return getFieldValue(this.contact.data, PHONE_FIELD);
    }
}
```

---

## Dynamic Fields (런타임 결정)

```javascript
const FIELDS = ['Contact.Name', 'Contact.Title', 'Contact.Phone'];

@wire(getRecord, { recordId: '$recordId', fields: FIELDS })
contact;

// 문자열 방식은 getFieldValue 없이 직접 접근
get name() {
    return this.contact.data?.fields.Name.value;
}
```

---

## getFieldValue vs 직접 접근

```javascript
// getFieldValue — Schema import 기반, null 안전
get name() {
    return getFieldValue(this.contact.data, NAME_FIELD); // null 반환 (예외 없음)
}

// 직접 접근 — optional chaining 필수
get name() {
    return this.contact.data?.fields.Name.value; // undefined 반환
}
```

> [!tip] getFieldDisplayValue
> `getFieldDisplayValue(record, field)` — 포맷된 값 반환 (날짜→'Jan 1, 2024', 통화→'$1,000').

---

## optionalFields — 선택적 필드

```javascript
@wire(getRecord, {
    recordId: '$userId',
    fields: [NAME_FIELD],          // 필수 — 없으면 에러
    optionalFields: [EMAIL_FIELD]  // 선택 — FLS로 차단돼도 에러 없음
})
record;
```

---

## getRecords — 여러 레코드 동시 조회

```javascript
import { getRecords } from 'lightning/uiRecordApi';

@wire(getContactList)
wiredContacts({ data }) {
    if (data) {
        this.records = [
            {
                recordIds: [data[0].Id, data[1].Id],
                fields: [NAME_FIELD],
                optionalFields: [EMAIL_FIELD]
            }
        ];
    }
}

@wire(getRecords, { records: '$records' })
recordResults;
```

---

## getObjectInfo — 객체 메타데이터

```javascript
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

// 동적 objectApiName으로 메타데이터 조회
@wire(getObjectInfo, { objectApiName: '$objectApiName' })
objectInfo;

get recordTypeId() {
    return this.objectInfo.data?.defaultRecordTypeId;
}
```

---

## getPicklistValues — Picklist 옵션

```javascript
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import TYPE_FIELD from '@salesforce/schema/Account.Type';

@wire(getPicklistValues, {
    recordTypeId: '$recordTypeId', // getObjectInfo에서 가져온 값
    fieldApiName: TYPE_FIELD
})
picklistValues;

get typeOptions() {
    return this.picklistValues.data?.values; // [{ label, value }, ...]
}
```

---

## 관련 노트

- [[uiRecordApi]]
- [[Record Form 선택]]
- [[Wire 패턴]]
- [[ldsUtils reduceErrors]]
