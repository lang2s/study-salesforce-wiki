---
tags: [DevOps, Packaging, 2GP, ManagedPackage, Einstein, Analytics, Agentforce, GenAi, Bot, AIApplication, DiscoveryAI, Report, Dashboard, RecommendationStrategy, ManageabilityRules, IPProtection, PackagingConsiderations, Components, EinsteinAnalytics]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — Components Available in Second-Generation Managed Packages, pp.48–57, 70–71, 113–114, 143–145, 204–206, 261, 270–272
created: 2026-05-23
aliases: [2GP Einstein 패키징, 2GP Analytics 패키징, 2GP Agentforce 패키징, 2GP GenAi 패키징, 2GP Bot 패키징, 2GP Report 패키징, AffinityScoreDefinition 2GP, AIApplication 2GP, AIApplicationConfig 2GP, AiEvaluationDefinition 2GP, AIUsecaseDefinition 2GP, AnalyticsVisualization 2GP, AnalyticsWorkspace 2GP, BotTemplate 2GP, Dashboard 2GP, DiscoveryAIModel 2GP, DiscoveryGoal 2GP, DiscoveryStory 2GP, GenAiFunction 2GP, GenAiPlugin 2GP, GenAiPlannerBundle 2GP, GenAiPromptTemplate 2GP, Report 2GP, ReportType 2GP, RecommendationStrategy 2GP, 2GP Einstein Analytics 컴포넌트]
---

# 2GP — Components: Einstein & Analytics

> 2GP Managed Package에서 **Einstein AI·Analytics·Agentforce·Bot·Report/Dashboard** 관련 컴포넌트의 패키징 규칙 전수. Manageability Rules 4속성, Editable Properties 3카테고리, 패키징 시 고려사항, 라이선스 요건을 컴포넌트별로 정리.

---

## Manageability Rules — 읽는 방법

각 컴포넌트마다 아래 4속성이 정의된다.

| 속성 | 의미 |
|---|---|
| **Component Is Updated During Package Upgrade** | 패키지 신버전 설치 시 해당 컴포넌트가 구독자 org에서 자동 업데이트되는가 |
| **Subscriber Can Delete Component From Org** | 구독자가 자기 org에서 이 컴포넌트를 삭제할 수 있는가 |
| **Package Developer Can Remove Component From Package** | 개발자가 신버전 패키지에서 이 컴포넌트를 제거할 수 있는가 |
| **Component Has IP Protection** | 컴포넌트의 메타데이터가 구독자 org에서 숨겨지는가 |

Editable Properties After Package Promotion or Installation은 3카테고리로 구분된다.
- **Only Package Developer Can Edit** — 개발자만 신버전에서 수정 가능
- **Both Package Developer and Subscriber Can Edit** — 양측 모두 수정 가능
- **Neither Package Developer or Subscriber Can Edit** — 양측 모두 수정 불가 (잠김)

> 컴포넌트 제거(Remove)는 Salesforce 승인이 필요하다. 제거 기능 접근을 요청하려면 Salesforce Partner Community에 지원 케이스를 등록한다.

---

## AffinityScoreDefinition

> Represents the affinity information used in calculations to analyze and categorize contacts for marketing purposes.

**Metadata Name:** `AffinityScoreDefinition`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | AffinityScoreType, NumberOfMonths, NumberOfRanges, SourceFieldApiNameList, TargetFieldApiNameList, ScoreRangeList |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Fundraising Metadata API Types: AffinityScoreDefinitions
- Salesforce Help: Set Up RRM Scoring
- Salesforce Help: Scoring Frameworks Help Increase Fundraising Success

---

## Agent Action (GenAiFunction)

> Represents an action, for use in Agentforce.

**Metadata Name:** `GenAiFunction`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Generative AI Function Definition

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** (단, 액션이 Flow나 Apex 코드를 포함하면 해당 코드에 IP Protection 적용) |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, IsConfirmationRequired, MasterLabel; Action Input Fields: CopilotAction.IsUserInput, Description, IsPII, Properties (Inherited from invocationTarget), Title (Inherited from invocationTarget), Required, Lightning.Type; Action Output Fields: Description, CopilotAction.IsDisplayable, IsPII, CopilotAction.IsUsedByPlanner, Properties (Inherited from invocationTarget), Title (Inherited from invocationTarget) |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | DeveloperName, InvocationTarget, InvocationTargetType |

### Considerations When Packaging

