---
tags: [devops, salesforce-dx, unlocked-package, package-version, version-numbering, code-coverage, org-shape, branch, promote, hard-delete]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [unlocked package version, package version create, sf package version promote, hard deleted components, 패키지 버전 생성, 패키지 릴리스]
---

# Unlocked Package 개발과 버전

> Unlocked Package 버전 생성(Default/Async/Skip Validation), 버전 번호 가이드, 코드 커버리지 75%, Org Shape 활용, 브랜치 기반 버전 관리, 릴리스·업데이트·Hard-Delete·삭제·버전 조회 전수

---

## Create and Update an Unlocked Package

패키지를 공유하거나 테스트할 준비가 되면 `sf package create`로 패키지를 생성한다.

```bash
sf package create --name "Expenser App" --package-type Unlocked \
  --path "expenser-main" --target-dev-hub my-hub \
  --error-notification-username me@devhub.org
```

출력 예시:
```
sfdx-project.json has been updated.
Successfully created a package. 0HoB00000004CzHKAU
=== Ids
NAME        VALUE
──────────── ──────────────────
Package Id   0HoB00000004CzHKAU
```

### 패키지 업데이트

기존 패키지의 이름, 설명, 오류 알림 사용자를 변경한다.

```bash
sf package update --package "Expense App" \
  --name "Expense Manager App" \
  --description "New Description" \
  --error-notification-username me2@devhub.org
```

- 패키지 namespace와 package type은 생성 후 변경 불가

### Metadata Limits

| 항목 | 한도 |
|---|---|
| Number of Metadata Files | 10,000 files |
| Total Metadata File Size | 600 MB |

---

## Create New Versions of an Unlocked Package

패키지 버전은 패키지 콘텐츠와 관련 메타데이터의 고정 스냅샷이다. 버전을 생성하기 전:
1. 패키지 이름, 의존성 등 세부 사항 확인
2. `sfdx-project.json`의 `versionNumber` 파라미터 업데이트
3. 변경 또는 추가할 메타데이터가 패키지 메인 디렉토리에 있는지 확인

### 세 가지 버전 생성 옵션

| 옵션 | 설명 | 프로모션 가능 |
|---|---|---|
| Default | 의존성·조상 패키지·메타데이터 전체 검증 완료 후 반환 | ✅ |
| Async Validation | 검증 전에 설치 가능한 버전 즉시 반환, 검증은 비동기로 진행 | 검증 성공 시 ✅ |
| Skip Validation | 의존성·조상·메타데이터 검증 생략, 생성 시간 대폭 단축 | ❌ |

---

### Create an Unlocked Package Version (Default)

```bash
sf package version create \
  --package "Expenser App" \
  --installation-key "HIF83kS8kS7C" \
  --definitionfile config/project-scratch-def.json \
  --code-coverage \
  --wait 10
```

- `--wait` 시간 내 완료 시 `sfdx-project.json` 자동 업데이트
- 완료되지 않으면 프로젝트 파일을 수동으로 편집해야 함

진행 상태 확인:
```bash
sf package version create report --package-create-request-id 08cxx00000000YDAAY
```

출력 예시:
```
=== Package Version Create Request
NAME                          VALUE
──────────────────────────────────────────────
Version Create Request Id     08cB00000004CBxIAM
Status                        InProgress
Package Id                    0HoB00000004C9hKAE
Package Version Id            05iB0000000CaaNIAS
Subscriber Package Version Id 04tB0000000NOimIAG
Tag                           git commit id 08dcfsdf
Branch
CreatedDate                   2024-05-08 09:48
Installation URL              https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000NOimIAG
```

대기 중인 요청 목록 전체 조회:
```bash
sf package version create list --created-last-days 0
```

### Async Validation

CI 스크립트에서 설치 가능한 아티팩트를 빨리 얻고 이후 단계를 시작하려면 `--async-validation`을 사용한다.

```bash
sf package version create --async-validation <rest of command syntax>
```

- 모든 패키지 검증이 성공적으로 완료된 경우에만 async validated 버전을 프로모션 가능
- 완료 여부 확인: `sf package version create report --package-create-request-id 08cxx`

### Skip Validation

```bash
sf package version create --skip-validation <rest of command syntax>
```

- 의존성·조상 패키지·메타데이터 검증 없이 버전 생성
- 생성 시간 대폭 단축
- **프로모션(릴리스 상태 전환) 불가**
- `--skip-validation`과 `--code-coverage` 동시 지정 불가 (코드 커버리지는 검증 중 계산)
- `--skip-validation`과 `--async-validation` 동시 지정 불가

