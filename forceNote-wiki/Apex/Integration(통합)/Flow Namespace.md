---
tags: [apex, flow, flow-interview, namespace, integration, reference]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, Summer '26, p.2880~2884)
created: 2026-05-19
aliases: [Flow Namespace, Flow.Interview, Flow Interview 클래스, Apex에서 Flow 실행, createInterview, start interview, getVariableValue]
---

# Flow Namespace

> `Flow` 네임스페이스는 Visualforce 컨트롤러 또는 비동기 Apex 등에서 Flow에 고급 접근을 제공하는 클래스를 담는다. 핵심 클래스는 `Flow.Interview` 하나다.

---

## 네임스페이스 개요

`Flow` 네임스페이스에는 클래스가 하나뿐이다.

| 클래스 | 설명 |
|---|---|
| `Flow.Interview` | Apex에서 Flow 인터뷰(실행 인스턴스)를 생성하고 시작하며, 입출력 변수를 주고받는다 |

> 이 네임스페이스는 **Apex → Flow** 방향이다. 반대 방향(Flow → Apex)은 `@InvocableMethod`를 사용한다.

---

## Flow.Interview 클래스

`Flow.Interview` 클래스는 Apex 코드에서 Flow의 고급 컨트롤러 접근과 Flow 시작 능력을 제공한다.

### 인스턴스 생성 방법

Interview 객체를 생성하는 방법은 두 가지다.

**방법 1 — 정적 직접 생성 (권장)**

```apex
// 네임스페이스 없는 Flow
Flow.Interview.flowName myFlow = new Flow.Interview.flowName(inputs);

// 네임스페이스 있는 관리 패키지 Flow
Flow.Interview.namespace.flowName myFlow =
    new Flow.Interview.namespace.flowName(inputs);
```

**방법 2 — createInterview() 동적 생성**

```apex
// 런타임에 Flow 이름을 결정해야 할 때 사용
Flow.Interview myFlow = Flow.Interview.createInterview(flowName, inputs);
```

> **Note:** `createInterview()`를 사용하면 두 가지 단점이 있다.
> - 이 방식을 사용하는 클래스를 패키지에 포함할 경우, 연관된 Flow를 수동으로 추가해야 한다.
> - Flow를 삭제해도 Salesforce가 `createInterview()` 참조를 확인하지 않는다.

---

### Interview Methods (인스턴스 메서드)

#### createInterview(namespace, flowName, inputVariables)

네임스페이스가 있는 Flow의 인터뷰를 생성한다.

```apex
public static Flow.Interview createInterview(
    String namespace,
    String flowName,
    Map<String, ANY> inputVariables
)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `namespace` | String | Flow의 네임스페이스 |
| `flowName` | String | Flow의 API 이름 |
| `inputVariables` | Map<String, ANY> | Flow 입력 변수의 초기값 |

반환 타입: `Flow.Interview`

#### createInterview(flowName, inputVariables)

로컬 Flow의 인터뷰를 생성한다.

```apex
public static Flow.Interview createInterview(
    String flowName,
    Map<String, Object> inputVariables
)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `flowName` | String | Flow의 API 이름 |
| `inputVariables` | Map<String, Object> | Flow 입력 변수의 초기값 |

반환 타입: `Flow.Interview`

Flow가 현재 org에 존재하지 않으면 `TypeException`이 발생한다.

**출력 변수 접근 방식:**

```apex
// 특정 Flow 타입으로 캐스팅된 경우 — 변수명으로 직접 접근
system.debug('출력 변수: ' + myFlow.varName);

// Flow.Interview 타입인 경우 — getVariableValue() 사용
system.debug('출력 변수: ' + myFlow.getVariableValue('varName'));
```

#### getVariableValue(variableName)

지정한 Flow 변수의 값을 반환한다. 변수는 Visualforce 페이지에 임베드된 Flow나 서브플로우 요소가 호출하는 별도 Flow에 있을 수 있다.

