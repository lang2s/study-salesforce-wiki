---
tags: [apex, platform-events, publish-callback, eventbus, async-publish, resume-checkpoint]
source: platform_events (Salesforce Platform Events Developer Guide) + salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [EventPublishFailureCallback, EventPublishSuccessCallback, publish callback, 발행 콜백, setResumeCheckpoint, 이벤트 발행 결과 추적]
---

# EventBus Publish Callbacks

> `EventBus.publish(events, callback)` 의 **최종 비동기 결과**(성공/실패)를 Apex 콜백으로 수신. `Database.SaveResult`가 반환하는 큐잉 결과와 다른 최종 커밋 결과.

---

## 콜백 클래스 구현

```apex
// 실패 콜백만 구현
public class MyFailureCallback implements EventBus.EventPublishFailureCallback {
    public void onFailure(EventBus.FailureResult result) {
        List<String> failedUuids = result.getEventUuids();
        System.debug(failedUuids.size() + ' 개 이벤트 발행 실패: ' + failedUuids);

        // 실패 이벤트 재처리, 로깅, 태스크 생성 등
        Task t = new Task(
            Subject      = '이벤트 발행 실패 후속 처리',
            Description  = String.join(failedUuids, ', '),
            ActivityDate = Date.today().addDays(1)
        );
        insert t;
        // 콜백은 Automated Process 사용자 컨텍스트로 실행됨
        // OwnerId를 명시적으로 지정하지 않으면 Automated Process에 할당됨
    }
}

// 성공·실패 모두 구현 (한 클래스에서)
public class MyFullCallback
        implements EventBus.EventPublishFailureCallback,
                   EventBus.EventPublishSuccessCallback {
    public void onFailure(EventBus.FailureResult result) {
        List<String> failedUuids = result.getEventUuids();
        // 실패 처리
    }
    public void onSuccess(EventBus.SuccessResult result) {
        List<String> successUuids = result.getEventUuids();
        // 성공 확인 로깅 (대량 이벤트 성공 처리는 거버너 주의)
    }
}
```

---

## 콜백 인스턴스를 포함한 발행

```apex
// 이벤트 생성 — EventUuid 자동 생성을 원하면 newSObject(null, true) 사용
List<Order_Event__e> events = new List<Order_Event__e>();
for (Integer i = 0; i < 10; i++) {
    // EventUuid 포함 생성 — 콜백에서 이벤트 특정 가능
    Order_Event__e e = (Order_Event__e) Order_Event__e.sObjectType.newSObject(null, true);
    events.add(e);
}

// 콜백 인스턴스를 두 번째 파라미터로 전달
MyFailureCallback cb = new MyFailureCallback();
List<Database.SaveResult> results = EventBus.publish(events, cb);

// results: 큐잉 중간 결과 (StatusCode: OPERATION_WITH_CALLBACK_ENQUEUED)
// 최종 성공/실패 결과 → onSuccess / onFailure 콜백으로 수신
for (Database.SaveResult sr : results) {
    System.debug('큐 등록 성공: ' + sr.isSuccess());
    // sr.getErrors()[0].getStatusCode() == 'OPERATION_WITH_CALLBACK_ENQUEUED'
    // sr.getErrors()[0].getMessage() == event UUID
}
```

---

## setResumeCheckpoint — 부분 처리 재개

```apex
// 이벤트 트리거가 일부 처리 후 중단되면, 재실행 시 체크포인트 이후부터 재개
trigger ResumeEventTrigger on Low_Ink__e (after insert) {
    Integer counter = 0;

    for (Low_Ink__e event : Trigger.New) {
        counter++;

        // 200개 단위로 배치 크기 제어
        if (counter > 200) {
            // 마지막으로 성공 처리한 이벤트의 replayId 설정
            // 이후 트리거 재실행은 해당 replayId 다음 이벤트부터 시작
            break;
        }

        // 이벤트 처리 로직
        // ...

        // 처리 완료 후 체크포인트 갱신
        EventBus.TriggerContext.currentContext().setResumeCheckpoint(event.ReplayId);
    }
}
```

---

## setResumeCheckpoint vs RetryableException 비교

| | `setResumeCheckpoint()` | `RetryableException` |
|---|---|---|
| 실행 흐름 | 이후에도 계속 실행 | 즉시 중단 후 재시도 |
| 재개 위치 | 설정한 replayId 다음 이벤트 | 현재 배치 전체 재처리 |
| 사용 목적 | 한도 도달·배치 크기 제어 | 일시적 오류 재시도 |
| 재시도 횟수 | 제한 없음 (배치 분할) | 기본 9회 |

---

## 테스트

```apex
@IsTest
static void testPublishCallback() {
    // 콜백 테스트 — fail() 로 실패 시뮬레이션
    List<Order_Event__e> events = new List<Order_Event__e>{
        (Order_Event__e) Order_Event__e.sObjectType.newSObject(null, true)
    };

    Test.startTest();
    EventBus.publish(events, new MyFailureCallback());
    Test.getEventBus().fail();   // 발행 실패 시뮬레이션 → onFailure 호출
    Test.stopTest();

    // onFailure에서 생성한 Task 검증
    List<Task> tasks = [SELECT Subject FROM Task LIMIT 1];
    System.assertEquals(1, tasks.size());
}

@IsTest
static void testTriggerDelivery() {
    // 트리거 수신 테스트 — deliver()로 전달 시뮬레이션
    Test.startTest();
    EventBus.publish(new List<Low_Ink__e>{ new Low_Ink__e() });
    Test.getEventBus().deliver();  // 트리거 즉시 실행
    Test.stopTest();
}
```

---

## 주의사항

- 콜백은 **Automated Process** 사용자로 실행 → `OwnerId` 등 명시 필요
- 고볼륨 Platform Event만 지원 (레거시 StandardVolume 불가)
- 콜백 인스턴스 크기를 작게 유지 (UUID 맵 최소화)
- 단건 발행 루프보다 **배치 발행 1회** 권장 (거버너 절약)

---

## 관련 노트

- [[Platform Event 발행]] — EventBus.publish 기본 패턴, 트랜잭션 경계
- [[ChangeEventHeader]] — CDC 이벤트 헤더, TriggerContext.retries, RetryableException
