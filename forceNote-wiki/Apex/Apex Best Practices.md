---
tags: [apex, best-practices, bulkify, governor-limits, trigger, testing, sharing, naming-convention]
source: external-knowledge (https://www.salesforceben.com/12-salesforce-apex-best-practices/)
created: 2026-05-19
aliases: [Apex 베스트 프랙티스, Apex Best Practices, Apex 모범 사례, apex 규칙, apex 코딩 표준, apex 성능]
---

# Apex Best Practices

> [!warning] 이 노트는 외부 지식 기반으로 작성되었으며 공식 소스와 대조되지 않았습니다.

> Salesforce Apex 개발 시 반드시 지켜야 할 12가지 핵심 모범 사례 — 거버너 한도 회피, 보안, 유지보수성 중심.

---

## 1. Bulkify Your Code (벌크화)

트리거는 한 번 실행될 때 최대 **200개 레코드**를 처리한다. 단건을 가정하고 코드를 작성하면 대량 처리 시 거버너 한도에 걸린다. List와 Map을 활용해 항상 컬렉션 단위로 처리한다.

```apex
// 나쁜 예 — 단건 가정
trigger AccountTrigger on Account (before insert) {
    Account acc = Trigger.new[0]; // 첫 번째 레코드만 처리
    acc.Name = acc.Name.toUpperCase();
}

// 좋은 예 — 벌크화
trigger AccountTrigger on Account (before insert) {
    for (Account acc : Trigger.new) {
        acc.Name = acc.Name.toUpperCase();
    }
}
```

---

## 2. Avoid DML / SOQL in Loops (루프 내 DML·SOQL 금지)

루프 안에서 SOQL 또는 DML을 실행하면 레코드 수에 비례해 한도를 소진한다 (SOQL 100회, DML 150회 제한).

**전략:**
- SOQL → 루프 밖에서 실행, ID를 Set에 수집한 뒤 `IN` 조건으로 한 번에 조회
- DML → 루프 안에서 List에 누적, 루프 완료 후 한 번에 실행

```apex
// 나쁜 예 — 루프 내 SOQL
for (Account acc : Trigger.new) {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id]; // 매번 쿼리
}

// 좋은 예 — SET으로 수집 후 IN 조건
Set<Id> accountIds = new Map<Id, Account>(Trigger.new).keySet();
Map<Id, List<Contact>> contactMap = new Map<Id, List<Contact>>();
for (Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds]) {
    if (!contactMap.containsKey(c.AccountId)) contactMap.put(c.AccountId, new List<Contact>());
    contactMap.get(c.AccountId).add(c);
}

// DML — 루프 후 일괄 처리
List<Contact> toUpdate = new List<Contact>();
for (Contact c : contactsToProcess) {
    c.Description = 'Updated';
    toUpdate.add(c);
}
update toUpdate; // 루프 밖 단일 DML
```

---

## 3. Avoid Hard-Coded IDs (하드코딩 ID 금지)

레코드 타입 ID, 특정 레코드 ID 등은 환경마다 다르다. 코드에 직접 박으면 샌드박스·프로덕션 간 이동 시 깨진다.

```apex
// 나쁜 예
Account acc = [SELECT Id FROM Account WHERE RecordTypeId = '0125g000001234AAA'];

// 좋은 예 — DeveloperName으로 조회
Id recordTypeId = Schema.SObjectType.Account
    .getRecordTypeInfosByDeveloperName()
    .get('Enterprise_Account')
    .getRecordTypeId();

// 특정 레코드 참조가 필요하면 → Custom Metadata에 저장
// MySettings__mdt.getInstance('Default').TargetAccountId__c
```

---

## 4. Explicitly Declare Sharing Model (공유 모델 명시)

공유 선언이 없는 클래스는 **기본 동작이 버전마다 달라질 수 있다** (Summer '26부터 `with sharing` 기본값으로 변경 예정). 항상 명시한다.

| 키워드 | 동작 |
|---|---|
| `with sharing` | 실행 사용자의 공유 규칙 적용 |
| `without sharing` | 공유 규칙 무시 (시스템 컨텍스트) |
| `inherited sharing` | 호출자의 공유 컨텍스트 상속 |

```apex
public with sharing class AccountService {
    public List<Account> getMyAccounts() {
        return [SELECT Id, Name FROM Account]; // 실행 사용자 기준 필터링
    }
}

// DML·쿼리가 없는 유틸 클래스는 inherited sharing 권장
public inherited sharing class StringUtils {
    public static String capitalize(String s) {
        return s.substring(0, 1).toUpperCase() + s.substring(1);
    }
}
```

---

## 5. Use a Single Trigger per SObject Type (객체당 트리거 하나)

여러 트리거가 같은 SObject에 붙어있으면 **실행 순서가 보장되지 않는다**. 로직이 순서에 의존할 경우 예측 불가능한 버그가 발생한다. 모든 로직을 하나의 TriggerHandler로 위임한다.

```apex
// AccountTrigger.trigger — 단 하나의 트리거
trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    handler.run();
}
// 비즈니스 로직은 AccountTriggerHandler 클래스 내에서 분기 처리
```

---

## 6. Use SOQL for Loops (SOQL for 루프로 힙 메모리 절약)

대용량 결과 Set을 `List`로 받으면 힙 메모리(6MB / 비동기 12MB)를 한꺼번에 차지한다. `for` 루프에 직접 쿼리를 넣으면 Salesforce가 내부적으로 청크 단위로 처리한다.

```apex
// 일반 SOQL — 전체 결과를 힙에 로드
List<Account> accounts = [SELECT Id, Name FROM Account WHERE CreatedDate = THIS_YEAR];
for (Account a : accounts) { /* 처리 */ }

// SOQL for 루프 — 대용량 데이터에 권장
for (Account a : [SELECT Id, Name FROM Account WHERE CreatedDate = THIS_YEAR]) {
    // 청크 단위로 처리되어 힙 절약
}
```

---

## 7. Modularize Your Code (모듈화)

재사용 가능한 코드를 별도 클래스로 분리하고 **단일 책임 원칙(SRP)**을 적용한다. 하나의 클래스가 너무 많은 책임을 지면 유지보수와 테스트가 어려워진다.

```apex
// 나쁜 예 — AccountTriggerHandler가 이메일 발송까지 담당
public class AccountTriggerHandler {
    public void afterInsert(List<Account> newAccounts) {
        // ... 비즈니스 로직
        // ... 이메일 발송 로직도 여기에
    }
}

// 좋은 예 — 책임 분리
public class AccountTriggerHandler {
    public void afterInsert(List<Account> newAccounts) {
        AccountService.processNewAccounts(newAccounts);
        EmailService.sendWelcomeEmails(newAccounts);
    }
}
```

---

## 8. Test Multiple Scenarios (다양한 시나리오 테스트)

**75% 코드 커버리지는 배포 최소 조건일 뿐**, 품질을 보장하지 않는다. Positive/Negative/Bulk 케이스를 모두 커버한다.

| 케이스 | 내용 |
|---|---|
| Positive | 정상 입력으로 기대 결과 확인 |
| Negative | 잘못된 입력, null, 빈 리스트 처리 |
| Bulk | 200개 레코드로 거버너 한도 검증 |
| Admin vs Standard User | 권한에 따른 동작 차이 확인 |

```apex
@isTest
static void testBulkInsert() {
    List<Account> accounts = new List<Account>();
    for (Integer i = 0; i < 200; i++) {
        accounts.add(new Account(Name = 'Test Account ' + i));
    }
    Test.startTest();
    insert accounts;
    Test.stopTest();
    System.assertEquals(200, [SELECT COUNT() FROM Account]);
}
```

---

## 9. Avoid Nested Loops (중첩 루프 금지)

중첩 루프는 시간 복잡도를 O(n²)으로 만들고 코드 이해를 어렵게 한다. Map을 활용하거나 내부 루프 로직을 별도 메서드로 추상화한다.

```apex
// 나쁜 예 — O(n²) 중첩 루프
for (Account acc : accounts) {
    for (Contact con : allContacts) {
        if (con.AccountId == acc.Id) { /* 처리 */ }
    }
}

// 좋은 예 — Map으로 O(n) 처리
Map<Id, List<Contact>> contactsByAccount = new Map<Id, List<Contact>>();
for (Contact con : allContacts) {
    if (!contactsByAccount.containsKey(con.AccountId)) {
        contactsByAccount.put(con.AccountId, new List<Contact>());
    }
    contactsByAccount.get(con.AccountId).add(con);
}
for (Account acc : accounts) {
    List<Contact> contacts = contactsByAccount.get(acc.Id) ?? new List<Contact>();
}
```

---

## 10. Have a Naming Convention (네이밍 컨벤션)

팀 전체가 따를 수 있는 일관된 네이밍 규칙을 수립한다. 규칙 자체보다 **일관성**이 중요하다.

| 항목 | 권장 패턴 | 예시 |
|---|---|---|
| 클래스 | PascalCase | `AccountService`, `ContactTriggerHandler` |
| 메서드 | camelCase (동사+명사) | `getActiveAccounts()`, `sendWelcomeEmail()` |
| 변수 | camelCase | `accountList`, `contactMap` |
| 상수 | UPPER_SNAKE_CASE | `MAX_BATCH_SIZE`, `DEFAULT_ACCOUNT_NAME` |
| 트리거 | `[SObject]Trigger` | `AccountTrigger`, `OpportunityTrigger` |
| 핸들러 | `[SObject]TriggerHandler` | `AccountTriggerHandler` |
| 테스트 클래스 | `[ClassName]Test` | `AccountServiceTest` |

---

## 11. Avoid Business Logic in Triggers (트리거에 비즈니스 로직 금지)

트리거는 **라우터** 역할만 해야 한다. 비즈니스 로직이 트리거에 있으면 테스트·재사용·유지보수가 모두 어려워진다.

```
AccountTrigger.trigger
    → AccountTriggerHandler.cls  (이벤트 분기)
        → AccountService.cls     (비즈니스 로직)
        → EmailService.cls       (이메일 발송)
```

**TriggerHandler가 God Object가 되지 않도록 주의.** 핸들러는 이벤트별 분기만 담당하고, 실제 로직은 Service 클래스로 위임한다.

```apex
// TriggerHandler — 이벤트 분기만
public class AccountTriggerHandler {
    public void beforeInsert(List<Account> newAccounts) {
        AccountService.validateNames(newAccounts);
    }
    public void afterInsert(List<Account> newAccounts) {
        AccountService.createDefaultContacts(newAccounts);
    }
}
```

---

## 12. Avoid Returning JSON to Lightning Components (@AuraEnabled 직접 객체 반환)

`@AuraEnabled` 메서드에서 JSON을 직렬화해 String으로 반환하면 **힙 메모리와 CPU를 이중 낭비**한다. LWC/Aura는 Apex 객체를 직접 역직렬화할 수 있으므로, Apex 클래스나 SObject를 바로 반환한다.

```apex
// 나쁜 예 — JSON 직렬화 후 String 반환
@AuraEnabled
public static String getAccountData(Id accountId) {
    Account acc = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
    return JSON.serialize(acc); // 힙 낭비 + CPU 낭비
}

// 좋은 예 — 직접 SObject 반환
@AuraEnabled(cacheable=true)
public static Account getAccountData(Id accountId) {
    return [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId WITH USER_MODE];
}

// 커스텀 데이터 클래스 반환도 OK
@AuraEnabled
public static AccountWrapper getAccountWrapper(Id accountId) {
    return AccountService.buildWrapper(accountId);
}
```

---

## 핵심 요약표

| # | 규칙 | 핵심 이유 |
|---|---|---|
| 1 | Bulkify | 200개 레코드 처리 보장 |
| 2 | No DML/SOQL in loops | 거버너 한도 (SOQL 100, DML 150) |
| 3 | No hard-coded IDs | 환경 이동 시 안전 |
| 4 | Declare sharing | 보안 명확화 |
| 5 | Single trigger | 실행 순서 예측 가능 |
| 6 | SOQL for loop | 힙 메모리 절약 |
| 7 | Modularize | SRP, 재사용성 |
| 8 | Test scenarios | 실질적 품질 보장 |
| 9 | No nested loops | 성능 O(n) 유지 |
| 10 | Naming convention | 팀 가독성 |
| 11 | No logic in triggers | 테스트·유지보수성 |
| 12 | No JSON to LWC | 힙·CPU 절약 |

---

## 관련 노트

- [[TriggerHandler 패턴]] — 객체당 단일 트리거 + 핸들러 구조 구현
- [[CMDT 메타데이터 트리거]] — 하드코딩 ID 대신 Custom Metadata 활용
- [[테스트 전략]] — Positive/Negative/Bulk 시나리오 테스트 방법론
- [[WITH USER_MODE]] — 공유 모델 인라인 키워드 (SOQL/DML)
- [[SOQL 패턴]] — SOQL for loop, 벌크 쿼리 패턴
