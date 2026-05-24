---
tags: [DevOps, Packaging, 2GP, ManagedPackage, Flow, Workflow, DecisionMatrix, ExpressionSet, BatchCalcJobDefinition, BatchProcessJobDefinition, BusinessProcessGroup, DecisionTable, FlowCategory, FlowTest, InvocableActionExtension, LearningItemType, LoyaltyProgramSetup, ManageabilityRules, IPProtection, PackagingConsiderations, Components, Automation]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — Components Available in Second-Generation Managed Packages, pp.67–69, 75–76, 132–135, 162–166, 194–200, 213–214, 216, 227–228, 308–313
created: 2026-05-23
aliases: [2GP Flow 패키징, 2GP Workflow 패키징, 2GP Decision Table 패키징, 2GP Expression Set 패키징, 2GP Automation 컴포넌트 Manageability Rules, Flow 2GP, BatchCalcJobDefinition 2GP, BusinessProcessGroup 2GP, DecisionMatrixDefinition 2GP, ExpressionSetDefinition 2GP, LoyaltyProgramSetup 2GP, Workflow 2GP, 2GP 자동화 컴포넌트]
---

# 2GP — Components: Automation

> 2GP Managed Package에서 **자동화(Automation) 관련 컴포넌트**의 패키징 규칙 전수. Flow·Workflow·Decision Table/Matrix·Expression Set·Business Process Group·Batch 처리 등 자동화 도메인 Manageability Rules 4속성, Editable Properties 3카테고리, 패키징 시 고려사항을 컴포넌트별로 정리.

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

## Batch Calc Job Definition (BatchCalcJobDefinition)

> Represents a Data Processing Engine definition. Data Processing Engine은 Salesforce org 내 데이터를 변환하고 결과를 새 레코드나 업데이트된 레코드로 기록하는 데 사용한다.

**Metadata Name:** `BatchCalcJobDefinition`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Entire Data Processing Engine definition |
| Both Package Developer and Subscriber Can Edit | Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | API Name, URL |

### License Requirements

Financial Services Cloud, Manufacturing Cloud, Loyalty Management, Net Zero Cloud, Rebate Management 또는 Data Pipelines 라이선스 필요.

### Documentation

- Salesforce Help: Data Processing Engine

---

## Batch Process Job Definition (BatchProcessJobDefinition)

> Represents the details of a Batch Management job definition. Batch Management로 대량의 표준·커스텀 오브젝트 레코드를 예약된 플로에서 처리한다.

**Metadata Name:** `BatchProcessJobDefinition`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Entire Batch Management job |
| Both Package Developer and Subscriber Can Edit | Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | API Name, URL |

### License Requirements

Loyalty Management, Manufacturing Cloud, Rebate Management 또는 System Administrator Profile.

### Documentation

- Salesforce Help: Batch Management

---

## Business Process Group (BusinessProcessGroup)

> Represents the surveys used to track customers' experiences across different stages in their lifecycle. 고객 라이프사이클의 다양한 단계에서 고객 경험을 추적하는 설문조사를 나타낸다.

**Metadata Name:** `BusinessProcessGroup`
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
| Only Package Developer Can Edit | All Business Process Group fields including Business Process Definition and Business Process Feedback |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Developer Name, Customer Satisfaction Metric |

### Use Case

설문 지표를 기반으로 한 그루핑을 제공한다. 특정 Business Process Group에 대해 다양한 단계를 정의하고, 보고 목적으로 하나 이상의 설문조사의 관련 질문을 연결할 수 있다.

### License Requirements

Feedback Management - Growth 라이선스 필요.

### Considerations When Packaging

Surveys 및 Survey Invitation Rules Flow 타입, 그리고 해당 의존성과 함께 사용할 수 있다.

### Documentation

- Metadata API Developer Guide: BusinessProcessGroup
- Salesforce Help: Track Satisfaction Across a Customer's Lifecycle

---

## Decision Matrix Definition (DecisionMatrixDefinition) — BETA

