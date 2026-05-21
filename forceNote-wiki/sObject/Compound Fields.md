---
tags: [sobject-reference, compound-fields, address, geolocation, location, distance, geolocation-function, soql]
source: object_reference.pdf p.15-20 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Compound Fields, Address Compound Field, Geolocation Compound Field, BillingAddress, MailingAddress, DISTANCE, GEOLOCATION, location, latitude, longitude, GeocodeAccuracy, __latitude__s, __longitude__s, 복합 필드, 주소 복합 필드, 지리좌표계]
---

# Compound Fields

> Primitive 필드 여러 개를 하나의 구조체로 묶는 복합 필드. Address(v30+)와 Geolocation(v26+)의 두 가지 타입.

---

## 개념

복합 필드는 복수의 Primitive 필드를 하나의 구조화된 데이터 타입으로 표현한다. 복합 필드와 개별 컴포넌트 필드는 **동일한 기저 데이터**를 가리키며 항상 같은 값을 가진다.

**공통 특성:**
- SOAP/REST API에서만 접근 가능 (Visualforce·Data Loader 불가)
- **읽기 전용** — 값 변경은 반드시 개별 컴포넌트 필드로 수행
- Address: SOAP/REST API v30.0 이상
- Geolocation: SOAP/REST API v26.0 이상

---

## Address Compound Fields

### 개요

표준 오브젝트(Account, Contact, Quote, User 등)에 내장된 표준 주소를 복합 데이터 타입 `Address`로 접근.

- `Address` 타입은 `Location` 타입을 확장
- 여러 주소 타입을 가진 오브젝트는 접두사로 구분: `BillingAddress`, `ShippingAddress`, `MailingAddress`, `OtherAddress`

### Address 구조체 서브필드

| 서브필드 | 타입 | 설명 | 예시 (Contact) |
|---|---|---|---|
| `Accuracy` | picklist | Geocode 정확도 수준. 주소 지오코딩 시에만 값 있음 | `MailingGeocodeAccuracy` |
| `City` | string | 도시 | `MailingCity` |
| `Country` | string | 국가 | `MailingCountry` |
| `CountryCode` | picklist | ISO 국가 코드. 표준 주소: State/Country picklist 활성화 시 사용 가능. 커스텀 주소: 항상 사용 가능 | `MailingCountryCode` |
| `Latitude` | double | 위도. Longitude와 함께 정밀 위치 표현 | `MailingLatitude` |
| `Longitude` | double | 경도. Latitude와 함께 정밀 위치 표현 | `MailingLongitude` |
| `PostalCode` | string | 우편번호 | `MailingPostalCode` |
| `State` | string | 주(州)/도 | `MailingState` |
| `StateCode` | picklist | ISO 주 코드. State/Country picklist 활성화 시만 사용 가능 | `MailingStateCode` |
| `Street` | textarea | 도로명 주소 | `MailingStreet` |

> [!note] GeocodeAccuracy 서브필드
> `Accuracy` 서브필드는 주소가 지오코딩 처리된 경우에만 값이 있음. 외부 지오코딩 서비스가 좌표의 정확도를 나타내는 값을 제공. `GeocodeAccuracy` 복합 필드는 표준 주소 필드에만 존재 (커스텀 지오코딩 필드 없음).

### Custom Address Fields

Custom Address Fields 기능 활성화 시 Object Manager에서 Address 타입 커스텀 필드 추가 가능.

- 표준 주소 필드 동작을 모방하되 일부 제한 있음
- `CountryCode`가 State/Country picklist 활성화 여부와 무관하게 항상 사용 가능

---

## SOQL로 복합 주소 필드 사용

### 복합 필드 직접 SELECT

```apex
// 복합 Address 필드 선택 (v30.0+)
List<Account> accounts = [
    SELECT Name, BillingAddress
    FROM Account
    WHERE BillingAddress != null
];

for (Account acc : accounts) {
    Address billing = acc.BillingAddress;
    if (billing != null) {
        System.debug('City: ' + billing.getCity());
        System.debug('State: ' + billing.getState());
    }
}
```

### 개별 컴포넌트 필드 SELECT (이전 버전 호환)

```apex
// 개별 필드 사용 (API v30.0 이전 호환)
List<Account> accounts = [
    SELECT Name, BillingStreet, BillingCity,
           BillingState, BillingPostalCode, BillingCountry,
           BillingLatitude, BillingLongitude
    FROM Account
];
```

---

## DISTANCE·GEOLOCATION 함수로 위치 기반 쿼리

복합 주소 필드에는 위도·경도가 포함되므로 SOQL WHERE·ORDER BY에서 거리 계산 가능.

```apex
// San Francisco에서 20마일 이내 Account 조회 (가까운 순)
List<Account> nearby = [
    SELECT Id, Name, BillingAddress
    FROM Account
    WHERE DISTANCE(BillingAddress, GEOLOCATION(37.775, -122.418), 'mi') < 20
    ORDER BY DISTANCE(BillingAddress, GEOLOCATION(37.775, -122.418), 'mi')
    LIMIT 10
];
```

> [!note] 자동 지오코딩
> Developer·Professional·Enterprise·Unlimited·Performance Edition에서 Account·Contact·Lead·WorkOrder 레코드에 대해 Salesforce가 자동으로 Geolocation 필드를 추가/갱신 가능 (관리자가 geo data integration rule 활성화 필요). 다른 오브젝트·에디션은 SOQL, SOAP/REST API, 또는 지오코딩 서비스로 수동 설정.

---

## Geolocation Compound Field

### 개요

커스텀 위치 필드를 `Location` 복합 타입으로 접근. API v26.0 이상.

- 서브필드: `latitude`, `longitude`
- 표준 오브젝트(Account, Contact, Quote, User)의 주소 필드에도 포함
- 커스텀 오브젝트에 커스텀 geolocation 필드로 추가 가능