---

## Guidance for Package Version Numbering

패키지 버전 번호 형식: `MAJOR.MINOR.PATCH.BUILD`

모든 패키지 버전은:
- 개발자가 결정하는 버전 번호 (예: `2.2.0.1`)
- 고유 subscriber package version ID (04t로 시작) — 자동 할당

### 버전 번호 지정 방법

`sfdx-project.json`의 `versionNumber` 속성으로 결정된다.

```json
{
  "namespace": "exp-mgr",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "61.0",
  "packageDirectories": [
    {
      "path": "util",
      "default": true,
      "package": "Expense Manager - Util",
      "versionName": "Summer '24",
      "versionDescription": "Summer 2024 Expense Manager Util Package",
      "versionNumber": "2.2.0.NEXT",
      "definitionFile": "config/scratch-org-def.json"
    }
  ]
}
```

### NEXT 키워드로 고유 빌드 번호 보장

```json
"versionNumber": "2.2.0.NEXT"
```

- NEXT를 사용하면 빌드 번호를 수동으로 증가시키지 않아도 됨
- NEXT를 사용하지 않으면 동일한 버전 번호로 여러 버전이 생성될 수 있음

### CLI 플래그로 버전 번호 재정의

```bash
sf package version create -p "my2gp" --version-number 2.2.0.NEXT <rest of command syntax>
```

- `--version-number` 플래그는 `sfdx-project.json`을 업데이트하지 않음
- 프로젝트 파일은 별도로 수동 업데이트 필요

### 프로모션 후 버전 번호 동작

특정 MAJOR.MINOR.PATCH 버전을 프로모션한 후에는 동일한 MAJOR.MINOR.PATCH 버전 번호로 새 버전을 생성할 수 없다.

### Major/Minor/Patch 결정 기준

| 변경 유형 | 버전 번호 |
|---|---|
| 주요 변경 (Breaking Changes) | Major 버전 번호 증가 |
| 소규모 개선 | Minor 버전 번호 증가 |
| Patch 버전 | 허용된 변경만 가능 (제한 있음) |

### 일일 버전 생성 한도 확인

```bash
sf limits api display
```

`Package2VersionCreates` 항목 확인:
```
NAME                     REMAINING  MAXIMUM
──────────────────────── ──────────  ────────
Package2VersionCreates   23          50
```

---

## Code Coverage for Unlocked Packages

- 프로모션·릴리스 전 Apex 코드는 최소 **75% 코드 커버리지**를 충족해야 함
- 코드 커버리지 미충족 패키지 버전은 Scratch Org와 Sandbox에만 설치 가능
- Winter '21 이전에 릴리스 상태로 프로모션된 버전은 코드 커버리지 요건 미적용

코드 커버리지 계산:
```bash
sf package version create --code-coverage ...
```

코드 커버리지 조회:
```bash
sf package version list --verbose
sf package version report --package "Expense Manager@1.3.0.7"
```

- Org-Dependent Unlocked Package는 코드 커버리지 계산 안 함
- `--skip-validation`과 `--code-coverage`는 동시 사용 불가

---

## Considerations for Promoting Packages with Dependencies

의존성이 있는 패키지를 프로모션하기 전 아래 질문에 답한다:
- Base·Extension 패키지를 병렬로 개발 중인가?
- 새 버전 생성 시 Skip Validation을 사용하는가?
- 패키지 의존성 지정 시 LATEST 또는 RELEASED 키워드를 사용하는가?

세 가지 모두 "아니오"면 트리키한 의존성 시나리오가 없다.

### Skip Validation 사용 시 주의

Base 패키지를 Skip Validation으로 개발하면:
- Extension 패키지 테스트는 안정적으로 프로모션된 Base 버전 또는 non-skip-validated Base 버전으로 진행
- Base + Extension을 병렬 개발하는 경우 순서:
  1. Base 패키지 버전 먼저 프로모션
  2. Extension의 의존성을 RELEASED 키워드로 업데이트
  3. Extension 버전 생성

### LATEST vs RELEASED 키워드

| 키워드 | 의미 |
|---|---|
| LATEST | 가장 최근에 생성된 패키지 버전 (promoted 아닐 수 있음) |
| RELEASED | 프로모션 및 릴리스된 패키지 버전 |

예: 1.0.0.1, 1.0.0.2, 1.0.0.3을 생성하고 1.0.0.2를 프로모션한 경우:
- `1.0.0.RELEASED` = 1.0.0.2
- `1.0.0.LATEST` = 1.0.0.3

