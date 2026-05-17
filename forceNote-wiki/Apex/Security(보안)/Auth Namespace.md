---
tags: [apex, auth, namespace, jwt, jws, oauth, session-management, mfa, registration-handler]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Auth Namespace, Auth.JWT, Auth.JWS, Auth.JWTBearerTokenExchange, Auth.SessionManagement, JWT bearer token, OAuth JWT flow, MFA TOTP, 세션 관리]
---

# Auth Namespace

> Apex에서 OAuth 2.0 JWT bearer token flow 구현, MFA/TOTP 세션 보안, 커스텀 로그인 플로우를 처리하는 API.

---

## OAuth 2.0 JWT Bearer Token Flow

### 전체 흐름

```
Auth.JWT  →  (클레임 셋 생성)
    ↓
Auth.JWS  →  (인증서로 서명 → compact serialization)
    ↓
Auth.JWTBearerTokenExchange  →  (토큰 엔드포인트에 POST → access token)
```

### 완성 예제

```apex
// 1. JWT 클레임 셋 생성
Auth.JWT jwt = new Auth.JWT();
jwt.setSub('user@example.com');
jwt.setAud('https://login.salesforce.com');
jwt.setIss('3MVG99OxTyEMCQ3...ConnectedAppConsumerKey');

// 2. 추가 클레임 (scope 등)
Map<String, Object> claims = new Map<String, Object>();
claims.put('scope', 'api refresh_token');
jwt.setAdditionalClaims(claims);

// 3. 인증서로 서명 (JWS)
Auth.JWS jws = new Auth.JWS(jwt, 'MyCertDevName'); // Certificate & Key Management의 Unique Name
String token = jws.getCompactSerialization(); // 디버깅용

// 4. 토큰 엔드포인트에 POST
String tokenEndpoint = 'https://login.salesforce.com/services/oauth2/token';
Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);

// 5. access token 추출
String accessToken = bearer.getAccessToken();
// 또는 전체 HTTP 응답:
System.HttpResponse fullResponse = bearer.getHttpResponse();
```

---

## Auth.JWT — JWT 클레임 셋 생성

| 메서드 | 설명 |
|---|---|
| `setIss(iss)` | issuer 클레임 (Connected App Consumer Key) |
| `setSub(sub)` | subject 클레임 (사용자 이름) |
| `setAud(aud)` | audience 클레임 (토큰 엔드포인트 URL) |
| `setNbfClockSkew(seconds)` | not-before 클레임 (클럭 스큐 허용) |
| `setValidityLength(seconds)` | exp 클레임 결정 (기본 3분) |
| `setAdditionalClaims(map)` | scope 등 추가 클레임 |
| `getIss()` / `getAud()` / `getSub()` | 각 클레임 반환 |
| `getAdditionalClaims()` | 추가 클레임 맵 반환 |

---

## Auth.JWS — JWT 서명 (JSON Web Signature)

```apex
// 방법 A — Auth.JWT 객체로 생성
Auth.JWS jwsA = new Auth.JWS(jwt, 'CertDevName');

// 방법 B — Base64 payload 문자열로 직접 생성
Auth.JWS jwsB = new Auth.JWS(base64EncodedPayload, 'CertDevName');

// compact serialization: header.payload.signature (Base64URL)
String serialized = jwsA.getCompactSerialization();
```

- `certDevName`: Setup → Certificate and Key Management 에서의 **Unique Name**
- 반환값: `header.payload.signature` 형식의 Base64URL 인코딩 문자열

---

## Auth.JWTBearerTokenExchange — 토큰 교환

| 메서드 | 설명 |
|---|---|
| `new Auth.JWTBearerTokenExchange(endpoint, jws)` | 생성자 — endpoint에 POST |
| `getAccessToken()` | `access_token` 값 추출 |
| `getHttpResponse()` | 전체 System.HttpResponse |
| `getJWS()` | 사용된 JWS 반환 |
| `getTokenEndpoint()` | 설정된 엔드포인트 반환 |
| `setGrantType(grantType)` | grant_type 재정의 (기본: `urn:ietf:params:oauth:grant-type:jwt-bearer`) |
| `setTokenEndpoint(endpoint)` | 엔드포인트 설정 |
| `setJWS(jws)` | JWS 재설정 |

---

## Auth.SessionManagement — 세션 / MFA / 로그인 플로우

