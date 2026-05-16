---
tags: [lwc, navigation, mixin, pageReference, pattern]
source: lwc-recipes/navToRecord, navToNewRecord, navToListView, navToFlow
created: 2026-05-17
aliases: [NavigationMixin, pageReference, 네비게이션]
---

# NavigationMixin 패턴

> `NavigationMixin`으로 LWC에서 Salesforce 내 다양한 페이지로 이동. `pageReference` 타입에 따라 목적지 지정.

---

## 기본 구조

```javascript
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class NavComponent extends NavigationMixin(LightningElement) {
    navigateSomewhere() {
        this[NavigationMixin.Navigate]({ /* pageReference */ });
    }

    // URL 생성 (공유, 앵커 태그용)
    async generateUrl() {
        const url = await this[NavigationMixin.GenerateUrl]({ /* pageReference */ });
        return url;
    }
}
```

---

## pageReference 타입별 사용법

### 기존 레코드 보기

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__recordPage',
    attributes: {
        recordId: this.recordId,
        objectApiName: 'Contact',
        actionName: 'view'  // 'view' | 'edit'
    }
});
```

### 새 레코드 생성

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'new'
    }
});

// 기본값 포함한 새 레코드
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'new'
    },
    state: {
        defaultFieldValues: encodeDefaultFieldValues({ LastName: 'Test' })
    }
});
```

### 리스트 뷰

```javascript
this[NavigationMixin.Navigate]({
    type: 'standard__objectPage',
    attributes: {
        objectApiName: 'Contact',
        actionName: 'list'
    },
    state: { filterName: 'Recent' } // 선택적 초기 필터
});
```

### Flow 실행

```javascript
// 기본 Flow
this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: { devName: 'SimpleGreetingFlow' }
});

// Flow 입력 변수 전달 (flow__ 접두사)
this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: { devName: this.flowDevName },
    state: { flow__userName: 'Trailblazer' }
});
```

### 홈, 파일, Chatter

```javascript
// 앱 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'home' } });

// 파일 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'filePreview' } });

// Chatter 홈
this[NavigationMixin.Navigate]({ type: 'standard__namedPage', attributes: { pageName: 'chatter' } });
```

---

## Workspace API (콘솔 환경)

```javascript
import { IsConsoleNavigation, openTab } from 'lightning/platformWorkspaceApi';

@wire(IsConsoleNavigation)
isConsoleNavigation;

async openTabHandler() {
    if (!this.isConsoleNavigation) return; // 비콘솔 환경 가드

    await openTab({
        pageReference: {
            type: 'standard__objectPage',
            attributes: { objectApiName: 'Contact', actionName: 'list' }
        },
        focus: true,
        label: 'Contacts'
    });
}
```

---

## pageReference 타입 참조

| type | 용도 |
|---|---|
| `standard__recordPage` | 기존 레코드 view/edit |
| `standard__objectPage` | 객체 리스트, 새 레코드 |
| `standard__namedPage` | home, filePreview, chatter |
| `standard__webPage` | 외부 URL |
| `standard__flow` | Flow 실행 |
| `standard__component` | LWC 컴포넌트 페이지 |

---

## 관련 노트

- [[Toast & 모달 패턴]]
- [[LWC 보안 패턴]]