### 예시 시나리오

```json
{
  "path": "pkg-extension",
  "default": false,
  "package": "PkgExtn",
  "versionName": "v 2.3",
  "versionDescription": "Winter 2025",
  "versionNumber": "2.3.0.NEXT",
  "dependencies": [
    {
      "package": "PkgBase",
      "versionNumber": "1.1.0.LATEST"
    }
  ]
}
```

PkgExtn 2.3을 프로모션하기 전, 의존성을 `1.1.0.LATEST` → `1.1.0.RELEASED`로 변경 후 테스트.

---

## Simplify Package Development with Org Shape

패키지 메타데이터가 복잡한 기능·설정·라이선스에 의존하는 경우, Scratch Org Definition File에 선언적으로 지정하기 어렵다. 대신 Production Org 또는 다른 개발 Org의 Org Shape를 생성하고 Source Org ID를 정의 파일에 지정한다.

```json
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5"
}
```

패키지 생성 중 Source Org 환경을 모방하여 메타데이터를 빌드·검증한다.

---

## Use Branches in Unlocked Packaging

소스 컨트롤 시스템(SCS)에서 브랜치를 사용하는 팀은 특정 브랜치의 메타데이터를 기반으로 패키지 버전을 빌드한다.

```bash
sf package version create --branch featureA
```

- 알파벳·숫자 조합 최대 240자까지 브랜치명 지정 가능

`sfdx-project.json`에도 브랜치명 지정 가능:
```json
"packageDirectories": [
  {
    "path": "util",
    "default": true,
    "package": "pkgA",
    "versionName": "Spring '21",
    "versionNumber": "4.7.0.NEXT",
    "branch": "featureA"
  }
]
```

브랜치 지정 시 packageAliases에 자동으로 브랜치명이 추가됨:
```json
"packageAliases": {
  "pkgA@1.0.0.4-featureA": "04tB0000000IB1EIAW"
}
```

- 버전 번호는 **브랜치 내**에서 증가하며, 브랜치 간에는 동일한 번호가 존재할 수 있음

| Branch Name | Package Version Alias |
|---|---|
| featureA | pkgA@1.3.0-1-featureA |
| featureB | pkgA@1.3.0-1-featureB |
| (미지정) | pkgA@1.3.0-1 |

- 동일 버전 번호로 여러 beta 버전이 존재할 수 있지만, 프로모션·릴리스된 버전은 MAJOR.MINOR.PATCH당 하나만 가능

### Package Dependencies and Branches

```json
// 브랜치 속성으로 다른 브랜치의 의존성 지정
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.3.0.LATEST",
    "branch": "featureC"
  }
]
```

| 의존성 시나리오 | 형식 |
|---|---|
| 브랜치 속성 사용 | `"branch": "featureC"` |
| 프로모션된 최신 버전 | `"versionNumber": "2.1.0.RELEASED"` |
| 패키지에 브랜치 없는 경우 | `"branch": ""` |
| 패키지 alias 사용 | `"package": "pkgB@2.1.0-1-featureC"` |

---

## Target a Specific Release During Salesforce Release Transitions

주요 Salesforce 릴리스 전환 기간에 `preview` 또는 `previous`를 지정하여 패키지 버전을 생성할 수 있다.

```json
// 이전 릴리스 기준
{ "release": "previous" }

// 프리뷰 릴리스 기준
{ "release": "preview" }
```

```bash
sf package version create --package pkgA --definition-file config/project-scratch-def.json
```

- `sfdx-project.json`의 `sourceApiVersion`을 대상 릴리스 버전에 맞게 설정 필요
- previous 릴리스 타겟 시: 현재 릴리스보다 낮은 `sourceApiVersion` 값 허용

| Release Version | Preview Start Date | Preview End Date |
|---|---|---|
| Spring '26 | January 11, 2026 | February 21, 2026 |
| Summer '26 | May 10, 2026 | June 13, 2026 |
| Winter '27 | August 30, 2026 | October 10, 2026 |

---

## Release an Unlocked Package

새 패키지 버전은 생성 시 beta 상태로 표시된다. 프로덕션 Org에 설치할 준비가 된 버전을 릴리스할 때 `sf package version promote`를 사용한다.

**사전 조건:** Dev Hub Org에서 `Promote a package version to released` 사용자 권한이 활성화되어야 함.

```bash
sf package version promote --package "Expense Manager@1.3.0-7"
```