> Represents a definition of a decision matrix. 입력 값을 매트릭스 행과 매칭하여 해당 행의 출력 값을 반환하는 룩업 테이블.

**Metadata Name:** `DecisionMatrixDefinition`
**Packageable In:** 2GP (BETA), 1GP

> [!warning] 2GP 지원이 Pilot/Beta 서비스입니다. Beta Services Terms at Agreements - Salesforce.com 또는 서면 Unified Pilot Agreement가 적용됩니다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Subscriber Can Delete Component From Org | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Type, GroupKey, SubGroupKey |
| Both Package Developer and Subscriber Can Edit | versions |
| Neither Package Developer or Subscriber Can Edit | None |

### Use Case

Decision Matrix는 expression set 및 다양한 digital procedure에서 호출할 수 있다. JSON 입력을 받아 JSON 출력을 반환한다. 복잡한 규칙을 체계적이고 읽기 쉬운 방식으로 구현하는 데 유용하다.

### Documentation

- Industries Common Resources Developer Guide: Decision Matrix Definition
- Salesforce Help: Decision Matrices
- Salesforce Help: Decision Matrix Migration Considerations

---

## Decision Matrix Definition Version (DecisionMatrixDefinitionVersion) — BETA

> Represents a definition of a decision matrix version.

**Metadata Name:** `DecisionMatrixDefinitionVersion`
**Packageable In:** 2GP (BETA), 1GP

> [!warning] 2GP 지원이 Pilot/Beta 서비스입니다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Subscriber Can Delete Component From Org | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Package Developer Can Remove Component From Package | **Yes** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | columns |
| Neither Package Developer or Subscriber Can Edit | None |

### Post Install Steps

Decision Matrix Version 마이그레이션 후에는 활성 버전에 행 데이터를 수동으로 업로드해야 한다. 행 데이터는 마이그레이션 과정에서 자동으로 이전되지 않는다.

### Relationship to Other Components

`DecisionMatrixDefinitionVersion`은 `DecisionMatrixDefinition`의 자식이며, 부모 없이는 존재할 수 없다.

### Documentation

- Industries Common Resources Developer Guide: Decision Matrix Definition

---

## Decision Table (DecisionTable)

> Represents the information about a decision table. 비즈니스 규칙을 읽고 Salesforce org 레코드나 지정된 값에 대한 결과를 결정한다.

**Metadata Name:** `DecisionTable`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Decision Table |
| Both Package Developer and Subscriber Can Edit | Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | API Name, URL |

### License Requirements

Loyalty Management 또는 Rebate Management 라이선스 필요.

### Documentation

- Salesforce Help: Decision Tables

---

## Decision Table Dataset Link (DecisionTableDatasetLink)

> Represents the information about a dataset link associated with a decision table. Decision Table의 입력 필드와 다양한 표준·커스텀 오브젝트의 필드를 매핑할 수 있다.

**Metadata Name:** `DecisionTableDatasetLink`
**Packageable In:** 2GP only

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Dataset Link record |
| Both Package Developer and Subscriber Can Edit | Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | API Name, URL |

### License Requirements

Loyalty Management 또는 Rebate Management 라이선스 필요.

### Documentation

- Salesforce Help: Add Dataset Links to a Decision Table

---

## Expression Set Definition (ExpressionSetDefinition) — BETA

> Represents an expression set definition.

**Metadata Name:** `ExpressionSetDefinition`
**Packageable In:** 2GP (BETA), 1GP

> [!warning] 2GP 지원이 Pilot/Beta 서비스입니다. Beta Services Terms at Agreements - Salesforce.com 또는 서면 Unified Pilot Agreement가 적용됩니다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** — 단, 활성 버전이 **없을 때**만 |
| Subscriber Can Delete Component From Org | **Yes** — 단, 활성 버전이 **없을 때**만 |
| Package Developer Can Remove Component From Package | **Yes** — 단, 활성 버전이 **없을 때**만 |
| Component Has IP Protection | N/A (명시되지 않음) |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | versions |
| Neither Package Developer or Subscriber Can Edit | None |

