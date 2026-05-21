---
tags: [apex, soql, knowledge, data-category, with-절]
source: salesforce_soql_sosl.pdf p.33-38 (v67.0 Summer '26)
created: 2026-05-22
aliases: [WITH DATA CATEGORY, 데이터 카테고리 필터, Knowledge 카테고리 쿼리, SOQL 카테고리]
---

# SOQL WITH DATA CATEGORY

> Knowledge 아티클·Questions를 데이터 카테고리로 필터하는 SOQL WITH 절 — AT/ABOVE/BELOW/ABOVE_OR_BELOW 선택자, RecordVisibilityContext

---

## WITH 절 개요

SOQL의 `WITH` 절은 FROM에 지정된 Object 외의 기준으로 레코드를 필터한다. 네 가지 용도:

| WITH 절 | 용도 |
|---|---|
| `WITH DATA CATEGORY` | Knowledge 아티클·Question을 데이터 카테고리로 필터 |
| `WITH UserId` | UserProfileFeed 레코드 필터 |
| `WITH SECURITY_ENFORCED` | **v67.0 제거 → 사용 금지** |
| `WITH USER_MODE` | Apex CRUD·FLS 보안 적용 |
| `WITH RecordVisibilityContext` | 레코드 가시성 속성 조회 (API v48.0+) |

---

## WITH DATA CATEGORY 문법

```
SELECT fieldList
FROM KnowledgeArticleVersion | ArticleTypeName | Question
WHERE ...
WITH DATA CATEGORY dataCategoryGroupName filteringSelector dataCategoryName
           [AND dataCategoryGroupName filteringSelector dataCategoryName ...]
```

**제약:**
- `FROM`은 `KnowledgeArticleVersion`, 특정 아티클 타입 API명, 또는 `Question`만 허용
- KnowledgeArticleVersion이나 아티클 타입을 조회할 때 `WHERE`에 `PublishStatus` 또는 `Id` 필터 필수
- 바인드 변수(`:variable`) 불가
- 한 쿼리에 최대 **3개** 데이터 카테고리 조건
- 같은 카테고리 그룹을 한 쿼리에 두 번 사용 불가
- 논리 연산자는 `AND`만 지원 (`OR` 불가)

```apex
// ✅ 기본 예시 — 공개된 Knowledge 아티클을 Geography 카테고리로 필터
List<KnowledgeArticleVersion> arts = [
    SELECT Title, UrlName
    FROM KnowledgeArticleVersion
    WHERE PublishStatus = 'online'
    AND Language = 'en_US'
    WITH DATA CATEGORY Geography__c ABOVE usa__c
];

// ✅ Question 카테고리 필터
List<Question> qs = [
    SELECT Title
    FROM Question
    WHERE LastReplyDate > 2005-10-08T01:02:03Z
    WITH DATA CATEGORY Geography__c AT (usa__c, uk__c)
];

// ✅ 복수 카테고리 그룹 AND 조합 (최대 3개)
List<KnowledgeArticleVersion> multi = [
    SELECT UrlName
    FROM KnowledgeArticleVersion
    WHERE PublishStatus = 'draft'
    AND Language = 'en_US'
    WITH DATA CATEGORY Geography__c AT usa__c AND Product__c ABOVE_OR_BELOW mobile_phones__c
];
```

---

## filteringSelector — 4가지 선택자

다음 카테고리 계층 구조를 예시로 설명한다:

```
Geography__c
  ww__c
    northAmerica__c
      usa__c
      canada__c
      mexico__c
    europe__c
      france__c
      uk__c
    asia__c
```

| 선택자 | 범위 | 예시 결과 (Geography__c 기준) |
|---|---|---|
| `AT dataCategoryName` | 지정한 카테고리만 | `AT asia__c` → asia__c만 |
| `ABOVE dataCategoryName` | 지정 카테고리 + 모든 상위 카테고리 | `ABOVE usa__c` → usa__c, northAmerica__c, ww__c |
| `BELOW dataCategoryName` | 지정 카테고리 + 모든 하위 카테고리 | `BELOW northAmerica__c` → northAmerica__c, usa__c, canada__c, mexico__c |
| `ABOVE_OR_BELOW dataCategoryName` | 지정 카테고리 + 상위 + 하위 전부 | `ABOVE_OR_BELOW europe__c` → ww__c, europe__c, france__c, uk__c |

```apex
// AT — 정확히 해당 카테고리로 분류된 아티클
[SELECT Title FROM KnowledgeArticleVersion WHERE PublishStatus='online'
 WITH DATA CATEGORY Product__c AT mobile_phones__c]

// ABOVE — usa__c와 그 상위(northAmerica, ww) 카테고리 포함
[SELECT Title FROM KnowledgeArticleVersion WHERE PublishStatus='online'
 WITH DATA CATEGORY Geography__c ABOVE usa__c]

// BELOW — northAmerica__c와 하위 전부 (usa, canada, mexico)
[SELECT Title FROM KnowledgeArticleVersion WHERE PublishStatus='online'
 WITH DATA CATEGORY Geography__c BELOW northAmerica__c]

// ABOVE_OR_BELOW — europe__c 기준 상하 모두
[SELECT Title FROM KnowledgeArticleVersion WHERE PublishStatus='online'
 WITH DATA CATEGORY Geography__c ABOVE_OR_BELOW europe__c]
```

---

## 여러 카테고리 그룹 AND 조합

```apex
// Geography + Product 두 그룹 동시 적용
List<KnowledgeArticleVersion> arts = [
    SELECT Title, Summary
    FROM KnowledgeArticleVersion
    WHERE PublishStatus = 'online'
    AND Language = 'en_US'
    WITH DATA CATEGORY Geography__c ABOVE_OR_BELOW europe__c
                    AND Product__c BELOW All__c
];

// 한 그룹에 복수 카테고리 → 괄호 사용 (콤마로 구분)
List<KnowledgeArticleVersion> arts2 = [
    SELECT Id, Title
    FROM Offer__kav
    WHERE PublishStatus = 'draft'
    AND Language = 'en_US'
    WITH DATA CATEGORY Geography__c AT (france__c, usa__c)
                    AND Product__c ABOVE dsl__c
];
```

> [!caution] `WITH DATA CATEGORY Geography__c AT usa__c AND france__c` — **금지.** 같은 그룹에 여러 카테고리를 AND로 나열 불가. 괄호(`AT (usa__c, france__c)`)를 써야 한다.

---

## PublishStatus 값

| 값 | 의미 |
|---|---|
| `'online'` | 게시된 아티클 |
| `'archived'` | 보관된 아티클 |
| `'draft'` | 초안 |

```apex
// 공개 + 한국어 아티클
List<KnowledgeArticleVersion> koArts = [
    SELECT Title, VersionNumber
    FROM KnowledgeArticleVersion
    WHERE PublishStatus = 'online'
    AND Language = 'ko'
    WITH DATA CATEGORY Geography__c ABOVE asia__c
];
```

---

## WITH RecordVisibilityContext (API v48.0+)

레코드 가시성 속성(VisibilityAttribute)을 조회할 때 사용. 레코드 공유·도메인·위임 가시성을 제어한다.

```apex
// RecordVisibility 속성 조회
List<Account> accs = [
    SELECT Id, RecordVisibility.VisibilityAttribute
    FROM Account
    WHERE Id = :targetId
    WITH RecordVisibilityContext (
        maxDescriptorPerRecord = 100,
        supportsDomains        = true,
        supportsDelegates      = true
    )
];

// RecordVisibility Object 직접 쿼리
List<RecordVisibility> vis = [
    SELECT recordId, VisibilityAttribute
    FROM RecordVisibility
    WHERE recordId = :targetId
    WITH RecordVisibilityContext (maxDescriptorPerRecord = 100)
];
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `maxDescriptorPerRecord` | Integer | CRM Analytics org: 150 / 기타: 400 | 레코드당 최대 descriptor 수. 초과 시 `tooManyDescriptors` 반환 |
| `supportsDomains` | Boolean | `true` | domain 가시성 속성 생성 허용 |
| `supportsDelegates` | Boolean | `true` | delegate 가시성 속성 생성 허용 |

> [!important] `WITH RecordVisibilityContext` 뒤에 파라미터 없이 괄호만 쓰면 오류. 최소 1개 파라미터 필수.

---

## 관련 노트

- [[SOQL 문법 레퍼런스]] — WITH 절 보안 옵션 전체 (USER_MODE, SECURITY_ENFORCED)
- [[SOQL SOSL 소개]] — SOQL vs SOSL 선택 기준
- [[KbManagement Namespace]] — Apex에서 Knowledge 아티클 관리
- [[WITH USER_MODE]] — Apex CRUD·FLS 보안 적용 기준
- [[1 Overview]] — DataCategoryGroupReference 필드 타입 정의
