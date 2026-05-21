---
tags: [lwc, shadow-dom, synthetic-shadow, light-dom, internals, RenderMode, ShadowMode, shadowSupportMode, migrate-mode]
source: lwc-master/packages/@lwc/engine-core/src/framework/vm.ts; lwc-master/packages/@lwc/synthetic-shadow/src/index.ts, faux-shadow/shadow-root.ts; lwc-master/packages/@lwc/engine-core/src/framework/shadow-migration-mode.ts
created: 2026-05-22
aliases: [LWC Shadow DOM, LWC Light DOM, synthetic shadow, native shadow, shadowSupportMode, RenderMode, ShadowMode, shadow migrate mode, DISABLE_SYNTHETIC_SHADOW, @lwc/synthetic-shadow]
---

# LWC Shadow DOM 모드

> LWC 컴포넌트의 세 가지 렌더링 격리 모드(Native Shadow / Synthetic Shadow / Light DOM) 내부 구현과 전환 방법.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 모드 전체 개요

| 모드 | RenderMode | ShadowMode | Shadow Root | 스타일 격리 |
|---|---|---|---|---|
| **Native Shadow DOM** | Shadow | Native | 브라우저 네이티브 | 강함 (브라우저 보장) |
| **Synthetic Shadow DOM** | Shadow | Synthetic | JS polyfill | 중간 (token 기반) |
| **Light DOM** | Light | — | 없음 | 약함 (token 기반 또는 없음) |
| **Shadow Migrate Mode** | Shadow | Native + synthetic-like 패치 | 네이티브 + 전역 CSS | 이행 중 |

---

## enum 정의 (vm.ts)

```typescript
// engine-core/src/framework/vm.ts
export const enum RenderMode {
    Light  = 0,  // Light DOM
    Shadow = 1,  // Shadow DOM (기본값)
}

export const enum ShadowMode {
    Native    = 0,  // 브라우저 네이티브 Shadow DOM
    Synthetic = 1,  // @lwc/synthetic-shadow polyfill
}

export type ShadowSupportMode = 'any' | 'reset' | 'native';
```

VM의 `renderMode`와 `shadowMode`가 런타임에 실제 동작을 결정한다.

---

## 1. Native Shadow DOM

브라우저 표준 Shadow DOM(`attachShadow()`)을 그대로 사용한다.

```javascript
// 컴포넌트 선언 (기본값)
export default class MyComp extends LightningElement {
    // renderMode: Shadow, shadowMode: Native (DISABLE_SYNTHETIC_SHADOW=true 또는 synthetic-shadow 미로드 시)
}
```

**특징:**
- `vm.shadowRoot` = 실제 브라우저 ShadowRoot
- 이벤트 리타게팅, CSS 완전 격리
- Locker/LWS와 가장 안전하게 통합

---

## 2. Synthetic Shadow DOM (@lwc/synthetic-shadow)

`@lwc/synthetic-shadow`를 로드하면, Node/Element/ShadowRoot 프로토타입을 JS로 패치해 Shadow DOM 동작을 에뮬레이션한다.

### 패치 범위 (index.ts)

```javascript
// synthetic-shadow/src/index.ts
// 환경 변수 수집 (패치 전 원본 참조 저장)
import './env/node';
import './env/element';
import './env/slot';
// ... (document, window, shadow-root 등)

// 실제 패치
import './faux-shadow/node';
import './faux-shadow/text';
import './faux-shadow/element';
import './faux-shadow/html-element';
import './faux-shadow/slot';
import './faux-shadow/portal';
import './faux-shadow/shadow-token';
```

### Faux ShadowRoot 내부 구조

```typescript
// faux-shadow/shadow-root.ts
interface ShadowRootRecord {
    mode: 'open' | 'closed';
    delegatesFocus: boolean;
    host: Element;
    shadowRoot: ShadowRoot;
}

const InternalSlot = new WeakMap<any, ShadowRootRecord>();
```

실제 ShadowRoot 대신 `WeakMap`으로 호스트-shadow root 관계를 추적한다.

### 비활성화 방법

```javascript
// DISABLE_SYNTHETIC_SHADOW 플래그: synthetic-shadow가 로드되어 있어도 무시
setFeatureFlag('DISABLE_SYNTHETIC_SHADOW', true);
```

→ 이 플래그를 설정하면 모든 컴포넌트가 Native Shadow 모드로 실행된다.

---

## 3. Light DOM

Shadow root 없이 컴포넌트의 콘텐츠가 DOM에 직접 렌더링된다. Vue/Svelte의 slot과 동일한 방식.

### 선언 방법

```javascript
// renderMode: 'light' 지정
export default class MyComp extends LightningElement {
    static renderMode = 'light';
}
```

