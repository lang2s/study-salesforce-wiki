---
tags: [devops, 2gp, managed-package, packaging, components, other, sustainability, service-catalog, translation, letterhead, email-template, slack, commerce, healthcare, fundraising, enablement, marketing]
source: pkg2_dev.pdf — Components Available in Second-Generation Managed Packages (pp.25-313)
created: 2026-05-24
aliases: [2GP Other 컴포넌트, 2GP 기타 컴포넌트, managed package other components, 2GP 미분류 컴포넌트]
---

# 2GP — Components: Other

> 2GP managed package에서 패키징 가능한 컴포넌트 중 Apex & Code / Automation / Einstein & Analytics / Integration & Platform / Objects & Fields / Security & Access / UI & Layout 7개 도메인에 배정되지 않은 나머지 컴포넌트 전수.

---

## Manageability Rules 4속성 (공통 참조)

| 속성 | 의미 |
|---|---|
| **Component Is Updated During Package Upgrade** | Yes = 업그레이드 시 갱신. No = 초기 설치만 |
| **Subscriber Can Delete Component From Org** | Yes = 구독자가 삭제 가능 |
| **Package Developer Can Remove Component From Package** | Yes = 개발자가 미래 버전에서 제거 가능 |
| **Component Has IP Protection** | Yes = 코드/데이터가 subscriber org에서 숨겨짐 |

Editable Properties 3카테고리: Only Package Developer Can Edit / Both Subscriber and Package Developer Can Edit / Neither Subscriber or Package Developer Can Edit

자세한 정의: [[2GP Managed Package — Workflow]] → Manageability Rules

---

## 1. Sustainability / Net Zero Cloud

### Fuel Type

**설명:** 커스텀 연료 타입 (Net Zero Cloud).
**Metadata Name:** `FuelType`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth 또는 Starter license + Net Zero Cloud Manager permission set
Post Install: Net Zero Cloud 활성화, Manage Carbon Accounting 활성화

---

### Fuel Type Sustainability Unit of Measure

**설명:** 커스텀 연료 타입 ↔ UOM(단위) 매핑.
**Metadata Name:** `FuelTypeSustnUom`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth 또는 Starter license + Net Zero Cloud Manager permission set
Post Install: Net Zero Cloud 활성화, Manage Carbon Accounting 활성화

---

### Sustainability UOM

**설명:** 커스텀 연료 타입 UOM 값. 연료 소비 및 배출 결과 추적.
**Metadata Name:** `SustainabilityUom`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth 또는 Starter license + Net Zero Cloud Manager permission set

---

### Sustainability UOM Conversion

**설명:** 커스텀 연료 타입 UOM 변환 정보.
**Metadata Name:** `SustnUomConversion`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth 또는 Starter license + Net Zero Cloud Manager permission set

---

### Building Energy Intensity Record Type Configuration

**설명:** Building Energy Intensity Record 레코드 타입과 내부 enum 간 매핑. 다양한 레코드 타입에 걸쳐 계산하는 데 사용.
**Metadata Name:** `BldgEnrgyIntensityCnfg`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth/Starter + Net Zero Cloud Manager
Post Install: Net Zero Cloud / Manage Carbon Accounting / Manage Building Energy Intensity 활성화

---

### Stationary Asset Environmental Source Record Type Configuration

**설명:** Stationary Asset Environmental Source 레코드 타입과 내부 enum 간 매핑.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

License: Net Zero Cloud Growth/Starter + Net Zero Cloud Manager

---

### Vehicle Asset Emissions Source Record Type Configuration

**설명:** Vehicle Asset Emissions Source 레코드 타입과 내부 enum 간 매핑.
**Metadata Name:** `VehicleAssetEmssnSrcCnfg`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

License: Net Zero Cloud Growth/Starter + Net Zero Cloud Manager

---

## 2. Email / Letterhead / Document

### Email Template (Classic)

**설명:** 이메일 템플릿(클래식). 머지 필드를 포함한 HTML 이메일 템플릿.
**Metadata Name:** `EmailTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes (1GP only) |
| IP Protection | No |

Editable Properties:
- Both: All attributes except Email Template Name
- Neither: Email Template Name

---

### Email Template (Lightning)

**설명:** Lightning 기반 이메일 템플릿. Sales Engagement 이메일에도 사용.
**Metadata Name:** `EmailTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | No |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes (1GP only; Email Template Builder로 생성한 것은 제외) |
| IP Protection | No |

