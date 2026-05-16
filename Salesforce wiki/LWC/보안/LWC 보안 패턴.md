---
tags: [lwc, security, permission, csp, pattern]
source: lwc-recipes/miscPermissionBasedUI, miscGetUserId, miscRestApiCall, miscLogger
created: 2026-05-17
aliases: [LWC 보안, customPermission, CSP, userId]
---

# LWC 보안 패턴

> 권한 기반 UI, 사용자 ID 획득, 외부 API 보안, 로깅 계층. 프론트엔드 검증은 UX 용이고, 백엔드 재검증 필수.

---

## 패턴 1: 커스텀 권한 기반 UI

```javascript
import hasAccessRestrictedUI from '@salesforce/customPermission/accessRestrictedUIPermission';

export default class PermissionBasedUI extends LightningElement {
    // @wire 불필요 — 컴파일 타임에 권한 정보 삽입
    get isRestrictedUIAccessible() {
        return hasAccessRestrictedUI; // boolean
    }
}
```

```html
<template lwc:if={isRestrictedUIAccessible}>
    <!-- 권한 있는 사용자만 표시 -->
    <lightning-button label="Admin Action"></lightning-button>
</template>
<template lwc:else>
    <p>이 기능에 대한 접근 권한이 없습니다.</p>
</template>
```

| Import | 설명 |
|---|---|
| `@salesforce/customPermission/{ApiName}` | Custom Permission Set 권한 |
| `@salesforce/userPermission/{ApiName}` | 표준 Salesforce 권한 |

> [!warning] 이중 계층 검증 필수
> 프론트엔드 권한 체크는 UX(UI 숨김)용. 실제 보안은 Apex에서 재검증 필수.
> 권한 변경은 페이지 새로고침 후 반영 (정적 컴파일).

---

## 패턴 2: 사용자 ID 획득

```javascript
import Id from '@salesforce/user/Id';

export default class GetUserId extends LightningElement {
    userId = Id; // @wire 없이 정적 할당

    get maskedId() {
        return this.userId?.substring(0, 6) + '...';
    }
}
```

**활용:**
- 현재 사용자 기반 데이터 필터링 (`WHERE OwnerId = :userId`)
- 감사 로그에 사용자 추적
- 사용자별 설정 로드

---

## 패턴 3: 외부 REST API — CSP 준수

```javascript
const BASE_URL = 'https://api.example.com/';

async handleSearch() {
    try {
        this.isLoading = true;

        // ① CSP Trusted Sites 등록 필수
        // Setup > Security > CSP Trusted Sites > New
        const response = await fetch(BASE_URL + this.searchKey);

        // ② fetch는 네트워크 에러만 throw — HTTP 에러 직접 체크
        if (!response.ok) {
            throw Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        this.data = await response.json();
        this.error = undefined;
    } catch (error) {
        this.error = error;
        this.data = undefined;
    } finally {
        this.isLoading = false; // 항상 실행
    }
}
```

> [!tip] fetch 대신 Apex + Named Credential 권장
> - FLS/CRUD 자동 검증
> - OAuth 토큰 자동 갱신
> - 인증 정보 코드 노출 없음
> - CSP 설정 불필요

---

## 패턴 4: 이중 계층 로깅

```javascript
import { log } from 'lightning/logger';

// 감사/규정 준수 로그 (Event Monitoring)
logAuditEvent(action) {
    log({ type: action, userId: this.userId });
    // Setup > Event Monitoring > Lightning Logger Events 활성화 필요
}

// 개발 디버그 로그
logDebug(message) {
    console.log('[MyComponent]', message);
}
```

| 방법 | 용도 | 저장 위치 |
|---|---|---|
| `lightning/logger` | 감사, 규정 준수 | Salesforce Event Monitoring |
| `console.log` | 개발 디버깅 | 브라우저 콘솔만 |

---

## 패턴 5: DOM 쿼리 안전 패턴

```javascript
// Shadow DOM — this.template 통해서만 접근
handleCheckboxChange() {
    const checked = Array.from(
        this.template.querySelectorAll('lightning-input')
    )
    .filter(el => el.checked)
    .map(el => el.label);
}

// querySelector 결과는 항상 null 체크
const input = this.template.querySelector('lightning-input');
if (input) {
    input.value = '';
}

// innerText 사용 (innerHTML XSS 위험)
this.template.querySelector('p').innerText = userValue; // ✅
this.template.querySelector('p').innerHTML = userValue; // ❌ XSS 위험
```

---

## i18n — 사용자 로케일 자동 적용

```javascript
import USER_LOCALE from '@salesforce/i18n/locale';
import USER_CURRENCY from '@salesforce/i18n/currency';

get formattedDate() {
    return new Intl.DateTimeFormat(USER_LOCALE).format(new Date());
}

get formattedCurrency() {
    return new Intl.NumberFormat(USER_LOCALE, {
        style: 'currency',
        currency: USER_CURRENCY
    }).format(this.amount);
}
```

---

## 보안 체크리스트

- [ ] 프론트엔드 권한 체크 (`@salesforce/customPermission`) + Apex 재검증
- [ ] 외부 fetch → CSP Trusted Sites 등록 + `response.ok` 체크
- [ ] 민감한 데이터 처리는 Apex + Named Credential
- [ ] DOM 조작 시 `innerText` (XSS 방지), `innerHTML` 금지
- [ ] 감사 대상 액션은 `lightning/logger` 기록

---

## 관련 노트

- [[Imperative 호출 패턴]]
- [[Wire 패턴]]
- [[NavigationMixin 패턴]]
