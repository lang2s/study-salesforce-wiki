---
tags: [sobject-reference, api-field-properties, describe, aggregatable, filter, nillable, required-fields]
source: object_reference.pdf p.10-12 (v67.0 Summer '26)
created: 2026-05-22
aliases: [API Field Properties, Aggregatable, Autonumber, Create, Defaulted on create, Delete, Filter, Group, idLookup, Namepointing, Nillable, Query, Restricted picklist, Retrieve, Sort, Update, 필드 속성, Required Fields, 필수 필드]
---

# API Field Properties

> 필드 describe 결과(`DescribeSObjectResult.fields[]`)에 포함되는 15개 속성 전수. 필드별 SOQL·DML 허용 범위를 결정.

---

## 개념

각 필드에는 하나 이상의 Property가 붙어 있다. Property는 해당 필드가 어떤 작업(DML·SOQL)에서 어떻게 동작하는지 정의한다. Apex describe API나 WSDL을 통해 확인할 수 있다.

```apex
// 필드 속성 describe로 확인
Schema.DescribeFieldResult f =
    Account.Name.getDescribe();

System.debug('isFilterable: ' + f.isFilterable());
System.debug('isSortable: '   + f.isSortable());
System.debug('isNillable: '   + f.isNillable());
System.debug('isCreateable: ' + f.isCreateable());
System.debug('isUpdateable: ' + f.isUpdateable());
```

---

## Property 전수

### Aggregatable

SOQL 집계 함수(COUNT·SUM·AVG·MIN·MAX)와 GROUP BY에서 사용 가능.

```apex
// Aggregatable 필드 집계
AggregateResult[] results = [
    SELECT Type, COUNT(Id) cnt, SUM(AnnualRevenue) totalRevenue
    FROM Account
    GROUP BY Type
];
```

---

### Autonumber

API가 자동으로 증가하는 번호를 생성. 클라이언트가 값을 직접 지정할 수 없음.

- `CaseNumber`, `ContractNumber` 등에 사용
- `Create` 속성이 없음

---

### Create

`create()` 호출(INSERT) 시 필드 값을 클라이언트가 지정 가능.

- `Create` 속성이 없는 필드는 INSERT 시 무시됨

```apex
// Create 속성이 있는 필드만 INSERT 시 지정 가능
Account acc = new Account(
    Name       = 'Acme',   // Create 있음
    CreatedDate = DateTime.now()  // Create 없음 → 무시 (시스템이 설정)
);
insert acc;
```

---

### Defaulted on create

INSERT 시 클라이언트가 값을 지정하지 않으면 시스템이 기본값을 자동 설정.

- 예: `IsDeleted = false`, `OwnerId = (현재 사용자 ID)`, 시스템 timestamp 필드

---

### Delete

`delete()` 호출 시 해당 필드 값을 삭제 가능.

- 대부분의 일반 필드에 있으며, 일부 시스템 필드(예: `Id`)는 Delete 속성 없음

---

### Filter

SOQL `WHERE` 또는 `FROM` 절에서 필터 조건으로 사용 가능.

- `Filter` 속성이 없는 필드는 WHERE에 사용 불가 (예: `textarea` 계열 필드)

```apex
// Filter 속성이 있는 필드만 WHERE 사용 가능
List<Account> accs = [
    SELECT Id, Name
    FROM Account
    WHERE Name = 'Acme'  // Name: Filter 있음
];

// ❌ Description(textarea)은 Filter 없음
// WHERE Description = 'test'  → 오류
```

---

### Group

SOQL `GROUP BY` 절에 포함 가능. **API v18.0 이상.**

- `Aggregatable`과 함께 사용

```apex
// Group 속성이 있는 필드만 GROUP BY 사용 가능
AggregateResult[] grouped = [
    SELECT Industry, COUNT(Id) cnt
    FROM Account
    GROUP BY Industry  // Industry: Group 있음
];
```

---

### idLookup

`upsert()` 호출 시 외부 ID 필드로 사용하여 레코드를 식별 가능.

- 모든 오브젝트의 `Id` 필드에 기본 설정
- 일부 `Name`, `Email` 필드에도 설정 (오브젝트별 상이)
- **`upsert()`에 사용하려면 반드시 해당 필드에 `idLookup` 속성 확인** — 없으면 사용 불가

```apex
// upsert 시 외부 ID 필드 사용 (idLookup 속성 필요)
Contact con = new Contact(
    Email    = 'john@acme.com',  // Email: idLookup 있음
    LastName = 'Smith'
);
upsert con Contact.Email; // Email로 중복 체크 후 insert/update
```

---

### Namepointing

이 `reference` 필드가 polymorphic parent (여러 오브젝트 타입을 가리킬 수 있음)를 나타낼 때 `true`.

- 예: `Task.WhoId` → `Contact` 또는 `Lead` 가리킴
- `Task.WhatId` → `Account`, `Opportunity`, `Campaign`, `Case` 가리킴

```apex
// Namepointing 확인
Schema.DescribeFieldResult whoIdDesc =
    Task.WhoId.getDescribe();
System.debug('isNamePointing: ' + whoIdDesc.isNamePointing()); // true
```

---

### Nillable

필드에 `null` 값을 허용.

- `Nillable = false`인 필드는 필수 필드 (반드시 값 필요)

```apex
// Nillable 필드 확인 후 null 허용 여부 결정
Schema.DescribeFieldResult f =
    Opportunity.CloseDate.getDescribe();
if (!f.isNillable()) {
    System.debug('CloseDate is required');
}
```

---

### Query

SOQL `SELECT` 절에서 조회 가능.

- `Query` 속성이 없는 필드는 SELECT에 포함 불가

---

### Restricted picklist

Salesforce 어드민이 정의한 값만 허용하는 피클리스트.

- API에서도 목록 외 값 설정 시 오류
- `DescribeFieldResult.isRestrictedPicklist() = true`

```apex
// Restricted picklist 여부 확인
Schema.DescribeFieldResult f =
    Lead.LeadSource.getDescribe();
System.debug('isRestricted: ' + f.isRestrictedPicklist());
```

---

### Retrieve

`retrieve()`, `query()` 호출로 필드 값을 가져올 수 있음.

- 대부분의 필드에 있으며, 일부 쓰기 전용(write-only) 필드는 없음

---

### Sort

SOQL `ORDER BY` 절에서 정렬 가능.

```apex
// Sort 속성이 있는 필드만 ORDER BY 사용 가능
List<Account> sorted = [
    SELECT Id, Name, CreatedDate
    FROM Account
    ORDER BY CreatedDate DESC  // CreatedDate: Sort 있음
];
```

---

### Update

`update()` 호출로 필드 값을 변경 가능.

- `Update` 없는 필드는 UPDATE 시 무시됨 (예: `Id`, `CreatedDate`, `SystemModstamp`)

---

## Property 전체 요약표

| Property | Apex describe 메서드 | 설명 |
|---|---|---|
| Aggregatable | `isAggregatable()` | SOQL 집계 함수·GROUP BY 사용 가능 |
| Autonumber | `isAutoNumber()` | 시스템이 자동 번호 생성, 지정 불가 |
| Create | `isCreateable()` | INSERT 시 값 지정 가능 |
| Defaulted on create | `isDefaultedOnCreate()` | 지정 없으면 시스템이 기본값 설정 |
| Delete | — | DELETE 허용 |
| Filter | `isFilterable()` | SOQL WHERE 절 사용 가능 |
| Group | `isGroupable()` | SOQL GROUP BY 사용 가능 (v18+) |
| idLookup | `isIdLookup()` | upsert 외부 ID로 사용 가능 |
| Namepointing | `isNamePointing()` | Polymorphic reference 필드 (여러 타입 가리킴) |
| Nillable | `isNillable()` | null 값 허용 |
| Query | `isAccessible()` | SELECT 조회 가능 |
| Restricted picklist | `isRestrictedPicklist()` | 관리자 정의 값만 허용 |
| Retrieve | — | retrieve()·query() 조회 가능 |
| Sort | `isSortable()` | ORDER BY 정렬 가능 |
| Update | `isUpdateable()` | UPDATE 시 값 변경 가능 |

---

## Required Fields 규칙

### create() 시 필수 필드 처리

| 유형 | 동작 |
|---|---|
| 시스템 필드 (Id, CreatedDate 등) | API가 자동으로 채움 (지정 불필요) |
| `Defaulted on create = true` 필드 | 지정하지 않으면 시스템이 기본값 할당 |
| FK 성격의 필수 필드 (예: `OpportunityId`) | 클라이언트가 반드시 명시적 값 지정 (null 불가) |

### update() 시 필수 필드 처리

- 필수 필드를 `null`로 변경 불가
- 많은 필수 필드는 변경 자체가 불가 (예: `Id`, 일부 시스템 필드)

### 선택 필드

- 오브젝트 describe에서 "required"로 표시되지 않은 모든 필드는 선택 사항 (null 허용)
- 일부 필수 필드는 특수 처리가 필요 — 각 오브젝트 문서 확인

---

## 관련 노트

- [[1 Overview]] — Ch1 전체 요약
- [[Field Types]] — 각 필드 타입별 특성 (reference·picklist 등)
- [[System Fields]] — System Fields 상세 (CreatedDate·SystemModstamp 등)
- [[SOQL 문법 레퍼런스]] — Filter·Sort·Group 속성을 실제 SOQL에 적용하는 방법