Apex 타입의 Agent Action을 생성할 때, Apex 클래스·invocable Apex 메서드·모든 invocable Apex 변수는 반드시 `global`로 선언해야 한다. `public` 또는 `private`이면 Agent Action 옵션 목록에 나타나지 않고 런타임에 에이전트가 호출하지 않는다.

### Use Case

Provide actions that customers can add to their own topics and agents.

### Documentation

- Salesforce Help: Agentforce Agents
- Salesforce Help: Agentforce Actions
- Metadata API Developer Guide: GenAiFunction

---

## Agent Topic (GenAiPlugin)

> Represents a topic, for use in Agentforce.

**Metadata Name:** `GenAiPlugin`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Generative AI Plugin Definition

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, MasterLabel, Scope, AiPluginUtterances, GenAiFunctions, GenAiPluginInstructions |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | DeveloperName, PluginType |

### Considerations When Packaging

구독자는 관리형 패키지로 설치된 Topic에 연결된 Action을 편집할 수 없다. 대신 구독자가 Topic의 복사본을 수동으로 만들고 해당 복사본에 Action을 할당해야 한다.

### Use Case

Provide topics that customers can add to their own agents. Actions can be added to topics.

### Documentation

- Salesforce Help: Agentforce Agents
- Salesforce Help: Agentforce Topics

---

## AI Application

> Represents an instance of an AI application. For example, Einstein Prediction Builder.

**Metadata Name:** `AIApplication`
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
| Only Package Developer Can Edit | Type |
| Both Package Developer and Subscriber Can Edit | Status, ExternalId, MlExternalId |
| Neither Package Developer or Subscriber Can Edit | Name |

### Considerations When Packaging

AIApplication은 모든 Einstein 구성 엔티티의 부모 엔티티다. Einstein 기능 패키징은 반드시 하나 이상의 AIApplication 선택으로 시작해야 한다.
- ML Prediction Definition을 포함한 패키지를 생성하려면: 부모 AIApplication (Type = PredictionBuilder)을 선택한다. 패키징이 자동으로 관계를 분석하고 Einstein 구성을 완전히 정의하는 데 필요한 MLPredictionDefinitions, MLRecommendationDefinitions, MLDataDefinitions를 포함한다.
- ML Recommendation Definition을 포함한 패키지를 생성하려면: 부모 AIApplication (Type = RecommendationBuilder)을 선택한다.

### Documentation

- Metadata API Developer Guide: AIApplication
- Salesforce Help: Einstein Prediction Builder
- Salesforce Help: Einstein Recommendation Builder

---

## AI Application Config

> Represents additional prediction information related to an AI application.

**Metadata Name:** `AIApplicationConfig`
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
| Only Package Developer Can Edit | AIApplicationId |
| Both Package Developer and Subscriber Can Edit | Rank, IsInsightReasonEnabled, AIScoringMode, ExternalId |
| Neither Package Developer or Subscriber Can Edit | Name |

### Considerations When Packaging

AIApplicationConfig는 항상 AIApplication과 연결된다. Einstein 기능 패키징은 반드시 하나 이상의 AIApplication 선택으로 시작해야 한다. 부모 AIApplication을 선택하면 패키징이 자동으로 관계를 분석하고 MLApplicationConfig, MLPredictionDefinition, MLRecommendationDefinitions, MLDataDefinitions를 포함한다.

### Documentation

- Metadata API Developer Guide: AIApplicationConfig
- Salesforce Help: Einstein Prediction Builder
- Salesforce Help: Einstein Recommendation Builder

---

## AIUsecaseDefinition

> Represents a collection of fields in a Salesforce org used to define a machine learning use case and get real-time predictions.

**Metadata Name:** `AIUsecaseDefinition`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** AIUsecaseDefinition

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All the AIUsecaseDefinition fields |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Use Case

AI Usecase Definition lets you ship data that can be used to set up use cases for which you want to generate real-time predictions. This data includes machine learning models and feature extractors required to generate the real-time predictions.

### License Requirements

CRM Plus 라이선스 및 사용 사례 관련 제품의 CRM 라이선스 필요.

### Documentation

- Industries Common Resources Developer Guide: AI Accelerator
- Salesforce Help: AI Accelerator

---

## Analytics (CRM Analytics — Wave)

> Analytics components include analytics applications, dashboards, dataflows, datasets, lenses, recipes, and user XMD.

**Packageable In:** 2GP, 1GP
**Metadata Names:** `WaveApplication`, `WaveDashboard`, `WaveDataflow`, `WaveDataset`, `WaveLens`, `WaveRecipe`, `WaveTemplateBundle`, `WaveXmd`, `WaveComponent`, `WaveAnalyticAssetCollection`

