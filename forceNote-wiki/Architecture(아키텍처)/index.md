---
tags: [index, architecture, apex, lwc, flow]
created: 2026-05-17
---

# Architecture(아키텍처) — 로컬 인덱스

> Salesforce 설계 패턴 — 서비스 레이어, 권한 설계, 네임스페이스 레퍼런스 (Apex·LWC·Flow 공통)

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[서비스 레이어 패턴]] | TriggerHandler → ServiceLayer 브로커 분리, 재사용 가능한 비즈니스 로직 | #pattern |
| [[Permission Set 설계]] | objectPermissions, fieldPermissions, classAccesses 구성 표준 | #pattern |
| [[Approval Namespace]] | Apex에서 승인 프로세스 제출·처리·잠금 — ProcessSubmitRequest, ProcessWorkitemRequest | #reference |
| [[Schema Namespace 상세]] | DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship 전체 | #reference |
| [[Salesforce 플랫폼 개요]] | Org/Object/Record/Field/App, Cloud 종류, 환경 구분 | #concept |
| [[System Namespace]] | System 네임스페이스 전체 클래스 레퍼런스 — AccessLevel, Assert, AsyncOptions, UserInfo, UUID, Callable, FeatureManagement | #reference |

---

## 빠른 선택

- Trigger 로직을 어디에 둘지? → [[서비스 레이어 패턴]]
- 권한 세트 메타데이터 구성? → [[Permission Set 설계]]
- Apex에서 승인 프로세스 제출? → [[Approval Namespace]]
- 오브젝트/필드/레코드 타입 메타데이터 조회? → [[Schema Namespace 상세]]
- DML 실행 모드(USER_MODE/SYSTEM_MODE) 제어? → [[System Namespace]] → AccessLevel
- 현재 사용자 정보 조회? → [[System Namespace]] → UserInfo
- UUID 생성? → [[System Namespace]] → UUID
- 패키지 간 느슨한 결합 인터페이스? → [[System Namespace]] → Callable

## 관련 폴더

트리거 구현 세부 → [[Apex/Trigger(트리거)/index|Trigger(트리거)]] | 보안 적용 → [[Apex/Security(보안)/index|Security(보안)]]
