---
tags: [apex, security, txnsecurity, transaction-security, policy-condition, event-condition, real-time-event-monitoring, shield]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.4445~4453)
created: 2026-05-19
aliases: [TxnSecurity, TxnSecurity.EventCondition, TxnSecurity.AsyncCondition, TxnSecurity.PolicyCondition, TxnSecurity.Event, Transaction Security Apex, 트랜잭션 보안 정책, EventCondition, 실시간 이벤트 모니터링 보안]
---

# TxnSecurity Namespace

> Transaction Security Policy를 Apex로 커스터마이징하는 API — UI 조건으로 표현할 수 없는 복잡한 보안 로직을 코드로 구현한다.

---

## 개념

Transaction Security는 Salesforce에서 발생하는 이벤트(로그인, API 쿼리, 데이터 내보내기 등)를 실시간으로 감시하고, 조건에 맞으면 **Block(차단)**, **Notify(알림)**, **Multi-Factor Authentication 요구** 등의 액션을 취하는 보안 기능이다.

Setup > Transaction Security Policies에서 정책을 만들 때, 조건 로직을 Apex 클래스로 지정할 수 있다. 이 Apex 클래스가 `TxnSecurity` 네임스페이스의 인터페이스를 구현한다.

### 인터페이스 2원 체계 (현행 vs 레거시)

| 인터페이스 | 대상 | 상태 |
|---|---|---|
| `TxnSecurity.EventCondition` | Real-Time Event Monitoring 기반 정책 | **현행 — 사용 권장** |
| `TxnSecurity.AsyncCondition` | 비동기 Apex 호출이 필요한 경우, EventCondition과 함께 구현 | **현행** |
| `TxnSecurity.PolicyCondition` | 레거시 Transaction Security | **Summer '20 Retired — 사용 금지** |
| `TxnSecurity.Event` 클래스 | PolicyCondition 전용 이벤트 컨테이너 | **Summer '20 Retired** |

---

## 언제 쓰나

- UI 조건 빌더(Condition Builder)로 표현할 수 없는 복합 조건이 필요할 때
- 외부 데이터(커스텀 오브젝트, 화이트리스트 등)와 대조해 차단 여부를 결정할 때
- 특정 이벤트 타입(`ApiEvent`, `LoginEvent`, `ListViewEvent` 등)에서 필드 값을 세밀하게 체크할 때
- 이벤트 발생 시 비동기 처리(외부 callout 등)가 필요할 때 — `AsyncCondition` 병행 구현

---

## TxnSecurity.EventCondition 인터페이스

Real-Time Event Monitoring 기반 Transaction Security Policy에 사용한다.

### evaluate(event)

```apex
public Boolean evaluate(SObject event)
```

| 항목 | 내용 |
|---|---|
| 파라미터 | `event` — Type: SObject (예: ApiEvent, LoginEvent, ListViewEvent 등) |
| 반환값 | `true` — 정책이 트리거됨 (액션 실행). `false` — 조건 불충족, 무시 |
| 호출 시점 | Real-Time Event 발생 시 Salesforce가 자동 호출 |

**evaluate()에서 return true 시 Salesforce가 액션을 수행한다.** evaluate() 메서드 자체가 Block/Notify 액션을 실행하는 것이 아니라, 정책에 설정된 액션을 Salesforce 플랫폼이 수행한다.

### 구현 예제 — API 쿼리에서 Account 조회 감지

PDF p.4451에서 발췌한 예제. `ApiEvent`에서 `QueriedEntities`에 'Account'가 포함되면 정책을 트리거한다.

```apex
public class AccountQueryCondition implements TxnSecurity.EventCondition {
    public boolean evaluate(SObject event) {
        switch on event {
            when ApiEvent apiEvent {
                return handleApiEvent(apiEvent);
            }
            when null {
                // 이벤트가 null이면 정책 트리거
                return true;
            }
            when else {
                // 처리되지 않은 이벤트 타입은 트리거
                return true;
            }
        }
    }

    private boolean handleApiEvent(ApiEvent apiEvent) {
        if (apiEvent.QueriedEntities.contains('Account')) {
            return true;
        }
        return false;
    }
}
```

