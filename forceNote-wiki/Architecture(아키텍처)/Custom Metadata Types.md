---
tags: [architecture, custom-metadata, cmdt, metadata, deployment, configuration, cache]
aliases: [CMDT, Custom Metadata, __mdt, CustomMetadata, 커스텀 메타데이터]
source: salesforce_apex_reference_guide.pdf (v67.0)
created: 2026-05-22
updated: 2026-05-22
---

# Custom Metadata Types

> **Custom Metadata Types (CMDT)** — 설정 데이터를 메타데이터로 저장하는 Salesforce 기능.  
> 배포·패키징·버전 관리가 가능하며, Apex·Flow·수식·검증 규칙에서 **캐시**를 통해 SOQL 없이 접근 가능.

**상위:** [[Architecture MOC]] → [[00 Home]]

---

## 1. CMDT vs Custom Settings vs Custom Objects

| 항목 | CMDT (`__mdt`) | Custom Settings (`__c`) | Custom Object (`__c`) |
|---|---|---|---|
| **API 이름 접미사** | `__mdt` | `__c` (설정 타입) | `__c` |
| **레코드 접근** | 앱 캐시 → SOQL 불필요 | 앱 캐시 → SOQL 불필요 | 항상 SOQL |
| **배포 포함** | ✅ (change set, 패키지) | ✅ | ❌ (데이터는 별도) |
| **패키징 가능** | ✅ (관리 패키지 포함) | 제한적 | ❌ |
| **수식/검증 규칙** | ✅ | ✅ | ❌ |
| **Flow 사용** | ✅ | ✅ | SOQL 필요 |
| **사용자·프로필 계층** | ❌ | ✅ (Hierarchy 설정) | ❌ |
| **대용량 레코드** | 제한 (수백 건) | 제한 (수백 건) | 무제한 |
| **비밀 저장** | ❌ (Public CMDT는 Guest 포함 모두 읽기 가능) | ❌ | 암호화 필드 사용 |

> ⚠️ **Protected CMDT**: 관리 패키지 바깥에서는 Public과 동일하게 동작한다.  
> 비밀(OAuth 토큰, 비밀번호 등)은 **Named Credentials** 또는 **암호화 커스텀 필드**에 저장할 것.

---

## 2. API 이름 규칙

| 요소 | 패턴 | 예시 |
|---|---|---|
| **타입 이름** | `TypeName__mdt` | `RateCard__mdt` |
| **레코드 fullName** | `TypeName.RecordName` | `RateCard.Standard` |
| **네임스페이스 포함** | `Namespace__TypeName.Namespace__RecordName` | `MyNS__RateCard.MyNS__Standard` |
| **커스텀 필드** | `FieldName__c` | `Discount__c` |
| **SOQL** | `SELECT ... FROM TypeName__mdt` | `SELECT Rate__c FROM RateCard__mdt` |

---

## 3. Apex에서 읽기 — Static Methods (캐시)

Custom Metadata Type 클래스 자체에 정적 메서드가 내장되어 있다. 모두 앱 캐시를 사용해 SOQL 없이 작동한다.

> ⚠️ 255자 초과 필드는 잘린다. 전체 값이 필요하면 SOQL 쿼리를 사용.

### 메서드 목록

| 메서드 | 서명 | 반환 |
|---|---|---|
| `getAll()` | `TypeName__mdt.getAll()` | `Map<String, TypeName__mdt>` |
| `getInstance(recordId)` | `TypeName__mdt.getInstance(String recordId)` | `TypeName__mdt` (없으면 `null`) |
| `getInstance(developerName)` | `TypeName__mdt.getInstance(String developerName)` | `TypeName__mdt` (없으면 `null`) |
| `getInstance(qualifiedApiName)` | `TypeName__mdt.getInstance(String qualifiedApiName)` | `TypeName__mdt` (없으면 `null`) |

### 예시

```apex
// 전체 맵 조회
Map<String, RateCard__mdt> allRates = RateCard__mdt.getAll();

// 값 순회
List<RateCard__mdt> rates = RateCard__mdt.getAll().values();
if (!rates.isEmpty() && rates[0].Discount__c == 10) {
    // ...
}

// developerName으로 단건 조회
RateCard__mdt standard = RateCard__mdt.getInstance('Standard');

// recordId로 조회
RateCard__mdt byId = RateCard__mdt.getInstance('m00000000000001');

// 네임스페이스 포함 qualifiedApiName으로 조회
RateCard__mdt ns = RateCard__mdt.getInstance('MyNS__Standard');
```

### SOQL 조회 (255자 초과 필드 필요 시)

