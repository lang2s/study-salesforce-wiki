---
tags: [admin, security, mfa, authentication, identity-verification]
source: basics.pdf
created: 2026-05-19
aliases: [MFA, 다중 인증, Multi-Factor Authentication, Salesforce Authenticator, 신원 확인, 이중 인증]
---

# Salesforce ID 인증

> Salesforce는 데이터 보안을 위해 MFA(다중 인증)를 필수 적용하며, 여러 인증 방식을 지원한다.

---

## 왜 MFA가 의무화되었나

Salesforce는 2022년부터 모든 사용자에게 MFA를 의무 적용했다. 배경은 두 가지다.

1. **크리덴셜 탈취 공격 급증** — 비밀번호만으로는 피싱·브루트포스 공격을 막을 수 없다. 두 번째 인증 수단이 있으면 비밀번호가 탈취되어도 계정이 안전하다.
2. **Salesforce 데이터의 높은 가치** — 고객 정보·거래 데이터·개인정보가 집중되어 있어 단일 계정 탈취의 피해가 크다. 금융·의료·공공 분야는 규제(HIPAA, PCI-DSS 등)에서도 MFA를 요구한다.

**관리자가 흔히 실수하는 설정:**

| 실수 | 결과 | 올바른 처리 |
|---|---|---|
| 시스템 관리자 프로필에만 MFA 적용 | 일반 사용자 계정이 공격 대상이 됨 | 모든 프로필에 MFA 적용 |
| Trusted IP에 너무 넓은 범위 설정 | 사무실 외부에서도 MFA 면제됨 | 정확한 사무실 IP 대역만 허용 |
| API 전용 계정에도 MFA 강제 | CI/CD·연동 서비스 인증 실패 | Connected App + OAuth Flow 사용 |
| 이메일 인증을 기본값으로 유지 | 이메일 계정 탈취 시 우회 가능 | Salesforce Authenticator 또는 TOTP 앱 사용 |

---

## MFA (Multi-Factor Authentication)

MFA는 로그인 시 **비밀번호 + 별도 인증 수단**을 조합해 보안을 강화한다. Salesforce는 2022년부터 MFA를 **의무화**했다.

```
// 구조 예시 — 실제 동작 코드 아님
로그인 흐름
1. 아이디 + 비밀번호 입력
2. 추가 인증 수단 확인 (아래 방법 중 하나)
3. 접속 완료
```

---

## 지원되는 인증 방법

| 인증 방법 | 설명 | 보안 수준 |
|---|---|---|
| **Salesforce Authenticator 앱** | Salesforce 공식 모바일 앱. 푸시 알림으로 1탭 승인 | ⭐⭐⭐ 권장 |
| **TOTP 앱** (Google Authenticator 등) | 30초마다 갱신되는 6자리 코드 입력 | ⭐⭐⭐ |
| **보안 키** (FIDO2/WebAuthn) | USB/NFC 물리 보안 키 | ⭐⭐⭐⭐ |
| **내장 인증기** (Face ID, Touch ID) | 기기 생체 인증 | ⭐⭐⭐ |
| **이메일 인증** | 이메일로 전송된 코드 입력 (보안 낮음) | ⭐ |

---

## Salesforce Authenticator 앱 설정

```
// 구조 예시 — 실제 동작 코드 아님
설정 순서:
1. 모바일에서 "Salesforce Authenticator" 앱 설치 (iOS/Android)
2. Salesforce → 개인 설정 → "고급 사용자 세부 사항" → "앱 등록" 클릭
3. Authenticator 앱에서 새 계정 추가 → QR 코드 스캔
4. 앱에서 확인 코드 생성 → Salesforce에 입력
5. 연결 완료 — 이후 로그인 시 푸시 알림으로 승인
```

---

## 신원 확인 정책 설정 (관리자)

```
// 구조 예시 — 실제 동작 코드 아님
Setup → Identity → Identity Verification

설정 가능 항목:
- MFA 필수 적용 대상 프로필/권한 세트
- 로그인 위치 변경 시 재인증
- 세션 유효 기간
- 위치 기반 신뢰(Trusted IP Ranges) — 특정 IP에서는 MFA 면제
```

---

## Trusted IP Ranges (신뢰된 IP 범위)

특정 IP 대역에서 로그인할 때 MFA 단계를 건너뛸 수 있도록 설정.

```
// 구조 예시 — 실제 동작 코드 아님
Setup → Security → Network Access → Trusted IP Ranges

예시:
- 사무실 IP 대역: 203.0.113.0 ~ 203.0.113.255
  → 해당 IP에서 로그인 시 MFA 생략
- 재택근무 환경: MFA 필수
```

---

## 개발자를 위한 고려사항

| 상황 | 권장 설정 |
|---|---|
| Sandbox 접속 | MFA 의무 적용 (Production과 동일) |
| API 연동 (Connected App) | OAuth 흐름 사용, MFA 면제 가능 |
| Apex / Flow 자동화 | 시스템 컨텍스트로 실행, MFA 비적용 |
| CI/CD 파이프라인 | JWT Bearer Flow 또는 Connected App 인증서 사용 |

---

## 관련 노트

- [[Salesforce 네비게이션]] — 로그인 후 화면 구조
- [[Architecture(아키텍처)/Salesforce 플랫폼 개요]] — Salesforce 기초 개념
- [[Apex/Security(보안)/index]] — Apex 코드 보안
