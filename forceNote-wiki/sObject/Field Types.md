---
tags: [sobject-reference, field-types, api, wsdl, id-field, junction-list, picklist, reference, compound]
source: object_reference.pdf p.4-10 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Field Types, anyType, calculated, combobox, currency, email, encryptedstring, ID Field Type, JunctionIdList, location, masterrecord, multipicklist, percent, phone, picklist, reference, textarea, url, 필드 타입]
---

# Field Types

> WSDL에 정의된 API 필드 타입 전수. Primitive 타입을 확장하며, `DescribeSObjectResult.fields[].type`으로 확인.

---

## 개념

Field Type은 Primitive Data Type을 확장한 Salesforce API 고유 데이터 타입이다. WSDL에 정의되며, 각 필드 메타데이터의 `type` 속성에 열거된다.

> [!note] 문자열 길이 초과 처리 (API v15.0+)
> `anyType`, `email`, `encryptedstring`, `multipicklist`, `phone`, `picklist`, `string`, `textarea`는 API v15.0부터 길이 초과 시 `STRING_TOO_LONG` 오류. `AllowFieldTruncationHeader`로 이전 truncation 동작 복원 가능.

---

## Field Type 전수

### address

여러 주소 구성 요소를 하나의 구조체로 묶은 복합 데이터 타입.

- `Account.BillingAddress`, `Contact.MailingAddress` 등에 적용
- SOAP/REST API v30.0+에서 접근 가능
- 자세한 내용: [[Compound Fields]]

---

### anyType

반환 타입이 동적으로 결정되는 다형(polymorphic) 타입.

- 가능한 반환 타입: `string`, `picklist`, `reference`, `boolean`, `currency`, `int`, `double`, `percent`, `ID`, `date`, `datetime`, `url`, `email`
- **주 사용처:** History 오브젝트의 `NewValue`, `OldValue` 필드
- 대부분의 SOAP 툴킷이 자동으로 적절한 네이티브 타입으로 역직렬화

```apex
// History Object에서 anyType 필드 읽기
List<AccountHistory> history = [
    SELECT Field, OldValue, NewValue
    FROM AccountHistory
    WHERE AccountId = :someAccountId
];
for (AccountHistory h : history) {
    System.debug(h.Field + ': ' + h.OldValue + ' → ' + h.NewValue);
}
```

---

### calculated

수식으로 값이 결정되는 읽기 전용 필드.

- **규칙:**
  - SOQL 필터(WHERE) 사용 가능, 하지만 Replication(getUpdated/getDeleted)에서는 제외
  - 텍스트 수식 필드: 최대 **3,900자** — 초과분은 잘림
- UI에서는 "Formula Field"로 표시

```apex
// 수식 필드 조회 (읽기 전용, INSERT/UPDATE 불가)
List<Opportunity> opps = [
    SELECT Id, Name, ForecastCategoryName  // ForecastCategoryName은 calculated
    FROM Opportunity
    WHERE ForecastCategoryName = 'Commit'
];
```

---

### combobox

열거형 값 목록을 제공하지만 사용자가 목록에 없는 값도 직접 입력 가능한 필드.

- 내부적으로 `string` 타입으로 정의

---

### currency

통화 값을 저장하는 필드. 내부적으로 `double` 타입.

- **대표 예:** `Campaign.ExpectedRevenue`
- **다중통화(multicurrency) 활성화 시:**
  - `CurrencyIsoCode` 필드가 해당 오브젝트의 레코드 통화를 정의
  - 모든 currency 필드는 `CurrencyIsoCode`의 통화로 표현
  - `CurrencyIsoCode`를 변경하면 해당 레코드의 모든 currency 필드값이 새 통화 코드로 암묵적 변환
  - 같은 `update()` 호출에서 currency 값을 함께 지정하면, 해당 값은 **새 통화 코드** 기준으로 해석 (변환 없음)
  - `CurrencyIsoCode`는 Restricted picklist — 허용되지 않는 코드를 설정하면 오류 발생
  - UI 표시 시 통화값 앞에 `CurrencyIsoCode`와 공백을 붙이는 것을 권장: `"USD 1,234.56"`
  - 통화 전환율은 `CurrencyType` 오브젝트에서 조회

```apex
// 다중통화 환경에서 통화 처리
Account acc = [SELECT AnnualRevenue, CurrencyIsoCode FROM Account LIMIT 1];
System.debug(acc.CurrencyIsoCode + ' ' + acc.AnnualRevenue);

// CurrencyType으로 환율 조회
List<CurrencyType> rates = [
    SELECT IsoCode, ConversionRate
    FROM CurrencyType
    WHERE IsActive = true
];
```

