---
tags: [apex, namespace, rich-messaging, enhanced-messaging, payment, messaging-for-web, messaging-for-in-app]
source: salesforce_apex_reference_guide.pdf v67.0 — RichMessaging Namespace (doc p.3408–3457)
created: 2026-05-21
aliases: [RichMessaging, rich messaging apex, 강화된 메시징, enhanced messaging sdk, messaging for web apex, messaging for in-app apex, 메시징 결제, 메시징 폼]
---

# RichMessaging Namespace

> Enhanced Messaging(Messaging for Web / Messaging for In-App) 채널에서 결제·폼·인증 요청을 처리하는 Apex SDK — 22개 클래스/인터페이스/열거형 제공

---

## 개요

RichMessaging 네임스페이스는 **Enhanced Messaging 채널 전용** Apex SDK다. 고객이 채팅 채널에서 직접 결제·폼 제출·OAuth 인증을 수행할 때 백엔드 처리 로직을 구현하는 데 사용한다.

### 주요 인터페이스

| 인터페이스 | 목적 | 반환 |
|---|---|---|
| `AuthRequestHandler` | OAuth 토큰 검증 → 인증 결과 반환 | `AuthRequestResult` |
| `ProcessFormHandler` | 폼 제출 처리 → 생성된 레코드 ID 반환 | `ID` |
| `ProcessPaymentHandler` | 결제 요청 처리 → 결제 결과 반환 | `ProcessPaymentResult` |

### 클래스 목록

| 클래스 / 열거형 | 유형 | 설명 |
|---|---|---|
| `AbstractTiming` | Abstract Class | `DeferredTiming` / `RecurringTiming`의 부모 |
| `AddressableContact` | Class | 청구/배송 연락처 정보 |
| `AuthRequestHandler` | Interface | 인증 요청 처리 |
| `AuthRequestResponse` | Class | 인증 요청 응답 (accessToken, contextRecordId) |
| `AuthRequestResult` | Class | 인증 처리 결과 (redirectPageReference, resultStatus) |
| `AuthRequestResultStatus` | Enum | `AUTHENTICATED` \| `DECLINED` |
| `DeferredTiming` | Class | 지연 결제 타이밍 (단일 날짜) |
| `MessageDefinitionInputParameter` | Class | 메시지 정의 입력 파라미터 (13개 프로퍼티) |
| `PaymentItemStatus` | Enum | `FinalCost` \| `PendingCost` |
| `PaymentLineItem` | Class | 결제 항목 (레이블, 금액, 타이밍) |
| `PaymentMethod` | Class | 결제 수단 (네트워크, 타입, 표시명) |
| `PostalAddress` | Class | 우편 주소 |
| `ProcessFormHandler` | Interface | 폼 제출 처리 |
| `ProcessPaymentHandler` | Interface | 결제 요청 처리 |
| `ProcessPaymentRequest` | Class | 결제 요청 (트랜잭션 ID, 결제 데이터, 연락처) |
| `ProcessPaymentResult` | Class | 결제 처리 결과 (resultStatus, errorMessage) |
| `ProcessPaymentResultStatus` | Enum | `PROCESSOR_ERROR` \| `SUCCESS` |
| `RecurringTiming` | Class | 반복 결제 타이밍 (시작일, 종료일, 주기) |
| `ShippingMethod` | Class | 배송 수단 (레이블, 금액, 상세, 식별자) |
| `TimeSlotOption` | Class | 예약 타임슬롯 옵션 |
| `TimingIntervalUnit` | Enum | `Day` \| `Hour` \| `Minute` \| `Month` \| `Year` |
| `TimingType` | Enum | `DeferredTiming` \| `RecurringTiming` |

---

## AbstractTiming

`DeferredTiming`과 `RecurringTiming`의 추상 부모 클래스. `PaymentLineItem`의 `timing` / `timingValue` 프로퍼티 타입으로 사용된다.

---

## AddressableContact

결제 요청의 청구자/수신자 연락처 정보를 담는 클래스.

