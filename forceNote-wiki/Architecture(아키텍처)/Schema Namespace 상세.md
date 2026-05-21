---
tags: [apex, schema, namespace, describe, describesobject, describefield, recordtype, picklist, child-relationship, sobjecttype, sobjectfield, displaytype, soaptype, describetab, datacategory]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
updated: 2026-05-22
aliases: [Schema Namespace, DescribeSObjectResult, DescribeFieldResult, RecordTypeInfo, PicklistEntry, ChildRelationship, Schema.getGlobalDescribe, 오브젝트 메타데이터, 필드 메타데이터, SObjectType, SObjectField, DisplayType, SOAPType, FieldDescribeOptions, SObjectDescribeOptions, DescribeTabResult, DescribeTabSetResult, DataCategory, DescribeColorResult, DescribeIconResult]
---

# Schema Namespace 상세 레퍼런스

> Schema namespace 전체 클래스 — SObject·필드·레코드 타입·피클리스트·자식 관계 메타데이터 조회.

---

## 기본 Describe 패턴

```apex
// SObject Describe
Schema.DescribeSObjectResult objDesc = Account.SObjectType.getDescribe();

// 단축 표현
Schema.DescribeSObjectResult objDesc2 = Schema.SObjectType.Account;

// 동적 오브젝트 이름으로 조회
Schema.SObjectType sObjType = Schema.getGlobalDescribe().get('Account');
Schema.DescribeSObjectResult dynDesc = sObjType.getDescribe();

// 필드 Describe
Schema.DescribeFieldResult fieldDesc = Account.Name.getDescribe();
Schema.DescribeFieldResult fieldDesc2 = Account.Type.getDescribe();
```

---

## DescribeSObjectResult — 오브젝트 메타데이터

```apex
Schema.DescribeSObjectResult d = Account.SObjectType.getDescribe();

// 기본 정보
d.getName()              // 'Account'
d.getLabel()             // 'Account' (사용자 정의 이름 반영)
d.getLabelPlural()       // 'Accounts'
d.getLocalName()         // 네임스페이스 없는 이름
d.getKeyPrefix()         // '001' (ID 3자리 접두어)

// 권한 체크
d.isAccessible()         // 현재 사용자가 볼 수 있는지
d.isCreateable()         // 생성 가능 여부
d.isUpdateable()         // 수정 가능 여부
d.isDeletable()          // 삭제 가능 여부
d.isUndeletable()        // 복원 가능 여부
d.isQueryable()          // SOQL 조회 가능 여부
d.isSearchable()         // SOSL 검색 가능 여부
d.isMergeable()          // 병합 가능 여부 (Account/Contact/Lead)

// 오브젝트 특성
d.isCustom()             // 커스텀 오브젝트 여부
d.isCustomSetting()      // 커스텀 설정 여부
d.isFeedEnabled()        // Chatter Feed 사용 여부

// 필드 맵 조회
Map<String, Schema.SObjectField> fieldMap = d.fields.getMap();
// 또는
Map<String, Schema.SObjectField> fieldMap2 =
    Schema.SObjectType.Account.fields.getMap();

// 필드셋 조회
Map<String, Schema.FieldSet> fieldSets = d.fieldSets.getMap();

// SObjectType 토큰
Schema.SObjectType sObjType = d.getSObjectType();
SObject newRecord = sObjType.newSObject();

// 자식 관계
List<Schema.ChildRelationship> children = d.getChildRelationships();
```