성공 메시지:
```
Successfully promoted the package version, ID: 04tB0000000719qIAA to released.
```

릴리스 상태 확인:
```bash
sf package version report --package "Expense Manager@1.3.0.7"
```

출력의 `Released: true` 확인.

- **프로모션은 각 버전 번호당 1회만 가능, 취소 불가**

---

## Update an Unlocked Package Version

버전의 이름, 설명 등 대부분의 속성을 CLI에서 변경 가능. **릴리스 상태(release status)는 변경 불가**.

```bash
sf package version update --package "Your Package Alias"
```

최근 패키지 버전이 릴리스된 경우, 다음 버전 생성 시 major·minor·patch 번호 중 하나를 반드시 증가시켜야 한다.

버전 번호 형식: `major.minor.patch.build`
- 1.0.0.2 릴리스 후 다음 버전: 1.1.0.0, 2.0.0.0, 1.0.1.0 중 택일

---

## Hard-Deleted Components in Unlocked Packages

아래 컴포넌트들이 Unlocked Package에서 제거되면 대상 설치 Org에서 **하드 삭제(hard delete)**된다. 기타 컴포넌트는 deprecated 처리되며, 어드민이 별도로 삭제 가능.

```
AccountForecastSettings, AcctMgrTargetSettings, ActionableListDefinition, ActionPlanTemplate,
AccountingFieldMapping, AccountingModelConfig, AdvAccountForecastSet, AdvAcctForecastDimSource,
AdvAcctForecastPeriodGroup, AIApplicationConfig, AIUsecaseDefinition, AnalyticSnapshot,
ApexClass, ApexComponent, ApexPage, ApexTrigger, ApplicationRecordTypeConfig,
ApplicationSubtypeDefinition, AppointmentAssignmentPolicy, AssessmentQuestion,
AssessmentQuestionSet, AssistantContextItem, AssistantSkillQuickAction,
AssistantSkillSobjectAction, AssistantVersion, AuraDefinitionBundle, BatchCalcJobDefinition,
BatchProcessJobDefinition, BenefitAction, BldgEnrgyIntensityCnfg, BrandingSet,
BriefcaseDefinition, BusinessProcessGroup, BusinessProcessTypeDefinition,
CareBenefitVerifySettings, CareLimitType, CareProviderSearchConfig, CareRequestConfiguration,
ChannelObjectLinkingRule, ClaimFinancialSettings, ClauseCatgConfiguration, CompactLayout,
ContractType, ConversationVendorInfo, CustomApplication, CustomPageWebLink, CustomPermission,
CustomTab, Dashboard, DecisionMatrixDefinition, DecisionMatrixDefinitionVersion, DecisionTable,
DecisionTableDatasetLink, DisclosureDefinition, DisclosureDefinitionVersion, DisclosureType,
DiscoveryAIModel, DiscoveryGoal, Document, DocumentGenerationSetting, DocumentType,
EmailServicesFunction, EmailTemplate, EmbeddedServiceBranding, EmbeddedServiceConfig,
EmbeddedServiceLiveAgent, EmbeddedServiceMenuSettings, ESignatureConfig, ESignatureEnvelopeConfig,
ExplainabilityActionDefinition, ExplainabilityActionVersion, ExplainabilityMsgTemplate,
ExpressionSetDefinition, ExpressionSetDefinitionVersion, ExpressionSetObjectAlias,
ExternalAIModel, ExternalClientApplication, ExtlClntAppMobileSettings, ExtlClntAppOauthSettings,
ExternalDataSrcDescriptor, ExternalServiceRegistration, FeatureParameterBoolean,
FeatureParameterDate, FeatureParameterInteger, FieldRestrictionRule, FieldServiceMobileExtension,
FlexiPage, Flow, FuelType, FuelTypeSustnUom, GatewayProviderPaymentMethodType,
HomePageComponent, HomePageLayout, IdentityVerificationProcDef, InstalledPackage,
IntegrationHubSettings, IntegrationHubSettingsType, IntegrationProviderDef, Layout, Letterhead,
LicenseDefinition, LightningComponentBundle, LightningExperienceTheme, LightningMessageChannel,
LightningOnboardingConfig, ListView, LiveChatAgentConfig, LiveChatButton,
LiveChatSensitiveDataRule, LocationUse, LoyaltyProgramSetup, MarketingAppExtActivity,
MarketingAppExtension, MatchingRule, MfgProgramTemplate, MLDataDefinition, MLPredictionDefinition,
NamedCredential, NetworkBranding, ObjectHierarchyRelationship, OcrSampleDocument, OcrTemplate,
OmniDataTransform, OmniIntegrationProcedure, OmniScript, OmniUiCard, PaymentGatewayProvider,
PermissionSet, PermissionSetGroup, PermissionSetLicense, PipelineInspMetricConfig,
PlatformEventSubscriberConfig, ProductAttributeSet, ProductSpecificationTypeDefinition, Profile,
QuickAction, RecordAlertCategory, RecordAlertDataSource, RegisteredExternalService,
RelatedRecordAssocCriteria, RelationshipGraphDefinition, RemoteSiteSetting, Report, ReportType,
RestrictionRule, SalesAgreementSettings, SchedulingRule, SchedulingObjective, ScoreCategory,
ServiceAISetupDefinition, ServiceAISetupField, ServiceProcess, SharingReason,
SharingRecalculation, SlackApp, StaticResource, StnryAssetEnvSrcCnfg, SustainabilityUom,
SustnUomConversion, SvcCatalogCategory, SvcCatalogFulfillmentFlow, SvcCatalogItemDef,
TimelineObjectDefinition, UIObjectRelationConfig, UserAccessPolicy, UserLicense,
UserProfileSearchScope, ValidationRule, VehicleAssetEmssnSrcCnfg, ViewDefinition,
VirtualVisitConfig, WaveApplication, WaveComponent, WaveDashboard, WaveDataflow, WaveDataset,
WaveLens, WaveRecipe, WaveTemplateBundle, WaveXmd, WebLink, WebStoreTemplate, WorkflowAlert,
WorkflowFieldUpdate, WorkflowFlowAction, WorkflowOutboundMessage, WorkflowRule, WorkflowTask
```

