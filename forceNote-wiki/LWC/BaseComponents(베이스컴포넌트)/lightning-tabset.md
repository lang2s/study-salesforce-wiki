---
tags: [lwc, base-components, lightning-tabset, tabs, navigation, ui]
source: external-knowledge
created: 2026-05-22
aliases: [lightning-tabset, 탭셋, 탭 컨테이너]
---

# lightning-tabset

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.

> 여러 탭(lightning-tab)을 그룹화하는 컨테이너 컴포넌트 — 한 번에 하나의 탭 콘텐츠를 표시한다.

---

## 기본 사용

```html
<lightning-tabset>
    <lightning-tab label="탭 1" value="tab1">
        <p>탭 1 내용</p>
    </lightning-tab>
    <lightning-tab label="탭 2" value="tab2">
        <p>탭 2 내용</p>
    </lightning-tab>
</lightning-tabset>
```

---

## 주요 속성

### lightning-tabset

| 속성 | 타입 | 설명 |
|---|---|---|
| `active-tab-value` | String | 초기 선택 탭의 value |
| `variant` | String | `default` \| `scoped` \| `vertical` — 탭 스타일 |
| `selected-tab-value` | String | 현재 선택된 탭 value |

### lightning-tab

| 속성 | 타입 | 설명 |
|---|---|---|
| `label` | String | 탭 헤더에 표시되는 텍스트 |
| `value` | String | 탭 식별자 (고유해야 함) |
| `icon-name` | String | 탭 헤더 아이콘 (예: `utility:user`) |
| `show-error-indicator` | Boolean | 탭 헤더에 에러 표시 여부 |
| `is-loaded` | Boolean | 탭 콘텐츠가 DOM에 로드되었는지 |

---

## 이벤트 — ontabchange

```html
<lightning-tabset ontabchange={handleTabChange}>
    <lightning-tab label="계정" value="account">...</lightning-tab>
    <lightning-tab label="연락처" value="contact">...</lightning-tab>
</lightning-tabset>
```

```javascript
handleTabChange(event) {
    const selectedTabValue = event.target.value;
    console.log('선택된 탭:', selectedTabValue);
}
```

---

## Variant 비교

| variant | 설명 |
|---|---|
| `default` | 기본 탭 스타일 (상단 탭 헤더) |
| `scoped` | 박스 테두리가 있는 탭 |
| `vertical` | 세로 탭 배열 |

---

## 초기 활성 탭 지정

```html
<lightning-tabset active-tab-value="contact">
    <lightning-tab label="계정" value="account">...</lightning-tab>
    <lightning-tab label="연락처" value="contact">...</lightning-tab>
</lightning-tabset>
```

---

## 관련 노트

- [[lightning-accordion]] — 펼치기/접기 패턴의 대안 컴포넌트
- [[lightning-card]] — 탭 내부에 카드 배치 패턴