### DescribeSObjectResult 추가 메서드 (전수)

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAssociateEntityType()` | `String` | 연관 오브젝트의 타입 (예: `History`) |
| `getAssociateParentEntity()` | `String` | 연관 오브젝트의 부모 (예: `Account`) |
| `getDataTranslationEnabled()` | `Boolean` | 데이터 번역 활성화 여부 |
| `getSObjectDescribeOption()` | `Schema.SObjectDescribeOptions` | 시스템이 사용한 describe 옵션 반환 |
| `isMruEnabled()` | `Boolean` | MRU(최근 사용 목록) 기능 활성화 여부 |
| `isDeprecatedAndHidden()` | `Boolean` | 예약 — 항상 false |
| `getDefaultImplementation()` | `String` | 예약 — 미래 사용 |
| `getHasSubtypes()` | `Boolean` | 예약 — 미래 사용 |
| `getImplementedBy()` | `String` | 예약 — 미래 사용 |
| `getImplementsInterfaces()` | `String` | 예약 — 미래 사용 |
| `getIsInterface()` | `Boolean` | 예약 — 미래 사용 |
| `hashCode()` | `Integer` | sObject 해시 코드 |
| `toString()` | `String` | sObject 문자열 표현 |

```apex
// AccountHistory처럼 연관 오브젝트의 부모/타입 확인
Schema.DescribeSObjectResult d = AccountHistory.SObjectType.getDescribe();
String entityType   = d.getAssociateEntityType();   // 'History'
String parentEntity = d.getAssociateParentEntity();  // 'Account'

// MRU 목록 사용 가능 여부
Boolean mruEnabled = Account.SObjectType.getDescribe().isMruEnabled();

// 데이터 번역 활성화 여부
Boolean translatable = Account.SObjectType.getDescribe().getDataTranslationEnabled();
```

---

## DescribeFieldResult — 필드 메타데이터

```apex
Schema.DescribeFieldResult fd = Account.Type.getDescribe();

// 기본 정보
fd.getName()             // 'Type' — API 이름
fd.getLabel()            // 'Account Type' — 레이블
fd.getLocalName()        // 네임스페이스 없는 이름
fd.getLength()           // 최대 문자 수
fd.getByteLength()       // 최대 바이트 수
fd.getDigits()           // 정수 필드 최대 자릿수
fd.getPrecision()        // Double 전체 자릿수
fd.getScale()            // Double 소수점 이하 자릿수
fd.getInlineHelpText()   // 필드 레벨 도움말 텍스트

// 타입 정보
fd.getType()             // Schema.DisplayType enum
fd.getSOAPType()         // Schema.SOAPType enum
fd.getDefaultValue()     // 기본값
fd.getCalculatedFormula() // 수식 문자열 (수식 필드)

// 권한 체크
fd.isAccessible()
fd.isCreateable()
fd.isUpdateable()
fd.isNillable()          // null 허용 여부
fd.isRequired()          // 필수 여부 (계산값 — isNillable && !isDefaultedOnCreate)

// 필드 특성
fd.isCustom()
fd.isAutoNumber()
fd.isCalculated()        // 수식 필드 여부
fd.isExternalID()
fd.isUnique()
fd.isCaseSensitive()
fd.isFilterable()
fd.isSortable()
fd.isGroupable()         // GROUP BY 사용 가능 여부
fd.isEncrypted()         // Shield Platform Encryption 여부
fd.isNameField()         // 이름 필드 여부

// 피클리스트 여부
fd.isDependentPicklist()
fd.isRestrictedPicklist()

// 참조 필드
fd.getReferenceTo()      // List<Schema.SObjectType> — 참조 오브젝트 목록
fd.getRelationshipName() // 자식→부모 관계 이름
fd.isNamePointing()      // 다중 타입 참조 여부 (WhoId, WhatId 등)

// 필드 토큰
Schema.SObjectField fieldToken = fd.getSObjectField();
Schema.SObjectType sourceObj = fd.getSObjectType();
```

### DescribeFieldResult 추가 메서드 (전수)

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getController()` | `Schema.SObjectField` | 종속 피클리스트의 컨트롤러 필드 토큰 |
| `getDefaultValueFormula()` | `String` | 기본값 수식 문자열 |
| `getReferenceTargetField()` | `String` | 외부 오브젝트 간접 조회 관계에서 부모 오브젝트의 매칭 기준 필드 이름 |
| `getRelationshipOrder()` | `Integer` | 주 관계 필드 = 0, 보조 관계 필드 = 1 |
| `isAiPredictionField()` | `Boolean` | Einstein 예측 데이터 표시 활성화 여부 (Beta) |
| `isCascadeDelete()` | `Boolean` | 부모 삭제 시 자식도 삭제 여부 |
| `isDefaultedOnCreate()` | `Boolean` | 생성 시 기본값이 채워지는지 여부 |
| `isDeprecatedAndHidden()` | `Boolean` | 예약 — 항상 false |
| `isFormulaTreatNullNumberAsZero()` | `Boolean` | 수식 필드에서 null 숫자를 0으로 처리하는지 여부 |
| `isHtmlFormatted()` | `Boolean` | HTML로 포맷되어 있는 필드인지 여부 (예: 하이퍼링크 수식) |
| `isIdLookup()` | `Boolean` | upsert 메서드에서 레코드 식별자로 사용 가능 여부 |
| `isPermissionable()` | `Boolean` | 필드 수준 보안 설정 가능 여부 |
| `isRestrictedDelete()` | `Boolean` | 자식 레코드가 있을 때 부모 삭제 금지 여부 |
| `isSearchPrefilterable()` | `Boolean` | SOSL WHERE 절 prefilter로 외래 키 포함 가능 여부 |
| `isWriteRequiresMasterRead()` | `Boolean` | 디테일 오브젝트 쓰기에 마스터 읽기 공유만 필요한지 여부 |

