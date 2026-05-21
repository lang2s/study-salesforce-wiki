---
tags: [flow, apex, invocable, action, pattern]
source: automation-components
created: 2026-05-17
aliases: [InvocableMethod, Flow Action, Invocable Apex]
---

# @InvocableMethod 패턴

> Flow에서 호출 가능한 Apex 액션 작성 표준. automation-components 프로젝트의 30개 액션 전체가 동일한 구조를 사용.

---

## 표준 구조

```apex
global with sharing class FilterRecordsWithFieldValue {

    @InvocableMethod(
        label='Filters a list of records with a field matching a value'
        category='Collections'  // Flow Builder에서 카테고리로 그룹화
    )
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs  // Flow는 항상 List로 전달
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            outputs.add(invoke(input));  // 단건 처리 위임
        }
        return outputs;
    }

    // 실제 비즈니스 로직 분리 — 테스트 용이
    private static OutputParameters invoke(InputParameters input) {
        OutputParameters output = new OutputParameters();
        output.collection = filter(input.collection, input.fieldName, input.fieldValue);
        output.filteredRecordCount = output.collection.size();
        output.totalRecordCount = input.collection.size();
        return output;
    }

    global class InputParameters {
        @InvocableVariable(required=true)
        global List<SObject> collection;

        @InvocableVariable(required=true)
        global String fieldName;

        @InvocableVariable(required=true)
        global String fieldValue;
    }

    global class OutputParameters {
        @InvocableVariable
        global List<SObject> collection;

        @InvocableVariable
        global Integer totalRecordCount;

        @InvocableVariable
        global Integer filteredRecordCount;
    }
}
```

---

## 핵심 규칙

| 항목 | 규칙 |
|---|---|
| 클래스 접근자 | `global` (관리 패키지 배포 시 필요) |
| 메서드 시그니처 | `global static List<Output> bulkInvoke(List<Input> inputs)` |
| Bulk 처리 | Flow가 여러 레코드를 한번에 보냄 → List 순환 필수 |
| 실제 로직 | `private static invoke()` 로 분리 → 단위 테스트 직접 호출 가능 |
| 파라미터 클래스 | `global inner class` + `@InvocableVariable` |
| 공유 키워드 | `with sharing` (Flow는 사용자 컨텍스트에서 실행) |

---

## @InvocableVariable 옵션

```apex
@InvocableVariable(required=true label='Field Name' description='API name of the field')
global String fieldName;
```

