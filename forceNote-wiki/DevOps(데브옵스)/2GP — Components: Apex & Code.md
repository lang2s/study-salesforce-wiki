---
tags: [DevOps, Packaging, 2GP, ManagedPackage, ApexClass, ApexTrigger, LWC, AuraComponent, StaticResource, VisualforceComponent, VisualforcePage, ManageabilityRules, IPProtection, PackagingConsiderations, Components]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — Components Available in Second-Generation Managed Packages (p.47–60, 65–67, 224–225, 280, 294–296)
created: 2026-05-23
aliases: [2GP Apex Class 패키징, 2GP Apex Trigger 패키징, 2GP LWC 패키징, 2GP Aura Component 패키징, 2GP Static Resource 패키징, 2GP Visualforce 패키징, Apex Sharing Reason 패키징, 2GP 코드 컴포넌트 Manageability Rules, ApexClass 2GP, ApexTrigger 2GP, LightningComponentBundle 2GP, AuraDefinitionBundle 2GP, StaticResource 2GP, ApexComponent 2GP, ApexPage 2GP]
---

# 2GP — Components: Apex & Code

> 2GP Managed Package에서 **Apex 및 코드 관련 컴포넌트**의 패키징 규칙 전수. Manageability Rules 4속성, Editable Properties 3카테고리, 패키징 시 고려사항, 라이선스 요건을 컴포넌트별로 정리.

---

## Manageability Rules — 읽는 방법

각 컴포넌트마다 아래 4속성이 정의된다.

| 속성 | 의미 |
|---|---|
| **Component Is Updated During Package Upgrade** | 패키지 신버전 설치 시 해당 컴포넌트가 구독자 org에서 자동 업데이트되는가 |
| **Subscriber Can Delete Component From Org** | 구독자가 자기 org에서 이 컴포넌트를 삭제할 수 있는가 |
| **Package Developer Can Remove Component From Package** | 개발자가 신버전 패키지에서 이 컴포넌트를 제거할 수 있는가 |
| **Component Has IP Protection** | Apex 코드가 구독자 org에서 난독화(obfuscated)되어 보이지 않는가 |

Editable Properties After Package Promotion or Installation은 3카테고리로 구분된다.
- **Only Package Developer Can Edit** — 개발자만 신버전에서 수정 가능
- **Both Package Developer and Subscriber Can Edit** — 양측 모두 수정 가능
- **Neither Package Developer or Subscriber Can Edit** — 양측 모두 수정 불가 (잠김)

> 컴포넌트 제거(Remove)는 Salesforce 승인이 필요하다. 제거 기능 접근을 요청하려면 Salesforce Partner Community에 지원 케이스를 등록한다.

---

## Apex Class

> Represents an Apex Class. An Apex class is a template or blueprint from which Apex objects are created. Classes consist of other classes, user-defined methods, variables, exception types, and static initialization code.

**Metadata Name:** `ApexClass`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (global access로 설정된 경우 제외). 1GP·2GP 모두 지원 |
| Component Has IP Protection | **Yes** |

> IP Protection이 Yes이므로 Apex 클래스·트리거·VF 컴포넌트 코드는 구독자 org에서 난독화되어 볼 수 없다. 예외: `global`로 선언된 메서드 시그니처는 볼 수 있다. License Management Org 사용자가 Subscriber Support Console로 로그인한 경우 "View and Debug Managed Apex" 권한으로 난독화된 클래스 조회 가능.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Code |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Considerations When Packaging

