---
tags: [apex, external-service, namespace, openapi, type-safe-callout, external-service-registration]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [ExternalService Namespace, External Service Registration, OpenAPI Apex, 타입 안전 외부 호출]
---

# ExternalService Namespace

> Salesforce에 등록된 외부 서비스(OpenAPI 스펙 기반)가 자동 생성하는 타입 안전 Apex 인터페이스. 고정 클래스 목록이 없으며, 등록된 서비스의 API 스펙이 Apex 타입으로 매핑된다.

---

## 개념

`ExternalService` 네임스페이스는 미리 정의된 클래스가 **없다.** Setup → External Services에서 OpenAPI 스펙을 등록하면, 해당 스펙의 오퍼레이션과 스키마가 아래 패턴으로 Apex에 자동 노출된다.

```
ExternalService.<ServiceName>.<OperationName>
ExternalService.<ServiceName>.<TypeName>
```

---

## 사용 패턴

```apex
// 등록된 서비스: "AccountAPI" (OpenAPI 3.0)
// 오퍼레이션: GET /accounts/{id}  →  AccountAPI.getAccountById

// 1. 입력 객체 생성 (스펙의 request body/parameter 타입)
ExternalService.AccountAPI.getAccountByIdInput input =
    new ExternalService.AccountAPI.getAccountByIdInput();
input.id = '001xx0000000001';

// 2. 서비스 인스턴스 생성 및 호출
ExternalService.AccountAPI client = new ExternalService.AccountAPI();
ExternalService.AccountAPI.getAccountByIdResponse response =
    client.getAccountById(input);

// 3. 응답 처리 (HTTP 상태코드별 타입 분기)
if (response.Code == 200) {
    ExternalService.AccountAPI.Account_v1 acc = response.body;
    System.debug(acc.name);
}
```

---

## 등록 방법

1. **Setup** → External Services → **Add an External Service**
2. OpenAPI 2.0 / 3.0 스펙 URL 또는 JSON 붙여넣기
3. Named Credential 연결
4. 사용할 오퍼레이션 선택 → **Save**
5. Apex에서 `ExternalService.<ServiceName>` 으로 바로 사용

---

## 제약 및 주의사항

| 항목 | 내용 |
|---|---|
| 스펙 기반 생성 | 클래스·메서드명은 스펙 오퍼레이션 ID에서 파생 |
| 패키지 포함 시 | 패키지에 서비스를 수동으로 추가해야 함 |
| Flow 연동 | Flow의 "Action" 요소에서도 동일 서비스 호출 가능 |
| Named Credential 필수 | 직접 URL 지정 불가 — Named Credential 경유 |
| 테스트 | `HttpCalloutMock`으로 모킹 가능 |

---

## RestClient 패턴과 비교

| | ExternalService | RestClient 패턴 |
|---|---|---|
| 설정 | Setup UI (OpenAPI 스펙) | Apex 코드 직접 작성 |
| 타입 안전 | 자동 생성 클래스로 컴파일 타임 체크 | 수동 직렬화/역직렬화 |
| 유연성 | 스펙 범위 내 | 완전 자유 |
| 변경 대응 | 스펙 재등록으로 재생성 | 코드 직접 수정 |

---

## 관련 노트

- [[RestClient 패턴]] — 스펙 없이 HTTP 직접 구현
- [[Named Credential]] — ExternalService 인증 기반
- [[HttpCalloutMock]] — 테스트 모킹
