---
tags: [apex, namespace, commercepayments, payment-gateway, b2b-commerce, d2c-commerce, payment]
source: salesforce_apex_reference_guide.pdf p.317–526
created: 2026-05-20
aliases: [CommercePayments, CommercePayments Namespace, Payment Gateway Adapter, 결제 게이트웨이 어댑터, Apex Payment Gateway, ISV Payment Adapter]
---

# CommercePayments Namespace

> Salesforce Payments용 Payment Gateway ISV 어댑터 SDK — `PaymentGatewayAdapter` 인터페이스 구현으로 외부 결제 게이트웨이를 Salesforce와 연결한다.

---

## 개요

`commercepayments` 네임스페이스는 B2B/D2C Commerce에서 결제를 처리하는 ISV 게이트웨이 어댑터를 구현하는 데 필요한 45개 이상의 클래스와 인터페이스를 제공한다.

- **동기 처리:** `PaymentGatewayAdapter.processRequest()` 구현
- **비동기 처리:** `PaymentGatewayAsyncAdapter.processNotification()` 추가 구현
- **비동기 어댑터는 반드시 두 인터페이스를 모두 구현해야 한다**

```apex
// 동기 전용 어댑터 (기본)
global class MyAdapter implements commercepayments.PaymentGatewayAdapter {
    global commercepayments.GatewayResponse processRequest(
            commercepayments.PaymentGatewayContext gatewayContext) {
        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        // RequestType으로 분기하여 처리
        if (requestType == commercepayments.RequestType.Authorize) { ... }
        else if (requestType == commercepayments.RequestType.Capture) { ... }
        else if (requestType == commercepayments.RequestType.ReferencedRefund) { ... }
        else if (requestType == commercepayments.RequestType.Tokenize) { ... }
        else if (requestType == commercepayments.RequestType.PostAuthorization) { ... }
        else if (requestType == commercepayments.RequestType.Sale) { ... }
    }
}
```

---

## 클래스 목록 (역할별)

### 핵심 인터페이스

| 클래스 | 설명 |
|---|---|
| `PaymentGatewayAdapter` | 동기 게이트웨이 어댑터 — `processRequest()` 구현 필수 |
| `PaymentGatewayAsyncAdapter` | 비동기 알림 수신 — `processNotification()` 구현 필수 (반드시 PaymentGatewayAdapter도 구현) |

### 컨텍스트 클래스

| 클래스 | 설명 |
|---|---|
| `PaymentGatewayContext` | 동기 요청 컨텍스트 — `getPaymentRequest()`, `getPaymentRequestType()` |
| `PaymentGatewayNotificationContext` | 비동기 알림 컨텍스트 — `getPaymentGatewayNotificationRequest()` |
| `PaymentGatewayNotificationRequest` | 비동기 알림 HTTP 요청 — `requestBody`, `getHeaders()`, `getRequestBody()` |

### 추상 베이스 클래스

| 클래스 | 설명 |
|---|---|
| `AbstractResponse` | 모든 응답의 최상위 베이스 — gateway 코드, 날짜, 메시지, SalesforceResultCodeInfo |
| `AbstractTransactionResponse` | AbstractResponse 확장 — 금액, 게이트웨이 참조번호 추가 |

### 요청 클래스

| 클래스 | 설명 |
|---|---|
| `AuthorizationRequest` | 카드 승인 요청 |
| `CaptureRequest` | 승인된 결제 포획 요청 |
| `ReferencedRefundRequest` | 이전 거래 참조 환불 요청 |
| `PostAuthorizationRequest` | 사후 승인 요청 (금액, accountId, 결제 수단 포함) |
| `SaleRequest` | 즉시 결제 요청 (Authorize + Capture 통합) |
| `PaymentMethodTokenizationRequest` | 결제 수단 토큰화 요청 |
| `AlternativePaymentMethodRequest` | 대체 결제 수단 요청 (페이팔 등) |
| `AddressRequest` | 청구/배송 주소 (테스트 생성자만 있음) |
| `PostAuthApiPaymentMethodRequest` | 사후 승인 결제 수단 정보 |
| `SaleApiPaymentMethodRequest` | Sale 요청 결제 수단 정보 |
| `EnhancedPaymentDataInput` | Level 2/Level 3 결제 데이터 (서드파티 게이트웨이 전용) |
| `LineItemInput` | EnhancedPaymentDataInput의 품목 데이터 |

### 응답 클래스

