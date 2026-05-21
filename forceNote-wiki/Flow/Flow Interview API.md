---
tags: [flow, apex, flow-interview, autolaunched-flow, invocable]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Flow.Interview, Flow Interview, Apex에서 Flow 호출, createInterview, flow start, getVariableValue]
---

# Flow.Interview — Apex에서 Flow 실행

> `Flow.Interview` 클래스로 Apex 코드에서 Autolaunched Flow를 직접 시작하고 변수를 주고받는 API.

---

## 언제 쓰나

`Flow.Interview`는 **Apex 코드가 Flow를 시작점으로 제어해야 할 때** 사용한다. 반대 방향(`@InvocableMethod` — Flow에서 Apex를 호출)과 혼동하지 않는다.

**이 API가 필요한 상황:**

| 상황 | 설명 |
|---|---|
| 트리거에서 조건부 Flow 실행 | Before/After 트리거에서 특정 조건을 Apex로 판단한 뒤 Flow에 위임 |
| 런타임에 Flow 이름이 결정됨 | CMDT나 설정값으로 Flow API 이름을 동적으로 주입 |
| Flow 결과를 Apex에서 후처리 | Flow 실행 후 출력 변수를 읽어 Apex에서 추가 로직 적용 |
| REST API Handler에서 Flow 호출 | Apex REST 엔드포인트 → Flow → DML 위임 구조 |

**이 API를 쓰지 말아야 할 상황:**

- Screen Flow는 호출 불가. Autolaunched Flow만 지원한다.
- 단순히 Apex에서 DML을 실행하려는 목적이라면 ServiceLayer 직접 호출이 더 명확하다.
- 반복문 안에서 매 레코드마다 `start()`를 호출하면 거버너 한도(SOQL, DML)가 빠르게 소진된다. 벌크 처리 설계가 필요하다.

---

## 기본 사용 — 정적(Static) 방식 (권장)

```apex
// Flow API 이름: Calculate_Discounts
Map<String, Object> inputs = new Map<String, Object>{
    'AccountID'     => accountId,
    'OpportunityID' => oppId
};

// 정적 인스턴스 생성 (컴파일 타임 체크 가능)
Flow.Interview.Calculate_Discounts myFlow =
    new Flow.Interview.Calculate_Discounts(inputs);

myFlow.start();

// 출력 변수 읽기 (정적 타입은 직접 접근 가능)
Decimal discount = (Decimal) myFlow.vDiscountRate;
```

---

## 동적(Dynamic) 방식 — 런타임 Flow 이름 결정

```apex
// Flow 이름을 런타임에 결정해야 할 때
public static void runFlow(String flowName, Map<String, Object> inputs) {
    Flow.Interview interview = Flow.Interview.createInterview(flowName, inputs);
    interview.start();

    // 동적 타입은 getVariableValue() 필수
    Object result = interview.getVariableValue('vOutputVar');
    System.debug('결과: ' + result);
}

// 네임스페이스 있는 Managed Flow
public static void runManagedFlow(String ns, String flowName, Map<String, Object> inputs) {
    Flow.Interview interview = Flow.Interview.createInterview(ns, flowName, inputs);
    interview.start();
}
```

---

## 출력 변수 읽기

```apex
// 정적 방식 — 변수명으로 직접 접근
Flow.Interview.My_Flow myFlow = new Flow.Interview.My_Flow(inputs);
myFlow.start();
String status = (String) myFlow.vStatus;
List<Account> accounts = (List<Account>) myFlow.vAccounts;

// 동적 방식 — getVariableValue() 사용
Flow.Interview interview = Flow.Interview.createInterview('My_Flow', inputs);
interview.start();
String status = (String) interview.getVariableValue('vStatus');
// 변수가 없으면 null 반환 (컴파일 타임 체크 없음)
```

---

## 트리거에서 Flow 호출

```apex
trigger AccountTrigger on Account (after insert) {
    for (Account acc : Trigger.new) {
        Map<String, Object> inputs = new Map<String, Object>{
            'recordId' => acc.Id
        };
        Flow.Interview.Account_Onboarding_Flow flow =
            new Flow.Interview.Account_Onboarding_Flow(inputs);
        flow.start();
    }
}
```

---

## 주의사항

| 항목 | 내용 |
|---|---|
| Flow 타입 | **Autolaunched Flow** (Screen Flow 불가) |
| 거버너 한도 | SOQL·DML 한도 Flow 실행 중 공유됨 |
| 정적 vs 동적 | 정적 방식이 패키지 포함 시 더 안전 |
| 공유 규칙 | API v62.0+에서 `with sharing` 클래스가 Flow를 호출하면 공유 규칙 적용 |
| 삭제 체크 | `createInterview()`는 Flow 삭제 여부를 컴파일 타임에 확인하지 않음 |

---

## 메서드 요약

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `createInterview` | `static Flow.Interview createInterview(String flowName, Map<String,Object> inputs)` | 로컬 Flow 동적 생성 |
| `createInterview` | `static Flow.Interview createInterview(String namespace, String flowName, Map<String,Object> inputs)` | 관리 패키지 Flow 동적 생성 |
| `start` | `void start()` | Flow 실행 시작 |
| `getVariableValue` | `Object getVariableValue(String variableName)` | 출력 변수 값 읽기 (없으면 null) |

---

## 비교 — Flow 호출 방식 3가지

| 방식 | 구현 | 장점 | 단점 |
|---|---|---|---|
| `Flow.Interview` (정적) | `new Flow.Interview.My_Flow(inputs)` | 컴파일 체크, 변수 직접 접근 | 패키지 시 Flow 수동 추가 필요 |
| `Flow.Interview` (동적) | `createInterview(name, inputs)` | 런타임 결정 유연성 | 삭제 체크 없음, `getVariableValue` 필요 |
| `@InvocableMethod` | Flow → Apex Action | Flow 설계자가 제어 | Apex가 Flow 시작 불가 |

---

## 관련 노트

- [[@InvocableMethod 패턴]] — Flow에서 Apex를 호출하는 반대 방향 패턴
- [[Autolaunched Flow 패턴]] — Apex에서 호출되는 Flow 설계 방법
- [[Queueable]] — Flow 호출 후 비동기 처리
- [[Governor Limits]] — Flow 실행 중 공유되는 한도 확인
