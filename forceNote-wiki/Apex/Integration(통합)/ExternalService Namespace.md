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

### 왜 존재하는가

Apex에서 외부 API를 호출하려면 전통적으로 `HttpRequest`를 수동으로 구성하고, JSON 응답을 직접 역직렬화해야 한다. API 스펙이 바뀌면 직렬화 코드도 함께 수동으로 수정해야 하며, 오타·타입 불일치를 컴파일 타임에 잡을 수 없다. `ExternalService` 네임스페이스는 이 문제를 해결한다. OpenAPI 스펙을 Setup에 등록하면 Salesforce가 타입 안전 Apex 클래스를 자동 생성하므로, 개발자는 HTTP 레이어를 직접 다루지 않고 **컴파일 타임에 검증되는 객체**로 외부 서비스를 호출할 수 있다.

### 언제 쓰나

- 외부 서비스가 OpenAPI 2.0 / 3.0 스펙을 제공하는 경우
- 여러 오퍼레이션을 반복 호출하며 타입 안전성이 중요한 경우
- Flow에서도 동일 서비스를 호출해야 하는 경우 (External Service 등록 하나로 Apex·Flow 모두 사용 가능)
- HTTP 직접 구현 대신 Setup UI 관리 방식을 선호하는 경우 (코드 없이 서비스 등록·수정 가능)

스펙 없이 HTTP를 자유롭게 구성해야 하면 RestClient 패턴을 사용한다.

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

> [!warning] 흔한 실수 — 클래스명이 스펙 operationId에서 파생됨
> 등록 후 Apex에서 사용할 클래스·메서드명은 OpenAPI 스펙의 `operationId` 값에서 자동 파생된다. `operationId`가 없거나 비표준 문자를 포함하면 생성된 이름이 예측 불가능해진다. 스펙 등록 전 `operationId`가 명확하고 일관되게 정의되어 있는지 반드시 확인한다.

> [!note] Governor Limits 적용 범위
> ExternalService 호출은 내부적으로 HTTP Callout을 사용하므로, Apex Callout 한도(트랜잭션당 100회)와 트랜잭션당 Callout 타임아웃이 동일하게 적용된다. `@future(callout=true)`, `Queueable + AllowsCallouts`, `Batch` 안에서 호출해야 하는 경우도 일반 Callout 규칙과 동일하다.

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
- [[External Services]] — Admin 설정 기반 외부 서비스 등록 가이드
- [[LxScheduler Namespace]] — Lightning Scheduler가 외부 캘린더 시스템을 ExternalService로 연동하는 호출자
