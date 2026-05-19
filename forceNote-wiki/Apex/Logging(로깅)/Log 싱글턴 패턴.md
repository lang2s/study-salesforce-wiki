---
tags: [apex, logging, singleton, platform-event, pattern]
source: apex-recipes/Log.cls, LogMessage.cls
created: 2026-05-17
aliases: [Log, 로그 싱글턴, Platform Event 로깅]
---

# Log 싱글턴 패턴

> `Log`는 동일 트랜잭션 내 여러 곳에서 로그를 누적하고 마지막에 한 번의 `EventBus.publish()`로 발행하는 싱글턴 패턴. DML 한도를 절약하면서 Platform Event 기반 비동기 로깅을 구현.

---

## 핵심 구조

```apex
public class Log {

    // 싱글턴 인스턴스 보관
    private static Log currentInstance;

    // 발행 대기 중인 로그 이벤트 목록
    private List<LogEvent__e> buffer = new List<LogEvent__e>();

    // 싱글턴 접근
    public static Log get() {
        if (currentInstance == null) {
            currentInstance = new Log();
        }
        return currentInstance;
    }

    // 로그 추가 (버퍼에만 쌓음)
    public Log add(String message, LogSeverity severity) {
        buffer.add(new LogEvent__e(
            Message__c   = message,
            Severity__c  = severity.name(),
            Context__c   = Request.getCurrent().getQuiddity().name()
        ));
        return this; // Fluent
    }

    // 한 번에 발행
    public void publish() {
        EventBus.publish(buffer);
        buffer.clear();
    }
}
```

---

## 사용 패턴

```apex
// 여러 곳에서 로그 누적
Log.get().add('Processing started', LogSeverity.INFO);

try {
    doSomeWork();
    Log.get().add('Work complete', LogSeverity.DEBUG);
} catch (Exception e) {
    Log.get().add('Error: ' + e.getMessage(), LogSeverity.ERROR);
} finally {
    Log.get().publish(); // 단 1번의 EventBus.publish()
}

// Fluent 체이닝
Log.get()
    .add('Step 1', LogSeverity.INFO)
    .add('Step 2', LogSeverity.INFO)
    .publish();
```

---

## LogSeverity 열거형

```apex
public enum LogSeverity {
    DEBUG,
    INFO,
    WARNING,
    ERROR
}
```

---

## Platform Event 수신 트리거

```apex
// LogEvent__e 수신 → Log_Entry__c 레코드 저장
trigger LogEventTrigger on LogEvent__e (after insert) {
    List<Log_Entry__c> entries = new List<Log_Entry__c>();
    for (LogEvent__e event : Trigger.new) {
        entries.add(new Log_Entry__c(
            Message__c  = event.Message__c,
            Severity__c = event.Severity__c,
            Context__c  = event.Context__c
        ));
    }
    insert entries;
}
```

> [!note] 왜 Platform Event인가?
> DML + EventBus.publish()는 같은 트랜잭션에서 허용됨. Platform Event 수신 트리거는 **별도 트랜잭션**으로 실행되므로 메인 트랜잭션 실패와 무관하게 로그가 저장됨.

---

## 싱글턴의 트랜잭션 범위

> [!warning] 싱글턴 재사용
> `Log.currentInstance`는 트랜잭션 전체에서 공유됨. 테스트에서 여러 케이스가 같은 인스턴스를 재사용하면 버퍼가 누적될 수 있음. 테스트 격리를 위해 `Log.clearInstance()` 메서드 제공 여부 확인.

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| 트리거·서비스·배치가 하나의 트랜잭션에서 공통 로그 버퍼를 공유해야 할 때 | 싱글턴 Log 패턴 |
| Platform Event로 로그를 비동기 전송하되 DML을 한 번만 발행하고 싶을 때 | `commitLogs()` + `EventBus.publish()` 조합 |
| Debug 로그(System.debug)만으로는 프로덕션 이슈 추적이 어려울 때 | Log 싱글턴으로 커스텀 오브젝트/Platform Event에 영속화 |
| 여러 클래스에서 각자 Platform Event를 발행해 한도를 소모하는 문제를 막을 때 | 싱글턴 버퍼 패턴으로 단일 발행 포인트 확보 |

Platform Event 발행 한도(트랜잭션당 150 DML 행, 동시 5개)를 절약하고 로그를 중앙화할 때 가장 효과적이다.

---

## 관련 노트

- [[Platform Event 발행]]
- [[QuiddityGuard]] — Context__c 값 출처
- [[OrgShape]]