### Manageability Rules (Analytics 그룹 전체)

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** (Analytics Dataflow만). 기타 모든 Analytics 컴포넌트는 업데이트 불가 |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (Analytic Snapshot만 — 2GP 패키지만 지원). 기타 모든 Analytics 컴포넌트는 제거 불가 |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Considerations When Packaging

- 2GP 패키지에 Analytics 컴포넌트를 포함하려면 scratch org 정의 파일에 `EinsteinAnalyticsPlus`를 포함해야 한다.
- 1GP 패키징 org에서 Analytics를 활성화하려면 Salesforce Help의 Basic CRM Analytics Platform Setup을 참조한다.
- 자세한 사항은 CRM Analytics Packaging Considerations를 참조한다.

---

## Analytics Visualization (AnalyticsVisualization)

> Represents a Tableau Next visualization.

**Metadata Name:** `AnalyticsVisualization`
**Packageable In:** **1GP only** (2GP 미지원)
**1GP Package Manager UI:** Analytics Visualization

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label |
| Both Package Developer and Subscriber Can Edit | Description |
| Neither Package Developer or Subscriber Can Edit | Full Name, Is Original, Version |

### License Requirements

Tableau Next Admin 또는 Tableau Next Analyst 권한 세트 필요.

### Documentation

- Salesforce Help: Build Insightful Visualizations in Tableau Next

---

## Analytics Workspace (AnalyticsWorkspace)

> Represents a Tableau Next workspace.

**Metadata Name:** `AnalyticsWorkspace`
**Packageable In:** **1GP only** (2GP 미지원)
**1GP Package Manager UI:** Analytics Workspace

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label |
| Both Package Developer and Subscriber Can Edit | Description |
| Neither Package Developer or Subscriber Can Edit | None |

### License Requirements

Tableau Next Admin 또는 Tableau Next Analyst 권한 세트 필요.

### Documentation

- Salesforce Help: Tableau Next Workspaces

---

## Bot Template (BotTemplate)

> Represents the configuration details for a specific Einstein Bot template, including dialogs and variables.

**Metadata Name:** `BotTemplate`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Bot Template

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Bot Dialog Groups, Bot Dialogs, Conversation Context Variables, Conversation Languages, Conversation Definition Goals, Conversation System Dialogs, Conversation Variables, Description, Entry Dialog, Icon, Main Menu Dialog, Label, MlDomain, Rich Content Enabled |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Salesforce Help: Create an Einstein Bot Template
- Salesforce Help: Create a Template from an Einstein Bot
- Salesforce Help: Package an Einstein Bot Template
- Metadata API Developer Guide: BotTemplate

---

## Dashboard

> Represents a dashboard. Dashboards are visual representations of data that allow you to see key metrics and performance at a glance.

**Metadata Name:** `Dashboard`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Dashboard

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** (1GP·2GP 모두 지원) |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Dashboard Unique Name |
| Neither Package Developer or Subscriber Can Edit | Dashboard Unique Name |

### Considerations When Packaging

개발자는 이전 버전 패키지에서 릴리스된 보고서를 참조하는 대시보드 컴포넌트를 도입할 때 영향을 고려해야 한다. 구독자가 보고서를 삭제하거나 개인 폴더로 이동한 경우, 해당 보고서를 참조하는 대시보드 컴포넌트는 설치 중에 삭제된다. 구독자가 보고서를 수정한 경우에는 수정된 보고서 결과가 대시보드 컴포넌트 표시에 영향을 줄 수 있다. 대시보드와 관련 보고서를 동일 버전에 릴리스하는 것을 권장한다.

### Documentation

- Metadata API Developer Guide: Dashboard

---

## Discovery AI Model (DiscoveryAIModel)

> Represents the metadata associated with a model used in Einstein Discovery.

**Metadata Name:** `DiscoveryAIModel`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Discovery AI Model Unique Name |
| Neither Package Developer or Subscriber Can Edit | Discovery AI Model Unique Name |

### Documentation

- Metadata API Developer Guide: DiscoveryAIModel

---

## Discovery Goal (DiscoveryGoal)

> Represents the metadata associated with an Einstein Discovery prediction definition.

**Metadata Name:** `DiscoveryGoal`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Discovery Goal Unique Name |
| Neither Package Developer or Subscriber Can Edit | Discovery Goal Unique Name |

### Documentation

- Metadata API Developer Guide: DiscoveryGoal

