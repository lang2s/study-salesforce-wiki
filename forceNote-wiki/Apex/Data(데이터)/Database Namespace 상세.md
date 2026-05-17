---
tags: [apex, database, namespace, dml, saveresult, upsertresult, deleteresult, cursor, querylocator, mergeresult, dml-options, lead-convert]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Database Namespace, SaveResult, UpsertResult, DeleteResult, MergeResult, QueryLocator, Cursor, PaginationCursor, DMLOptions, LeadConvert, Database.Error, EmptyRecycleBinResult]
---

# Database Namespace 상세 레퍼런스

> Database namespace 전체 클래스 — DML 결과 처리, Cursor 기반 페이지네이션, LeadConvert, DMLOptions.

---

## DML 결과 클래스 총정리

### 공통 패턴 — 결과 이터레이션

```apex
// 모든 DML 결과 클래스의 공통 구조
for (Database.SaveResult sr : Database.insert(records, false)) {
    if (sr.isSuccess()) {
        Id newId = sr.getId();
    } else {
        for (Database.Error err : sr.getErrors()) {
            String msg    = err.getMessage();
            StatusCode sc = err.getStatusCode();
            List<String> fields = err.getFields();  // 오류 필드 목록
        }
    }
}
```

---

### SaveResult — insert / update 결과

```apex
Database.SaveResult[] results = Database.insert(accounts, false);
// Database.update(records, false) 도 SaveResult[] 반환

for (Database.SaveResult sr : results) {
    sr.isSuccess()           // Boolean — 성공 여부
    sr.getId()               // Id — 삽입/수정된 레코드 ID (실패 시 null)
    sr.getErrors()           // Database.Error[] — 오류 목록
}
```

---

### UpsertResult — upsert 결과

```apex
Database.UpsertResult[] results =
    Database.upsert(accounts, Account.External_Id__c, false);

for (Database.UpsertResult ur : results) {
    ur.isSuccess()           // Boolean
    ur.getId()               // Id
    ur.isCreated()           // Boolean — true: 신규 생성, false: 기존 레코드 업데이트
    ur.getErrors()           // Database.Error[]
}
```

---

### DeleteResult — delete 결과

```apex
Database.DeleteResult[] results = Database.delete(accounts, false);

for (Database.DeleteResult dr : results) {
    dr.isSuccess()
    dr.getId()
    dr.getErrors()
}
```

---

### UndeleteResult — undelete 결과

```apex
Database.UndeleteResult[] results = Database.undelete(deletedRecords, false);

for (Database.UndeleteResult ur : results) {
    ur.isSuccess()
    ur.getId()
    ur.getErrors()
}
```

---

### MergeResult — merge 결과

```apex
// 마스터 레코드 + 병합될 레코드(들)
Database.MergeResult result = Database.merge(masterAccount, duplicateAccountId);
// 또는 복수: Database.merge(masterAccount, List<Id> duplicateIds)

result.isSuccess()                   // Boolean
result.getId()                       // Id — 마스터 레코드 ID
result.getMergedRecordIds()          // List<String> — 병합 소멸된 레코드 ID 목록
result.getUpdatedRelatedIds()        // List<String> — 재부모된 관련 레코드 ID 목록
result.getErrors()                   // List<Database.Error>
```

---

### EmptyRecycleBinResult — 영구 삭제 결과

```apex
// 휴지통에서 영구 삭제
Database.EmptyRecycleBinResult[] results =
    Database.emptyRecycleBin(new List<Id>{ recordId1, recordId2 });

for (Database.EmptyRecycleBinResult r : results) {
    r.isSuccess()
    r.getId()
    r.getErrors()
}
```

---

## Database.Error — 오류 세부 정보

```apex
// SaveResult, DeleteResult 등 모든 결과의 오류 정보
Database.Error err = results[0].getErrors()[0];

err.getMessage()       // String — 오류 메시지
err.getStatusCode()    // StatusCode enum — FIELD_CUSTOM_VALIDATION_EXCEPTION 등
err.getFields()        // String[] — 오류가 발생한 필드 이름 목록
```

---

## DMLOptions — DML 옵션 설정

```apex
// Case/Lead 자동 배정 규칙, 이메일 발송, 필드 트런케이션 제어
Database.DMLOptions opts = new Database.DMLOptions();

// 기본 배정 규칙 사용
opts.assignmentRuleHeader.useDefaultRule = true;

// 중복 레코드 허용 (DuplicateRule 바이패스)
opts.duplicateRuleHeader.allowSave = true;

// 자동 발송 이메일 제어
opts.emailHeader.triggerAutoResponseEmail = true;
opts.emailHeader.triggerOtherEmail = false;
opts.emailHeader.triggerUserEmail = true;

// 대용량 문자열 트런케이션 허용
opts.allowFieldTruncation = true;

// 부분 성공 허용
opts.optAllOrNone = false;

// DMLOptions 적용
Database.SaveResult[] results = Database.insert(records, opts);

// sObject에 직접 설정
Case c = new Case(Subject = 'Test');
c.setOptions(opts);
Database.insert(c);
```

---

## Cursor — 대용량 레코드 페이지 처리

