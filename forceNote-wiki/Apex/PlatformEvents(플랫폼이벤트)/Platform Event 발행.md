---
tags: [apex, platform-event, publish, trigger, pattern]
source: apex-recipes/PlatformEventRecipes.cls
created: 2026-05-17
aliases: [Platform Event, EventBus.publish, 플랫폼 이벤트]
---

# Platform Event 발행

> `EventBus.publish()`로 이벤트를 발행하고 트리거로 수신. DML + EventBus.publish()는 같은 트랜잭션에서 사용 가능. 수신 트리거는 별도 트랜잭션.

---

## 개념

Apex 트리거나 서비스 레이어에서 다른 시스템·컴포넌트로 알림을 보낼 때 직접 호출하면 두 서비스가 강하게 결합된다. 예를 들어 Order가 생성될 때 재고 시스템과 알림 시스템을 동기적으로 호출하면, 재고 시스템이 느리거나 오류를 낼 때 Order 저장 자체가 실패하거나 지연된다.

Platform Event는 이 결합을 끊기 위한 **Salesforce 내장 발행-구독(Pub/Sub) 메시지 버스**다. 발행자(Publisher)는 이벤트를 버스에 올리기만 하고, 누가 수신하는지 알 필요가 없다. 수신자(Subscriber — Apex 트리거, LWC, 외부 시스템)는 이벤트가 올 때만 독립된 트랜잭션으로 처리한다.

중요한 트랜잭션 보장이 있다. `EventBus.publish()`는 메인 트랜잭션이 커밋될 때 이벤트가 실제로 발행된다. 메인 트랜잭션이 롤백되면 이벤트도 취소되어 부분 상태가 발생하지 않는다. 단, 수신 트리거는 별도 트랜잭션으로 동작하므로 수신 실패가 발행 성공을 취소하지는 않는다.

---

## 발행 패턴

```apex
// 단건 발행
LogEvent__e event = new LogEvent__e(
    Message__c  = 'Processing complete',
    Severity__c = 'INFO'
);
EventBus.publish(event);

// 다건 발행 (List)
List<OrderEvent__e> events = new List<OrderEvent__e>();
for (Order o : orders) {
    events.add(new OrderEvent__e(
        OrderId__c = o.Id,
        Status__c  = o.Status
    ));
}
List<Database.SaveResult> results = EventBus.publish(events);
```

---

## 발행 결과 확인

```apex
List<Database.SaveResult> results = EventBus.publish(events);
for (Integer i = 0; i < results.size(); i++) {
    if (!results[i].isSuccess()) {
        System.debug('발행 실패: ' + results[i].getErrors()[0].getMessage());
    }
}
```

---

## 수신 트리거 패턴

```apex
trigger LogEventTrigger on LogEvent__e (after insert) {
    List<Log_Entry__c> entries = new List<Log_Entry__c>();

    for (LogEvent__e event : Trigger.new) {
        entries.add(new Log_Entry__c(
            Message__c   = event.Message__c,
            Severity__c  = event.Severity__c,
            EventUUID__c = event.EventUuid  // 중복 방지용 고유 ID
        ));
    }

    insert entries;
}
```

---

## 트랜잭션 동작

```apex
// DML + EventBus.publish() — 같은 트랜잭션에서 가능
insert newAccount;                    // DML
EventBus.publish(new OrderEvent__e()); // 같은 트랜잭션

// 메인 트랜잭션 롤백 시: 이벤트도 발행되지 않음 (일관성 보장)
// 수신 트리거: 별도 트랜잭션 (독립 실행)
```

> [!note] 트랜잭션 경계
> `EventBus.publish()`는 메인 트랜잭션이 **커밋된 후** 이벤트를 발행. 롤백 시 이벤트도 취소됨. 수신 트리거의 DML 실패는 이벤트 발행 자체를 영향 안 줌.

---

## Platform Event vs Streaming API vs CDC

| | Platform Event | Streaming API | Change Data Capture |
|---|---|---|---|
| 소스 | 커스텀 이벤트 | SOQL 기반 PushTopic | SObject 변경 |
| 수신 | Apex Trigger, LWC | LWC, External | LWC, External |
| DML 연동 | ✅ | ❌ | 자동 |
| 재사용 | ✅ | ❌ (deprecated) | ❌ |

---

## Platform Event 정의 (SFDX 메타데이터)

```xml
<!-- LogEvent__e.object-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <eventType>HighVolume</eventType>  <!-- HighVolume 또는 StandardVolume -->
    <label>Log Event</label>
    <pluralLabel>Log Events</pluralLabel>
    <fields>
        <fullName>Message__c</fullName>
        <type>Text</type>
        <length>255</length>
    </fields>
</CustomObject>
```

---

## 고급: ReplayId로 이벤트 재처리

```apex
// 수신 트리거에서 마지막 ReplayId 저장
String lastReplayId = Trigger.new[Trigger.new.size() - 1].ReplayId;
// LWC Subscribe에서 -1: 새 이벤트만, -2: 24시간 이내 전체
```

---

## 제한사항 및 주의사항

- **HighVolume vs StandardVolume** — `eventType`에 따라 보존 기간과 구독 방식이 다르다. HighVolume(기본 권장)은 72시간 이벤트 보존, ReplayId 지원. StandardVolume은 24시간 보존이며 권한 설정이 다르다. 새 이벤트는 HighVolume으로 정의하는 것이 표준이다.
- **발행 한도 (Governor Limit)** — 트랜잭션당 `EventBus.publish()` 호출로 발행할 수 있는 이벤트 수는 플랜에 따라 다르다. 단건/리스트 호출 모두 합산된다. 대량 이벤트는 리스트로 묶어 한 번에 발행하는 것이 권장된다.
- **`Database.SaveResult` 확인 필수** — `EventBus.publish()`는 예외를 던지지 않고 `Database.SaveResult`를 반환한다. 결과를 확인하지 않으면 발행 실패를 조용히 놓친다.
- **수신 트리거의 재시도 없음** — 수신 트리거에서 예외가 발생하면 해당 트리거 실행만 실패한다. 이벤트가 재발행되거나 재처리되지는 않으므로 수신 측에서 견고한 에러 처리가 필요하다.
- **LWC Subscribe는 Lightning 페이지에서만** — LWC에서 Platform Event를 구독하는 `lightning/empApi`는 브라우저 세션이 활성화된 동안만 동작한다. 페이지 이동 시 구독이 끊길 수 있다.

## 관련 노트

- [[Platform Event 통합 패턴]] — 이벤트 기반 시스템 통합 패턴
- [[Log 싱글턴 패턴]] — EventBus.publish 활용
- [[Queueable]] — 이벤트 처리 후 비동기 체이닝
- [[Custom REST Endpoint]]
- [[3 Associated Objects]] — ChangeEvent(CDC) 패턴 비교 — Platform Event와 다른 CDC 구독 방식