```apex
public AddressableContact(
    String givenName,
    String phoneticGivenName,
    String familyName,
    String phoneticFamilyName,
    String emailAddress,
    String phoneNumber,
    RichMessaging.PostalAddress postalAddress
)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `emailAddress` | String | 이메일 주소 |
| `familyName` | String | 성(家名) |
| `givenName` | String | 이름 |
| `phoneNumber` | String | 전화번호 |
| `phoneticFamilyName` | String | 성 발음 표기 |
| `phoneticGivenName` | String | 이름 발음 표기 |
| `postalAddress` | RichMessaging.PostalAddress | 우편 주소 |

---

## AuthRequestHandler (Interface)

OAuth 인증 요청을 처리하는 인터페이스. `global` 클래스로 구현 필수.

```apex
public RichMessaging.AuthRequestResult handleAuthRequest(RichMessaging.AuthRequestResponse var1)
```

> **⚠️ 한도 재정의:** 이 인터페이스를 구현하는 클래스에는 표준 Apex 한도가 아닌 아래 별도 한도가 적용된다.
> - SOQL 쿼리: **2개**
> - SOQL 당 레코드: **2개**
> - DML 문: **1개**
> - DML 당 레코드: **1개**
> - Callout: **2개**

```apex
// AuthRequestHandler 구현 예시
global class SampleAuthRequestHandler implements RichMessaging.AuthRequestHandler {
    global RichMessaging.AuthRequestResult
    handleAuthRequest(RichMessaging.AuthRequestResponse authReqResponse) {
        String sessionId = authReqResponse.getContextRecordId();
        String contactEmail = [SELECT MessagingSession.EndUserContact.Email FROM
            MessagingSession WHERE id = :sessionId].EndUserContact.Email;
        RichMessaging.AuthRequestResultStatus authRequestStatus =
            RichMessaging.AuthRequestResultStatus.DECLINED;
        DateTime dt = DateTime.now();
        if (!String.isBlank(contactEmail)) {
            String userInfoUrl = 'https://api.MY_AUTH_DOMAIN.com/v1/';
            HttpRequest req = new HttpRequest();
            req.setEndpoint(userInfoUrl);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer ' + authReqResponse.getAccessToken());
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String responseBody = res.getBody();
            UserWrapper userInfo = (UserWrapper)System.JSON.deserialize(
                responseBody, UserWrapper.class
            );
            if (userInfo.email == contactEmail) {
                authRequestStatus = RichMessaging.AuthRequestResultStatus.AUTHENTICATED;
                dt = dt.addHours(6);
            }
        }
        return new RichMessaging.AuthRequestResult(null, authRequestStatus, dt);
    }
    public class UserWrapper {
        public String href;
        public String display_name;
        public String type;
        public String country;
        public String product;
        public String email;
    }
}
```

---

## AuthRequestResponse

인증 요청 정보(액세스 토큰, 컨텍스트 레코드 ID, 인증 공급자명)를 담는 클래스.

```apex
public AuthRequestResponse(
    String accessToken,
    String contextRecordId,
    String authProviderName
)
```

### 메서드

| 메서드 | 반환 | 설명 |
|---|---|---|
| `getAccessToken()` | String | OAuth 액세스 토큰 반환 |
| `getAuthProviderName()` | String | 인증 공급자 이름 반환 |
| `getContextRecordId()` | String | 컨텍스트 레코드 ID 반환 |

---

## AuthRequestResult

인증 처리 결과를 담는 클래스.

```apex
public AuthRequestResult(
    System.PageReference redirectPageReference,
    RichMessaging.AuthRequestResultStatus resultStatus,
    Datetime expirationDateTime
)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `expirationDateTime` | Datetime | 인증 만료 일시 |
| `redirectPageReference` | System.PageReference | 인증 완료 후 리디렉션 URL |
| `resultStatus` | RichMessaging.AuthRequestResultStatus | 인증 결과 상태 |

---

## AuthRequestResultStatus (Enum)

| 값 | 설명 |
|---|---|
| `AUTHENTICATED` | 인증 성공 |
| `DECLINED` | 인증 거부 |

---

## DeferredTiming

단일 날짜로 지연 결제를 표현하는 타이밍 클래스. `AbstractTiming`의 구체 구현.

```apex
public DeferredTiming(Datetime deferredDate)
public DeferredTiming()
```

### 프로퍼티 (_Value 이중 패턴)

