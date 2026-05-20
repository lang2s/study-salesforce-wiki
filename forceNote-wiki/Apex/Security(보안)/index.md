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
| [[Auth Namespace]] | JWT/JWS OAuth bearer token flow, MFA TOTP, SessionManagement, RegistrationHandler | #reference |
| [[TxnSecurity Namespace]] | Transaction Security Policy Apex — EventCondition, AsyncCondition, 실시간 이벤트 기반 차단·알림 정책 | #reference |
| [[UserProvisioning Namespace]] | 커넥티드 앱 아웃바운드 사용자 프로비저닝 — ConnectorTestUtil, UserProvisioningLog, UserProvisioningPlugin(reconOffset 청크 패턴) | #reference |

---

## 빠른 선택

- DML 전에 FLS/CRUD 보안 적용? → [[Safely]] (DML) + [[WITH USER_MODE]] (SOQL)
- 사용자에게 권한 있는지 코드에서 확인? → [[CanTheUser]]
- 외부 입력 데이터의 접근 불가 필드 제거? → [[StripInaccessible]]
- SOQL에서 바로 사용자 권한 적용? → [[WITH USER_MODE]]
- OAuth JWT Bearer Token Flow 구현? → [[Auth Namespace]]
- MFA / TOTP 세션 보안 또는 커스텀 로그인 플로우? → [[Auth Namespace]]
- Apex로 Transaction Security Policy 조건 구현? → [[TxnSecurity Namespace]] (EventCondition)
- 보안 정책에서 비동기 처리 필요? → [[TxnSecurity Namespace]] (AsyncCondition)
- 커넥티드 앱 사용자 프로비저닝 로그 기록? → [[UserProvisioning Namespace]] → UserProvisioningLog.log
- 프로비저닝 플러그인 커스터마이즈? → [[UserProvisioning Namespace]] → UserProvisioningPlugin
- 프로비저닝 테스트(@isTest 전용 시뮬레이션)? → [[UserProvisioning Namespace]] → ConnectorTestUtil

## 보안 계층 관계

```
SOQL 보안  →  WITH USER_MODE (쿼리 단)
DML 보안   →  Safely (DML 단)
사전 체크  →  CanTheUser (조건 분기)
입력 정화  →  StripInaccessible (데이터 정제)
```
