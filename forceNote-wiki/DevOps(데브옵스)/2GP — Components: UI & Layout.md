---
tags: [devops, 2gp, managed-package, packaging, components, ui, layout, flexi-page, custom-application, custom-tab, experience-builder, quick-action, lightning-page, ManageabilityRules, IPProtection]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — Components Available in Second-Generation Managed Packages, pp.43, 71–72, 85–88, 97–99, 112–113, 137–138, 208–209, 220–223, 228–229, 244–245, 245–246, 259–260
created: 2026-05-24
aliases: [2GP UI Layout 컴포넌트, 2GP CustomApplication 패키징, 2GP CustomTab 패키징, 2GP FlexiPage 패키징, 2GP LightningPage 패키징, 2GP QuickAction 패키징, 2GP ExperienceBundle 패키징, 2GP DigitalExperienceBundle 패키징, 2GP BrandingSet 패키징, 2GP LightningMessageChannel 패키징, 2GP LightningTypeBundle 패키징, 2GP LightningBolt 패키징, 2GP ManagedContentType 패키징, 2GP HomePageComponent 패키징, 2GP HomePageLayout 패키징, 2GP CompactLayout 패키징, 2GP CommunityTemplateDefinition 패키징, 2GP CommunityThemeDefinition 패키징, 2GP PathAssistant 패키징, 2GP Prompt 패키징, 2GP Layout 패키징, ActionLinkGroupTemplate 2GP, ActionableListDefinition 2GP, 2GP UI 컴포넌트 Manageability Rules]
---

# 2GP — Components: UI & Layout

> 2GP Managed Package에서 **UI·레이아웃 관련 컴포넌트**의 패키징 규칙 전수. Lightning 페이지, 커스텀 앱, 탭, Experience Builder, Quick Action, 홈 페이지 레이아웃 등 UI 도메인 Manageability Rules 4속성, Editable Properties 3카테고리, 패키징 시 고려사항을 컴포넌트별로 정리.

---

## Manageability Rules — 읽는 방법

각 컴포넌트마다 아래 4속성이 정의된다.

| 속성 | 의미 |
|---|---|
| **Component Is Updated During Package Upgrade** | 패키지 신버전 설치 시 해당 컴포넌트가 구독자 org에서 자동 업데이트되는가 |
| **Subscriber Can Delete Component From Org** | 구독자가 자기 org에서 이 컴포넌트를 삭제할 수 있는가 |
| **Package Developer Can Remove Component From Package** | 개발자가 신버전 패키지에서 이 컴포넌트를 제거할 수 있는가 |
| **Component Has IP Protection** | 컴포넌트의 메타데이터·코드가 구독자 org에서 숨겨지는가 |

Editable Properties After Package Promotion or Installation은 3카테고리로 구분된다.
- **Only Package Developer Can Edit** — 개발자만 신버전에서 수정 가능, 구독자 org에서 잠김
- **Both Package Developer and Subscriber Can Edit** — 양측 모두 수정 가능 (업그레이드 시 개발자 변경은 신규 설치에만 적용, 구독자 수정 보존)
- **Neither Package Developer or Subscriber Can Edit** — promote/release 후 잠금

> 컴포넌트 제거(Remove)는 Salesforce 승인이 필요하다. 제거 기능 접근을 요청하려면 Salesforce Partner Community에 지원 케이스를 등록한다.

---

## Action Link Group Template

> Represents the action link group template. Action link templates let you reuse action link definitions and package and distribute action links.

**Metadata Name:** `ActionLinkGroupTemplate`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Salesforce Help: Action Link Templates

---

## Actionable List Definition

> Represents the data source definition details associated with an actionable list.

**Metadata Name:** `ActionableListDefinition`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All attributes |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Salesforce Help: Actionable Segmentation

---

## Branding Set

> Represents the definition of a set of branding properties for an Experience Builder site, as defined in the Theme panel in Experience Builder.

**Metadata Name:** `BrandingSet`
**Packageable In:** 2GP only

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
| Only Package Developer Can Edit | brandingSetProperty, description, masterLabel, type |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- BrandingSet은 패키지에 직접 추가할 수 없다. BrandingSet은 `CommunityThemeDefinition`, `LightningExperienceTheme`, `EmbeddedServiceMenuSettings` 같은 다른 오브젝트가 패키지에 참조될 때 자동으로 포함된다.