```apex
// 현재 세션 속성 조회
Map<String, String> sessionInfo = Auth.SessionManagement.getCurrentSession();
// 키: 'SessionId', 'SessionType', 'UserType', 'LoginType', 'CommunityUrl' 등

// 세션 보안 레벨 상승 (MFA 요구 후)
Auth.SessionManagement.setSessionLevel(Auth.SessionLevel.HIGH_ASSURANCE);

// MFA — TOTP 검증
Boolean valid = Auth.SessionManagement.validateTotpTokenForUser(totpCode, 'My App Verification');
// 또는 공유 키로 검증 (TOTP 기기 등록 시)
Boolean validKey = Auth.SessionManagement.validateTotpTokenForKey(sharedKey, totpCode, 'MFA Setup');

// QR 코드 및 shared secret 생성 (TOTP 앱 등록용)
Map<String, String> qrData = Auth.SessionManagement.getQrCode();
String qrUrl    = qrData.get('qrcode');      // QR 이미지 URL
String secret   = qrData.get('secret');      // TOTP shared secret

// IP 범위 검증
Boolean inRange = Auth.SessionManagement.inOrgNetworkRange('203.0.113.10');
Boolean allowed = Auth.SessionManagement.isIpAllowedForProfile(profileId, '203.0.113.10');

// 로그인 플로우 완료 (Visualforce login flow)
PageReference homePR    = Auth.SessionManagement.finishLoginFlow();
PageReference customPR  = Auth.SessionManagement.finishLoginFlow('/apex/myPage');

// MFA 재인증 URL 생성 (고위험 페이지 접근 전)
String verifyUrl = Auth.SessionManagement.generateVerificationUrl(
    Auth.VerificationPolicy.MEDIUM_ASSURANCE,
    'Accessing Sensitive Data',
    '/apex/SensitiveDetails'
);
```

### 주요 SessionManagement 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getCurrentSession()` | `Map<String,String>` | 현재 세션 속성 |
| `setSessionLevel(level)` | `void` | HIGH_ASSURANCE / STANDARD |
| `validateTotpTokenForUser(code, desc)` | `Boolean` | 현재 사용자 TOTP 검증 |
| `validateTotpTokenForKey(key, code, desc)` | `Boolean` | 공유 키로 TOTP 검증 |
| `getQrCode()` | `Map<String,String>` | TOTP QR URL + shared secret |
| `inOrgNetworkRange(ip)` | `Boolean` | 조직 신뢰 IP 범위 내 여부 |
| `isIpAllowedForProfile(profileId, ip)` | `Boolean` | 프로필 신뢰 IP 허용 여부 |
| `finishLoginFlow()` | `PageReference` | 로그인 플로우 완료 → 홈 |
| `finishLoginFlow(startUrl)` | `PageReference` | 로그인 플로우 완료 → URL |
| `generateVerificationUrl(policy, desc, destUrl)` | `String` | 신원 확인 URL 생성 |
| `getLightningLoginEligibility(userId)` | `Auth.LightningLoginEligibility` | Lightning Login 적격성 |

---

## Auth.RegistrationHandler (인터페이스)

SSO/OAuth 인증 후 사용자를 자동 프로비저닝 또는 매핑할 때 구현한다.

```apex
global class MyRegHandler implements Auth.RegistrationHandler {
    global User createUser(Id portalId, Auth.UserData data) {
        // 신규 사용자 생성 또는 기존 사용자 반환
        User u = new User();
        u.Username = data.email;
        u.Email    = data.email;
        u.LastName = data.lastName ?? 'Unknown';
        u.FirstName = data.firstName;
        u.Alias    = data.email.left(8);
        u.ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id;
        return u;
    }
    global void updateUser(Id userId, Id portalId, Auth.UserData data) {
        // 기존 사용자 속성 갱신
        User u = new User(Id = userId, Email = data.email);
        update u;
    }
}
```

- `Auth.UserData`: `username`, `email`, `firstName`, `lastName`, `locale`, `provider`, `siteLoginUrl`, `identifier`, `attributeMap`

---

## 관련 노트

- [[Named Credential]] — JWT 교환에 사용할 외부 자격증명 관리
- [[RestClient 패턴]] — Bearer token을 Authorization 헤더로 전달
- [[CanTheUser]] — Apex 내 권한 체크 (인증과 구분)
- [[테스트 전략]] — Auth.HttpCalloutMockUtil로 토큰 엔드포인트 모킹