Editable Properties:
- Neither: All attributes

Considerations: Email Template Builder로 생성한 템플릿은 Spring '21 이전 첨부파일이 자동 포함되지 않음.

---

### Letterhead

**설명:** HTML 이메일 템플릿용 레터헤드. 로고, 페이지 색상, 텍스트 설정 정의.
**Metadata Name:** `Letterhead`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes (1GP only) |
| IP Protection | No |

Editable Properties:
- Both: All attributes except Letterhead Name
- Neither: Letterhead Name

---

### Document Generation Setting

**설명:** 자동 문서 생성(DocGen) 템플릿 org 설정.
**Metadata Name:** `DocumentGenerationSetting`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: Document Template Library Name / Generation Mechanism / Guest Access Named Credential / Label / Preview Type
- Neither: API Name

License: DocGen Designer (Permission Set License)

---

### Eclair GeoData

**설명:** Analytics 커스텀 맵 차트. 사용자 정의 지도를 Analytics에 업로드하여 표준 맵처럼 사용.
**Metadata Name:** `EclairGeoData`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Both: All attributes except Eclair GeoData Unique Name
- Neither: Eclair GeoData Unique Name

---

## 3. Fundraising

### Fundraising Config

**설명:** Fundraising 제품 구성 설정 컬렉션.
**Metadata Name:** `FundraisingConfig`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes (both 1GP and 2GP) |
| IP Protection | No |

Editable Properties:
- Only Package Developer: LapsedUnpaidTrxnCount / HouseholdSoftCreditRole / IsHshldSoftCrAutoCrea / InstallmentExtDayCount / DonorMatchingMethod / FailedTransactionCount / ShouldCreateRcrSchdTrxn / ShouldClosePaidRcrCmt
- Both: None
- Neither: None

License: Fundraising Access (Permission Set License)

---

## 4. Service Catalog

### Service Catalog Category

**설명:** Service Catalog에서 개별 카탈로그 항목을 그룹화하는 범주.
**Metadata Name:** `SvcCatalogCategory`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: ParentCategory
- Both: SortOrder / IsActive / Image
- Neither: FullName

License: Service Catalog Add-On License + Service Catalog Builder Permission Set
Post Install: 카테고리는 활성화된 항목이 있을 때만 UI에 표시

---

### Service Catalog Filter Criteria

**설명:** Service Catalog 사용자가 카탈로그 항목에 접근할 수 있는지 결정하는 자격 규칙.
**Metadata Name:** `SvcCatalogFilterCriteria`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: All fields
- Neither: FullName

License: Service Catalog Add-On License + Service Catalog Builder Permission Set

---

### Service Catalog Item Definition

**설명:** Service Catalog에서 제공하는 특정 서비스와 연관된 엔티티.
**Metadata Name:** `SvcCatalogItemDef`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: Flow
- Both: Status / Description / InternalNotes / Image / IsFeatured / IsPublic
- Neither: FullName

License: Service Catalog Add-On License + Service Catalog Builder Permission Set
Considerations: 구독자는 카탈로그 항목의 fulfillment flow 속성 변경 불가 — 클론해서 편집해야 함. 최대 1000개 SvcCatalogItemDef.
Post Install: draft 상태로 설치된 항목은 활성화 후 UI에 표시

---

### Service Catalog Fulfillment Flow

**설명:** Service Catalog의 특정 카탈로그 항목과 연결된 Flow.
**Metadata Name:** `SvcCatalogFulfillmentFlow`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

License: Service Catalog Add-On License + Service Catalog Builder Permission Set

---

## 5. Service & Operations

### ServiceProcess

**설명:** Service Process Studio에서 생성된 프로세스와 관련 속성.
**Metadata Name:** `ServiceProcess`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All other fields
- Both: Status / Description / ServiceProcessAttribute / ServiceProcessDependency / ServiceProcessItemGroup
- Neither: FullName

---

### Record Action Deployment

**설명:** Actions & Recommendations, Action Launcher, Bulk Action Panel 컴포넌트에 대한 구성 설정.
**Metadata Name:** `RecordActionDeployment`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Both: Channel Configurations / Deployment Contexts / HasGuidedActions / HasRecommendations / Label / Recommendations / SelectableItems / ShouldLaunchActionOnReject
- Neither: Name

Considerations: Flow, Quick Action, Object, NBA Recommendation을 사용하는 경우 함께 패키징 필요