---

## TxnSecurity.AsyncCondition 인터페이스

EventCondition 구현 클래스 내에서 **비동기 Apex 호출**이 필요한 경우, 같은 클래스에 이 인터페이스를 함께 구현한다.

Transaction Security Apex 정책에서는 **DML과 Apex callout이 허용되지 않는다.** 외부 시스템 호출이나 레코드 저장이 필요한 경우 비동기 Apex(Queueable 등)를 사용해야 하며, 이를 위해 `AsyncCondition`을 선언한다.

- 이 인터페이스는 **메서드가 없다.** Salesforce에게 "이 클래스는 비동기 Apex를 사용한다"고 선언하는 마커 역할.
- EventCondition과 AsyncCondition을 함께 구현한 클래스에서 `System.enqueueJob()`을 호출할 수 있다.

### 구현 예제 — 외부 검증 시스템과 연동하는 로그인 정책

PDF p.4452에서 발췌한 예제. 로그인 이벤트 발생 시 외부 검증 시스템에 비동기로 알리는 패턴.

```apex
// EventCondition + AsyncCondition 동시 구현
global class ExternallyValidatedLoginCondition
    implements TxnSecurity.EventCondition, TxnSecurity.AsyncCondition {

    public boolean evaluate(SObject event) {
        LoginEvent loginEvent = (LoginEvent) event;
        // 커스텀 오브젝트에서 차단 여부 확인
        Boolean userBlocked = [
            select blocked from ExternalValidation__c
            where loginId = :loginEvent.UserId
        ][0].Blocked;

        // 외부 검증 시스템에 비동기로 알림 (callout은 직접 금지 → Queueable 사용)
        System.enqueueJob(new CalloutToExternalValidator(
            loginEvent.SourceIp,
            loginEvent.LoginUrl
        ));

        return userBlocked;
    }
}

// Queueable로 외부 callout 처리
public class CalloutToExternalValidator implements Queueable {
    private String sourceIp;
    private String loginUrl;

    public CalloutToExternalValidator(String sourceIp, String loginUrl) {
        this.sourceIp = sourceIp;
        this.loginUrl = loginUrl;
    }

    public void execute(QueueableContext context) {
        // callout to external validation service
        // pass sourceIp, loginUrl
        // update ExternalValidation__c
    }
}
```

---

## TxnSecurity.Event 클래스 (레거시 — 참고용)

> [!warning] `TxnSecurity.Event` 클래스와 `TxnSecurity.PolicyCondition` 인터페이스는 **Summer '20에 Retired**된 레거시 기능이다. 신규 정책에는 사용하지 않는다. 기존 레거시 정책을 유지보수할 때만 참조한다.

레거시 PolicyCondition의 evaluate()에 전달되는 이벤트 컨테이너 클래스.

### Event 프로퍼티 (주요)

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `action` | String | Entity 이벤트에서 리소스에 수행하는 동작 (예: `create`) |
| `data` | Map\<String, String\> | 이벤트 데이터 (예: 로그인 이벤트의 `SourceIp`, `LoginHistoryId`) |
| `entityId` | String | 이벤트와 연관된 엔티티 ID |
| `entityName` | String | 이벤트가 작동하는 오브젝트 이름 |
| `organizationId` | String | 이벤트가 발생한 org ID |
| `resourceType` | String | 이벤트의 리소스 타입 (예: Connected Application) |
| `timeStamp` | Datetime | 이벤트 발생 시각 |
| `userId` | String | 이벤트를 유발한 사용자 ID |

### data 맵 Key Name 전체 목록

