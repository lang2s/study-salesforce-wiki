---
tags: [apex, industriesdigitallending, namespace, financial-services-cloud, digital-lending, omniscript, stub, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — IndustriesDigitalLending Namespace (doc p.2928)
created: 2026-05-20
aliases: [IndustriesDigitalLending Namespace, DigitalLendingIntakeRecordsWrapper, DigitalLendingPostIntakeRecordsWrapper, DigitalLendingProductsApi, DigitalLendingUtils, PricingExecutionWrapper, FSC Digital Lending Apex, 디지털 대출 Apex, 디지털 렌딩 OmniScript]
---

# IndustriesDigitalLending Namespace

> Financial Services Cloud Digital Lending OmniScript 및 Integration Procedure에서 사용하는 callable Apex 클래스를 제공하는 네임스페이스.

> [!warning] 이 노트는 Apex Reference Guide v67.0 클래스 인벤토리만 수록한 스텁입니다. 메서드 상세는 `industriesDigitalLending` 네임스페이스 공식 문서를 참조하세요.

---

## 클래스 목록

| 클래스 | 사용 위치 | 설명 |
|---|---|---|
| `DigitalLendingIntakeRecordsWrapper` | OmniScript (인테이크 프로세스) | Digital Lending 애플리케이션 인테이크 프로세스 유틸리티 메서드 |
| `DigitalLendingPostIntakeRecordsWrapper` | Integration Procedure (인테이크 후) | Digital Lending 인테이크 후 FlexCards 유틸리티 메서드 |
| `DigitalLendingProductsApi` | Integration Procedure (FlexCards) | Digital Lending FlexCards 제품 API 유틸리티 |
| `DigitalLendingUtils` | Integration Procedure (PostIntake) | Digital Lending PostIntake FlexCards 일반 유틸리티 |
| `PricingExecutionWrapper` | Integration Procedure (FlexCards) | Digital Lending FlexCards 가격 책정 실행 유틸리티 |

모든 클래스는 OmniScript 또는 Integration Procedure에서 **callable 메서드**로 호출한다.

---

## 사용 컨텍스트

industriesDigitalLending 네임스페이스는 FSC Digital Lending 솔루션의 두 가지 흐름에서 활용된다.

- **인테이크 흐름**: OmniScript가 `DigitalLendingIntakeRecordsWrapper` 및 `DigitalLendingPostIntakeRecordsWrapper`를 callable로 호출해 대출 신청 데이터를 처리한다.
- **FlexCards 흐름**: Integration Procedure가 `DigitalLendingProductsApi`, `DigitalLendingUtils`, `PricingExecutionWrapper`를 호출해 대출 상품 조회·가격 책정·유틸리티 작업을 수행한다.

```apex
// 구조 예시 — 실제 동작 코드 아님 (OmniScript/Integration Procedure에서 callable로 호출)
// IndustriesDigitalLending.DigitalLendingProductsApi productsApi =
//     new IndustriesDigitalLending.DigitalLendingProductsApi();
// IndustriesDigitalLending.PricingExecutionWrapper pricingWrapper =
//     new IndustriesDigitalLending.PricingExecutionWrapper();
```

---

## 관련 노트

- [[Context Namespace]] — Industries Cloud 컨텍스트 서비스
- [[ComplianceMgmt Namespace]] — FSC 규정 준수 룰 프로세서 Apex
