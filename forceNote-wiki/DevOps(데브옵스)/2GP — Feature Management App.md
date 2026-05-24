---
tags: [DevOps, Packaging, 2GP, ManagedPackage, FMA, FeatureManagement, FeatureParameters, LMO, ISV, 피처파라미터, 기능관리]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.420-427
created: 2026-05-24
aliases: [FMA, Feature Management App, Feature Parameters, FeatureParameterBoolean, FeatureParameterDate, FeatureParameterInteger, 피처 파라미터, 기능 관리 앱, System.FeatureManagement, featureParameterBoolean-meta.xml, featureParameterInteger-meta.xml, featureParameterDate-meta.xml, LMO subscriber feature, dataFlowDirection, Hide Custom Objects Custom Permissions Subscribers]
---

# 2GP — Feature Management App (기능 관리 앱)

> License Management App(LMA)을 확장하는 Feature Management App(FMA)을 사용해, managed 2GP 패키지의 기능을 구독자별로 제어하는 Feature Parameters 설정·운영·Apex 코드 연동 방법을 전수 정리한다.

---

## 1. Manage Features in Second-Generation Managed Packages

### 1-1. Feature Management App(FMA) 개요

AppSalesforce에서 패키지를 AppExchange에 배포하기 전 일부 기능을 어둡게(dark launch) 할 때가 있다. 또는 구독자별로 특정 기능을 제한하거나 활성화하고 싶을 때도 있다.

**Feature Parameters**를 사용하면 이 기능을 패키지에 넣을 수 있다.

- Feature parameters를 사용하면 패키지 기능에 대한 **구독자별 접근을 LMO에서 제어**할 수 있다.
- Feature Parameter 값은 **LMO에서 구독자 org로 전달**된다.
- 구독자 Org에서는 Apex 코드로 Feature Parameter 값을 읽어 기능을 활성화/비활성화한다.

**FMA를 사용하는 주요 시나리오:**

| 시나리오 | 설명 |
|---|---|
| Dark launch | 패키지 배포 전 일부 기능을 숨기고 준비 완료 후 활성화 |
| Feature gating by subscriber | 특정 구독자에게만 기능 활성화 |
| Trial-to-paid feature unlock | 평가판 기간 중 기능을 제한하고 구매 후 활성화 |
| Feature activation tracking | 구독자 org에서 기능 활성화 날짜 추적 |
| Usage counting | 구독자가 특정 기능(예: invoice)을 사용한 횟수 추적 |

---

## 2. Feature Parameter Metadata Types and Custom Objects

### 2-1. Feature Parameter 타입 3종

Feature parameters는 Metadata API 타입으로 패키지 메타데이터에 포함되고, LMO와 구독자 org에서 Custom Object 레코드로 존재한다.

| Metadata Type | 타입 | 용도 |
|---|---|---|
| **FeatureParameterBoolean** | Boolean | 기능 활성화/비활성화 플래그 |
| **FeatureParameterDate** | Date | 기능 활성화/만료 날짜 |
| **FeatureParameterInteger** | Integer | 숫자 기반 제한값 (예: 최대 사용자 수, invoice 수) |

### 2-2. Feature Parameter Fields (모든 타입 공통)

Feature parameter records에는 다음 3가지 필드가 있다:

| Field Name | Description |
|---|---|
| **dataFlowDirection** | Indicates which direction this feature parameter is transferring data.<br>Each feature parameter value gets transferred in one of two directions:<br>- From your LMO to a subscriber org (`FromLmoToSubscriber`)<br>- From a subscriber org to your LMO (`FromSubscriberToLmo`) |
| **masterLabel** | The label of the feature parameter. Booleans, integers, and dates are all valid values |
| **value** | The value of the feature parameter. Booleans, integers, and dates are all valid values |

> **Note:** feature parameter가 package에 포함되어 released 이후에는 **data flow direction을 변경할 수 없다.**

---

## 3. Set Up Feature Parameters

### 3-1. FMA 설치 및 설정 개요

