---
tags: [index, apex, data, soql, dml]
created: 2026-05-17
---

# Data(데이터) — 로컬 인덱스

> SOQL 쿼리, DML 조작, 동적 쿼리, 페이지네이션 패턴

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[SOQL 패턴]] | WITH USER_MODE, SOQL for loop, 거버너 한도 회피 | #pattern |
| [[DML 패턴]] | insert as user/system, Database.*(accessLevel), 부분 성공 | #pattern |
| [[Dynamic SOQL]] | queryWithBinds, SOQL 인젝션 방어 | #pattern |
| [[PagedResult 패턴]] | 페이지네이션 DTO, LIMIT+OFFSET, ?? null coalescing | #pattern |
| [[BusinessHours 패턴]] | BusinessHours.diff(), 영업시간 경과 계산, SLA 초과 여부 | #pattern |
| [[Database Namespace 상세]] | SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert 전체 | #reference |
| [[Search Namespace]] | SOSL Apex API — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter | #reference |
| [[FormulaEval Namespace]] | Formula.builder() 동적 수식 평가 — evaluate(), getReferencedFields(), 템플릿 모드 | #reference |

---

## 빠른 선택

- 일반 데이터 조회? → [[SOQL 패턴]]
- 조건이 동적으로 바뀌는 쿼리? → [[Dynamic SOQL]]
- 레코드 삽입/수정/삭제? → [[DML 패턴]]
- 목록 페이지에 페이지네이션? → [[PagedResult 패턴]]
- SLA 경과 시간 / 영업시간 기준 계산? → [[BusinessHours 패턴]]
- DML 결과 처리, Cursor, LeadConvert 상세? → [[Database Namespace 상세]]
- SOSL 검색, 자동완성 제안? → [[Search Namespace]]
- 포뮬러 필드 값을 DML 없이 재계산? → [[FormulaEval Namespace]]

## 보안 연동

SOQL 보안 → [[WITH USER_MODE]] | DML 보안 → [[Safely]] (Security(보안) 폴더)