| 프로퍼티 | 타입 | 용도 |
|---|---|---|
| `deferredDate` | Datetime | `@InvocableVariable` — Flow 바인딩 |
| `deferredDateValue` | Datetime | LWC 컴포넌트 바인딩 |
| `timingType` | String | 항상 `"DeferredTiming"` (read-only) |

---

## MessageDefinitionInputParameter

메시지 정의에 대한 입력 파라미터를 담는 클래스. 다양한 타입의 단일/목록 값을 지원한다.

### 프로퍼티 (13개)

| 프로퍼티 | 타입 |
|---|---|
| `booleanValue` | Boolean |
| `booleanValues` | List\<Boolean\> |
| `dateTimeValue` | Datetime |
| `dateTimeValues` | List\<Datetime\> |
| `dateValue` | Date |
| `dateValues` | List\<Date\> |
| `name` | String |
| `numberValue` | Double |
| `numberValues` | List\<Double\> |
| `recordIdValue` | String |
| `recordIdValues` | List\<String\> |
| `textValue` | String |
| `textValues` | List\<String\> |

---

## PaymentItemStatus (Enum)

| 값 | 설명 |
|---|---|
| `FinalCost` | 최종 확정 금액 |
| `PendingCost` | 예상(미확정) 금액 |

---

## PaymentLineItem

결제 내역의 개별 항목(레이블, 금액, 타이밍 포함)을 나타내는 클래스.

```apex
public PaymentLineItem(String label, Double amount, RichMessaging.AbstractTiming timing)
public PaymentLineItem(String label, Double amount)
public PaymentLineItem()
```

### 프로퍼티 (_Value 이중 패턴)

| 프로퍼티 | 타입 | 용도 |
|---|---|---|
| `amount` | Double | Flow `@InvocableVariable` |
| `amountValue` | Double | LWC 바인딩 |
| `automaticReloadPaymentThresholdAmount` | Double | Flow `@InvocableVariable` |
| `automaticReloadPaymentThresholdAmountValue` | Double | LWC 바인딩 |
| `label` | String | Flow `@InvocableVariable` |
| `labelValue` | String | LWC 바인딩 |
| `lineItemType` | String | read-only |
| `status` | String | Flow `@InvocableVariable` |
| `statusValue` | RichMessaging.PaymentItemStatus | LWC 바인딩 |
| `timing` | RichMessaging.AbstractTiming | Flow `@InvocableVariable` |
| `timingValue` | RichMessaging.AbstractTiming | LWC 바인딩 |

```apex
// @InvocableMethod로 결제 항목 목록 반환 예시
public with sharing class MessagingPaymentLineItems {
    @InvocableMethod
    public static List<List<RichMessaging.PaymentLineItem>> getLineItems() {
        Double amount = 0.25;
        List<List<RichMessaging.PaymentLineItem>> result =
            new List<List<RichMessaging.PaymentLineItem>>();
        RichMessaging.PaymentLineItem pizza = new RichMessaging.PaymentLineItem('pizza', amount);
        RichMessaging.PaymentLineItem pasta = new RichMessaging.PaymentLineItem('pasta', amount);
        pizza.statusValue = RichMessaging.PaymentItemStatus.FinalCost;
        pasta.statusValue = RichMessaging.PaymentItemStatus.FinalCost;
        List<RichMessaging.PaymentLineItem> options = new List<RichMessaging.PaymentLineItem>{
            pizza, pasta
        };
        result.add(options);
        return result;
    }
}
```

---

## PaymentMethod

결제 수단(카드 네트워크, 결제 타입, 표시명)을 담는 클래스.

```apex
public PaymentMethod(String network, String paymentType, String displayName)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `displayName` | String | 결제 수단 표시명 |
| `network` | String | 카드 네트워크 (예: Visa, Mastercard) |
| `paymentType` | String | 결제 타입 |

---

## PostalAddress

우편 주소 정보를 담는 클래스.

```apex
public PostalAddress(
    List<String> addressLines,
    String subLocality,
    String locality,
    String postalCode,
    String subAdministrativeArea,
    String administrativeArea,
    String country,
    String countryCode
)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `addressLines` | List\<String\> | 주소 행 목록 |
| `administrativeArea` | String | 시/도 |
| `country` | String | 국가명 |
| `countryCode` | String | 국가 코드 |
| `locality` | String | 시/군/구 |
| `postalCode` | String | 우편번호 |
| `subAdministrativeArea` | String | 하위 행정구역 |
| `subLocality` | String | 동/읍/면 |

