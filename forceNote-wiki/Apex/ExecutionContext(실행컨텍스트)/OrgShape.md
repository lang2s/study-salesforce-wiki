---
tags: [apex, org, sandbox, environment, pattern]
source: apex-recipes/OrgShape.cls
created: 2026-05-17
aliases: [OrgShape, 조직 환경 확인, Sandbox 확인]
---

# OrgShape — 조직 환경 정보

> `OrgShape`는 현재 Salesforce Org의 환경 정보(Sandbox/Production, Multi-Currency, Person Account 등)를 캡슐화하는 유틸리티.

---

## 개념

Apex 코드가 어떤 조직 환경에서 실행되는지에 따라 동작을 분기해야 하는 경우가 있다. 예를 들어 Multi-Currency가 활성화된 조직에서만 `CurrencyIsoCode` 필드가 존재하며, Person Account가 꺼진 조직에서 `IsPersonAccount` 필드를 참조하면 에러가 발생한다. Sandbox에서만 상세 디버그 로그를 남기고 싶을 때도 있다.

이런 org 환경 정보를 매번 직접 쿼리하거나 Schema API를 호출하면 코드 중복이 생기고, 팀 내 구현이 제각각이 된다. `OrgShape`는 이런 환경 확인 로직을 단일 유틸리티 클래스로 캡슐화해서 일관된 인터페이스를 제공한다.

---

## 주요 메서드

```apex
// Sandbox 여부
if (OrgShape.isSandbox()) {
    // 개발/테스트 환경 전용 로직
}

// 멀티 커런시 활성화 여부
if (OrgShape.isMultiCurrencyEnabled()) {
    // CurrencyIsoCode 필드 처리
}

// Person Account 활성화 여부
if (OrgShape.isPersonAccountEnabled()) {
    // IsPersonAccount 필드 처리
}

// 현재 API 버전
Decimal apiVersion = OrgShape.getApiVersion();
```

---

## 내부 구현

```apex
// isSandbox — Organization SObject 쿼리
public static Boolean isSandbox() {
    return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
}

// 멀티 커런시 — Schema describe
public static Boolean isMultiCurrencyEnabled() {
    return UserInfo.isMultiCurrencyOrganization();
}

// Person Account — SObjectType describe
public static Boolean isPersonAccountEnabled() {
    return Schema.SObjectType.Account.fields.getMap()
        .containsKey('isPersonAccount');
}
```

---

## 활용 패턴

```apex
// 환경별 로그 레벨 조정
public void process() {
    if (OrgShape.isSandbox()) {
        Log.get().add('Sandbox 환경 — 상세 로깅 활성화', LogSeverity.DEBUG);
    }
    // 실제 로직...
}

// 멀티 커런시 조건 처리
public List<String> getFieldsToQuery() {
    List<String> fields = new List<String>{ 'Id', 'Name', 'Amount' };
    if (OrgShape.isMultiCurrencyEnabled()) {
        fields.add('CurrencyIsoCode');
    }
    return fields;
}
```

---

## 테스트에서의 주의

> [!warning] Organization SObject 조회
> `OrgShape.isSandbox()`는 `Organization` 레코드를 쿼리. `@isTest`에서는 실제 조직 정보가 반환되므로 테스트 환경에서의 결과는 조직 유형에 따라 다름.

---

## 주의사항 및 성능 고려사항

- **SOQL 비용** — `isSandbox()`는 매 호출마다 `Organization` SObject를 SOQL로 쿼리한다. 루프나 반복 호출이 예상되는 경우 결과를 변수에 캐싱해서 재사용해야 한다. `isMultiCurrencyEnabled()`는 `UserInfo` 시스템 메서드를 사용하므로 SOQL을 소비하지 않는다.
- **Static 메서드이므로 Mocking 불가** — 단위 테스트에서 `OrgShape.isSandbox()`의 반환값을 제어하기 어렵다. 테스트 환경이 Sandbox가 아니면 항상 `false`를 반환하므로 Sandbox 전용 분기를 테스트할 때 별도 고려가 필요하다.
- **Schema describe 비용** — `isPersonAccountEnabled()`는 `Schema.SObjectType.Account.fields.getMap()`을 호출해 필드 describe를 실행한다. Apex governor limit에서 Schema describe 호출은 별도 제한이 없지만, 대형 객체에서는 처리 시간이 걸릴 수 있다.

---

## Url.getOrgDomainUrl() — Org 도메인 URL 획득

Apex에서 현재 Org의 기본 URL을 가져올 때 사용. 이메일 링크, Flow 링크 생성에 활용.

```apex
// 현재 Org 도메인 URL (예: https://mycompany.my.salesforce.com)
String baseUrl = Url.getOrgDomainUrl().toExternalForm();

// 활용 예: Flow 시작 링크 생성
String flowLink = baseUrl + '/flow/' + flowApiName;

// PageReference로 파라미터 URL 인코딩
System.PageReference pageRef = new System.PageReference(flowLink);
pageRef.getParameters().put('recordId', recordId);
String fullUrl = pageRef.getUrl();
```

> [!tip] Url.getSalesforceBaseUrl() vs Url.getOrgDomainUrl()
> - `getSalesforceBaseUrl()` — 현재 요청의 base URL (비동기/배치에서 null 가능)
> - `getOrgDomainUrl()` — Org 설정의 도메인 (비동기 컨텍스트에서도 안전)

---

## 관련 노트

- [[QuiddityGuard]]
- [[Log 싱글턴 패턴]]