```apex
// 종속 피클리스트 컨트롤러 필드
Schema.DescribeFieldResult depFd = Account.DependentPicklist__c.getDescribe();
if (depFd.isDependentPicklist()) {
    Schema.SObjectField ctrlToken = depFd.getController();
    System.debug('컨트롤러: ' + ctrlToken.getDescribe().getName());
}

// upsert 외부 ID 필드 확인
Boolean isExternalId = Account.External_Id__c.getDescribe().isIdLookup();

// HTML 포맷 필드 인코딩 필요 여부
Boolean needsEncoding = fd.isHtmlFormatted();
```

---

## RecordTypeInfo — 레코드 타입 조회

```apex
Schema.DescribeSObjectResult d = Account.SObjectType.getDescribe();

// 모든 레코드 타입 목록
List<Schema.RecordTypeInfo> rtInfos = d.getRecordTypeInfos();

// API 이름으로 직접 조회 (권장)
Map<String, Schema.RecordTypeInfo> rtByDevName =
    d.getRecordTypeInfosByDeveloperName();
Id rtId = rtByDevName.get('Enterprise_Account').getRecordTypeId();

// 레이블로 조회
Map<String, Schema.RecordTypeInfo> rtByName = d.getRecordTypeInfosByName();

// ID로 조회
Map<Id, Schema.RecordTypeInfo> rtById = d.getRecordTypeInfosById();

// RecordTypeInfo 메서드
Schema.RecordTypeInfo rt = rtByDevName.get('Enterprise_Account');
rt.getRecordTypeId()          // Id
rt.getName()                  // 레이블
rt.getDeveloperName()         // API 이름
rt.isAvailable()              // 현재 사용자에게 사용 가능 여부
rt.isActive()                 // 활성화 여부
rt.isMaster()                 // Master 레코드 타입 여부
```

---

## PicklistEntry — 피클리스트 값 조회

```apex
// 활성 피클리스트 값만 반환
List<Schema.PicklistEntry> entries = Account.Type.getDescribe().getPicklistValues();

for (Schema.PicklistEntry pe : entries) {
    pe.getValue()         // API 값
    pe.getLabel()         // 화면 표시 레이블
    pe.isActive()         // 활성 여부
    pe.isDefaultValue()   // 기본값 여부
}

// 실용 패턴 — 피클리스트 값 목록을 Map으로 변환
Map<String, String> picklistMap = new Map<String, String>();
for (Schema.PicklistEntry pe : Account.Type.getDescribe().getPicklistValues()) {
    if (pe.isActive()) {
        picklistMap.put(pe.getValue(), pe.getLabel());
    }
}
```

---

## ChildRelationship — 자식 관계 조회

```apex
Schema.DescribeSObjectResult d = Account.SObjectType.getDescribe();
List<Schema.ChildRelationship> children = d.getChildRelationships();

for (Schema.ChildRelationship cr : children) {
    cr.getRelationshipName()  // 관계 이름 (예: 'Contacts', 'Opportunities')
    cr.getChildSObject()      // Schema.SObjectType — 자식 오브젝트 타입
    cr.getField()             // Schema.SObjectField — 외래 키 필드
    cr.isCascadeDelete()      // 부모 삭제 시 자식도 삭제 여부
    cr.isRestrictedDelete()   // 자식 있을 때 부모 삭제 금지 여부
}

// 자식 오브젝트 이름 추출
List<String> childNames = new List<String>();
for (Schema.ChildRelationship cr : children) {
    if (cr.getRelationshipName() != null) {
        childNames.add(cr.getChildSObject().getDescribe().getName());
    }
}
```

