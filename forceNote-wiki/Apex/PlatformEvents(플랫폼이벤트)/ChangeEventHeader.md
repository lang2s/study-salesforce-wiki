---
tags: [apex, platform-events, cdc, change-data-capture, change-event-header, eventbus]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [ChangeEventHeader, CDC, Change Data Capture, 변경 데이터 캡처, changetype, recordids]
---

# EventBus.ChangeEventHeader

> Change Data Capture(CDC) 이벤트의 헤더 필드를 담는 클래스. CDC 트리거에서 변경된 레코드·필드 정보 파악에 사용.

---

## CDC 트리거 기본 구조

```apex
trigger AccountCDCTrigger on AccountChangeEvent (after insert) {
    List<AccountChangeEvent> events = Trigger.new;

    for (AccountChangeEvent event : events) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;

        String changeType  = header.changetype;       // CREATE/UPDATE/DELETE/UNDELETE
        List<String> recordIds = header.recordids;    // 변경된 레코드 ID 목록
        String entityName  = header.entityname;       // 오브젝트 API 이름
        String commitUser  = header.commituser;       // 변경 실행 User ID
        Long   commitTs    = header.committimestamp;  // 에포크 밀리초

        // UPDATE일 때만 의미 있음
        List<String> changedFields = header.changedfields;
        List<String> nulledFields  = header.nulledfields;

        System.debug('변경 타입: ' + changeType);
        System.debug('레코드 ID: ' + recordIds);
        System.debug('변경 필드: ' + changedFields);
    }
}
```

---

## changeType 값 처리

```apex
String ct = event.ChangeEventHeader.changetype;

if (ct == 'CREATE') {
    // 새 레코드 생성됨
} else if (ct == 'UPDATE') {
    // 기존 레코드 수정됨
    List<String> changed = event.ChangeEventHeader.changedfields;
    if (changed.contains('Status__c')) {
        // 특정 필드 변경 시 처리
    }
} else if (ct == 'DELETE') {
    // 레코드 삭제됨
} else if (ct == 'UNDELETE') {
    // 휴지통에서 복원됨
}
// GAP_CREATE / GAP_UPDATE / GAP_DELETE / GAP_UNDELETE — 갭 이벤트
// GAP_OVERFLOW — 오버플로우 이벤트
```

---

## 다중 레코드 이벤트 처리

```apex
// 동일 트랜잭션 내 동일 변경이 여러 레코드에 발생하면 하나의 이벤트로 병합됨
List<String> allRecordIds = event.ChangeEventHeader.recordids;
// 예: 피클리스트 값 일괄 업데이트 시 recordIds에 와일드카드 '001*' 포함 가능

for (String rId : allRecordIds) {
    if (rId.endsWith('*')) {
        // 와일드카드 — 정확한 ID 조회 불가
    } else {
        // 정상 레코드 ID 처리
    }
}
```

---

## TriggerContext — 재시도 정보

```apex
// EventBus.TriggerContext: 현재 트리거 실행 컨텍스트 정보
trigger MyPlatformEventTrigger on My_Event__e (after insert) {
    EventBus.TriggerContext ctx = EventBus.TriggerContext.currentContext();
    Integer retryCount = ctx.retries;   // 현재 재시도 횟수

    if (retryCount >= 3) {
        // 최대 재시도 초과 — 에러 로깅 후 포기
        return;
    }

    try {
        // 이벤트 처리 로직
    } catch (Exception e) {
        // 재시도 트리거 (다음 재시도 스케줄)
        throw new EventBus.RetryableException('재처리 필요: ' + e.getMessage());
    }
}
```

---

## 테스트 — TestBroker

```apex
@IsTest
static void testCDCTrigger() {
    // CDC 이벤트 시뮬레이션
    AccountChangeEvent changeEvent = new AccountChangeEvent();
    EventBus.ChangeEventHeader header = new EventBus.ChangeEventHeader();
    header.changetype = 'UPDATE';
    header.recordids  = new List<String>{ '001xx000000001AAAQ' };
    header.changedfields = new List<String>{ 'Name', 'Phone' };
    changeEvent.ChangeEventHeader = header;

    // TestBroker로 이벤트 전달 시뮬레이션
    Test.startTest();
    EventBus.TestBroker.deliver(new List<AccountChangeEvent>{ changeEvent });
    Test.stopTest();
}
```

---

## ChangeEventHeader 프로퍼티 목록

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `changetype` | `String` | `CREATE`/`UPDATE`/`DELETE`/`UNDELETE` (또는 `GAP_*`) |
| `recordids` | `List<String>` | 변경된 레코드 ID 목록 |
| `entityname` | `String` | 오브젝트 API 이름 (예: `Account`) |
| `changedfields` | `List<String>` | UPDATE 시 변경된 필드명 목록 |
| `nulledfields` | `List<String>` | null로 변경된 필드명 목록 |
| `difffields` | `List<String>` | 대용량 텍스트 diff로 전송된 필드 |
| `commituser` | `String` | 변경 실행 User ID |
| `committimestamp` | `Long` | 에포크 밀리초 |
| `commitnumber` | `Long` | 시스템 변경 번호 (SCN) |
| `transactionkey` | `String` | 트랜잭션 고유 키 |
| `sequencenumber` | `Integer` | 트랜잭션 내 변경 순서 (1부터) |
| `changeorigin` | `String` | 변경을 일으킨 API/클라이언트 정보 |

---

## Platform Event vs CDC 비교

| 항목 | Platform Event | Change Data Capture |
|---|---|---|
| 이벤트 소스 | 직접 발행 (`EventBus.publish`) | Salesforce 자동 생성 |
| 이벤트 타입 | 커스텀 (`My_Event__e`) | `{Object}ChangeEvent` |
| 트리거 대상 | 직접 발행 시 | 레코드 CUD 시 |
| 헤더 | 없음 | `ChangeEventHeader` 포함 |
| 재시도 | 수동 처리 | `RetryableException` 지원 |

---

## 관련 노트

- [[Platform Event 발행]] — Platform Event 발행·수신 기본 패턴
- [[Batch Apex]] — CDC 이벤트를 Batch에서 처리하는 패턴
- [[Queueable]] — CDC 트리거에서 비동기 처리 위임
- [[EventBus Namespace]] — EventBus.publish 메서드 서명, TriggerContext, RetryableException 상세
- [[3 Associated Objects]] — ChangeEvent Object 패턴 상세 (changeType·changedFields·transactionKey)
- [[ChangeEvent Objects]] — CDC 지원 오브젝트 목록 전수·JSON 이벤트 메시지 예제·ChangeEventHeader 필드 상세