---

### Timeline Object Definition

**설명:** 타임라인 구성 상세 정보 컨테이너. Salesforce Object의 레코드를 시간 순 정렬 뷰로 표시.
**Metadata Name:** `TimelineObjectDefinition`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes (1GP only) |
| IP Protection | No |

Editable Properties:
- Both: Label / FullName / Definition / IsActive
- Neither: BaseObject

License: Industries Health Cloud 또는 Timeline Permission 활성화된 라이선스

---

### UI Object Relation Config

**설명:** 어드민이 생성한 Object Relation UI 컴포넌트 구성.
**Metadata Name:** `UIObjectRelationConfig`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Only Package Developer: Reference Name / Developer Name / IsActive
- Both: IsActive
- Neither: ContextObject

License: Industries Health Cloud / Industries Insurance / Industries Automotive

---

## 6. Translation

### Translation

**설명:** managed package에 번역 추가. Language Extension Package(Beta)를 통해 다른 패키지의 번역도 포함 가능.
**Metadata Name:** `Translation`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

Considerations (Beta):
- Language Extension Package — Dev Hub에서 Enable Language Extension Packages 활성화
- 번역만 포함 가능 (Translation + CustomObjectTranslation)
- 번역을 제거하려면 base package와 모든 extension을 언인스톨 후 재인스톨

---

## 7. Commerce & Pricing

### Pricing Action Parameters

**설명:** context definition 및 pricing procedure와 연결된 pricing action.
**Metadata Name:** `PricingActionParameters`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: Pricing Action Parameters Name
- Neither: None

License: Salesforce Pricing permissions
Relationship: 패키징 시 Pricing이 의존하는 모든 컴포넌트가 함께 패키징됨

---

### Pricing Recipe

**설명:** pricing data store가 사용할 특정 cloud의 다양한 데이터 모델 중 하나.
**Metadata Name:** `PricingRecipe`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Both: Recipe Name
- Neither: None

Considerations: 연결된 context는 내보내지 않음. Decision Table의 경우 컬럼 추가분은 내보낼 때 갱신되지 않음.

---

### Procedure Output Resolution

**설명:** strategy name과 formula로 결정된 pricing element의 pricing resolution.
**Metadata Name:** `ProcedureOutputResolution` (추정)

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Product Attribute Set

**설명:** 제품 속성 세트 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Product Specification Type

**설명:** 특정 application domain 내에서 애플리케이션 서브타입 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Product Specification Record Type

**설명:** 제품 사양 레코드 타입 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Web Store Template