```apex
List<RateCard__mdt> rates = [
    SELECT DeveloperName, MasterLabel, Discount__c, LongDescription__c
    FROM RateCard__mdt
    WHERE IsActive__c = true
    ORDER BY DeveloperName
];
```

---

## 4. Apex에서 쓰기 — Metadata.Operations (배포)

CMDT 레코드는 **DML로 생성·수정 불가** — 반드시 `Metadata.Operations.enqueueDeployment()`를 통해 비동기 배포로 처리한다.

### 4-1. Metadata.CustomMetadata 클래스 (레코드 표현)

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `fullName` | `String` | `'TypeName.RecordName'` 형식. inherited from `Metadata.Metadata` |
| `label` | `String` | 레코드 레이블 |
| `description` | `String` | 레코드 설명 |
| `protected_x` | `Boolean` | Protected 컴포넌트 여부 |
| `values` | `List<Metadata.CustomMetadataValue>` | 커스텀 필드 값 목록 |

### 4-2. Metadata.CustomMetadataValue 클래스 (필드 값)

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `field` | `String` | 필드 API 이름 (예: `Discount__c`) |
| `value` | `Object` | 값 (Boolean, Date, DateTime, Decimal, Double, Integer, Long, String 지원) |

> 관계 필드: ID 대신 **qualified API name** 사용.

### 4-3. DeployCallback 구현

```apex
public class MyCmdtCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            // 배포 성공 처리
        } else {
            // 실패 처리: result.details.componentFailures 확인
        }
    }
}
```

### 4-4. 전체 배포 흐름 예시

```apex
// 1. 레코드 객체 구성
Metadata.CustomMetadata cmdt = new Metadata.CustomMetadata();
cmdt.fullName = 'RateCard__mdt.Premium';
cmdt.label = 'Premium Rate';

Metadata.CustomMetadataValue discountField = new Metadata.CustomMetadataValue();
discountField.field = 'Discount__c';
discountField.value = 15;
cmdt.values.add(discountField);

// 2. 컨테이너에 담기
Metadata.DeployContainer container = new Metadata.DeployContainer();
container.addMetadata(cmdt);

// 3. 콜백 + 비동기 배포
MyCmdtCallback callback = new MyCmdtCallback();
Metadata.Operations.enqueueDeployment(container, callback);
```

### 4-5. Metadata.DeployContainer 메서드

| 메서드 | 반환 | 설명 |
|---|---|---|
| `addMetadata(md)` | `void` | 컨테이너에 컴포넌트 추가 |
| `getMetadata()` | `List<Metadata.Metadata>` | 컨테이너 내 컴포넌트 목록 |
| `removeMetadata(md)` | `Boolean` | 컴포넌트 제거 (성공 시 true) |
| `removeMetadataByFullName(fullName)` | `Boolean` | fullName으로 제거 |

---

## 5. 테스트에서 CMDT 모킹

`getAll()` / `getInstance()`는 캐시를 사용하므로 테스트에서 **실제 레코드 없이 Mocking**이 필요하다.

```apex
// 방법 1: SOQL을 사용해 쿼리한 뒤 Test.setFixedSearchResults() 대신
//          직접 SOQL 쿼리로 테스트 레코드를 주입하는 패턴
//          (단, Test 클래스에서 직접 sObject 초기화 가능)

// 방법 2: Service Layer / Selector 패턴으로 CMDT 접근을 추상화
public interface IRateCardSelector {
    List<RateCard__mdt> getAll();
}

public class RateCardSelector implements IRateCardSelector {
    public List<RateCard__mdt> getAll() {
        return RateCard__mdt.getAll().values();
    }
}

// 테스트에서 Mock 구현 주입
```

> **권장:** CMDT 조회 로직을 Selector/Repository 레이어로 분리하면 테스트에서 Mock 구현체를 주입하기 쉽다.

---

## 6. 사용 사례

| 사용 사례 | 설명 |
|---|---|
| **기능 플래그 (Feature Flag)** | `FeatureFlag__mdt.EnableNewUI__c = true/false` |
| **요율표 (Rate Card)** | 국가별·등급별 할인율, 세율 등 |
| **매핑 테이블** | 외부 시스템 코드 ↔ Salesforce 값 매핑 |
| **이메일 템플릿 ID** | 환경별 템플릿 ID를 코드 외부에 관리 |
| **검증 규칙 설정** | 조직 설정에 따라 ON/OFF |
| **관리 패키지 설정** | 구독자 org에 배포 가능한 앱 설정값 |

---

## 관련 문서

- [[Governor Limits 빠른 참조]] — CMDT 한도 확인
- [[Schema Namespace 상세]] — SObject 타입 describe (CMDT도 SObject임)
- [[Database Namespace 상세]] — DML과 CMDT 비교 (CMDT는 DML 불가)