### Documentation

- Salesforce Help: Use Branding Sets in Experience Builder

---

## Community Template Definition

> Represents the definition of an Experience Builder site template.

**Metadata Name:** `CommunityTemplateDefinition`
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
| Only Package Developer Can Edit | All |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- `CommunityTemplateDefinition`을 패키지에 추가하면 `CommunityThemeDefinition`도 반드시 함께 패키지에 추가해야 한다.

### Documentation

- Salesforce Help: Export a Customized Experience Builder Template for a Lightning Bolt Solution
- Salesforce Help: Package and Distribute a Lightning Bolt Solution

---

## Community Theme Definition

> Represents the definition of a theme for an Experience Builder site.

**Metadata Name:** `CommunityThemeDefinition`
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
| Only Package Developer Can Edit | All |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- `CommunityThemeDefinition`은 반드시 `BrandingSet`을 포함해야 한다.
- `CommunityThemeDefinition`은 `CommunityTemplateDefinition` 없이 패키지에 추가할 수 있지만, `CommunityTemplateDefinition`은 반드시 `CommunityThemeDefinition`을 포함해야 한다.

### Documentation

- Salesforce Help: Export a Customized Experience Builder Theme for a Lightning Bolt Solution
- Salesforce Help: Package and Distribute a Lightning Bolt Solution

---

## Compact Layout

> Represents the metadata associated with a compact layout.

**Metadata Name:** `CompactLayout`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 2GP only |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Metadata API Developer Guide: CompactLayout

---

## Custom Application

> Represents a custom application.

**Metadata Name:** `CustomApplication`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 2GP only |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 (Salesforce Classic) | 속성 (Lightning Experience) |
|---|---|---|
| Only Package Developer Can Edit | Show in Lightning Experience | Selected Items, Utility Bar |
| Both Package Developer and Subscriber Can Edit | All attributes except App Name and Show in LE | All attributes except Developer Name, Selected Items, Utility Bar |
| Neither Package Developer or Subscriber Can Edit | App Name | Developer Name |

### Documentation

- Metadata API Developer Guide: CustomApplication

```xml
<!-- 구조 예시 — package.xml에서 CustomApplication 지정 -->
<!-- 실제 동작 코드 아님 -->
<types>
  <members>MyApp</members>
  <name>CustomApplication</name>
</types>
```

---

## Custom Button or Link (CustomPageWebLink)

> Represents a custom link defined in a home page component.

**Metadata Name:** `WebLink`, `CustomPageWebLink`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Behavior, Button or Link URL, Content Source, Description, Display Checkboxes, Label, Link Encoding |
| Both Package Developer and Subscriber Can Edit | Height, Resizeable, Show Address Bar, Show Menu Bar, Show Scrollbars, Show Status Bar, Show Toolbars, Width, Window Position |
| Neither Package Developer or Subscriber Can Edit | Display Type, Name |

### Documentation

- Salesforce Help: Custom Buttons and Links

---

## Custom Tab

> Represents a custom tab. Custom tabs let you display custom object data or other web content in Salesforce.

**Metadata Name:** `CustomTab`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Encoding, Has Sidebar, Height, Label, S-control, Splash Page Custom Link, Type, URL, Width |
| Both Package Developer and Subscriber Can Edit | Tab Style |
| Neither Package Developer or Subscriber Can Edit | Tab Name |

### Considerations When Packaging

- 커스텀 탭 스타일은 앱 내에서 고유해야 하지만, 설치 org의 전체 org에서 고유할 필요는 없다. 커스텀 탭 스타일은 설치 환경의 기존 커스텀 탭과 충돌하지 않는다.
- 다른 언어로 커스텀 탭 이름을 제공하려면 Setup에서 Rename Tabs and Labels를 사용한다.

### Documentation

- Metadata API Developer Guide: CustomTab

---

## Digital Experience Bundle

> Represents a text-based code structure of your organization's workspaces, organized by workspace type, and each workspace's content items.

