---
tags: [devops, metadata-api, metadata-types, einstein, analytics, wave, agentforce, ai, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [WaveApplication 메타데이터, AIApplication 메타데이터, Bot 메타데이터, GenAiPlanner 메타데이터, 아인슈타인 분석 메타데이터 타입, Agentforce 메타데이터]
---

# Metadata Types — Einstein & Analytics

> Einstein AI, CRM Analytics(Wave), Agentforce(GenAi), Bot, DiscoveryAIModel 등 AI·분석 관련 메타데이터 타입.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| AffinityScoreDefinition | 어피니티 점수 정의 (마케팅) |
| AIApplication | AI 애플리케이션 인스턴스 |
| AIApplicationConfig | AI 애플리케이션 추가 예측 정보 |
| AiAuthoringBundle | AI 저작 번들 (Agent Script 등) |
| AiEvaluationDefinition | 에이전트 평가 정의 |
| AIScoringModelDefinition | 머신러닝 점수 모델 정의 |
| AIUsecaseDefinition | 머신러닝 유스케이스 정의 |
| AnalyticsDashboard | Tableau Next 대시보드 |
| AnalyticSnapshot | 보고 스냅샷 |
| AnalyticsVisualization | Tableau Next 시각화 |
| AnalyticsWorkspace | Tableau Next 작업공간 |
| Bot | Einstein Bot 구성 정의 |
| BotBlock | Einstein Bot 블록 구성 |
| BotTemplate | Einstein Bot 템플릿 |
| BotVersion | Einstein Bot 버전 |
| CallCoachingMediaProvider | Einstein Conversation Insights 음성 제공자 |
| ConvIntelligenceSignalRule | 대화 인텔리전스 신호 규칙 |
| Dashboard | 대시보드 |
| DiscoveryAIModel | Einstein Discovery 모델 |
| DiscoveryGoal | Einstein Discovery 예측 정의 |
| DiscoveryStory | Einstein Discovery 스토리 |
| EclairGeoData | Analytics 커스텀 지도 차트 |
| ExplainabilityMsgTemplate | 의사결정 설명 메시지 템플릿 |
| ExternalAIModel | Einstein for Service 모델 상태 |
| GenAiFunction | AI 에이전트 액션 |
| GenAiPlanner | AI 에이전트 플래너 |
| GenAiPlannerBundle | AI 에이전트 플래너 번들 |
| GenAiPlugin | AI 에이전트 주제 (Agent Topic) |
| GenAiPluginInstructionDef | 주제 지침 정의 |
| GenAiPromptTemplate | 프롬프트 템플릿 정의 |
| GenAiPromptTemplateActv | Salesforce 제공 프롬프트 템플릿 활성화 상태 |
| MlDomain | Einstein Intent Set |
| MLDataDefinition | 모델링 데이터 정의 |
| MLPredictionDefinition | 예측 정의 |
| RecommendationStrategy | 추천 전략 |
| ReferencedDashboard | CRM Analytics 외부 참조 대시보드 |
| Report | 커스텀 리포트 |
| ReportType | 커스텀 리포트 타입 |
| ServiceAISetupDefinition | Einstein for Service 기능 설정 |
| ServiceAISetupField | Einstein 기사 추천용 필드 |
| WaveAnalyticAssetCollection | Analytics 자산 컬렉션 |
| WaveApplication | CRM Analytics 애플리케이션 |
| WaveComponent | Analytics 컴포넌트 |
| WaveDataflow | Analytics 데이터플로우 |
| WaveDashboard | Analytics 대시보드 |
| WaveDataset | Analytics 데이터셋 |
| WaveLens | Analytics Lens |
| WaveRecipe | Analytics 레시피 |
| WaveTemplateBundle | Analytics 템플릿 번들 |
| WaveXmd | Analytics XMD |

---

## CRM Analytics (Wave) 타입군

### WaveApplication

CRM Analytics(Tableau CRM) 애플리케이션. `Metadata` 타입을 extends.

**파일 경로:** `wave/AppName.wapp`

#### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `assetIcon` | string | - | 앱 아이콘 이름 |
| `description` | string | - | 앱 설명 |
| `folder` | string | - | 폴더 경로 |
| `fullName` | string | - | 앱 고유 이름 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `shares` | FolderShare[] | - | 공유 설정 |
| `templateOptions` | WaveTemplateDetails | - | 템플릿 옵션 |

---

### WaveDataflow

Analytics 데이터플로우. `MetadataWithContent` 타입을 extends.

---

### WaveDashboard

Analytics 대시보드. `MetadataWithContent` 타입을 extends.

---

### WaveDataset

Analytics 데이터셋. `Metadata` 타입을 extends.

---

### WaveLens

Analytics Lens.

---

### WaveRecipe

Analytics 레시피 (저장된 데이터 변환 단계). `MetadataWithContent` 타입을 extends.

---

### WaveTemplateBundle

Analytics 앱 생성에 사용할 수 있는 템플릿 번들. `Metadata` 타입을 extends.

---

### WaveXmd

Analytics XMD (Extended Metadata) — 데이터셋 필드의 시각적 표현 설정. `Metadata` 타입을 extends.

---

### WaveAnalyticAssetCollection

Analytics 자산 컬렉션. `Metadata` 타입을 extends.

---

### WaveComponent

Analytics 컴포넌트. `MetadataWithContent` 타입을 extends.

---

## Agentforce / GenAI 타입군

### GenAiPlanner

AI 에이전트 플래너. LLM과 상호작용하기 위한 주제(Topic)와 액션(Action) 컨테이너.

---

### GenAiPlannerBundle

에이전트 또는 에이전트 템플릿용 플래너 번들.

---

### GenAiPlugin

AI 에이전트 주제(Agent Topic). 특정 작업과 관련된 액션 카테고리.

---

### GenAiFunction

AI 에이전트 액션.

---

### GenAiPluginInstructionDef

주제 지침 정의.

---

### GenAiPromptTemplate

프롬프트 템플릿 정의. 관련 오브젝트·필드 포함.

---

### GenAiPromptTemplateActv

Salesforce 제공 프롬프트 템플릿 활성화 상태.

---

### AiAuthoringBundle

AI 저작 번들. Agentforce 에이전트의 Agent Script 파일 및 관련 메타데이터 콘텐츠 컨테이너.

**Deploy/Retrieve 한도:** Individual 50, Daily 100/200

---

### AiEvaluationDefinition

에이전트 평가 정의. 주제 메타데이터와 테스트 케이스 세트 포함.

---

### AIScoringModelDefinition

Industries Cloud Einstein 채점 프레임워크용 머신러닝 모델 정보.

---

### AIUsecaseDefinition

머신러닝 유스케이스 정의. 실시간 예측을 위한 Salesforce org 필드 컬렉션.

---

## Einstein Bot 타입군

### Bot

Einstein Bot 구성 정의. 여러 버전을 가질 수 있으며 하나의 버전만 활성화 가능.

---

### BotVersion

특정 Einstein Bot 버전의 설정 (다이얼로그, 변수 포함).

---

### BotBlock

특정 Einstein Bot 블록의 설정.

---

### BotTemplate

특정 Einstein Bot 템플릿의 설정.

---

## Einstein Discovery 타입군

### DiscoveryAIModel

Einstein Discovery에서 사용하는 모델 메타데이터.

---

### DiscoveryGoal

Einstein Discovery 예측 정의(Prediction Definition) 메타데이터.

---

### DiscoveryStory

Einstein Discovery 스토리 메타데이터.

---

## 기타 AI·분석 타입

### AIApplication

Einstein Prediction Builder 등 AI 애플리케이션 인스턴스.

---

### AIApplicationConfig

AI 애플리케이션의 추가 예측 정보. `Metadata` 타입을 extends.

---

### AffinityScoreDefinition

마케팅 목적으로 연락처를 분석·분류하는 어피니티 정보.

---

### AnalyticSnapshot

보고 스냅샷(Reporting Snapshot). 탭 결과 또는 요약 보고서 결과를 커스텀 오브젝트 필드에 저장하고 스케줄 실행.

---

### AnalyticsDashboard / AnalyticsVisualization / AnalyticsWorkspace

Tableau Next 대시보드, 시각화, 작업공간.

**Deploy/Retrieve 한도:** Individual 50/100, Daily 100/200

---

### ConvIntelligenceSignalRule

대화 인텔리전스 신호 규칙. 실시간 텔레포니/키워드 기반 액션 트리거. 조건(서브규칙) 세트와 필터 로직 포함.

---

### Dashboard

Salesforce 대시보드. 커스텀 보고서만 지원.

---

### RecommendationStrategy

추천 전략. 데이터 플로우와 유사한 애플리케이션으로 Next Best Action 추천 배달.

---

### Report

커스텀 리포트. 표준 리포트 미지원.

---

### ReportType

커스텀 리포트 타입. 사용자가 구축·커스터마이즈할 수 있는 리포트 프레임워크.

---

### ServiceAISetupDefinition / ServiceAISetupField

Einstein for Service 기능(Einstein Article Recommendations 등) 설정 및 관련 필드. `Metadata` 타입을 extends.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata API MCP Tool]] — AI 도구로 타입 컨텍스트 조회
- [[Metadata API File-Based 호출]] — Wave/Analytics 배포
- [[2GP — Components: Einstein & Analytics]] — 같은 타입의 2GP 패키징 동작 (Manageability Rules·Editable Properties)

---

## Declarative Metadata 예시

### WaveApplication package.xml 예시

```xml
<!-- package.xml -->
<types>
    <members>SalesAnalytics</members>
    <name>WaveApplication</name>
</types>
<types>
    <members>SalesAnalyticsDashboard</members>
    <name>WaveDashboard</name>
</types>
```

### GenAiPlanner (Agentforce Agent) 검색 예시

```xml
<!-- package.xml -->
<types>
    <members>MyAgent</members>
    <name>GenAiPlanner</name>
</types>
<types>
    <members>MyAgent_SalesSupport</members>
    <name>GenAiPlugin</name>
</types>
<types>
    <members>MyAgent_GetAccountInfo</members>
    <name>GenAiFunction</name>
</types>
```

### Bot 배포 예시

```xml
<!-- package.xml -->
<types>
    <members>MyBot</members>
    <name>Bot</name>
</types>
<types>
    <members>MyBot.v1</members>
    <name>BotVersion</name>
</types>
```