---

### DataCategoryGroupReference

Salesforce Knowledge나 Answers의 데이터 카테고리 그룹/카테고리를 참조하는 필드.

- 모든 Knowledge 기사 및 질문 오브젝트에 두 개의 DataCategoryGroupReference 필드 존재 (카테고리 그룹 + 카테고리 고유 이름)
- `describeDataCategoryGroups()`, `describeDataCategoryGroupStructures()` API 호출로 카테고리 구조 조회

```apex
// Knowledge 카테고리 그룹 조회
List<DescribeDataCategoryGroupResult> groups = 
    Schema.describeDataCategoryGroups(new List<String>{'KnowledgeArticleVersion'});
```

---

### email

이메일 주소를 저장하는 필드.

- 클라이언트가 유효하고 올바른 형식의 이메일 주소를 `create()`/`update()` 시 직접 검증해야 함
- API v15.0+: 최대 길이 초과 시 `STRING_TOO_LONG` 반환

---

### encryptedstring

암호화된 텍스트를 저장하는 필드.

- 최대 **175자**
- **API v11.0 이상**에서 사용 가능
- 암호화된 상태로 저장

---

### floatarray

예약된 타입 — 현재 사용되지 않음 (Reserved for future use).

---

### ID

오브젝트의 기본키(primary key) 필드.

**두 가지 ID 형식:**

| 형식 | 길이 | 대소문자 | 권장 여부 |
|---|---|---|---|
| 15자 ID | 15자 | Case-sensitive | ❌ 사용 금지 (대소문자 구분 앱에서만 안전) |
| 18자 ID | 18자 | Case-safe (case-insensitive 앱에서도 안전) | ✅ 항상 18자 사용 권장 |

- 마지막 3자리 = 앞 15자리의 대소문자를 인코딩 (변환: 18자 → 15자는 마지막 3자 truncation)
- 각 ID에는 **3자리 접두사**가 포함되어 있으며, 오브젝트 타입을 식별
- `update()` 호출로 ID 필드를 변경할 수 없음 (생성 후 고정)
- `.NET`, `WSC` 등 대부분의 Web services 도구는 ID를 `string`으로 매핑

> [!warning] 15자 ID 위험
> Microsoft Access 등 case-insensitive 애플리케이션에서 `000000000000Abc`와 `000000000000aBC`를 같은 값으로 처리. 18자 ID 사용으로 이 문제 방지.

```apex
// ID 형식 확인
Id accountId = [SELECT Id FROM Account LIMIT 1].Id;
System.debug(accountId.length()); // 18
System.debug(accountId.getSObjectType()); // Schema.Account

// ID를 String으로 변환하면 18자
String idStr = (String) accountId;
System.debug(idStr.length()); // 18
```

---

### JunctionIdList

다대다(many-to-many) 관계를 직접 조작하는 ID 배열 타입. **API v34.0 이상.**

- WSDL에서는 ID의 언바운드 배열(`ID[]`)로 표현
- `Task.TaskWhoIds`, `Event.EventWhoIds` 등에 사용
- 쿼리·업데이트를 junction 레코드를 직접 조작하지 않고 처리 가능

**제한 사항:**

| 제약 | 내용 |
|---|---|
| SOQL 레코드 한도 | `(엔티티 레코드 수) × (JunctionIdList 항목 수) < 500` |
| `fieldsToNull` 사용 | 해당 필드를 `fieldsToNull`에 추가하면 관련 junction 레코드 **전체 삭제** (되돌릴 수 없음) |
| Apex에서 | **읽기 전용** — 값 설정 시 예외 발생 |

```apex
// TaskWhoIds 조회 (JunctionIdList)
List<Task> tasks = [
    SELECT Id, Subject, TaskWhoIds
    FROM Task
    WHERE LastModifiedDate > LAST_WEEK
];
for (Task t : tasks) {
    System.debug('Task: ' + t.Subject + ', Whos: ' + t.TaskWhoIds);
}

// 한도 초과 방지: parent/child 쿼리로 대체
// ❌ 한도 초과 위험
// SELECT Subject, CcIds FROM EmailMessage (101건 × 5 = 505 > 500)

// ✅ parent/child 쿼리로 대체
List<EmailMessage> emails = [
    SELECT Subject,
           (SELECT Id FROM EmailMessageRelations WHERE RelationType = 'CcAddress')
    FROM EmailMessage
];
```