### Relationship to Other Components

이 컴포넌트를 사용하려면 decision matrix, decision table, object field alias, subexpression 등의 expression set version 의존성이 target org에 있어야 한다.

### Documentation

- Industries Common Resources Developer Guide: Expression Set Definition
- Salesforce Help: Expression Set Migration Considerations

---

## Expression Set Definition Version (ExpressionSetDefinitionVersion) — BETA

> Represents a definition of an expression set version.

**Metadata Name:** `ExpressionSetDefinitionVersion`
**Packageable In:** 2GP (BETA), 1GP

> [!warning] 2GP 지원이 Pilot/Beta 서비스입니다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Subscriber Can Delete Component From Org | **Yes** — 단, 컴포넌트가 **비활성** 상태일 때만 |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | variables, steps |
| Neither Package Developer or Subscriber Can Edit | None |

### Relationship to Other Components

이 컴포넌트는 해당 `ExpressionSetDefinitionVersion`이 속한 `ExpressionSetDefinition`이 target org에 있을 때만 사용할 수 있다.

### Documentation

- Industries Common Resources Developer Guide: Expression Set Definition Version

---

## Expression Set Object Alias (ExpressionSetObjectAlias)

> Represents information about the alias of the source object that's used in an expression set. Expression set에서 오브젝트 필드를 변수로 사용할 수 있도록 하는 별칭.

**Metadata Name:** `ExpressionSetObjectAlias`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | N/A (명시되지 않음) |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | mappings.sourceFieldName, mappings.fieldAlias |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | objectApiName, usageType, dataType |

### Use Case

Expression set object alias는 expression set에서 오브젝트 필드를 변수로 사용할 수 있게 한다. Alias는 기저의 소스 오브젝트 필드에 대한 관련성 있고 사용자 친화적인 이름이다. 필드 alias는 오브젝트 alias 아래에 그룹화된다.

### Documentation

- Industries Common Resources Developer Guide: ExpressionSetObjectAlias
- Salesforce Help: Object Variables in Expression Sets

---

## Expression Set Message Token (ExpressionSetMessageToken)

> Represents a token that's used in an explainability message template. 토큰은 사용되는 expression set version 리소스로 대체될 수 있다. API version 59.0 이후 사용 가능.

**Metadata Name:** `ExpressionSetMessageToken`
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
| Both Package Developer and Subscriber Can Edit | Master Label, Developer Name, Description |
| Neither Package Developer or Subscriber Can Edit | None |

### Documentation

- Industries Common Resources Developer Guide: ExpressionSetMessageToken
- Salesforce Help: Create Expression Set Message Tokens

---

## Flow

> Represents the metadata associated with a flow. Flow로 데이터베이스에서 레코드를 조회·업데이트하는 사용자 탐색 애플리케이션을 만들거나, 비즈니스 프로세스를 자동으로 반복 실행할 수 있다.

**Metadata Name:** `Flow`
**Packageable In:** 2GP only

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** — 2GP 패키지에서만 지원 |
| Component Has IP Protection | **Yes**, except a flow that is a template or overridable |

> 개발자가 이 컴포넌트를 패키지에서 제거하면, 컴포넌트는 구독자 org에 계속 남는다. 구독자 org의 어드민이 원하면 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Entire flow |
| Both Package Developer and Subscriber Can Edit | Flow Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | Flow API Name, URL |

### Considerations When Packaging