**Metadata Name:** `DigitalExperienceBundle`
**Packageable In:** 2GP only

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
| Only Package Developer Can Edit | Labels, Description, Content |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- Enhanced LWR 사이트는 지원되지 않는다.
- 마케팅 워크스페이스에서는 기본 데이터 그래프, 퍼스널라이제이션 추천자, 포인트, 결정은 번들에 포함되지 않는다. 이에 의존하는 이메일 병합 필드나 반복기는 대상 org에서 깨질 수 있다.

### Post Install Steps

패키지 설치 후 워크스페이스 콘텐츠를 publish해야 고객에게 제공된다.

### Documentation

- Salesforce Help: Salesforce CMS
- Metadata API Developer Guide: DigitalExperienceBundle

---

## Home Page Component

> Represents the metadata associated with a home page component. You can customize the Home tab in Salesforce Classic to include components such as sidebar links, a company logo, a dashboard snapshot, or custom components that you create.

**Metadata Name:** `HomePageComponent`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Body, Component Position |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name, Type |

### Considerations When Packaging

- 커스텀 홈 페이지 레이아웃을 패키지에 포함할 때 해당 레이아웃에 포함된 모든 커스텀 홈 페이지 컴포넌트가 자동으로 추가된다.
- Messages & Alerts 같은 표준 컴포넌트는 패키지에 포함되지 않으며 설치자의 Messages & Alerts를 덮어쓰지 않는다.

### Documentation

- Metadata API Developer Guide: HomePageComponent

---

## Home Page Layout

> Represents the metadata associated with a home page layout. You can customize home page layouts and assign the layouts to users based on their user profile.

**Metadata Name:** `HomePageLayout`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP only |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Layout Name |
| Neither Package Developer or Subscriber Can Edit | Layout Name |

### Considerations When Packaging

- 설치 후 커스텀 홈 페이지 레이아웃은 구독자의 모든 홈 페이지 레이아웃과 함께 나열된다. 앱 이름을 레이아웃 이름에 포함해 구분한다.

### Documentation

- Metadata API Developer Guide: HomePageLayout

---

## Lightning Bolt

> Represents the definition of a Lightning Bolt Solution, which can include custom apps, flow categories, and Experience Builder templates.

**Metadata Name:** `LightningBolt`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP only |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

Editable Properties 정보는 PDF에 명시되지 않았다.

### Documentation

- Metadata API Developer Guide: LightningBolt

---

## Lightning Message Channel

> Represents the metadata associated with a Lightning Message Channel. A Lightning Message Channel represents a secure channel to communicate across UI technologies, such as Lightning Web Components, Aura Components, and Visualforce.

**Metadata Name:** `LightningMessageChannel`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes** |

### Editable Properties After Package Promotion or Installation

Editable Properties 정보는 PDF에 명시되지 않았다.

### Considerations When Packaging

- AppExchange Security Review를 통과하려면 `isExposed` 속성을 `false`로 설정해야 한다.

### Documentation

- Metadata API Developer Guide: Lightning Message Channel
- Lightning Web Components Developer Guide: Create a Message Channel

```javascript
// 구조 예시 — 관리형 패키지 LMC 구독 패턴 (실제 동작 코드 아님)
import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import MY_CHANNEL from '@salesforce/messageChannel/ns__MyChannel__c';

export default class MySubscriber extends LightningElement {
    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            MY_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }
}
```

---

## Lightning Page (FlexiPage)

> Represents the metadata associated with a Lightning page. A Lightning page represents a customizable screen made up of regions containing Lightning components.

**Metadata Name:** `FlexiPage`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**. 2GP only |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Lightning page |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- 프롬프트 템플릿을 참조하는 Lightning 페이지를 패키지에 성공적으로 포함하려면 **Manage Prompt Templates** 권한이 필요하다. 이 권한 없이도 패키지 생성은 성공하지만 프롬프트 템플릿이 패키지에 포함되지 않는다.

### Documentation

- Metadata API Developer Guide: Flexipage

---

## Lightning Type (LightningTypeBundle)

> Represents a custom Lightning type. Use this type to override the default user interface to create a customized appearance based on your business requirements. Deploy this bundle to your organization to implement the overrides.

**Metadata Name:** `LightningTypeBundle`
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
| Only Package Developer Can Edit | Description |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Metadata API Developer Guide: LightningTypeBundle