1. LMO에서 FMA를 설치한다 (Support 케이스 요청 필요).
2. Feature parameters를 정의한다.
3. 패키지에 Feature parameter files를 추가한다.
4. page layout에 Feature parameters 관련 페이지를 조정한다.

### 3-2. Install and Set Up the Feature Management App in Your License Management Org

1. Feature parameters에 접근하려면 먼저 Salesforce 파트너 지원에 **Technology Request** 케이스를 등록해야 한다.
2. FMA가 LMO에 설치되면 LMO default view를 Feature Parameter 기준으로 설정하고 page layout을 추가한다.
3. Feature Parameters 탭을 LMA에서 접근할 수 있도록 설정한다.
4. Update your page layout to add these items:
   - a. Related Lists에서 Feature Parameter Booleans, Feature Parameter Dates, Feature Parameter Integers를 추가한다.
   - b. 각 related list에 다음 컬럼을 추가한다: Data Flow Direction, Feature Parameter Name, Package, Value

---

## 4. Create Feature Parameters for Your Second-Generation Managed Package

### 4-1. Folder Structure (파일 시스템 구조)

Feature parameter files는 패키지의 **Scratch Org project folder**에 저장한다.

```
// 구조 예시 — 실제 동작 코드 아님
force-app/
  └── main/
      └── default/
          └── featureParameters/
              ├── AdvancedPricingEnabled.featureParameterBoolean-meta.xml
              ├── NumberLedgers.featureParameterInteger-meta.xml
              └── ProjectActivationDate.featureParameterDate-meta.xml
```

> **Note:** 각 Feature parameter는 별도의 파일로 저장한다.

### 4-2. File Naming Convention

Feature parameter 파일 이름은 `<name>.<type>-meta.xml` 형식:

| Type | File Naming Format |
|---|---|
| Boolean | `.featureParameterBoolean-meta.xml` |
| Date | `.featureParameterDate-meta.xml` |
| Integer | `.featureParameterInteger-meta.xml` |

`<name>` 부분은 해당 Feature Parameter의 API 이름이다.

### 4-3. Feature Parameter Attributes

| Field Name | Description |
|---|---|
| **dataFlowDirection** | Indicates which direction this feature parameter is transferring data. Each feature parameter value gets transferred in one of two directions: From your LMO to a subscriber org (`FromLmoToSubscriber`) or From a subscriber org to your LMO (`FromSubscriberToLmo`) |
| **masterLabel** | The label of the feature parameter. Booleans, integers, and dates are all valid values |
| **value** | The value of the feature parameter. Booleans, integers, and dates are all valid values |

---

## 5. Feature Parameter XML 예제

### 5-1. Boolean Feature Parameter (AdvancedPricingEnabled)

```xml
<FeatureParameterBoolean xmlns="http://soap.sforce.com/2006/04/metadata">
    <dataFlowDirection>FromSubscriberToLmo</dataFlowDirection>
    <masterLabel>Advanced Pricing Enabled</masterLabel>
    <value>true</value>
</FeatureParameterBoolean>
```

### 5-2. Integer Feature Parameter (NumberLedgers)

```xml
<?xml version="2.0" encoding="UTF-8"?>
<FeatureParameterInteger xmlns="http://soap.sforce.com/2006/04/metadata">
    <dataFlowDirection>FromSubscriberToLmo</dataFlowDirection>
    <masterLabel>Number of Ledgers</masterLabel>
    <value>7</value>
</FeatureParameterInteger>
```

### 5-3. Date Feature Parameter (ProjectActivationDate)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<FeatureParameterDate xmlns="http://soap.sforce.com/2006/04/metadata">
    <dataFlowDirection>FromLmoToSubscriber</dataFlowDirection>
    <masterLabel>Date of Activation of the Project</masterLabel>
    <value>2020-01-25</value>
