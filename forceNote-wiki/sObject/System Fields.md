---
tags: [sobject-reference, system-fields, audit-fields, ownerid, record-type, created-date, lastmodified, systemmodstamp]
source: object_reference.pdf p.12-15 (v67.0 Summer '26)
created: 2026-05-22
aliases: [System Fields, Audit Fields, 시스템 필드, 감사 필드, CreatedDate, LastModifiedDate, SystemModstamp, IsDeleted, OwnerId, RecordTypeId, CurrencyIsoCode, Frequently Occurring Fields]
---

# System Fields

> 대부분의 오브젝트에 자동으로 존재하는 읽기 전용 시스템 필드 9개 + 자주 등장하는 공통 필드 3개 전수 참조.

---

## 개념

System Fields는 거의 모든 오브젝트에 자동으로 생성되며 API 작업 중 자동으로 갱신된다. 예를 들어 `Id`는 `create()` 시 자동 생성되고, `LastModifiedDate`는 레코드 수정 시 자동 갱신된다.

필드 테이블에 별도 나열하지 않아도 존재하는 필드이므로, 특정 오브젝트 문서에서 System Field를 찾을 수 없어도 기본적으로 있다고 가정할 수 있다.

---

## System Fields 전수

### Id

| 항목 | 내용 |
|---|---|
| 타입 | `ID` |
| Properties | `Defaulted on create`, `Filter` |
| 설명 | 레코드를 전역에서 고유하게 식별하는 18자 ID. `create()` 시 자동 생성. `update()` 불가. |

```apex
// Id 조회
Account acc = [SELECT Id, Name FROM Account LIMIT 1];
System.debug(acc.Id); // e.g. 001Qy00000AbCdEAAZ
```

---

### IsDeleted

| 항목 | 내용 |
|---|---|
| 타입 | `boolean` |
| Properties | `Defaulted on create`, `Filter`, `Group`, `Sort` |
| 설명 | 레코드가 휴지통(Recycle Bin)으로 이동했으면 `true`. SOQL에서 기본적으로 `false`인 레코드만 반환. |

```apex
// 삭제된 레코드 포함 조회 (ALL ROWS)
List<Account> deleted = [
    SELECT Id, Name, IsDeleted
    FROM Account
    WHERE IsDeleted = true
    ALL ROWS
];
```

---

### LastReferencedDate

| 항목 | 내용 |
|---|---|
| 타입 | `dateTime` |
| Properties | `Aggregatable`, `Filter`, `Sort`, `Nillable` |
| 설명 | 현재 사용자가 이 레코드, 관련 레코드, 또는 목록 뷰를 마지막으로 조회/수정한 일시. null이면 조회한 적 없음. 커스텀 오브젝트 탭이 있는 경우에만 커스텀 오브젝트에 존재. |

---

### LastViewedDate

| 항목 | 내용 |
|---|---|
| 타입 | `dateTime` |
| Properties | `Aggregatable`, `Filter`, `Sort`, `Nillable` |
| 설명 | 현재 사용자가 이 레코드를 마지막으로 조회/수정한 일시. null이면 조회한 적 없음. 커스텀 오브젝트 탭이 있는 경우에만 커스텀 오브젝트에 존재. |

> [!note] LastReferencedDate vs LastViewedDate
> - `LastReferencedDate`: 이 레코드 **또는 관련 레코드/목록 뷰** 기준
> - `LastViewedDate`: **이 레코드 자체**만 기준

---

### CreatedById

| 항목 | 내용 |
|---|---|
| 타입 | `reference` |
| Properties | `Aggregatable`, `Defaulted on create`, `Filter`, `Group`, `Sort` |
| 설명 | 레코드를 생성한 User의 ID. `create()` 시 자동 설정. |

---

### CreatedDate

| 항목 | 내용 |
|---|---|
| 타입 | `dateTime` |
| Properties | `Aggregatable`, `Defaulted on create`, `Filter`, `Sort` |
| 설명 | 레코드가 생성된 일시(UTC). `create()` 시 자동 설정. |

```apex
// 최근 7일 내 생성된 레코드 조회
List<Case> recentCases = [
    SELECT Id, Subject, CreatedDate
    FROM Case
    WHERE CreatedDate >= LAST_N_DAYS:7
    ORDER BY CreatedDate DESC
];
```

---

### LastModifiedById

| 항목 | 내용 |
|---|---|
| 타입 | `reference` |
| Properties | `Aggregatable`, `Defaulted on create`, `Filter`, `Group`, `Sort` |
| 설명 | 레코드를 마지막으로 수정한 User의 ID. `update()` 시 자동 갱신. |

---

### LastModifiedDate

| 항목 | 내용 |
|---|---|
| 타입 | `dateTime` |
| Properties | `Aggregatable`, `Defaulted on create`, `Filter`, `Sort` |
| 설명 | 사용자가 레코드를 마지막으로 수정한 일시(UTC). `update()` 시 자동 갱신. |

---

### SystemModstamp

| 항목 | 내용 |
|---|---|
| 타입 | `dateTime` |
| Properties | `Aggregatable`, `Defaulted on create`, `Filter`, `Sort` |
| 설명 | 사용자 또는 **자동화 프로세스(Salesforce 내부 코드, 트리거 제외)**에 의해 레코드가 마지막으로 변경된 일시. Replication에서 변경 감지 기준으로 사용. |

> [!note] LastModifiedDate vs SystemModstamp
> - `LastModifiedDate`: 사용자 수정만 추적
> - `SystemModstamp`: 사용자 + 자동화 처리 모두 추적 (replication 시 사용)
> - 단, 오브젝트 A가 오브젝트 B에서 값을 조회하는 경우, B 레코드 변경이 A의 `SystemModstamp`에는 반영되지 않음

---

## Audit Fields 규칙

### 유효 날짜 범위

Audit Fields(dateTime 타입)의 허용 범위:

| 항목 | 값 |
|---|---|
| 최솟값 | `1970-01-01T00:00:00Z` (UTC 자정) |
| 최댓값 | `4000-12-31T00:00:00Z` (UTC 자정) |
| 타임존 오프셋 예 | 태평양 표준시: 최솟값 = `1969-12-31T16:00:00` |

### 감사 필드 직접 설정

import 시 소스 시스템의 감사 필드 값을 유지하려면 아래 절차를 따른다:

1. Setup > User Interface > "Set Audit Fields upon Record Creation" 및 "Update Records with Inactive Owners" 사용자 권한 활성화
2. 감사 필드를 설정할 프로파일/권한 세트에 `Set Audit Fields upon Record Creation` 권한 부여
3. API로 레코드 생성 시 감사 필드 값 명시

**직접 설정 가능한 오브젝트:** Account, ArticleVersion, Attachment, CampaignMember, Case, CaseComment, Contact, ContentVersion, Contract, Event, Idea, IdeaComment, Lead, Opportunity, Question, Task, Vote, 커스텀 오브젝트

> [!warning] SystemModstamp는 직접 설정 불가

### 부모 참조 필드 패턴

오브젝트에 부모 관계가 있으면 두 필드가 추가된다:
- `ParentName` — 부모 오브젝트 이름 (예: `Case.Contact`)
- `ParentNameId` — 부모 레코드 ID (예: `Case.ContactId`)

```apex
// 부모 참조 필드 SOQL 패턴
SELECT Case.ContactId, Case.Contact.Name FROM Case
```

---

## Frequently Occurring Fields (자주 등장하는 공통 필드)

System Fields는 아니지만 대부분의 오브젝트에 공통으로 있는 세 필드.

---

### OwnerId

| 항목 | 내용 |
|---|---|
| 타입 | `reference` |
| Properties | `Aggregatable`, `Create`, `Defaulted on create`, `Filter`, `Group`, `Namepointing`, `Sort`, `Update` |
| 설명 | 레코드를 소유한 User의 ID. 소유권은 보안 모델과 공유 설정에 직접 영향. |

**특성 및 제한:**

| 규칙 | 내용 |
|---|---|
| INSERT 기본값 | 대부분의 경우 INSERT 시 현재 로그인 사용자로 자동 설정 (직접 지정 불가) |
| Case·Lead 예외 | Case/Lead 생성 시 충분한 권한이 있으면 임의 User 또는 Queue로 지정 가능 |
| 연쇄 변경 없음 | API로 OwnerId 변경 시 해당 레코드만 변경. UI의 전체 소유권 이전과 달리 관련 레코드에 cascade되지 않음 |
| Account 특이 | Account의 OwnerId 변경 시 기존 공유 정보 삭제 후 org-wide default 및 공유 규칙 재적용 |
| 변경 권한 | `Transfer Record` 권한 + 신규 소유자의 Read 접근 필요 |
| Opportunity Teams (v12.0+) | Account/Opportunity의 OwnerId 변경 시 `RowCause = Sales Team`인 공유 레코드 유지 (v11.0 이하: 삭제) |

```apex
// OwnerId 변경 (권한 필요)
Opportunity opp = [SELECT Id, OwnerId FROM Opportunity LIMIT 1];
opp.OwnerId = newOwnerId;  // Transfer Record 권한 필요
update opp;

// Case 생성 시 Queue에 할당
Case newCase = new Case(
    Subject = 'Support Request',
    OwnerId = queueId     // Queue ID로 설정 가능
);
insert newCase;
```

---

### RecordTypeId

| 항목 | 내용 |
|---|---|
| 타입 | `reference` |
| Properties | `Create`, `Filter`, `Nillable`, `Update` |
| 설명 | 레코드에 연결된 `RecordType`의 ID. 비즈니스 프로세스·피클리스트 값·페이지 레이아웃을 프로파일별로 제어. |

**특성:**
- 유효한 RecordType ID 값은 `RecordType` 오브젝트를 SOQL로 조회해서 가져옴
- 조직에 Record Type이 하나도 없으면 WSDL에 이 필드가 포함되지 않음
- **`CampaignMember`의 RecordType는 직접 설정 불가** → `Campaign.CampaignMemberRecordTypeId`로 설정

```apex
// RecordType 조회 후 레코드 생성
RecordType rt = [
    SELECT Id
    FROM RecordType
    WHERE SObjectType = 'Opportunity'
      AND DeveloperName = 'Enterprise'
    LIMIT 1
];
Opportunity opp = new Opportunity(
    Name          = 'Big Deal',
    RecordTypeId  = rt.Id,
    StageName     = 'Prospecting',
    CloseDate     = Date.today().addDays(90)
);
```

---

### CurrencyIsoCode

| 항목 | 내용 |
|---|---|
| 타입 | `picklist` (Restricted) |
| 설명 | 다중통화(multicurrency) 활성화 시에만 존재. 레코드의 통화 ISO 코드(예: `USD`, `EUR`, `KRW`). |

**특성:**
- `User.DefaultCurrencyIsoCode` — 해당 사용자의 기본 통화 (CurrencyIsoCode와 별개)
- 레코드의 통화 필드는 모두 `CurrencyIsoCode` 기준으로 표현

```apex
// CurrencyIsoCode 조회
Account acc = [
    SELECT Id, Name, AnnualRevenue, CurrencyIsoCode
    FROM Account
    WHERE CurrencyIsoCode = 'USD'
    LIMIT 1
];
System.debug(acc.CurrencyIsoCode + ' ' + acc.AnnualRevenue);
```

---

## System Fields 요약표

| 필드 | 타입 | 읽기 전용 | 자동 설정 | 설명 |
|---|---|---|---|---|
| `Id` | ID | ✅ | create 시 | 18자 고유 식별자 |
| `IsDeleted` | boolean | ✅ | delete 시 | 휴지통 여부 |
| `LastReferencedDate` | dateTime | ✅ | 조회 시 | 현재 사용자의 마지막 참조 일시 |
| `LastViewedDate` | dateTime | ✅ | 조회 시 | 현재 사용자의 마지막 직접 조회 일시 |
| `CreatedById` | reference | ✅ | create 시 | 생성자 User ID |
| `CreatedDate` | dateTime | ✅ | create 시 | 생성 일시 (UTC) |
| `LastModifiedById` | reference | ✅ | update 시 | 마지막 수정자 User ID |
| `LastModifiedDate` | dateTime | ✅ | update 시 | 마지막 사용자 수정 일시 (UTC) |
| `SystemModstamp` | dateTime | ✅ | 변경 시 | 마지막 변경 일시 (사용자+자동화) |

---

## 관련 노트

- [[1 Overview]] — Ch1 전체 요약
- [[API Field Properties]] — Defaulted on create·Filter·Aggregatable 속성 상세
- [[Custom Objects]] — 커스텀 오브젝트의 감사 필드 설정 절차
- [[Custom Object Standard Fields (__c)]] — 커스텀 오브젝트의 표준 필드 전수
- [[SOQL 문법 레퍼런스]] — LastModifiedDate·CreatedDate 날짜 필터 리터럴
