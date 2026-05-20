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
| [[SOSL 패턴]] | FIND 구문, IN 절, RETURNING, 여러 Object 전문 검색 | #pattern |
| [[DML 패턴]] | insert as user/system, Database.*(accessLevel), 부분 성공 | #pattern |
| [[Dynamic SOQL]] | queryWithBinds, SOQL 인젝션 방어 | #pattern |
| [[PagedResult 패턴]] | 페이지네이션 DTO, LIMIT+OFFSET, ?? null coalescing | #pattern |
| [[BusinessHours 패턴]] | BusinessHours.diff(), 영업시간 경과 계산, SLA 초과 여부 | #pattern |
| [[Database Namespace 상세]] | SaveResult/UpsertResult/MergeResult/Cursor/PaginationCursor/QueryLocator/DMLOptions/LeadConvert 전체 | #reference |
| [[Search Namespace]] | SOSL Apex API — Search.find(), Search.suggest(), SearchResult, KnowledgeSuggestionFilter | #reference |
| [[FormulaEval Namespace]] | Formula.builder() 동적 수식 평가 — evaluate(), getReferencedFields(), 템플릿 모드 | #reference |
| [[Reports Namespace]] | Apex에서 보고서 실행·조회 — ReportManager.runReport/runAsyncReport, FactMap, ReportMetadata | #reference |
| [[Datacloud Namespace]] | Duplicate Management API — FindDuplicates/FindDuplicatesByIds, DuplicateResult, MatchRecord (Salesforce Data Cloud 제품과 무관) | #reference |
| [[Wave Namespace]] | CRM Analytics Analytics SDK — QueryBuilder/QueryNode/ProjectionNode로 SAQL 쿼리 빌드·실행, Templates 조회 | #reference |

---

## 빠른 선택

- 일반 데이터 조회? → [[SOQL 패턴]]
- 여러 Object에서 키워드 검색? → [[SOSL 패턴]]
- 조건이 동적으로 바뀌는 쿼리? → [[Dynamic SOQL]]
- 레코드 삽입/수정/삭제? → [[DML 패턴]]
- 목록 페이지에 페이지네이션? → [[PagedResult 패턴]]
- SLA 경과 시간 / 영업시간 기준 계산? → [[BusinessHours 패턴]]
- DML 결과 처리, Cursor, LeadConvert 상세? → [[Database Namespace 상세]]
- SOSL 검색, 자동완성 제안? → [[Search Namespace]]
- 포뮬러 필드 값을 DML 없이 재계산? → [[FormulaEval Namespace]]
- Apex에서 보고서 실행·결과 분석? → [[Reports Namespace]]
- 중복 레코드 탐지·차단 처리? → [[Datacloud Namespace]] (Duplicate Management)
- DML 에러에서 중복 정보 추출? → [[Datacloud Namespace]] → DuplicateResult
- Apex에서 SAQL 쿼리로 CRM Analytics 데이터 조회? → [[Wave Namespace]] → QueryBuilder.load
- CRM Analytics 집계(sum/avg/count)를 Apex로? → [[Wave Namespace]] → ProjectionNode
- CRM Analytics 템플릿 목록 Apex로 가져오기? → [[Wave Namespace]] → Templates.getTemplates

## 보안 연동

SOQL 보안 → [[WITH USER_MODE]] | DML 보안 → [[Safely]] (Security(보안) 폴더)