---

## ProcessFormHandler (Interface)

폼 제출을 처리하고 새로 생성된 레코드 ID를 반환하는 인터페이스.

```apex
ID processFormRequest(RichMessaging.ProcessFormResponse formResponse)
```

> **참고:** `ProcessFormResponse`는 RichMessaging 클래스 인벤토리에 별도 문서가 없다. `formResponse.formValues.get('fieldName')` 패턴으로 Map처럼 폼 필드 값에 접근한다.

```apex
// 폼 제출로 Contact 생성 예시
global class ContactApexFormHandler implements RichMessaging.ProcessFormHandler {
    global ID processFormRequest(RichMessaging.ProcessFormResponse formResponse) {
        Contact newContact = new Contact(
            Phone = formResponse.formValues.get('Phone'),
            Salutation = formResponse.formValues.get('Salutation'),
            Email = formResponse.formValues.get('Email')
        );
        insert newContact;
        return newContact.Id;
    }
}
```

---

## ProcessPaymentHandler (Interface)

결제 요청을 처리하는 인터페이스.

```apex
public RichMessaging.ProcessPaymentResult processPaymentRequest(RichMessaging.ProcessPaymentRequest var1)
```

```apex
// 결제 처리 예시 (항상 SUCCESS 반환)
global class MyProcessPaymentHandler implements RichMessaging.ProcessPaymentHandler {
    global RichMessaging.ProcessPaymentResult
    processPaymentRequest(RichMessaging.ProcessPaymentRequest paymentRequest) {
        return new RichMessaging.ProcessPaymentResult(
            RichMessaging.ProcessPaymentResultStatus.SUCCESS
        );
    }
}
```

---

## ProcessPaymentRequest

결제 요청 데이터를 담는 클래스.

```apex
public ProcessPaymentRequest(
    String transactionIdentifier,
    String paymentData,
    RichMessaging.AddressableContact billingContact,
    RichMessaging.AddressableContact shippingContact,
    RichMessaging.PaymentMethod paymentMethod,
    RichMessaging.ShippingMethod shippingMethod,
    String contextRecordId
)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `billingContact` | RichMessaging.AddressableContact | 청구 연락처 |
| `contextRecordId` | String | 컨텍스트 레코드 ID |
| `paymentData` | String | 결제 데이터 |
| `paymentMethod` | RichMessaging.PaymentMethod | 결제 수단 |
| `shippingContact` | RichMessaging.AddressableContact | 배송 연락처 |
| `shippingMethod` | RichMessaging.ShippingMethod | 배송 수단 |
| `transactionIdentifier` | String | 트랜잭션 식별자 |

---

## ProcessPaymentResult

결제 처리 결과를 담는 클래스.

```apex
public ProcessPaymentResult(RichMessaging.ProcessPaymentResultStatus resultStatus, String errorMessage)
public ProcessPaymentResult(RichMessaging.ProcessPaymentResultStatus resultStatus)
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `errorMessage` | String | 오류 메시지 (실패 시) |
| `resultStatus` | RichMessaging.ProcessPaymentResultStatus | 결제 결과 상태 |

---

## ProcessPaymentResultStatus (Enum)

| 값 | 설명 |
|---|---|
| `PROCESSOR_ERROR` | 결제 처리 오류 |
| `SUCCESS` | 결제 성공 |

---

## RecurringTiming

시작일·종료일·주기로 반복 결제를 표현하는 타이밍 클래스. `AbstractTiming`의 구체 구현.

```apex
public RecurringTiming(
    Date startDate,
    Date endDate,
    Integer intervalCount,
    RichMessaging.TimingIntervalUnit intervalUnit
)
public RecurringTiming()
```

### 프로퍼티 (_Value 이중 패턴)

| 프로퍼티 | 타입 | 용도 |
|---|---|---|
| `endDate` | Date | Flow `@InvocableVariable` |
| `endDateValue` | Date | LWC 바인딩 |
| `intervalCount` | Integer | Flow `@InvocableVariable` |
| `intervalCountValue` | Integer | LWC 바인딩 |
| `intervalUnit` | String | Flow `@InvocableVariable` |
| `intervalUnitValue` | RichMessaging.TimingIntervalUnit | LWC 바인딩 |
| `startDate` | Date | Flow `@InvocableVariable` |
| `startDateValue` | Date | LWC 바인딩 |
| `timingType` | String | 항상 `"RecurringTiming"` (read-only) |