---

## 전역 Describe — 모든 오브젝트 탐색

```apex
// 전체 오브젝트 메타데이터 맵 (한도 주의 — 무거운 작업)
Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();

// 동적으로 오브젝트 존재 여부 확인
Boolean exists = globalDescribe.containsKey('My_Object__c');

// 동적 오브젝트로 레코드 생성
Schema.SObjectType sObjType = globalDescribe.get('Account');
if (sObjType != null) {
    SObject newRecord = sObjType.newSObject();
    newRecord.put('Name', 'Dynamic Account');
}
```

---

## DisplayType Enum — 필드 타입 값

`DescribeFieldResult.getType()`이 반환하는 열거형.

| DisplayType 값 | 설명 |
|---|---|
| `ADDRESS` | 주소 값 |
| `ANYTYPE` | 임의 타입 (String/Boolean/Integer/Double/Percent/ID/Date/DateTime/URL/Email 중 하나) |
| `BASE64` | Base64 인코딩 바이너리 |
| `BOOLEAN` | 체크박스 |
| `COMBOBOX` | 콤보박스 (열거형 + 자유 입력 허용) |
| `COMPLEXVALUE` | Complex Value Type (CVT) |
| `CURRENCY` | 통화 |
| `DATACATEGORYGROUPREFERENCE` | 데이터 카테고리 그룹/카테고리 참조 |
| `DATE` | 날짜 |
| `DATETIME` | 날짜/시간 |
| `DOUBLE` | 실수 |
| `EMAIL` | 이메일 |
| `ENCRYPTEDSTRING` | 암호화 텍스트 (Shield Platform Encryption) |
| `FLOATARRAY` | 실수 배열 (예약) |
| `ID` | ID (기본 키) |
| `INTEGER` | 정수 |
| `JSON` | JSON 형식 |
| `LOCATION` | 위치 (위도·경도) |
| `LONG` | Long 정수 |
| `MULTIPICKLIST` | 다중 선택 피클리스트 |
| `PERCENT` | 퍼센트 |
| `PHONE` | 전화번호 |
| `PICKLIST` | 피클리스트 |
| `REFERENCE` | 조회 관계 (외래 키) |
| `SOBJECT` | sObject 변수 |
| `STRING` | 텍스트 |
| `TEXTAREA` | 긴 텍스트 |
| `TEXTARRAY` | 텍스트 배열 (예약) |
| `TIME` | 시간 |
| `URL` | URL (하이퍼링크) |

---

## SOAPType Enum — SOAP 타입 값

`DescribeFieldResult.getSOAPType()`이 반환하는 열거형.

| SOAPType 값 | 설명 |
|---|---|
| `anytype` | String·Boolean·Integer·Double·ID·Date·DateTime 중 임의 타입 |
| `base64binary` | Base64 인코딩 임의 바이너리 |
| `Boolean` | Boolean (true/false) |
| `Date` | 날짜 |
| `DateTime` | 날짜/시간 |
| `Double` | 실수 |
| `ID` | 기본 키 필드 ID |
| `Integer` | 정수 |
| `String` | 문자열 |
| `Time` | 시간 |

---

## FieldDescribeOptions Enum

`SObjectField.getDescribe(options)` 및 `SObjectType.getDescribe(options)` 파라미터로 사용.

| 값 | 설명 |
|---|---|
| `DEFAULT` | 컨텍스트에 따라 eager-load 또는 lazy-load 선택 |
| `FULL_DESCRIBE` | 피클리스트 값 등 모든 describe 결과를 완전히 계산 |

```apex
// 컨텍스트 의존 피클리스트 필드 describe 시 사용
Schema.DescribeFieldResult fd =
    AIConversationContext.PersonType.getDescribe(Schema.FieldDescribeOptions.FULL_DESCRIBE);
```

---

## SObjectDescribeOptions Enum

`SObjectType.getDescribe(options)` 파라미터로 사용. 자식 관계 로딩 방식 결정.