- 패키지에 포함된 Apex 코드는 **누적 테스트 커버리지 75% 이상** 필수. 각 트리거에도 일부 테스트 커버리지 필요. AppExchange 업로드 및 구독자 org 설치 시 모든 테스트가 실행된다.
- 관리형 패키지는 **고유 namespace**를 받는다. 이 namespace는 클래스명·메서드·변수 등에 자동으로 접두어로 붙어 구독자 org의 이름 충돌을 방지한다.
- 단일 트랜잭션 내에서 **최대 10개 고유 namespace**만 참조 가능. 패키지 A가 패키지 B의 클래스를 간접 호출하더라도 같은 트랜잭션이면 포함된다.
- Web service로 노출하는 메서드가 있으면 구독자가 외부 코드를 작성할 수 있도록 상세 문서를 포함한다.
- 커스텀 레이블 + 번역을 사용하는 Apex 클래스가 있으면 원하는 언어를 명시적으로 패키지에 포함해야 번역이 같이 배포된다.
- 커스텀 오브젝트의 sharing object(예: `MyCustomObject__share`)를 Apex에서 참조하면 패키지에 sharing model 의존성이 생긴다. 다른 org에서 설치 성공을 보장하려면 해당 커스텀 오브젝트의 org-wide 기본 접근 수준을 **Private**으로 설정한다.
- 관리형 패키지의 Apex 클래스·트리거·VF 컴포넌트 코드는 구독자 org에서 난독화된다. `global` 메서드 시그니처만 예외적으로 볼 수 있다.
- `@deprecated` 어노테이션을 사용해 global 메서드·클래스·예외·enum·인터페이스·변수를 더 이상 참조할 수 없도록 표시할 수 있다. 기존 구독자에게는 계속 동작하고 새 구독자에게는 보이지 않는다.
- Data Categories를 참조하는 Apex 코드는 업로드 불가.
- VF 페이지나 global VF 컴포넌트를 패키지에서 삭제하기 전에 public Apex 클래스·public VF 컴포넌트에 대한 모든 참조를 먼저 제거하고, 중간 버전으로 구독자를 업그레이드한 다음 삭제한다.

**Usage Limits:** 단일 배포에서 Apex 클래스·트리거 코드 유닛 최대 **7,500개**. (Apex Developer Guide: Execution Governors and Limits 참조)

### Documentation

- Second-Generation Managed Packaging Developer Guide: Namespace-Based Visibility for Apex Classes in Second-Generation Managed Packages
- First-Generation Managed Packaging Developer Guide: About API and Dynamic Apex Access in Packages
- First-Generation Managed Packaging Developer Guide: Using Apex in Group and Professional Editions

```xml
<!-- 구조 예시 — Apex Class Metadata XML -->
<!-- MyHelloWorld.cls-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>67.0</apiVersion>
  <status>Active</status>
</ApexClass>
```

---

## Apex Sharing Reason

> Represents an Apex sharing reason, which is used to indicate why sharing was implemented for a custom object.

**Metadata Name:** `SharingReason`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Reason Label |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Reason Name |

### Considerations When Packaging

- Apex sharing reason은 패키지에 직접 추가할 수 있지만 **커스텀 오브젝트에만** 사용 가능하다.

### Documentation

- Metadata API Developer Guide: SharingReason

---

## Apex Trigger

> Represents an Apex trigger. A trigger is Apex code that executes before or after specific DML events occur.

**Metadata Name:** `ApexTrigger`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> IP Protection이 No이지만 Apex Trigger 코드는 관리형 패키지에서 난독화된다. Apex Class의 IP Protection(Yes)과는 별도 표기이나 실제 코드 보호는 동일하게 적용된다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Code |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Documentation

- Apex Developer Guide: Triggers

```apex
// 구조 예시 — 관리형 패키지 내 트리거 (namespace 자동 접두어 적용)
trigger ns__MyTrigger on ns__MyObject__c (before insert, before update) {
    // 패키지 클래스 호출 시 namespace 접두어 필요
    ns__MyHandler.handleTrigger(Trigger.new, Trigger.old);
}
```

---

## Aura Component (AuraDefinitionBundle)

> Represents an Aura definition bundle. A bundle contains an Aura definition, such as an Aura component, and its related resources, such as a JavaScript controller. The definition can be a component, application, event, interface, or a tokens collection.

