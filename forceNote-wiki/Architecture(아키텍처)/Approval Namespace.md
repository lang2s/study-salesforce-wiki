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

## 개념

Salesforce의 승인 프로세스(Approval Process)는 UI에서 수동으로 제출·승인·거절하는 것이 기본이다. `Approval` 네임스페이스는 이 동작을 **Apex 코드에서 자동화**할 수 있게 해준다.

- 레코드를 특정 조건 충족 시 자동으로 승인 프로세스에 제출
- 외부 시스템의 응답(Callout 결과 등)에 따라 자동 승인/거절
- 대량 레코드를 Batch Apex로 일괄 제출

UI 클릭 없이 프로그래밍 방식으로 승인 워크플로를 구동해야 할 때 필수 API다.

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| 특정 조건 충족 시 레코드를 자동으로 승인 프로세스에 제출 | `Approval.ProcessSubmitRequest` + `Approval.process()` |
| 외부 시스템 응답에 따라 자동 승인/거절 처리 | `ProcessWorkitemRequest.setAction('Approve'/'Reject')` |
| 대량 레코드 일괄 승인 제출 | Batch Apex 내에서 `Approval.process(requests, false)` |
| 레코드 수정을 방지하기 위해 잠금/해제가 필요할 때 | `Approval.lock()` / `Approval.unlock()` |
| 기존 승인 프로세스 인스턴스 상태를 Apex에서 읽어야 할 때 | `ProcessInstanceWorkitem` SOQL 쿼리 후 `ProcessWorkitemRequest` |

승인 결과(승인/거절)에 따라 후속 자동화(이메일 발송, Platform Event 발행 등)를 연결해야 할 때도 Apex `Approval` API가 적합하다.

---

## 주의사항

> [!warning] Approval Namespace 제한사항
> - **트랜잭션당 한도**: `Approval.process()` 단일 호출 당 최대 1000개 요청. Bulk 처리 시 `allOrNone=false`로 부분 성공을 허용하는 것이 안전하다.
> - **승인자 할당 필수**: 승인 프로세스가 설정되어 있지 않거나 활성 단계가 없으면 `process()` 호출 시 예외 발생.
> - **재제출 불가**: 이미 승인/거절된 레코드에 `ProcessSubmitRequest`를 제출하면 오류. `ProcessResult.isSuccess()` 확인 후 처리.
> - **레코드 잠금 상태 주의**: `Approval.lock()`으로 잠긴 레코드는 프로필 권한이 있어도 수정 불가. 잠금/해제를 명시적으로 관리해야 한다.
> - **테스트 컨텍스트**: `@isTest`에서 승인 프로세스가 실제로 설정된 org가 아니면 제출이 예외 없이 성공처럼 보일 수 있음. 통합 테스트 환경에서 검증 권장.

---

## 관련 노트

- [[서비스 레이어 패턴]] — Approval 호출을 Service Layer에 캡슐화
- [[Platform Event 발행]] — 승인 완료 후 이벤트 발행 패턴
- [[Batch Apex]] — 대량 레코드 일괄 승인 제출
