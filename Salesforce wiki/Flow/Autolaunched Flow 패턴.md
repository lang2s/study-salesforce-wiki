---
tags: [flow, autolaunched, apex, agent, pattern]
source: agent-script-recipes/FetchCustomer, UpdateCase
created: 2026-05-17
aliases: [AutolaunchedFlow, Headless Flow, Agent Flow]
---

# Autolaunched Flow 패턴

> `processType: AutoLaunchedFlow`. 화면 없이 로직만 실행. Apex/@InvocableMethod, Agent Action, 다른 Flow에서 호출.

---

## 기본 구조

```xml
<Flow xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <processType>AutoLaunchedFlow</processType>
    <status>Active</status>

    <!-- 입력 변수 (isInput=true) -->
    <variables>
        <name>customer_id</name>
        <dataType>String</dataType>
        <isCollection>false</isCollection>
        <isInput>true</isInput>
        <isOutput>false</isOutput>
    </variables>

    <!-- 출력 변수 (isOutput=true) -->
    <variables>
        <name>name</name>
        <dataType>String</dataType>
        <isCollection>false</isCollection>
        <isInput>false</isInput>
        <isOutput>true</isOutput>
    </variables>

    <start>
        <locationX>50</locationX>
        <locationY>0</locationY>
        <connector>
            <targetReference>Get_Contact</targetReference>
        </connector>
    </start>

    <recordLookups>
        <name>Get_Contact</name>
        ...
        <outputAssignments>
            <assignToReference>name</assignToReference>  <!-- 출력 변수에 매핑 -->
            <field>LastName</field>
        </outputAssignments>
    </recordLookups>
</Flow>
```

---

## 레코드 조회 → 출력 패턴

```xml
<!-- 입력: customer_id (String) / 출력: name, email, tier (String) -->
<recordLookups>
    <name>Get_Contact</name>
    <label>Get Contact</label>
    <object>Contact</object>

    <filterLogic>and</filterLogic>
    <filters>
        <field>Customer_ID__c</field>
        <operator>EqualTo</operator>
        <value>
            <elementReference>customer_id</elementReference>
        </value>
    </filters>

    <!-- 특정 필드만 변수에 매핑 -->
    <outputAssignments>
        <assignToReference>name</assignToReference>
        <field>LastName</field>
    </outputAssignments>
    <outputAssignments>
        <assignToReference>email</assignToReference>
        <field>Email</field>
    </outputAssignments>
    <outputAssignments>
        <assignToReference>tier</assignToReference>
        <field>Loyalty_Tier__c</field>
    </outputAssignments>
</recordLookups>
```

---

## 레코드 업데이트 → 결과 반환 패턴

```xml
<!-- 업데이트 후 Assignment로 결과 변수 설정 -->
<recordUpdates>
    <name>Update_Case_Record</name>
    <object>Case</object>
    <filterLogic>and</filterLogic>
    <filters>
        <field>Id</field>
        <operator>EqualTo</operator>
        <value><elementReference>case_id</elementReference></value>
    </filters>
    <inputAssignments>
        <field>Status</field>
        <value><elementReference>status</elementReference></value>
    </inputAssignments>
    <connector>
        <targetReference>Assign_Result</targetReference>
    </connector>
</recordUpdates>

<!-- 업데이트 성공 후 출력 변수에 true 대입 -->
<assignments>
    <name>Assign_Result</name>
    <label>Assign Result</label>
    <assignmentItems>
        <assignToReference>updated</assignToReference>
        <operator>Assign</operator>
        <value><booleanValue>true</booleanValue></value>
    </assignmentItems>
</assignments>
```

---

## Apex에서 호출

```apex
// 변수 전달
Map<String, Object> params = new Map<String, Object>{
    'customer_id' => '12345'
};

Flow.Interview interview = Flow.Interview.createInterview(
    '',              // namespace (기본 org: 빈 문자열)
    'FetchCustomer', // Flow API Name
    params
);
interview.start();

// 출력 변수 읽기
String name  = (String) interview.getVariableValue('name');
String email = (String) interview.getVariableValue('email');
```

---

## Agent Action으로 호출 (Agentforce)

Autolaunched Flow를 Agent의 Action으로 등록하면 AI가 자연어로 호출:

```
사용자: "고객 ID 12345 정보 조회해줘"
Agent → FetchCustomer Flow 호출 (customer_id = '12345')
→ name, email, tier 반환
→ "고객 Kim의 이메일은 kim@example.com, 등급은 Gold입니다."
```

Flow 변수 설계 주의사항:
- `isInput=true`: Agent가 채울 파라미터 → 명확한 이름 + 설명 추가
- `isOutput=true`: Agent가 응답에 활용할 결과

---

## Apex @InvocableMethod vs Autolaunched Flow 선택

| 상황 | 선택 |
|---|---|
| 복잡한 로직, 분기, 다중 DML | Apex @InvocableMethod |
| 단순 CRUD (조회/생성/수정) | Autolaunched Flow |
| 관리자가 직접 유지보수 | Autolaunched Flow |
| 개발자 코드 배포 없이 변경 | Autolaunched Flow |
| 트랜잭션 제어 중요 | Apex |
| Agent Action 연동 | Autolaunched Flow 우선 |

---

## 관련 노트

- [[Flow 종류와 변수]]
- [[Flow 요소 참조]]
- [[@InvocableMethod 패턴]]