```apex
public Object getVariableValue(String variableName)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `variableName` | String | Flow 변수의 고유 이름 |

반환 타입: `Object`

인터뷰가 실행 중인 Flow에서 변수를 찾을 수 없으면 `null`을 반환한다. 이 메서드는 컴파일 타임이 아닌 런타임에만 변수 존재 여부를 확인한다.

#### start()

Autolaunched Flow 또는 User Provisioning Flow의 인스턴스(인터뷰)를 시작한다.

```apex
public Void start()
```

반환 타입: `Void`

이 메서드는 아래 타입의 Flow에만 사용할 수 있다.
- Autolaunched Flow
- User Provisioning Flow

---

## 코드 예제

### 예제 1 — 정적 방식 (로컬 Flow)

```apex
// 구조 예시 — 실제 Flow API 이름(Calculate_discounts)으로 교체 필요
Map<String, Object> inputs = new Map<String, Object>();
inputs.put('AccountID', myAccount);
inputs.put('OpportunityID', myOppty);

Flow.Interview.Calculate_discounts myFlow =
    new Flow.Interview.Calculate_discounts(inputs);
myFlow.start();
```

### 예제 2 — 동적 방식 (로컬 Flow)

```apex
public void callFlow(String flowName, Map<String, Object> inputs) {
    Flow.Interview myFlow = Flow.Interview.createInterview(flowName, inputs);
    myFlow.start();
}
```

### 예제 3 — 정적 방식 (관리 패키지 Flow)

```apex
Map<String, Object> inputs = new Map<String, Object>();
inputs.put('AccountID', myAccount);
inputs.put('OpportunityID', myOppty);

Flow.Interview.myNamespace.Calculate_discounts myFlow =
    new Flow.Interview.myNamespace.Calculate_discounts(inputs);
myFlow.start();
```

### 예제 4 — 동적 방식 (관리 패키지 Flow)

```apex
public void callFlow(String namespace, String flowName, Map<String, Object> inputs) {
    Flow.Interview myFlow = Flow.Interview.createInterview(namespace, flowName, inputs);
    myFlow.start();
}
```

### 예제 5 — 출력 변수 읽기 (getVariableValue)

```apex
public class SampleController {
    // Flow 인스턴스 보유
    public Flow.Interview.Flow_Template_Gallery myFlow {get; set;}

    public String getBreadCrumb() {
        String aBreadCrumb;
        if (myFlow == null) { return 'Home'; }
        else aBreadCrumb = (String) myFlow.getVariableValue('vaBreadCrumb');

        return (aBreadCrumb == null ? 'Home' : aBreadCrumb);
    }
}
```

---

## 언제 쓰나 — @InvocableMethod vs Flow.Interview

| 방향 | API | 설명 |
|---|---|---|
| Apex → Flow | `Flow.Interview` | Apex 코드가 Flow를 능동적으로 실행 |
| Flow → Apex | `@InvocableMethod` | Flow가 Apex 액션을 호출 |

`Flow.Interview`가 필요한 상황:
- 트리거에서 조건부로 Flow 실행
- 런타임에 Flow 이름을 동적으로 결정
- Flow 실행 결과(출력 변수)를 Apex에서 후처리

---

## 주의사항

| 항목 | 내용 |
|---|---|
| 지원 Flow 타입 | `start()`는 **Autolaunched Flow**와 **User Provisioning Flow**만 지원. Screen Flow 호출 불가 |
| Governor Limits | SOQL·DML 한도가 Flow 실행 중 Apex 트랜잭션과 공유됨 |
| 정적 vs 동적 | 정적 방식이 패키지 배포 시 더 안전 (컴파일 타임 참조 체크 가능) |
| 공유 규칙 | API v62.0 이상에서 `with sharing` 클래스가 Flow 호출 시 공유 규칙 적용됨 |
| Flow 버전 | Flow 사용자가 Autolaunched Flow 호출 시 활성 버전 실행. 활성 버전 없으면 최신 버전. Flow 관리자가 호출 시 항상 최신 버전 실행 |
| createInterview 한계 | Flow 삭제 여부를 컴파일 타임에 확인하지 않음. TypeException은 런타임에만 발생 |

---

## 관련 노트

- [[Flow Interview API]] — 실전 패턴 중심 사용 가이드 (트리거 호출, 동적 방식 상세)
- [[@InvocableMethod 패턴]] — 반대 방향: Flow에서 Apex를 호출하는 패턴
- [[Flowtesting Namespace]] — Flow Builder로 만든 Flow 테스트를 Apex에서 실행
- [[Invocable Namespace]] — Apex에서 Flow Action을 동적으로 호출하는 별도 API
- [[Sfdc_Enablement Namespace]] — Enablement 프로그램이 Flow를 트리거·실행하는 호출자