| 값 | 설명 |
|---|---|
| `DEFAULT` | API 버전에 따라 eager/lazy 결정 (v44.0+ = Lazy) |
| `DEFERRED` | 자식 관계를 첫 접근 시 lazy-load |
| `FULL` | 자식 관계를 포함한 모든 요소를 즉시 eager-load |

```apex
// v44.0+에서 자식 관계까지 즉시 로드
Schema.DescribeSObjectResult d =
    Account.SObjectType.getDescribe(Schema.SObjectDescribeOptions.FULL);
```

---

## SObjectField Class

`DescribeFieldResult.getSObjectField()`, `DescribeFieldResult.getController()` 등이 반환하는 필드 토큰.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDescribe()` | `Schema.DescribeFieldResult` | 이 필드의 describe 결과 반환 |
| `getDescribe(options)` | `Schema.DescribeFieldResult` | FieldDescribeOptions 파라미터로 describe 반환 |

```apex
Schema.DescribeFieldResult fd = Account.Industry.getDescribe();
Schema.SObjectField token = fd.getSObjectField();

// 토큰으로 다시 describe 조회
Schema.DescribeFieldResult fd2 = token.getDescribe();

// 컨텍스트 의존 필드는 FULL_DESCRIBE 사용
Schema.DescribeFieldResult fd3 =
    token.getDescribe(Schema.FieldDescribeOptions.FULL_DESCRIBE);
```

---

## SObjectType Class

`DescribeFieldResult.getReferenceTo()`, `DescribeSObjectResult.getSObjectType()` 등이 반환하는 sObject 타입 토큰.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDescribe()` | `Schema.DescribeSObjectResult` | sObject describe 결과 반환 |
| `getDescribe(options)` | `Schema.DescribeSObjectResult` | SObjectDescribeOptions 파라미터로 describe 반환 |
| `newSObject()` | `sObject` | 이 타입의 새 sObject 인스턴스 생성 |
| `newSObject(id)` | `sObject` | 지정 ID를 가진 새 sObject 생성 |
| `newSObject(recordTypeId, loadDefaults)` | `sObject` | 레코드 타입 + 기본값 로드 옵션으로 새 sObject 생성 |

```apex
// 기본 사용
Schema.SObjectType sObjType = Account.SObjectType;
Schema.DescribeSObjectResult d = sObjType.getDescribe();

// 새 sObject 생성
SObject newAcct = Account.SObjectType.newSObject();
newAcct.put('Name', 'Acme');

// 특정 ID를 가진 sObject (기존 레코드 업데이트용)
SObject existing = Account.SObjectType.newSObject(existingId);

// 레코드 타입 + 기본값 로드 (커스텀 필드 기본값 포함)
Id rtId = Account.SObjectType.getDescribe()
    .getRecordTypeInfosByDeveloperName().get('Enterprise').getRecordTypeId();
Account acctWithDefaults = (Account) Account.SObjectType.newSObject(rtId, true);
acctWithDefaults.Name = 'Acme';  // 필수 필드는 직접 설정
insert acctWithDefaults;

// 동적 SObjectType 사용
Schema.SObjectType dynamicType = Schema.getGlobalDescribe().get('My_Custom__c');
SObject record = dynamicType.newSObject();

// 자식 관계까지 eager-load
Schema.DescribeSObjectResult fullDesc =
    Account.SObjectType.getDescribe(Schema.SObjectDescribeOptions.FULL);
```

---

## 자주 쓰는 조합 패턴