---

## Managed Content Type

> Represents the definition of custom content types for use with Salesforce CMS. Custom content types are displayed as forms with defined fields.

**Metadata Name:** `ManagedContentType`
**Packageable In:** 2GP only

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
| Only Package Developer Can Edit | Content, Description, Labels |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- 설치된 콘텐츠 타입은 Enhanced CMS 워크스페이스에서만 사용 가능하다.
- Connect REST API에서 설치된 콘텐츠 타입을 참조하려면 콘텐츠 타입의 fully qualified name을 사용해야 한다.

### Documentation

- Metadata API Developer Guide: ManagedContentType
- Connect REST API Developer Guide: Enhanced CMS Workspaces Resources

---

## Page Layout (Layout)

> Represents the metadata associated with a page layout.

**Metadata Name:** `Layout`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Page Layout Name |
| Neither Package Developer or Subscriber Can Edit | Page Layout Name |

### Considerations When Packaging

- 패키지를 업로드하는 사용자의 페이지 레이아웃이 Group·Professional Edition org에서 사용되고, Enterprise·Unlimited·Performance·Developer Edition org에서 기본 페이지 레이아웃이 된다.
- 기존 오브젝트에 페이지 레이아웃을 설치하는 경우 관련 레코드 타입과 함께 패키징하는 것이 좋다. 그렇지 않으면 설치된 페이지 레이아웃을 수동으로 프로파일에 적용해야 한다.
- 패키지 설치로 페이지 레이아웃과 레코드 타입이 모두 생성되면, 업로드 사용자의 해당 레코드 타입에 대한 페이지 레이아웃 배정이 구독자 org의 모든 프로파일에 배정된다(설치 또는 업그레이드 시 프로파일이 매핑되지 않은 경우).

### Documentation

- Metadata API Developer Guide: Layout

---

## Path Assistant

> Represents Path records.

**Metadata Name:** `PathAssistant`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes**. 1GP only |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | IsActive field |
| Neither Package Developer or Subscriber Can Edit | SobjectType, SobjectProcessField, RecordType |

### Documentation

- Metadata API Developer Guide: PathAssistant

---

## Prompts (In-App Guidance)

> Represents the metadata related to in-app guidance, which includes prompts and walkthroughs.

**Metadata Name:** `Prompt`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Considerations When Packaging

- 2GP 패키지에서는 scratch org 정의 파일에 `GuidanceHubAllowed`와 `Enablement` 피처를 포함해야 한다.

### License Requirements

Enablement Admin 퍼미션 셋 및 Enablement 퍼미션 셋 라이선스 필요.

### Documentation

- Metadata API Developer Guide: Prompt
- Salesforce Help: Guidelines for In-App Guidance in Managed Packages

---

## Quick Action

> Represents a specified create or update quick action for an object that then becomes available in the Chatter publisher.

**Metadata Name:** `QuickAction`
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
| Only Package Developer Can Edit | Field Overrides |
| Both Package Developer and Subscriber Can Edit | All attributes except Field Overrides |
| Neither Package Developer or Subscriber Can Edit | (없음) |

> 관리형 패키지 Quick Action 레이아웃은 Salesforce Setup에서만 수정 가능하다. Metadata API로는 변경할 수 없다.

### Documentation

- Salesforce Help: Quick Actions

---

## 2GP 미지원 / 1GP only 컴포넌트

아래 컴포넌트는 PDF "Components Available in Second-Generation Managed Packages" 섹션에서 1GP only 또는 2GP 지원 없음으로 확인된 것들이다.

| 컴포넌트 | Metadata Name | 2GP 지원 | 비고 |
|---|---|---|---|
| Channel Layout | `ChannelLayout` | 1GP only | Salesforce Classic + Knowledge 필요; Lightning Knowledge 불가 |
| Custom Help Menu Section | `CustomHelpMenuSection` | 1GP only | Lightning Experience 도움말 메뉴 섹션 |

---

## 전체 비교표

