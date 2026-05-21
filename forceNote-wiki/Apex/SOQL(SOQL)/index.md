---
tags: [index, apex, soql, sosl, data]
created: 2026-05-22
---

# SOQL(SOQL) — 로컬 인덱스

> SOQL·SOSL 문법 레퍼런스, 코딩 패턴, 동적 쿼리, 카테고리 필터, 피드 매핑

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[SOQL SOSL 소개]] | SOQL vs SOSL 선택 기준, 언제 무엇을 쓸지, 성능 고려사항 | #guide |
| [[SOQL 문법 레퍼런스]] | SELECT 전체 문법, 날짜 리터럴 44개, 집계 함수, 관계 쿼리, ROLLUP/CUBE, 세미조인, Object별 제한 | #reference |
| [[SOQL WITH DATA CATEGORY]] | Knowledge/Question 카테고리 필터, AT/ABOVE/BELOW/ABOVE_OR_BELOW, RecordVisibilityContext | #reference |
| [[Syndication Feed SOQL]] | 커스텀 피드 동기화용 SOQL 매핑 문법 | #reference |
| [[SOQL 패턴]] | WITH USER_MODE, SOQL for loop, 집계 패턴, Apex Cursor | #pattern |
| [[Dynamic SOQL]] | queryWithBinds, SOQL 인젝션 방어 | #pattern |
| [[SOSL 패턴]] | FIND 구문, IN SearchGroup, RETURNING, 여러 Object 전문 검색 | #pattern |

---

## 빠른 선택

- SOQL vs SOSL 언제 쓸지? → [[SOQL SOSL 소개]]
- SELECT 전체 문법·날짜 리터럴·집계 함수? → [[SOQL 문법 레퍼런스]]
- Knowledge/Question 카테고리 필터? → [[SOQL WITH DATA CATEGORY]]
- 커스텀 피드 SOQL 매핑? → [[Syndication Feed SOQL]]
- WITH USER_MODE, SOQL for loop? → [[SOQL 패턴]]
- 동적 쿼리·인젝션 방어? → [[Dynamic SOQL]]
- 여러 Object에서 키워드 검색? → [[SOSL 패턴]]