| 클래스 | 설명 |
|---|---|
| `AuthorizationResponse` | 승인 응답 — AbstractTransactionResponse 확장 |
| `CaptureResponse` | 포획 응답 — AbstractTransactionResponse 확장 |
| `ReferencedRefundResponse` | 환불 응답 — AbstractTransactionResponse 확장 |
| `PostAuthorizationResponse` | 사후 승인 응답 (비동기, authCode, 만료일 포함) |
| `SaleResponse` | Sale 응답 — AbstractTransactionResponse 확장 |
| `PaymentMethodTokenizationResponse` | 토큰화 응답 (gatewayToken/gatewayTokenEncrypted 포함) |
| `AlternativePaymentMethodResponse` | 대체 결제 수단 응답 |
| `CardPaymentMethodResponse` | 카드 응답 데이터 (마스킹된 번호, 만료일, 카드 종류) |
| `PaymentMethodDetailsResponse` | 결제 수단 상세 응답 |
| `GatewayErrorResponse` | 오류 응답 — errorCode(HTTP 상태), errorMessage |
| `GatewayNotificationResponse` | 비동기 알림 처리 결과 응답 |
| `GatewayResponse` | 마커 인터페이스 — 모든 응답 타입의 루트 |

### 알림 클래스 (비동기)

| 클래스 | 설명 |
|---|---|
| `BaseNotification` | 알림 베이스 클래스 |
| `CaptureNotification` | 포획 완료 알림 |
| `ReferencedRefundNotification` | 환불 완료 알림 |
| `TokenizeNotification` | 토큰화 완료 알림 |
| `NotificationClient` | 알림 저장 — `record(BaseNotification)` 정적 메서드 |
| `NotificationSaveResult` | 알림 저장 결과 — `isSuccess()`, `getErrorMessage()`, `getStatusCode()` |

### 유틸리티 클래스

| 클래스 | 설명 |
|---|---|
| `PaymentsHttp` | 어댑터 내 HTTP 호출 — 표준 `Http` 클래스 대체 |
| `SalesforceResultCodeInfo` | SF 표준 결과 코드 매핑 (SalesforceResultCode 또는 CMT 기반) |
| `CustomMetadataTypeInfo` | CMT 기반 결과 코드 매핑 (cmtRecordId, fieldName) |

---

## 핵심 인터페이스

### PaymentGatewayAdapter

```apex
global interface PaymentGatewayAdapter {
    global commercepayments.GatewayResponse processRequest(
        commercepayments.PaymentGatewayContext var1);
}
```

### PaymentGatewayAsyncAdapter

```apex
global interface PaymentGatewayAsyncAdapter {
    global commercepayments.GatewayNotificationResponse processNotification(
        commercepayments.PaymentGatewayNotificationContext var1);
}
```

---

## 컨텍스트 API

### PaymentGatewayContext

```apex
// 프로덕션: 플랫폼이 생성 (생성자 없음)
// 테스트 전용 생성자:
global PaymentGatewayContext(
    commercepayments.PaymentGatewayRequest request,
    String requestType)

global commercepayments.PaymentGatewayRequest getPaymentRequest()
global String getPaymentRequestType()
```

### PaymentGatewayNotificationContext

```apex
global commercepayments.PaymentGatewayNotificationRequest getPaymentGatewayNotificationRequest()
```

### PaymentGatewayNotificationRequest

```apex
global Blob requestBody {get; set;}
global Map<String,String> getHeaders()
global Blob getRequestBody()
```

---

## 추상 베이스 클래스 API

### AbstractResponse (모든 응답의 베이스)

```apex
global void setGatewayAvsCode(String gatewayAvsCode)            // max 64자
global void setGatewayDate(Datetime gatewayDate)
global void setGatewayMessage(String gatewayMessage)             // max 255자
global void setGatewayResultCode(String gatewayResultCode)       // max 64자
global void setGatewayResultCodeDescription(String desc)         // max 1000자
global void setSalesforceResultCodeInfo(
    commercepayments.SalesforceResultCodeInfo info)
public void setRetryCategory(commercepayments.RetryCategory retryCategory)
public void setRetryDecision(commercepayments.RetryDecision retryDecision)
```

### AbstractTransactionResponse (AbstractResponse 확장)

```apex
// AbstractResponse 메서드 모두 상속 +
global void setAmount(Double amount)
global void setGatewayReferenceDetails(String gatewayReferenceDetails)
global void setGatewayReferenceNumber(String gatewayReferenceNumber)
```

---

## 요청 클래스 상세

### SaleRequest — 즉시 결제

