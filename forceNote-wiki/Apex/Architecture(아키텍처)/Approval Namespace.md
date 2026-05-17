---
tags: [apex, approval, namespace, process-submit, process-workitem, lock-unlock]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Approval Namespace, 승인 프로세스 API, ProcessSubmitRequest, ProcessWorkitemRequest, Approval.process]
---

# Approval Namespace

> Apex에서 승인 프로세스를 프로그래밍 방식으로 제출·처리·잠금하는 API.

---

## 클래스 구성

| 클래스 | 역할 |
|---|---|
| `Approval.ProcessSubmitRequest` | 레코드를 승인 프로세스에 제출 |
| `Approval.ProcessWorkitemRequest` | 대기 중인 승인 작업을 승인/거절/취소 |
| `Approval.ProcessResult` | `Approval.process()` 결과 |
| `Approval.LockResult` | `Approval.lock()` 결과 |
| `Approval.UnlockResult` | `Approval.unlock()` 결과 |
| `Approval.ProcessRequest` | ProcessSubmitRequest/ProcessWorkitemRequest 공통 부모 |

---

## 승인 제출 — ProcessSubmitRequest

```apex
// 레코드를 승인 프로세스에 제출
Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
req.setComments('제출 코멘트');
req.setObjectId(recordId);                          // 승인할 레코드 ID

// 특정 프로세스 지정 (선택)
req.setProcessDefinitionNameOrId('My_Approval_Process');
req.setSkipEntryCriteria(true);                     // 진입 조건 건너뜀

// 대리 제출자 지정 (선택 — 기본값: 현재 사용자)
req.setSubmitterId(userId);

Approval.ProcessResult result = Approval.process(req);

// 결과 확인
if (result.isSuccess()) {
    String instanceId = result.getInstanceId();           // 프로세스 인스턴스 ID
    String entityId   = result.getEntityId();             // 레코드 ID
    String status     = result.getInstanceStatus();       // Approved/Rejected/Pending
    List<Id> workitemIds = result.getNewWorkitemIds();    // 대기 작업 ID 목록
} else {
    for (Database.Error err : result.getErrors()) {
        System.debug(err.getMessage());
    }
}
```

---

## 승인/거절 처리 — ProcessWorkitemRequest

```apex
// 대기 중인 승인 작업을 처리
// workitemId: ProcessInstanceWorkItem.Id (SOQL로 조회)
Approval.ProcessWorkitemRequest pwr = new Approval.ProcessWorkitemRequest();
pwr.setWorkitemId(workitemId);
pwr.setAction('Approve');    // 'Approve' | 'Reject' | 'Removed'
pwr.setComments('승인합니다');

// 다음 승인자 지정 (다음 단계가 수동 승인인 경우)
pwr.setNextApproverIds(new List<Id>{ nextApproverId });

Approval.ProcessResult result = Approval.process(pwr);
System.assert(result.isSuccess(), '처리 실패: ' + result.getErrors());
```

---

## 레코드 잠금 / 잠금 해제

```apex
// 레코드 잠금 — 승인 중 수정 방지
Account[] accts = [SELECT Id FROM Account WHERE Name LIKE 'Acme%'];
Approval.LockResult[] lockResults = Approval.lock(accts, false);  // allOrNothing=false

for (Approval.LockResult lr : lockResults) {
    if (lr.isSuccess()) {
        System.debug('잠금 성공: ' + lr.getId());
    } else {
        for (Database.Error err : lr.getErrors()) {
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
    }
}

// 레코드 잠금 해제
Approval.UnlockResult[] unlockResults = Approval.unlock(accts, false);
for (Approval.UnlockResult ur : unlockResults) {
    if (ur.isSuccess()) {
        System.debug('잠금 해제 성공: ' + ur.getId());
    }
}
```

---

## 일괄 처리 — 여러 레코드 동시 제출

```apex
// 여러 레코드를 한 번에 승인 제출
List<Approval.ProcessRequest> requests = new List<Approval.ProcessRequest>();
for (Opportunity opp : opportunities) {
    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
    req.setObjectId(opp.Id);
    req.setComments('일괄 제출');
    requests.add(req);
}
Approval.ProcessResult[] results = Approval.process(requests);
```

---

## 비교표 — 언제 무엇을 쓰나

| 상황 | 사용 클래스 | 핵심 메서드 |
|---|---|---|
| 레코드를 승인에 제출 | `ProcessSubmitRequest` | `setObjectId()`, `setComments()` |
| 대기 중 승인 처리 | `ProcessWorkitemRequest` | `setWorkitemId()`, `setAction()` |
| 레코드 수정 잠금 | `Approval.lock()` | `LockResult.isSuccess()` |
| 잠금 해제 | `Approval.unlock()` | `UnlockResult.isSuccess()` |

---

## 주요 메서드 요약

### ProcessSubmitRequest

| 메서드 | 설명 |
|---|---|
| `setObjectId(id)` | 승인 제출할 레코드 ID |
| `setComments(str)` | 승인 코멘트 |
| `setProcessDefinitionNameOrId(str)` | 특정 프로세스 지정 (null이면 전체 평가) |
| `setSkipEntryCriteria(bool)` | 진입 조건 평가 건너뜀 여부 |
| `setSubmitterId(id)` | 제출자 User ID (기본: 현재 사용자) |
| `setNextApproverIds(ids)` | 다음 승인자 목록 |

### ProcessWorkitemRequest

| 메서드 | 설명 |
|---|---|
| `setWorkitemId(id)` | 처리할 ProcessInstanceWorkItem ID |
| `setAction(str)` | `'Approve'` / `'Reject'` / `'Removed'` |
| `setComments(str)` | 처리 코멘트 |
| `setNextApproverIds(ids)` | 다음 승인자 (다음 단계가 수동 승인일 때) |

### ProcessResult

| 메서드 | 설명 |
|---|---|
| `isSuccess()` | 처리 성공 여부 |
| `getErrors()` | `Database.Error[]` |
| `getEntityId()` | 레코드 ID |
| `getInstanceId()` | 프로세스 인스턴스 ID |
| `getInstanceStatus()` | `Approved` / `Rejected` / `Removed` / `Pending` |
| `getNewWorkitemIds()` | 새로 생성된 작업 항목 ID 목록 |

---

## 관련 노트

- [[서비스 레이어 패턴]] — Approval 호출을 Service Layer에 캡슐화
- [[Platform Event 발행]] — 승인 완료 후 이벤트 발행 패턴
- [[Batch Apex]] — 대량 레코드 일괄 승인 제출
