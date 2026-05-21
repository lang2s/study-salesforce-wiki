---
tags: [sobject-reference, primitive-types, field-types, soap, api]
source: object_reference.pdf p.1-3 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Primitive Data Types, SOAP 데이터 타입, base64, boolean, date, dateTime, double, int, long, string, time]
---

# Primitive Data Types

> SOAP 메시지 교환에서 사용하는 10개 기본 데이터 타입. W3C XML Schema Part 2 기반이며, `DescribeSObjectResult.fields[].soapType`으로 확인.

---

## 개념

Salesforce API는 SOAP 메시지로 데이터를 교환한다. 이때 사용하는 기본 단위가 Primitive Data Type이다. 클라이언트 애플리케이션은 각 언어의 타입 규칙을 따르고, 개발 도구가 SOAP 데이터 타입 매핑을 처리한다.

Primitive 타입은 세 가지 목적으로 사용된다:
1. SOAP 메시지의 기본 데이터 타입 정의 (W3C XML Schema Part 2)
2. `DescribeSObjectResult`의 `fields[].soapType` 열거
3. Salesforce 고유 방식으로 해석 — 예: `double`을 `currency` 필드로 받으면 통화 기호를 붙이고, `percent` 필드로 받으면 `%` 기호를 붙임

---

## Primitive 타입 전수

### base64

Base 64 인코딩 바이너리 데이터.

- **사용 위치:** `Attachment.Body`, `Document.Body`, `Scontrol.Body`
- `BodyLength` 필드가 `Body`/`Binary` 필드의 데이터 길이를 정의
- `Document` 오브젝트에서는 파일을 직접 저장하는 대신 URL을 지정하는 방식도 지원

```apex
// Attachment 생성 시 body를 base64로 인코딩
Blob fileContent = Blob.valueOf('Hello World');
Attachment att = new Attachment(
    ParentId  = someRecordId,
    Name      = 'hello.txt',
    Body      = fileContent,       // Blob → base64로 SOAP 직렬화
    BodyLength = fileContent.size()
);
insert att;
```

---

### boolean

`true` 또는 `false` 값을 갖는 필드.

- SOAP 메시지에서 `true`/`1` 또는 `false`/`0`/미지정으로 전송
- Checkbox 필드에 매핑

```apex
Account acc = [SELECT Id, IsPartner FROM Account LIMIT 1];
System.debug(acc.IsPartner); // true 또는 false
```

---

### byte

비트셋(bit set). API 내부 목적으로 사용되며, 클라이언트에서 직접 사용하는 경우는 드물다.

---

### date

시간 정보가 없는 날짜 값.

- **대표 예:** `Event.ActivityDate`, `Contact.Birthdate`
- 시간 부분은 항상 UTC 자정(midnight)으로 설정 — 의미 없음
- SOQL 필터 시: **date 필드는 date 필드끼리만** 비교 가능, dateTime 필드와 혼용 불가

```apex
// SOQL date 필터 — date literal 사용
List<Event> events = [
    SELECT Id, ActivityDate
    FROM Event
    WHERE ActivityDate = TODAY
];

// Apex에서 date 값 생성
Date today = Date.today();
Date specific = Date.newInstance(2026, 12, 31);
```

---

### dateTime

1초 정밀도의 타임스탬프.

- **대표 예:** `Event.ActivityDateTime`, `Account.CreatedDate`, `Account.LastModifiedDate`, `Account.SystemModstamp`
- 항상 UTC로 전송/저장. 클라이언트에서 로컬 타임존 변환 필요
- 개발 도구에 따라 로컬 시간 또는 UTC만 표시할 수 있으므로 도구 문서 확인 필요
- SOQL 필터 시: **dateTime 필드는 dateTime 필드끼리만** 비교 가능

> [!note] DurationInMinutes 주의
> `Event.DurationInMinutes`는 시간 관련 값이지만 타입은 `int` — `dateTime`이 아님.

```apex
// SOQL dateTime 필터 — ISO 8601 또는 날짜 리터럴
List<Account> accs = [
    SELECT Id, Name, CreatedDate
    FROM Account
    WHERE CreatedDate >= LAST_MONTH
];

// Apex에서 dateTime 값 생성
DateTime now = DateTime.now();
DateTime specific = DateTime.newInstance(2026, 12, 31, 23, 59, 59);

// UTC 기준 출력
String utcStr = now.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
```

---

### double

소수점을 포함하는 부동소수점 숫자.

- **대표 예:** `CurrencyType.ConversionRate`
- API에서 `Currency` 타입·`Percent` 타입 필드는 모두 내부적으로 `double`로 저장/전송

**두 가지 정밀도 속성:**

| 속성 | 의미 |
|---|---|
| `scale` | 소수점 우측 최대 자릿수 |
| `precision` | 전체 최대 자릿수 (좌측 + 우측 포함) |
| 소수점 좌측 최대 자릿수 | `precision - scale` |

