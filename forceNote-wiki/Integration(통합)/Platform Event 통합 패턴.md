---
tags: [integration, platform-event, event-bus, lwc, apex, pattern]
source: apex-recipes/PlatformEventRecipes.cls, lwc-recipes/lmsSubscriber
created: 2026-05-17
aliases: [Platform Event 통합, EventBus, 이벤트 기반 통합]
---

# Platform Event 통합 패턴

> 시스템 간 느슨한 결합(Loose Coupling)을 위한 이벤트 기반 통합.
> Apex·Flow·외부 시스템이 이벤트를 발행하고, Apex Trigger·LWC·외부 시스템이 수신.

---

## 아키텍처 개요

```
발행자 (Publisher)              수신자 (Subscriber)
─────────────────               ───────────────────
Apex (EventBus.publish)  ──┐
Flow (Publish Message)     ├──▶ Apex Trigger (after insert)
외부 시스템 (REST API)    ──┘    LWC (empApi subscribe)
                                외부 시스템 (CometD)
```

---

## Apex 발행 패턴

```apex
// 단건
OrderEvent__e event = new OrderEvent__e(
    OrderId__c = order.Id,
    Status__c  = 'Created',
    Amount__c  = order.TotalAmount
);
Database.SaveResult result = EventBus.publish(event);

// 다건 — bulkify
List<OrderEvent__e> events = new List<OrderEvent__e>();
for (Order o : orders) {
    events.add(new OrderEvent__e(
        OrderId__c = o.Id,
        Status__c  = o.Status
    ));
}
List<Database.SaveResult> results = EventBus.publish(events);

// 결과 확인
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        System.debug('발행 실패: ' + sr.getErrors()[0].getMessage());
    }
}
```

> [!note] 트랜잭션 동작
> `EventBus.publish()`는 메인 트랜잭션 **커밋 이후** 이벤트를 발행.
> 트랜잭션이 롤백되면 이벤트도 발행되지 않음 — 데이터 일관성 자동 보장.

---

## Apex Trigger 수신 패턴

```apex
trigger OrderEventTrigger on OrderEvent__e (after insert) {
    List<Order_Log__c> logs = new List<Order_Log__c>();

    for (OrderEvent__e event : Trigger.new) {
        logs.add(new Order_Log__c(
            Order_Id__c  = event.OrderId__c,
            Status__c    = event.Status__c,
            Event_UUID__c = event.EventUuid  // 중복 방지용 고유 ID (시스템 필드)
        ));
    }

    insert logs;

    // 다음 이벤트 처리 재개 (에러 없이 계속)
    EventBus.TriggerContext.currentContext().setResumeCheckpoint(
        Trigger.new[Trigger.new.size() - 1].ReplayId
    );
}
```

> [!tip] setResumeCheckpoint()
> 트리거 실패 시 재시도 기준 ReplayId를 명시. 생략하면 실패 시 처음부터 재처리.
> 이미 처리한 이벤트를 `EventUuid`로 중복 체크하여 멱등성 확보.

---

## LWC 구독 패턴

```javascript
// orderStatusMonitor.js
import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

const CHANNEL = '/event/OrderEvent__e';

export default class OrderStatusMonitor extends LightningElement {
    subscription = {};

    connectedCallback() {
        onError((error) => console.error('EMP API error:', error));

        // -1: 이 시점부터 새 이벤트만 수신
        // -2: 24시간 이내 보관된 이벤트부터 수신
        subscribe(CHANNEL, -1, (event) => {
            this.handleEvent(event.data.payload);
        }).then((sub) => {
            this.subscription = sub;
        });
    }

    handleEvent(payload) {
        console.log('Order updated:', payload.OrderId__c, payload.Status__c);
        // UI 갱신 로직
    }

    disconnectedCallback() {
        unsubscribe(this.subscription, (response) => {
            console.log('Unsubscribed:', response);
        });
    }
}
```

---

## 외부 시스템 → Salesforce 발행 (REST API)

```bash
# 외부에서 Platform Event 발행 (Salesforce REST API 사용)
POST /services/data/v59.0/sobjects/OrderEvent__e/
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "OrderId__c": "001xxxxxxxxxxxx",
  "Status__c": "Shipped"
}
```

> 외부 시스템이 Salesforce에 직접 Platform Event를 발행할 때 사용.
> `@RestResource` Custom Endpoint 대신 이 방식을 쓰면 수신 로직이 Trigger로 일원화됨.

---

## Platform Event vs 다른 통합 방식

| 기준 | Platform Event | @RestResource | Streaming API PushTopic |
|---|---|---|---|
| 방향 | 양방향 | Inbound | Outbound |
| 동기/비동기 | 비동기 | 동기 | 비동기 |
| 수신 측 | Trigger, LWC, 외부 | 외부 시스템 | LWC, 외부 |
| 커스텀 로직 | Trigger에 집중 | Endpoint에 집중 | 별도 없음 |
| 재처리 | ReplayId로 가능 | ❌ | 제한적 |
| 권장 | 시스템 간 이벤트 | 단순 REST API | 레거시 (deprecated 예정) |

---

## Platform Event 메타데이터 정의

```xml
<!-- force-app/main/default/objects/OrderEvent__e/OrderEvent__e.object-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <eventType>HighVolume</eventType>
    <label>Order Event</label>
    <pluralLabel>Order Events</pluralLabel>
    <fields>
        <fullName>OrderId__c</fullName>
        <label>Order Id</label>
        <type>Text</type>
        <length>18</length>
    </fields>
    <fields>
        <fullName>Status__c</fullName>
        <label>Status</label>
        <type>Text</type>
        <length>50</length>
    </fields>
</CustomObject>
```

| eventType | 설명 |
|---|---|
| `HighVolume` | 대용량, ReplayId 지원, 72시간 보존 |
| `StandardVolume` | 소용량, 레거시 |

---

## 테스트

```apex
@isTest
static void testOrderEventPublish() {
    OrderEvent__e event = new OrderEvent__e(
        OrderId__c = '001xxxxxxxxxxxx',
        Status__c  = 'Created'
    );

    Test.startTest();
    Database.SaveResult result = EventBus.publish(event);
    Test.stopTest(); // ← Trigger 동기 실행

    Assert.isTrue(result.isSuccess());

    // Trigger가 생성한 레코드 확인
    List<Order_Log__c> logs = [SELECT Status__c FROM Order_Log__c];
    Assert.areEqual(1, logs.size());
    Assert.areEqual('Created', logs[0].Status__c);
}
```

---

## 관련 노트

- [[Platform Event 발행]] — EventBus.publish 기본 발행·수신 패턴
- [[Custom REST Endpoint]] — Inbound 동기 통합
- [[Queueable + Callout 패턴]] — 이벤트 처리 후 외부 Callout 연결
- [[Named Credential]] — Outbound 연동
- [[sfdc_surveys Namespace]] — Survey 응답 이벤트를 Platform Event로 발행하는 사례