- 패키지 또는 패키지 버전 업로드 시 **활성 플로 버전**이 포함된다. 활성 버전이 없으면 최신 버전이 패키징된다.
- 다른 플로 버전으로 패키지를 업데이트하려면: 해당 버전을 활성화하고 패키지를 다시 업로드한다. 또는 모든 버전을 비활성화하고 배포할 최신 버전을 확인한 후 패키지를 업로드한다.
- 패키징 org에서는 released 또는 beta 1GP 관리형 패키지에 업로드한 후에는 플로를 삭제할 수 없다. Managed Component Deletion 권한, 가장 최근에 패키징된 버전이 아닌 경우, 활성 상태가 아닌 경우, 유일한 버전이 아닌 경우에만 플로 버전 삭제 가능.
- 설치된 패키지에서 플로를 삭제할 수 없다. 패키징된 플로를 org에서 제거하려면 비활성화 후 패키지를 언인스톨해야 한다.
- 플로는 패키지 패치에 포함할 수 없다.
- 패키지에서 활성 플로는 설치 후에도 활성 상태다. 대상 org의 이전 활성 버전은 새로 설치된 버전으로 대체되어 비활성화된다. 진행 중인 플로 실행은 이전 버전 기준으로 중단 없이 계속 실행된다.
- 패키지 버전 하나당 플로 하나에 플로 버전 하나만 포함할 수 있다.
- Flow Builder는 관리형 패키지에서 설치된 플로를 열 수 없다. 단, 플로가 template이거나 overridable인 경우는 예외다.
- 다음 요소를 사용하는 플로에서 참조하는 packageable 컴포넌트는 자동으로 패키지에 포함되지 않으므로 수동으로 추가해야 한다: Post to Chatter, Send Email, Submit for Approval.
- 플로가 CSP Trusted Site에 의존하는 Lightning 컴포넌트를 참조하면 해당 trusted site는 패키지에 자동으로 포함되지 않는다.

### Relationship to Other Components

1GP 관리형 패키지에서 플로를 패키징하려면 관련 Flow Definition 컴포넌트가 필요하다.

### Documentation

- Metadata API Developer Guide: Flow
- Salesforce Help: Packaging Considerations for Flows
- Salesforce Help: Considerations for Deploying Flows with Packages

---

## Flow Category (FlowCategory)

> Represents a list of flows that are grouped by category. Flow 기반 자동화 프로세스를 재사용하기 위해 플로를 카테고리로 그룹화하고, 하나 이상의 플로 카테고리를 Lightning Bolt Solution에 추가할 수 있다.

**Metadata Name:** `FlowCategory`
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
| Only Package Developer Can Edit | label, description |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### License Requirements

Customize Application 사용자 권한, View Setup and Configuration 사용자 권한 필요.

### Relationship to Other Components

FlowCategory는 Lightning Bolt Solution의 일부로만 사용할 수 있다.

### Documentation

- Salesforce Help: Add Flows to a Lightning Bolt Solution
- Salesforce Help: Package and Distribute a Lightning Bolt Solution

---

## Flow Definition (FlowDefinition) — 1GP Only

> Represents the flow definition's description and active flow version number. 1GP 관리형 패키지에서 플로를 패키징할 때 필요한 컴포넌트.

**Metadata Name:** `FlowDefinition`
**Packageable In:** 1GP only (2GP 미지원)

> [!note] Flow Definition은 1GP 전용 컴포넌트다. 2GP에서는 Flow 컴포넌트만 사용한다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | Active Version Number, Description, Master Label |
| Neither Package Developer or Subscriber Can Edit | None |

### Relationship to Other Components

1GP 관리형 패키지에서 관련 Flow 컴포넌트가 필요하다.

### Documentation

- Metadata API Developer Guide: Flow Definition

---

## Flow Test (FlowTest)

> Represents the metadata associated with a flow test. Record-triggered 플로를 활성화하기 전에 테스트하여 예상 결과를 검증하고 런타임 실패를 확인한다.

**Metadata Name:** `FlowTest`
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
| Only Package Developer Can Edit | All properties |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | API Name |

### Relationship to Other Components

1GP 관리형 패키지에서 관련 Flow 컴포넌트가 필요하다.

### Documentation

- Metadata API Developer Guide: Flow Test
- Salesforce Help: Testing Your Flow

---

## Invocable Action Extension (InvocableActionExtension)

> Represents extended metadata for Apex classes that are used as invocable actions or data types. 개발자가 커스텀 코드 없이 액션의 입력 표현 방법을 지정할 수 있도록 한다.

**Metadata Name:** `InvocableActionExtension`
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
| Only Package Developer Can Edit | All properties |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

