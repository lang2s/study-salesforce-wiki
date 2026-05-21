---
tags: [apex, soql, 문법, 날짜리터럴, 집계함수, 관계쿼리, date-literal, aggregate, relationship-query]
source: salesforce_soql_sosl.pdf p.1-94 (v67.0 Summer '26)
updated: 2026-05-21
created: 2026-05-21
aliases: [SOQL 레퍼런스, SOQL SELECT 문법, SOQL 날짜 리터럴, SOQL 집계 함수, 관계 쿼리, SOQL semi-join, SOQL GROUP BY ROLLUP, SOQL CUBE]
---

# SOQL 문법 레퍼런스

> SOQL(Salesforce Object Query Language) SELECT 전체 문법 — 절 구조, 날짜 리터럴 완전 목록, 집계 함수, 관계 쿼리, GROUP BY ROLLUP/CUBE, 세미조인/안티조인, 오브젝트별 제한 사항

---

## SELECT 전체 문법 구조

```
SELECT fieldList [subquery] [typeof]
FROM objectType [, objectType2]
[USING SCOPE filterScope]
[WHERE conditionExpression]
[WITH [SECURITY_ENFORCED
     | USER_MODE
     | DATA CATEGORY filteringExpression
     | RECORD_VISIBILITY_CONTEXT (...)]]
[GROUP BY {fieldGroupByList
         | ROLLUP (fieldSubtotalGroupByList)
         | CUBE (fieldSubtotalGroupByList)}]
[HAVING havingConditionExpression]
[ORDER BY fieldOrderByList {ASC | DESC} [NULLS {FIRST | LAST}]]
[LIMIT numberOfRowsToReturn]
[OFFSET numberOfRowsToSkip]
[FOR {VIEW | REFERENCE} [, UPDATE]]
[UPDATE {TRACKING | VIEWSTAT}]
```

---

## FIELDS() — 동적 필드 선택 (API v51.0+)

모든 필드를 개별 나열하지 않고 카테고리 단위로 선택한다.

| 키워드 | 선택 범위 | 제한 | Apex 지원 |
|---|---|---|---|
| `FIELDS(ALL)` | 표준 + 커스텀 필드 전체 | **Unbounded** — Apex·Bulk API 2.0 불가 | ❌ |
| `FIELDS(CUSTOM)` | 커스텀 필드만 | **Unbounded** — Apex·Bulk API 2.0 불가 | ❌ |
| `FIELDS(STANDARD)` | 표준 필드만 | Bounded — 200필드 이하 | ✅ |

```apex
// ✅ Apex에서는 FIELDS(STANDARD)만 허용
List<Account> accs = [SELECT FIELDS(STANDARD) FROM Account LIMIT 200];

// REST API에서는 FIELDS(ALL) 사용 가능 (Apex에서 불가)
// GET /services/data/v67.0/query?q=SELECT+FIELDS(ALL)+FROM+Account+LIMIT+200
```

---

## WHERE 절 — 비교 연산자

| 연산자 | 설명 | 예시 |
|---|---|---|
| `=` | 같음 | `WHERE Name = 'Acme'` |
| `!=` | 다름 | `WHERE Status != 'Closed'` |
| `<` | 미만 | `WHERE Amount < 1000` |
| `<=` | 이하 | `WHERE Amount <= 1000` |
| `>` | 초과 | `WHERE Amount > 1000` |
| `>=` | 이상 | `WHERE Amount >= 1000` |
| `LIKE` | 패턴 일치 | `WHERE Name LIKE 'Acme%'` |
| `IN` | 목록 포함 | `WHERE Id IN ('001...', '002...')` |
| `NOT IN` | 목록 미포함 | `WHERE Id NOT IN :excludeIds` |
| `INCLUDES` | 멀티-피클리스트 값 포함 | `WHERE Languages__c INCLUDES ('Korean', 'English')` |
| `EXCLUDES` | 멀티-피클리스트 값 미포함 | `WHERE Languages__c EXCLUDES ('Spanish')` |

**LIKE 와일드카드:**
- `%` — 0개 이상 문자 (예: `LIKE 'Ac%'` → Acme, Accenture)
- `_` — 정확히 1개 문자 (예: `LIKE 'A_me'` → Acme, Acne 불일치)

---

## 세미조인·안티조인 (Semi-join / Anti-join)

서브쿼리 결과를 필터 조건으로 사용한다.

```apex
// 세미조인 (IN with subquery) — Contact가 있는 Account만
List<Account> accs = [
    SELECT Id, Name FROM Account
    WHERE Id IN (SELECT AccountId FROM Contact WHERE IsActive__c = true)
    WITH USER_MODE
];

// 안티조인 (NOT IN with subquery) — Contact가 없는 Account
List<Account> noContact = [
    SELECT Id, Name FROM Account
    WHERE Id NOT IN (SELECT AccountId FROM Contact)
    WITH USER_MODE
];

// 두 서브쿼리 동시 사용 (한 WHERE에 IN/NOT IN 최대 2개)
List<Account> accs2 = [
    SELECT Id FROM Account
    WHERE Id IN (SELECT AccountId FROM Contact)
    AND Id NOT IN (SELECT AccountId FROM Case WHERE Status = 'Open')
    WITH USER_MODE
];
```

**제한 사항:**
- 한 WHERE 절에 `IN`/`NOT IN` 서브쿼리 최대 **2개**
- `HAVING` 절에는 세미조인/안티조인 불가
- 서브쿼리에서 메인 쿼리와 **같은 Object** 조회 불가
- 서브쿼리에서 조회하는 필드는 **1개**만 허용

---

## 날짜 형식

| 유형 | 형식 | 예시 |
|---|---|---|
| Date | `YYYY-MM-DD` | `2024-01-29` |
| DateTime | `YYYY-MM-DDThh:mm:ssZ` | `2024-01-29T08:00:00Z` |
| DateTime (오프셋) | `YYYY-MM-DDThh:mm:ss+HH:MM` | `2024-01-29T17:00:00+09:00` |

```apex
// Date 필터
WHERE CloseDate >= 2024-01-01

// DateTime 필터 (UTC)
WHERE CreatedDate > 2024-01-01T00:00:00Z
```

---

## 날짜 리터럴 — 완전 목록 (44개)

날짜 리터럴을 사용하면 실행 시점의 날짜를 기준으로 동적 범위가 계산된다.

### 어제·오늘·내일

| 리터럴 | 설명 |
|---|---|
| `YESTERDAY` | 어제 00:00:00 ~ 23:59:59 |
| `TODAY` | 오늘 00:00:00 ~ 23:59:59 |
| `TOMORROW` | 내일 00:00:00 ~ 23:59:59 |

### 주(Week)

| 리터럴 | 설명 |
|---|---|
| `LAST_WEEK` | 지난주 일요일~토요일 |
| `THIS_WEEK` | 이번주 일요일~토요일 |
| `NEXT_WEEK` | 다음주 일요일~토요일 |
| `LAST_N_WEEKS:n` | 최근 n주 (이번주 포함 안 함) |
| `NEXT_N_WEEKS:n` | 다음 n주 (이번주 포함 안 함) |
| `N_WEEKS_AGO:n` | n주 전 해당 주 |

### 월(Month)

| 리터럴 | 설명 |
|---|---|
| `LAST_MONTH` | 지난달 1일~말일 |
| `THIS_MONTH` | 이번달 1일~말일 |
| `NEXT_MONTH` | 다음달 1일~말일 |
| `LAST_N_MONTHS:n` | 최근 n개월 (이번달 포함 안 함) |
| `NEXT_N_MONTHS:n` | 다음 n개월 (이번달 포함 안 함) |
| `N_MONTHS_AGO:n` | n개월 전 해당 월 |

### 일(Day) 단위

| 리터럴 | 설명 |
|---|---|
| `LAST_90_DAYS` | 오늘 포함 최근 90일 |
| `NEXT_90_DAYS` | 오늘 포함 다음 90일 |
| `LAST_N_DAYS:n` | 오늘 포함 최근 n일 |
| `NEXT_N_DAYS:n` | 오늘 포함 다음 n일 |
| `N_DAYS_AGO:n` | n일 전 해당 날짜 |

### 분기(Quarter)

| 리터럴 | 설명 |
|---|---|
| `LAST_QUARTER` | 지난 분기 |
| `THIS_QUARTER` | 이번 분기 |
| `NEXT_QUARTER` | 다음 분기 |
| `LAST_N_QUARTERS:n` | 최근 n분기 (이번 분기 포함 안 함) |
| `NEXT_N_QUARTERS:n` | 다음 n분기 (이번 분기 포함 안 함) |
| `N_QUARTERS_AGO:n` | n분기 전 해당 분기 |

### 년(Year)

| 리터럴 | 설명 |
|---|---|
| `LAST_YEAR` | 작년 1/1~12/31 |
| `THIS_YEAR` | 올해 1/1~12/31 |
| `NEXT_YEAR` | 내년 1/1~12/31 |
| `LAST_N_YEARS:n` | 최근 n년 (올해 포함 안 함) |
| `NEXT_N_YEARS:n` | 다음 n년 (올해 포함 안 함) |
| `N_YEARS_AGO:n` | n년 전 해당 연도 |

### 회계 분기(Fiscal Quarter)

| 리터럴 | 설명 |
|---|---|
| `THIS_FISCAL_QUARTER` | 이번 회계 분기 |
| `LAST_FISCAL_QUARTER` | 지난 회계 분기 |
| `NEXT_FISCAL_QUARTER` | 다음 회계 분기 |
| `LAST_N_FISCAL_QUARTERS:n` | 최근 n회계 분기 |
| `NEXT_N_FISCAL_QUARTERS:n` | 다음 n회계 분기 |
| `N_FISCAL_QUARTERS_AGO:n` | n회계 분기 전 |

### 회계 연도(Fiscal Year)

| 리터럴 | 설명 |
|---|---|
| `THIS_FISCAL_YEAR` | 이번 회계 연도 |
| `LAST_FISCAL_YEAR` | 지난 회계 연도 |
| `NEXT_FISCAL_YEAR` | 다음 회계 연도 |
| `LAST_N_FISCAL_YEARS:n` | 최근 n회계 연도 |
| `NEXT_N_FISCAL_YEARS:n` | 다음 n회계 연도 |
| `N_FISCAL_YEARS_AGO:n` | n회계 연도 전 |

```apex
// 날짜 리터럴 활용 예시
List<Opportunity> recent = [
    SELECT Id, Name, Amount FROM Opportunity
    WHERE CloseDate >= LAST_N_MONTHS:3
    AND CreatedDate = THIS_FISCAL_YEAR
    WITH USER_MODE
];
```

---

## 날짜 함수 (GROUP BY / WHERE 사용)

날짜·시간 필드를 특정 단위로 분해하여 GROUP BY나 WHERE 조건에 사용한다.

| 함수 | 적용 필드 | 반환 |
|---|---|---|
| `CALENDAR_MONTH(date)` | Date, DateTime | 1–12 |
| `CALENDAR_QUARTER(date)` | Date, DateTime | 1–4 |
| `CALENDAR_YEAR(date)` | Date, DateTime | 정수 연도 |
| `DAY_IN_MONTH(date)` | Date, DateTime | 1–31 |
| `DAY_IN_WEEK(date)` | Date, DateTime | 1(일)–7(토) |
| `DAY_IN_YEAR(date)` | Date, DateTime | 1–366 |
| `DAY_ONLY(dateTime)` | DateTime만 | Date 값 |
| `FISCAL_MONTH(date)` | Date, DateTime | 회계 월 번호 |
| `FISCAL_QUARTER(date)` | Date, DateTime | 회계 분기 번호 |
| `FISCAL_YEAR(date)` | Date, DateTime | 회계 연도 |
| `HOUR_IN_DAY(dateTime)` | DateTime만 | 0–23 |
| `WEEK_IN_MONTH(date)` | Date, DateTime | 1–5 |
| `WEEK_IN_YEAR(date)` | Date, DateTime | 1–53 |
| `convertTimezone(dateTime)` | DateTime만 | 사용자 타임존 DateTime |

```apex
// 월별 기회 합계
List<AggregateResult> monthly = [
    SELECT CALENDAR_MONTH(CloseDate) mo,
           CALENDAR_YEAR(CloseDate) yr,
           SUM(Amount) total
    FROM Opportunity
    WHERE CloseDate = THIS_YEAR
    GROUP BY CALENDAR_YEAR(CloseDate), CALENDAR_MONTH(CloseDate)
    WITH USER_MODE
    ORDER BY CALENDAR_YEAR(CloseDate), CALENDAR_MONTH(CloseDate)
];

// 사용자 타임존으로 변환 후 시간별 그룹
List<AggregateResult> byHour = [
    SELECT HOUR_IN_DAY(convertTimezone(CreatedDate)) hr, COUNT(Id) cnt
    FROM Lead
    GROUP BY HOUR_IN_DAY(convertTimezone(CreatedDate))
    WITH USER_MODE
];

// WHERE 절에서도 사용 가능
List<Opportunity> q2 = [
    SELECT Id FROM Opportunity
    WHERE CALENDAR_QUARTER(CloseDate) = 2
    AND CALENDAR_YEAR(CloseDate) = 2024
    WITH USER_MODE
];
```

---

## 집계 함수 (Aggregate Functions)

| 함수 | 설명 | null 처리 |
|---|---|---|
| `COUNT()` | 전체 행 수 | null 포함 |
| `COUNT(field)` | 특정 필드 non-null 행 수 | null 제외 |
| `COUNT_DISTINCT(field)` | 중복 제거 non-null 값 수 | null 제외 |
| `AVG(field)` | 숫자 필드 평균 | null 제외 |
| `MIN(field)` | 최솟값 (숫자·날짜·문자열) | null 제외 |
| `MAX(field)` | 최댓값 (숫자·날짜·문자열) | null 제외 |
| `SUM(field)` | 숫자 필드 합계 | null 제외 |

```apex
// AggregateResult로 받기
List<AggregateResult> results = [
    SELECT Industry, COUNT(Id) cnt, SUM(AnnualRevenue) revenue, AVG(AnnualRevenue) avgRev
    FROM Account
    WHERE Industry != null
    GROUP BY Industry
    WITH USER_MODE
    HAVING COUNT(Id) > 5
];

for (AggregateResult ar : results) {
    String ind = (String) ar.get('Industry');
    Integer cnt = (Integer) ar.get('cnt');
    Decimal rev = (Decimal) ar.get('revenue');
}

// COUNT() — Integer로 바로 반환 (AggregateResult 불필요)
Integer total = [SELECT COUNT() FROM Account WHERE Type = 'Customer' WITH USER_MODE];
```

---

## GROUP BY ROLLUP / CUBE — 소계·전체 합계

### GROUP BY ROLLUP

계층적 소계를 자동으로 생성한다. `GROUPING(field)` 함수로 소계 행을 식별한다.

```apex
// LeadSource별, Rating별 소계 + 전체 합계 동시 계산
List<AggregateResult> rollup = [
    SELECT LeadSource,
           Rating,
           COUNT(Name) cnt,
           GROUPING(LeadSource) grpLS,    // 1 = 이 행은 LeadSource 소계
           GROUPING(Rating) grpRating      // 1 = 이 행은 Rating 소계
    FROM Lead
    GROUP BY ROLLUP(LeadSource, Rating)
    WITH USER_MODE
];

for (AggregateResult ar : rollup) {
    Integer isLeadSourceSubtotal = (Integer) ar.get('grpLS');
    Integer isRatingSubtotal = (Integer) ar.get('grpRating');
    // grpLS=1, grpRating=1 → 전체 합계 행
    // grpLS=0, grpRating=1 → LeadSource별 소계 행
    // grpLS=0, grpRating=0 → 일반 집계 행
}
```

**ROLLUP 결과 행 수:** 필드 n개 → 최대 n+1 레벨의 소계 행 생성

### GROUP BY CUBE

모든 가능한 조합의 소계를 생성한다 (ROLLUP보다 더 많은 소계).

```apex
// 2개 필드 CUBE → 4가지 조합 소계 (LeadSource별, Rating별, 전체, 각 조합)
List<AggregateResult> cube = [
    SELECT LeadSource,
           Rating,
           COUNT(Name) cnt,
           GROUPING(LeadSource) grpLS,
           GROUPING(Rating) grpRating
    FROM Lead
    GROUP BY CUBE(LeadSource, Rating)
    WITH USER_MODE
];
```

**ROLLUP vs CUBE:**
- `ROLLUP(A, B)`: (A,B), (A), (전체) — 3가지 조합
- `CUBE(A, B)`: (A,B), (A), (B), (전체) — 4가지 조합 (B 소계 추가)

---

## 관계 쿼리 (Relationship Queries)

### 자식→부모 (Child-to-Parent) — 점 표기법

```apex
// 표준 관계: Contact → Account (최대 5단계 깊이)
List<Contact> contacts = [
    SELECT Id, Name,
           Account.Name,              // 1단계 부모
           Account.Owner.Name,        // 2단계 부모
           Account.Owner.Profile.Name // 3단계 부모
    FROM Contact
    WITH USER_MODE
];

// 커스텀 관계: __r 접미사 사용
List<Invoice__c> invoices = [
    SELECT Id, Amount__c,
           Project__r.Name,           // 커스텀 관계: __r
           Project__r.Client__r.Name  // 2단계 커스텀 관계
    FROM Invoice__c
    WITH USER_MODE
];
```

### 부모→자식 (Parent-to-Child) — 서브쿼리

서브쿼리에서 자식 Object의 관계명을 사용한다.

```apex
// 표준 자식: Account → Contacts (관계명 복수형)
List<Account> accs = [
    SELECT Id, Name,
           (SELECT Id, LastName, Email FROM Contacts),  // 표준: Contacts
           (SELECT Id, Subject FROM Cases)               // 표준: Cases
    FROM Account
    WITH USER_MODE
];

// 커스텀 자식: __r 접미사 복수형 관계명
List<Project__c> projects = [
    SELECT Id, Name,
           (SELECT Id, Amount__c FROM Invoices__r)   // 커스텀: Invoices__r
    FROM Project__c
    WITH USER_MODE
];

// 자식 레코드 접근
for (Account acc : accs) {
    for (Contact c : acc.Contacts) {
        System.debug(c.LastName);
    }
}
```

**제한 사항:**
- 서브쿼리 깊이 최대 **5단계** (Summer '24+; 이전 버전 1단계)
- 서브쿼리 당 결과 최대 **1,000건** (초과 시 QueryMoreLocator 필요)
- 서브쿼리 최대 **20개** per query

### TYPEOF — 다형성 관계 (API v46.0+)

`Task.What`, `Event.WhoId` 같은 다형성 관계 필드에서 실제 타입에 따라 다른 필드를 조회한다.

```apex
// TYPEOF + ELSE 조합
List<Task> tasks = [
    SELECT Id, Subject,
        TYPEOF What
            WHEN Account THEN Id, Name, Phone
            WHEN Opportunity THEN Id, Name, CloseDate
            ELSE Id, Name    // Account/Opportunity 외 모든 타입
        END
    FROM Task
    WITH USER_MODE
];

// TYPEOF + Type qualifier 조합 (WHERE에서 타입 필터)
List<Event> events = [
    SELECT Id,
        TYPEOF What
            WHEN Account THEN Phone
            WHEN Opportunity THEN Amount
        END
    FROM Event
    WHERE What.Type IN ('Account', 'Opportunity')
    WITH USER_MODE
];
```

**TYPEOF 제한 사항:**

| 제한 | 내용 |
|---|---|
| `namePointing=false` 필드 | TYPEOF 사용 불가 |
| `relationshipName=false` 필드 | TYPEOF 사용 불가 |
| `COUNT()` 쿼리 | TYPEOF 사용 불가 |
| 중첩 TYPEOF | 불가 (TYPEOF 안의 WHEN 절에 다시 TYPEOF 불가) |
| 세미조인 내부 쿼리 | TYPEOF 사용 불가 (외부 쿼리에는 가능) |
| `FORMAT()` 함수 포함 SELECT | TYPEOF 사용 불가 |
| `GROUP BY`, `GROUP BY ROLLUP`, `GROUP BY CUBE`, `HAVING` | TYPEOF 사용 불가 |
| Streaming API PushTopics | TYPEOF 사용 불가 |
| Bulk API | TYPEOF 사용 불가 |

---

## 관계 쿼리 제한 사항

| 제한 사항 | 값 |
|---|---|
| 자식→부모 관계 최대 수 | **55개** (커스텀 Object는 최대 40개 관계 → 전부 한 쿼리에 포함 가능) |
| 부모→자식 관계 최대 수 | **20개** per query |
| 자식→부모 깊이 최대 | **5단계** (예: Contact.Account.Owner.Profile.Name) |
| 부모→자식 깊이 최대 | API v57.0 이하: **1단계** / API v58.0+: **5단계** |
| 5단계 부모→자식 미지원 | Big objects, External objects, Bulk API 2.0 |

**다형성 관계(TYPEOF)와 관계 수 계산:**
```apex
// 이 쿼리는 What, Account, Opportunity 3개를 child-to-parent 관계로 계산
SELECT TYPEOF What
    WHEN Account THEN Phone, NumberOfEmployees
    WHEN Opportunity THEN Amount, CloseDate
    ELSE Name, Email
END
FROM Event
```

**노트/첨부 파일 제한:**
- Note Body, Attachment Body는 WHERE 조건으로 필터 불가
- `SELECT Account.Name, (SELECT Note.OwnerId FROM Account.Notes) FROM Account` — 유효 (Body 필터 없음)
- `WHERE Note.Body LIKE 'D%'` — ❌ 오류

---

## WITH 보안 절

| 키워드 | 버전 | CRUD 검사 | FLS 검사 | 비고 |
|---|---|---|---|---|
| `WITH USER_MODE` | API 57.0+ | ✅ | ✅ | 권장 표준 |
| `WITH SECURITY_ENFORCED` | 구형 | ❌ | ✅ | **v67.0 컴파일 오류** |
| (생략, 기본) | — | ❌ | ❌ | 시스템 컨텍스트 |

> [!important] **Summer '26 (API v67.0) 파괴적 변경**
> `WITH SECURITY_ENFORCED`가 v67.0에서 컴파일 오류로 제거됨. 기존 코드베이스에서 `WITH USER_MODE`로 일괄 교체 필요. 자세한 내용은 [[WITH USER_MODE]] 참조.

---

## ORDER BY / LIMIT / OFFSET

```apex
// ASC(기본)/DESC, NULLS FIRST/LAST
List<Account> sorted = [
    SELECT Id, Name, AnnualRevenue
    FROM Account
    ORDER BY AnnualRevenue DESC NULLS LAST, Name ASC
    LIMIT 10
    OFFSET 20   // 21번째부터 10건 (페이지 3)
    WITH USER_MODE
];
```

**NULLS 기본값:** 오름차순(ASC) → `NULLS FIRST`, 내림차순(DESC) → `NULLS LAST`

**OFFSET 제한:** 최대 2,000

---

## 특수 절

```apex
// FOR UPDATE — 레코드 잠금 (SELECT와 DML 사이 다른 트랜잭션 수정 방지)
// ORDER BY와 함께 사용 불가
Account[] accts = [SELECT Id FROM Account WHERE Id IN :ids FOR UPDATE];

// FOR VIEW — LastViewedDate + RecentlyViewed 갱신
SELECT Id FROM Contact LIMIT 1 FOR VIEW

// FOR REFERENCE — LastReferencedDate + RecentlyViewed 갱신 (관련 레코드 조회 시)
SELECT Id FROM Contact LIMIT 1 FOR REFERENCE

// UPDATE TRACKING — 사용자 정의 추적 필드 업데이트
SELECT Id FROM KnowledgeArticleVersion WHERE PublishStatus = 'online' UPDATE TRACKING

// UPDATE VIEWSTAT — 뷰 통계(KnowledgeArticleViewStat) 업데이트
SELECT Id FROM KnowledgeArticleVersion WHERE PublishStatus = 'online' UPDATE VIEWSTAT
```

---

## FORMAT() 함수

사용자 Locale에 맞게 숫자·날짜·시간·통화 필드를 포맷해 반환한다.

```apex
// 날짜를 사용자 로케일 포맷으로 (예: 2015-12-28 → "12/28/2015")
List<Account> accs = [
    SELECT Name, AnnualRevenue, FORMAT(AnnualRevenue) FormattedRevenue
    FROM Account
    WITH USER_MODE
];

// 같은 필드를 FORMAT으로 두 번 쓸 때 alias 필수
SELECT AnnualRevenue,
       FORMAT(AnnualRevenue) FormattedRevenue,
       FORMAT(convertCurrency(AnnualRevenue)) ConvertedRevenue
FROM Account
```

| 항목 | 내용 |
|---|---|
| 적용 필드 | 숫자, 날짜, 시간, 통화 |
| alias 필요 | 같은 필드 여러 번 사용 시 필수 |
| convertCurrency() 중첩 | 가능 — `FORMAT(convertCurrency(field))` |
| TYPEOF와 함께 사용 | ❌ 불가 |

---

## toLabel() 함수

피클리스트·RecordType 필드를 사용자 언어로 번역해 반환한다.

```apex
// 피클리스트 값 번역
List<Lead> leads = [
    SELECT Id, toLabel(Status), toLabel(LeadSource)
    FROM Lead
    WITH USER_MODE
];

// RecordType 번역
List<Account> accs = [
    SELECT Id, Name, toLabel(RecordType.Name)
    FROM Account
    WITH USER_MODE
];

// WHERE 절에서 번역된 레이블로 필터 가능
List<Lead> french = [
    SELECT Id FROM Lead
    WHERE toLabel(Status) = 'Brouillon'  // 프랑스어 "Draft"
    WITH USER_MODE
];
```

| 주의 사항 | 내용 |
|---|---|
| ORDER BY | `toLabel()`과 함께 사용 불가 |
| Record Type 필터 | 번역된 이름이 아닌 master value 또는 ID로 필터 |
| Translation Workbench 미설정 | master value로 비교 |
| External objects | `toLabel()` 미지원 |

---

## convertCurrency() 함수

다중 통화 Org에서 통화 필드를 사용자 통화로 변환한다.

```apex
// SELECT에서 통화 변환
List<Opportunity> opps = [
    SELECT Name, Amount, convertCurrency(Amount) AmtConverted
    FROM Opportunity
    WITH USER_MODE
];

// WHERE에서 ISO 코드 직접 비교
List<Opportunity> bigDeals = [
    SELECT Id FROM Opportunity
    WHERE Amount > USD5000   // ISO 코드 + 금액 (공백 없이)
    WITH USER_MODE
];
```

| 항목 | 내용 |
|---|---|
| 사용 위치 | SELECT 절 (WHERE에 `convertCurrency()` 함수 불가) |
| WHERE 비교 | ISO 코드 직접 사용: `Amount > USD5000` |
| ORDER BY | `convertCurrency()`와 함께 사용 불가 |
| Advanced Currency Management | Opportunity 등에서 날짜 기반 환율 사용 |
| org 설정 | Multi-currency 미활성화 Org에서는 오류 |
| External objects | `convertCurrency()` 미지원 |

---

## USING SCOPE — 레코드 범위 필터

내 레코드, 팀 레코드 등 사전 정의된 범위로 결과를 제한한다.

| 값 | 설명 |
|---|---|
| `DELEGATED` | 다른 사람에게 위임된 레코드 |
| `EVERYTHING` | 관련 있는 모든 레코드 |
| `MINE` | 내 소유 레코드 |
| `MINE_AND_MY_GROUPS` | 내 소유 + 내 그룹 소유 |
| `MY_TERRITORY` | 내 Territory의 레코드 |
| `MY_TEAM_TERRITORY` | 내 Team Territory의 레코드 |
| `TEAM` | 내 Sales Team의 레코드 |

```apex
List<Opportunity> myOpps = [
    SELECT Id, Name FROM Opportunity
    USING SCOPE MINE
    WHERE CloseDate = THIS_QUARTER
    WITH USER_MODE
];
```

---

## Location-Based SOQL

위치(지리 좌표) 기반 거리 계산 쿼리. Apex, SOAP API, REST API 모두 지원.

### 함수

| 함수 | 설명 | 사용 위치 |
|---|---|---|
| `DISTANCE(loc1, loc2, 'unit')` | 두 위치 간 거리 계산 | SELECT, WHERE, ORDER BY (GROUP BY 불가) |
| `GEOLOCATION(lat, lon)` | 위도·경도로 위치 값 생성 | DISTANCE 인자로 사용 |

`unit`: `'mi'` (마일) 또는 `'km'` (킬로미터)

> [!caution] 위치 필드가 첫 번째 인자, GEOLOCATION이 두 번째 인자여야 한다. 순서가 바뀌면 `MALFORMED_QUERY` 오류.

### 복합 필드 컴포넌트 접근

```apex
// __latitude__s, __longitude__s 접미사로 개별 컴포넌트 조회
List<Warehouse__c> warehouses = [
    SELECT Name, Location__latitude__s, Location__longitude__s
    FROM Warehouse__c
    WITH USER_MODE
];

// REST/SOAP API: 복합 필드 전체 반환 (구조화 데이터)
SELECT Name, Location__c FROM Warehouse__c
```

### WHERE 절 거리 필터

```apex
// 반경 20마일 이내 창고 검색
List<Warehouse__c> nearby = [
    SELECT Name, Location__c
    FROM Warehouse__c
    WHERE DISTANCE(Location__c, GEOLOCATION(37.775, -122.418), 'mi') < 20
    WITH USER_MODE
];
```

> [!note] `DISTANCE`는 `>` (초과) 와 `<` (미만) 연산자만 지원. `=` 불가 — 부동소수점 오차로 인해 두 위치가 정확히 같은지는 판단 불가.

### ORDER BY 거리 정렬

```apex
// 가장 가까운 창고 10개
List<Warehouse__c> closest = [
    SELECT Name, StreetAddress__c
    FROM Warehouse__c
    WHERE DISTANCE(Location__c, GEOLOCATION(37.775, -122.418), 'mi') < 20
    ORDER BY DISTANCE(Location__c, GEOLOCATION(37.775, -122.418), 'mi')
    LIMIT 10
    WITH USER_MODE
];
```

### Null 처리

- Geolocation 필드가 null로 처리되려면 위도·경도 **둘 다** null이어야 함
- 하나만 null이면 → DISTANCE/ORDER BY에서 해당 레코드를 null처럼 처리
- SELECT에서는 부분 null(한 쪽만 null)을 그대로 반환

### 추가 제한

- Apex bind variable은 `DISTANCE` 함수의 unit 파라미터에 사용 불가
- `DISTANCE`, `GEOLOCATION`은 GROUP BY에서 사용 불가
- DISTANCE 계산은 하버사인(Haversine) 공식 기반 (오차 ~0.0002%, 최대 0.55%)

---

## Object별 쿼리 제한 사항

### ContentDocumentLink

```apex
// WHERE 조건 없이는 쿼리 불가 — ContentDocumentId 또는 LinkedEntityId 필수
List<ContentDocumentLink> links = [
    SELECT Id, ContentDocumentId, LinkedEntityId
    FROM ContentDocumentLink
    WHERE LinkedEntityId = :recordId  // 필수
];
```

### Big Objects (`__b` 접미사)

- 인덱스 필드에 대해서만 필터 가능 (`=`, `<`, `>`, `<=`, `>=`, `IN`)
- `LIKE`, `!=`, `NOT IN` 불가
- 집계 함수 불가
- 복합 인덱스: 앞 필드부터 순서대로 포함해야 함

```apex
// Big Object 쿼리 — 인덱스 필드 순서 준수
List<ActivityHistory__b> history = [
    SELECT AccountId__c, ActivityDate__c, ActivityType__c
    FROM ActivityHistory__b
    WHERE AccountId__c = :accId         // 복합 인덱스 1번 필드 (필수)
    AND ActivityDate__c >= 2024-01-01   // 복합 인덱스 2번 필드
    ORDER BY AccountId__c, ActivityDate__c
];
```

### ContentHubItem

```apex
// Id, ExternalId, 또는 ContentHubRepositoryId 필터 필수
List<ContentHubItem> items = [
    SELECT Id, Name FROM ContentHubItem
    WHERE ContentHubRepositoryId = :repoId
];
```

### External Objects (`__x` 접미사)

미지원 집계 함수: `AVG()`, `COUNT(fieldName)`, `MAX()`, `MIN()`, `SUM()`  
미지원 연산자: `EXCLUDES`, `INCLUDES`, `LIKE`, `toLabel()`  
미지원 절: `FOR VIEW`, `FOR REFERENCE`, `HAVING`, `GROUP BY`, `TYPEOF`, `WITH`, `UPDATE TRACKING/VIEWSTAT`, `USING SCOPE`, `convertCurrency()`

- 서브쿼리 포함 시 최대 1,000건
- 한 쿼리당 최대 4개 조인 (각 조인마다 외부 시스템 왕복 발생)
- ORDER BY `NULLS FIRST`/`NULLS LAST` 무시
- 관계 쿼리에서 ORDER BY 미지원
- 두 개 이상의 긴 텍스트 커스텀 필드 SELECT 시 배치 크기 최대 200
- Apex 테스트에서 static SOQL로 외부 Object 쿼리 불가 → Dynamic SOQL 사용

### KnowledgeArticleVersion

```apex
// PublishStatus 또는 KnowledgeArticleId 필터 권장
List<KnowledgeArticleVersion> articles = [
    SELECT Id, Title, VersionNumber
    FROM KnowledgeArticleVersion
    WHERE PublishStatus = 'online'
    AND Language = 'en_US'
    WITH USER_MODE
];

// binding variable 사용 불가 (컴파일 오류) → Dynamic SOQL 필요
final String PUBLISH_STATUS_ONLINE = 'Online';
final String q = 'SELECT Id, PublishStatus FROM Knowledge__kav WHERE PublishStatus = :PUBLISH_STATUS_ONLINE';
List<Knowledge__kav> articles2 = Database.query(q);
```

- API v46.0 이하: `PublishStatus` 필터 없으면 Published 기사만 반환
- API v47.0+: `PublishStatus` 없으면 draft, published, archived 모두 반환
- 아카이브 버전: `Knowledge__kav` Object, `IsLatestVersion = '0'` 으로 조회

### Data 360 Objects (Data Cloud DMO/DLO)

- SOQL 결과 최대 **12MB** — 초과 시 쿼리 거부 또는 queryMore로 페이지 처리
- 집계 함수 포함 쿼리에서 통화 필드 미지원 (집계 대상 필드 외에 있어도 동일)
- CIO(Calculated Insight Objects) 조회 불가
- `SET OPTIONS` 절로 dataspace 지정 또는 NULL과 빈 문자열 구분 필요
- `Id` 필드를 `HAVING`, `GROUP BY`에서 사용 불가
- `HAVING` 절에서 `IN` 연산자, null 비교 불가
- 문자열 정렬: Unicode Root Collation만 지원 (로케일 기반 정렬 미지원)
- 비교 연산자 `>`, `<`, `>=`, `<=`를 문자열 필드에 사용 불가
- Child-to-parent Object 관계 쿼리 미지원

### NewsFeed

- "View All Data" 권한 없으면 `LIMIT 1000` 이하 지정 필요
- 관계 필드 ORDER BY 미지원 (root Object 필드로만 ORDER BY)

### RecentlyViewed

- `FOR VIEW`/`FOR REFERENCE` 사용 시 자동 갱신
- Object당 200건으로 주기적 자동 정리 (90일 후 삭제)

### TopicAssignment

- "View All Data" 권한 없으면 `LIMIT 1100` 이하 또는 Id/Entity 필터 (`=`) 필수

### UserRecordAccess

- `HasAccess` SELECT 시 반드시 `ORDER BY HasAccess`
- `MaxAccessLevel` SELECT 시 반드시 `ORDER BY MaxAccessLevel`
- 최대 조회 건수: 200건

### UserProfileFeed

- "View All Data" 권한 없으면 `LIMIT 1000` 이하 지정 필요
- 관계 필드 ORDER BY 미지원
- `WITH UserId = [userId]` 반드시 포함

### Vote

```apex
// Vote 쿼리는 아래 조건 중 하나 필수
// ParentId = [single ID]
// Parent.Type = [single type]
// Id = [single ID]
// Id IN [list of IDs]
List<Vote> votes = [SELECT Id FROM Vote WHERE ParentId = :parentId];
```

---

## SELECT 예시 모음

| 목적 | 쿼리 |
|---|---|
| 기본 조회 | `SELECT Id, Name FROM Account WHERE Type = 'Customer'` |
| 전체 행 수 | `SELECT COUNT() FROM Account` |
| 필드별 집계 | `SELECT AccountId, COUNT(Id) FROM Contact GROUP BY AccountId` |
| 날짜 필터 | `SELECT Id FROM Opportunity WHERE CloseDate = THIS_QUARTER` |
| 관계 쿼리 | `SELECT Name, (SELECT LastName FROM Contacts) FROM Account` |
| 부모 필드 조회 | `SELECT Name, Account.Name FROM Contact` |
| 레코드 잠금 | `SELECT Id FROM Account WHERE Id IN :ids FOR UPDATE` |
| 최근 본 기록 | `SELECT Id, Name FROM Contact LIMIT 5 FOR VIEW` |
| 분기 소계 | `SELECT Status, COUNT(Id) FROM Case GROUP BY ROLLUP(Status)` |
| 타임존 변환 | `SELECT HOUR_IN_DAY(convertTimezone(CreatedDate)), COUNT(Id) FROM Lead GROUP BY HOUR_IN_DAY(convertTimezone(CreatedDate))` |

---

## 관련 노트

- [[SOQL 패턴]] — Apex 코드에서 USER_MODE 적용·for loop·집계 패턴
- [[SOSL 패턴]] — FIND 구문, IN 절, RETURNING, 여러 Object 전문 검색
- [[Dynamic SOQL]] — queryWithBinds, 동적 쿼리 인젝션 방어
- [[WITH USER_MODE]] — 보안 적용 기준 상세
- [[1 Overview]] — Field 타입·Compound Fields·Address/Geolocation SOQL 패턴
- [[6 Standard Objects]] — 표준 Object API 이름·도메인별 카탈로그
- [[Governor Limits]] — SOQL 행 수·쿼리 수 거버너 한도
- [[Database Namespace 상세]] — QueryLocator, Cursor 대용량 처리
- [[Summer '26]] — API v67.0 WITH SECURITY_ENFORCED 제거
