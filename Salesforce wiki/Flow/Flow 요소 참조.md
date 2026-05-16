---
tags: [flow, element, xml, reference]
source: dreamhouse-lwc/Create_property, agent-script-recipes
created: 2026-05-17
aliases: [Flow Elements, Flow XML, recordLookups, decisions, assignments]
---

# Flow 요소 참조

> .flow-meta.xml 에서 사용하는 요소들. 각 요소의 XML 구조와 연결(connector) 패턴.

---

## 요소 종류 한눈에 보기

| XML 요소 | Flow Builder 이름 | 역할 |
|---|---|---|
| `recordLookups` | Get Records | SOQL 조회 |
| `recordCreates` | Create Records | 레코드 생성 |
| `recordUpdates` | Update Records | 레코드 수정 |
| `recordDeletes` | Delete Records | 레코드 삭제 |
| `decisions` | Decision | 조건 분기 |
| `assignments` | Assignment | 변수에 값 대입 |
| `loops` | Loop | 컬렉션 반복 |
| `screens` | Screen | 사용자 입력 화면 |
| `actionCalls` | Action | Apex/외부 액션 호출 |
| `subflows` | Subflow | 다른 Flow 호출 |
| `formulas` | Formula | 계산 수식 |
| `waits` | Wait | 일시 정지 (예약) |

---

## recordLookups — Get Records

```xml
<recordLookups>
    <name>Get_Contact</name>
    <label>Get Contact</label>
    <locationX>176</locationX>
    <locationY>134</locationY>

    <!-- 결과 없으면 null 할당 여부 -->
    <assignNullValuesIfNoRecordsFound>false</assignNullValuesIfNoRecordsFound>

    <!-- 첫 번째 레코드만 (true) vs 전체 컬렉션 (false) -->
    <getFirstRecordOnly>true</getFirstRecordOnly>

    <filterLogic>and</filterLogic>
    <filters>
        <field>Customer_ID__c</field>
        <operator>EqualTo</operator>
        <value>
            <elementReference>customer_id</elementReference>  <!-- Flow 변수 참조 -->
        </value>
    </filters>

    <object>Contact</object>

    <!-- 자동 저장 (storeOutputAutomatically=true) → 요소명으로 직접 접근 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <!-- 또는 outputAssignments로 특정 필드만 변수에 매핑 -->
    <outputAssignments>
        <assignToReference>name</assignToReference>
        <field>LastName</field>
    </outputAssignments>

    <connector>
        <targetReference>Next_Element</targetReference>
    </connector>
    <faultConnector>
        <targetReference>Error_Screen</targetReference>
    </faultConnector>
</recordLookups>
```

**storeOutputAutomatically vs outputAssignments:**

| 방식 | 접근 방법 | 사용 시점 |
|---|---|---|
| `storeOutputAutomatically` | `{!get_contact.LastName}` | 전체 레코드 필드에 접근 |
| `outputAssignments` | `{!name}` (별도 변수) | 특정 필드만 별도 변수로 |

---

## recordCreates — Create Records

```xml
<recordCreates>
    <name>create_property</name>
    <label>Create Property</label>
    <object>Property__c</object>

    <inputAssignments>
        <field>Name</field>
        <value>
            <elementReference>property_name</elementReference>
        </value>
    </inputAssignments>
    <inputAssignments>
        <field>Status__c</field>
        <value>
            <stringValue>Available</stringValue>  <!-- 리터럴 값 -->
        </value>
    </inputAssignments>
    <inputAssignments>
        <field>Date_Listed__c</field>
        <value>
            <elementReference>$Flow.CurrentDate</elementReference>  <!-- 전역 변수 -->
        </value>
    </inputAssignments>

    <!-- true면 생성된 레코드 ID를 요소명으로 자동 저장 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <connector><targetReference>Next_Step</targetReference></connector>
    <faultConnector><targetReference>Error_Screen</targetReference></faultConnector>
</recordCreates>
```

> `storeOutputAutomatically`가 true이면 `{!create_property}` = 생성된 Record ID.

---

## recordUpdates — Update Records

