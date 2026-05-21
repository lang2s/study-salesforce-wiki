---
tags: [apex, soql, sosl, 선택기준, 성능]
source: salesforce_soql_sosl.pdf p.1-2 (v67.0 Summer '26)
created: 2026-05-22
aliases: [SOQL vs SOSL, SOQL SOSL 선택, 쿼리 언어 선택]
---

# SOQL SOSL 소개

> SOQL과 SOSL이 무엇인지, 언제 어떤 것을 써야 하는지, 성능 고려사항 요약

---

## SOQL vs SOSL — 선택 기준

| 조건 | SOQL | SOSL |
|---|---|---|
| 어떤 Object에 데이터가 있는지 알 때 | ✅ | |
| 단일 Object 또는 관련 Object 조회 | ✅ | |
| 레코드 수 카운트 | ✅ | |
| 결과를 쿼리 내에서 정렬 | ✅ | |
| 숫자·날짜·체크박스 필드 조회 | ✅ | |
| 어떤 Object·필드에 데이터가 있는지 모를 때 | | ✅ |
| 특정 용어가 필드 어딘가에 있다는 것만 알 때 | | ✅ |
| 관련 없는 여러 Object를 한 번에 검색 | | ✅ |
| Division 기능으로 특정 사업부 데이터 검색 | | ✅ |
| 중국어·일본어·한국어·태국어(CJKT) 검색 | | ✅ |

> [!note] SOSL은 Big Objects를 지원하지 않는다.

---

## 언제 SOQL을 써야 하는가

```apex
// 구체적인 Object와 필드를 알 때 → SOQL
List<Account> accs = [
    SELECT Id, Name, AnnualRevenue
    FROM Account
    WHERE Type = 'Customer'
    AND AnnualRevenue > 1000000
    ORDER BY Name
    WITH USER_MODE
];

// 관련 Object 함께 조회
List<Account> withContacts = [
    SELECT Id, Name, (SELECT Id, LastName FROM Contacts)
    FROM Account
    WHERE Industry = 'Technology'
    WITH USER_MODE
];

// 레코드 수 카운트
Integer cnt = [SELECT COUNT() FROM Lead WHERE Status = 'Open' WITH USER_MODE];
```

---

## 언제 SOSL을 써야 하는가

```apex
// 어떤 Object에 데이터가 있는지 모를 때 → SOSL
List<List<SObject>> results = [
    FIND 'John Smith'
    IN ALL FIELDS
    RETURNING Account(Id, Name), Contact(Id, Name), Lead(Id, Name)
];

// CJKT 형태소 분석 검색 (한국어, 일본어 등)
List<List<SObject>> korResults = [
    FIND '영업팀'
    IN ALL FIELDS
    RETURNING Account(Id, Name)
];

// 여러 관련 없는 Object 동시 검색
List<List<SObject>> multiObj = [
    FIND 'Acme'
    IN NAME FIELDS
    RETURNING Account(Id, Name), Opportunity(Id, Name, CloseDate), Case(Id, Subject)
];
```

---

## 성능 고려사항

| 항목 | 내용 |
|---|---|
| CONTAINS 조건 속도 | SOSL이 일반적으로 더 빠름 (검색 인덱스 활용) |
| 필드 내 다중 단어 검색 | SOSL이 유리 — 토큰화 후 인덱스 구축 |
| 필드·Object 수 최소화 | 검색 대상이 많을수록 순열 증가, 튜닝 어려움 |
| 정확한 필드/Object 알 때 | SOQL이 직접적이고 예측 가능 |

> [!tip] **규칙:** `WHERE Name LIKE '%John%'` 같은 CONTAINS 패턴이면 SOSL이 더 빠를 수 있다. 단, 결과가 반드시 필요한 특정 Object에 있다면 SOQL이 안전하다.

---

## 쿼리·검색 실행 환경

SOQL과 SOSL은 다음 환경에서 실행 가능하다:

| 환경 | SOQL | SOSL |
|---|---|---|
| Apex (Static) | ✅ | ✅ |
| Apex (Dynamic) | ✅ `Database.query()` | ✅ `Search.query()` |
| SOAP API | ✅ `query()` / `queryMore()` | ✅ `search()` |
| REST API | ✅ `/query` | ✅ `/search` |
| Developer Console (Query Editor) | ✅ | ✅ |

---

## 관련 노트

- [[SOQL 문법 레퍼런스]] — SELECT 전체 문법, 날짜 리터럴, 관계 쿼리
- [[SOSL 패턴]] — FIND 구문, IN 절, RETURNING, WITH 절 전체
- [[SOQL 패턴]] — Apex에서 USER_MODE, for loop, 집계 패턴
- [[Dynamic SOQL]] — Database.query(), queryWithBinds(), 인젝션 방어
- [[Governor Limits]] — SOQL 쿼리 수·행 수 거버너 한도