패키지에 포함할 수 있는 최대 파일 수는 10,000개다. Invocable Action Extension은 확장된 각 Apex 클래스마다 5개의 추가 확장 파일을 추가하므로 파일 카운트에 큰 영향을 줄 수 있다. 또한 각 확장 파일은 패키지 버전 생성 및 설치 시간을 증가시킨다. 파일 수 초과 오류가 발생하거나 설치가 너무 오래 걸리면 패키지를 의존성 패키지 세트로 분리하는 것을 고려한다.

### Relationship to Other Components

이 컴포넌트는 Apex Invocable Action과 쌍을 이룬다.

### Documentation

- Metadata API Developer Guide: InvocableActionExtension

---

## Learning Item Type (LearningItemType)

> Represents a custom exercise type that an Enablement user takes in an Enablement program in the Guidance Center. 커스텀 exercise type을 만들고 Enablement program에서 사용한다.

**Metadata Name:** `LearningItemType`
**Packageable In:** 2GP only

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
| Only Package Developer Can Edit | All but DeveloperName |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | DeveloperName |

### License Requirements

Enablement add-on 라이선스 및 Enablement 권한 세트 라이선스 필요. 커스텀 exercise는 Partner Enablement 프로그램과 호환되지 않는다.

### Relationship to Other Components

Learning Item Type 컴포넌트는 대응되는 Enablement Program Task Subcategory 컴포넌트가 필요하다. 두 컴포넌트 모두 Enablement Program Definition 컴포넌트와 함께 패키징해야 한다.

### Documentation

- Metadata API Developer Guide: LearningItemType
- Salesforce Help: Sales Programs and Partner Tracks with Enablement

---

## Loyalty Program Setup (LoyaltyProgramSetup)

> Represents the configuration of a loyalty program process including its parameters and rules. 새 거래 일지가 처리되는 방식을 결정하는 프로그램 프로세스 설정.

**Metadata Name:** `LoyaltyProgramSetup`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **Yes**, except templates |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Loyalty Program Process records |
| Both Package Developer and Subscriber Can Edit | Label, Description, Status |
| Neither Package Developer or Subscriber Can Edit | API Name, URL |

### Use Case

Promotion setup으로 loyalty program manager가 loyalty program process를 만들 수 있게 한다.

### License Requirements

Loyalty Management 권한 세트 라이선스 필요.

### Documentation

- Salesforce Help: Create Processes with Promotion Setup

---

## Workflow Alert (WorkflowAlert)

> WorkflowAlert represents an email alert associated with a workflow rule.

**Metadata Name:** `Workflow`
**Packageable In:** 2GP only

> [!warning] 새 패키지 또는 패키지 버전을 만들 때는 Workflow 컴포넌트 대신 **Flow 컴포넌트를 사용**하라. 기존 관리형 패키지에 Workflow 컴포넌트가 포함되어 있다면 Flow로 마이그레이션 계획을 수립하라.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** — protected·non-protected 컴포넌트 모두 제거 가능 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | Additional Emails, Email Template, From Email Address, Recipients |
| Neither Package Developer or Subscriber Can Edit | Description |

### Considerations When Packaging

- Salesforce는 public group, partner user, 또는 role 수신자를 가진 workflow alert 업로드를 막는다. 업로드 전에 수신자를 user로 변경한다. 설치 시 Salesforce는 해당 user를 패키지를 설치하는 user로 대체하며, installer가 커스터마이즈할 수 있다.
- Workflow rule 및 관련 workflow action을 패키징할 수 있지만, **time-based trigger는 패키지에 포함되지 않는다**. installer에게 필수적인 time-based trigger를 설정하도록 알려야 한다.
- org-wide 주소에 대한 참조(예: workflow email alert의 From 이메일 주소)는 설치 시 Current User로 재설정된다.
- 이 컴포넌트는 protected로 표시할 수 있다.

### Documentation

- First-Generation Managed Packaging Developer Guide: Protected Components

---

## Workflow Field Update (WorkflowFieldUpdate)

