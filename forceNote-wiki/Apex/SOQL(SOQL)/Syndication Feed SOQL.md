---
tags: [apex, soql, syndication-feed, rss, atom]
source: salesforce_soql_sosl.pdf p.90 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Syndication Feed SOQL, 피드 SOQL, RSS 피드 SOQL]
---

# Syndication Feed SOQL

> Syndication Feed 서비스가 Object 집합을 가리키거나 Object 간 관계를 탐색할 때 사용하는 SOQL 쿼리·매핑 문법 — 공개 사이트(Public Site) 적용 가능

---

## 개요

Syndication Feed는 SOQL 쿼리와 매핑 사양을 조합하여 다음을 수행한다:
- Object 집합 또는 단일 Object를 가리킴
- Object 간 관계 탐색
- 쿼리 문자열 파라미터로 데이터 필터링·표현 방식 제어
- 공개 사이트(Public Site)에서도 피드 정의 가능

> [!note] Syndication Feed SOQL의 상세 제한 사항은 Salesforce Help의 Syndication Feed 문서에서 관리된다. PDF(v67.0)에서는 공식 Help로 위임.

---

## 기본 사용 패턴

Syndication Feed는 주로 REST API 또는 SOAP API 쿼리 파라미터로 피드를 정의할 때 사용된다. Apex 코드에서 직접 실행하는 방식이 아니라 피드 정의 문서(Feed Definition XML/URL)에 SOQL을 삽입하는 형태다.

```
// 피드 정의에서 SOQL 쿼리 예시 (구조 예시 — 실제 동작 코드 아님)
SELECT Id, Name, Description__c, ImageUrl__c
FROM Product__c
WHERE Active__c = true
ORDER BY Name
LIMIT 50
```

쿼리 문자열 파라미터 예:
- `?start=0&count=20` — 페이지 시작·건수 제어
- `?filter=Category__c='Electronics'` — 추가 필터

---

## Apex에서 피드 데이터 조회

Syndication Feed 데이터를 Apex로 조회할 때는 일반 SOQL을 사용한다.

```apex
// 피드에 포함될 공개 제품 목록 조회
List<Product__c> feedItems = [
    SELECT Id, Name, Description__c, Price__c, ImageUrl__c
    FROM Product__c
    WHERE Active__c = true
    AND PublicFeed__c = true
    ORDER BY Name
    LIMIT 50
    WITH USER_MODE
];
```

---

## 제한 사항

| 항목 | 내용 |
|---|---|
| 상세 제한 문서 | Salesforce Help — Syndication Feeds 참조 |
| 공개 사이트 | Guest User 컨텍스트에서 실행 → 공개된 Object만 접근 가능 |
| 관계 탐색 | SOQL 관계 쿼리(서브쿼리) 사용 가능 |
| 데이터 노출 | 피드에 노출될 필드는 최소화 (PII 포함 금지) |

---

## 관련 노트

- [[SOQL 문법 레퍼런스]] — SOQL SELECT 전체 문법
- [[SOQL SOSL 소개]] — SOQL vs SOSL 선택 기준
- [[SOQL 패턴]] — WITH USER_MODE, SOQL for loop
