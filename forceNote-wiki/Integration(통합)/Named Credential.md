---
tags: [salesforce, integration, named-credential, security, pattern]
source: apex-recipes/RestClient.cls, NamedCredentialRecipes.cls
created: 2026-05-17
aliases: [Named Credential, 네임드 크레덴셜, callout:]
---

# Named Credential

> 외부 시스템 URL과 인증 정보를 Salesforce에 저장하고 Apex에서 `callout:{NC_Name}` 형식으로 참조. 코드에 URL/비밀번호를 하드코딩하지 않는 Salesforce 표준 방식.

---

## 개념

외부 시스템을 Apex callout으로 연동할 때 URL과 인증 정보를 코드에 직접 쓰면 두 가지 문제가 생긴다. 첫째, 비밀번호나 API Key가 소스 코드에 노출되어 버전 관리 시스템에 평문으로 저장된다. 둘째, Sandbox와 Production이 서로 다른 엔드포인트를 써야 할 때 코드를 배포해야 변경된다.

Named Credential은 이 두 문제를 모두 해결하는 Salesforce 표준 메커니즘이다. URL과 인증 정보를 Setup에 저장하고, Apex 코드에서는 `callout:NC_Developer_Name` 형식의 논리적 이름만 사용한다. 환경별로 Named Credential 레코드의 URL만 바꾸면 코드 변경 없이 엔드포인트를 교체할 수 있다. OAuth 2.0 프로토콜을 사용할 경우 Salesforce가 토큰 갱신을 자동으로 처리해 만료된 토큰 관련 에러를 직접 처리하지 않아도 된다.

Spring '23부터 Legacy Named Credential과 신형 Named Credential + External Credential 구조로 분리되었다. 신형 구조에서는 인증 정보(External Credential)와 엔드포인트 URL(Named Credential)을 각각 독립적으로 관리할 수 있다.

---

## Apex에서 사용하는 형식

```apex
// 기본 형식
req.setEndpoint('callout:GoogleBooksAPI/volumes?q=' + keyword);

// Named Credential 이름 + 경로
// callout:{DeveloperName}/{path}?{querystring}

// 예시
req.setEndpoint('callout:MyRestApi/api/v1/accounts/');
req.setEndpoint('callout:Stripe/v1/charges?limit=10');
```

---

## RestClient에서의 활용

```apex
// RestClient 상속 서비스 클래스
public with sharing class BookApiService extends RestClient {

    public BookApiService() {
        namedCredentialName = 'GoogleBooksAPI'; // ← Named Credential Developer Name
    }

    public List<BookModel> searchBooks(String keyword) {
        // RestClient.get()이 내부적으로 callout:GoogleBooksAPI/{path} 구성
        HttpResponse response = get('volumes?q=' + EncodingUtil.urlEncode(keyword, 'UTF-8'));
        // 응답 처리...
    }
}
```

---

## Named Credential 종류

| 종류 | 설명 |
|---|---|
| Legacy Named Credential | URL + 인증 정보 통합 (구형) |
| Named Credential (신형) | URL + External Credential 분리 |
| External Credential | 인증 정보만 별도 관리 |
| Per-User Principal | 사용자별 인증 정보 |

---

## 설정 경로

```
Setup → Security → Named Credentials → New Named Credential

필드:
- Label: 화면 표시명
- Name (Developer Name): Apex에서 참조하는 이름
- URL: 외부 시스템 Base URL
- Identity Type: Named Principal / Per-User
- Authentication Protocol: No Auth / Password / OAuth 2.0 / JWT / AWS Signature V4
```

---

## ConnectApi를 통한 Named Credential 생성 (코드)

```apex
// 코드로 Named Credential 생성 (apex-recipes/NamedCredentialRecipes.cls 패턴)
ConnectApi.ExternalCredentialInput credInput = new ConnectApi.ExternalCredentialInput();
credInput.developerName = 'MyExternalCred';
credInput.label = 'My External Credential';
credInput.authenticationProtocol = ConnectApi.CredentialAuthenticationProtocol.NoAuthentication;

ConnectApi.ExternalCredential cred =
    ConnectApi.NamedCredentials.createExternalCredential(credInput);
```

> [!note] ConnectApi 테스트 제약
> `ConnectApi.NamedCredentials`는 `@isTest(SeeAllData=true)` 없이 호출 불가.
> → 래퍼 클래스로 감싸서 `TestDouble`로 모킹. ([[StubProvider]] 참조)

---

## 인증 프로토콜별 선택

| 프로토콜 | 사용 시점 |
|---|---|
| No Authentication | API Key를 헤더로 직접 전달 (코드에서) |
| Password | 기본 인증 (Basic Auth) |
| OAuth 2.0 | OAuth flow (Salesforce가 토큰 관리) |
| JWT Token Bearer | JWT 기반 M2M |
| AWS Signature V4 | AWS 서비스 |

---

## 보안 모범 사례

> [!tip] Named Credential 사용 이유
> 1. URL/비밀번호가 Apex 코드에 노출되지 않음
> 2. 환경별(Sandbox/Production) URL 분리 관리
> 3. Salesforce가 토큰 갱신 자동 처리 (OAuth)
> 4. 감사 로그에서 추적 가능

---

## 주의사항

- **Remote Site Setting 불필요** — Named Credential을 사용하는 Apex callout은 Remote Site Setting을 별도로 등록하지 않아도 된다. Named Credential 자체가 허용 목록 역할을 한다.
- **경로(path)는 코드에서 지정** — Named Credential에는 Base URL만 저장한다. 리소스 경로(`/api/v1/users`)는 `callout:NC_Name/api/v1/users` 형태로 Apex 코드에서 이어 붙인다.
- **Per-User Principal과 실행 컨텍스트** — Per-User Identity Type을 사용할 때 배치/큐어블 등 비동기 컨텍스트에서는 사용자 컨텍스트가 없어 인증 정보를 찾지 못할 수 있다. Named Principal을 사용하거나 실행 컨텍스트를 확인한다.
- **테스트에서의 callout 모킹** — `@isTest`에서도 `HttpCalloutMock`을 구현해 callout을 모킹해야 한다. Named Credential을 사용해도 테스트 메서드에 `Test.setMock()`은 필수.
- **외부 인증 흐름 (OAuth)** — OAuth 2.0 설정 시 콜백 URL을 외부 시스템에 등록해야 한다. Salesforce 콜백 URL은 `https://[인스턴스].salesforce.com/services/authcallback/[NC_Name]` 형식.

## 관련 노트

- [[RestClient 패턴]]
- [[Custom REST Endpoint]]
- [[StubProvider]] — ConnectApi 래퍼 테스트