> WorkflowFieldUpdate represents a workflow field update.

**Metadata Name:** `Workflow`
**Packageable In:** 2GP, 1GP

> [!warning] 새 패키지 또는 패키지 버전을 만들 때는 **Flow 컴포넌트를 사용**하라.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** — 1GP·2GP 모두 지원. protected·non-protected 모두 제거 가능 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Field Value, Formula Value |
| Both Package Developer and Subscriber Can Edit | Lookup |
| Neither Package Developer or Subscriber Can Edit | Name |

### Considerations When Packaging

- Owner 필드를 queue로 변경하는 workflow field update 업로드를 Salesforce가 막는다. 설치 전 user로 변경해야 한다.
- Workflow rule, field update, outbound message가 표준 또는 관리형 설치 오브젝트의 record type을 참조하면 업로드가 막힌다.
- time-based trigger는 패키지에 포함되지 않는다.
- 이 컴포넌트는 protected로 표시할 수 있다.

---

## Workflow Knowledge Publish (WorkflowKnowledgePublish) — 1GP Only

> WorkflowKnowledgePublish represents Salesforce Knowledge article publishing actions and information.

**Metadata Name:** `WorkflowKnowledgePublish` (또는 `WorkflowKnowledgePublish`)
**Packageable In:** 1GP only (2GP 미지원)

> [!note] 이 컴포넌트는 1GP 전용이며, Lightning Knowledge가 활성화된 org에는 설치할 수 없다.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes**, if protected |
| Component Has IP Protection | **No** |

### Considerations When Packaging

- Salesforce Classic org에서 Knowledge가 활성화된 org에만 설치 가능하다.
- Lightning Knowledge가 활성화된 org에 설치 시도 시 오류: "When Lightning Knowledge is enabled, you can't add an article type"

---

## Workflow Outbound Message (WorkflowOutboundMessage)

> WorkflowOutboundMessage represents an outbound message associated with a workflow rule.

**Metadata Name:** `Workflow`
**Packageable In:** 2GP, 1GP

> [!warning] 새 패키지 또는 패키지 버전을 만들 때는 **Flow 컴포넌트를 사용**하라.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** — 1GP·2GP 모두 지원. protected·non-protected 모두 제거 가능 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Endpoint URL, Fields to Send, Send Session ID |
| Both Package Developer and Subscriber Can Edit | User to Send As |
| Neither Package Developer or Subscriber Can Edit | Name |

### Considerations When Packaging

Workflow rule, field update, outbound message가 표준 또는 관리형 설치 오브젝트의 record type을 참조하면 업로드가 막힌다. 이 컴포넌트는 protected로 표시할 수 있다.

---

## Workflow Rule (WorkflowRule)

> This metadata type represents a workflow rule.

**Metadata Name:** `Workflow`
**Packageable In:** 2GP, 1GP

> [!warning] 새 패키지 또는 패키지 버전을 만들 때는 **Flow 컴포넌트를 사용**하라.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** — 1GP·2GP 모두 지원 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Evaluation Criteria, Rule Criteria |
| Both Package Developer and Subscriber Can Edit | Active |
| Neither Package Developer or Subscriber Can Edit | Rule Name |

### Considerations When Packaging

- Workflow rule, field update, outbound message가 표준 또는 관리형 설치 오브젝트의 record type을 참조하면 업로드가 막힌다.
- 개발자는 언제든지 workflow action을 workflow rule과 연결하거나 분리할 수 있다. 분리를 포함한 이러한 변경 사항은 설치 시 구독자 org에 반영된다. 관리형 패키지에서 구독자는 개발자가 연결한 workflow action을 workflow rule에서 분리할 수 없다.
- 설치 또는 업그레이드된 패키지에서 새로 만든 모든 workflow rule은 업로드된 패키지와 동일한 활성화 상태를 가진다.
- **Time trigger가 있는 workflow rule은 패키징할 수 없다.**

---

## Workflow Task (WorkflowTask)

> This metadata type references an assigned workflow task.

