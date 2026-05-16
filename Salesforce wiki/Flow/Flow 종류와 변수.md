---
tags: [flow, processType, variable, concept]
source: dreamhouse-lwc, lwc-recipes, agent-script-recipes
created: 2026-05-17
aliases: [Flow 종류, Screen Flow, AutolaunchedFlow, Flow 변수]
---

# Flow 종류와 변수

> Flow의 processType 결정과 변수 설계. .flow-meta.xml의 가장 기본적인 구조.

---

## Flow 종류 (processType)

| processType | 실행 방식 | 화면 | 주요 사용 |
|---|---|---|---|
| `Flow` | 사용자가 직접 실행 | ✅ | 마법사형 UI, 데이터 입력 |
| `AutoLaunchedFlow` | 코드/Flow/Agent에서 호출 | ❌ | 레코드 처리, API 로직 |
| `Schedule` | 예약 실행 | ❌ | 배치 처리, 일괄 업데이트 |
| `RecordTriggeredFlow` | 레코드 저장 시 자동 실행 | ❌ | Trigger 대체, 자동화 |
| `Orchestration` | 복잡한 다단계 프로세스 | ❌ | 승인/SLA 관리 |

```xml
<!-- Screen Flow -->
<processType>Flow</processType>

<!-- Autolaunched Flow (Apex/Agent에서 호출) -->
<processType>AutoLaunchedFlow</processType>
```

---

## 변수 (variables)

### 기본 구조

```xml
<variables>
    <name>customer_id</name>
    <dataType>String</dataType>
    <isCollection>false</isCollection>
    <isInput>true</isInput>    <!-- 외부에서 값 주입 가능 -->
    <isOutput>true</isOutput>  <!-- 외부로 값 반환 가능 -->
</variables>
```

### isInput / isOutput 조합

| isInput | isOutput | 용도 |
|---|---|---|
| `true` | `false` | 입력 전용 (파라미터) |
| `false` | `true` | 출력 전용 (결과 반환) |
| `true` | `true` | 입출력 양방향 |
| `false` | `false` | 내부 전용 변수 |

### dataType 종류

| dataType | 설명 | isCollection |
|---|---|---|
| `String` | 텍스트 | `false` |
| `Number` | 숫자 (정수/소수) | `false` |
| `Boolean` | 참/거짓 | `false` |
| `Date` | 날짜 | `false` |
| `DateTime` | 날짜+시간 | `false` |
| `Currency` | 통화 | `false` |
| `Id` | Salesforce Record ID | `false` |
| `SObject` | 단일 레코드 | `false` |
| `SObject` | 레코드 컬렉션 | `true` |

### 레코드 변수

```xml
<!-- 단일 레코드 변수 -->
<variables>
    <name>currentCase</name>
    <dataType>SObject</dataType>
    <isCollection>false</isCollection>
    <isInput>false</isInput>
    <isOutput>true</isOutput>
    <objectType>Case</objectType>  <!-- SObject 타입 지정 -->
</variables>

<!-- 레코드 컬렉션 변수 -->
<variables>
    <name>contactList</name>
    <dataType>SObject</dataType>
    <isCollection>true</isCollection>
    <isInput>false</isInput>
    <isOutput>false</isOutput>
    <objectType>Contact</objectType>
</variables>
```

---

## 전역 변수 ($Flow)

```
$Flow.CurrentDate       → 오늘 날짜
$Flow.CurrentDateTime   → 현재 날짜+시간
$Flow.CurrentUser.Id    → 실행 사용자 ID
$Flow.CurrentUser.Name  → 실행 사용자 이름
$Flow.FaultMessage      → 오류 메시지 (faultConnector에서)
```

---

## 수식 (formulas)

```xml
<formulas>
    <name>displayName</name>
    <dataType>String</dataType>
    <!-- IF, ISBLANK, AND, OR 등 Salesforce 수식 함수 사용 가능 -->
    <expression>IF(ISBLANK({!User_Name_Input}), "", ", " &amp; {!User_Name_Input})</expression>
</formulas>
```

> 수식은 변수처럼 다른 요소에서 `{!formulaName}` 으로 참조.

---

## Apex로 Flow 호출 시 변수 전달

```apex
// isInput=true 변수에 값 전달
Map<String, Object> params = new Map<String, Object>{
    'customer_id' => '12345',
    'status'      => 'Active'
};
Flow.Interview interview = Flow.Interview.createInterview(
    '',           // namespace
    'FetchCustomer',
    params
);
interview.start();

// isOutput=true 변수 값 읽기
String name = (String) interview.getVariableValue('name');
```

---

## 관련 노트

- [[Flow 요소 참조]]
- [[Screen Flow 설계]]
- [[Autolaunched Flow 패턴]]
- [[@InvocableMethod 패턴]]
