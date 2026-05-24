---
tags: [apex, messaging, notification, custom-notification, push]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [CustomNotification, 커스텀 알림, 인앱 알림, Messaging.CustomNotification, send 알림]
---

# Messaging.CustomNotification

> Apex 코드에서 Lightning 앱 사용자에게 커스텀 인앱·모바일 알림을 발송하는 클래스.

---

## 기본 사용 패턴

```apex
// 1. 커스텀 알림 타입 조회 (Setup > Notification Builder에서 생성)
CustomNotificationType notifType = [
    SELECT Id
    FROM CustomNotificationType
    WHERE DeveloperName = 'My_Approval_Notification'
    WITH USER_MODE
    LIMIT 1
];

// 2. 알림 생성 및 설정
Messaging.CustomNotification notification = new Messaging.CustomNotification();
notification.setNotificationTypeId(notifType.Id);
notification.setTitle('승인 요청');                  // 최대 250자
notification.setBody('귀하의 승인이 필요합니다.');    // 최대 750자

// 3. 타겟 설정 (targetId 또는 targetPageRef 중 하나 필수)
notification.setTargetId(opportunityId);             // 레코드 ID로 이동
// 또는
notification.setTargetPageRef('/lightning/r/Case/500xx.../view');

// 4. 발송
Set<String> recipientIds = new Set<String>{ userId1, userId2 };
try {
    notification.send(recipientIds);
} catch (Exception e) {
    System.debug('알림 발송 실패: ' + e.getMessage());
}
```

---

## 파라미터 생성자 사용

```apex
// 한 번에 모든 속성 설정
Messaging.CustomNotification notification = new Messaging.CustomNotification(
    notifType.Id,          // typeId
    senderId,              // sender User ID (선택)
    '제목',                // title
    '알림 본문',            // body
    targetRecordId,        // targetId (또는 null)
    null                   // targetPageRef (또는 null)
);
notification.send(new Set<String>{ recipientId });
```

---

## ActionGroup 포함 (Actionable Notification)

```apex
// 알림에 액션 버튼 추가 — ActionGroup ID 필요
Messaging.CustomNotification notification = new Messaging.CustomNotification();
notification.setNotificationTypeId(notifType.Id);
notification.setTitle('승인 대기');
notification.setBody('빠른 승인을 위해 탭하세요.');
notification.setTargetId(recordId);
notification.setActionGroupId(actionGroupId);    // Actions > Action Groups에서 생성

notification.send(new Set<String>{ userId });
```

---

## 서비스 레이어 패턴 (재사용 가능한 구조)

```apex
public without sharing class NotificationService {
    public static void notifyUsers(
        String notifTypeDeveloperName,
        String title,
        String body,
        Id targetId,
        Set<String> recipientIds
    ) {
        CustomNotificationType notifType = [
            SELECT Id
            FROM CustomNotificationType
            WHERE DeveloperName = :notifTypeDeveloperName
            WITH USER_MODE
            LIMIT 1
        ];

        Messaging.CustomNotification n = new Messaging.CustomNotification();
        n.setNotificationTypeId(notifType.Id);
        n.setTitle(title);
        n.setBody(body);
        if (targetId != null) {
            n.setTargetId(String.valueOf(targetId));
        } else {
            n.setTargetId('000000000000000AAA');  // 타겟 없을 때 더미값
        }

        try {
            n.send(recipientIds);
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Notification failed: ' + e.getMessage());
        }
    }
}
```

---

## 주요 메서드 요약

| 메서드 | 설명 | 필수 |
|---|---|---|
| `setNotificationTypeId(Id)` | 알림 타입 ID (Setup에서 생성) | 필수 |
| `setTitle(String)` | 알림 제목 (최대 250자) | 필수 |
| `setBody(String)` | 알림 본문 (최대 750자) | 필수 |
| `setTargetId(String)` | 클릭 시 이동할 레코드 ID | targetId/pageRef 중 하나 |
| `setTargetPageRef(String)` | 클릭 시 이동할 페이지 URL (`/lightning/r/...`) | targetId/pageRef 중 하나 |
| `setSenderId(String)` | 발신자 User ID (선택) | - |
| `setActionGroupId(String)` | 액션 그룹 ID (Actionable 알림용) | - |
| `send(Set<String>)` | 지정 User ID 목록에 알림 발송 | 필수 |

---

## 비교표 — CustomNotification vs SingleEmailMessage

| 항목 | CustomNotification | SingleEmailMessage |
|---|---|---|
| 채널 | Lightning/모바일 인앱 | 이메일 |
| 즉시성 | 실시간 Push | 이메일 서버 경유 |
| 타겟 | Salesforce 사용자 (User ID) | 이메일 주소 / Contact/Lead |
| 첨부 | 없음 | 가능 |
| 사용 권한 | `Send Custom Notifications` | 없음 |
| 한도 | 일일 알림 한도 | 일일 이메일 한도 |

---

## 주의사항

- `setTargetId` 또는 `setTargetPageRef` 중 하나는 **반드시** 설정해야 합니다. 둘 다 없으면 `send()` 에서 예외 발생.
- 타겟이 없는 경우 더미 ID `000000000000000AAA` 사용.
- 발신자는 **`Send Custom Notifications` 권한**이 있어야 합니다.

---

## 관련 노트

- [[SingleEmailMessage]] — 이메일 발송 대안
- [[Platform Event 발행]] — 비동기 이벤트 기반 알림
- [[서비스 레이어 패턴]] — 알림 로직 캡슐화
- [[Messaging Namespace]] — CustomNotification이 속한 상위 네임스페이스 (이메일·SMS·푸시 통합 카탈로그)