```xml
<recordUpdates>
    <name>Update_Case_Record</name>
    <label>Update Case Record</label>
    <object>Case</object>

    <filterLogic>and</filterLogic>
    <filters>
        <field>Id</field>
        <operator>EqualTo</operator>
        <value>
            <elementReference>case_id</elementReference>
        </value>
    </filters>

    <inputAssignments>
        <field>Status</field>
        <value>
            <elementReference>status</elementReference>
        </value>
    </inputAssignments>

    <connector><targetReference>Assign_Result</targetReference></connector>
</recordUpdates>
```

---

## decisions — 조건 분기

```xml
<decisions>
    <name>If_content_document_found</name>
    <label>If Content Document found</label>

    <!-- 조건 미충족 시 기본 경로 -->
    <defaultConnector>
        <targetReference>navigate_to_record_detail</targetReference>
    </defaultConnector>
    <defaultConnectorLabel>Default Outcome</defaultConnectorLabel>

    <rules>
        <name>Content_Document_Link_found</name>
        <conditionLogic>and</conditionLogic>
        <conditions>
            <leftValueReference>get_main_content_document</leftValueReference>
            <operator>IsNull</operator>
            <rightValue>
                <booleanValue>false</booleanValue>
            </rightValue>
        </conditions>
        <connector>
            <targetReference>get_main_content_version</targetReference>
        </connector>
        <label>Content Document Found</label>
    </rules>
</decisions>
```

**operator 종류:**

| operator | 의미 |
|---|---|
| `EqualTo` | = |
| `NotEqualTo` | ≠ |
| `IsNull` | null 여부 |
| `GreaterThan` | > |
| `LessThan` | < |
| `Contains` | 포함 |
| `StartsWith` | 시작 |

---

## assignments — 변수 대입

```xml
<assignments>
    <name>Assign_Result</name>
    <label>Assign Result</label>
    <assignmentItems>
        <assignToReference>updated</assignToReference>
        <operator>Assign</operator>
        <value>
            <booleanValue>true</booleanValue>
        </value>
    </assignmentItems>
</assignments>
```

**operator 종류:**

| operator | 의미 |
|---|---|
| `Assign` | 덮어쓰기 |
| `Add` | 숫자 더하기 / 문자열 연결 |
| `AddItem` | 컬렉션에 항목 추가 |
| `RemoveFirst` | 컬렉션에서 첫 일치 제거 |
| `RemoveAll` | 컬렉션에서 모든 일치 제거 |

---

## actionCalls — Apex Action 호출

```xml
<actionCalls>
    <name>geocode_address</name>
    <label>Geocode Address</label>
    <actionName>GeocodingService</actionName>  <!-- @InvocableMethod 클래스명 -->
    <actionType>apex</actionType>

    <!-- storeOutputAutomatically로 출력 자동 저장 -->
    <storeOutputAutomatically>true</storeOutputAutomatically>

    <inputParameters>
        <name>city</name>
        <value>
            <elementReference>property_address.city</elementReference>
        </value>
    </inputParameters>

    <!-- 현재 트랜잭션에서 실행 여부 -->
    <flowTransactionModel>CurrentTransaction</flowTransactionModel>

    <connector><targetReference>property_details</targetReference></connector>
    <faultConnector><targetReference>Error5</targetReference></faultConnector>
</actionCalls>
```

**actionType 종류:**

| actionType | 설명 |
|---|---|
| `apex` | `@InvocableMethod` Apex 클래스 |
| `flow` | Subflow 호출 |
| `emailAlert` | 이메일 알림 |
| `quickAction` | Quick Action |
| `externalService` | External Service (OpenAPI) |

---

## faultConnector — 오류 처리

모든 레코드 DML 요소와 actionCalls에 `faultConnector` 추가 권장:

```xml
<faultConnector>
    <targetReference>Error_Screen</targetReference>
</faultConnector>
```

오류 화면에서 `{!$Flow.FaultMessage}` 로 오류 내용 표시 가능.

---

## 관련 노트

- [[Flow 종류와 변수]]
- [[Screen Flow 설계]]
- [[Autolaunched Flow 패턴]]
- [[@InvocableMethod 패턴]]