```apex
// 1. 동적 필드 순회 — 모든 커스텀 필드 조회
Map<String, Schema.SObjectField> fieldMap =
    Schema.SObjectType.Account.fields.getMap();
for (String fieldName : fieldMap.keySet()) {
    Schema.DescribeFieldResult fd = fieldMap.get(fieldName).getDescribe();
    if (fd.isCustom() && fd.isAccessible()) {
        System.debug(fd.getName() + ' (' + fd.getType() + ')');
    }
}

// 2. 권한 체크 후 DML
Schema.DescribeSObjectResult d = Account.SObjectType.getDescribe();
if (d.isCreateable()) {
    insert new Account(Name = 'Test');
}

// 3. 레코드 타입 ID 조회 (하드코딩 ID 대신)
Id enterpriseRtId = Account.SObjectType.getDescribe()
    .getRecordTypeInfosByDeveloperName()
    .get('Enterprise')
    .getRecordTypeId();

// 4. FieldSet 조회 및 필드 목록 추출
Schema.FieldSet fs = Schema.SObjectType.Account
    .fieldSets.getMap().get('My_Field_Set');
List<String> fieldNames = new List<String>();
for (Schema.FieldSetMember fsm : fs.getFields()) {
    fieldNames.add(fsm.getFieldPath());
    // fsm.getType()    — DisplayType
    // fsm.getLabel()   — 레이블
    // fsm.isRequired() — 필수 여부
}
```

---

---

## ChildRelationship 추가 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getChildSObject()` | `Schema.SObjectType` | 자식 오브젝트 타입 토큰 |
| `getField()` | `Schema.SObjectField` | 외래 키 필드 토큰 |
| `getRelationshipName()` | `String` | 관계 이름 |
| `isCascadeDelete()` | `Boolean` | 부모 삭제 시 자식도 삭제 여부 |
| `isRestrictedDelete()` | `Boolean` | 자식 존재 시 부모 삭제 금지 여부 |
| `isDeprecatedAndHidden()` | `Boolean` | 예약 — 항상 false |

---

## DataCategory Class

Salesforce Knowledge 또는 Answers의 데이터 카테고리를 나타냄.
`DescribeDataCategoryGroupStructureResult.getTopCategories()`가 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getChildCategories()` | `List<Schema.DataCategory>` | 하위 카테고리 목록 (재귀) |
| `getLabel()` | `String` | UI 레이블 |
| `getName()` | `String` | API 이름 |

```apex
// 데이터 카테고리 트리 순회
List<Schema.DescribeDataCategoryGroupStructureResult> results =
    Schema.describeDataCategoryGroupStructures(pairs, true);
for (Schema.DescribeDataCategoryGroupStructureResult r : results) {
    for (Schema.DataCategory cat : r.getTopCategories()) {
        System.debug(cat.getName() + ' (' + cat.getLabel() + ')');
        for (Schema.DataCategory child : cat.getChildCategories()) {
            System.debug('  └ ' + child.getName());
        }
    }
}
```

---

## DataCategoryGroupSobjectTypePair Class

`Schema.describeDataCategoryGroupStructures()` 입력 파라미터.

```apex
Schema.DataCategoryGroupSobjectTypePair pair = new Schema.DataCategoryGroupSobjectTypePair();
pair.setSobject('KnowledgeArticleVersion');    // 또는 'Question'
pair.setDataCategoryGroupName('Regions');
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `new DataCategoryGroupSobjectTypePair()` | — | 기본 생성자 |
| `getDataCategoryGroupName()` | `String` | 카테고리 그룹 이름 조회 |
| `getSobject()` | `String` | 연결된 sObject 이름 조회 |
| `setDataCategoryGroupName(name)` | `void` | 카테고리 그룹 이름 설정 |
| `setSobject(sObjectName)` | `void` | sObject 설정 (`KnowledgeArticleVersion` 또는 `Question`) |

---

## DescribeDataCategoryGroupResult Class

`Schema.describeDataCategoryGroups(objectTypes)` 반환값.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getCategoryCount()` | `Integer` | 가시적 데이터 카테고리 수 |
| `getDescription()` | `String` | 카테고리 그룹 설명 |
| `getLabel()` | `String` | UI 레이블 |
| `getName()` | `String` | API 이름 |
| `getSobject()` | `String` | 연결된 sObject 이름 |

```apex
List<String> objTypes = new List<String>{ 'KnowledgeArticleVersion', 'Question' };
List<Schema.DescribeDataCategoryGroupResult> groups =
    Schema.describeDataCategoryGroups(objTypes);
for (Schema.DescribeDataCategoryGroupResult g : groups) {
    System.debug(g.getName() + ' — ' + g.getCategoryCount() + '개 카테고리');
}
```

---

## DescribeDataCategoryGroupStructureResult Class

`Schema.describeDataCategoryGroupStructures(pairs, topCategoriesOnly)` 반환값.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDescription()` | `String` | 카테고리 그룹 설명 |
| `getLabel()` | `String` | UI 레이블 |
| `getName()` | `String` | API 이름 |
| `getSobject()` | `String` | 연결된 sObject 이름 |
| `getTopCategories()` | `List<Schema.DataCategory>` | 최상위 카테고리 목록 (사용자 가시성 기준) |

