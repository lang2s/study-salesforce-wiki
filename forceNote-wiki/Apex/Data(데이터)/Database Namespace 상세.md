---
tags: [apex, database, namespace, dml, saveresult, upsertresult, deleteresult, cursor, querylocator, mergeresult, dml-options, lead-convert, querylocatoriterator]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
updated: 2026-05-22
aliases: [Database Namespace, SaveResult, UpsertResult, DeleteResult, MergeResult, QueryLocator, QueryLocatorIterator, Cursor, PaginationCursor, DMLOptions, LeadConvert, Database.Error, EmptyRecycleBinResult, AssignmentRuleHeader, DuplicateRuleHeader, EmailHeader, LocaleOptions]
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
opts.duplicateRuleHeader.runAsCurrentUser = true;  // 현재 사용자 공유 규칙 적용

// 자동 발송 이메일 제어
opts.emailHeader.triggerAutoResponseEmail = true;
opts.emailHeader.triggerOtherEmail = false;
opts.emailHeader.triggerUserEmail = true;

// 대용량 문자열 트런케이션 허용
opts.allowFieldTruncation = true;

// 반환 레이블 언어 설정 (예: 'ko', 'en_US', 'de_DE')
opts.localeOptions = 'en_US';

// 부분 성공 허용
opts.optAllOrNone = false;

// DMLOptions 적용
Database.SaveResult[] results = Database.insert(records, opts);

// sObject에 직접 설정
Case c = new Case(Subject = 'Test');
c.setOptions(opts);
Database.insert(c);
```

### DMLOptions 프로퍼티 전체 목록

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `allowFieldTruncation` | `Boolean` | 긴 문자열 트런케이션 허용 (API v15.0+ 기본값: false) |
| `assignmentRuleHeader` | `DmlOptions.AssignmentRuleHeader` | 배정 규칙 설정 |
| `duplicateRuleHeader` | `DMLOptions.DuplicateRuleHeader` | 중복 규칙 설정 |
| `emailHeader` | `DmlOptions.EmailHeader` | 자동 이메일 설정 |
| `localeOptions` | `String` | 반환 레이블 언어 코드 (예: `'en_US'`, `'de_DE'`, `'ko'`) |
| `optAllOrNone` | `Boolean` | 부분 성공 허용 여부 (기본값: false) |

### DmlOptions.AssignmentRuleHeader 프로퍼티

Case/Lead 배정 규칙 설정. Account에는 지원하지 않음.

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `useDefaultRule` | `Boolean` | 기본(활성) 배정 규칙 사용. `assignmentRuleId` 와 동시 사용 금지 |
| `assignmentRuleId` | `Id` | 특정 배정 규칙 ID (활성/비활성 모두 가능). `useDefaultRule` 와 동시 사용 금지 |

```apex
// 방법 1 — 기본 규칙
opts.assignmentRuleHeader.useDefaultRule = true;

// 방법 2 — 특정 규칙 ID 지정
opts.assignmentRuleHeader.assignmentRuleId = '01QD0000000EqAn';
```

### DMLOptions.DuplicateRuleHeader 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `allowSave` | `Boolean` | Alert 중복 규칙 위반 시에도 저장 허용 (true) 또는 거부 (false) |
| `runAsCurrentUser` | `Boolean` | 현재 사용자의 공유 규칙 적용 여부. true 설정 시 보이지 않는 중복 레코드 탐지 방지 |

```apex
// 리드→연락처 전환 시 현재 사용자 기준으로 중복 탐지
opts.duplicateRuleHeader.allowSave = false;
opts.duplicateRuleHeader.runAsCurrentUser = true;
```

### DmlOptions.EmailHeader 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `triggerAutoResponseEmail` | `Boolean` | 자동 응답 규칙 이메일 발송 여부 (케이스 생성, 비밀번호 재설정 등) |
| `triggerOtherEmail` | `Boolean` | 조직 외부 이메일 발송 여부 (케이스 연락처 수정 등) |
| `triggerUserEmail` | `Boolean` | 조직 내 사용자 이메일 발송 여부 (비밀번호 재설정, 신규 사용자 등) |

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

### QueryLocator 추가 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getQuery()` | `String` | QueryLocator에서 사용한 SOQL 문자열 반환 |
| `iterator()` | `Database.QueryLocatorIterator` | 새 이터레이터 인스턴스 반환 |

> ⚠️ `iterator()`를 반복 호출하면 매번 새 이터레이터가 생성됨. 반드시 변수에 저장해서 사용.

---

## QueryLocatorIterator — QueryLocator 이터레이터

`Database.QueryLocator.iterator()`가 반환. 배치 테스트 등에서 레코드를 직접 순회할 때 사용.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `hasNext()` | `Boolean` | 다음 레코드가 있으면 true |
| `next()` | `sObject` | 다음 sObject 레코드 반환 |

```apex
Database.QueryLocator ql = Database.getQueryLocator(
    [SELECT Name FROM Account LIMIT 5]
);
Database.QueryLocatorIterator it = ql.iterator();  // 변수에 저장
while (it.hasNext()) {
    Account a = (Account) it.next();
    System.debug(a.Name);
}
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

## Database.Batchable / BatchableContext 인터페이스

```apex
// Database.Batchable<T> 인터페이스 3개 메서드
public class MyBatch implements Database.Batchable<SObject>, Database.Stateful {

    // start: 처리할 레코드 범위 반환 (QueryLocator 또는 Iterable)
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id FROM Account');
    }

    // execute: 각 청크마다 호출
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        Id jobId      = bc.getJobId();        // AsyncApexJob ID
        Id chunkJobId = bc.getChildJobId();   // 현재 청크 ID
        // scope 처리...
    }

    // finish: 전체 배치 완료 후 1회 호출
    public void finish(Database.BatchableContext bc) {
        Id jobId = bc.getJobId();
        // 완료 후 이메일 발송 등
    }
}

