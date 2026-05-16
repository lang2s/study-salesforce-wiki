---
tags: [lwc, lds, uiRecordApi, createRecord, updateRecord, pattern]
source: lwc-recipes/ldsCreateRecord, ldsDeleteRecord, datatableInlineEditWithUiApi
created: 2026-05-17
aliases: [uiRecordApi, createRecord, updateRecord, deleteRecord]
---

# uiRecordApi — 프로그래밍 방식 레코드 CRUD

> `lightning/uiRecordApi`의 `createRecord`, `updateRecord`, `deleteRecord`로 LWC에서 직접 레코드 조작. Apex 없이 FLS/CRUD 자동 적용.

---

## createRecord

```javascript
import { createRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';

async createAccount() {
    const fields = {};
    fields[NAME_FIELD.fieldApiName] = this.name; // 'Name'
    const recordInput = {
        apiName: ACCOUNT_OBJECT.objectApiName,   // 'Account'
        fields
    };

    try {
        const account = await createRecord(recordInput);
        this.accountId = account.id;
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: `Account ${account.id} created`,
            variant: 'success'
        }));
    } catch (error) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: reduceErrors(error).join(', '),
            variant: 'error'
        }));
    }
}
```

---

## updateRecord

```javascript
import { updateRecord } from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Account.Id';

async updateAccount() {
    const fields = {};
    fields[ID_FIELD.fieldApiName] = this.recordId; // Id 필수
    fields['Name'] = this.newName;

    try {
        await updateRecord({ fields });
    } catch (error) {
        // 에러 처리
    }
}

// Datatable inline edit — 여러 레코드 병렬 업데이트
async handleSave(event) {
    const records = event.detail.draftValues.map(draft => ({
        fields: Object.assign({}, draft) // { Id: '...', Name: '...' }
    }));
    this.draftValues = [];

    try {
        await Promise.all(records.map(r => updateRecord(r)));
        await refreshApex(this.contacts); // 목록 새로고침
    } catch (error) {
        // 에러 처리
    }
}
```

---

## deleteRecord

```javascript
import { deleteRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';

@wire(getAccountList)
wiredAccounts;

async handleDelete(event) {
    const recordId = event.target.dataset.recordid;
    try {
        await deleteRecord(recordId);
        await refreshApex(this.wiredAccounts); // wire 캐시 새로고침
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Record deleted',
            variant: 'success'
        }));
    } catch (error) {
        // 에러 처리
    }
}
```

---

## notifyRecordUpdateAvailable — Apex 업데이트 후 캐시 무효화

```javascript
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';

// Apex로 서버 데이터 변경 후 wire 캐시 무효화
async handleUpdate() {
    try {
        await updateContactApex({ recordId: this.recordId, ... });

        // wire 어댑터가 사용 중인 캐시를 무효화 → 자동 재조회
        notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
    } catch (error) {
        // 에러 처리
    }
}
```

> [!note] refreshApex vs notifyRecordUpdateAvailable
> - `refreshApex(wiredResult)` — 특정 wire 결과 강제 새로고침
> - `notifyRecordUpdateAvailable([{recordId}])` — recordId 기반 전체 캐시 무효화 (getRecord wire 포함)

---

## generateRecordInputForCreate

```javascript
import { generateRecordInputForCreate, getRecord } from 'lightning/uiRecordApi';

// 기존 레코드를 복제하여 새 레코드 생성 준비
@wire(getRecord, { recordId: '$recordId', fields })
record;

async cloneRecord() {
    const recordInput = generateRecordInputForCreate(
        this.record.data,
        this.objectInfo.data
    );
    // recordInput.fields에서 Id, SystemModstamp 등 자동 제거
    const newRecord = await createRecord(recordInput);
}
```

---

## Schema Import vs 문자열

```javascript
// ✅ Schema import (프로덕션 권장)
import NAME_FIELD from '@salesforce/schema/Account.Name';
fields[NAME_FIELD.fieldApiName] = value; // NAME_FIELD.fieldApiName = 'Name'

// 빠른 프로토타이핑
fields['Name'] = value;
```

---

## 관련 노트

- [[Record Form 선택]]
- [[getRecord 패턴]]
- [[ldsUtils reduceErrors]]
