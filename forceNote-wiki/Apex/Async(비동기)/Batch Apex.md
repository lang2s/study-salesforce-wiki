---
tags: [apex, async, batch, pattern, release-notes]
source: apex-recipes/BatchApexRecipes.cls
created: 2026-05-17
aliases: [batch apex, 배치, 대용량 처리, apex cursor, batch vs cursor, test discovery api]
---

# Batch Apex

> 수만 건 이상의 대용량 데이터 처리. QueryLocator로 힙 한도 우회.

---

## 표준 패턴

```apex
// Database.Stateful: execute() 간 인스턴스 변수 상태 유지 (없으면 각 execute마다 초기화)
public with sharing class MyBatch
        implements Database.Batchable<SObject>, Database.Stateful {

    // Stateful 변수 — 모든 execute()에서 누적됨
    private List<Id> successes = new List<Id>();
    private List<Id> failures  = new List<Id>();

    // 테스트에서 의도적 실패 유발용 회로 차단기
    @testVisible private Boolean throwError = false;

    public Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator([
            SELECT Id, Name FROM Account WITH USER_MODE
        ]);
    }

    public void execute(Database.BatchableContext ctx, List<Account> scope) {
        for (Account acct : scope) {
            acct.Description = 'Processed';
            if (throwError) { acct.Name = null; } // 테스트: 실패 강제
        }

        // allOrNothing=false → 부분 성공 허용
        List<Database.SaveResult> results = Database.update(scope, false);

        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) { successes.add(sr.getId()); }
            else                { failures.add(sr.getId());  }
        }
    }

    public void finish(Database.BatchableContext ctx) {
        // 완료 후 처리: 결과 이메일, 후속 배치 실행 등
        System.debug('Successes: ' + successes.size() + ', Failures: ' + failures.size());
    }
}
```

---

## 실행 방법

```apex
// 기본 실행 (배치 크기 default: 200)
Database.executeBatch(new MyBatch());

// 배치 크기 지정
Database.executeBatch(new MyBatch(), 50);

// 정기 실행 (Schedulable 대신)
System.scheduleBatch(new MyBatch(), 'Daily Batch', 1440); // 24시간마다
```

---

## 핵심 규칙

> [!warning] Database.Stateful 필수 조건
> execute() 간에 `successes`, `failures` 같은 집계 변수를 유지하려면 반드시 `Database.Stateful`을 함께 implements해야 한다. 없으면 각 execute() 호출마다 인스턴스가 새로 생성되어 변수가 초기화된다.

> [!tip] 부분 성공 처리
> `Database.update(scope, false)`(allOrNothing=false)로 실패한 레코드만 건너뛰고 성공한 레코드를 처리할 수 있다. `Database.SaveResult.isSuccess()`로 각 레코드 결과를 확인한다.

> [!tip] QueryLocator vs Iterable
> - `Database.QueryLocator`: SOQL 결과 최대 5천만 건, 힙 한도 우회
> - `Iterable<SObject>`: 복잡한 필터링이 필요할 때, 최대 5만 건

---

---

## 릴리즈별 변경사항

### Summer '24 (v61.0) — Apex Cursor (Beta): Batch 대안

`Database.getCursor()`로 대용량 SOQL 결과를 커서 방식으로 처리한다. Batch Apex처럼 별도 클래스를 만들 필요 없이 단일 트랜잭션 내에서 페이지 단위로 레코드를 가져온다.

```apex
// Cursor 생성 — SOQL을 즉시 실행하지 않고 커서 핸들만 반환
Database.Cursor cursor = Database.getCursor(
    [SELECT Id, Name, Description FROM Account WITH USER_MODE]
);

// 페이지 단위로 fetch (최대 2,000건 / 호출)
Integer offset = 0;
Integer pageSize = 2000;
List<Account> page;

do {
    page = (List<Account>) cursor.fetch(offset, pageSize);
    for (Account acct : page) {
        acct.Description = 'Cursor Processed';
    }
    update page;
    offset += pageSize;
} while (!page.isEmpty());

// 커서는 사용 후 반드시 닫는다
cursor.close();
```

#### Batch Apex vs Apex Cursor 비교

| 항목 | Batch Apex | Apex Cursor (Beta) |
|---|---|---|
| 트랜잭션 분리 | ✅ execute()마다 별도 트랜잭션 | ❌ 단일 트랜잭션 |
| 상태 유지 | `Database.Stateful`로 가능 | 변수 그대로 유지 (단일 트랜잭션) |
| 최대 처리 건수 | 5천만 건 (QueryLocator) | 5천만 건 |
| 코드 복잡도 | 높음 (start/execute/finish) | 낮음 (단일 메서드) |
| 힙 한도 우회 | ✅ execute()마다 초기화 | ❌ 단일 트랜잭션 힙 공유 |
| 사용 시점 | 트랜잭션 격리가 필요한 DML | 단순 대용량 읽기·경량 처리 |
| GA 여부 | GA | Summer '24 기준 Beta |

> [!tip] 선택 기준
> - 처리 중 실패 시 부분 롤백이 필요하다 → **Batch Apex** (`allOrNothing=false`)
> - 집계 변수(`successes`, `failures`)를 execute() 간에 누적해야 한다 → **Batch Apex** (`Database.Stateful`)
> - 단순 대용량 읽기 + 가벼운 처리, 코드를 간결하게 유지하고 싶다 → **Apex Cursor**

---

### Winter '26 (v65.0) — Test Discovery/Runner API

REST API로 Apex 테스트를 탐색하고 비동기 실행할 수 있다. CI/CD 파이프라인에서 특정 클래스/메서드만 선택해 실행하는 자동화에 활용한다.

```
# 테스트 탐색 — 실행 가능한 테스트 클래스 목록 조회
GET /services/data/v65.0/tooling/tests/

# 비동기 테스트 실행 — 특정 클래스 또는 메서드 지정 가능
POST /services/data/v65.0/tooling/runTestsAsynchronous/
```

```json
// POST body 예시 — 특정 클래스와 메서드만 실행
{
  "classNames": "MyBatchTest",
  "testLevel": "RunSpecifiedTests",
  "tests": [
    {
      "className": "MyBatchTest",
      "testMethods": ["testExecuteSuccess", "testStatefulAccumulation"]
    }
  ]
}
```

> [!note] CI/CD 활용 패턴
> - 배포 후 관련 테스트 클래스만 선택 실행 → 전체 테스트 실행 시간 단축
> - `runTestsAsynchronous` 응답의 `testRunId`로 `AsyncApexJob`을 폴링해 결과 확인
> - `Release/Winter '26` 기준 GA. Apex REST 인증은 기존 OAuth 흐름 동일.

---

## 관련 노트

- [[비동기 컨텍스트 선택]]
- [[Scheduled Apex]]
- [[testVisible 회로차단기]]
- [[Queueable]]
- [[Database Namespace 상세]] — Database.Batchable·QueryLocator·BatchableContext 상세
- [[Release/Summer '24]]
- [[Release/Winter '26]]