### SOQL로 Geolocation 필드 사용

```apex
// 복합 필드 SELECT (v26.0+)
SELECT location__c FROM Warehouse__c

// 개별 서브필드 (v26.0 이전 호환)
SELECT location__latitude__s, location__longitude__s FROM Warehouse__c
```

### Apex에서 서브필드 접근

```apex
// 커스텀 geolocation 필드의 서브필드 읽기/쓰기
// 접근 방식: __c 대신 __latitude__s / __longitude__s 사용
Double lat = myObj.aLocation__latitude__s;
myObj.aLocation__longitude__s = 37.5665;

// 복합 필드 자체는 접근/설정 불가
// ❌ myObj.aLocation__c = someLocation;  → 불가
```

### v30.0 이전 SOAP API의 반환 형식

SOAP API v30.0 이전에서는 geolocation 복합 필드를 구조체 대신 **문자열**로 반환:

```
API location: [latitudeValue longitudeValue]
// 예: API location: [37.7749 -122.4194]

// 정규식으로 파싱:
\[([-+]?\d{1,2}([.]\d+)?) ([-+]?\d{1,3}([.]\d+)?)]
// 첫 번째 캡처 = 위도, 세 번째 캡처 = 경도
```

> [!note] 수학 계산이 필요한 경우 반환값을 숫자로 cast 필요. 표시 또는 문자열 전달 용도면 문자열 그대로 사용.

---

## Compound Field 고려 사항 및 제한사항

### 공통 제한 (Address + Geolocation)

| 제한 | 내용 |
|---|---|
| 읽기 전용 | 복합 필드 자체는 읽기 전용. 값 변경은 개별 컴포넌트 필드로 |
| API 전용 | SOAP/REST API와 Apex에서만 접근 가능. Salesforce UI에서 복합 버전 미노출 |
| Apex 수식 필드 불가 | `<apex:outputField>`에서 복합 필드 사용 불가 — 개별 컴포넌트 필드 사용 |
| Data Loader 불가 | Data Loader에서 복합 필드 export 시 오류 — 개별 컴포넌트 필드로 export |
| 이메일 템플릿 불가 | 커스텀 geolocation 및 표준 주소의 위치 필드는 이메일 템플릿 미지원 |
| 조회 필터 제한 | 복합 필드는 조회 필터에서 거리 범위 필터(within/not within)로만 사용 가능. Metadata API에서만 지원 |
| 수식 함수 제한 | 사용 가능: `ISBLANK`, `ISCHANGED`, `ISNULL`만 허용 |
| 수식 함수 불가 | `BLANKVALUE`, `CASE`, `NULLVALUE`, `PRIORVALUE`, `=`, `!=`, `<`, `>`, `<=`, `>=`, `&&`, `||` 모두 불가 |

### Address 전용 제한

| 제한 | 내용 |
|---|---|
| 표준 오브젝트 전용 | 복합 주소 필드는 Salesforce 표준 오브젝트에 내장된 주소에만 사용 가능 |
| 커스텀 추가 방법 | Custom Address Fields 기능 활성화 후 커스텀 필드 추가 |
| GeocodeAccuracy 값 | 주소 지오코딩 시에만 Accuracy 서브필드 값 있음 |
| WHERE 불가 | 주소 복합 필드는 SOQL WHERE 절 사용 불가 (단, `isFilterable()`이 잘못 true 반환하는 버그 존재) |

### Geolocation 전용 제한

| 제한 | 내용 |
|---|---|
| Custom settings 미지원 | Geolocation 필드는 custom settings에서 사용 불가 |
| 대시보드·Schema Builder 미지원 | 미지원 |
| Workflow·Approval 제한 | 수식 기반 workflow·approval에서는 사용 가능. 단, filter 기반 workflow updates·approvals에서는 불가 |
| SOQL DISTANCE 지원 | `WHERE`, `ORDER BY`에서 지원. `GROUP BY`에서 미지원. `SELECT`에서 지원 |
| DISTANCE 연산자 | `>`, `<`만 지원 (within/beyond radius) |
| GEOLOCATION 인수 순서 | geolocation 필드가 DISTANCE 함수의 **첫 번째 인수**여야 함 |
| Apex bind 변수 불가 | DISTANCE의 units 파라미터에 Apex bind 변수(`:units`) 불가 |
| Salesforce to Salesforce 미지원 | Geolocation 필드 및 표준 주소의 위도·경도 미지원 |
| 커스텀 필드 = 3개 소모 | 커스텀 geolocation 필드 1개 = 실제로 3개 커스텀 필드 (latitude, longitude, 내부용) |

```apex
// ✅ 올바른 GEOLOCATION 인수 순서
DISTANCE(warehouse_location__c, GEOLOCATION(37.775, -122.418), 'km')

// ❌ 잘못된 인수 순서 (오류)
DISTANCE(GEOLOCATION(37.775, -122.418), warehouse_location__c, 'km')

// ❌ units에 Apex bind 변수 불가
String units = 'mi';
// [SELECT ID FROM Account WHERE DISTANCE(MyLoc__c, GEOLOCATION(10,10), :units) < 10]
// → 오류

// ✅ units은 리터럴로 지정
List<Account> accs = [
    SELECT Id FROM Account
    WHERE DISTANCE(MyLoc__c, GEOLOCATION(10, 10), 'mi') < 10
];
```

---

## 관련 노트

- [[1 Overview]] — Ch1 전체 요약
- [[Field Types]] — address·location 타입 정의
- [[External Objects]] — 외부 오브젝트의 geolocation 필드 지원
- [[SOQL 문법 레퍼런스]] — DISTANCE·GEOLOCATION 함수 레퍼런스
