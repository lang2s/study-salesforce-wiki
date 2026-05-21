---
tags: [sobject-reference, field-types, primitive-types, compound-fields, external-objects, big-objects, api-properties]
source: object_reference.pdf p.1-39 (v67.0 Summer '26)
created: 2026-05-22
aliases: [1 Overview, sObject 개요, 필드 타입 레퍼런스, Primitive Data Types, Compound Fields, Big Objects, External Objects]
---

# 1 Overview — Salesforce Objects and Fields

> Salesforce 데이터 모델의 핵심: Primitive 타입, Field 타입, API 속성, Compound Fields, External·Big Object 개요

---

## Primitive Data Types → [[Primitive Data Types]]

SOAP 메시지에서 사용하는 기본 데이터 타입이다.

| 타입 | 설명 |
|---|---|
| `base64` | Base 64 인코딩 바이너리 — Attachment·Document Body 필드에 사용 |
| `boolean` | `true`/`1` 또는 `false`/`0` |
| `byte` | 비트셋 |
| `date` | 날짜 값 (시간 미포함). 필터 시 date 필드만 필터 가능 |
| `dateTime` | 타임스탬프 (1초 정밀도). UTC 기준 전송. 필터 시 dateTime 필드만 필터 가능 |
| `double` | 소수 포함 수치 (Currency·Percent). `scale`(소수점 우측 자리수) / `precision`(전체 자리수) |
| `int` | 정수 (소수 없음). `digits`로 최대 자리수 지정 |
| `long` | 큰 정수. 범위: -9223372036854775808 ~ 9223372036854775807 |
| `string` | 문자열. API v15.0+: 초과 시 `STRING_TOO_LONG` 오류 (`AllowFieldTruncationHeader`로 이전 동작 복원 가능) |
| `time` | 시간 값 (1ms 정밀도). BusinessHours.FridayEndTime 등 |

---

## Field Types → [[Field Types]]

API가 정의하는 필드 타입 (WSDL에 정의됨).

| 필드 타입 | 설명 |
|---|---|
| `address` | 주소 복합 필드 (Address 구조체) |
| `anyType` | 다형 타입 — string·picklist·reference·boolean·currency·int·double·percent·ID·date·datetime·url·email 반환 가능 |
| `calculated` | 수식(formula) 필드 |
| `combobox` | 열거형 값 목록 + 사용자 정의 값 입력 가능 |
| `currency` | 통화 값 |
| `DataCategoryGroupReference` | Knowledge/Answers 데이터 카테고리 그룹·카테고리 참조 |
| `email` | 이메일 주소 |
| `encryptedstring` | 암호화된 텍스트 (최대 175자). API v11.0+ |
| `ID` | 객체 기본키 (18자 case-safe). 3자 접두사로 object type 식별 |
| `JunctionIdList` | 다대다 관계 junction ID 배열 (string[]). null 설정 시 관련 junction 레코드 모두 삭제 |
| `location` | Geolocation 복합 필드 (latitude·longitude) |
| `masterrecord` | 병합 시 유지되는 레코드 ID |
| `multipicklist` | 다중 선택 picklist |
| `percent` | 백분율 |
| `phone` | 전화번호 (알파벳 포함 가능, 형식은 클라이언트 책임) |
| `picklist` | 단일 선택 picklist |
| `reference` | 다른 Object 참조 (외래키). 필드명 접미사 `Id`. update() 가능 |
| `textarea` | 멀티라인 문자열 |
| `url` | URL |

### ID 필드 특징

```
15자 ID: case-sensitive (case-insensitive 앱에서 혼동 위험)
18자 ID: case-safe (API 호출 시 항상 18자 사용 권장)
           마지막 3자 = 앞 15자의 대소문자 인코딩
```

---

## API Field Properties → [[API Field Properties]]

필드 describe 결과에 나타나는 속성.

| 속성 | 의미 |
|---|---|
| `Aggregatable` | GROUP BY·집계 함수 사용 가능 |
| `Autonumber` | 자동 증가 번호 |
| `Create` | insert 시 값 지정 가능 |
| `Defaulted on create` | 생성 시 기본값 자동 설정 |
| `Filter` | WHERE 절 사용 가능 |
| `Group` | GROUP BY 사용 가능 |
| `idLookup` | 이 필드로 SOQL WHERE 조회 가능 (`Name`, `Email` 등) |
| `Namepointing` | 이 reference 필드가 polymorphic (여러 Object 가리킴) |
| `Nillable` | null 허용 |
| `Restricted picklist` | API에서 지정된 값만 허용 |
| `Sort` | ORDER BY 사용 가능 |
| `Update` | update() 호출로 값 변경 가능 |

---

## System Fields → [[System Fields]]

대부분의 Object에 자동으로 있는 시스템 필드.

| 필드 | 타입 | 설명 |
|---|---|---|
| `Id` | ID | 18자 레코드 고유 ID |
| `CreatedById` | reference | 생성한 User ID |
| `CreatedDate` | dateTime | 생성 일시 (UTC) |
| `LastModifiedById` | reference | 마지막 수정 User ID |
| `LastModifiedDate` | dateTime | 마지막 수정 일시 |
| `SystemModstamp` | dateTime | 트리거·자동화 포함 마지막 변경 일시 |
| `IsDeleted` | boolean | 휴지통 이동 여부 |

**Audit Fields** (감사 필드) 유효 범위: `1970-01-01T00:00:00Z` ~ `4000-12-31T00:00:00Z`

감사 필드를 직접 설정하려면 권한 `Set Audit Fields upon Record Creation` 필요.

---

## Frequently Occurring Fields → [[System Fields]]

| 필드 | 설명 |
|---|---|
| `OwnerId` | 레코드 소유자 User ID. 생성 시 현재 사용자로 자동 설정. 변경 시 공유 정보 재계산. 변경 권한: `Transfer Record` + 신규 소유자 Read 권한 필요 |
| `RecordTypeId` | 레코드 타입 ID. 비즈니스 프로세스·픽리스트 값 제어 |
| `CurrencyIsoCode` | 다중통화 활성화 조직에서 레코드 통화 ISO 코드 |

---

## Compound Fields → [[Compound Fields]]

복합 필드는 여러 primitive 필드를 하나의 구조체로 묶는다.

### Address Compound Field

API v30.0+, SOAP/REST API에서만 접근 가능.

```apex
// SOQL - 복합 Address 필드 사용
SELECT Name, BillingAddress FROM Account

// 개별 필드 사용 (API v30.0 이전 호환)
SELECT Name, BillingStreet, BillingCity, BillingState,
       BillingPostalCode, BillingCountry
FROM Account

// 거리 기반 쿼리 (GEOLOCATION 함수)
SELECT Id, Name, BillingAddress
FROM Account
WHERE DISTANCE(BillingAddress, GEOLOCATION(37.775,-122.418), 'mi') < 20
ORDER BY DISTANCE(BillingAddress, GEOLOCATION(37.775,-122.418), 'mi')
LIMIT 10
```

Address 구조체 서브필드:

| 필드 | 타입 | 비고 |
|---|---|---|
| `Accuracy` | picklist | Geocode 정밀도 |
| `City` | string | |
| `Country` | string | |
| `CountryCode` | picklist | State/Country picklist 활성화 시 가능 |
| `Latitude` | double | |
| `Longitude` | double | |
| `PostalCode` | string | |
| `State` | string | |
| `StateCode` | picklist | State/Country picklist 활성화 시 가능 |
| `Street` | textarea | |

### Geolocation Compound Field

API v26.0+. `latitude`, `longitude` 서브필드.

```apex
// 복합 필드 SELECT
SELECT location__c FROM Warehouse__c

// 개별 서브필드 (v26.0 이전 호환)
SELECT location__latitude__s, location__longitude__s FROM Warehouse__c

// Apex에서 서브필드 접근
Double lat = myObj.aLocation__latitude__s;
myObj.aLocation__longitude__s = theLon;
```

### Compound Field 제한 사항

- **읽기 전용**: 값 변경은 반드시 개별 컴포넌트 필드로
- SOAP/REST API에서만 접근 (Visualforce·Data Loader 불가)
- WHERE 절 사용 불가 (Address는 필터 불가)
- DISTANCE/GEOLOCATION은 WHERE·ORDER BY 지원, GROUP BY 미지원
- 사용 가능 수식 함수: `ISBLANK`, `ISCHANGED`, `ISNULL`만 허용
- 커스텀 Geolocation 필드는 실제로 3개 커스텀 필드 소모 (latitude·longitude·내부용)

---

## Custom Objects → [[Custom Objects]] · [[Custom Fields]] · [[Object Relationships]]

| 항목 | 규칙 |
|---|---|
| API Name 접미사 | `__c` (예: `Issue__c`) |
| 관계 필드 | 부모 참조: `__r`, ID 필드: `__c` |
| SOQL | `SELECT Id FROM Issue__c WHERE Parent__r.Name = 'X'` |
| 공유 | Standard Object와 동일 (cascade delete 지원) |

---

## External Objects → [[External Objects]]

Salesforce 외부에 저장된 데이터를 OData 어댑터 등으로 매핑. API Name 접미사 `__x`.

```apex
// 외부 Object SOQL
List<Product__x> externalProducts = [
    SELECT ExternalId, Name__c, Price__c
    FROM Product__x
    LIMIT 100
];
```

---

## Big Objects → [[Big Objects]]

대용량 데이터(수억 건) 장기 보관용. 별도 라이센스 필요.

| 항목 | 내용 |
|---|---|
| API Name 접미사 | `__b` |
| 트랜잭션 타입 | OLTP (non-transactional 분산 DB) |
| 지원 작업 | Insert·Query (Delete·Update 없음) |
| 배포 | `deploy()`/`retrieve()` (.zip). AppExchange 패키지 불가 |
| 예시 | `FieldHistoryArchive` |

```apex
// Big Object Insert (비동기)
List<MyBigObject__b> records = new List<MyBigObject__b>();
MyBigObject__b rec = new MyBigObject__b();
rec.IndexField__c = 'value';
records.add(rec);
Database.insertImmediate(records); // 동기 insert
```

---

## Object Interfaces

특정 기능(가격조정, 판매 트랜잭션)을 구현하는 Object 인터페이스. API v55.0+.

자세한 내용: [[5 Object Interfaces]]

---

## 관련 노트

**Ch1 세부 페이지**
- [[Primitive Data Types]] — SOAP 기본 타입 10개 전수
- [[Field Types]] — API 필드 타입 20개+ 전수
- [[API Field Properties]] — 필드 속성 15개 전수
- [[System Fields]] — 시스템 필드·감사 필드·공통 필드
- [[Compound Fields]] — Address·Geolocation 복합 필드 상세
- [[Custom Objects]] — __c 오브젝트 규칙·공유·태그
- [[Custom Fields]] — External ID·Uniqueness·기본값
- [[Object Relationships]] — Master-Detail·Lookup·Many-to-many
- [[External Objects]] — Salesforce Connect 어댑터 전수
- [[Big Objects]] — Metadata XML 전수·배포 절차

**연관 챕터**
- [[2 Object Behavior]] — Object 그룹·타입·치트시트
- [[3 Associated Objects]] — Feed·History·Share 패턴
- [[4 Custom Objects]] — 커스텀 Object 공통 필드·CMDT 패턴
- [[SOQL 문법 레퍼런스]] — 복합 필드 SOQL 쿼리
- [[SOQL WITH DATA CATEGORY]] — DataCategoryGroupReference 활용