| 컴포넌트 | Metadata Name | Packageable In | Updated on Upgrade | Sub. Can Delete | Dev Can Remove | IP Protection |
|---|---|---|---|---|---|---|
| Action Link Group Template | `ActionLinkGroupTemplate` | 2GP, 1GP | Yes | No | Yes (both) | No |
| Actionable List Definition | `ActionableListDefinition` | 2GP, 1GP | Yes | No | Yes (both) | No |
| Branding Set | `BrandingSet` | **2GP only** | Yes | No | No | No |
| Community Template Definition | `CommunityTemplateDefinition` | 2GP, 1GP | Yes | No | No | No |
| Community Theme Definition | `CommunityThemeDefinition` | 2GP, 1GP | Yes | No | No | No |
| Compact Layout | `CompactLayout` | 2GP, 1GP | Yes | No | Yes (2GP only) | No |
| Custom Application | `CustomApplication` | 2GP, 1GP | Yes | No | Yes (2GP only) | No |
| Custom Button or Link | `WebLink/CustomPageWebLink` | 2GP, 1GP | Yes | No | Yes (both) | No |
| Custom Tab | `CustomTab` | 2GP, 1GP | Yes | No | Yes (both) | No |
| Digital Experience Bundle | `DigitalExperienceBundle` | **2GP only** | Yes | No | No | No |
| Home Page Component | `HomePageComponent` | 2GP, 1GP | **No** | No | No | No |
| Home Page Layout | `HomePageLayout` | 2GP, 1GP | **No** | Yes | Yes (1GP only) | No |
| Lightning Bolt | `LightningBolt` | 2GP, 1GP | Yes | No | Yes (1GP only) | No |
| Lightning Message Channel | `LightningMessageChannel` | 2GP, 1GP | Yes | No | **No** | **Yes** |
| Lightning Page (FlexiPage) | `FlexiPage` | 2GP, 1GP | Yes | No | Yes (2GP only) | No |
| Lightning Type | `LightningTypeBundle` | 2GP, 1GP | Yes | No | **No** | No |
| Managed Content Type | `ManagedContentType` | **2GP only** | Yes | No | No | No |
| Page Layout | `Layout` | 2GP, 1GP | **No** | Yes | Yes (both) | No |
| Path Assistant | `PathAssistant` | 2GP, 1GP | Yes | Yes | Yes (1GP only) | No |
| Prompts (In-App Guidance) | `Prompt` | 2GP, 1GP | Yes | No | **No** | No |
| Quick Action | `QuickAction` | 2GP, 1GP | Yes | No | **No** | No |

**주요 패턴:**
- `BrandingSet`, `DigitalExperienceBundle`, `ManagedContentType`은 **2GP only** — 1GP에서 사용 불가.
- `LightningMessageChannel`만 IP Protection이 Yes — 채널 메타데이터 보호.
- `HomePageComponent`, `HomePageLayout`, `Page Layout`은 Updated on Upgrade가 No — 초기 설치 이후 업그레이드로 덮어쓰지 않음.
- `CustomHelpMenuSection`, `ChannelLayout`은 1GP only — 2GP에서 패키징 불가.
- `BrandingSet`은 직접 패키지에 추가할 수 없고 `CommunityThemeDefinition` 등에 자동 포함.

---

## 관련 노트

- [[Metadata Types — UI & Layout]] — MetadataAPI 관점의 동일 컴포넌트 필드 정의 (FlexiPage, Layout, CustomApplication, ExperienceBundle 등)
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로·Manageability Rules 4속성 개요·Supported Components 전체 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — Manageability Rules 개념 설명·Package Ancestry·IP Protection 원리
- [[2GP — Components: Apex & Code]] — Apex Class·Trigger·LWC·Aura 등 코드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Automation]] — Flow·Workflow·Decision Table·Batch·Expression Set 등 자동화 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Einstein & Analytics]] — Einstein·Analytics·Agentforce·Bot·Report/Dashboard 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Integration & Platform]] — NamedCredential·FeatureParameter·ExternalDataSource·EventRelayConfig·PlatformCachePartition 등 통합·플랫폼 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Objects & Fields]] — CustomObject·CustomField·CustomLabels·GlobalValueSet·Folder·FieldSet 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Security & Access]] — ConnectedApp·CorsWhitelistOrigin·CspTrustedSite·ExternalCredential·PermissionSet 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