| 옵션 | 설명 |
|---|---|
| `required=true` | Flow Builder에서 필수 입력 표시 |
| `label` | Flow Builder UI 레이블 |
| `description` | Flow Builder 툴팁 |
| `defaultValue` | 기본값 지정 *(Summer '24 추가)* |
| `placeholderText` | 입력 필드 플레이스홀더 텍스트 *(Summer '24 추가)* |

**Summer '24 (v61.0) — `defaultValue` · `placeholderText` 수식자 추가:**

```apex
@InvocableVariable(label='Account ID' defaultValue='001000000000000' placeholderText='Enter Account ID')
public String accountId;
```

---

## 지원 타입

| Apex 타입 | Flow 타입 |
|---|---|
| `String` | Text |
| `Boolean` | Boolean |
| `Integer` / `Double` | Number |
| `Date` / `DateTime` | Date / DateTime |
| `Id` | Record ID |
| `List<SObject>` | Record Collection |
| `SObject` | Record (단건) |

> Flow는 복잡한 객체를 직접 전달 불가 → **JSON 직렬화 우회**

```apex
// Flow에서 JSON 문자열로 복잡한 파라미터 전달
@InvocableVariable(required=true)
global String sortKeys;  // '[{"field":"Name","direction":"desc"}]'

// Apex 역직렬화
List<SortKey> keys = (List<SortKey>) JSON.deserialize(sortKeys, List<SortKey>.class);
```

---

## Queueable 연동 — 비동기 처리

```apex
// Flow에서 비동기 저장 호출
private static OutputParameters invoke(InputParameters input) {
    UpsertRecordsQueueable job = new UpsertRecordsQueueable(input.records);
    Id jobId = System.enqueueJob(job);

    OutputParameters output = new OutputParameters();
    output.jobId = jobId;  // Job ID를 Flow 변수로 반환
    return output;
}

public class UpsertRecordsQueueable implements Queueable {
    private List<SObject> records;

    @TestVisible
    UpsertRecordsQueueable(List<SObject> records) {
        this.records = records;
    }

    public void execute(QueueableContext ctx) {
        upsert records;
    }
}
```

---

## Flow.Interview — Apex에서 Flow 실행

```apex
// 다른 Autolaunched Flow를 Apex에서 기동
Map<String, Object> flowParams = new Map<String, Object>{
    'recordId' => input.recordId
};

if (!Test.isRunningTest()) {  // Flow 실행은 테스트에서 불가
    Flow.Interview interview = Flow.Interview.createInterview(
        input.namespace,   // 관리 패키지 namespace ('': 기본)
        input.flowApiName,
        flowParams
    );
    interview.start();
}
```

---

## 레코드 잠금 (Approval Process)

```apex
// 승인 잠금 확인
output.isLocked = Approval.isLocked(input.recordId);

// 잠금 / 해제
Approval.lock(input.recordId);
Approval.unlock(input.recordId);
```

---

## category 분류 (Flow Builder 정렬)

| category | 포함 액션 |
|---|---|
| `Collections` | 컬렉션 필터·정렬·집계·변환 |
| `Data` | SOQL 실행, 레코드 비동기 저장 |
| `Flows` | Flow 실행, Flow 메타데이터 조회 |
| `Security` | 레코드 잠금 확인/설정 |
| `Strings` | CSV 파싱·포맷팅 |
| `Utilities` | 업무 시간 계산, 랜덤 값 |
| `Messaging` | Chatter Rich 메시지 발송 |

---

## 테스트

```apex
@IsTest
static void testFilter() {
    // bulkInvoke 대신 invoke 직접 테스트 불가 (private)
    // → bulkInvoke를 통해 테스트
    FilterRecordsWithFieldValue.InputParameters input =
        new FilterRecordsWithFieldValue.InputParameters();
    input.collection = [SELECT Id, Name, Status__c FROM Order__c LIMIT 10];
    input.fieldName = 'Status__c';
    input.fieldValue = 'Active';

    List<FilterRecordsWithFieldValue.OutputParameters> outputs =
        FilterRecordsWithFieldValue.bulkInvoke(
            new List<FilterRecordsWithFieldValue.InputParameters>{ input }
        );

    Assert.areEqual(/* 기대값 */, outputs[0].filteredRecordCount);
}
```

---

## InvocableActionExtension — Flow Builder 커스텀 프로퍼티 에디터 *(Winter '26 추가)*

`InvocableActionExtension` 메타데이터를 사용하면 Flow Builder 내 Apex 액션의 입력 파라미터에 피클리스트 및 커스텀 프로퍼티 에디터를 정의할 수 있다. 별도 LWC 없이 Flow Builder UI에서 동적 선택 옵션을 제공한다.

---

## 파라미터 클래스 no-arg 생성자 필수 *(Summer '26 추가)*

**v67.0+부터 Invocable Action 파라미터 클래스(Request/Response)에 무인자 생성자 선언이 필수.**

| 패키지 유형 | 필요 접근자 |
|---|---|
| 비패키지(언매니지드) | `public` |
| 관리 패키지 | `global` |

```apex
// ✅ v67.0+ 필수 — no-arg 생성자 명시
public class FlowRequest {
    public FlowRequest() {} // no-arg 생성자 필수
    @InvocableVariable
    public String accountId;
}

// ❌ 이전 방식 — v67.0부터 허용 안 됨
public class FlowRequest {
    @InvocableVariable
    public String accountId;
    // 생성자 없음
}
```

---

## Platform Events 발행 접근 레벨 지정 *(Summer '26 추가)*

`EventBus.publishWithAccessLevel()` — Platform Events 발행 시 접근 레벨을 명시적으로 지정하는 신규 메서드.

```apex
// 구조 예시 — 실제 동작 코드 아님
EventBus.publishWithAccessLevel(eventList, EventBus.AccessLevel.USER);
```

---

## 관련 노트

- [[Flow Interview API]] — Apex에서 Flow를 실행하는 반대 방향 패턴
- [[Flow Screen LWC 패턴]]
- [[멀티 패키지 구조]]
- [[Queueable 체이닝]]
- [[Summer '24]] — @InvocableVariable defaultValue/placeholderText 추가
- [[Winter '26]] — InvocableActionExtension 메타데이터
- [[Summer '26]] — no-arg 생성자 필수, EventBus.publishWithAccessLevel