---

## Discovery Story (DiscoveryStory)

> Represents the metadata associated with a story used in Einstein Discovery.

**Metadata Name:** `DiscoveryStory`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Discovery Story Unique Name |
| Neither Package Developer or Subscriber Can Edit | Discovery Story Unique Name |

### Documentation

- Metadata API Developer Guide: DiscoveryStory

---

## Gen Ai Planner Bundle (GenAiPlannerBundle)

> Represents a planner for an agent or agent template. It's a container for all the topics and actions used to interact with a large language model (LLM).

**Metadata Name:** `GenAiPlannerBundle`
**Packageable In:** **2GP only**
**2GP Package Manager UI:** Generative AI Planner Bundle

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Capabilities, Description, MasterLabel |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Use Case

Represents a planner for an agent or agent template. It's a container for all the topics and actions used to interact with a large language model (LLM).

### Documentation

- Salesforce Help: Agentforce Agents
- Salesforce Help: The Building Blocks of Agents

---

## Generative AI Prompt Template (GenAiPromptTemplate)

> Represents a generative AI prompt template, for use in Agentforce.

**Metadata Name:** `GenAIPromptTemplate`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Generative AI Prompt Template

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Template Active Version |
| Both Package Developer and Subscriber Can Edit | Template Description |
| Neither Package Developer or Subscriber Can Edit | Prompt Template Name, Prompt Template Version |

### Considerations When Packaging

Prompt Builder에서 생성된 프롬프트 템플릿 패키징 시 Considerations for Packaging Prompt Templates를 참조한다.

### License Requirements

Generative AI SKU가 필요하다 (Prompt Builder 프로비저닝용).

### Documentation

- Metadata API Developer Guide: GenAiPromptTemplate

---

## Recommendation Strategy (RecommendationStrategy)

> Represents a recommendation strategy. Recommendation strategies are applications, similar to data flows, that determine a set of recommendations to be delivered to the client through data retrieval, branching, and logic operations.

**Metadata Name:** `RecommendationStrategy`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Recommendation Strategy

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

PDF에 상세 Editable Properties 섹션이 명시되어 있지 않다. Metadata Coverage Report에서 최신 정보를 확인한다.

### Use Case

개인화된 추천을 만들어 최종 사용자에게 제공하는 데 사용할 수 있다. 추천은 Salesforce에서 컨텍스트에 맞게 표시되고 최종 사용자가 제안을 수락하거나 거절하도록 유도한다. 최종 사용자가 추천을 수락하거나 거절하면 Salesforce가 레코드 생성 또는 업데이트 등의 프로세스를 자동화한다.

### Considerations When Packaging

추천 전략을 패키징할 때 recommendation, recommendationReaction, flow 등의 객체 의존성을 수동으로 추가해야 한다. Recommendation과 RecommendationReaction에 대한 객체 의존성은 자동으로 추가되지 않으므로 어드민이 직접 선택해야 한다.

### Documentation

- Salesforce Help: Einstein Next Best Action

---

## Report

> Represents a custom report.

**Metadata Name:** `Report`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Report

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** (1GP·2GP 모두 지원) |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Report Unique Name |
| Neither Package Developer or Subscriber Can Edit | Report Unique Name |

### Considerations When Packaging

패키지에 포함할 수 없는 요소가 있는 보고서는 해당 요소가 삭제·다운그레이드되거나 패키지 생성이 실패한다.
- 활동 및 기회 보고서의 계층 드릴다운은 삭제된다.
- 패키징 불가능한 필드의 필터는 자동으로 삭제된다 (예: 표준 오브젝트 record type 필터).
- 패키징 불가능한 필드의 필터 로직이 있는 보고서는 업로드가 실패한다.
- 표준 캠페인 보고서의 Select Campaign 필드 조회값은 삭제된다.
- 개인 폴더나 Unfiled Public Reports 폴더로 이동된 보고서는 패키지에서 삭제된다.
- Chart Analytics 2.0이 없는 org에 패키지 설치 시: 조합 차트는 삭제 대신 다운그레이드되고, 도넛·퍼널 등 지원되지 않는 차트 타입은 삭제된다.

### Documentation

- Metadata API Developer Guide: Report

---

## Report Type (ReportType)

> Represents the metadata associated with a custom report type. Custom report types allow you to build a framework from which users can create and customize reports.

