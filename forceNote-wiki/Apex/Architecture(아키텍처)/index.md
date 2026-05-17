---
tags: [index, apex, architecture]
created: 2026-05-17
---

# Architecture(아키텍처) — 로컬 인덱스

> Apex 계층 설계 — 서비스 레이어, 권한 설계

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[서비스 레이어 패턴]] | TriggerHandler → ServiceLayer 브로커 분리, 재사용 가능한 비즈니스 로직 | #pattern |
| [[Permission Set 설계]] | objectPermissions, fieldPermissions, classAccesses 구성 표준 | #pattern |
| [[Approval Namespace]] | Apex에서 승인 프로세스 제출·처리·잠금 — ProcessSubmitRequest, ProcessWorkitemRequest | #reference |
| [[Schema Namespace 상세]] | DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship 전체 | #reference |

---

## 빠른 선택

- Trigger 로직을 어디에 둘지? → [[서비스 레이어 패턴]]
- 권한 세트 메타데이터 구성? → [[Permission Set 설계]]
- Apex에서 승인 프로세스 제출? → [[Approval Namespace]]
- 오브젝트/필드/레코드 타입 메타데이터 조회? → [[Schema Namespace 상세]]

## 관련 폴더

트리거 구현 세부 → [[Apex/Trigger(트리거)/index|Trigger(트리거)]] | 보안 적용 → [[Apex/Security(보안)/index|Security(보안)]]
