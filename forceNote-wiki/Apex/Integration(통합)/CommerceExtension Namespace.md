---
tags: [apex, namespace, commerceextension, b2b-commerce, d2c-commerce, resolution-strategy, extension-point]
source: salesforce_apex_reference_guide.pdf p.307-315
created: 2026-05-20
aliases: [CommerceExtension, ResolutionStrategy, Resolution, ResolutionStates, ExtensionInfo, CommerceExtension.ResolutionStrategy, B2B Commerce Extension Point, 커머스 확장 포인트 Apex]
---

# CommerceExtension Namespace

> B2B/D2C Commerce 확장 포인트 해결 전략 — `ResolutionStrategy`를 구현해 각 확장 호출마다 기본 도메인 로직·등록된 확장 제공자·비실행 중 하나를 동적으로 선택한다.

---

## 구성 요소 요약

| 클래스 / 인터페이스 / Enum | 역할 |
|---|---|
| `CommerceExtension.ExtensionInfo` | 확장 컨텍스트 정보 조회 (static 메서드) |
| `CommerceExtension.Resolution` | 해결 전략 결과 객체 |
| `CommerceExtension.ResolutionException` | 해결 전략 실행 중 예외 |
| `CommerceExtension.ResolutionStates` | 해결 상태 열거형 (EXECUTE_DEFAULT / EXECUTE_REGISTERED / OFF) |
| `CommerceExtension.ResolutionStrategy` | 해결 전략 인터페이스 (구현 필요) |

---

## CommerceExtension.ExtensionInfo Class (Static)

확장 컨텍스트 정보를 노출하는 static 메서드 모음.

```apex
public static Double  getClientApiVersion()                         // Client API 버전 번호
public static String  getCustomParameterField(String fieldName)     // 커스텀 파라미터 필드 값
public static String  getLocaleString()                             // 확장 컨텍스트 로케일
public static Boolean isCustomParametersAvailable()                 // 커스텀 파라미터 사용 가능 여부
```

---

## CommerceExtension.ResolutionStates Enum

해결 전략이 반환하는 실행 상태.

| 값 | 설명 |
|---|---|
| `EXECUTE_DEFAULT` | 기본 도메인 로직 실행 (확장 제공자 로직 미실행) |
| `EXECUTE_REGISTERED` | 엔드포인트에 등록된 확장 제공자 로직 실행 |
| `OFF` | 기본 로직 및 확장 제공자 로직 모두 미실행 |

---

## CommerceExtension.Resolution Class

해결 전략의 결과를 나타내는 객체. `resolve()` 메서드의 반환 타입.

### 생성자

```apex
public Resolution(CommerceExtension.ResolutionStates resolutionState)
// resolutionState: EXECUTE_DEFAULT / EXECUTE_REGISTERED / OFF

public Resolution(String providerName)
// providerName: 실행할 확장 제공자의 developer name

public Resolution()
// 기본 생성자 — EXECUTE_DEFAULT 동작
```

### 메서드

```apex
public String                          getProviderName()      // 확장 제공자 이름
public CommerceExtension.ResolutionStates getResolutionState() // 해결 상태
```

---

## CommerceExtension.ResolutionException Class

해결 전략 실행 중 문제가 발생했을 때 사용하는 예외.

### 생성자

```apex
public ResolutionException(String errorMessage, Exception exception)
public ResolutionException(Exception exception)
public ResolutionException(String errorMessage)
public ResolutionException()
```

### 메서드

```apex
public String getTypeName()  // 예외 타입 이름 반환
```

---

## CommerceExtension.ResolutionStrategy Interface

확장 포인트에 등록 가능한 해결 전략 인터페이스. 이 인터페이스를 구현하는 클래스를 확장 제공자 클래스처럼 등록할 수 있다.

```apex
public CommerceExtension.Resolution resolve()
// 반환: Resolution 객체 — 기본 로직·등록 확장 제공자·OFF 중 하나를 나타냄
```

---

## 전체 구현 예제 — 로케일별 Tax 서비스 확장 해결자

```apex
// TaxService를 상속하고 ResolutionStrategy를 구현한 Extension Resolver
// 로케일에 따라 EXECUTE_DEFAULT / EXECUTE_REGISTERED / OFF 중 하나를 반환
public class TaxServiceExtensionResolverSample
        extends commercestoretax.TaxService
        implements CommerceExtension.ResolutionStrategy {

    public CommerceExtension.Resolution resolve() {

        // en_US → 'tax_extension_provider_for_us' 확장 제공자 실행
        if (CommerceExtension.ExtensionInfo.getLocaleString() == 'en_US') {
            return new CommerceExtension.Resolution('tax_extension_provider_for_us');
        }

        // en_CA → 'tax_extension_provider_for_canada' 확장 제공자 실행
        if (CommerceExtension.ExtensionInfo.getLocaleString() == 'en_CA') {
            return new CommerceExtension.Resolution('tax_extension_provider_for_canada');
        }

        // de → 기본 Salesforce Internal Tax API가 빈 응답 반환 (OFF)
        if (CommerceExtension.ExtensionInfo.getLocaleString() == 'de') {
            return new CommerceExtension.Resolution(CommerceExtension.ResolutionStates.OFF);
        }

        // 그 외 로케일 → 기본 Salesforce Internal Tax API 실행
        return new CommerceExtension.Resolution();
    }
}
```

**등록 절차:**
1. 확장 제공자(Extension Provider) Apex 클래스 작성 → tax 확장 포인트에 등록
2. 해결자(Resolver) 클래스 작성 → 확장 포인트에 등록 후 Web Store에 매핑

---

## 관련 노트

- [[Apex MOC]]
- [[CommerceBuyGrp Namespace]] — Buyer Group 배정 커스텀 로직
