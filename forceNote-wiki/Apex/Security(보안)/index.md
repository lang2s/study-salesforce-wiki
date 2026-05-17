---
tags: [index, apex, security]
created: 2026-05-17
---

# Security(보안) — 로컬 인덱스

> Apex 보안 — FLS, CRUD, 공유 규칙, DML 보안 패턴

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Safely]] | Fluent DML API — allOrNothing, throwIfRemovedFields | #pattern |
| [[CanTheUser]] | CRUD/FLS 체크 — create/edit/destroy/flsAccessible | #pattern |
| [[StripInaccessible]] | AccessType별 FLS 필드 제거 — POST 바디 보안 | #pattern |
| [[WITH USER_MODE]] | SOQL/DML 인라인 보안 키워드 — USER_MODE vs SYSTEM_MODE | #pattern |

---

## 빠른 선택

- DML 전에 FLS/CRUD 보안 적용? → [[Safely]] (DML) + [[WITH USER_MODE]] (SOQL)
- 사용자에게 권한 있는지 코드에서 확인? → [[CanTheUser]]
- 외부 입력 데이터의 접근 불가 필드 제거? → [[StripInaccessible]]
- SOQL에서 바로 사용자 권한 적용? → [[WITH USER_MODE]]

## 보안 계층 관계

```
SOQL 보안  →  WITH USER_MODE (쿼리 단)
DML 보안   →  Safely (DML 단)
사전 체크  →  CanTheUser (조건 분기)
입력 정화  →  StripInaccessible (데이터 정제)
```
