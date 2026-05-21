---
tags: [lwc, architecture, internals, compiler, runtime, ssr, virtual-dom, shadow-dom, static-content-optimization]
source: lwc-master/ARCHITECTURE.md (salesforce/lwc open-source)
created: 2026-05-22
aliases: [LWC 아키텍처, LWC 내부 구조, lwc monorepo, @lwc/compiler, @lwc/engine-core, @lwc/engine-dom, @lwc/ssr-compiler, static content optimization, virtual DOM LWC]
---

# LWC 오픈소스 아키텍처

> salesforce/lwc 모노레포 전체 구조 — Compiler·Runtime·SSR 분리 설계, 패키지 역할, 프레임워크 설계 결정.

**상위:** [[Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 고수준 분류

LWC 코드베이스는 크게 두 카테고리로 나뉜다.

| 카테고리 | 실행 환경 | 설명 |
|---|---|---|
| **Compiler** | Node.js (빌드 타임) | HTML/CSS/JS 파일을 처리해 최적화된 JS 출력 |
| **Runtime** | Browser / Node.js (SSR) | 컴포넌트 렌더링·생명주기·반응성 처리 |

---

## 컴파일러 패키지 구조

```
@lwc/rollup-plugin
    └── @lwc/compiler
            ├── HTML  → @lwc/template-compiler   (parse5 기반)
            ├── CSS   → @lwc/style-compiler       (PostCSS 기반)
            └── JS    → @lwc/babel-plugin-component (Babel 기반)

SSR 경로:
@lwc/compiler
    └── HTML/JS → @lwc/ssr-compiler  (targetSSR 플래그로 분기)
```

- `@lwc/template-compiler`: HTML → JS 변환. `parse5`로 파싱, 템플릿 directive 처리, static content optimization 적용.
- `@lwc/style-compiler`: CSS → scoped JS. PostCSS 기반, CSS 스코핑 토큰 삽입.
- `@lwc/babel-plugin-component`: JS/TS 데코레이터(`@api`, `@track`, `@wire`) 변환, `import { LightningElement } from 'lwc'` 재작성.
- `@lwc/rollup-plugin`: Rollup 번들러 통합. webpack(`lwc-webpack-plugin`), Vite(`vite-plugin-lwc`) 같은 외부 번들러는 `@lwc/compiler`를 직접 호출.

---

## 런타임 패키지 구조

```
@lwc/engine-dom      (CSR 브라우저)
    └── @lwc/engine-core  (공통 핵심 로직)
@lwc/engine-server   (SSR 레거시 — 향후 deprecated 예정)
    └── @lwc/engine-core

신규 SSR:
@lwc/ssr-compiler + @lwc/ssr-runtime  (engine-server 대체 예정)
```

| 패키지 | 역할 |
|---|---|
| `@lwc/engine-core` | LightningElement, VM, 반응성, 렌더링 공통 로직 |
| `@lwc/engine-dom` | 브라우저 DOM API와 최소 인터페이스 (CSR) |
| `@lwc/engine-server` | pseudo-DOM 구축 후 HTML 문자열 직렬화 (SSR 레거시) |
| `@lwc/ssr-compiler` | HTML/JS를 SSR 전용 코드로 컴파일 (`targetSSR` 플래그) |
| `@lwc/ssr-runtime` | SSR 실행 런타임 (`LightningElement` 포함) |

> `@lwc/engine-server`는 CSR 대비 성능이 낮아 장기적으로 `@lwc/ssr-compiler/runtime`으로 교체 예정.  
> `ssr-runtime`은 `engine-dom`, `engine-server`의 형제 패키지로, 세 패키지 모두 동일한 API surface(e.g. `LightningElement`)를 export 해야 한다.

---

## 공유 패키지

| 패키지 | 역할 |
|---|---|
| `@lwc/errors` | 공통 에러 메시지 카탈로그 |
| `@lwc/features` | 런타임 Feature Flag (`lwcRuntimeFlags` 글로벌) |
| `@lwc/shared` | 유틸리티·타입 모음 (위 두 카테고리 모두 공유) |

---

## 헬퍼 패키지

| 패키지 | 역할 |
|---|---|
| `@lwc/module-resolver` | LWC 커스텀 모듈 해석 로직 |
| `@lwc/signals` | 클라이언트 사이드 Signals 구현 (`Signal<T>`, `SignalBaseClass<T>`) |
| `@lwc/types` | HTML/CSS import용 TypeScript 헬퍼 타입 |
| `@lwc/wire-service` | `@wire` 서비스 구현 (legacy `register()` + 현재 WireAdapter 지원) |

---

## 폴리필 패키지

| 패키지 | 역할 |
|---|---|
| `@lwc/aria-reflection` | ARIA string reflection (WICG AOM 스펙 polyfill) |
| `@lwc/synthetic-shadow` | Shadow DOM polyfill (LWC 전용 훅 포함) |

이상적으로는 두 패키지 모두 불필요하지만, 하위 호환성 때문에 유지.

---

## `import { LightningElement } from 'lwc'` 처리

`'lwc'`는 번들 패키지(`packages/lwc`)지만, `import` 구문은 주로 **컴파일 타임 관심사**다.  
컴파일러가 `'lwc'`를 실행 환경에 맞게 재작성한다:
- CSR: `@lwc/engine-dom`으로 변환
- SSR(새): `@lwc/ssr-runtime`으로 변환

---

## 프레임워크 설계 결정

### Virtual DOM → Static Content Optimization

초기(2016–2019) LWC는 Vue처럼 Virtual DOM + snabbdom 기반이었다. 이후 성능 개선을 위해 **Static Content Optimization**(= "fine-grained reactivity")을 도입:

- 정적인 HTML 블록을 `<template>` / `innerHTML` / `cloneNode` 방식으로 처리 (VDOM diffing 대신)
- 비정적 블록도 점차 최적화 확장
- VDOM + 최적화 경로 두 가지가 공존 (CI는 두 모드 모두 테스트)

### Shadow DOM & Light DOM

| 모드 | 특징 |
|---|---|
| **Shadow DOM** (기본) | 네이티브/합성 Shadow DOM, Locker/LWS 통합, 스타일 격리 강함 |
| **Light DOM** | Vue/Svelte 방식, 스타일 격리 약함, 서드파티 도구 통합 용이 |

`renderMode: 'light'` 지정으로 Light DOM 사용 가능. Stencil과 유사한 pragmatic 선택.

### Component-level API Versioning

Salesforce Lightning 플랫폼의 강한 하위 호환성 요구로 LWC에만 있는 개념. 한 컴포넌트 내부의 breaking change가 다른 컴포넌트에 관찰되지 않으면, API versioning으로 격리해 적용한다. `.js-meta.xml`의 `<apiVersion>` 설정으로 제어.

→ [[LWC API 버전 관리]]

---

## 관련 노트

- [[@api 데코레이터 내부 구조]] — engine-core 데코레이터 구현
- [[@track 데코레이터 내부 구조]] — reactive proxy 상세
- [[LWC VM 내부 구조]] — VM 인터페이스, 생명주기 함수
- [[@wire 어댑터 내부 구조]] — @wire 서비스 내부 동작
- [[LWC API 버전 관리]] — apiVersion 설정 가이드