```apex
global String accountId {get;set;}
global Double amount {get;set;}
global String comments {get;set;}
global String currencyIsoCode {get;set;}
public commercepayments.EnhancedPaymentDataInput enhancedPaymentData {get;set;}
public String paymentInitiationSourceId {get;set;}
global commercepayments.SaleApiPaymentMethodRequest paymentMethod {get;set;}
public Map<String,String> paymentMethodData {get;set;}  // GatewayToken, Type, GatewayReference, StandardEntryCode
public Boolean submittedByMerchant {get;set;}
```

### PostAuthorizationRequest

```apex
global String accountId {get;set;}
global Double amount {get;set;}
global String comments {get;set;}
global String currencyIsoCode {get;set;}
global PostAuthApiPaymentMethodRequest paymentMethod {get;set;}
```

### AddressRequest

```apex
// 테스트 전용 생성자:
global AddressRequest(String street, String city, String state,
                      String country, String postalCode)
// 프로퍼티:
global String city {get;set;}
global String companyName {get;set;}
global String country {get;set;}
global String postalCode {get;set;}
global String state {get;set;}
global String street {get;set;}
```

### EnhancedPaymentDataInput (서드파티 게이트웨이 전용)

```apex
// ⚠️ 네이티브 Salesforce Payments에서는 지원되지 않음
public Map<String,String> additionalAttributes {get;set;}
public Double discountAmount {get;set;}
public Double dutyAmount {get;set;}
public String invoiceNumber {get;set;}
public List<commercepayments.LineItemInput> lineItems {get;set;}
public String referenceId {get;set;}
public Double salesTaxAmount {get;set;}
public String shipFromZip {get;set;}
public String shipToCountry {get;set;}
public String shipToZip {get;set;}
public Double shippingAmount {get;set;}
public Double taxRate {get;set;}
public Double totalTaxAmount {get;set;}
```

---

## 응답 클래스 상세

### PostAuthorizationResponse (AbstractTransactionResponse 확장 + 추가 메서드)

```apex
global void setAlternativePaymentMethodResponse(
    commercepayments.AlternativePaymentMethodResponse response)
global void setAsync(Boolean async)
global void setAuthorizationExpirationDate(Datetime authExpDate)
global void setGatewayAuthCode(String gatewayAuthCode)           // max 64자
public void setPaymentMethodDetails(
    commercepayments.PaymentMethodDetailsResponse details)
global void setPaymentMethodTokenizationResponse(
    commercepayments.PaymentMethodTokenizationResponse tokenResponse)
```

### PaymentMethodTokenizationResponse

```apex
public void setAmount(Double amount)
public void setAsync(Boolean async)       // true = 플랫폼이 알림 대기
public void setBankName(String bankName)
public void setChecksum(String checksum)
public void setCustomerReference(String customerReference)
global void setGatewayAvsCode(String gatewayAvsCode)
global void setGatewayDate(Datetime gatewayDate)
global void setGatewayMessage(String gatewayMessage)
global void setGatewayToken(String gatewayToken)           // CardPaymentMethod/DigitalWallet에는 사용 금지
global void setGatewayTokenDetails(String gatewayTokenDetails)
global void setGatewayTokenEncrypted(String gatewayTokenEncrypted)  // CardPaymentMethod/DigitalWallet은 이것 사용
global void setSalesforceResultCodeInfo(
    commercepayments.SalesforceResultCodeInfo info)
```

### GatewayErrorResponse

```apex
// errorCode: HTTP 상태 문자열 (예: '400', '403', '500')
global GatewayErrorResponse(String errorCode, String errorMessage)
```

### GatewayNotificationResponse

```apex
global void setResponseBody(Blob responseBody)
global void setStatusCode(Integer statusCode)
```

---

## 유틸리티 클래스

### PaymentsHttp — 어댑터 전용 HTTP 클라이언트

```apex
global PaymentsHttp()
global HttpResponse send(HttpRequest request)
// ⚠️ 어댑터 내에서는 표준 Http 클래스 대신 반드시 이것을 사용한다
```

### NotificationClient — 비동기 알림 저장

```apex
global static commercepayments.NotificationSaveResult record(
    commercepayments.BaseNotification notification)
```

### NotificationSaveResult

```apex
global String getErrorMessage()
global Integer getStatusCode()
global Boolean isSuccess()
```

### SalesforceResultCodeInfo — 결과 코드 매핑

