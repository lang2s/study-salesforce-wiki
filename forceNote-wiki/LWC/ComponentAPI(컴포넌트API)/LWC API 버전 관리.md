---
tags: [lwc, api-version, js-meta-xml, component-bundle, versioning, dynamic-import, lws]
aliases: [LWC API Version, apiVersion, js-meta.xml apiVersion, 컴포넌트 API 버전]
source: Release/Winter '24.md (Tier 1) + 외부 지식 (Tier 3)
created: 2026-05-22
updated: 2026-05-22
---

# LWC API 버전 관리

> LWC 컴포넌트는 `.js-meta.xml`의 `<apiVersion>` 요소로 **프레임워크 동작 버전**을 고정할 수 있다.  
> API 버전이 낮아도 컴파일·실행은 되지만, 특정 버전 이후 도입된 동작 변경은 적용되지 않는다.

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 1. .js-meta.xml 구조

모든 LWC 컴포넌트 번들에는 `.js-meta.xml` 설정 파일이 필수다.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>59.0</apiVersion>
    <isExposed>true</isExposed>
</LightningComponentBundle>
```

| 요소 | 타입 | 설명 |
|---|---|---|
| `<apiVersion>` | Double | 컴포넌트가 사용하는 Salesforce API / LWC 프레임워크 버전 |
| `<isExposed>` | Boolean | App Builder·레코드 페이지에서 배치 허용 여부 |
| `<targets>` | — | 사용 가능한 컨텍스트 지정 (App Page, Record Page 등) |
| `<targetConfigs>` | — | 각 target별 속성 노출 설정 |

---

## 2. apiVersion 핵심 규칙

> **출처:** [[Release/Winter '24]] (API v59.0 릴리즈)  
> 컴포넌트 수준 API 버전 지정은 Winter '24(v59.0)에서 GA 됨.

| 규칙 | 내용 |
|---|---|
| **최솟값** | 58.0 미만 값은 **58.0으로 처리** (하한 보정) |
| **최댓값** | 현재 Org API 버전 이하여야 함 |
| **동작 보장** | 지정된 버전의 LWC 프레임워크 동작이 유지됨 |
| **미지정 시** | Org의 현재 API 버전으로 자동 설정 |
| **Scratch Org** | 프로젝트 `sfdx-project.json`의 `sourceApiVersion`이 기본값 |

---

## 3. 버전별 주요 변경 이력

> **[외부 지식 — Tier 3]** 아래 내용은 Salesforce 릴리즈 노트를 기반으로 한 외부 지식이다.

| API 버전 | 릴리즈 | 주요 변경 |
|---|---|---|
| **55.0** | Spring '22 | 동적 컴포넌트 import (`await import('c/...')`) 사용 가능 최솟값 |
| **57.0** | Spring '23 | `lwc:ref` 지시자 도입 |
| **58.0** | Summer '23 | `lwc:spread` GA; `lwc:if/lwc:elseif/lwc:else` 도입 (기존 `if:true`/`if:false` 대체) |
| **59.0** | Winter '24 | 컴포넌트 수준 `<apiVersion>` 지정 GA; 동적 임포트 + 인스턴스화 GA |
| **60.0** | Spring '24 | `@salesforce/userPermission` 등 권한 모듈 확장 |
| **61.0** | Summer '24 | `@lwc/state` Alpha (상태 관리) |
| **62.0** | Winter '25 | `@lwc/state` Beta |

---

## 4. 동적 컴포넌트 임포트 (apiVersion ≥ 55.0)

런타임에 알 수 없는 컴포넌트를 동적으로 로드하려면 `apiVersion 55.0` 이상 + **Lightning Web Security(LWS)** 활성화가 필요하다.

```javascript
// LWS 활성화 + apiVersion >= 55.0 필요
async loadDynamicComponent() {
    try {
        const { default: ctor } = await import('c/myDynamicComponent');
        const el = this.template.createComponent(ctor);
        this.template.querySelector('.container').appendChild(el);
    } catch (e) {
        console.error('Dynamic component load failed:', e);
    }
}
```

> ⚠️ LWR Sites(Experience Cloud LWR)에서는 **정적 분석 가능한 형식**만 지원. 변수를 경로로 사용하는 패턴은 LWR에서 동작하지 않는다.

---

## 5. lwc:if / lwc:elseif / lwc:else (apiVersion ≥ 58.0)

`if:true` / `if:false`는 deprecated. `apiVersion 58.0` 이상에서는 새 디렉티브를 사용한다.

```html
<!-- apiVersion >= 58.0 권장 방식 -->
<template lwc:if={isAdmin}>
    <p>관리자 전용 내용</p>
</template>
<template lwc:elseif={isMember}>
    <p>회원 전용 내용</p>
</template>
<template lwc:else>
    <p>게스트 내용</p>
</template>
```

```html
<!-- apiVersion < 58.0 구형 방식 (deprecated) -->
<template if:true={isAdmin}>
    <p>관리자 전용 내용</p>
</template>
```

---

## 6. 버전 관리 전략

| 상황 | 권장 전략 |
|---|---|
| **신규 컴포넌트** | 현재 Org API 버전 사용 |
| **레거시 컴포넌트 유지** | 동작이 검증된 버전 고정 (업그레이드 테스트 후 올리기) |
| **패키지 배포** | 패키지 최솟값 API 버전과 맞추거나 그 이상 |
| **동적 임포트 필요** | `apiVersion >= 55.0` + LWS 활성화 확인 |
| **if:true → lwc:if 마이그레이션** | `apiVersion >= 58.0` 으로 올린 뒤 템플릿 수정 |

---

## 7. sfdx-project.json 설정

프로젝트 전체 기본 버전은 `sfdx-project.json`의 `sourceApiVersion`으로 지정한다.

```json
{
    "packageDirectories": [
        {
            "path": "force-app",
            "default": true
        }
    ],
    "namespace": "",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "67.0"
}
```

> 개별 컴포넌트의 `.js-meta.xml`이 우선 적용된다.  
> `sourceApiVersion`은 명시적으로 지정하지 않은 컴포넌트의 기본값으로 사용.

---

## 관련 문서

- [[@api 패턴]] — `@api` 속성/메서드 공개 인터페이스
- [[컴포지션 패턴]] — `lwc:if/lwc:elseif/lwc:else`, `for:each` 패턴
- [[Release/Winter '24]] — 컴포넌트 수준 apiVersion 지정 GA 릴리즈