**Metadata Name:** `AuraDefinitionBundle`
**Packageable In:** 2GP, 1GP

Lightning 컴포넌트는 두 가지 프로그래밍 모델을 지원한다: Lightning Web Components 모델과 원래의 Aura Components 모델.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 Aura 또는 LWC 컴포넌트를 패키지에서 제거하면, 해당 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다. `public` 또는 `global` access value를 가진 Aura/LWC 컴포넌트 모두 동일하게 적용된다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Description, Label, Markup |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Documentation

- Lightning Aura Components Developer Guide

---

## Lightning Web Component (LightningComponentBundle)

> Represents a Lightning web component bundle. A bundle contains Lightning web component resources.

**Metadata Name:** `LightningComponentBundle`
**Packageable In:** 2GP, 1GP

Lightning 컴포넌트는 두 가지 프로그래밍 모델을 지원한다: Lightning Web Components 모델과 원래의 Aura Components 모델.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 LWC를 패키지에서 제거하면 컴포넌트는 구독자 org에 남는다. `public` 또는 `global` access value를 가진 Aura/LWC 모두 동일 동작.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Description, isExposed (false→true 방향만 변경 가능), Label, Markup, Targets, targetConfigs, targetConfig, property |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

> `<property>` 태그에 대한 특정 변경은 관리형 패키지나 Experience Builder 사이트에서 사용 중인 커스텀 컴포넌트에서 불가. 자세한 내용은 Lightning Web Components Developer Guide: Considerations for configuring a component for Experience Builder 참조.

### Considerations When Packaging

**라이선스 고려사항:**
- LWC는 관리형 패키지 라이선스를 자동으로 enforce하지 않는다. 관리형 패키지의 LWC는 해당 패키지의 활성 라이선스가 없는 사용자도 볼 수 있고 사용할 수 있다. 패키지 트라이얼이 만료된 후에도 마찬가지다.
- AppExchange 파트너는 LWC에서 직접 패키지 라이선스를 enforce해야 한다. 권장 방법: `UserInfo.isCurrentUserLicensed(namespace)` 또는 `UserInfo.isCurrentUserLicensedForPackage(packageID)` 메서드를 호출하는 Apex 컨트롤러를 사용하고, `true`가 반환된 경우에만 컴포넌트를 렌더링한다.

**isExposed 사용 시 고려사항:**
- `isExposed = false`: 개발자는 configuration target과 public(`@api`) 프로퍼티를 제거할 수 있다. 컴포넌트는 다른 namespace나 Lightning App Builder, Experience Builder에서 사용할 수 없다.
- `isExposed = true` + 발행된 관리형 패키지: 개발자는 configuration target이나 public(`@api`) 프로퍼티를 제거할 수 없다. 최근 패키지 발행 이후 추가된 target이나 public 프로퍼티도 마찬가지.
- `isExposed = true`: 컴포넌트는 다른 namespace(발행된 관리형 패키지 외부 포함)에서 사용 가능.
- `isExposed = true` + `Targets` 값도 있으면: Lightning App Builder, Experience Builder 같은 Salesforce 빌더에서 사용 가능.
- `isExposed = true`인 LWC 삭제 시 2단계 프로세스 권장: 삭제할 컴포넌트가 패키지 내 다른 항목에 의존성이 없도록 먼저 확인. 자세한 내용은 "Remove Components from Second-Generation Managed Packages" 참조.

### Documentation

- Lightning Web Components Developer Guide
- Lightning Web Components Developer Guide: Add Components to Managed Packages
- Lightning Web Components Developer Guide: Delete Components from Managed Packages

```javascript
// 구조 예시 — 관리형 패키지 LWC에서 라이선스 enforce 패턴
import { LightningElement, wire } from 'lwc';
import isLicensed from '@salesforce/apex/MyController.isCurrentUserLicensed';

export default class MyManagedComponent extends LightningElement {
    @wire(isLicensed)
    licensedStatus;

    get isUserLicensed() {
        return this.licensedStatus.data === true;
    }
}
```

