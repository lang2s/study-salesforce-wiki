---
tags: [apex, messaging, namespace, inbound-email, email-service, notification, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — Messaging Namespace (p.3024~3065)
created: 2026-05-18
aliases: [Messaging Namespace, InboundEmail, InboundEmailHandler, InboundEmailResult, InboundEnvelope, EmailService, ActionableNotification, 인바운드 이메일, 이메일 서비스]
---

# Messaging Namespace

> Salesforce 알림·이메일 기능 전체 클래스 모음. SingleEmailMessage/CustomNotification 외에 인바운드 이메일 처리 포함.

---

## 클래스 목록

| 클래스/인터페이스/Enum | 설명 |
|---|---|
| `SingleEmailMessage` | 단일 이메일 발송 | 
| `MassEmailMessage` | 대량 이메일 발송 |
| `Email` | SingleEmail/MassEmail 공통 기본 메서드 |
| `EmailFileAttachment` | 이메일 첨부 파일 |
| `CustomNotification` | 커스텀 인앱 알림 발송 |
| `ActionableNotification` | 모바일 실행 가능 알림 |
| `ActionableNotification.Builder` | ActionableNotification 빌더 |
| `ActionError` Enum | 알림 실행 오류 코드 |
| `ActionResult` | 알림 실행 결과 |
| `ActionResult.Builder` | ActionResult 빌더 |
| `NotificationActionHandler` Interface | 커스텀 알림 액션 실행 인터페이스 |
| **`InboundEmail`** | 인바운드 이메일 객체 |
| `InboundEmail.BinaryAttachment` | 바이너리 첨부 파일 |
| `InboundEmail.TextAttachment` | 텍스트 첨부 파일 |
| `InboundEmail.AuthenticationResult` | 인증 결과 |
| `InboundEmail.AuthenticationResultField` | 인증 결과 필드 |
| `InboundEmail.Header` | RFC 2822 헤더 |
| **`InboundEmailResult`** | 이메일 서비스 처리 결과 반환 |
| **`InboundEnvelope`** | 인바운드 이메일 봉투 정보 |
| `PushNotification` | 푸시 알림 (Apex 트리거에서 발송) |
| `PushNotificationPayload` | Apple 기기용 알림 페이로드 |
| `RenderEmailTemplateBodyResult` | 이메일 템플릿 렌더링 결과 |
| `SendEmailResult` | 이메일 발송 결과 |
| `SendEmailError` | 이메일 발송 오류 |
| `AttachmentRetrievalOption` Enum | 첨부 파일 포함 옵션 |

---

## InboundEmail — 인바운드 이메일 처리

Email Service를 통해 수신된 이메일을 Apex로 처리한다.

### InboundEmailHandler 인터페이스 구현 패턴

```apex
global class MyEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(
        Messaging.InboundEmail email,
        Messaging.InboundEnvelope env
    ) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();

        // 이메일 본문 처리
        String subject   = email.subject;
        String fromAddr  = email.fromAddress;
        String plainBody = email.plainTextBody;
        String htmlBody  = email.htmlBody;

        // 이메일 메시지 → Case 연결 예시
        Id caseId = EmailMessages.getRecordIdFromEmail(
            email.subject, email.plainTextBody, email.htmlBody
        );
        if (caseId == null) {
            Case c = new Case(Subject = email.subject);
            insert c;
            caseId = c.Id;
        }

        String toAddresses;
        if (email.toAddresses != null) {
            toAddresses = String.join(email.toAddresses, '; ');
        }

        EmailMessage em = new EmailMessage(
            Status          = '0',
            MessageIdentifier = email.messageId,
            ParentId        = caseId,
            FromAddress     = email.fromAddress,
            FromName        = email.fromName,
            ToAddress       = toAddresses,
            TextBody        = email.plainTextBody,
            HtmlBody        = email.htmlBody,
            Subject         = email.subject
        );
        insert em;

        result.success = true; // false면 발신자에게 오류 회신
        return result;
    }
}
```

### InboundEmail Properties

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `subject` | String | 제목 |
| `fromAddress` | String | 발신자 이메일 |
| `fromName` | String | 발신자 이름 |
| `toAddresses` | String[] | 수신자 목록 |
| `ccAddresses` | String[] | CC 주소 목록 |
| `replyTo` | String | Reply-To 헤더 |
| `plainTextBody` | String | 텍스트 본문 |
| `htmlBody` | String | HTML 본문 |
| `plainTextBodyIsTruncated` | Boolean | 텍스트 본문 잘림 여부 |
| `htmlBodyIsTruncated` | Boolean | HTML 본문 잘림 여부 |
| `messageId` | String | 이메일 고유 Message-ID |
| `inReplyTo` | String | 부모 이메일 Message-ID |
| `references` | String | 이메일 스레드 참조 |
| `headers` | InboundEmail.Header[] | RFC 2822 헤더 목록 |
| `binaryAttachments` | InboundEmail.BinaryAttachment[] | 바이너리 첨부 (이미지, 오디오 등) |
| `textAttachments` | InboundEmail.TextAttachment[] | 텍스트 첨부 |
| `authenticationResults` | InboundEmail.AuthenticationResult[] | DKIM/DMARC/SPF 인증 결과 |

---

## InboundEmailResult

이메일 서비스 처리 결과. null 반환 시 성공으로 간주.

```apex
Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
result.success = true;
// result.success = false → 발신자에게 result.message 내용으로 오류 회신
result.message = '처리 오류 상세 설명';
return result;
```

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `success` | Boolean | true: 성공, false: 오류 회신 발송 |
| `message` | String | 회신 이메일 본문 (success 무관하게 설정 가능) |

---

## InboundEnvelope

이메일 봉투 정보 (From/To 봉투 주소).

```apex
global Messaging.InboundEmailResult handleInboundEmail(
    Messaging.InboundEmail email,
    Messaging.InboundEnvelope env
) {
    String envFrom = env.fromAddress; // 봉투 발신자
    String envTo   = env.toAddress;   // 봉투 수신자 (Email Service 주소)
    ...
}
```

---

## ActionableNotification — 모바일 실행 가능 알림

모바일 기기에서 특정 액션을 실행할 수 있는 커스텀 알림.

```apex
Messaging.ActionableNotification notification =
    new Messaging.ActionableNotification.Builder()
        .withNotificationTypeId('0MLXXXXXXXXXXXX4AC')
        .withActionIdentifier('testAction')   // 액션 그룹 API명
        .withRecipientId('005XXXXXXXXXXXX')   // 수신 사용자 ID
        .withSenderId('005XXXXXXXXXXXX')      // 발신자 ID (선택)
        .withTargetId('500XXXXXXXXXXXXYAI')   // 대상 레코드 ID
        // .withTargetPageRef('/lightning/r/Case/500XXXXXXXXXXXXYAI/view') // 또는 URL
        .build();
```

### ActionError Enum

| 값 | 설명 |
|---|---|
| `ACCESS_DENIED` | 사용자 권한 없음 |
| `ACTION_NOT_IMPLEMENTED` | 지원하지 않는 액션 |
| `INTERNAL_ERROR` | 내부 오류 |
| `INVALID_ACTION_PARAMETERS` | 파라미터 오류 |
| `INVALID_STATE` | 잘못된 상태 |

### ActionResult 패턴

```apex
// 성공
Messaging.ActionResult result =
    new Messaging.ActionResult.Builder()
        .withSuccess(true)
        .withMessage('Action is executed successfully')
        .build();

// 실패
Messaging.ActionResult result =
    new Messaging.ActionResult.Builder()
        .withSuccess(false)
        .withMessage('Error updating case')
        .withErrorCode(Messaging.ActionError.INTERNAL_ERROR)
        .build();
```

---

## AttachmentRetrievalOption Enum

`renderStoredEmailTemplate()` 메서드와 함께 사용.

| 값 | 설명 |
|---|---|
| `METADATA_ONLY` | 파일명·ContentType·objectId만 포함 |
| `METADATA_WITH_BODY` | 첨부 파일 내용까지 포함 |
| `NONE` | 첨부 파일 제외 |

---

## 이미 있는 노트와의 관계

| 클래스 | 상세 노트 |
|---|---|
| `CustomNotification` | [[CustomNotification]] — send(), setNotificationTypeId() |
| `SingleEmailMessage` | [[SingleEmailMessage]] — setToAddresses, setHtmlBody, 첨부파일 |

---

## 관련 노트

- [[SingleEmailMessage]] — 단일 이메일 발송 상세
- [[CustomNotification]] — 인앱 알림 상세
- [[Compression Namespace]] — 이메일 첨부파일 압축/해제 시 함께 사용되는 gzip/zip API