패키지를 언인스톨하면 deprecated 컴포넌트를 포함한 모든 컴포넌트가 삭제된다.

---

## Delete an Unlocked Package or Package Version

```bash
# 패키지 버전 삭제
sf package version delete -p "Your Package Version Alias"
sf package version delete -p 04t...

# 패키지 삭제
sf package delete -p "Your Package Alias"
sf package delete -p 0Ho...
```

- **삭제는 영구적**
- 삭제된 패키지 버전 설치 시도 → 실패
- 삭제 전 해당 패키지/버전이 다른 패키지의 의존성으로 참조되지 않는지 확인
- 패키지 삭제 전 모든 관련 패키지 버전을 먼저 삭제
- 필요 권한: `Delete Second-Generation Packages`

| 패키지 유형 | Beta 버전 삭제 | 릴리스 버전 삭제 |
|---|---|---|
| Second-Generation Managed Package | ✅ | ❌ |
| Unlocked Package | ✅ | ✅ |

- 1GP Managed Package / Unmanaged Package에는 이 CLI 명령 사용 불가

---

## View Package Details

```bash
# Dev Hub Org의 모든 패키지 목록
sf package list --target-dev-hub my-hub
```

출력 예시:
```
Name            Id                  Alias           Description  Type
─────────────── ─────────────────── ─────────────── ──────────── ───────────
Expenser App    0HoB00000004CzRKAU  Expenser App                 Unlocked
Expenser Logic  0HoB00000004CzMKAU  Expenser Logic               Unlocked
Expenser Schema 0HoB00000004CzHKAU  Expenser Schema              Unlocked
```

```bash
# Dev Hub Org의 모든 패키지 버전 목록
sf package version list --target-dev-hub my-hub
```

| 플래그 | 효과 |
|---|---|
| `--concise` | 최소한의 세부 정보 표시 |
| `--verbose` | 확장된 세부 정보 표시 (코드 커버리지 포함) |
| `--created-last-days N` | 최근 N일 이내 생성된 버전만 표시 |

---

## 관련 노트

- [[Unlocked Package 개념과 준비]]
- [[Unlocked Package 생성과 설정]]
- [[Unlocked Package 릴리스와 설치]]
- [[Scratch Org 생성과 정의 파일]]
- [[Org Shape와 Snapshot]]
- [[CI 통합 전수 (CircleCI·Jenkins·Travis)]]
- [[Metadata Coverage 보고서]] — Hard-Deleted Components 및 Unlocked Package 메타데이터 지원 채널 확인
- [[DX 제약사항]] — Unlocked Package 관련 알려진 제약 (shared namespace 시크릿 노출)
- [[2GP — Develop]] — 2GP managed 버전 생성 비교: Async/Skip Validation, MAJOR.MINOR.PATCH.BUILD, Package Ancestor 규칙