---

## Static Resource

> Represents a static resource file, often a code library in a ZIP file.

**Metadata Name:** `StaticResource`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, File |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Documentation

- Metadata API Developer Guide: StaticResource

---

## Visualforce Component (ApexComponent)

> Represents a Visualforce component.

**Metadata Name:** `ApexComponent`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **Yes** |

> **1GP:** public VF 컴포넌트를 새 버전에서 제거하면 구독자 org에서 삭제된다. global VF 컴포넌트는 어드민이 수동 삭제할 때까지 구독자 org에 남는다.
> **2GP:** VF 컴포넌트는 hard-deleted되며, `global`로 표시되지 않은 컴포넌트만 패키지에서 제거 가능하다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Description, Label, Markup |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Documentation

- Visualforce Components (개발자 가이드)

---

## Visualforce Page (ApexPage)

> Represents a Visualforce page.

**Metadata Name:** `ApexPage`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> public VF 컴포넌트(또는 VF 페이지)를 새 버전에서 제거하면 구독자 org에서 삭제된다. global VF 컴포넌트(또는 VF 페이지)는 어드민이 수동 삭제할 때까지 구독자 org에 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | API Version, Description, Label, Markup |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Documentation

- Visualforce Page (Metadata API Developer Guide)

---

## 전체 비교표

| 컴포넌트 | Metadata Name | Updated on Upgrade | Subscriber Can Delete | Dev Can Remove | IP Protection |
|---|---|---|---|---|---|
| Apex Class | `ApexClass` | Yes | No | Yes (not global) | **Yes** |
| Apex Sharing Reason | `SharingReason` | Yes | No | **No** | No |
| Apex Trigger | `ApexTrigger` | Yes | No | Yes | No |
| Aura Component | `AuraDefinitionBundle` | Yes | No | Yes | No |
| Lightning Web Component | `LightningComponentBundle` | Yes | No | Yes | No |
| Static Resource | `StaticResource` | Yes | No | Yes | No |
| Visualforce Component | `ApexComponent` | Yes | No | Yes | **Yes** |
| Visualforce Page | `ApexPage` | Yes | No | Yes | No |

**주요 패턴:**
- Apex Class는 IP Protection이 Yes → 코드 난독화. 단, `global`로 선언된 Apex Class는 제거 불가.
- Visualforce Component도 IP Protection Yes → 코드 난독화.
- Apex Sharing Reason만 Developer Can Remove가 No → 한번 패키지에 넣으면 제거 불가.
- 모든 코드 컴포넌트는 Subscriber Can Delete가 No → 구독자가 임의로 삭제 불가.

---

## 관련 노트

- [[Metadata Types — Apex & Code]] — MetadataAPI 관점의 동일 컴포넌트 필드 정의 (apiVersion, content, status 등)
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로·Manageability Rules 4속성 개요·Supported Components 전체 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — Manageability Rules 개념 설명·Package Ancestry·IP Protection 원리
- [[2GP — Components: Automation]] — Flow·Workflow·Decision Table·Batch·Expression Set 등 자동화 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Einstein & Analytics]] — Einstein·Analytics·Agentforce·Bot·Report/Dashboard 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Integration & Platform]] — NamedCredential·FeatureParameter·ExternalDataSource·EventRelayConfig·PlatformCachePartition 등 통합·플랫폼 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Objects & Fields]] — AssessmentQuestion·BriefcaseDefinition·CustomObject·CustomField·CustomLabels·GlobalValueSet·Folder·FieldSet 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Security & Access]] — AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·CspTrustedSite·ExternalAuthIdentityProvider·ExternalCredential·IdentityVerificationProcDef·PermissionSet·PermissionSetGroup 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
