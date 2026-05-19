---
tags: [apex, governor-limits, execution-context, limits, performance, soql, dml, email-limits, push-notification]
source: developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_gov_limits.htm (Apex Developer Guide v67.0, Summer '26)
created: 2026-05-19
aliases: [Governor Limits, 거버너 한도, 실행 한도, SOQL 한도, DML 한도, Heap 한도, CPU 한도, Limits 클래스, 거버너 리밋, 이메일 한도]
---

# Governor Limits — Apex 실행 한도

> Salesforce 멀티테넌트 플랫폼에서 자원 독점을 막기 위해 Apex 런타임이 강제하는 실행 한도. 한도 초과 시 처리 불가능한 런타임 예외가 발생한다.

---

## 개요

Apex는 Salesforce 멀티테넌트 서버에서 실행된다. 런타임 엔진이 *governors*(거버너)를 통해 한도를 강제 적용하여, Runaway Apex 코드나 프로세스가 공유 자원을 독점하지 못하게 한다.

어떤 Apex 코드가 한도를 초과하면, 해당 거버너는 **처리할 수 없는(can't be handled) 런타임 예외**를 발생시킨다.

한도 대부분은 **트랜잭션 단위**로 적용되며, 일부(예: 24시간 비동기 실행 한도)는 트랜잭션에 묶이지 않는다. Batch Apex의 경우 `execute` 메서드의 각 배치 실행마다 Per-Transaction 한도가 초기화된다.

**Apex 트랜잭션 경계:** trigger, 클래스 메서드, 익명 코드 블록, Visualforce 페이지, 커스텀 Web Service 메서드

---

## Per-Transaction Apex Limits

> **참고:** Scheduled Apex는 비동기 기능이지만, 동기 한도가 적용된다.
>
> **참고:** Bulk API / Bulk API 2.0 트랜잭션의 경우, 동기/비동기 한도 중 높은 쪽이 적용된다.

| 항목 | 동기 한도 | 비동기 한도 |
|---|---|---|
| SOQL 쿼리 수 | **100** | **200** |
| SOQL 조회 레코드 수 | 50,000 | 50,000 |
| `Database.getQueryLocator` 레코드 수 | 10,000 | 10,000 |
| SOSL 쿼리 수 | 20 | 20 |
| 단일 SOSL 쿼리 결과 레코드 수 | 2,000 | 2,000 |
| DML 문 수 | **150** | **150** |
| DML 처리 레코드 수 (`Approval.process`, `database.emptyRecycleBin` 포함) | 10,000 | 10,000 |
| 트리거 재귀 스택 깊이 (insert/update/delete) | 16 | 16 |
| Callout 수 (HTTP 요청 / 웹 서비스 호출) | 100 | 100 |
| Callout 누적 타임아웃 | 120초 | 120초 |
| `@future` 메서드 수 | 50 | 0 (batch/future), 50 (queueable) |
| `System.enqueueJob` 대기열 추가 수 | **50** | **1** |
| `sendEmail` 메서드 수 | 10 | 10 |
| Heap size | **6 MB** | **12 MB** |
| CPU time (Salesforce 서버) | **10,000 ms** | **60,000 ms** |
| 트랜잭션 최대 실행 시간 | 10분 | 10분 |
| Push notification 메서드 호출 수 | 10 | 10 |
| Push notification 건당 최대 발송 수 | 2,000 | 2,000 |
| `EventBus.publish` (즉시 발행 이벤트) | 150 | 150 |
| Apex cursors 총 rows (트랜잭션 당) | 50 million | 50 million |
| Apex cursors 일일 한도 | 10,000 | 10,000 |
| `Cursor.fetch` 호출 수 | 100 | 100 |
| Cursor rows 누적 (신규+페이지네이션, 24시간) | 100 million | 100 million |
| Apex Pagination Cursor 총 rows (트랜잭션 당) | 100,000 | 100,000 |
| Apex Pagination Cursor 인스턴스 수 (트랜잭션 당) | 50 | 50 |
| Apex Pagination Cursor 인스턴스 수 (24시간) | 200,000 | 200,000 |
| Pagination Cursor 페이지당 rows | 2,000 | 2,000 |

**DML 문으로 카운트되는 메서드:**
`Approval.process`, `Database.convertLead`, `Database.emptyRecycleBin`, `Database.rollback`, `Database.setSavePoint`, `delete/Database.delete`, `insert/Database.insert`, `merge/Database.merge`, `undelete/Database.undelete`, `update/Database.update`, `upsert/Database.upsert`, `EventBus.publish` (커밋 후 발행 이벤트), `System.runAs`

**SOQL 쿼리로 카운트되는 메서드:**
`Database.countQuery`, `Database.countQueryWithBinds`, `Database.getQueryLocator`, `Database.getQueryLocatorWithBinds`, `Database.query`, `Database.queryWithBinds`

---

## Per-Transaction Certified Managed Package Limits

AppExchange 보안 리뷰를 통과한 Certified Managed Package는 자체 Per-Transaction 한도를 별도로 가진다.

**예시:** Certified Managed Package 설치 시, 해당 패키지 코드는 자체 150 DML 문 + org 네이티브 코드의 150 DML 문을 각각 사용 가능하다. 동일 트랜잭션에서 150개 이상의 DML이 가능해진다.

**Cross-Namespace 누적 한도 (여러 패키지 동시 사용):**

| 항목 | 누적 한도 |
|---|---|
| SOQL 쿼리 수 | 1,100 |
| `Database.getQueryLocator` 레코드 수 | 110,000 |
| SOSL 쿼리 수 | 220 |
| DML 문 수 | 1,650 |
| Callout 수 | 1,100 |
| `sendEmail` 수 | 110 |

> **참고:** Heap size, CPU time, 최대 트랜잭션 실행 시간, 최대 unique namespace 수는 전체 트랜잭션에 걸쳐 단일하게 적용된다 (certified managed package별 분리 없음).

---

## Salesforce Platform Apex Limits

트랜잭션에 귀속되지 않는 플랫폼 수준 한도.

| 항목 | 한도 |
|---|---|
| 일일 비동기 Apex 실행 수 (Batch, Future, Queueable, Scheduled) | 250,000 또는 사용자 라이선스 수 × 200 중 큰 값 |
| 동시 장기실행 트랜잭션 (5초 초과, 동기) | licenses/100 비율 (최소 10, 최대 50) |
| 동시 스케줄 클래스 수 | 100 (Developer Edition: 5) |
| Batch flex queue Holding 상태 | 100 |
| 동시 활성 Batch jobs | 5 |
| Batch `start` 메서드 동시 실행 | 1 |
| 실행 중인 테스트에서 제출 가능한 Batch jobs | 5 |
| 테스트 클래스 큐 한도 (24시간, production) | max(500, 테스트 클래스 수 × 10) |
| 테스트 클래스 큐 한도 (24시간, sandbox/Developer Edition) | max(500, 테스트 클래스 수 × 20) |

---

## Static Apex Limits

특정 트랜잭션이 아닌 정적으로 적용되는 한도.

| 항목 | 한도 |
|---|---|
| Callout 기본 타임아웃 | 10초 |
| Callout 요청/응답 최대 크기 | 동기 6 MB, 비동기 12 MB |
| SOQL query run time | 120초 (초과 시 트랜잭션 취소) |
| 배포 당 Apex 클래스/트리거 최대 수 | 7,500 |
| Apex 트리거 배치 크기 | **200** (PE/CDC 이벤트: 2,000) |
| for 루프 배치 크기 | 200 |
| `Database.QueryLocator` 최대 레코드 수 | 50 million |

---

## Size-Specific Apex Limits

| 항목 | 한도 |
|---|---|
| 클래스 최대 문자 수 | 1 million |
| 트리거 최대 문자 수 | 1 million |
| Org 전체 Apex 코드 크기 | 6 MB (support case로 증설 가능) |
| Method size | 65,535 bytecode instructions (compiled) |

---

## Limits 클래스 사용법

```apex
// 현재 트랜잭션에서 사용된 SOQL 쿼리 수와 남은 한도 확인
Integer queriesUsed  = Limits.getQueries();          // 현재까지 사용된 SOQL 수
Integer queriesLimit = Limits.getLimitQueries();     // 허용된 총 SOQL 수
Integer queriesLeft  = queriesLimit - queriesUsed;

System.debug('SOQL: ' + queriesUsed + '/' + queriesLimit + ' (남은: ' + queriesLeft + ')');
```

```apex
// 주요 Limits 메서드 목록
Limits.getQueries()                  // 현재 SOQL 쿼리 수
Limits.getLimitQueries()             // 최대 허용 SOQL 수 (sync: 100, async: 200)

Limits.getDmlStatements()            // 현재 DML 문 수
Limits.getLimitDmlStatements()       // 최대 허용 DML 수 (150)

Limits.getDmlRows()                  // 현재 DML 처리 레코드 수
Limits.getLimitDmlRows()             // 최대 허용 DML 레코드 수 (10,000)

Limits.getQueryRows()                // 현재 SOQL 조회 레코드 수
Limits.getLimitQueryRows()           // 최대 허용 SOQL 레코드 수 (50,000)

Limits.getCallouts()                 // 현재 Callout 수
Limits.getLimitCallouts()            // 최대 허용 Callout 수 (100)

Limits.getHeapSize()                 // 현재 힙 크기 (bytes)
Limits.getLimitHeapSize()            // 최대 허용 힙 크기 (sync: 6MB, async: 12MB)

Limits.getCpuTime()                  // 현재 CPU 사용량 (ms)
Limits.getLimitCpuTime()             // 최대 허용 CPU (sync: 10,000ms, async: 60,000ms)
```

```apex
// 구조 예시 — 실제 동작 코드 아님
// 한도 안전 체크 후 DML 실행 패턴
public void safeBulkInsert(List<SObject> records) {
    Integer remaining = Limits.getLimitDmlStatements() - Limits.getDmlStatements();
    if (remaining > 0) {
        insert records;
    } else {
        // 로그 또는 예외 처리
        throw new LimitException('DML 한도 초과 위험');
    }
}
```

---

## 한도 초과 방어 패턴

### 1. Bulkify DML — 루프 내 DML 금지

```apex
// 비추천 — 루프 내 DML (150개 초과 시 런타임 예외)
for(Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
    }
    update li;  // 매 반복마다 DML 1회 소비
}

// 권장 — 리스트로 모아서 단 1번 DML
List<Line_Item__c> updatedList = new List<Line_Item__c>();
for(Line_Item__c li : liList) {
    if (li.Units_Sold__c > 10) {
        li.Description__c = 'New description';
        updatedList.add(li);
    }
}
update updatedList;  // DML 1회
```

### 2. Efficient SOQL — 루프 내 SOQL 금지

```apex
// 비추천 — Trigger.new 100개 이상이면 SOQL 한도(100) 초과
trigger LimitExample on Invoice_Statement__c (before insert, before update) {
    for(Invoice_Statement__c inv : Trigger.new) {
        List<Line_Item__c> liList = [SELECT Id, Units_Sold__c, Merchandise__c
                                     FROM Line_Item__c
                                     WHERE Invoice_Statement__c = :inv.Id];
        for(Line_Item__c li : liList) { /* 처리 */ }
    }
}

// 권장 — 중첩 쿼리로 단 1번의 SOQL
trigger EnhancedLimitExample on Invoice_Statement__c (before insert, before update) {
    List<Invoice_Statement__c> invoicesWithLineItems =
        [SELECT Id, Description__c,
                (SELECT Id, Units_Sold__c, Merchandise__c FROM Line_Items__r)
         FROM Invoice_Statement__c
         WHERE Id IN :Trigger.newMap.KeySet()];

    for(Invoice_Statement__c inv : invoicesWithLineItems) {
        for(Line_Item__c li : inv.Line_Items__r) { /* 처리 */ }
    }
}
```

### 3. SOQL for Loop — Heap 한도 방어

```apex
// 구조 예시 — 실제 동작 코드 아님
// 대용량 레코드 처리 시 for 루프로 heap 한도(6MB) 방어
// 200개씩 청크로 처리하므로 전체를 한 번에 List에 올리지 않음
for(Account a : [SELECT Id, Name FROM Account]) {
    // 처리 로직 — 200개씩 청크로 자동 분할
}
```

---

## 한도 초과 시 발생하는 예외

| 상황 | 발생하는 예외 / 메시지 |
|---|---|
| SOQL 한도 초과 | `System.LimitException: Too many SOQL queries: 101` |
| DML 한도 초과 | `System.LimitException: Too many DML statements: 151` |
| DML 레코드 한도 초과 | `System.LimitException: Too many DML rows: 10001` |
| Heap 한도 초과 | `System.LimitException: Apex heap size too large: ...` |
| CPU 한도 초과 | `System.LimitException: Maximum CPU time exceeded` |
| Callout 한도 초과 | `System.LimitException: Too many callouts: 101` |
| 일일 비동기 한도 초과 | `System.AsyncException: AsyncApexExecutions Limit exceeded` |

> `System.LimitException`은 `catch` 블록에서 잡을 수 없다. try-catch로 처리되지 않으며, 트랜잭션이 강제 롤백된다.

---

## 동기 vs 비동기 핵심 차이

| 컨텍스트 | SOQL | Heap | CPU | enqueueJob |
|---|---|---|---|---|
| **동기 (Sync)** | 100 | 6 MB | 10,000 ms | 50 |
| **비동기 (Async)** | 200 | 12 MB | 60,000 ms | 1 |
| **Scheduled** | 100 (동기 적용) | 6 MB | 10,000 ms | 50 |

비동기 컨텍스트는 SOQL 2배, Heap 2배, CPU 6배로 여유가 크다. 대용량 처리는 [[비동기 컨텍스트 선택]] 참조.

---

## Miscellaneous Apex Limits

### Connect in Apex (ConnectApi)

- ConnectApi 모든 **쓰기 작업**은 DML 문 1회로 카운트된다.
- ConnectApi 메서드 호출은 Salesforce Platform API 요청 할당(24시간 기준, org 단위)에도 포함된다.
- **Chatter 필요 메서드**는 사용자/네임스페이스/시간당 별도 Rate Limit 적용. 초과 시 `ConnectApi.RateLimitException` 발생 → 반드시 catch 처리.

### 테스트에서의 DML 한도 (MAX_DML_ROWS)

- 단일 동기 Apex 테스트 실행 컨텍스트에서 insert/update/delete 가능한 최대 rows: **450,000**
- 초과 시: `Your runallTests is consuming too many DB resources`

### 이메일 한도 (Email Limits)

#### 인바운드 이메일

| 항목 | 한도 |
|---|---|
| Email Services 일일 처리 최대 수 (On-Demand Email-to-Case 포함) | 사용자 라이선스 수 × 1,000 (최대 1,000,000) |
| Email Services 메시지 최대 크기 (본문 + 첨부) | 25 MB |
| On-Demand Email-to-Case 첨부 최대 크기 | 25 MB |

#### 아웃바운드 이메일 (Apex/API)

| 항목 | 한도 |
|---|---|
| 일일 외부 이메일 주소 발송 수 (single email) | 5,000 (Developer Edition: 50명/일, 수신자 당 최대 15명) |
| `SingleEmailMessage` To/CC/BCC 합산 최대 수신자 | 150명 (각 필드 4,000 bytes 제한) |
| 일일 mass/list email 외부 주소 발송 수 | 5,000 (Developer Edition: 10명/일) |
| 내부 사용자 발송 | 무제한 (일일 한도 미적용) |

> **팁:** `setTargetObjectId`로 내부 사용자 ID를 지정하면 일일 한도 미포함. `setToAddresses`로 이메일 주소를 지정하면 한도 포함.

### Push Notification 한도 (Org 수준)

| 항목 | 한도 |
|---|---|
| iOS push notification | 시간당 **20,000건** |
| Android push notification | 시간당 **10,000건** |
| 테스트 push notification | 수신자 1명 제한, org 시간당 한도에 포함 |

> 시간당 한도 초과 시에도 인앱 표시 및 REST API 조회용 알림은 계속 생성됨.

---

## 관련 노트

- [[QuiddityGuard]] — 현재 실행 컨텍스트 판별 (동기/비동기/Batch 구분)
- [[OrgShape]] — Org 환경 정보 (isSandbox 등)
- [[비동기 컨텍스트 선택]] — @future vs Queueable vs Batch 결정 기준
- [[Batch Apex]] — 대용량 처리, execute 당 한도 초기화
- [[Queueable]] — enqueueJob 한도 (비동기: 1개)
- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop, 한도 방어
- [[DML 패턴]] — Bulkify DML, allOrNothing
- [[Apex 표준 클래스 레퍼런스]] — Limits 클래스 전체 메서드 목록
- [[TriggerHandler 패턴]] — 트리거에서 한도 방어 아키텍처