또는 템플릿에서:

```html
<!-- lwc:render-mode="light" -->
<template lwc:render-mode="light">
    <slot></slot>
</template>
```

**특징:**
- `vm.renderMode = RenderMode.Light`
- `vm.shadowRoot = null`
- `vm.renderRoot = vm.elm` (shadow root 대신 엘리먼트 자신)
- CSS 스코핑은 scope token으로만 (격리 수준 낮음)
- 서드파티 도구(CSS framework, 외부 JS 라이브러리) 통합 용이
- `<slot>` 동작이 compile-time concern (Vue/Svelte 방식)

### `DISABLE_LIGHT_DOM_UNSCOPED_CSS` 플래그

Light DOM에서 스코프 없는 전역 CSS를 금지할 때 사용.

---

## 4. Shadow Migrate Mode

Native Shadow를 쓰면서 Synthetic Shadow처럼 동작하도록 global stylesheet를 주입하는 이행 모드.

```typescript
// engine-core/src/framework/shadow-migration-mode.ts
export function applyShadowMigrateMode(shadowRoot: ShadowRoot) {
    if (!globalStylesheet) {
        globalStylesheet = initGlobalStylesheet(); // document.head의 <style>/<link> 수집
    }

    (shadowRoot as any).synthetic = true;          // synthetic mode인 척
    shadowRoot.adoptedStyleSheets.push(globalStylesheet); // 전역 스타일 주입
}
```

`initGlobalStylesheet()`는 `MutationObserver`로 `document.head`를 감시하며,  
`<style>` / `<link rel="stylesheet">`의 내용을 `CSSStyleSheet.replaceSync()`로 구성해  
모든 shadow root에서 전역 스타일이 보이도록 한다.

### 활성화 방법

```javascript
setFeatureFlag('ENABLE_FORCE_SHADOW_MIGRATE_MODE', true);
// 또는 컴포넌트 단위: static shadowSupportMode = 'reset'
```

`vm.shadowMigrateMode = true`일 때 `applyShadowMigrateMode(shadowRoot)` 호출.

---

## shadowSupportMode — 컴포넌트 수준 선언

```typescript
// vm.ts
export type ShadowSupportMode = 'any' | 'reset' | 'native';
```

| 값 | 의미 |
|---|---|
| `'any'` (기본) | Native, Synthetic 모두 지원 |
| `'native'` | 네이티브 Shadow DOM만 허용 |
| `'reset'` | Shadow Migrate Mode 활성화 (synthetic → native 전환 지원) |

```javascript
export default class MyComp extends LightningElement {
    static shadowSupportMode = 'native'; // 이 컴포넌트는 native shadow만 사용
}
```

---

## 모드 비교 요약

| 항목 | Native Shadow | Synthetic Shadow | Light DOM |
|---|---|---|---|
| Shadow Root | 브라우저 네이티브 | JS WeakMap 에뮬레이션 | 없음 |
| 이벤트 리타게팅 | 브라우저 처리 | polyfill 처리 | 없음 |
| CSS 격리 | 완전 | scope token + polyfill | token만 (선택적) |
| `querySelector` 범위 | shadow 경계 존중 | polyfill 패치 | DOM 전체 |
| 서드파티 CSS 통합 | 어려움 | 어려움 | 쉬움 |
| Locker/LWS 통합 | 강함 | 강함 | 약함 |
| `vm.shadowRoot` | 실제 ShadowRoot | faux ShadowRoot | null |
| `vm.renderRoot` | shadowRoot | shadowRoot | elm |
| `vm.renderMode` | Shadow | Shadow | Light |
| `vm.shadowMode` | Native | Synthetic | — |

---

## 템플릿 컴파일러와의 연계

`disableSyntheticShadowSupport: true` 설정 시 컴파일러가 Synthetic Shadow를 고려하지 않아도 되므로 더 작고 빠른 코드를 생성한다.

```typescript
// codegen/codegen.ts
readonly isSyntheticShadow: boolean; // disableSyntheticShadowSupport 기반
```

slot 처리나 일부 최적화 경로가 `isSyntheticShadow` 값에 따라 분기된다.

---

## 관련 노트

- [[LWC VM 내부 구조]] — RenderMode/ShadowMode enum, shadowMigrateMode 필드
- [[LWC 런타임 Feature Flags]] — DISABLE_SYNTHETIC_SHADOW, ENABLE_FORCE_SHADOW_MIGRATE_MODE 플래그
- [[LWC 템플릿 컴파일러 파이프라인]] — disableSyntheticShadowSupport 컴파일 옵션
- [[LWC 오픈소스 아키텍처]] — @lwc/synthetic-shadow 폴리필 패키지 역할
