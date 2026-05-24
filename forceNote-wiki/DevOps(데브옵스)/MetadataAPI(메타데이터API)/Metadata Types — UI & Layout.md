---
tags: [devops, metadata-api, metadata-types, layout, flexi-page, custom-tab, custom-application, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [Layout 메타데이터, FlexiPage 메타데이터, CustomApplication 메타데이터, CustomTab 메타데이터, UI 레이아웃 메타데이터 타입]
---

# Metadata Types — UI & Layout

> 레이아웃, Lightning 페이지(FlexiPage), 커스텀 탭, 애플리케이션, Experience Builder 사이트, 네비게이션 등 UI/레이아웃 관련 메타데이터 타입.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| ActionLinkGroupTemplate | 액션 링크 그룹 템플릿 (피드 버튼) |
| ActionableListDefinition | 실행 가능한 목록 데이터 소스 정의 |
| AnimationRule | Path 사용자 애니메이션 기준 |
| AppMenu | 앱 메뉴 (Reserved for future use) |
| Audience | Experience Builder 사이트 대상자 |
| AuraDefinitionBundle | Aura 컴포넌트 번들 (코드 그룹에 포함) |
| BrandingSet | Experience Builder 브랜딩 속성 세트 |
| ChoiceList | 프리챗 드롭다운 필드 |
| Community (Zone) | Ideas/Chatter Answers 존 |
| CommunityTemplateDefinition | Experience Builder 사이트 템플릿 정의 |
| CommunityThemeDefinition | Experience Builder 사이트 테마 정의 |
| ContentTypeBundle | Enhanced CMS 커스텀 콘텐츠 타입 정의 |
| CustomApplication | 커스텀/표준 앱 |
| CustomApplicationComponent | 콘솔 커스텀 컴포넌트 (VF 페이지) |
| CustomFeedFilter | 커스텀 피드 필터 |
| CustomHelpMenuSection | Lightning Experience 도움말 메뉴 섹션 |
| CustomPageWebLink | 홈 페이지 컴포넌트 커스텀 링크 |
| CustomSite | Salesforce Sites (공개 웹사이트) |
| CustomTab | 커스텀 탭 |
| DigitalExperienceBundle | 조직 작업공간 코드 구조 |
| DigitalExperienceConfig | 조직 작업공간 세부 정보 |
| EmbeddedServiceBranding | Embedded Service 배포 브랜딩 |
| ExperienceBundle | Experience Builder 사이트 코드 구조 |
| ExperiencePropertyTypeBundle | 속성 타입 (Spring '26에서 LightningPropertyType으로 대체) |
| FlexiPage | Lightning 페이지 |
| HomePageComponent | 홈 페이지 컴포넌트 |
| HomePageLayout | 홈 페이지 레이아웃 |
| KeywordList | Experience Cloud 키워드 목록 (모더레이션) |
| Layout | 페이지 레이아웃 |
| LightningBolt | Lightning Bolt Solution 정의 |
| LightningExperienceTheme | 커스텀 Lightning Experience 테마 |
| LightningOnboardingConfig | Salesforce Classic 전환 시 피드백 설정 |
| LightningTypeBundle | 커스텀 Lightning 타입 번들 |
| ManagedContentType | Salesforce CMS 커스텀 콘텐츠 타입 |
| ManagedTopics | Experience Cloud 사이트 네비게이션·추천 주제 |
| NavigationMenu | Experience Builder 사이트 네비게이션 메뉴 |
| Network | Experience Cloud 사이트 |
| NetworkBranding | Experience Cloud 사이트 로그인 페이지 브랜딩 |
| PathAssistant | Path 레코드 |
| Portal | 파트너 포털 |
| Prompt | 인앱 가이던스 (프롬프트·워크스루) |
| QuickAction | Quick Action |
| RecordActionDeployment | Actions & Recommendations 설정 |
| SearchCustomization | Search Manager 검색 설정 |
| SearchOrgWideObjectConfig | 검색 인덱스 오브젝트 |
| SiteDotCom | Sites 배포 |
| SvcCatalogCategory | Service Catalog 카테고리 |
| SynonymDictionary | 검색 동의어 사전 |
| UIBundle | Multi-Framework 앱 (React 등) (Beta) |
| UiFormatSpecificationSet | Dynamic Forms 조건부 필드 서식 |
| UIObjectRelationConfig | 오브젝트 관계 UI 컴포넌트 설정 |
| UiPreviewMessageTabDef | Marketing Cloud Preview 커스텀 탭 등록 |

---

## FlexiPage

Lightning 페이지 메타데이터. 레코드 페이지, 홈 페이지, 앱 페이지 등.

**파일 경로:** `flexipages/PageName.flexipage`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `description` | string | - | 페이지 설명 |
| `flexiPageRegions` | FlexiPageRegion[] | - | 페이지 리전 (컴포넌트 배치 영역) |
| `fullName` | string | - | 페이지 API 이름 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `parentFlexiPage` | string | - | 부모 FlexiPage (v41.0+) |
| `platformActionlist` | PlatformActionList | - | 플랫폼 액션 목록 |
| `quickActionList` | QuickActionList | - | Quick Action 목록 |
| `sobjectType` | string | - | 연관된 sObject 타입 (레코드 페이지의 경우) |
| `template` | FlexiPageTemplateInstance | Required | 페이지 레이아웃 템플릿 |
| `type` | FlexiPageType (enum) | Required | `RecordPage` / `AppPage` / `HomePage` / `RecordHome` 등 |

### FlexiPageRegion 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `appendable` | Boolean (enum) | - | 추가 가능 여부 |
| `componentInstances` | ComponentInstance[] | - | 컴포넌트 인스턴스 목록 |
| `mode` | FlexiPageRegionMode (enum) | - | `append` / `prepend` / `replace` |
| `name` | string | Required | 리전 이름 |
| `prependable` | Boolean (enum) | - | 앞에 추가 가능 여부 |
| `replaceable` | Boolean (enum) | - | 교체 가능 여부 |
| `type` | FlexiPageRegionType (enum) | Required | `Region` / `Facet` / `Background` |

### Declarative Metadata 예시

```xml
<!-- package.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <fullName>New Opportunity Page</fullName>
  <types>
    <members>New_Opportunity_Page</members>
    <name>FlexiPage</name>
  </types>
  <version>49.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예

---

## Layout

페이지 레이아웃 메타데이터.

**파일 경로:** `layouts/ObjectName-LayoutName.layout`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `customButtons` | string[] | - | 커스텀 버튼 목록 |
| `customConsoleComponents` | CustomConsoleComponents | - | 콘솔 커스텀 컴포넌트 |
| `emailDefault` | boolean | - | 이메일 기본 레이아웃 여부 |
| `excludeButtons` | string[] | - | 제외할 표준 버튼 목록 |
| `feedLayout` | FeedLayout | - | Chatter 피드 레이아웃 (v21.0+) |
| `fullName` | string | - | 레이아웃 이름 (ObjectName-LayoutName 형식) |
| `headers` | string[] | - | 헤더 목록 (v21.0 이하) |
| `layoutSections` | LayoutSection[] | - | 레이아웃 섹션 목록 |
| `miniLayout` | MiniLayout | - | 미니 레이아웃 |
| `multilineLayoutFields` | string[] | - | 멀티라인 필드 목록 |
| `platformActionList` | PlatformActionList | - | 플랫폼 액션 목록 |
| `quickActionList` | QuickActionList | - | Quick Action 목록 (v28.0+) |
| `relatedContent` | RelatedContent | - | Related Content 설정 |
| `relatedLists` | RelatedListItem[] | - | 관련 목록 |
| `relatedObjects` | string[] | - | 관련 오브젝트 목록 |
| `runAssignmentRulesDefault` | boolean | - | 기본 배정 규칙 실행 여부 |
| `showEmailCheckbox` | boolean | - | 이메일 알림 체크박스 표시 여부 |
| `showHighlightsPanel` | boolean | - | Highlights Panel 표시 여부 (v37.0+) |
| `showKnowledgeComponent` | boolean | - | Knowledge 컴포넌트 표시 여부 |
| `showRunAssignmentRulesCheckbox` | boolean | - | 배정 규칙 실행 체크박스 표시 여부 |
| `showSolutionSection` | boolean | - | Solution 섹션 표시 여부 |
| `showSubmitAndAttachButton` | boolean | - | Submit & Attach 버튼 표시 여부 |
| `summaryLayout` | SummaryLayout | - | 관련 목록 요약 레이아웃 |

---

## CustomTab

커스텀 탭. Salesforce Classic에서 탭으로, Lightning Experience에서 네비게이션 바 항목으로 표시. `Metadata` 타입을 extends.

**파일 경로:** `tabs/TabName.tab`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `auraComponent` | string | - | 탭에 표시할 Aura 컴포넌트 |
| `customObject` | boolean | - | 커스텀 오브젝트 탭 여부 |
| `description` | string | - | 탭 설명 |
| `flexiPage` | string | - | 탭에 표시할 FlexiPage |
| `frameHeight` | int | - | Web 탭의 프레임 높이 |
| `hasSidebar` | boolean | - | 사이드바 표시 여부 |
| `icon` | string | Required | 탭 아이콘 |
| `label` | string | - | 탭 레이블 |
| `lwcComponent` | string | - | 탭에 표시할 LWC (v47.0+) |
| `motif` | string | - | 아이콘 모티프 (v29.0 이하) |
| `mobileReady` | boolean | - | 모바일 지원 여부 |
| `page` | string | - | Visualforce 페이지 이름 |
| `scontrol` | string | - | S-control 이름 |
| `splashPageLink` | string | - | 스플래시 페이지 링크 |
| `url` | string | - | 탭에 표시할 URL |
| `urlEncodingKey` | Encoding (enum) | - | URL 인코딩 방식 |

---

## CustomApplication

커스텀 또는 표준 앱. 탭 참조 목록, 설명, 로고 포함. API v29.0 이하에서는 커스텀 앱만 해당. `Metadata` 타입을 extends.

**파일 경로:** `applications/AppName.app`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actionOverrides` | AppActionOverride[] | - | 앱 레벨 액션 재정의 |
| `brand` | AppBrand | - | 앱 브랜딩 속성 |
| `description` | string | - | 앱 설명 |
| `formFactors` | FormFactor[] | - | 지원 폼 팩터 목록 |
| `fullName` | string | - | 앱 API 이름 |
| `isNavAutoTempTabsDisabled` | boolean | - | 임시 탭 자동 열기 비활성화 여부 |
| `isNavPersonalizationDisabled` | boolean | - | 네비게이션 개인화 비활성화 여부 |
| `label` | string | - | 앱 레이블 |
| `logo` | string | - | 로고 이미지 이름 |
| `navType` | NavType (enum) | - | 네비게이션 타입. `Standard` / `Console` |
| `preferences` | AppPreferences | - | 앱 환경설정 |
| `profileActionOverrides` | AppProfileActionOverride[] | - | 프로파일별 액션 재정의 |
| `setupExperience` | string | - | 초기 설정 경험 페이지 |
| `tabs` | string[] | - | 탭 이름 목록 |
| `uiType` | AppUiType (enum) | - | UI 타입. `Aloha` / `Lightning` |
| `utilityBar` | AppUtilityBar | - | Utility Bar 설정 |
| `workspaceConfig` | AppWorkspaceConfig | - | Console 작업공간 구성 |

---

## Network

Experience Cloud 사이트(커뮤니티/사이트/포털). Ideas와 Chatter Answers 존은 Community(Zone) 사용.

---

## NavigationMenu

Experience Builder 사이트 네비게이션 메뉴. API v47.0+에서 NetworkLinkSet 서브타입을 대체. `Metadata` 타입을 extends.

---

## ExperienceBundle

Experience Builder 사이트의 설정·컴포넌트(페이지, 브랜딩 세트, 테마) 텍스트 기반 코드 구조. `Metadata` 타입을 extends.

---

## PathAssistant

Path 레코드. `Metadata` 타입을 extends.

---

## QuickAction

Quick Action (생성/업데이트). Chatter 게시자에서 사용 가능.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata Types — Apex & Code]] — LightningComponentBundle, AuraDefinitionBundle
- [[Metadata Types — Security & Access]] — Profile (레이아웃 배정 관련)
- [[Metadata Types — Integration & Platform]] — EmbeddedService 관련 타입
- [[Metadata Types — Objects & Fields]] — CustomObject·CustomField·RecordType (레이아웃이 배치하는 오브젝트 구조)
- [[2GP — Components: UI & Layout]] — 같은 타입의 2GP 패키징 동작 (Manageability Rules·Editable Properties)
