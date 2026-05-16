---
tags: [lwc, event, custom-event, bubbling, pattern]
source: lwc-recipes/eventSimple, eventBubbling, eventWithData, contactListItem
created: 2026-05-17
aliases: [CustomEvent, 이벤트 버블링, 이벤트 위임]
---

# CustomEvent 패턴

> 자식 → 부모 통신의 표준. `new CustomEvent(name, options)`로 생성하고 `dispatchEvent()`로 발행.

---

## 패턴 1: 단순 시그널 (데이터 없음)

```javascript
// paginator.js
handlePrevious() {
    this.dispatchEvent(new CustomEvent('previous'));
}
handleNext() {
    this.dispatchEvent(new CustomEvent('next'));
}
```

```html
<!-- 부모에서 onprevious, onnext로 수신 -->
<c-paginator onprevious={handlePrevious} onnext={handleNext}></c-paginator>
```

---

## 패턴 2: detail로 데이터 전달

```javascript
// contactListItem.js
handleClick(event) {
    event.preventDefault();
    const selectEvent = new CustomEvent('select', {
        detail: this.contact.Id  // 단순값
    });
    this.dispatchEvent(selectEvent);
}

// 객체 전달
const selectEvent = new CustomEvent('contactselect', {
    detail: { contactId: this.contact.Id, name: this.contact.Name }
});
```

```javascript
// 부모에서 수신
handleSelect(event) {
    const contactId = event.detail;          // 단순값
    const { contactId, name } = event.detail; // 객체
}
```

---

## 패턴 3: 버블링 이벤트 (이벤트 위임)

```javascript
// 중간 자식 — bubbles: true로 상위로 전파
handleSelect() {
    this.dispatchEvent(new CustomEvent('contactselect', {
        bubbles: true  // 부모→할아버지로 자동 전파
    }));
}
```

```html
<!-- 할아버지 컴포넌트에서 단일 리스너로 모든 손자 처리 -->
<lightning-layout-item oncontactselect={handleContactSelect}>
    <template for:each={contacts.data} for:item="contact">
        <c-contact-list-item-bubbling contact={contact}></c-contact-list-item-bubbling>
    </template>
</lightning-layout-item>
```

```javascript
// 버블링 이벤트에서 이벤트 발생 자식 참조
handleContactSelect(event) {
    this.selectedContact = event.target.contact; // event.target = 이벤트 원천 요소
}
```

---

## bubbles vs composed

| 옵션 | 효과 |
|---|---|
| `bubbles: false` (기본) | 부모에서만 수신 |
| `bubbles: true` | DOM 트리 위로 전파 |
| `composed: true` | Shadow DOM 경계 넘어 전파 |
| `bubbles: true, composed: true` | Shadow DOM 경계 포함 전파 |

> [!tip] 언제 bubbles?
> 여러 자식이 동일 이벤트를 발생시키고 공통 조상에서 처리할 때 → `bubbles: true`. 단일 부모-자식 통신에는 불필요.

---

## 이벤트명 규칙

```javascript
// ✅ 소문자, 하이픈 가능, 접두사 없음
new CustomEvent('select')
new CustomEvent('contactselect')
new CustomEvent('record-updated')

// ❌ 대문자, 특수문자
new CustomEvent('Select')
new CustomEvent('onSelect')
```

---

## connectedCallback / disconnectedCallback (수동 리스너)

```javascript
// 컴포넌트 외부 DOM에 리스너 등록 시 — 반드시 해제 짝 필요
connectedCallback() {
    window.addEventListener('resize', this.handleResize);
}

disconnectedCallback() {
    window.removeEventListener('resize', this.handleResize); // 누수 방지
}
```

---

## 관련 노트

- [[@api 패턴]] — 부모 → 자식 방향
- [[Lightning Message Service]] — 형제/크로스 컴포넌트 통신
- [[컴포지션 패턴]]
