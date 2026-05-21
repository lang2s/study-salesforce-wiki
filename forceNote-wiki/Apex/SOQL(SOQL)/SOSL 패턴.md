---
tags: [apex, sosl, 검색, data, full-text-search, sosl-syntax, sosl-레퍼런스]
source: salesforce_soql_sosl.pdf p.95-130 (v67.0 Summer '26)
created: 2026-05-19
updated: 2026-05-21
aliases: [SOSL, SOSL 패턴, Salesforce Object Search Language, 전문 검색, SOSL 레퍼런스]
---

# SOSL 패턴

> SOSL(Salesforce Object Search Language)은 여러 Object를 동시에 전문 검색(full-text search)하는 쿼리 언어다. 검색 인덱스를 사용하므로 SOQL LIKE보다 빠르고, 어떤 Object에 데이터가 있는지 모를 때 유용하다.

---

## SOSL 전체 문법 구조

```
FIND {SearchQuery}
[ IN SearchGroup ]
[ RETURNING ObjectTypeName
    [(FieldList [WHERE conditionExpression]
                [USING Listview=listview]
                [ORDER BY Clause]
                [LIMIT n]
                [OFFSETn])]
    [toLabel(fields)] [convertCurrency(Amount)] [FORMAT()]
  [, ObjectTypeName [...]]
]
[ WITH DivisionFilter ]
[ WITH DATA CATEGORY DataCategorySpec ]
[ WITH SNIPPET[(target_length=n)] ]
[ WITH NETWORK NetworkIdSpec ]
[ WITH PricebookId ]
[ WITH METADATA ]
[ WITH HIGHLIGHT ]
[ WITH SPELL_CORRECTION ]
[ LIMIT n ]
[ UPDATE [TRACKING], [VIEWSTAT] ]
```

> [!note] OFFSET과 WHERE는 `RETURNING FieldSpec` 안에 포함된다.

---

## FIND 절 — 검색어 지정

### Apex vs API 구문 차이

| 환경 | 값 구분자 | 예시 |
|---|---|---|
| **Apex** | 작은따옴표 `''` | `[FIND 'map*' IN ALL FIELDS RETURNING Account]` |
| **API (REST/SOAP)** | 중괄호 `{}` | `FIND {map*} IN ALL FIELDS RETURNING Account` |

> [!note] Apex에서 IN ALL FIELDS 사용 시 System Mode는 FLS를 무시한다.

### 와일드카드

| 와일드카드 | 설명 | 예시 |
|---|---|---|
| `*` | 0개 이상 문자 (중간 또는 끝) | `john*` → john, johnson, johnny |
| `?` | 정확히 1개 문자 (중간 또는 끝) | `jo?n` → john, joan (jon은 불일치) |

> [!caution] `?`는 Lookup 검색에서 사용 불가.

### 논리 연산자

| 연산자 | 설명 |
|---|---|
| `AND` | 두 단어 모두 포함. 단, Article/Document/Solution은 OR가 기본값 |
| `OR` | 둘 중 하나 포함 |
| `AND NOT` | 첫 번째 단어 포함, 두 번째 단어 미포함 |
| `"phrase"` | 순서 일치 구문 검색 |
| `(...)` | 그룹화. 평가 순서: 괄호 → AND/AND NOT → OR |

연산자 자체를 검색어로 쓰려면 큰따옴표로 감싼다:
```
FIND {"and" or "or"}
FIND {"joe and mary"}
```

### SearchQuery 문자 수 제한

| 조건 | 동작 |
|---|---|
| 길이 > 10,000자 | 결과 행 없음 반환 |
| 길이 > 4,000자 | AND 연산자가 OR로 자동 변환 (예상보다 많은 결과 반환 가능) |
| 전체 SOSL 문 최대 | 100,000자 (`MALFORMED_SEARCH` 오류) |

### 예약 문자 (이스케이프 필요)

```
? & | ! { } [ ] ( ) ^ ~ * : \ " ' + -
```

이스케이프는 `\` 문자를 앞에 붙인다:

```apex
// 예약 문자 검색 예시
[FIND 'right brace \}' ...]
[FIND 'asterisk \*' ...]
[FIND 'single quote \'' ...]

// 복합 예시: {1+1}:2 검색
// API: FIND {\{1\+1\}\:2}
// Apex: [FIND '\{1\+1\}\:2' ...]
```

---

## IN 절 — 검색 필드 범위

```
IN { ALL FIELDS | NAME FIELDS | EMAIL FIELDS | PHONE FIELDS | SIDEBAR FIELDS }
```

| 값 | 설명 |
|---|---|
| `ALL FIELDS` (기본값) | 모든 텍스트, 이름, 이메일, 전화 필드 |
| `NAME FIELDS` | 이름 관련 필드 (Object별로 추가 필드 포함) |
| `EMAIL FIELDS` | 이메일 필드만 |
| `PHONE FIELDS` | 전화번호 필드만 |
| `SIDEBAR FIELDS` | 사이드바 검색에 표시되는 필드 |

**NAME FIELDS 오브젝트별 추가 검색 필드:**

| Object | 추가 검색 필드 |
|---|---|
| Account | Website, Site, NameLocal |
| Asset | SerialNumber |
| Case | SuppliedName, SuppliedCompany, Subject |
| Contact | AssistantName, FirstNameLocal, LastNameLocal, AccountName |
| Event | Subject |
| Lead | Company, CompanyLocal, FirstNameLocal, LastNameLocal |
| Note | Title |
| Task | Subject |
| User | CommunityNickname |

> [!note] Article, Document, Feed Comment, File, Product, Solution은 IN 절 무시 — RETURNING에 명시하면 모든 필드 검색

---

## RETURNING 절 — 반환 Object·필드 지정

```
RETURNING ObjectTypeName
  [(FieldList [WHERE conditionExpression]
              [USING Listview=listview]
              [ORDER BY Clause]
              [LIMIT n]
              [OFFSETn])]
[, ObjectTypeName [...]]
```

```apex
// 단순 반환 (ID만)
FIND {Acme} RETURNING Account, Contact

// 특정 필드 지정
FIND {Acme} RETURNING Account(Id, Name, Phone)

// WHERE 조건 (FieldList 필수)
FIND {'Joe Smith'} IN NAME FIELDS
RETURNING Lead(Name, Phone WHERE CreatedDate = THIS_FISCAL_QUARTER)

// ORDER BY + LIMIT
FIND {test}
RETURNING Account(Id, Name ORDER BY Name ASC LIMIT 50),
          Contact(Id, Name)

// OFFSET (단일 Object만, 반드시 마지막)
FIND {test} RETURNING Account(Name, Id ORDER BY Name LIMIT 100 OFFSET 100)

// USING Listview= (API v41.0+)
FIND {Acme} IN ALL FIELDS RETURNING Account(Id, Name USING ListViewName=MVPCustomers)

// 커스텀 Object
FIND {test} RETURNING CustomObject__c(CustomField__c)
```

> [!important] Apex에서는 RETURNING 절이 **필수**다.

> [!note] External objects, Article, Document, Feed Comment, Feed Item, File, Product, Solution은 RETURNING에 **명시해야만** 결과에 포함된다.

---

## ORDER BY 절

SOSL ORDER BY는 **RETURNING FieldSpec 안**에 포함된다.

```
ORDER BY fieldname [ASC | DESC] [NULLS {first | last}]
```

- 여러 ORDER BY 절 동시 사용 가능
- 기본값: ASC, NULLS FIRST
- `DISTANCE()` 함수로 지리적 거리 기준 정렬 가능

```apex
// 기본 정렬
FIND {MyName} RETURNING Account(Name, Id ORDER BY Id)

// 다중 Object 각각 정렬
FIND {name} RETURNING Contact(Name, Id ORDER BY Name),
                      Account(Description, Id ORDER BY Description)

// null 마지막 정렬
FIND {name} IN NAME FIELDS RETURNING Account(Name, Id ORDER BY Name DESC NULLS last)

// 지리 거리 기준 정렬
FIND {SF}
RETURNING My_Object__c(Name, Id
    WHERE DISTANCE(Location__c, GEOLOCATION(37,122), 'mi') < 500
    ORDER BY DISTANCE(Location__c, GEOLOCATION(37,122), 'mi') DESC)
```

---

## OFFSET n

페이지네이션에 사용. **단일 Object 조회 시만 사용 가능**, 반드시 **마지막 절**로 지정.

| 항목 | 값 |
|---|---|
| 최대 offset | 2,000 rows |
| 초과 시 오류 | `System.SearchException: SOSL offset should be between 0 to 2000` |
| 사용 제한 | 단일 Object만 가능 |
| 위치 제한 | 쿼리의 마지막 절 |

```apex
// 페이지 2 (11번~20번 레코드)
FIND {test} RETURNING Account(Name, Id ORDER BY Name LIMIT 10 OFFSET 10)

// 101번~200번
FIND {test} RETURNING Account(Name, Id ORDER BY Name LIMIT 100 OFFSET 100)
```

---

## 검색 결과 한도 — 상세 알고리즘

검색 엔진은 단계적으로 결과를 필터링한다:

1. 검색어와 일치하는 레코드를 전체 인덱스에서 최대 **2,000건** 탐색 (API v28.0+)
2. 단일 Object: 최대 **250건** (WHERE 또는 ORDER BY 포함 시 최대 2,000건)
3. 복수 Object (n개): Object당 **min(2000/n, 250)건**
4. 관리자(View All Data): 전체 결과 반환; 일반 사용자: 공유 규칙 적용 후 반환

| 조건 | 최대 결과 수 |
|---|---|
| 단일 Object, WHERE/ORDER BY 없음 | 250건 |
| 단일 Object, WHERE 또는 ORDER BY 포함 | 2,000건 |
| 복수 Object (n개) | min(2000/n, 250)건 |
| 전체 최대 | 2,000건 |

---

## FORMAT() 함수

사용자 Locale에 맞게 숫자·날짜·시간·통화 필드를 포맷해 반환한다.

```apex
// 날짜 포맷 변환
FIND {Acme} RETURNING Account(Id, LastModifiedDate, FORMAT(LastModifiedDate) FormattedDate)

// convertCurrency와 중첩 사용
FIND {Acme} RETURNING Account(AnnualRevenue, FORMAT(convertCurrency(AnnualRevenue)) convertedCurrency)
```

> [!note] 같은 필드를 여러 번 쓸 때는 반드시 alias 지정. FORMAT()은 TYPEOF와 함께 사용 불가.

---

## toLabel() 함수

SOSL 쿼리 결과를 사용자 언어로 번역해 반환한다.

```apex
// picklist 값 번역
FIND {Joe} RETURNING Lead(company, toLabel(Recordtype.Name))

// WHERE 절에서 번역된 값으로 필터
FIND {test} RETURNING Lead(company, toLabel(Status) WHERE toLabel(Status) = 'le Draft')

// alias 지정 (필드 중복 사용 시 필수)
FIND {Joe} RETURNING Lead(company, toLabel(Recordtype.Name) AliasName)
```

> [!caution] `toLabel()`은 ORDER BY와 함께 사용 불가. 피클리스트 순서는 항상 정의 순서.

---

## convertCurrency() 함수

다중 통화 Org에서 통화 필드를 사용자 통화로 변환한다.

```apex
// RETURNING 절에서 convertCurrency 사용
FIND {test} RETURNING Opportunity(Name, convertCurrency(Amount))

// 별칭 (같은 필드 여러 번 사용 시 필수)
FIND {Acme} RETURNING Account(AnnualRevenue, convertCurrency(AnnualRevenue) AliasCurrency)
```

**WHERE 절에서 ISO 코드 직접 비교:**

```
WHERE Object_name Operator ISO_CODEvalue
```

```apex
// Amount가 USD 5,000 이상인 Opportunity
FIND {test} IN ALL FIELDS RETURNING Opportunity(Name WHERE Amount>USD5000)
```

| 주의 사항 | 내용 |
|---|---|
| `convertCurrency()` + `ORDER BY` | ❌ 함께 사용 불가 |
| WHERE에서 `convertCurrency()` | ❌ 오류 — ISO 코드 직접 사용 |
| IN 절에서 ISO/non-ISO 혼용 | ❌ 불가 |
| Advanced Currency Management | 날짜 기준 환율 사용 (Opportunity 등) |

---

## USING Listview=

특정 List View 내에서만 검색한다. API v41.0+, SOAP/REST/Apex 지원.

- 한 번에 List View 하나만 지정 가능
- 해당 List View의 최초 2,000건만 검색 (사용자 설정 정렬 순서 기준)
- `USING ListViewName=Recent` — 최근 열람 아이템 검색

```apex
// 특정 List View 검색
FIND {Acme} IN ALL FIELDS RETURNING Account(Id, Name USING ListViewName=MVPCustomers)

// 최근 열람 아이템 검색 + 정렬
FIND {Acme} IN ALL FIELDS
RETURNING Account(Name USING LISTVIEW=Recent ORDER BY Name ASC NULLS FIRST, Id ASC NULLS FIRST LIMIT 51)
```

---

## WITH 절 — 필터 옵션 전체

### WITH DATA CATEGORY

Knowledge 또는 Question 검색 시 데이터 카테고리 필터. API v18.0+.

```apex
FIND {error} RETURNING KnowledgeArticleVersion(Id, Title WHERE PublishStatus='online')
WITH DATA CATEGORY Geography__c AT usa__c

// 복수 카테고리 (AND만 지원, OR/AND NOT 불가)
FIND {tourism} RETURNING FAQ__kav(Id, Title WHERE PublishStatus='online')
WITH DATA CATEGORY Geography__c ABOVE France__c
AND Product__c AT mobile_phones__c
```

| 연산자 | 설명 |
|---|---|
| `AT` | 해당 카테고리만 |
| `ABOVE` | 해당 카테고리 + 상위 카테고리 |
| `BELOW` | 해당 카테고리 + 하위 카테고리 |
| `ABOVE_OR_BELOW` | 해당 카테고리 + 상위 + 하위 모두 |

RETURNING의 ObjectTypeName: 특정 아티클 타입(`__kav`), `KnowledgeArticleVersion`, 또는 `Question` 중 하나.

### WITH DivisionFilter

Division 필드 기준으로 모든 검색 결과를 필터링한다.

```apex
FIND {test} RETURNING Account(id WHERE name LIKE '%test%'),
                      Contact(id WHERE name LIKE '%test%')
WITH DIVISION = 'Global'
```

> [!note] 특정 Division 검색 시 Global Division도 자동 포함된다.

### WITH HIGHLIGHT

검색어와 일치하는 텍스트를 `<mark>` 태그로 하이라이트해 반환한다. API v39.0+ (커스텀 필드/오브젝트는 v40.0+).

**하이라이트 생성 필드 타입 (지원):** Auto number, Email, Text, Text Area, Text Area (Long)

**하이라이트 미생성 필드 타입:** Checkbox, Compound fields, Currency, Date, Date/Time, File, Formula, Lookup Relationship, Number, Percent, Phone, Picklist, Picklist (Multi-Select), Text Area (Rich), URL

```apex
FIND {salesforce} IN ALL FIELDS RETURNING Account(Name, Description) WITH HIGHLIGHT
```

응답 예시 (JSON):
```json
{
  "Name": "salesforce",
  "Description": "Salesforce.com",
  "highlight.Description": "<mark>salesforce</mark>.com",
  "highlight.Name": "<mark>salesforce</mark>"
}
```

> [!note]
> - Object당 최대 **25건**만 하이라이트 생성
> - 와일드카드 포함 검색어는 하이라이트 없음
> - SOAP API, REST API에서만 지원 (Apex 미지원)
> - 철자 오류가 있어도 수정된 철자 기준으로 하이라이트

### WITH METADATA

응답에 메타데이터(필드 표시 레이블 등)를 포함할지 지정.

```apex
// LABELS — 반환 필드의 표시 레이블을 응답에 포함
FIND {Acme} RETURNING Account(Id, Name) WITH METADATA='LABELS'
```

기본값: 메타데이터 없음.

### WITH NETWORK

Experience Cloud Site(Community) ID로 검색 범위 필터.

```apex
// 단일 Site
FIND {test} RETURNING Account WITH NETWORK = '0DB000000000001'

// 복수 Site
FIND {test} RETURNING User(id),
                      FeedItem(id, ParentId WHERE CreatedDate = THIS_YEAR ORDER BY CreatedDate DESC)
WITH NETWORK IN ('NetworkId1', 'NetworkId2', 'NetworkId3')

// 내부 Org
FIND {test} RETURNING User(id) WITH NETWORK = '00000000000000'
```

### WITH PricebookId

Product2 오브젝트의 검색 결과를 특정 Price Book으로 필터.

```apex
Find {laptop} RETURNING Product2 WITH PricebookId = '01sxx0000002MffAAE'
```

### WITH SNIPPET

Knowledge 아티클 검색 결과에 컨텍스트 스니펫 표시. API v28.0+.

**스니펫 생성 필드 타입:** Email, Text, Text Area, Text Area (Long), Text Area (Rich)

```apex
FIND {San Francisco} IN ALL FIELDS
RETURNING KnowledgeArticleVersion(id, title WHERE PublishStatus='Online' AND Language='en_US')
WITH SNIPPET(target_length=120)
```

| 파라미터 | 범위 | 기본값 |
|---|---|---|
| `target_length=n` | 100–500자 | ~300자 |

응답에 `snippet.text`, `highlight.fieldName` 키로 결과 반환. `<mark>` 태그로 일치 구문 표시.

### WITH SPELL_CORRECTION

철자 교정 활성화/비활성화.

```apex
// 기본값 true — 철자 교정 활성
FIND {salesforse} RETURNING Account WITH SPELL_CORRECTION = true

// 비활성화 — 정확한 검색어만 매칭
FIND {salesforse} RETURNING Account WITH SPELL_CORRECTION = false
```

기본값: `true`.

---

## UPDATE TRACKING / VIEWSTAT

Knowledge 아티클에만 적용되는 통계 추적 옵션. 외부 Object에는 미지원.

```apex
// UPDATE TRACKING — 검색 키워드를 Knowledge 키워드 통계에 기록
FIND {Keyword}
RETURNING KnowledgeArticleVersion(Title WHERE PublishStatus="Online" AND language="en_US")
UPDATE TRACKING

// UPDATE VIEWSTAT — 아티클 조회수 통계 업데이트
FIND {Title}
RETURNING FAQ__kav(Title WHERE PublishStatus="Online" AND language="en_US"
                   AND KnowledgeArticleVersion = 'ka230000000PCiy')
UPDATE VIEWSTAT

// 두 가지 동시 적용
FIND {Keyword} RETURNING KnowledgeArticleVersion(Title WHERE PublishStatus="Online")
UPDATE TRACKING, VIEWSTAT
```

> [!note] language 속성으로 특정 로케일 기준 검색 가능. Java 포맷 사용 (fr_FR, jp_JP 등). 쿼리 하나당 로케일 하나만 지정 가능.

---

## WHERE 절 — 필드 필터

RETURNING FieldSpec 안에 포함. 기본값: 해당 Object의 사용자에게 보이는 모든 행 반환 (아카이브 포함).

WHERE 절을 지정하려면 FieldList에 최소 하나의 필드를 명시해야 한다:
```apex
// 올바른 구문
RETURNING Account (Name, Industry WHERE Name like 'test')

// 잘못된 구문 (FieldList 없음)
RETURNING Account (WHERE name like 'test')   // ❌
```

### 비교 연산자

| 연산자 | 설명 |
|---|---|
| `=` | 같음 |
| `!=` | 다름 |
| `<`, `<=`, `>`, `>=` | 숫자/날짜 비교 |
| `LIKE` | 패턴 매칭 (`%` — 0개 이상, `_` — 정확히 1개) |
| `IN` | 목록 포함; ID/참조 필드에서 세미조인 지원 |
| `NOT IN` | 목록 미포함 |
| `INCLUDES` | 멀티-피클리스트 포함 |
| `EXCLUDES` | 멀티-피클리스트 미포함 |

### 논리 연산자

| 연산자 | 설명 |
|---|---|
| `AND` | 두 조건 모두 참 |
| `OR` | 하나 이상 참 (null 포함 반환 가능) |
| `NOT` | 조건 부정 |

### WHERE 이스케이프 시퀀스

| 시퀀스 | 의미 |
|---|---|
| `\n` / `\N` | 줄바꿈 |
| `\t` / `\T` | 탭 |
| `\'` | 작은따옴표 |
| `\"` | 큰따옴표 |
| `\\` | 백슬래시 |
| `\_` (LIKE만) | 리터럴 밑줄 `_` |
| `\%` (LIKE만) | 리터럴 퍼센트 `%` |
| `\uXXXX` | Unicode 문자 (예: `é` = é) |

---

## Apex에서 SOSL 사용 패턴

```apex
// 기본 패턴 — List<List<SObject>>로 받기
public static void searchRecords(String keyword) {
    String searchTerm = '*' + String.escapeSingleQuotes(keyword) + '*';
    List<List<SObject>> results = [
        FIND :searchTerm IN ALL FIELDS
        RETURNING
            Account(Id, Name, Phone),
            Contact(Id, Name, Email),
            Lead(Id, Name, Company)
        LIMIT 50
    ];

    List<Account> accounts = (List<Account>) results[0];
    List<Contact> contacts = (List<Contact>) results[1];
    List<Lead> leads = (List<Lead>) results[2];
}

// Search Namespace 사용 (동적 SOSL)
String sosl = 'FIND {' + keyword + '} IN NAME FIELDS RETURNING Account, Contact';
Search.SearchResults searchResults = Search.find(sosl);

// 페이지네이션 (OFFSET)
// 1번~100번
List<List<SObject>> page1 = [FIND 'test' IN ALL FIELDS RETURNING Account(Name, Id ORDER BY Name LIMIT 100)];
// 101번~200번
List<List<SObject>> page2 = [FIND 'test' IN ALL FIELDS RETURNING Account(Name, Id ORDER BY Name LIMIT 100 OFFSET 100)];
```

---

## External Object SOSL 제한

| 제한 사항 | 내용 |
|---|---|
| 검색 가능 필드 | Text, Text Area, Long Text Area만 |
| RETURNING 명시 필수 | 지정 않으면 결과에 포함 안 됨 |
| 검색 문자열 최대 길이 | 100자 |
| 미지원 연산자/함수 | `INCLUDES`, `LIKE`, `EXCLUDES`, `toLabel()` |
| 미지원 Knowledge 절 | `UPDATE TRACKING`, `UPDATE VIEWSTAT`, `WITH DATA CATEGORY` |
| `convertCurrency()` | 커스텀 어댑터에서 미지원 |
| `WITH` 절 | 커스텀 어댑터에서 미지원 |
| OData 어댑터 | 논리 연산자 무시 — 전체 문자열을 단일 구문으로 전송 |

---

## SOQL vs SOSL 비교표

| 기준 | SOQL | SOSL |
|---|---|---|
| 시작 키워드 | `SELECT` | `FIND` |
| 용도 | 특정 Object 구조적 조회 | 여러 Object 전문 검색 |
| Object 지정 | `FROM Object` 필수 | `RETURNING`으로 선택 지정 |
| 검색 필드 | 모든 필드 | 텍스트/이메일/전화 필드 |
| 반환 타입 | `List<SObject>` | `List<List<SObject>>` |
| WHERE 조건 | 직접 사용 | RETURNING 안에 포함 |
| 쿼리 한도 | 100,000건 | 2,000건 |
| 사용 시기 | 조건이 명확한 레코드 조회 | Object 불명확한 키워드 검색 |

### 언제 SOSL을 쓸까?

- 검색어가 어떤 Object/Field에 있는지 모를 때
- 여러 Object를 동시에 검색할 때 (전역 검색 기능 구현)
- 텍스트 검색이 SOQL WHERE LIKE보다 빠른 속도가 필요할 때
- 한국어·중국어·일본어·태국어 등 CJK/Thai 텍스트 검색 (형태소 분석 지원)

---

## 관련 노트

- [[SOQL 패턴]] — 구조적 쿼리 패턴
- [[SOQL 문법 레퍼런스]] — SELECT 전체 문법, 날짜 리터럴, 집계 함수
- [[Dynamic SOQL]] — 동적 SOQL 패턴
- [[Search Namespace]] — Search Apex 클래스
