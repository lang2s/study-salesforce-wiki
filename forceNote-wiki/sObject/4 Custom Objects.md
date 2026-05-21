---
tags: [sobject-reference, custom-objects, custom-metadata, mdt, apex, field-service]
source: object_reference.pdf p.78-94 (v67.0 Summer '26)
created: 2026-05-22
aliases: [4 Custom Objects, __mdt 필드, __c 필드, __Feed 필드, FSL Time Dependency, Custom Metadata 표준 필드]
---

# 4 Custom Objects — __mdt·__c·__Feed 표준 필드

> 커스텀 Object 생성 시 Salesforce가 자동으로 추가하는 표준 필드 목록 + Custom Metadata(__mdt) 상세

---

## 개요

커스텀 Object를 생성하거나 기능(공유 규칙 등)을 활성화하면 Salesforce가 자동으로 보조 Object를 생성한다.

| 생성 조건 | 생성되는 Object |
|---|---|
| 커스텀 Object 생성 | `Object__c` |
| Feed Tracking 활성화 | `Object__Feed` |
| Field History Tracking 활성화 | `Object__History` |
| Sharing Rules 활성화 | `Object__Share`, `Object__OwnerSharingRule` |
| CDC 활성화 | `Object__ChangeEvent` |

---

## FSL__Time_Dependency__c

Field Service 관리 패키지(`FSL`)에 포함된 커스텀 Object. 두 Service Appointment 간 스케줄 의존성을 정의한다.

**지원 호출**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

**특수 접근 규칙**: Field Service 관리 패키지 설치 Org에서만 사용 가능.

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `FSL__Dependency__c` | picklist | 의존성 유형: `Immediately Follow`, `Same Start`, `Start After Finish`, `Start After Finish And Same Day`. 기본값: `Same Start` |
| `FSL__Root_Service_Appointment__c` | reference → ServiceAppointment | 의존 체인의 루트 ServiceAppointment. 시스템 자동 설정, API 생성 시 비워두기 권장 |
| `FSL__Same_Resource__c` | boolean | 두 SA가 동일 Service Resource로 배정되어야 하는지 여부. 기본값 `false` |
| `FSL__Service_Appointment_1__c` | reference → ServiceAppointment | 선행 SA (Master-detail) |
| `FSL__Service_Appointment_2__c` | reference → ServiceAppointment | 후행 SA (Lookup, Nillable) |
| `Name` | string | 자동번호(Autonumber) |

---

## Custom Metadata Type `__mdt`

커스텀 메타데이터 레코드. API v34.0+.

**지원 호출**: `describeSObjects()`, `describeLayout()`, `query()`, `retrieve()` (DML 없음)

> [!note] 배포와 패키지로만 레코드를 관리. API에서는 읽기 전용.

### 필드

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `Custom Field__c` | Any Type | Nillable | 레코드의 커스텀 필드 값 |
| `DeveloperName` | string | Filter, Group, Sort | API 이름 (영문자·숫자·언더스코어. 공백·특수문자 불가) |
| `isProtected` | boolean | — | 보호 여부. `true`: 같은 패키지 코드만 접근 가능 |
| `Label` | picklist | Nillable | 레코드 레이블 (MasterLabel과 동일) |
| `Language` | string | Restricted picklist | 개발 Org 기본 언어 |
| `MasterLabel` | string | Filter, Group, Sort | 기본 레이블 |
| `NamespacePrefix` | string | Nillable | 네임스페이스 접두사 (최대 15자) |
| `QualifiedApiName` | string | Nillable | `NamespacePrefix__DeveloperName` 형식 |
| `SystemModStamp` | dateTime | Filter, Sort | 마지막 수정 일시. API v56.0+ |

### `isProtected` 동작

```
같은 패키지 내 코드       → 레코드 읽기 가능
같은 패키지 내 타입 코드   → 레코드 읽기 가능
다른 패키지 코드          → 보호된 레코드 접근 불가
구독자/비관리 패키지 코드  → 보호된 레코드 접근 불가

※ SOQL, SOAP, REST API, Setup에서도 동일 규칙 적용
※ 보호 레코드의 DeveloperName은 릴리즈 후 변경 불가
```

### SOQL 패턴

```apex
// Custom Metadata 조회
List<MyConfig__mdt> configs = [
    SELECT DeveloperName, MasterLabel, Value__c, IsActive__c
    FROM MyConfig__mdt
    WHERE IsActive__c = true
];

// QualifiedApiName으로 특정 레코드 조회
MyConfig__mdt config = MyConfig__mdt.getInstance('MyRecord');
```

---

## Custom Object `__c`

사용자 정의 Object의 표준 필드.

**지원 호출**: `create()`, `delete()`, `describeLayout()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`, `search()`, `undelete()`, `update()`, `upsert()`

### 표준 필드

| 필드 | 타입 | 속성 | 설명 |
|---|---|---|---|
| `Id` | ID | Aggregatable, Filter, Group, idLookup, Sort | 18자 레코드 고유 ID |
| `Name` | string | Aggregatable, Create, Filter, Group, idLookup, Sort, Update | Object 이름 (최대 80자). null 불허 |
| `OwnerId` | reference | Aggregatable, Create, Filter, Group, Namepointing, Sort, Update | 소유자 User ID |
| `RecordTypeId` | reference | Create, Filter, Nillable, Update | 레코드 타입 ID |
| `CreatedById` | reference | Aggregatable, Filter, Group, Sort | 생성 User ID |
| `CreatedDate` | dateTime | Aggregatable, Filter, Sort | 생성 일시 |
| `LastModifiedById` | reference | Aggregatable, Filter, Group, Sort | 마지막 수정 User ID |
| `LastModifiedDate` | dateTime | Aggregatable, Filter, Sort | 마지막 수정 일시 |
| `SystemModStamp` | dateTime | Aggregatable, Filter, Sort | 트리거·자동화 포함 마지막 변경 |
| `IsDeleted` | boolean | Filter, Group, Sort | 휴지통 이동 여부 |
| `LastActivityDate` | dateTime | Filter, Group, Nillable, Sort | 최근 Event/Task 날짜 |
| `LastReferencedDate` | dateTime | Aggregatable, Filter, Sort, Nillable | 현재 사용자가 마지막으로 조회·수정한 일시 (탭 생성 후 사용 가능) |
| `LastViewedDate` | dateTime | Aggregatable, Filter, Sort, Nillable | 현재 사용자가 마지막으로 직접 조회한 일시 |
| `ConnectionReceivedId` | reference | Filter, Nillable | S2S로 공유받은 PartnerNetworkConnection ID |
| `ConnectionSentId` | reference | Filter, Nillable | S2S로 공유한 PartnerNetworkConnection ID (v15.0 이전만) |
| `CurrencyIsoCode` | picklist | Filter, Group, Restricted picklist, Sort | 다중통화 Org에서의 통화 ISO 코드 |

---

## Custom Object `__Feed`

커스텀 Object의 Chatter 피드. `CustomObject__Feed` 형식 (예: `Textile__Feed`).

**지원 호출**: `delete()`, `describeSObjects()`, `getDeleted()`, `getUpdated()`, `query()`, `retrieve()`

### 특수 접근 규칙

- 자신이 만든 피드 아이템 삭제 가능
- Experience Cloud(thread blocking): 중첩 콘텐츠 있는 아이템은 Moderator 또는 Modify All Data 권한 필요
- 삭제 권한: `Modify All Data`, `Modify All Records on {Object}`, `Moderate Chatter`

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `BestCommentId` | reference | 베스트 댓글 ID |
| `Body` | textarea | 포스트 본문 |
| `CommentCount` | int | 댓글 수 |
| `ContentDocumentId` | reference | 첨부 ContentDocument ID |
| `InsertedById` | reference | 피드에 아이템을 추가한 User ID |
| `IsRichText` | boolean | Rich text 여부 |
| `LikeCount` | int | 좋아요 수 |
| `LinkUrl` | url | LinkPost URL |
| `ParentId` | reference | 부모 Object 레코드 ID |
| `RelatedRecordId` | reference | ContentPost의 ContentVersion ID |
| `Title` | string | 피드 아이템 제목 |
| `Type` | picklist | 피드 타입 |
| `Visibility` | picklist | `AllUsers` / `InternalUsers` |

### SOQL 패턴

```apex
// 커스텀 Object 피드 최근 포스트 조회
List<Textile__Feed> posts = [
    SELECT Body, Type, CreatedBy.Name, CreatedDate, LikeCount
    FROM Textile__Feed
    WHERE ParentId = :textileId
    ORDER BY CreatedDate DESC
    LIMIT 20
];

// 추적된 필드 변경만 조회
List<Textile__Feed> changes = [
    SELECT Body, Type, CreatedDate
    FROM Textile__Feed
    WHERE ParentId = :textileId
    AND Type = 'TrackedChange'
    ORDER BY CreatedDate DESC
];
```

---

## 관련 노트

- [[1 Overview]] — Field 타입·API 속성 기초
- [[2 Object Behavior]] — Object 타입·접미어별 분류 (__c/__mdt/__Feed 비교)
- [[3 Associated Objects]] — Feed·History·Share·ChangeEvent 패턴 상세
- [[DML 패턴]] — insert/update/upsert 패턴
- [[SOQL 패턴]] — SOQL for loop, WITH USER_MODE