> [!note] UI vs API의 precision 차이
> - UI에서 precision = 소수점 **좌측**의 최대 자릿수로 표시
> - API에서 precision = **전체** 자릿수 (좌측 + 우측)
> - API로 precision 설정 시 반올림 없음 (UI 방식과 다름)

- 충분히 크거나 작은 값은 과학적 표기법(`1.23E+10` 형태)으로 저장 가능

```apex
// 소수점 처리 예
Double revenue = 1234567.89;
// precision=12, scale=2 → 소수점 좌측 최대 12-2=10자리, 우측 최대 2자리
Account acc = new Account(
    Name          = 'Test',
    AnnualRevenue = revenue
);
```

---

### int

소수점 없는 32비트 정수.

- **대표 예:** `Account.NumberOfEmployees`
- `digits` 속성: 최대 자릿수 지정

```apex
Account acc = [SELECT Id, NumberOfEmployees FROM Account LIMIT 1];
Integer empCount = acc.NumberOfEmployees; // int → Apex Integer
```

---

### long

소수점 없는 64비트 정수.

- 범위: **-9,223,372,036,854,775,808 ~ 9,223,372,036,854,775,807**
- `int`보다 훨씬 넓은 범위가 필요할 때 사용
- `digits` 속성: 최대 자릿수 지정

```apex
// Apex에서는 Long 타입 사용
Long bigNum = 9223372036854775807L;
```

---

### string

유니코드 문자열.

- 필드마다 길이 제한이 다름:
  - `Contact.FirstName` = 40자
  - `Contact.LastName` = 80자
  - `Contact.MailingStreet` = 255자
  - 커스텀 텍스트 필드 = 최대 255자 (Long Text = 최대 131,072자)

**API v15.0+ 길이 초과 처리 변경:**

| API 버전 | 초과 시 동작 |
|---|---|
| v14.0 이하 | 자동 truncation (잘라서 저장) |
| v15.0 이상 | `STRING_TOO_LONG` fault code로 실패 |

- `AllowFieldTruncationHeader`로 이전 동작(truncation)으로 복원 가능

**`STRING_TOO_LONG` 영향 필드:** `anyType`, `email`, `encryptedstring`, `multipicklist`, `phone`, `picklist`, `string`, `textarea`

```apex
// Apex에서 문자열 길이 확인
String name = 'A very long name that might exceed limits...';
if (name.length() > 40) {
    name = name.left(40); // 수동 truncation
}
Contact con = new Contact(FirstName = name);
```

---

### time

1밀리초 정밀도의 시간 값.

- **대표 예:** `BusinessHours.FridayEndTime`, `BusinessHours.MondayStartTime`
- 24시간 형식: `HH:mm:ss.SSS`
- 개발 도구에 따라 로컬 시간 또는 UTC만 표시할 수 있으므로 도구 문서 확인 필요

```apex
// BusinessHours에서 time 필드 조회
BusinessHours bh = [
    SELECT Id, MondayStartTime, FridayEndTime
    FROM BusinessHours
    WHERE IsDefault = true
    LIMIT 1
];
Time startTime = bh.MondayStartTime;
System.debug('Monday starts at: ' + startTime); // e.g. 09:00:00.000Z
```

---

## Primitive 타입 요약표

| 타입 | Apex 타입 | 설명 | 주요 예시 |
|---|---|---|---|
| `base64` | `Blob` | Base 64 인코딩 바이너리 | Attachment.Body |
| `boolean` | `Boolean` | true / false | IsPartner |
| `byte` | — | 비트셋 (내부용) | — |
| `date` | `Date` | 날짜 (시간 없음, UTC 자정) | ActivityDate |
| `dateTime` | `DateTime` | 타임스탬프 (1초 정밀도, UTC) | CreatedDate |
| `double` | `Double` | 부동소수점 (Currency·Percent 포함) | ConversionRate |
| `int` | `Integer` | 32비트 정수 | NumberOfEmployees |
| `long` | `Long` | 64비트 정수 (범위 더 큼) | — |
| `string` | `String` | 유니코드 문자열 | Name, Email |
| `time` | `Time` | 시간 (1ms 정밀도) | BusinessHours.FridayEndTime |

---

## 관련 노트

- [[1 Overview]] — Ch1 전체 요약
- [[Field Types]] — Primitive 타입을 확장한 필드 타입 (address·ID·JunctionIdList 등)
- [[API Field Properties]] — 필드 속성 (Aggregatable·Filter·Sort 등)
- [[System Fields]] — 시스템 필드 (CreatedDate·LastModifiedDate·SystemModstamp 등)
- [[SOQL 문법 레퍼런스]] — date·dateTime 필터 리터럴 전수
