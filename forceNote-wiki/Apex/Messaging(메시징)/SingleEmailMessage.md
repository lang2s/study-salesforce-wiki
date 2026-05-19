---
tags: [apex, messaging, email, single-email, sendEmail]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [SingleEmailMessage, 단일 이메일, Apex 이메일 발송, Messaging.sendEmail, setToAddresses, setHtmlBody]
---

# Messaging.SingleEmailMessage

> Apex에서 단일 이메일 한 건을 구성하고 발송하는 클래스.

---

## 기본 사용 패턴

```apex
// 1. 이메일 직접 작성
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new List<String>{ 'recipient@example.com' });
mail.setSubject('제목');
mail.setPlainTextBody('본문 텍스트');
mail.setHtmlBody('<h1>HTML 본문</h1>');

Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
for (Messaging.SendEmailResult r : results) {
    if (!r.isSuccess()) {
        System.debug(r.getErrors());
    }
}
```

---

## 템플릿 기반 발송

```apex
// 2. 이메일 템플릿 사용 (권장)
EmailTemplate template = [
    SELECT Id FROM EmailTemplate WHERE DeveloperName = 'My_Template' LIMIT 1
];
Contact recipient = [SELECT Id FROM Contact WHERE Email = 'user@example.com' LIMIT 1];

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setTemplateId(template.Id);
mail.setTargetObjectId(recipient.Id);    // 머지 필드 컨텍스트 + 수신자
mail.setWhatId(opportunityId);          // 관련 레코드 (머지 필드)

// Org-Wide Email 주소 사용 (선택)
OrgWideEmailAddress owa = [
    SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'No Reply' LIMIT 1
];
mail.setOrgWideEmailAddressId(owa.Id);

Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
```

---

## 첨부파일 발송

```apex
// 3. 파일 첨부
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new List<String>{ 'user@example.com' });
mail.setSubject('첨부 파일');
mail.setPlainTextBody('첨부 파일을 확인해 주세요.');

// Blob 직접 첨부
Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
attach.setFileName('report.txt');
attach.setBody(Blob.valueOf('파일 내용'));
attach.setContentType('text/plain');
mail.setFileAttachments(new List<Messaging.EmailFileAttachment>{ attach });

// 기존 ContentVersion/Document 첨부
mail.setEntityAttachments(new List<String>{ contentVersionId });

Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
```

---

## 수신거부(Unsubscribe) 지원

```apex
// 4. List-Unsubscribe 헤더 포함
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new List<String>{ contactId });    // Contact ID도 가능
mail.setSubject('뉴스레터');
mail.setPlainTextBody('본문');

// 수신거부 URL 설정
mail.setUnsubscribeUrls(
    new List<String>{ 'https://example.com/unsubscribe?id=123' }
);
mail.setOneClickPost(true);    // List-Unsubscribe-Post 헤더 추가

Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
```

---

## 주요 메서드 요약

| 메서드 | 설명 | 필수 |
|---|---|---|
| `setToAddresses(List<String>)` | 수신자 이메일 or Contact/Lead/User ID 목록 | 조건부 |
| `setCcAddresses(List<String>)` | CC 수신자 (최대 150명 합산) | - |
| `setBccAddresses(List<String>)` | BCC 수신자 | - |
| `setSubject(String)` | 제목 (템플릿 사용 시 덮어씀) | - |
| `setPlainTextBody(String)` | 일반 텍스트 본문 | 조건부 |
| `setHtmlBody(String)` | HTML 본문 | 조건부 |
| `setTemplateId(Id)` | 이메일 템플릿 ID | 조건부 |
| `setTargetObjectId(Id)` | 머지 필드 컨텍스트 Contact/Lead/User ID | 템플릿 시 필수 |
| `setWhatId(Id)` | 관련 레코드 (Case, Opp 등) 머지 필드용 | - |
| `setOrgWideEmailAddressId(Id)` | 발신 Org-Wide Email 주소 ID | - |
| `setEntityAttachments(List<String>)` | ContentVersion/Document/Attachment ID 첨부 | - |
| `setFileAttachments(List<EmailFileAttachment>)` | Blob 파일 직접 첨부 | - |
| `setTreatBodiesAsTemplate(Boolean)` | 본문을 머지 필드 포함 템플릿으로 처리 | - |
| `setTreatTargetObjectAsRecipient(Boolean)` | targetObjectId를 수신자로 처리 여부 (기본 true) | - |
| `setOptOutPolicy(String)` | 수신거부 설정 시 동작 (`FILTER`/`SEND`/`REJECT`) | - |
| `setUnsubscribeUrls(List<String>)` | List-Unsubscribe 헤더 URL | - |
| `setOneClickPost(Boolean)` | One-Click 수신거부 헤더 추가 | - |

---

## 한도 및 주의사항

| 항목 | 한도 |
|---|---|
| 하루 총 발송 수 | 조직 일일 이메일 한도 |
| 수신자 합계 (To+CC+BCC) | 최대 150명 |
| 첨부 파일 합계 | 10 MB |
| 단일 API 호출 발송 수 | 최대 10건 |

> 이메일 발송은 **도메인·사용자 이메일 인증**이 완료돼야 합니다. 미완료 시 발송 실패.

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| Apex 코드에서 이메일 한 건을 즉시 발송 | `Messaging.SingleEmailMessage` |
| 이메일 템플릿 + 머지 필드 기반 발송 | `setTemplateId()` + `setTargetObjectId()` |
| 대량 이메일 (수천 명 수신자) | `Messaging.MassEmailMessage` |
| 인앱(모바일·데스크톱) 알림이 필요한 경우 | `Messaging.CustomNotification` |
| 외부 이메일 서비스(SendGrid 등)를 통한 발송 | Callout + HTTP POST |

단일 트랜잭션에서 최대 10건까지 `Messaging.sendEmail()`로 한 번에 발송 가능하다. 수신자 합계가 150명을 초과하는 경우 MassEmailMessage를 검토한다.

---

## 관련 노트

- [[CustomNotification]] — 이메일 대신 인앱 알림
- [[Platform Event 발행]] — 비동기 알림 트리거
- [[Batch Apex]] — 대량 이메일 발송 (MassEmailMessage 사용 고려)
