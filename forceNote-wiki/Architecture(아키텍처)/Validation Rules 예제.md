---
tags: [architecture, validation, formula, regex, isblank, isnumber, ischanged, priorvalue, vlookup, ispickval]
aliases: [Validation Rule, 검증 규칙, 유효성 규칙, 수식 검증, REGEX 검증, SSN 형식, 우편번호 검증]
source: salesforce_useful_validation_formulas.pdf (Spring '26)
created: 2026-05-22
updated: 2026-05-22
---

# Validation Rules 예제

> Salesforce 검증 규칙 예제 모음 — 레코드 저장 전 데이터 무결성 검증.  
> 아래 수식은 **true일 때 오류**를 반환한다.

**상위:** [[Architecture MOC]] → [[00 Home]]

---

## 1. 주소 형식 검증 (Account)

### 미국 Billing ZIP Code (REGEX)

```
AND(
  OR(BillingCountry = "USA", BillingCountry = "US"),
  NOT(REGEX(BillingPostalCode, "\\d{5}(-\\d{4})?"))
)
```
**오류:** `ZIP code must be in 99999 or 99999-9999 format.`

---

### 캐나다 Billing Postal Code (REGEX)

```
AND(
  OR(BillingCountry = "CAN", BillingCountry = "CA", BillingCountry = "Canada"),
  NOT(REGEX(BillingPostalCode, "((?i)[ABCEGHJKLMNPRSTVXY]\\d[A-Z]?\\s?\\d[A-Z]\\d)?"))
)
```
**오류:** `Canadian postal code must be in A9A 9A9 format.`

---

### 미국 Billing State (CONTAINS)

```
AND(
  OR(BillingCountry = "US", BillingCountry = "USA", ISBLANK(BillingCountry)),
  OR(
    LEN(BillingState) < 2,
    NOT(CONTAINS(
      "AL:AK:AZ:AR:CA:CO:CT:DE:DC:FL:GA:HI:ID:IL:IN:IA:KS:KY:LA:ME:MD:MA:MI:MN:MS:MO:MT:NE:NV:NH:"
      & "NJ:NM:NY:NC:ND:OH:OK:OR:PA:RI:SC:SD:TN:TX:UT:VT:VA:WA:WV:WI:WY",
      BillingState
    ))
  )
)
```
**오류:** `A valid two-letter state code is required.`

---

### ISO 3166 Billing Country (CONTAINS)

```
OR(
  LEN(BillingCountry) = 1,
  NOT(CONTAINS(
    "AF:AX:AL:DZ:..." /* ISO 3166 전체 — 아래 주석 참고 */,
    BillingCountry
  ))
)
```
> 전체 ISO 3166 국가 코드 문자열은 원본 PDF 참고. `BillingCountry`가 정확히 2자리 대문자 코드여야 한다.

**오류:** `A valid two-letter country code is required.`

---

### Billing Zip Code ↔ Billing State 교차 검증 (VLOOKUP)

```
VLOOKUP(
  $ObjectType.Zip_Code__c.Fields.City__c,
  $ObjectType.Zip_Code__c.Fields.Name,
  LEFT(BillingPostalCode, 5)
) <> BillingCity
```
> `Zip_Code__c` 커스텀 오브젝트(ZIP 코드 → State_Code__c 매핑)가 필요.

**오류:** `Billing Zip Code doesn't exist in specified Billing State.`

---

## 2. 연락처 / 전화번호 검증

### 미국 전화번호 10자리 (REGEX)

```
NOT(REGEX(Phone, "\\D*?(\\d\\D*?){10}"))
```
**오류:** `US phone numbers should be in this format: (999) 999-9999.`

---

### 국제 전화번호 (+로 시작)

```
LEFT(Phone, 1) <> "+"
```
**오류:** `Phone number must begin with + (country code).`

---

### Mailing 주소 필수 3항목

```
OR(
  ISBLANK(MailingStreet),
  ISBLANK(MailingCity),
  ISBLANK(MailingCountry)
)
```
**오류:** `Mailing Street, City, and Country are required.`

---

## 3. 숫자·형식 검증

### SSN 형식 999-99-9999 (REGEX)

```
NOT(OR(
  ISBLANK(Social_Security_Number__c),
  REGEX(Social_Security_Number__c, "[0-9]{3}-[0-9]{2}-[0-9]{4}")
))
```
**오류:** `SSN must be in this format: 999-99-9999.`

---

### 신용카드 번호 (REGEX)

```
NOT(REGEX(Credit_Card_Number__c, "(((\\d{4}-){3}\\d{4})|\\d{16})?"))
```
**오류:** `Credit Card Number must be in this format: 9999-9999-9999-9999 or 9999999999999999.`

---

### IP 주소 형식 (REGEX)

```
NOT(REGEX(IP_Address__c, "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"))
```
**오류:** `IP Address must be in form 999.999.999.999 where each part is between 0 and 255.`

---

### 캘리포니아 운전면허 A9999999 (REGEX)

```
AND(
  MailingState = "CA",
  NOT(REGEX(Drivers_License__c, "([A-Z]\\d{7})?"))
)
```
**오류:** `Invalid California driver's license format.`

---

### 계정 번호 숫자 여부 (ISNUMBER)

```
OR(
  ISBLANK(AccountNumber),
  NOT(ISNUMBER(AccountNumber))
)
```
**오류:** `Account Number is not numeric.`

---

### 짝수 / 홀수 검증 (MOD)

```
/* 짝수 */
OR(Ark_Passengers__c < 0, MOD(Ark_Passengers__c, 2) <> 0)

/* 홀수 */
OR(Socks_Found__c < 0, MOD(Socks_Found__c, 2) = 0)
```

### 정수 여부 (FLOOR)

```
FLOOR(My_Integer__c) <> My_Integer__c
```

### 퍼센트 범위 0~100% (소수 표현 주의)

```
OR(Mix_Pct__c > 1.0, Mix_Pct__c < 0.0)
```
> 퍼센트 필드는 수식에서 소수로 표현됨 (100% = 1.0).

---

## 4. 날짜 검증

### 평일 여부 (MOD, CASE)

```
CASE(MOD(My_Date__c - DATE(1900, 1, 7), 7), 0, 0, 6, 0, 1) = 0
```
**오류:** `Date must be a weekday.`

### 이번 달 내 날짜

```
OR(
  YEAR(My_Date__c) <> YEAR(TODAY()),
  MONTH(My_Date__c) <> MONTH(TODAY())
)
```

### 이달 말일 여부

```
DAY(My_Date__c) <> IF(
  Month(My_Date__c) = 12,
  31,
  DAY(DATE(YEAR(My_Date__c), MONTH(My_Date__c) + 1, 1) - 1)
)
```

### 종료일이 시작일보다 이른 경우

```
Begin_Date__c > End_Date__c
```
**오류:** `End Date cannot be before Begin Date.`

### 오늘로부터 1년 이내

```
Followup_Date__c - TODAY() > 365
```

---

## 5. Opportunity 검증

### Stage 기반 조건부 필수 필드

```
AND(
  OR(ISPICKVAL(StageName, "Closed Won"), ISPICKVAL(StageName, "Negotiation/Review")),
  ISBLANK(Delivery_Date__c)
)
```
**오류:** `Delivery Date is required for this stage.`

### Close Date 이번 달 이전 금지 (ISNEW, ISCHANGED)

```
AND(
  OR(ISNEW(), ISCHANGED(CloseDate)),
  CloseDate < DATE(YEAR(TODAY()), MONTH(TODAY()), 1)
)
```
**오류:** `Close Date cannot be prior to current month.`

### 고액 Opportunity 승인 필수 (50,000 초과)

```
AND(
  OR(ISPICKVAL(StageName, "Closed Won"), ISPICKVAL(StageName, "Closed Lost")),
  (Amount > 50000),
  NOT(ISPICKVAL(Approval_Status__c, "Approved"))
)
```
**오류:** `All high-value opportunities must be approved for closure.`

### Products 없이 특정 Stage 이동 금지

```
AND(
  CASE(StageName,
    "Value Proposition", 1, "Id. Decision Makers", 1, "Perception Analysis", 1,
    "Proposal/Price Quote", 1, "Negotiation/Review", 1, "Closed Won", 1, 0
  ) = 1,
  NOT(HasOpportunityLineItem)
)
```
**오류:** `Opportunity products are required to advance beyond the Needs Analysis stage.`

### Won/Lost 확률 자동 검증

```
/* Closed Won은 100% */
AND(ISPICKVAL(StageName, "Closed Won"), Probability <> 1)

/* Closed Lost는 0% */
AND(ISPICKVAL(StageName, "Closed Lost"), Probability <> 0)
```

---

## 6. 소유자 / 사용자 / 역할 검증

### 레코드 소유자만 특정 필드 변경 가능

```
AND(
  ISCHANGED(Personal_Goal__c),
  Owner <> $User.Id
)
```
**오류:** `Only record owner can change Personal Goal.`

### 소유자 또는 System Admin만 변경 가능 ($Profile)

```
AND(
  ISCHANGED(Personal_Goal__c),
  Owner <> $User.Id,
  $Profile.Name <> "Custom: System Admin"
)
```
> `$Profile` 병합 필드는 Enterprise Edition 이상에서만 사용 가능.

### 역할 기반 할인 한도 (VLOOKUP)

```
Discount_Percent__c > VLOOKUP(
  $ObjectType.Role_Limits__c.Fields.Limit__c,
  $ObjectType.Role_Limits__c.Fields.Name,
  $UserRole.Name
)
```
> `Role_Limits__c` 커스텀 오브젝트(역할명 → 한도 맵핑)가 필요.

### 사용자 커스텀 필드와 비교 ($User)

```
Expense_Amount__c > $User.Max_Allowed_Expense__c
```
**오류:** `Amount cannot exceed your maximum allowed expense.`

---

## 7. 변경 이력 기반 검증 (PRIORVALUE, ISCHANGED)

### 저장 후 변경 금지 (ISNEW, ISCHANGED)

```
AND(
  NOT(ISNEW()),
  ISCHANGED(Guaranteed_Rate__c)
)
```
**오류:** `Guaranteed Rate cannot be changed.`

### 값을 줄이는 변경 금지 (PRIORVALUE)

```
PRIORVALUE(Commit_Amount__c) > Commit_Amount__c
```
**오류:** `Commit Amount cannot be decreased.`

### Case Status를 New로 되돌리기 금지

```
AND(
  ISCHANGED(Status),
  NOT(ISPICKVAL(PRIORVALUE(Status), "New")),
  ISPICKVAL(Status, "New")
)
```
**오류:** `Open case Status cannot be reset to New.`

---

## 8. 크로스 오브젝트 검증

### Account에 Support 권한 없으면 Case 생성 금지

```
Account.Allowed_Support__c = FALSE
```
**오류:** `Unable to create cases for this account because it is not signed up for support.`

### Closed Opportunity의 Products 삭제 금지 (롤업 필드 활용)

```
AND(
  OR(ISPICKVAL(StageName, "Closed Won"), ISPICKVAL(StageName, "Closed Lost")),
  Number_of_Line_Items__c < PRIORVALUE(Number_of_Line_Items__c)
)
```

---

## 9. 기타

### 웹사이트 확장자 검증 (RIGHT)

```
AND(
  RIGHT(Web_Site__c, 4) <> ".COM",
  RIGHT(Web_Site__c, 4) <> ".com",
  RIGHT(Web_Site__c, 4) <> ".ORG",
  RIGHT(Web_Site__c, 4) <> ".org",
  RIGHT(Web_Site__c, 4) <> ".NET",
  RIGHT(Web_Site__c, 4) <> ".net",
  RIGHT(Web_Site__c, 6) <> ".CO.UK",
  RIGHT(Web_Site__c, 6) <> ".co.uk"
)
```

### 통화 코드 허용 목록 (CASE)

```
CASE(CurrencyIsoCode, "USD", 1, "EUR", 1, "GBP", 1, "JPY", 1, 0) = 0
```
**오류:** `Currency must be USD, EUR, GBP, or JPY.`

### 연간 매출 범위 ($0 ~ $100B)

```
OR(AnnualRevenue < 0, AnnualRevenue > 100000000000)
```

---

## 주요 함수 요약

| 함수 | 사용 패턴 |
|---|---|
| `REGEX(field, pattern)` | 정규식 패턴 매칭 — SSN, ZIP, 전화번호, IP 형식 검증 |
| `ISNUMBER(field)` | 숫자 여부 — 계정번호, 코드 검증 |
| `ISBLANK(field)` | 필수 입력 검증 |
| `ISCHANGED(field)` | 값 변경 감지 — 변경 금지, 조건부 검증 |
| `PRIORVALUE(field)` | 변경 전 값 참조 — 감소 금지, 되돌리기 금지 |
| `ISNEW()` | 신규 레코드 여부 |
| `ISPICKVAL(field, value)` | 픽리스트 값 비교 |
| `MOD(num, divisor)` | 나머지 — 짝수/홀수, 배수 검증 |
| `FLOOR(num)` | 정수 부분 — 정수 여부 검증 |
| `CONTAINS(text, substr)` | 포함 여부 — 주/국가 코드 목록 검증 |
| `VLOOKUP(field, lookupField, lookupValue)` | 다른 오브젝트 값 조회 — 역할별 한도, ZIP↔State |
| `$User.FieldName` | 현재 사용자 커스텀 필드 참조 |
| `$Profile.Name` | 현재 사용자 프로필 이름 (Enterprise+ 전용) |
| `$UserRole.Name` | 현재 사용자 역할 이름 |

---

## 관련 문서

- [[Governor Limits]] — 수식 필드 및 검증 규칙 한도 확인
- [[Custom Metadata Types]] — CMDT를 활용한 동적 검증 임계값 관리
- [[Schema Namespace 상세]] — `REGEX`, 수식 함수 스키마 컨텍스트