| Key Name | True Value Type | Events Supported |
|---|---|---|
| ActionName | String (Convert/Delete/Insert/Undelete/Update/Upsert) | Entity |
| ApiType | String (Enum manifested as a String) | DataExport, Login |
| Application | String | AccessResource, DataExport |
| ClientId | String (ID of the client) | DataExport |
| ConnectedAppId | String (ID of the Connected App) | AccessResource, DataExport |
| ExecutionTime | milliseconds | DataExport |
| IsApi | Boolean | DataExport |
| IsScheduled | Boolean | DataExport |
| LoginHistoryId | String | DataExport, Login |
| NumberOfRecords | Integer | DataExport |
| PolicyId | String (ID of the current policy) | All events |
| SessionLevel | String (Enum: STANDARD, HIGH_ASSURANCE) | AccessResource |
| SourceIp | String (IPv4) | AccessResource |
| UserName | String | Entity |

---

## TxnSecurity.PolicyCondition 인터페이스 (레거시 — 참고용)

> [!warning] **Summer '20 Retired.** 신규 구현에 사용 금지. `TxnSecurity.EventCondition`을 사용한다.

레거시 evaluate() 시그니처:

```apex
// 레거시 — 사용 금지
public Boolean evaluate(TxnSecurity.Event event)
```

현행 EventCondition의 파라미터가 `SObject event`인 반면, PolicyCondition은 `TxnSecurity.Event event`를 받는다.

---

## 주의사항

### 1. 정책 등록 필요 — 코드만으로는 동작하지 않는다

Apex 클래스를 구현해도 Setup에서 연결하지 않으면 동작하지 않는다.

```
경로: Setup > Security > Transaction Security Policies
→ New Policy
→ Event Type 선택 (예: ApiEvent)
→ Apex Class 선택 (구현한 EventCondition 클래스)
→ Action 설정 (Block / Notify / MFA)
→ 정책 활성화
```

### 2. DML과 Callout 금지

evaluate() 메서드 내에서 DML과 Apex callout을 직접 실행하면 오류가 발생한다. 비동기 처리가 필요하면 `AsyncCondition`을 함께 구현하고 `System.enqueueJob()`을 사용한다.

### 3. evaluate() 예외 시 동작

evaluate()에서 예외가 발생하면 **정책이 트리거된 것으로 간주**해 설정된 액션이 실행된다. try-catch 없이 예외가 전파되면 의도치 않은 차단이 발생할 수 있으므로, 예외 처리를 명시적으로 구현한다.

### 4. 테스트 방법

테스트 클래스에서 `evaluate()` 메서드를 직접 호출해 로직을 검증한다. SObject 이벤트 타입(예: `ApiEvent`)은 `new ApiEvent(필드 = 값)` 방식으로 생성해 전달한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
@isTest
private class AccountQueryConditionTest {
    @isTest
    static void testApiEventWithAccount() {
        ApiEvent evt = new ApiEvent(QueriedEntities = 'Account,Contact');
        AccountQueryCondition cond = new AccountQueryCondition();
        Boolean result = cond.evaluate(evt);
        System.assert(result, 'Account 쿼리는 정책을 트리거해야 한다');
    }

    @isTest
    static void testApiEventWithoutAccount() {
        ApiEvent evt = new ApiEvent(QueriedEntities = 'Contact');
        AccountQueryCondition cond = new AccountQueryCondition();
        Boolean result = cond.evaluate(evt);
        System.assert(!result, 'Account 없는 쿼리는 트리거하지 않아야 한다');
    }
}
```

---

## 관련 노트

- [[Auth Namespace]] — OAuth, MFA 세션 관리 — SessionManagement.setSessionLevel과 연계 가능
- [[Safely]] — DML 보안 패턴 — 트랜잭션 보안과 FLS 보안의 역할 분리
- [[WITH USER_MODE]] — SOQL 보안 모드 — evaluate() 내 SOQL 작성 시 적용
- [[테스트 전략]] — Apex 테스트 구조 — evaluate() 테스트 패턴 참고