---

### location

위도·경도를 묶은 지리좌표계 복합 데이터 타입.

- `latitude`, `longitude` 두 서브필드 포함
- API v26.0 이상에서 복합 필드로 접근 가능
- 자세한 내용: [[Compound Fields]]

---

### masterrecord

레코드 병합(merge) 시 살아남은(유지되는) 레코드의 ID.

- 병합된 레코드의 `IsDeleted = true` 상태에서만 의미 있음

---

### multipicklist

여러 값을 동시에 선택할 수 있는 피클리스트.

- 선택된 값은 **세미콜론(`;`) 구분 문자열**로 저장: `"first value;second value;third value"`
- SOQL에서 `=`, `!=`, `INCLUDES`, `EXCLUDES` 사용

```apex
// multipicklist 값 필터 (INCLUDES)
List<Contact> contacts = [
    SELECT Id, Name, Languages__c
    FROM Contact
    WHERE Languages__c INCLUDES ('Korean', 'English')
];

// multipicklist 값 설정
Contact con = new Contact(
    LastName    = 'Kim',
    Languages__c = 'Korean;English'  // 세미콜론으로 구분
);
```

---

### percent

백분율 값. 내부적으로 `double` 타입.

- UI 표시 시 `%` 기호 추가

---

### phone

전화번호를 저장하는 필드.

- 알파벳 문자 포함 가능 (`1-800-FLOWERS` 형태)
- 클라이언트가 전화번호 형식 검증 및 포맷팅 담당
- API v15.0+: 최대 길이 초과 시 `STRING_TOO_LONG`

---

### picklist

하나의 값만 선택 가능한 드롭다운 목록.

**Restricted vs Unrestricted:**

| 구분 | 설명 |
|---|---|
| `restrictedPicklist = true` | Restricted picklist — Salesforce 어드민이 정의한 값만 허용. API에서도 목록 외 값 불가. |
| `restrictedPicklist = false` | Unrestricted(advisory) picklist — API에서 목록 외 값 설정 가능. 없는 값 설정 시 "inactive" 상태로 생성. |

**값 vs 레이블:**
- `PicklistEntry.value` = 실제 저장되는 값 (언어 불변)
- `PicklistEntry.label` = UI 표시 레이블 (다국어 지원)
- DML 시 항상 `value` 사용, SOQL도 `value` 반환
- UI 표시 시에는 `label` 사용

**특수 피클리스트 오브젝트 (읽기 전용):**

| 오브젝트 | 대응 필드 |
|---|---|
| `CaseStatus` | `Case.Status` |
| `ContractStatus` | `Contract.Status` |
| `LeadStatus` | `Lead.Status` |
| `OpportunityStage` | `Opportunity.StageName` |
| `PartnerRole` | — |
| `SolutionStatus` | — |
| `TaskPriority` | `Task.Priority` |
| `TaskStatus` | `Task.Status` |

이 오브젝트들은 해당 피클리스트의 모든 값과 추가 정보(예: 전환 여부)를 포함. API로 쿼리는 가능하나 수정은 UI에서만 가능.

```apex
// Picklist 값 조회 (describe 사용)
Schema.DescribeFieldResult fieldResult =
    Opportunity.StageName.getDescribe();
List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
for (Schema.PicklistEntry entry : entries) {
    System.debug(entry.getValue() + ' (' + entry.getLabel() + ')');
}

// Picklist 값 설정 (value 사용)
Opportunity opp = new Opportunity(
    Name       = 'Test',
    StageName  = 'Prospecting',   // value 사용
    CloseDate  = Date.today().addDays(30)
);

// Unrestricted picklist에서 목록 외 값 설정
Contact con = new Contact(
    LastName = 'Test',
    Title    = 'Custom Title Not In List'  // Title은 unrestricted picklist
);
```

---

### reference

다른 오브젝트의 레코드 ID를 저장하는 외래키(foreign key) 필드.

- 필드명 관례: 접미사 `Id` (예: `CaseId`, `OwnerId`, `AccountId`)
- `update()` 호출로 변경 가능 (ID 필드와 달리)
- `OpportunityCompetitor.OpportunityId` → `Opportunity` 오브젝트의 단일 레코드 참조

**Polymorphic reference (교차 참조 ID):**
- `Task.WhoId` → `Contact` 또는 `Lead` 중 하나
- `Task.WhatId` → `Account`, `Opportunity`, `Campaign`, `Case` 중 하나
- `WhoId`가 `Lead`를 가리키면 `WhatId`는 비워야 함

