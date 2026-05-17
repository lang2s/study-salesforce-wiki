---
tags: [apex, schema, namespace, describe, describesobject, describefield, recordtype, picklist, child-relationship]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Schema Namespace, DescribeSObjectResult, DescribeFieldResult, RecordTypeInfo, PicklistEntry, ChildRelationship, Schema.getGlobalDescribe, 오브젝트 메타데이터, 필드 메타데이터]
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

| DisplayType 값 | 설명 |
|---|---|
| `STRING` | 텍스트 |
| `TEXTAREA` | 긴 텍스트 |
| `EMAIL` | 이메일 |
| `PHONE` | 전화번호 |
| `URL` | URL |
| `INTEGER` | 정수 |
| `DOUBLE` | 실수 |
| `DECIMAL` | 통화 |
| `DATE` | 날짜 |
| `DATETIME` | 날짜/시간 |
| `BOOLEAN` | 체크박스 |
| `PICKLIST` | 피클리스트 |
| `MULTIPICKLIST` | 다중 선택 피클리스트 |
| `REFERENCE` | 조회 관계 |
| `ID` | ID |
| `BLOB` | 바이너리 |
| `ENCRYPTEDSTRING` | 암호화 텍스트 |

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

## 관련 노트

- [[Apex 표준 클래스 레퍼런스]] — Schema 섹션 기본 개요
- [[DML 패턴]] — isCreateable/isUpdateable 체크 후 DML
- [[SOQL 패턴]] — 동적 필드를 이용한 동적 SOQL 구성
- [[Safely]] — StripInaccessible, CanTheUser — FLS 필드 필터링