**Metadata Name:** `Workflow`
**Packageable In:** 2GP, 1GP

> [!warning] 새 패키지 또는 패키지 버전을 만들 때는 **Flow 컴포넌트를 사용**하라.

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** — 1GP·2GP 모두 지원. protected·non-protected 모두 제거 가능 |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | Assign To, Comments, Due Date, Priority, Record Type, Status |
| Neither Package Developer or Subscriber Can Edit | Subject |

### Considerations When Packaging

- Role에 할당된 workflow task 업로드를 Salesforce가 막는다. 업로드 전 Assigned To 필드를 user로 변경해야 한다. 설치 시 Salesforce는 해당 user를 패키지를 설치하는 user로 대체하며, installer가 커스터마이즈할 수 있다.
- 이 컴포넌트는 protected로 표시할 수 있다.

---

## 요청 목록에 포함되었으나 PDF에 상세 섹션 없는 컴포넌트

다음 컴포넌트들은 2GP Supported Components 요약 목록에 등장하지만, `pkg2_dev.pdf` 내에 Manageability Rules 상세 섹션이 존재하지 않는다. Metadata Coverage Report 또는 Salesforce 공식 문서에서 최신 정보를 확인한다.

| 컴포넌트 | 비고 |
|---|---|
| Action Plan Template | **1GP 전용** (PDF 명시). 2GP 미지원. |
| Approval Process | Summary 목록에 등장, 상세 섹션 없음 |
| Assignment Rules | Summary 목록에 등장, 상세 섹션 없음 |
| Auto Response Rules | Summary 목록에 등장, 상세 섹션 없음 |
| Email Template (Classic) | 2GP+1GP 지원, 상세 섹션 없음 (별도 분류) |
| Email Template (Lightning) | **1GP 전용** (PDF 명시). 2GP 미지원. |
| Entitlement Process | 관련 `EntitlementTemplate`은 **1GP 전용** |
| Escalation Rules | Summary 목록에 등장, 상세 섹션 없음 |
| Matching Rule | Summary 목록에 등장, 상세 섹션 없음 |
| Milestone Type | Summary 목록에 등장, 상세 섹션 없음 |
| Queue | Summary 목록에 등장, 상세 섹션 없음 |
| Service Process | Summary 목록에 등장, 상세 섹션 없음 |

---

## 전체 비교표

| 컴포넌트 | Metadata Name | Packageable In | Updated on Upgrade | Sub Delete | Dev Remove | IP Protection |
|---|---|---|---|---|---|---|
| Batch Calc Job Definition | `BatchCalcJobDefinition` | 2GP+1GP | Yes | No | **No** | **Yes** (templates 제외) |
| Batch Process Job Definition | `BatchProcessJobDefinition` | 2GP+1GP | Yes | No | **No** | **Yes** (templates 제외) |
| Business Process Group | `BusinessProcessGroup` | 2GP+1GP | Yes | No | **No** | No |
| Decision Matrix Definition | `DecisionMatrixDefinition` | 2GP+1GP (BETA) | Yes (inactive only) | Yes (inactive only) | Yes | No |
| Decision Matrix Definition Version | `DecisionMatrixDefinitionVersion` | 2GP+1GP (BETA) | Yes (inactive only) | Yes (inactive only) | Yes | No |
| Decision Table | `DecisionTable` | 2GP+1GP | Yes | No | **No** | **Yes** (templates 제외) |
| Decision Table Dataset Link | `DecisionTableDatasetLink` | **2GP only** | Yes | No | **No** | **Yes** (templates 제외) |
| Expression Set Definition | `ExpressionSetDefinition` | 2GP+1GP (BETA) | Yes (no active ver) | Yes (no active ver) | Yes (no active ver) | N/A |
| Expression Set Definition Version | `ExpressionSetDefinitionVersion` | 2GP+1GP (BETA) | Yes (inactive only) | Yes (inactive only) | **No** | No |
| Expression Set Object Alias | `ExpressionSetObjectAlias` | 2GP+1GP | Yes | No | **No** | N/A |
| Expression Set Message Token | `ExpressionSetMessageToken` | 2GP+1GP | **No** | Yes | Yes | No |
| Flow | `Flow` | **2GP only** | Yes | Yes | Yes | **Yes** (template/overridable 제외) |
| Flow Category | `FlowCategory` | **2GP only** | Yes | No | **No** | No |
| Flow Definition | `FlowDefinition` | **1GP only** | Yes | No | **No** | Yes |
| Flow Test | `FlowTest` | 2GP+1GP | Yes | No | **No** | No |
| Invocable Action Extension | `InvocableActionExtension` | **2GP only** | Yes | No | **No** | No |
| Learning Item Type | `LearningItemType` | **2GP only** | Yes | No | Yes | No |
| Loyalty Program Setup | `LoyaltyProgramSetup` | 2GP+1GP | Yes | No | **No** | **Yes** (templates 제외) |
| Workflow Alert | `Workflow` | **2GP only** | Yes | No | Yes | No |
| Workflow Field Update | `Workflow` | 2GP+1GP | Yes | No | Yes | No |
| Workflow Knowledge Publish | `WorkflowKnowledgePublish` | **1GP only** | Yes | No | Yes (if protected) | No |
| Workflow Outbound Message | `Workflow` | 2GP+1GP | Yes | No | Yes | No |
| Workflow Rule | `Workflow` | 2GP+1GP | Yes | No | Yes | No |
| Workflow Task | `Workflow` | 2GP+1GP | Yes | No | Yes | No |