// 실행
Id jobId = Database.executeBatch(new MyBatch(), 200);
```

### Database.BatchableContext 인터페이스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getJobId()` | `Id` | AsyncApexJob 레코드 ID |
| `getChildJobId()` | `Id` | 현재 배치 청크 ID |

---

## Database.DeletedRecord — 삭제된 레코드 정보

`Database.getDeleted(sObjectType, startDate, endDate)`가 반환하는 `GetDeletedResult` 내부에서 사용.

```apex
Database.GetDeletedResult gdr = Database.getDeleted(
    Account.sObjectType,
    Datetime.now().addDays(-7),
    Datetime.now()
);
for (Database.DeletedRecord dr : gdr.getDeletedRecords()) {
    Id recordId         = dr.getId();
    Date deletedDate    = dr.getDeletedDate();
}
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getId()` | `Id` | 삭제된 레코드 ID |
| `getDeletedDate()` | `Date` | 삭제 날짜 |

---

## Database.GetDeletedResult — 삭제 이력 조회

```apex
Database.GetDeletedResult result = Database.getDeleted(
    Account.sObjectType,
    Datetime.now().addDays(-30),
    Datetime.now()
);

List<Database.DeletedRecord> deleted = result.getDeletedRecords();
Date earliest = result.getEarliestDateAvailable();  // 조회 가능한 가장 오래된 날짜
Date latest   = result.getLatestDateCovered();       // 조회 범위 끝 날짜
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDeletedRecords()` | `List<Database.DeletedRecord>` | 삭제된 레코드 목록 |
| `getEarliestDateAvailable()` | `Date` | 조회 가능한 가장 오래된 날짜 |
| `getLatestDateCovered()` | `Date` | 조회 범위 끝 날짜 |

---

## Database.GetUpdatedResult — 수정 이력 조회

```apex
Database.GetUpdatedResult result = Database.getUpdated(
    Account.sObjectType,
    Datetime.now().addDays(-7),
    Datetime.now()
);

List<Id> updatedIds  = result.getIds();
Date latestCovered   = result.getLatestDateCovered();
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getIds()` | `List<Id>` | 수정된 레코드 ID 목록 |
| `getLatestDateCovered()` | `Date` | 조회 범위 끝 날짜 |

---

## Database.DuplicateError — 중복 레코드 오류

중복 감지 규칙 위반 시 `Database.Error` 대신 반환되는 하위 클래스.

```apex
Database.SaveResult[] results = Database.insert(records, false);
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        for (Database.Error err : sr.getErrors()) {
            if (err instanceof Database.DuplicateError) {
                Database.DuplicateError dupErr = (Database.DuplicateError) err;
                Datacloud.DuplicateResult dupResult = dupErr.getDuplicateResult();
                // 중복 매치 레코드 조회
                for (Datacloud.MatchResult mr : dupResult.getMatchResults()) {
                    System.debug('중복 오브젝트: ' + mr.getEntityType());
                }
            }
        }
    }
}
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDuplicateResult()` | `Datacloud.DuplicateResult` | 중복 결과 세부 정보 |
| `getFields()` (상속) | `List<String>` | 오류 관련 필드 목록 |
| `getMessage()` (상속) | `String` | 오류 메시지 |
| `getStatusCode()` (상속) | `StatusCode` | 상태 코드 |

---

## LeadConvert 전체 메서드 보완

```apex
Database.LeadConvert lc = new Database.LeadConvert();
lc.setLeadId(myLead.Id);
lc.setConvertedStatus(status);

// 추가 옵션
lc.setAccountId(existingAccountId);
lc.setContactId(existingContactId);
lc.setOpportunityId(existingOppId);       // 기존 기회에 병합
lc.setOpportunityName('New Deal');         // 신규 기회 이름
lc.setOwnerId(ownerId);                    // 소유자 재지정
lc.setRelatedPersonAccountId(personAcctId); // 개인 계정 연결
lc.setDoNotCreateOpportunity(true);
lc.setSendNotificationEmail(false);
lc.setOverwriteLeadSource(false);          // 연락처의 Lead Source 덮어쓰기 여부
```

### LeadConvert 메서드 전체 목록

| setter | 설명 |
|---|---|
| `setLeadId(id)` | 전환할 리드 ID (필수) |
| `setConvertedStatus(status)` | 전환 상태 (필수) |
| `setAccountId(id)` | 연결할 기존 계정 ID |
| `setContactId(id)` | 연결할 기존 연락처 ID |
| `setOpportunityId(id)` | 연결할 기존 기회 ID |
| `setOpportunityName(name)` | 신규 기회 이름 |
| `setOwnerId(id)` | 소유자 User ID |
| `setRelatedPersonAccountId(id)` | 개인 계정 연결 ID |
| `setDoNotCreateOpportunity(bool)` | 기회 생성 안함 |
| `setSendNotificationEmail(bool)` | 알림 이메일 발송 |
| `setOverwriteLeadSource(bool)` | 연락처 Lead Source 덮어쓰기 |

### LeadConvertResult 메서드 전체 목록

```apex
Database.LeadConvertResult lcr = Database.convertLead(lc);
lcr.isSuccess()
lcr.getErrors()
lcr.getLeadId()
lcr.getAccountId()
lcr.getContactId()
lcr.getOpportunityId()
lcr.getRelatedPersonAccountId()   // 개인 계정 ID (있을 경우)
lcr.getRelatedPersonAccountRecord() // 개인 계정 레코드 ID
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
