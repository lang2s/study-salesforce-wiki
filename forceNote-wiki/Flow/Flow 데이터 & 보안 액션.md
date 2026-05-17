---
tags: [flow, invocable, data, security, soql, async, pattern]
source: automation-components/src-data, automation-components/src-security
created: 2026-05-17
aliases: [ExecuteSOQLQuery, SaveRecordsAsync, IsRecordLocked, SetRecordLock, Flow 동적 SOQL, Flow 레코드 잠금]
---

# Flow 데이터 & 보안 액션

> Flow에서 동적 SOQL 실행, 비동기 레코드 저장, 레코드 잠금 제어를 Invocable Action으로 처리하는 패턴.

---

## ExecuteSOQLQuery — 동적 SOQL 실행

Flow Get Records 요소로 처리할 수 없는 복잡한 쿼리를 문자열로 실행한다.

```apex
@InvocableMethod(label='Executes a SOQL query' category='Data')
global static List<OutputParameters> bulkInvoke(List<InputParameters> inputs) { ... }

private static OutputParameters invoke(InputParameters input) {
    List<SObject> records = Database.query(input.query); // 동적 SOQL
    OutputParameters output = new OutputParameters();
    output.records = records;
    return output;
}

global class InputParameters {
    @InvocableVariable(required=true)
    global String query; // SOQL 쿼리 전체 문자열
}

global class OutputParameters {
    @InvocableVariable
    global List<SObject> records;
}
```

**Flow 설정 예시:**
- query: `SELECT Id, Name, Amount FROM Opportunity WHERE StageName = 'Closed Won' AND CloseDate = THIS_YEAR`

> [!warning] SOQL 인젝션 주의
> Flow 텍스트 변수를 쿼리 문자열에 직접 연결할 경우 인젝션 위험.
> 사용자 입력이 포함되면 Apex에서 `queryWithBinds()` 사용 권장 → [[Dynamic SOQL]]

---

## SaveRecordsAsync — 비동기 레코드 Upsert

현재 Flow 트랜잭션 밖에서 레코드를 저장한다. DML 한도 초과 시 또는 트리거 재귀를 피할 때 유용.

```apex
@InvocableMethod(
    label='Saves a list of records asynchronously (outside of current transaction)'
    category='Data'
)
global static List<OutputParameters> bulkInvoke(List<InputParameters> inputs) { ... }

private static OutputParameters invoke(InputParameters input) {
    UpsertRecordsQueueable job = new UpsertRecordsQueueable(input.records);
    Id jobId = System.enqueueJob(job);         // Queueable 등록
    output.jobId = jobId;
    return output;
}

// Queueable 구현 — execute 단에서 upsert
public class UpsertRecordsQueueable implements Queueable {
    private List<SObject> records;

    public void execute(QueueableContext context) {
        upsert records;  // 새 트랜잭션에서 실행
    }
}
```

**출력:** `jobId` (Id) — AsyncApexJob ID, 추적 가능

> [!tip] 언제 SaveRecordsAsync
> - Flow DML 거버너 한도(150건) 초과 우려
> - 이메일 발송 후 레코드 업데이트처럼 순서가 중요하지 않을 때
> - 현재 Flow 트랜잭션이 롤백되더라도 저장은 진행해야 할 때

> [!warning] 롤백 불가
> 비동기이므로 부모 Flow가 실패해도 Queueable은 실행된다. 조건부 저장이 필요하면 Flow 자체 Decision으로 분기 후 호출.

---

## IsRecordLocked — 레코드 잠금 상태 확인

```apex
@InvocableMethod(label='Checks if a record is locked' category='Security')

private static OutputParameters invoke(InputParameters input) {
    OutputParameters output = new OutputParameters();
    output.isLocked = Approval.isLocked(input.recordId); // Boolean 반환
    return output;
}

global class InputParameters {
    @InvocableVariable(required=true)
    global Id recordId;
}
global class OutputParameters {
    @InvocableVariable
    global Boolean isLocked;
}
```

---

## SetRecordLock — 레코드 잠금/해제

```apex
@InvocableMethod(label='Locks or unlocks a record' category='Security')

private static OutputParameters invoke(InputParameters input) {
    try {
        if (input.isLocked) {
            Approval.LockResult result = Approval.lock(input.recordId);
            return processResult(result.isSuccess(), result.getErrors());
        } else {
            Approval.UnlockResult result = Approval.unlock(input.recordId);
            return processResult(result.isSuccess(), result.getErrors());
        }
    } catch (Exception e) {
        output.isSuccess = false;
        output.errorMessage = e.getMessage();
    }
}

// 에러 문자열화 패턴
private static OutputParameters processResult(Boolean isSuccess, List<Database.Error> errors) {
    if (!isSuccess) {
        String errorString = '';
        for (Database.Error err : errors) {
            errorString += 'Error ' + err.getStatusCode() + ': ' + err.getMessage() + '\n';
        }
        output.errorMessage = errorString;
    }
}

global class InputParameters {
    @InvocableVariable(required=true) global Id recordId;
    @InvocableVariable               global Boolean isLocked; // true=잠금, false=해제
}
global class OutputParameters {
    @InvocableVariable global Boolean isSuccess;
    @InvocableVariable global String  errorMessage;
}
```

---

## 비교표 — 언제 어떤 액션

| 상황 | 액션 |
|---|---|
| Get Records로 못 하는 복잡한 쿼리 | ExecuteSOQLQuery |
| DML 한도 우려, 비동기 저장 | SaveRecordsAsync |
| 승인 프로세스 잠금 여부 확인 | IsRecordLocked |
| 승인 완료 후 레코드 잠금 | SetRecordLock (isLocked=true) |
| 재검토를 위한 잠금 해제 | SetRecordLock (isLocked=false) |

---

## 관련 노트

- [[Dynamic SOQL]] — SOQL 인젝션 방어, queryWithBinds
- [[Queueable]] — Queueable 구현 패턴
- [[@InvocableMethod 패턴]] — bulkInvoke 구조
- [[Flow 레코드 컬렉션 조작]] — 컬렉션 조작 액션