**주요 패턴:**
- **Flow**: Automation 도메인에서 가장 강력한 컴포넌트. 2GP only이며 IP Protection Yes. 새 패키지에서는 Workflow 대신 Flow를 사용할 것을 Salesforce가 공식 권장.
- **Workflow 5종**: 모두 "신규 패키지에서 Flow 사용 권장" 경고가 있음. Workflow Alert만 2GP only이고 나머지는 2GP+1GP.
- **Decision Table/Matrix/Expression Set**: Loyalty 및 Industries 도메인의 비즈니스 규칙 엔진. Decision Matrix/Expression Set의 2GP 지원은 BETA.
- **Batch Calc/Process Job**: IP Protection이 있어 Data Processing Engine 정의가 구독자에게 숨겨짐.
- **LearningItemType**: 2GP only, Developer Can Remove Yes — Enablement 프로그램 커스텀 exercise 유형.

```xml
<!-- 구조 예시 — Flow Metadata XML (2GP 관리형 패키지용) -->
<!-- MyAutoFlow.flow-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Flow xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>67.0</apiVersion>
    <label>My Automation Flow</label>
    <processType>AutoLaunchedFlow</processType>
    <status>Active</status>
    <!-- 관리형 패키지 설치 후 Flow Label·Description·Status는 양측 모두 수정 가능 -->
    <!-- Flow API Name은 잠겨있어 수정 불가 -->
</Flow>
```

---

## 관련 노트

- [[Metadata Types — Automation]] — MetadataAPI 관점의 동일 자동화 컴포넌트 필드 정의 (Flow, Workflow, ApprovalProcess 등)
- [[2GP — Components: Apex & Code]] — 동일 시리즈: Apex Class·Trigger·LWC·Aura·Visualforce 패키징 규칙
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로·Manageability Rules 4속성 개요·Supported Components 전체 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — Manageability Rules 개념 설명·Package Ancestry·IP Protection 원리
- [[2GP — Components: Einstein & Analytics]] — Einstein·Analytics·Agentforce·Bot·Report/Dashboard 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Integration & Platform]] — NamedCredential·FeatureParameter·ExternalDataSource·EventRelayConfig·PlatformCachePartition 등 통합·플랫폼 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Objects & Fields]] — AssessmentQuestion·BriefcaseDefinition·CustomObject·CustomField·CustomLabels·GlobalValueSet·Folder·FieldSet 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Security & Access]] — AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·ExternalAuthIdentityProvider·ExternalCredential·PermissionSet·PermissionSetGroup 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