```apex
// 열거형으로 직접 매핑:
global SalesforceResultCodeInfo(
    commercepayments.SalesforceResultCode salesforceResultCode)

// CMT 레코드로 매핑:
global SalesforceResultCodeInfo(
    commercepayments.CustomMetadataTypeInfo customMetadataTypeInfo)
```

### CustomMetadataTypeInfo

```apex
global CustomMetadataTypeInfo(String cmtRecordId, String cmtSfResultCodeFieldName)
```

---

## 열거형

### RequestType — 요청 유형

| 값 | 설명 |
|---|---|
| `Authorize` | 카드 승인 (포획 없음) |
| `Capture` | 승인 후 포획 |
| `ReferencedRefund` | 이전 거래 참조 환불 |
| `Tokenize` | 결제 수단 토큰화 |
| `PostAuthorization` | 사후 승인 |
| `Sale` | 즉시 결제 (Authorize + Capture) |

### SalesforceResultCode — 표준 결과 코드 (7개)

| 값 | 의미 |
|---|---|
| `Success` | 게이트웨이 처리 성공 |
| `Decline` | 소프트 거절 (잔액 부족 — 재시도 가능) |
| `PermanentFail` | 영구 실패 (계정 종료·사기 등) |
| `RequiresReview` | 은행 추가 정보 필요 |
| `Indeterminate` | 게이트웨이 무응답 — 상태 확인 필요 |
| `SystemError` | 게이트웨이 응답 전 Salesforce 호출 종료 |
| `ValidationError` | 잘못된 고객 정보 (카드명 오타, CVV 누락 등) |

### CardType Enum

`AmericanExpress` / `DinersClub` / `Jcb` / `Maestro` / `MasterCard` / `Visa`

### AccountType Enum

`Checking` / `Savings`

### AccountHolderType Enum

`Business` / `Individual`

### NotificationStatus Enum

`Failed` / `Success`

### PaymentMethodIdType Enum

`CardPaymentMethod` / `SavedPaymentMethod`

### StandardEntryClassCode Enum — ACH 결제 유형

| 값 | 설명 |
|---|---|
| `Ccd` | Corporate Credit or Debit (기업 결제) |
| `Ppd` | Prearranged Payment and Deposit (사전 계약 결제) |
| `Tel` | Telephone-Initiated Entry (전화 결제) |
| `Web` | Internet-Initiated/Mobile Entry (웹/모바일 결제) |

---

## 전체 구현 예시 — 비동기 Adyen 어댑터

```apex
global with sharing class AdyenAdapter
        implements commercepayments.PaymentGatewayAsyncAdapter,
                   commercepayments.PaymentGatewayAdapter {

    global AdyenAdapter() {}

    // ── 동기 처리 ──────────────────────────────────────────────
    global commercepayments.GatewayResponse processRequest(
            commercepayments.PaymentGatewayContext gatewayContext) {

        commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
        HttpRequest req = new HttpRequest();

        String body;
        if (requestType == commercepayments.RequestType.Capture) {
            req.setEndpoint('/pal/servlet/Payment/v52/capture');
            body = buildCaptureRequest(
                (commercepayments.CaptureRequest) gatewayContext.getPaymentRequest());
        } else if (requestType == commercepayments.RequestType.ReferencedRefund) {
            req.setEndpoint('/pal/servlet/Payment/v52/refund');
            body = buildRefundRequest(
                (commercepayments.ReferencedRefundRequest) gatewayContext.getPaymentRequest());
        }

        req.setBody(body);
        req.setMethod('POST');

        commercepayments.PaymentsHttp http = new commercepayments.PaymentsHttp();
        try {
            HttpResponse res = http.send(req);
            return parseResponse(res);
        } catch (CalloutException ce) {
            return new commercepayments.GatewayErrorResponse('500', ce.getMessage());
        }
    }

    // ── 비동기 알림 처리 ────────────────────────────────────────
    global commercepayments.GatewayNotificationResponse processNotification(
            commercepayments.PaymentGatewayNotificationContext notifContext) {

        commercepayments.PaymentGatewayNotificationRequest notifReq =
            notifContext.getPaymentGatewayNotificationRequest();

        Blob requestBody = notifReq.getRequestBody();
        Map<String,Object> jsonReq = (Map<String,Object>)
            JSON.deserializeUntyped(requestBody.toString());

        String eventCode = (String) jsonReq.get('eventCode');
        String pspReference = (String) jsonReq.get('pspReference');
        Double amount = (Double) ((Map<String,Object>) jsonReq.get('amount')).get('value');

        commercepayments.BaseNotification notification;
        commercepayments.NotificationStatus notifStatus =
            commercepayments.NotificationStatus.Success;

        if (eventCode == 'CAPTURE') {
            commercepayments.CaptureNotification cn =
                new commercepayments.CaptureNotification();
            cn.setStatus(notifStatus);
            cn.setGatewayReferenceNumber(pspReference);
            cn.setAmount(amount);
            notification = cn;
        } else if (eventCode == 'REFUND') {
            commercepayments.ReferencedRefundNotification rn =
                new commercepayments.ReferencedRefundNotification();
            rn.setStatus(notifStatus);
            rn.setGatewayReferenceNumber(pspReference);
            rn.setAmount(amount);
            notification = rn;
        }

        commercepayments.NotificationSaveResult saveResult =
            commercepayments.NotificationClient.record(notification);

        commercepayments.GatewayNotificationResponse gnr =
            new commercepayments.GatewayNotificationResponse();

        if (saveResult.isSuccess()) {
            System.debug('Notification accepted by platform');
        } else {
            System.debug('Errors: ' + saveResult.getErrorMessage());
        }

        gnr.setStatusCode(200);
        gnr.setResponseBody(Blob.valueOf('[accepted]'));
        return gnr;
    }
}
```