---

## ShippingMethod

배송 수단(레이블, 금액, 상세, 식별자)을 나타내는 클래스.

```apex
public ShippingMethod(String label, Double amount, String detail, String identifier)
public ShippingMethod()
```

### 프로퍼티 (_Value 이중 패턴)

| 프로퍼티 | 타입 | 용도 |
|---|---|---|
| `amount` | Double | Flow `@InvocableVariable` |
| `amountValue` | Double | LWC 바인딩 |
| `detail` | String | Flow `@InvocableVariable` |
| `detailValue` | String | LWC 바인딩 |
| `identifier` | String | Flow `@InvocableVariable` |
| `identifierValue` | String | LWC 바인딩 |
| `label` | String | Flow `@InvocableVariable` |
| `labelValue` | String | LWC 바인딩 |
| `shippingMethodType` | String | read-only |

```apex
// @InvocableMethod로 배송 수단 목록 반환 예시
public with sharing class MessagingShippingMethods {
    @InvocableMethod
    public static List<List<RichMessaging.ShippingMethod>> getShippingMethods() {
        Double amount = 0.25;
        List<List<RichMessaging.ShippingMethod>> result =
            new List<List<RichMessaging.ShippingMethod>>();
        List<RichMessaging.ShippingMethod> options = new List<RichMessaging.ShippingMethod>{
            new RichMessaging.ShippingMethod('doordash', amount, '1 hour delivery to your door', 'ddash'),
            new RichMessaging.ShippingMethod('UPS', amount, '2 days delivery', 'UPS')
        };
        result.add(options);
        return result;
    }
}
```

---

## TimeSlotOption

예약 가능 타임슬롯을 나타내는 클래스. 시작 시간 + 종료 시간 또는 시작 시간 + 지속 시간(초 단위)으로 생성한다.

```apex
public TimeSlotOption(Datetime startTime, Datetime endTime)
public TimeSlotOption(Datetime startTime, Integer duration)  // duration: 초 단위
public TimeSlotOption()
```

### 프로퍼티 (_Value 이중 패턴)

| 프로퍼티 | 타입 | 용도 |
|---|---|---|
| `duration` | Integer | 지속 시간(초) — Flow `@InvocableVariable` |
| `durationValue` | Integer | LWC 바인딩 |
| `endTimeValue` | Datetime | 종료 시간 — LWC 바인딩 |
| `startTime` | Datetime | 시작 시간 — Flow `@InvocableVariable` |
| `startTimeValue` | Datetime | LWC 바인딩 |

---

## TimingIntervalUnit (Enum)

`RecurringTiming`의 `intervalUnit`에 사용.

| 값 |
|---|
| `Day` |
| `Hour` |
| `Minute` |
| `Month` |
| `Year` |

---

## TimingType (Enum)

| 값 |
|---|
| `DeferredTiming` |
| `RecurringTiming` |

---

## _Value suffix 이중 프로퍼티 패턴

RichMessaging SDK는 같은 데이터를 두 프로퍼티로 이중 노출한다.

| 프로퍼티 형식 | 애노테이션 | 사용 컨텍스트 |
|---|---|---|
| `xxx` | `@InvocableVariable` | Flow에서 직접 매핑 |
| `xxxValue` | (없음) | LWC 컴포넌트 바인딩 |

예: `PaymentLineItem.status` (Flow) vs `PaymentLineItem.statusValue` (LWC)

---

## 관련 노트

- [[CommercePayments Namespace]] — Payment Gateway ISV 어댑터 (결제 처리 유사 패턴)
- [[System Namespace]] — PageReference 클래스 (AuthRequestResult.redirectPageReference 타입)
- [[DataRetrieval Namespace]] — Service Cloud 인게이지먼트·대화 트랜스크립트 (같은 메시징 채널 도메인)
- [[RevSignaling Namespace]] — Revenue Cloud 시그널 송수신 어댑터 (같은 ISV 콜백 어댑터 패턴)