**설명:** 커머스 스토어 생성을 위한 구성 템플릿.
**Metadata Name:** `WebStoreTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

## 8. Slack 통합

### Slack App (Beta)

**설명:** Slack 앱 구성.
**Metadata Name:** `SlackApp`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | Yes |

Editable Properties:
- Only Package Developer: AppKey / AppToken / ClientKey / ClientSecret / SigningSecret / BotScopes / UserScopes / Config / IntegrationUser / DefaultUser
- Both: None
- Neither: None

License: Connect to Slack Permission
Relationship: Slack App은 Apex class 핸들러와 View Definition 컴포넌트를 참조

---

### View Definition (Beta)

**설명:** Slack 앱 내 뷰 정의.
**Metadata Name:** `ViewDefinition`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Only Package Developer: TargetType / Content / Description
- Both: None
- Neither: None

License: Connect to Slack Permission

---

## 9. Healthcare / Life Sciences

### Virtual Visit Config

**설명:** 외부 비디오 제공자 구성. Salesforce에서 공급자로 이벤트를 전달.
**Metadata Name:** `VirtualVisitConfig`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: ComprehendServiceType / ExperienceCloudSiteUrl / ExternalRoleIdentifier / Label / MessagingRegion / NamedCredential / StorageBucketName / UsageType / VideoCallApptTypeValue / VideoControlRegion / VisitRegion
- Neither: Name

---

### Life Science Config Category

**설명:** Life Sciences 구성 레코드가 분류되는 카테고리.
**Metadata Name:** `LifeSciConfigCategory`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Only Package Developer: CategoryLabel / DeveloperName / MasterLabel
- Neither: CategoryType

License: Industries Life Sciences Cloud + Life Sciences Cloud for Customer Engagement Add-on + Life Sciences Customer Engagement managed package
Considerations: DeveloperName은 Category와 일치해야 함

---

### Life Science Config Record

**설명:** Life Sciences 구성 레코드. Life Science Config Category의 자식.
**Metadata Name:** `LifeSciConfigRecord`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

License: Industries Life Sciences Cloud + Life Sciences Cloud for Customer Engagement Add-on

---

## 10. Enablement & Learning

### Enablement Measure Definition

**설명:** Enablement 프로그램의 측정 지표 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

License: Enablement add-on license + Enablement permission set license
Considerations: Enablement Program Definition과 함께 패키징하거나 별도 패키징 가능

---

### Enablement Program Definition

**설명:** Enablement 프로그램 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

License: Enablement add-on license + Enablement permission set license (Partner Enablement도 동일)
Relationship: Enablement Measure Definition / Enablement Program Task Subcategory와 함께 패키징

---

### Enablement Program Task Subcategory

**설명:** Enablement 프로그램에서 사용하는 커스텀 exercise 타입 서브카테고리.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

License: Enablement add-on license + Enablement permission set license
Considerations: Partner Enablement 프로그램에서 커스텀 exercise 미지원

---

### LearningAchievementConfig

**설명:** Enablement 프로그램의 Learning Achievement 구성.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

## 11. Marketing & Data Cloud

### Activation Platform

**설명:** Activation Platform 구성(플랫폼명, 전달 스케줄, 출력 형식, 대상 폴더 등). ISV가 Activation Platform 통합 기능을 정의하고 AppExchange에 게시.
**Metadata Name:** `ActivationPlatform`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Only Package Developer: DataConnector / Description / LogoUrl / MasterLabel / OutputFormat / RefreshMode / Type
- Both: Enabled (구독자만 편집) / IncludeSegmentNames (구독자만 편집)
- Neither: ID / OutputGrouping / PeriodicRefreshFrequency / RefreshFrequency

License: Data Cloud enabled orgs
Post Install: 어드민이 activation platform 활성화 필요
Considerations: 새 required field 추가 / 이전에 지원된 ID 타입 제거 등은 업그레이드 미지원. 업그레이드 후 Activation Target을 재편집·저장해야 새 버전 적용.

---

### Market Segment Definition

**설명:** 마케팅 목적의 시장 세그먼트 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### MktCalculatedInsightsObjectDef

**설명:** 마케팅 인사이트 계산 오브젝트 정의.
**Metadata Name:** `MktCalculatedInsightsObjectDef`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### MktDataConnection

**설명:** 마케팅 데이터 커넥션 정의.
**Metadata Name:** `MktDataConnection`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### MktDataTranObject

**설명:** 마케팅 데이터 전환 오브젝트 정의.
**Metadata Name:** `MktDataTranObject`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Marketing App Extension

**설명:** 마케팅 앱 확장 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Marketing App Extension Activity

**설명:** 마케팅 앱 확장 활동 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

## 12. Data Kit / Data Cloud

### DataCalcInsightTemplate

**설명:** 계산된 인사이트 템플릿.
**Metadata Name:** `DataCalcInsightTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Kit Object Dependency

**설명:** Data Kit 오브젝트 의존성 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Kit Object Template

**설명:** Data Kit 오브젝트 템플릿.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### DataObjectBuildOrgTemplate

**설명:** 오브젝트 빌드 org 템플릿.
**Metadata Name:** `DataObjectBuildOrgTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Package Kit Definition

**설명:** Data Cloud 패키지 키트 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Package Kit Object

**설명:** Data Package Kit 오브젝트 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Source Bundle Definition

**설명:** Data Source 번들 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Stream Definition

**설명:** Data Stream 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Data Stream Template

**설명:** Data Stream 템플릿.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

## 13. Financial / Insurance / Commerce 공통

### Transaction Processing Type

**설명:** 거래 처리 요청의 처리 제약 설정.
**Metadata Name:** `TransactionProcessingType`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: All attributes
- Neither: None

Consideration on Uninstall: 패키지와 연결된 TransactionProcessingType 레코드는 언인스톨 시 삭제됨. 연관 sales transaction(quote/order)이 있는 경우 같은 DeveloperName으로 재생성 필요.

---

### Contract Type

**설명:** 계약 타입 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Conversation Channel Definition

**설명:** 대화 채널 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### CommunicationChannelType

**설명:** 커뮤니케이션 채널 타입 정의.
**Metadata Name:** `CommunicationChannelType`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

---

## 15. Account Plan & Sales

### Account Plan Objective Measure Calculation Definition

**설명:** 판매 계정 플랜 목표 측정의 현재 값 계산을 위한 대상 오브젝트, 롤업 필드, 로직 정의.
**Metadata Name:** `AccountPlanObjMeasCalcDef`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: Description / DeveloperName / MasterLabel / RollupType / Status / TargetField / TargetObject
- Neither: None

---

## 14. 기타 미분류 컴포넌트

### Action Plan Template

**설명:** Action Plan 템플릿 인스턴스.
**Metadata Name:** `ActionPlanTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