</FeatureParameterDate>
```

---

## 6. LMO와 구독자 Org 간 Feature Parameter 값 사용

### 6-1. Use LMO-to-Subscriber Feature Parameters to Enable and Disable Features

`dataFlowDirection`이 `FromLmoToSubscriber`인 Feature Parameter는 LMO에서 구독자 org로 값이 전달된다.

이 Feature Parameters는 구독자의 org 내에서만 읽기 전용이다. 이 Feature Parameters를 사용해 기능을 활성화하거나 비활성화한다.

### 6-2. Assign Override Values in Your LMO

구독자의 org에서 Feature parameter 기본값을 override하려면, LMO에서 적절한 junction object 레코드를 업데이트한다.

```
// 구조 예시 — 실제 동작 코드 아님
LMO에서:
1. License record → 해당 subscriber org의 Feature Parameter junction object 레코드 찾기
2. Value 필드를 원하는 값으로 업데이트
3. 저장 (값은 subscriber org에 비동기적으로 전달)
```

### 6-3. Check LMO-to-Subscriber Values in Your Code

구독자 org의 Apex 코드에서 Feature Parameter 값을 참조하는 방법:

```apex
// FeatureManagement API로 Feature Parameter 값 조회
Boolean advancedPricingEnabled = System.FeatureManagement.checkPackageBooleanValue('YourBooleanFeatureParameter');
Integer numberLedgers = System.FeatureManagement.checkPackageIntegerValue('YourIntegerFeatureParameter');
Date projectActivationDate = System.FeatureManagement.checkPackageDateValue('YourDateFeatureParameter');
```

**사용 가능한 System.FeatureManagement 메서드:**

| 메서드 | 파라미터 | 반환 타입 | 설명 |
|---|---|---|---|
| `checkPackageBooleanValue` | `String featureParameterName` | `Boolean` | Boolean Feature Parameter 값 조회 |
| `checkPackageDateValue` | `String featureParameterName` | `Date` | Date Feature Parameter 값 조회 |
| `checkPackageIntegerValue` | `String featureParameterName` | `Integer` | Integer Feature Parameter 값 조회 |
| `setPackageBooleanValue` | `String featureParameterName, Boolean booleanValue` | `void` | LMO에서 Boolean Feature Parameter override 설정 |
| `setPackageDateValue` | `String featureParameterName, Date dateTimeValue` | `void` | LMO에서 Date Feature Parameter override 설정 |
| `setPackageIntegerValue` | `String featureParameterName, Integer integerValue` | `void` | LMO에서 Integer Feature Parameter override 설정 |

> **Note:** `The Value__ field on LMO-to-Subscriber Feature Parameters is editable in your LMO. Don't change it. The subscriber org's value will be of type.`

---

## 7. Custom Objects and Custom Permissions in Subscribers' Orgs

### 7-1. Custom Objects/Permissions 숨기기 (subscriber에서)

패키지를 구성할 때 구독자로부터 일부 Custom Objects 또는 Custom Permissions를 숨길 수 있다. 예를 들어, 특정 구독자에게 적합하지 않은 기능에 대한 select picklist를 숨기려는 경우, custom object와 custom permission을 pilot feature로 숨길 수 있다.

Custom Objects를 숨기는 방법:
- 패키지를 구성할 때 visibility를 `Protected`로 설정한다.
- `CustomObject` Metadata API로 visibility 필드를 `Protected`로 설정 가능.

Custom Permissions를 숨기는 방법:
- Permission Set을 사용해 custom permission의 Visibility를 Protected로 변경한다.
- LMA에서 subscriber에게 custom permission access를 부여한 후 `Protected` visibility로 숨길 수 있다.

### 7-2. Hide Custom Permissions from Subscriber Orgs (Apex)

```apex
// 패키지 내 custom permission 숨기기 (System.FeatureManagement API)
System.FeatureManagement.changeProtection('YourCustomPermissionName', 'Protected');
System.FeatureManagement.changeProtection('YourCustomPermissionName', 'Unprotected');
```

### 7-3. Hide Custom Objects from Subscriber Orgs (Apex)

Custom Objects를 Apex에서 Protected로 변경:

```apex
// 패키지에서 Custom Object 숨기기 (Apex)
System.FeatureManagement.changeProtection('YourCustomObjectName__c', 'Protected');