```apex
// Cursor: 최대 5천만 건, 최대 100번 fetch, 1회 최대 2,000건
Database.Cursor cursor = Database.getCursor(
    'SELECT Id, Name FROM Contact WHERE LastActivityDate = LAST_N_DAYS:400',
    AccessLevel.USER_MODE
);

Integer total = cursor.getNumRecords();  // 전체 레코드 수
Integer position = 0;

while (position < total) {
    Integer fetchSize = Math.min(200, total - position);
    List<Contact> batch = cursor.fetch(position, fetchSize);
    position += batch.size();
    // batch 처리...
}

// Queueable에서 Cursor 재사용 패턴
public class ChunkQueueable implements Queueable {
    private Database.Cursor cursor;
    private Integer position;

    public ChunkQueueable() {
        cursor = Database.getCursor(
            [SELECT Id FROM Account ORDER BY CreatedDate],
            AccessLevel.USER_MODE
        );
        position = 0;
    }

    public void execute(QueueableContext ctx) {
        if (position >= cursor.getNumRecords()) return;
        List<Account> batch = cursor.fetch(position, 200);
        position += batch.size();
        // 처리...
        if (position < cursor.getNumRecords()) {
            System.enqueueJob(this);
        }
    }
}
```

---

## PaginationCursor — UI 페이지네이션

```apex
// PaginationCursor: 최대 10만 건, UI 페이지네이션용 (삭제 행 자동 스킵)
Database.PaginationCursor pc = Database.getPaginationCursor(
    'SELECT Id, Name FROM Account ORDER BY Name',
    AccessLevel.USER_MODE
);

Integer total = pc.getNumRecords();

// 첫 페이지 fetch
Database.CursorFetchResult page1 = pc.fetchPage(0, 50);
List<SObject> rows = page1.getRecords();
Integer nextStart = page1.getNextIndex();  // 다음 페이지 시작 인덱스
Boolean done = page1.isDone();             // 마지막 페이지 여부
Integer deletedSkipped = page1.getNumDeletedRecords();

// 다음 페이지
Database.CursorFetchResult page2 = pc.fetchPage(nextStart, 50);
```

---

## QueryLocator — Batch Apex용 레코드 셋

```apex
// Batch Apex의 start()에서 사용
public class MyBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name FROM Account WHERE IsActive__c = true'
        );
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // scope 처리
        // bc.getJobId() — 배치 잡 ID
        // bc.getChildJobId() — 현재 청크 ID
    }

    public void finish(Database.BatchableContext bc) { }
}

// QueryLocator 이터레이터 (테스트에서 사용)
Database.QueryLocator ql = Database.getQueryLocator([SELECT Id FROM Account LIMIT 5]);
Database.QueryLocatorIterator it = ql.iterator();
while (it.hasNext()) {
    Account a = (Account) it.next();
}

// QueryLocator 쿼리 문자열 확인 (테스트 검증용)
String q = ql.getQuery();
```

---

## LeadConvert — 리드 전환

```apex
// 리드를 Account + Contact (+ Opportunity) 로 전환
Lead myLead = new Lead(LastName = 'Kim', Company = 'Acme');
insert myLead;

Database.LeadConvert lc = new Database.LeadConvert();
lc.setLeadId(myLead.Id);

// 전환 상태 설정 (필수)
LeadStatus convertStatus = [
    SELECT ApiName FROM LeadStatus WHERE IsConverted = true LIMIT 1
];
lc.setConvertedStatus(convertStatus.ApiName);

// 기존 계정으로 병합 (선택 — 없으면 신규 생성)
lc.setAccountId(existingAccountId);

// 기존 연락처로 병합 (선택)
lc.setContactId(existingContactId);

// 영업 기회 생성하지 않음 (선택)
lc.setDoNotCreateOpportunity(true);

// 알림 이메일 발송 (선택)
lc.setSendNotificationEmail(false);

Database.LeadConvertResult lcr = Database.convertLead(lc);
System.assert(lcr.isSuccess());
Id newAccountId  = lcr.getAccountId();
Id newContactId  = lcr.getContactId();
Id newOppId      = lcr.getOpportunityId();

// 일괄 전환
List<Database.LeadConvertResult> results =
    Database.convertLead(new List<Database.LeadConvert>{ lc1, lc2 });
```

---

## 비교표 — Cursor vs PaginationCursor vs QueryLocator

| 항목 | Cursor | PaginationCursor | QueryLocator |
|---|---|---|---|
| 최대 건수 | 5,000만 | 10만 | 5,000만 |
| 용도 | 대용량 처리 | UI 페이지네이션 | Batch Apex |
| 삭제 행 처리 | 포함 | 자동 스킵 | N/A |
| fetch 방식 | offset + count | fetchPage | iterator |
| 사용 위치 | Queueable 등 | UI 컨트롤러 | Batch.start() |

---

## 관련 노트

- [[DML 패턴]] — insert/update/delete as user, Database.*(accessLevel)
- [[SOQL 패턴]] — Database.getCursor, WITH USER_MODE
- [[Batch Apex]] — Database.Batchable, QueryLocator, BatchableContext
- [[Apex 표준 클래스 레퍼런스]] — Database 섹션 기본 개요