Editable Properties:
- Only Package Developer: All attributes
- Both: None
- Neither: None

---

### Actionable List Key Performance Indicator Definition

**설명:** 오브젝트의 특정 필드에 정의된 커스텀 KPI.
**Metadata Name:** `ActnblListKeyPrfmIndDef`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes (both) |
| IP Protection | No |

Editable Properties:
- Both: All attributes
- Neither: None

License: Actionable Segmentation

---

### Application Subtype Definition

**설명:** 애플리케이션 도메인 내 애플리케이션 서브타입 정의.
**Metadata Name:** `ApplicationSubtypeDefinition`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes |
| IP Protection | Not specified |

Editable Properties:
- Both: Label / Developer Name / Description / Application Usage Type
- Neither: None

License: Tableau Included App Manager permission set

---

### Benefit Action

**설명:** 혜택(benefit)에 대해 트리거될 수 있는 액션 상세.
**Metadata Name:** `BenefitAction`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | Yes (except templates) |

Editable Properties:
- Only Package Developer: Entire Benefit Action record
- Both: Label / Description / Status
- Neither: API Name / URL

License: Loyalty Management permission set license
Use Case: Loyalty Program benefit에 트리거 가능한 액션

---

### Business Process

**설명:** 프로파일 기반으로 다른 피클리스트 값을 표시하는 메타데이터 타입. Record Type과 연결.
**Metadata Name:** `BusinessProcess`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: All attributes
- Neither: None

Relationship: 해당 엔티티의 Record Type과 연결

---

### Business Process Type Definition

**설명:** 규칙에 적용되는 비즈니스 프로세스 타입 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | No |
| Subscriber Can Delete | Yes |
| Developer Can Remove | Yes |
| IP Protection | Not specified |

Editable Properties:
- Both: Label / Developer Name
- Neither: None

---

### Conditional Formatting Ruleset

**설명:** 조건부 서식 규칙 세트.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Disclosure Definition

**설명:** 정보 공개 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Disclosure Definition Version

**설명:** 정보 공개 정의의 버전.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### Disclosure Type

**설명:** 정보 공개 타입 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

---

### ESignature Config

**설명:** 전자 서명 구성.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### ESignature Envelope Config

**설명:** 전자 서명 봉투 구성.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Embedded Service Menu Settings

**설명:** Embedded Service 메뉴 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Entitlement Template

**설명:** 자격(Entitlement) 템플릿 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Explainability Action Definition

**설명:** 설명 가능성 액션 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Explainability Action Version

**설명:** 설명 가능성 액션 버전.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Explainability Message Template

**설명:** 설명 가능성 메시지 템플릿.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### External Client App Canvas Settings

**설명:** 외부 클라이언트 앱 Canvas 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### External Client App Header

**설명:** 외부 클라이언트 앱 헤더 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### External Client App Notification Settings

**설명:** 외부 클라이언트 앱 알림 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### External Client App OAuth Settings

**설명:** 외부 클라이언트 앱 OAuth 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### External Client App Push Settings

**설명:** 외부 클라이언트 앱 Push 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### OcrSampleDocument

**설명:** OCR 샘플 문서.
**Metadata Name:** `OcrSampleDocument`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### OcrTemplate