**참조 무결성:**
- 비어있지 않은 reference 값은 해당 org의 유효한 레코드를 가리킴이 보장
- 단, 쿼리 권한은 별도로 필요 — "View All Data" 없으면 접근 제한 가능

```apex
// reference 필드 조회 및 업데이트
Opportunity opp = [
    SELECT Id, AccountId, Account.Name
    FROM Opportunity
    WHERE Id = :someOppId
];
System.debug(opp.Account.Name); // 부모 Account 이름

// reference 필드 업데이트 (외래키 변경)
opp.AccountId = newAccountId;
update opp;

// WhoId/WhatId polymorphic 처리
Task t = [SELECT Id, WhoId, WhatId, Who.Name FROM Task LIMIT 1];
System.debug(t.Who.Name); // Contact 또는 Lead 이름
```

---

### textarea

4,000 바이트를 초과할 수 있는 멀티라인 텍스트 필드.

- **SOQL WHERE 절에 사용 불가** — `filterable = false`
- WHERE 절 필터가 필요하면 레코드를 먼저 가져온 후 Apex에서 처리
- Rich Text Area = textarea의 확장형 (HTML 포맷 지원)

```apex
// textarea는 WHERE에 사용 불가
// ❌ 불가:
// SELECT Id FROM Account WHERE Description = 'test'

// ✅ 모든 레코드 가져와서 Apex 필터
List<Account> accs = [SELECT Id, Name, Description FROM Account];
List<Account> filtered = new List<Account>();
for (Account a : accs) {
    if (a.Description != null && a.Description.contains('test')) {
        filtered.add(a);
    }
}
```

---

### textarray

예약된 타입 — 현재 사용되지 않음 (Reserved for future use).

---

### url

URL을 저장하는 필드.

- 클라이언트가 유효하고 올바른 형식의 URL을 `create()`/`update()` 시 직접 검증해야 함
- UI에서는 하이퍼링크로 표시

---

## Field Type 요약표

| 필드 타입 | 내부 타입 | 주요 특징 |
|---|---|---|
| `address` | 복합 | Address 구조체, SOAP/REST API v30+ |
| `anyType` | 동적 | History OldValue/NewValue, 자동 역직렬화 |
| `calculated` | 다양 | 수식 필드, 읽기 전용, 텍스트 최대 3900자 |
| `combobox` | `string` | 열거형 + 사용자 입력 허용 |
| `currency` | `double` | 다중통화 CurrencyIsoCode 연동 |
| `DataCategoryGroupReference` | `string` | Knowledge/Answers 카테고리 참조 |
| `email` | `string` | 이메일 형식, v15.0+ STRING_TOO_LONG |
| `encryptedstring` | `string` | 암호화 저장, v11.0+, 최대 175자 |
| `floatarray` | — | 예약 (미사용) |
| `ID` | `string` | 18자 case-safe, 3자 prefix, update 불가 |
| `JunctionIdList` | `ID[]` | 다대다 직접 조작, v34+, Apex 읽기 전용 |
| `location` | 복합 | latitude/longitude, v26+ |
| `masterrecord` | `ID` | 병합 후 살아남은 레코드 ID |
| `multipicklist` | `string` | 세미콜론 구분, INCLUDES/EXCLUDES |
| `percent` | `double` | 백분율, UI에 % 표시 |
| `phone` | `string` | 알파벳 포함 가능, 클라이언트 포맷 책임 |
| `picklist` | `string` | 단일 선택, restricted 여부 확인 필요 |
| `reference` | `ID` | 외래키, 끝에 Id 접미사, update 가능 |
| `textarea` | `string` | WHERE 불가, 4000+ 바이트 |
| `textarray` | — | 예약 (미사용) |
| `url` | `string` | URL 형식, 클라이언트 검증 책임 |

---

## 관련 노트

- [[1 Overview]] — Ch1 전체 요약
- [[Primitive Data Types]] — Field Type 기반이 되는 SOAP 기본 타입 10개
- [[API Field Properties]] — 각 필드에 붙는 속성 (Filter·Sort·Nillable 등)
- [[Compound Fields]] — address·location 복합 필드 상세
- [[3 Associated Objects]] — anyType이 사용되는 History 오브젝트 패턴
- [[SOQL 문법 레퍼런스]] — multipicklist INCLUDES/EXCLUDES, JunctionIdList 쿼리