// Custom Permission 숨기기
System.FeatureManagement.changeProtection('YourCustomPermissionName', 'Protected');
```

released 패키지에서 Custom Objects를 subscriber에게 숨긴 후에는 `visibility`를 `Protected`로 변경할 수 없다. (단, Apex `changeProtection` 메서드 사용 시 예외)

**changeProtection 관련 메서드 전수:**

```apex
// Custom Permission 보호 설정
System.FeatureManagement.changeProtection(
    'YourCustomPermissionName',   // Custom Permission API 이름
    'Protected'                   // 'Protected' 또는 'Unprotected'
);

// Custom Object 보호 설정
System.FeatureManagement.changeProtection(
    'YourCustomObjectName__c',    // Custom Object API 이름
    'Protected'
);

// Released 패키지의 Custom Objects와 Custom Permissions에서 사용:
System.FeatureManagement.changeProtection(
    'YourCustomPermissionName',
    'Unprotected'                 // Unprotected로 다시 노출 가능
);
```

---

## 8. Best Practices for Feature Management

Feature parameters를 사용할 때 권장 모범 사례:

- **Feature Management를 사용하기 전에 먼저 테스트하고 LMO에서 LMO beta 버전을 테스트한다.** subscriber org를 sandbox에서 확인 후 배포한다.
- **LMO에서 Feature Parameter Apex Access triggers를 사용해 feature parameters 값을 직접 조작하지 않는다.** LMO에서 subscriber org에 기능 활성화는 Apex를 통해 제어해야 한다. subscriber org의 Apex 코드로는 `sendSend` triggers를 사용하지 않는다.
- **subscriber org에서 feature parameters를 직접 생성하거나 삭제하지 않는다.** feature parameters는 subscriber org에서 자동으로 생성된다.
- **LMO에서 활성화 metrics 추적을 위해 LMO to subscriber 방향의 feature parameters를 사용한다.** subscriber가 특정 기능을 처음 사용한 날짜를 subscriber-to-LMO 방향의 Date feature parameter로 추적한다.

---

## 9. Considerations for Feature Management

Feature parameters를 사용할 때 주의사항:

| 항목 | 내용 |
|---|---|
| 만료 후 동작 | Feature parameter가 있는 field 또는 records가 삭제된 후에도 subscriber org에서 계속 사용 가능 |
| 삭제 금지 | Feature parameters는 패키지에서 삭제하지 않는다. 비활성화하려면 boolean을 `false`로 설정 |
| 비동기 업데이트 지연 | LMO의 값이 subscriber org에 업데이트되는 데 최대 **24시간** 걸릴 수 있다. subscriber org는 일반적으로 값을 캐시하며, 그 값은 최대 24시간 동안 지속된다 |
| dataFlowDirection 불변 | feature parameter가 패키지에 포함돼 released된 이후에는 data flow direction을 변경할 수 없다 |
| 200개 한도 | 패키지당 최대 **200개** Feature Parameters를 포함할 수 있다 |
| LMO-to-Subscriber 동기화 | LMO에서 subscriber org로 값을 전달할 때 기본 정기 동기화 작업에 의존. 즉각적인 업데이트는 보장되지 않음 |
| Sandbox 동작 | sandbox org에 설치된 패키지는 LMO와 동일하게 Feature Parameter 값을 수신하며, sandbox와 production org는 별개로 처리 |

---

## 관련 노트

- [[2GP — LMA Part 1 Get Started]] — LMA 설치·권한·라이선스 레코드 관리
- [[2GP — LMA Part 2 Troubleshoot]] — LMA 트러블슈팅, 구독자 지원, LMA 이전
- [[2GP — Best Practices]] — 2GP 개발·배포 모범 사례
- [[2GP — Prepare to Distribute]] — AppExchange 등록, LMO 연결, Package 등록 절차
- [[2GP — Components: Integration & Platform]] — FeatureParameterBoolean·Date·Integer Manageability Rules
- [[2GP Managed Package 개념과 1GP 비교]] — managed 2GP 개념·LMO·Partner Business Org
- [[2GP — App Analytics Part 1: Overview & Setup]] — AppExchange App Analytics 개요·CustomInteractions 구현 (IsvPartners.AppAnalytics — LMO·ISV 사용량 데이터)
