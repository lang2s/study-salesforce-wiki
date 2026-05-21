---
tags: [apex, dml, security, pattern]
source: apex-recipes/DMLRecipes.cls, AccountServiceLayer.cls
created: 2026-05-17
aliases: [DML 보안, insert as user]
---

# DML 패턴

> Apex API 57.0+의 `insert as user/system` 키워드와 `Database.*(AccessLevel)` 패턴. FLS/CRUD를 인라인으로 강제.

---

## 개념

### 왜 DML 접근 모드가 중요한가

Apex DML(`insert`, `update`, `delete` 등)은 기본적으로 시스템 컨텍스트에서 실행된다. 이는 클래스에 `with sharing`이 선언되어 있어도 동일하다 — `with sharing`은 **레코드 가시성(공유 규칙)**에만 영향을 주며, DML 실행 시 FLS나 CRUD 권한 확인은 하지 않는다.

따라서 별도의 처리 없이 Apex DML을 수행하면, 사용자가 특정 오브젝트에 Create 권한이 없거나 특정 필드에 접근 권한이 없어도 DML이 성공적으로 실행된다. 이는 **권한 초과(privilege escalation)** 문제이며, Salesforce Security Review의 주요 지적 사항이다.

API 57.0(Summer '23)에서 `insert as user` 키워드와 `Database.*(AccessLevel)` 파라미터가 도입되어, DML 선언 지점에서 직접 접근 모드를 명시할 수 있게 되었다. v67.0(Summer '26)부터는 **DML 기본 모드 자체가 USER_MODE**로 변경된다.

### 언제 어떤 모드를 선택하는가

- **일반 서비스 레이어, @AuraEnabled, REST**: `insert as user` — 가장 간결하고 명확
- **트리거 핸들러, 플랫폼 자동화, 배치**: `insert as system` 또는 `Database.insert(recs, AccessLevel.SYSTEM_MODE)` — 자동화 컨텍스트에서 사용자 권한과 무관하게 작동해야 할 때
- **부분 성공(Partial Success) 처리**: `Database.insert(recs, false, AccessLevel.USER_MODE)` — 배치처럼 일부 레코드 실패를 허용하고 성공 레코드만 처리해야 할 때
- **FLS 위반 필드 감지 필요**: `Safely().throwIfRemovedFields().doInsert()` — 어떤 필드가 제거되었는지 알아야 할 때
- **외부 입력(JSON) 처리**: `Security.stripInaccessible()` → DML — 사용자가 보낸 데이터를 그대로 DML하기 전 접근 불가 필드를 반드시 제거

---

## DML 접근 모드 선택 기준

| 패턴 | 코드 | 사용 시점 |
|---|---|---|
| `insert as user` | 현재 사용자 CRUD/FLS 적용 | 일반 DML (가장 권장) |
| `insert as system` | 시스템 모드 (CRUD/FLS 무시) | 트리거 핸들러, 플랫폼 자동화 |
| `Database.insert(recs, allOrNothing, AccessLevel.USER_MODE)` | 부분 성공 + FLS | 배치, 부분 실패 허용 시 |
| `Safely.cls` Fluent API | `new Safely().allOrNothing().doInsert(recs)` | throwIfRemovedFields 필요 시 |
| `Security.stripInaccessible` → DML | 필드 단위 제거 후 DML | 사용자 입력 데이터 처리 |

---

## `as user` / `as system` 키워드 (API 57.0+)

> [!important] **Summer '26 (API v67.0) 파괴적 변경**
> - API v67.0부터 DML 기본 실행 모드가 **USER_MODE**로 변경.
> - `insert as user`, `update as user` 등 DML 접근 레벨 명시 구문 권장.
> - `Database.insert()`, `Database.update()` 등 Database 메서드도 기본 USER_MODE 적용.

```apex
// ✅ v67.0+ 권장 — 명시적 user mode DML
insert as user new Account(Name = 'Test');
update as user accounts;
delete as user [SELECT Id FROM Contact WHERE AccountId = :accId];
undelete as user contacts;
upsert as user acct;

// 시스템 모드 (트리거 핸들러, 플랫폼 자동화 등 명시적 필요 시)
insert as system acct;
update as system accounts;
```

---

## Database.* + AccessLevel (부분 성공 필요 시)

```apex
// allOrNothing=false + USER_MODE — 배치에서 자주 사용
List<Database.SaveResult> results =
    Database.insert(accounts, false, System.AccessLevel.USER_MODE);

// 결과 처리
for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) { /* 성공 Id */ }
    else { /* sr.getErrors() */ }
}

// upsert
Database.upsert(acct, false, AccessLevel.USER_MODE);
Database.update(accts, AccessLevel.USER_MODE);
Database.delete(accts, AccessLevel.USER_MODE);

// ✅ v67.0+ — SYSTEM_MODE 명시도 가능 (의도 명확화)
Database.insert(new Account(Name = 'Test'), AccessLevel.USER_MODE);
Database.insert(new Account(Name = 'Test'), AccessLevel.SYSTEM_MODE);
```

---

## Safely.cls Fluent API (throwIfRemovedFields 필요 시)

```apex
// throwIfRemovedFields: FLS로 제거된 필드가 있으면 예외 throw
new Safely()
    .allOrNothing()
    .throwIfRemovedFields()
    .doInsert(records);

new Safely().doUpdate(accounts);
new Safely().doDelete(contacts);
```

> [!note] Safely vs `as user` 선택 기준
> - 단순 DML → `insert as user` (더 읽기 쉬움)
> - 제거된 필드 감지 필요 → `Safely().throwIfRemovedFields()`
> - 부분 성공 처리 → `Database.insert(recs, false, AccessLevel.USER_MODE)`

---

## stripInaccessible + DML (외부 입력 처리)

```apex
// LWC/REST에서 받은 JSON 역직렬화 후 업데이트
List<Account> accounts = (List<Account>) JSON.deserialize(jsonText, List<Account>.class);

// UPDATABLE 모드로 편집 불가 필드 제거
SObjectAccessDecision decision =
    Security.stripInaccessible(AccessType.UPDATABLE, accounts);

update as user decision.getRecords();
```

> [!warning] JSON 역직렬화 후 반드시 stripInaccessible
> 사용자가 보내온 JSON을 그대로 DML하면 권한 없는 필드까지 수정될 수 있다. 반드시 `stripInaccessible(AccessType.UPDATABLE, ...)` 처리 후 DML.

---

## 관련 노트

- [[Safely]]
- [[StripInaccessible]]
- [[CanTheUser]]
- [[WITH USER_MODE]] — AccessLevel 열거형 상세
- [[4 Custom Objects]] — __c 표준 필드 목록 (DML 대상 필드 참조)
- [[Batch Apex]] — Database.SaveResult 처리
- [[Summer '26]] — API v67.0 DML 기본 모드 USER_MODE 변경