**설명:** OCR 템플릿.
**Metadata Name:** `OcrTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Outbound Network Connection

**설명:** 아웃바운드 네트워크 연결 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Payment Gateway Provider

**설명:** 결제 게이트웨이 제공자 설정.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Process (Process Builder)

**설명:** Process Builder 프로세스. 신규 패키징에서는 Flow 사용 권장.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Process Flow Migration

**설명:** Process Builder → Flow 마이그레이션 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Object Source Target Map

**설명:** 오브젝트 소스-타겟 매핑 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Object Integration Provider Definition Mapping

**설명:** 오브젝트-통합 제공자 정의 매핑.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Record Alert Data Source Expression Set Definition

**설명:** 레코드 알림 데이터 소스와 Expression Set Definition 간의 연결 정보.
**Metadata Name:** `RecAlrtDataSrcExpSetDef`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | No |
| IP Protection | No |

Editable Properties:
- Both: ExpressionSetDefinition / ExpressionSetObject / IsActive / RecordAlertDataSource
- Neither: FullName / Metadata

---

### Referenced Dashboard

**설명:** 참조 대시보드 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Registered External Service

**설명:** 등록된 외부 서비스 정의.

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes |
| IP Protection | No |

---

### Timesheet Template

**설명:** Field Service의 타임시트 생성 템플릿.
**Metadata Name:** `TimesheetTemplate`

| 속성 | 값 |
|---|---|
| Packageable In | 1GP only |
| Updated During Upgrade | Yes |
| Subscriber Can Delete | No |
| Developer Can Remove | Yes (1GP only) |
| IP Protection | No |

---

## 코드 예제

### package.xml — Other 도메인 컴포넌트 배포 예시

```xml
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- package.xml — Other 도메인 주요 컴포넌트 패키징 예시 -->
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <!-- Net Zero Cloud -->
    <types>
        <members>*</members>
        <name>FuelType</name>
    </types>
    <types>
        <members>*</members>
        <name>FuelTypeSustnUom</name>
    </types>
    <types>
        <members>*</members>
        <name>SustainabilityUom</name>
    </types>
    <types>
        <members>*</members>
        <name>SustnUomConversion</name>
    </types>
    <!-- Service Catalog -->
    <types>
        <members>*</members>
        <name>SvcCatalogCategory</name>
    </types>
    <types>
        <members>*</members>
        <name>SvcCatalogItemDef</name>
    </types>
    <!-- Translation -->
    <types>
        <members>ko</members>
        <name>Translation</name>
    </types>
    <!-- Email Template (Classic) -->
    <types>
        <members>MyFolder/MyTemplate</members>
        <name>EmailTemplate</name>
    </types>
    <!-- Web Store Template -->
    <types>
        <members>*</members>
        <name>WebStoreTemplate</name>
    </types>
    <version>64.0</version>
</Package>
```

### Translation — 언어 확장 패키지 (Beta) 생성 예시

```bash
# 구조 예시 — 실제 동작 코드 아님
# 언어 확장 패키지 생성 (Dev Hub에서 Enable Language Extension Packages 필요)
sf package create \
  --name "MyApp Korean Translation" \
  --package-type Unlocked \
  --path translations \
  --target-dev-hub MyDevHub

# 번역 파일만 포함 가능: Translation + CustomObjectTranslation
```

---

## 2GP Components 시리즈 전체 목차

- [[2GP — Components: Apex & Code]] — Apex Class, Trigger, LWC, Aura 등
- [[2GP — Components: Automation]] — Flow, Workflow, Approval Process 등
- [[2GP — Components: Einstein & Analytics]] — AI Application, Dashboard, Bot 등
- [[2GP — Components: Integration & Platform]] — Named Credential, External Service, Feature Parameter 등
- [[2GP — Components: Objects & Fields]] — Custom Object, Custom Field, Global Value Set 등
- [[2GP — Components: Security & Access]] — Permission Set, Connected App, External Credential 등
- [[2GP — Components: UI & Layout]] — FlexiPage, Lightning Message Channel, Custom App 등
- [[2GP — Components: Other]] — 이 파일

---

## 관련 노트

- [[Metadata Types — Other]] — Metadata API 관점의 기타 타입 (FuelType, Scontrol 등)
- [[2GP — Components: Apex & Code]] — Apex Class, Trigger, LWC, Aura 컴포넌트 규칙
- [[2GP — Components: Automation]] — Flow, Workflow, Decision Table 등 자동화 도메인
- [[2GP — Components: Einstein & Analytics]] — AI, Analytics, Agentforce 도메인
- [[2GP — Components: Integration & Platform]] — Named Credential, External Service 등
- [[2GP — Components: Objects & Fields]] — Custom Object, Custom Field 등 데이터 도메인
- [[2GP — Components: Security & Access]] — Permission Set, Connected App 등 보안 도메인
- [[2GP — Components: UI & Layout]] — FlexiPage, Layout, Quick Action 등 UI 도메인
- [[2GP Managed Package — Workflow]] — Manageability Rules 전체 정의 및 2GP 워크플로