---

## DescribeColorResult Class

탭(tab)의 색상 메타데이터. `DescribeTabResult.getColors()`가 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getColor()` | `String` | RGB 색상 코드 (예: `1797C0`) |
| `getContext()` | `String` | 색상 컨텍스트 (`primary` 등) |
| `getTheme()` | `String` | 테마 (`theme3`, `theme4`, `custom`) |

```apex
List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
for (Schema.DescribeTabSetResult tsr : tabSetDesc) {
    if (tsr.getLabel() == 'Sales') {
        List<Schema.DescribeColorResult> colors = tsr.getTabs()[0].getColors();
        System.debug('Primary color: ' + colors[0].getColor()); // '1797C0'
        System.debug('Theme: ' + colors[0].getTheme());         // 'theme4'
    }
}
```

---

## DescribeIconResult Class

탭(tab)의 아이콘 메타데이터. `DescribeTabResult.getIcons()`가 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getContentType()` | `String` | 콘텐츠 타입 (예: `image/png`) |
| `getHeight()` | `Integer` | 높이(px). SVG이면 0 |
| `getTheme()` | `String` | 테마 (`theme3`, `theme4`, `custom`) |
| `getUrl()` | `String` | 아이콘 완전 URL |
| `getWidth()` | `Integer` | 너비(px) |

---

## DescribeTabResult Class

Salesforce 앱의 탭(tab) 메타데이터. `DescribeTabSetResult.getTabs()`가 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getColors()` | `List<Schema.DescribeColorResult>` | 탭 색상 목록 |
| `getIconUrl()` | `String` | 32×32 기본 아이콘 URL (theme3) |
| `getIcons()` | `List<Schema.DescribeIconResult>` | 탭 아이콘 목록 |
| `getLabel()` | `String` | 탭 표시 레이블 |
| `getMiniIconUrl()` | `String` | 16×16 미니 아이콘 URL (theme3) |
| `getSobjectName()` | `String` | 탭에 표시되는 기본 sObject 이름 |
| `getUrl()` | `String` | 탭 완전 URL |
| `isCustom()` | `Boolean` | 커스텀 탭이면 true, 표준 탭이면 false |

---

## DescribeTabSetResult Class

Salesforce Classic 표준/커스텀 앱 메타데이터. `Schema.describeTabs()`가 반환.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDescription()` | `String` | 앱 설명 |
| `getLabel()` | `String` | 앱 표시 레이블 |
| `getLogoUrl()` | `String` | 앱 로고 이미지 완전 URL |
| `getNamespace()` | `String` | AppExchange 관리 패키지 네임스페이스 (없으면 `''`) |
| `getTabs()` | `List<Schema.DescribeTabResult>` | 앱의 탭 목록 |
| `isSelected()` | `Boolean` | 현재 사용자가 선택한 앱이면 true |

```apex
// 앱·탭 메타데이터 탐색
List<Schema.DescribeTabSetResult> appDescs = Schema.describeTabs();
for (Schema.DescribeTabSetResult app : appDescs) {
    System.debug('앱: ' + app.getLabel() + ', 탭 수: ' + app.getTabs().size());
    if (app.isSelected()) {
        System.debug('→ 현재 선택된 앱');
    }
}

// 특정 탭의 sObject 이름 확인
for (Schema.DescribeTabSetResult app : appDescs) {
    for (Schema.DescribeTabResult tab : app.getTabs()) {
        System.debug(tab.getLabel() + ' → ' + tab.getSobjectName());
    }
}
```

---

## 관련 노트

- [[Apex 표준 클래스 레퍼런스]] — Schema 섹션 기본 개요
- [[DML 패턴]] — isCreateable/isUpdateable 체크 후 DML
- [[SOQL 패턴]] — 동적 필드를 이용한 동적 SOQL 구성
- [[Safely]] — StripInaccessible, CanTheUser — FLS 필드 필터링
