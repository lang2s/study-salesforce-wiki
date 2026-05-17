---
tags: [lwc, lds, picklist, getPicklistValues, getObjectInfo, wire, pattern]
source: lwc-recipes/wireGetPicklistValues, wireGetPicklistValuesByRecordType
created: 2026-05-17
aliases: [getPicklistValues, Picklist 옵션 로드, 동적 Picklist, 종속 Picklist]
---

# getPicklistValues 패턴

> `@wire(getPicklistValues)` — 필드의 Picklist 옵션을 LDS로 로드. Record Type별로 다른 옵션이 있으면 recordTypeId 조합 필수.

---

## 기본 패턴 — 단순 Picklist

```javascript
import { LightningElement, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ACCOUNT_OBJECT } from '@salesforce/schema/Account';
import TYPE_FIELD from '@salesforce/schema/Account.Type';

export default class PicklistExample extends LightningElement {
    // 1단계: ObjectInfo로 defaultRecordTypeId 획득
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    objectInfo;

    get recordTypeId() {
        return this.objectInfo.data?.defaultRecordTypeId;
    }

    // 2단계: recordTypeId 확보 후 Picklist 로드 ($변수로 reactive)
    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: TYPE_FIELD
    })
    picklistValues;

    get typeOptions() {
        return this.picklistValues.data?.values ?? [];
        // [{ label: 'Analyst', value: 'Analyst' }, ...]
    }
}
```

```html
<template>
    <lightning-combobox
        label="Type"
        options={typeOptions}
        value={selectedType}
        onchange={handleChange}>
    </lightning-combobox>
</template>
```

---

## Record Type별 다른 옵션 — 동적 recordTypeId

```javascript
import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ACCOUNT_OBJECT } from '@salesforce/schema/Account';
import RATING_FIELD from '@salesforce/schema/Account.Rating';
import RECORD_TYPE_FIELD from '@salesforce/schema/Account.RecordTypeId';

export default class PicklistByRecordType extends LightningElement {
    @api recordId;

    // 현재 레코드의 RecordTypeId 조회
    @wire(getRecord, { recordId: '$recordId', fields: [RECORD_TYPE_FIELD] })
    record;

    get recordTypeId() {
        return this.record.data?.fields.RecordTypeId.value;
    }

    // Record Type에 맞는 Picklist 옵션 로드
    @wire(getPicklistValues, {
        recordTypeId: '$recordTypeId',
        fieldApiName: RATING_FIELD
    })
    ratingPicklist;

    get ratingOptions() {
        return this.ratingPicklist.data?.values ?? [];
    }
}
```

---

## 종속 Picklist (Dependent Picklist)

```javascript
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

// controllerValues: { '컨트롤러값': 인덱스 } 매핑 반환
// values: 각 옵션에 validFor 배열 포함 → 컨트롤러 인덱스와 매칭

@wire(getPicklistValues, {
    recordTypeId: '$recordTypeId',
    fieldApiName: DEPENDENT_FIELD
})
dependentPicklist;

// 컨트롤러 선택값에 따라 종속 옵션 필터링
getFilteredOptions(controllerValue) {
    const { values, controllerValues } = this.dependentPicklist.data;
    const controllerIndex = controllerValues[controllerValue];

    return values.filter(opt =>
        opt.validFor.includes(controllerIndex)
    );
}
```

---

## 비교표 — Picklist 로드 방법 선택

| 상황 | 방법 |
|---|---|
| Record Type 무관, 단일 필드 | `getPicklistValues` + `defaultRecordTypeId` |
| 현재 레코드 Record Type 기준 | `getRecord` → `recordTypeId` → `getPicklistValues` |
| 종속 Picklist | `getPicklistValues` + `validFor` 필터링 |
| 여러 필드 동시 로드 | `getPicklistValues` 여러 개 선언 |
| 하드코딩 옵션 (Picklist 아님) | JS 배열 직접 선언 |

---

## 주의 사항

> [!warning] recordTypeId가 undefined이면 wire 미실행
> `$recordTypeId`가 undefined인 동안 `getPicklistValues`는 실행되지 않음.
> ObjectInfo 로드 완료 후 자동으로 실행되므로 별도 처리 불필요.

> [!tip] defaultRecordTypeId
> Record Type을 쓰지 않는 객체도 `defaultRecordTypeId`가 존재함(Master Record Type).
> 항상 `objectInfo.data?.defaultRecordTypeId`로 안전하게 접근.

---

## 관련 노트

- [[getRecord 패턴]] — getObjectInfo, recordTypeId 획득
- [[Wire 패턴]] — $변수 reactive 동작 원리
- [[Record Form 선택]] — lightning-combobox vs record-form 선택
