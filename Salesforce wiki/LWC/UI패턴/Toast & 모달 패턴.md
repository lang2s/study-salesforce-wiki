---
tags: [lwc, toast, modal, ui, pattern]
source: lwc-recipes/miscToastNotification, miscModal, myModal
created: 2026-05-17
aliases: [ShowToastEvent, Toast, Modal, LightningModal]
---

# Toast & 모달 패턴

---

## ShowToastEvent — 토스트 알림

```javascript
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
}

// 사용 예
showToast('Success', 'Record saved', 'success');
showToast('Error', 'Something went wrong', 'error');
```

### variant 종류

| variant | 색상 | 아이콘 | 사용 시점 |
|---|---|---|---|
| `success` | 초록 | ✓ | 저장, 삭제 완료 |
| `error` | 빨강 | ✗ | API 실패, 검증 오류 |
| `warning` | 주황 | ! | 비가역적 작업 경고 |
| `info` | 파랑 | ℹ | 안내 메시지 |

### mode 옵션 (선택)

```javascript
new ShowToastEvent({
    title: '알림',
    message: '내용',
    variant: 'info',
    mode: 'sticky'  // 'dismissible'(기본) | 'pester' | 'sticky'
})
```

---

## LightningModal — 모달 다이얼로그

### 모달 컴포넌트 정의

```javascript
// myModal.js — LightningModal 상속 필수
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api header;
    @api content;

    handleClose() {
        this.close('confirmed'); // 반환값 전달
    }
}
```

```html
<!-- myModal.html -->
<template>
    <lightning-modal-header label={header}></lightning-modal-header>
    <lightning-modal-body>
        <p>{content}</p>
    </lightning-modal-body>
    <lightning-modal-footer>
        <lightning-button label="Cancel" onclick={handleCancel}></lightning-button>
        <lightning-button label="Confirm" variant="brand" onclick={handleClose}></lightning-button>
    </lightning-modal-footer>
</template>
```

### 모달 호출 (부모)

```javascript
import MyModal from 'c/myModal';

async handleShowModal() {
    const result = await MyModal.open({
        size: 'small',        // 'small' | 'medium' | 'large' | 'full'
        description: 'Confirmation dialog',
        header: '확인',
        content: '계속 진행하시겠습니까?'
    });

    if (result === 'confirmed') {
        // 사용자가 Confirm 클릭
        await this.doAction();
    }
    // result === undefined → X 버튼 또는 ESC로 닫음
}
```

> [!note] close() 반환값
> - `this.close('value')` → `result = 'value'`
> - X 버튼 / ESC / backdrop 클릭 → `result = undefined`

---

## 확인 다이얼로그 패턴

```javascript
// 삭제 전 확인 패턴
async handleDelete() {
    const result = await ConfirmModal.open({
        header: '삭제 확인',
        content: '이 레코드를 삭제하시겠습니까?'
    });

    if (result !== 'confirmed') return; // 취소

    try {
        await deleteRecord(this.recordId);
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: '삭제되었습니다',
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

## 관련 노트

- [[NavigationMixin 패턴]]
- [[에러 패널 패턴]]
- [[ldsUtils reduceErrors]]