**Metadata Name:** `ReportType`
**Packageable In:** 2GP, 1GP
**1GP Package Manager UI:** Custom Report Type

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (2GP 패키지만 지원) |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All attributes except Development Status and Report Type Name |
| Both Package Developer and Subscriber Can Edit | Development Status |
| Neither Package Developer or Subscriber Can Edit | Report Type Name |

### Considerations When Packaging

개발자는 관리형 패키지에서 커스텀 보고서 타입을 릴리스 후 편집하고 새 필드를 추가할 수 있다. 구독자는 새 버전 설치 시 변경 사항을 자동으로 받는다. 단, 패키지가 릴리스된 후에는 보고서 타입에서 오브젝트를 제거할 수 없다. 관리형 패키지 커스텀 보고서 타입에서 버킷 또는 그룹화에 사용된 필드를 삭제하면 오류 메시지가 표시된다.

### Documentation

- Metadata API Developer's Guide: ReportType

---

## 요청 목록에 포함되었으나 PDF에 상세 Manageability Rules 섹션이 없는 컴포넌트

다음 컴포넌트들은 2GP Supported Components 요약 목록 또는 관련 패키징 문서에 등장하지만, `pkg2_dev.pdf` 내에 Manageability Rules 상세 섹션이 존재하지 않는다. 해당 컴포넌트들의 정확한 패키징 규칙은 [Metadata Coverage Report](https://developer.salesforce.com/docs/metadata-coverage) 또는 Salesforce 공식 문서에서 확인한다.

| 컴포넌트 | Metadata Name | 비고 |
|---|---|---|
| AiEvaluationDefinition | `AiEvaluationDefinition` | PDF에 상세 섹션 없음 |
| AIScoringModelDefinition | `AIScoringModelDefinition` | PDF에 상세 섹션 없음 |
| AnalyticSnapshot | `AnalyticSnapshot` | Analytics 그룹 요약에 "Analytic snapshot only — 2GP only로 Remove 가능"으로 언급. 상세 섹션 없음 |
| Bot | `Bot` | PDF Summary 목록에 등장. 상세 섹션 없음. BotBlock·BotVersion도 동일 |
| BotBlock | `BotBlock` | PDF에 상세 섹션 없음 |
| BotVersion | `BotVersion` | PDF에 상세 섹션 없음 |
| ConvIntelligenceSignalRule | `ConvIntelligenceSignalRule` | PDF에 상세 섹션 없음 |
| ExternalAIModel | `ExternalAIModel` | PDF에 상세 섹션 없음 |
| MLDataDefinition | `MLDataDefinition` | AIApplication 하위 자동 포함 (패키징 자동 분석). 별도 섹션 없음 |
| MLPredictionDefinition | `MLPredictionDefinition` | AIApplication 하위 자동 포함 (패키징 자동 분석). 별도 섹션 없음 |
| GenAiPlanner | `GenAiPlanner` | PDF에 GenAiPlannerBundle 섹션만 존재. GenAiPlanner 단독 섹션 없음. GenAiPlannerBundle 항목 참조 |
| ServiceAISetupDefinition | `ServiceAISetupDefinition` | PDF에 상세 섹션 없음 |

> **MLDataDefinition·MLPredictionDefinition 패키징 주의:** 이 두 컴포넌트는 AIApplication 선택 시 패키징 시스템이 자동으로 관계를 분석하고 포함한다. 직접 지정하지 않아도 된다.

---

## 전체 비교표

| 컴포넌트 | Metadata Name | Packageable In | Updated on Upgrade | Sub Delete | Dev Remove | IP Protection |
|---|---|---|---|---|---|---|
| AffinityScoreDefinition | `AffinityScoreDefinition` | 2GP+1GP | Yes | No | Yes | No |
| Agent Action (GenAiFunction) | `GenAiFunction` | 2GP+1GP | Yes | No | Yes | No |
| Agent Topic (GenAiPlugin) | `GenAiPlugin` | 2GP+1GP | Yes | No | Yes | No |
| AI Application | `AIApplication` | 2GP+1GP | Yes | No | **No** | No |
| AI Application Config | `AIApplicationConfig` | 2GP+1GP | Yes | No | **No** | No |
| AIUsecaseDefinition | `AIUsecaseDefinition` | 2GP+1GP | Yes | No | Yes | No |
| Analytics (Wave 전체) | 복수 | 2GP+1GP | Yes (Dataflow만) | No | Yes (Analytic Snapshot/2GP만) | No |
| Analytics Visualization | `AnalyticsVisualization` | **1GP only** | Yes | Yes | Yes | No |
| Analytics Workspace | `AnalyticsWorkspace` | **1GP only** | Yes | Yes | Yes | No |
| Bot Template | `BotTemplate` | 2GP+1GP | Yes | Yes | Yes | No |
| Dashboard | `Dashboard` | 2GP+1GP | **No** | Yes | Yes | No |
| Discovery AI Model | `DiscoveryAIModel` | 2GP+1GP | **No** | Yes | Yes | No |
| Discovery Goal | `DiscoveryGoal` | 2GP+1GP | **No** | Yes | Yes | No |
| Discovery Story | `DiscoveryStory` | 2GP+1GP | **No** | Yes | Yes | No |
| Gen Ai Planner Bundle | `GenAiPlannerBundle` | **2GP only** | Yes | No | Yes | No |
| Generative AI Prompt Template | `GenAIPromptTemplate` | 2GP+1GP | Yes | No | Yes | No |
| Recommendation Strategy | `RecommendationStrategy` | 2GP+1GP | Yes | No | **No** | **Yes** (templates 제외) |
| Report | `Report` | 2GP+1GP | **No** | Yes | Yes | No |
| Report Type | `ReportType` | 2GP+1GP | Yes | No | Yes (2GP만) | No |

**주요 패턴:**
- **Einstein Discovery 3종 (DiscoveryAIModel·DiscoveryGoal·DiscoveryStory):** 모두 Updated No · Subscriber Delete Yes · Dev Remove Yes — 구독자가 삭제 가능하고 업그레이드 시 자동 갱신되지 않는다.
- **Report·Dashboard:** 패키징 후 Updated No — 설치 이후 구독자·개발자가 자유롭게 수정 가능하나 업그레이드로 덮어쓰이지 않는다.
- **AI Application·AI Application Config:** Dev Remove No — 한번 패키지에 넣으면 제거 불가. AIApplication은 모든 Einstein 기능 패키징의 시작점.
- **RecommendationStrategy:** IP Protection Yes (templates 제외) — 전략 로직이 구독자에게 숨겨진다.
- **GenAiPlannerBundle:** 2GP only.
- **Analytics Visualization·Workspace:** 1GP only (Tableau Next 전용).

---

```xml
<!-- 구조 예시 — Agentforce 컴포넌트 package.xml -->
<!-- GenAiPlugin(Topic) + GenAiFunction(Action) + GenAiPlannerBundle 패키징 -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>MySalesAgent</members>
        <name>GenAiPlannerBundle</name>
    </types>
    <types>
        <members>MySalesAgent_SalesSupport</members>
        <name>GenAiPlugin</name>
    </types>
    <types>
        <members>MySalesAgent_GetAccountInfo</members>
        <name>GenAiFunction</name>
    </types>
    <types>
        <members>MyPromptTemplate</members>
        <name>GenAIPromptTemplate</name>
    </types>
    <version>67.0</version>
</Package>
```

```xml
<!-- 구조 예시 — Einstein AIApplication + 관련 컴포넌트 패키징 -->
<!-- AIApplication 선택 시 MLPredictionDefinition/MLDataDefinition 자동 포함 -->
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>MyEinsteinApp</members>
        <name>AIApplication</name>
    </types>
    <types>
        <members>MyEinsteinApp</members>
        <name>AIApplicationConfig</name>
    </types>
    <version>67.0</version>
</Package>
```

---

## 관련 노트

- [[Metadata Types — Einstein & Analytics]] — MetadataAPI 관점의 동일 컴포넌트 필드 정의 (WaveApplication, GenAiPlanner, Bot, DiscoveryAIModel 등)
- [[2GP — Components: Apex & Code]] — 동일 시리즈: Apex Class·Trigger·LWC·Aura·Visualforce 패키징 규칙
- [[2GP — Components: Automation]] — 동일 시리즈: Flow·Workflow·Decision Table·Expression Set·Batch 자동화 컴포넌트 패키징 규칙
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로·Manageability Rules 4속성 개요·Supported Components 전체 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — Manageability Rules 개념 설명·Package Ancestry·IP Protection 원리
- [[2GP — Components: Integration & Platform]] — NamedCredential·FeatureParameter·ExternalDataSource·EventRelayConfig·PlatformCachePartition 등 통합·플랫폼 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Objects & Fields]] — AssessmentQuestion·BriefcaseDefinition·CustomObject·CustomField·CustomLabels·GlobalValueSet·Folder·FieldSet 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Security & Access]] — AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·ExternalAuthIdentityProvider·ExternalCredential·PermissionSet·PermissionSetGroup 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