---

## GatewayErrorResponse — 오류 처리 패턴

```apex
global commercepayments.GatewayResponse processRequest(
        commercepayments.PaymentGatewayContext gatewayContext) {

    commercepayments.RequestType requestType = gatewayContext.getPaymentRequestType();
    commercepayments.GatewayResponse response;

    try {
        if (requestType == commercepayments.RequestType.Authorize) {
            response = createAuthResponse(
                (commercepayments.AuthorizationRequest) gatewayContext.getPaymentRequest());
        } else if (requestType == commercepayments.RequestType.Capture) {
            response = createCaptureResponse(
                (commercepayments.CaptureRequest) gatewayContext.getPaymentRequest());
        } else if (requestType == commercepayments.RequestType.ReferencedRefund) {
            response = createRefundResponse(
                (commercepayments.ReferencedRefundRequest) gatewayContext.getPaymentRequest());
        }
        return response;
    } catch (SalesforceValidationException e) {
        return new commercepayments.GatewayErrorResponse('400', e.getMessage());
    }
}
```

---

## SaleResponse 구성 예시

```apex
commercepayments.SaleResponse saleResponse = new commercepayments.SaleResponse();
saleResponse.setGatewayReferenceDetails('refDetailString');
saleResponse.setGatewayResultCode('res_code');
saleResponse.setGatewayResultCodeDescription('');
saleResponse.setGatewayReferenceNumber('');
saleResponse.setSalesforceResultCodeInfo(
    new commercepayments.SalesforceResultCodeInfo(
        commercepayments.SalesforceResultCode.Success));
```

---

## SalesforceResultCodeInfo — CMT 기반 동적 매핑

```apex
// 커스텀 메타데이터로 게이트웨이별 결과 코드 → Salesforce 코드 매핑
String cmtRecordId = 'My_Gateway_Success';
String fieldName = 'SalesforceResultCode__c';
commercepayments.CustomMetadataTypeInfo cmtInfo =
    new commercepayments.CustomMetadataTypeInfo(cmtRecordId, fieldName);
commercepayments.SalesforceResultCodeInfo resultInfo =
    new commercepayments.SalesforceResultCodeInfo(cmtInfo);

// 정적 매핑 (간단한 경우)
commercepayments.SalesforceResultCodeInfo staticInfo =
    new commercepayments.SalesforceResultCodeInfo(
        commercepayments.SalesforceResultCode.Success);
```

---

## 토큰 종류별 저장 방법

```apex
// CardPaymentMethod / DigitalWallet → Encrypted 사용
tokenResponse.setGatewayTokenEncrypted(encryptedToken);

// 그 외 결제 수단 → 일반 Token 사용
tokenResponse.setGatewayToken(plainToken);
```

---

## 관련 노트

- [[Apex MOC]]
- [[CommerceBuyGrp Namespace]] — Buyer Group 동적 배정
- [[CommerceExtension Namespace]] — B2B/D2C 확장 포인트 해결 전략
- [[CommerceOrders Namespace]] — B2B/D2C 주문 생성 Apex
- [[RestClient 패턴]] — 일반 외부 HTTP 호출 패턴
- [[5 Object Interfaces]] — SalesTransaction·PriceAdjustmentGroup 인터페이스 필드 참조
