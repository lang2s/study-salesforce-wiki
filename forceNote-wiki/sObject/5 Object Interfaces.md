---
tags: [sobject-reference, object-interfaces, price-adjustment, sales-transaction, b2b-commerce, subscription-management]
source: object_reference.pdf p.95-104 (v67.0 Summer '26)
created: 2026-05-22
aliases: [5 Object Interfaces, PriceAdjustmentGroup, PriceAdjustmentItem, SalesTransaction, 가격조정 인터페이스]
---

# 5 Object Interfaces — PriceAdjustmentGroup·PriceAdjustmentItem·SalesTransaction

> B2B Commerce 및 Subscription Management에서 가격 조정 로직을 구현하는 3개 Object 인터페이스 — API v55.0+

---

## 개요

Object 인터페이스(Object Interface)는 특정 비즈니스 로직을 구현하는 계약을 정의한다. 여러 Object가 같은 인터페이스를 구현할 수 있다.

| 인터페이스 | 용도 | 구현 Object 예시 |
|---|---|---|
| `PriceAdjustmentGroup` | 주문/카트 레벨 가격 조정 그룹 | `WebCartAdjustmentGroup`, `OrderAdjustmentGroup` |
| `PriceAdjustmentItem` | 라인 아이템 레벨 가격 조정 | `CartItemPriceAdjustment`, `OrderItemAdjustment` |
| `SalesTransaction` | 판매 트랜잭션 (주문·카트) | `Order`, `WebCart` |

**지원 호출 (공통)**: `describeSObjects()`, `query()`, `retrieve()`
**라이센스**: Subscription Management 또는 B2B Commerce

---

## PriceAdjustmentGroup

주문/카트 전체에 적용되는 가격 조정 그룹. 여러 `PriceAdjustmentItem`의 합산 값을 보유.

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `AdjustmentSource` | picklist | 조정 출처: `Discretionary`(수동), `Promotion`(프로모션), `Rule`(미래용), `System`(가격 규칙) |
| `AdjustmentType` | picklist | 조정 방식: `AdjustmentPercentage`, `OverrideAmount` (미래용: `AdjustmentAmount`) |
| `AdjustmentValue` | double | 조정 값 (할인 = 음수) |
| `Description` | textarea | 가격 조정 그룹 설명 (v55.0-57.0) |
| `ImplementorType` | string | 인터페이스를 구현하는 Object (예: `WebCartAdjustmentGroup`) |
| `PriceAdjustmentCauseId` | reference → `PriceAdjCauseInterface` | 조정 원인 레코드 ID (프로모션·가격 조정 티어 등) |
| `Priority` | int | 적용 순서 (1이 먼저, null은 우선순위 있는 것 이후에 적용). 같은 트랜잭션 내 고유 |
| `SalesTransactionId` | reference → `SalesTransaction` | 속한 판매 트랜잭션 |
| `TotalAmount` | currency | 관련 PriceAdjustmentItem의 TotalAmount 합산 (구독 기간·수량 포함) |

### Priority 적용 규칙

```
1. Priority 명시 → 숫자 순서대로 적용 (1이 먼저)
2. Priority null → 명시된 것 이후에 적용
3. 여러 null → 퍼센트 조정 먼저, 금액 조정 나중
   (퍼센트 먼저 적용 → 최종 총 조정액 더 큰 효과)
```

---

## PriceAdjustmentItem

주문/카트의 특정 라인 아이템에 적용되는 가격 조정.

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `AdjustmentAmountScope` | picklist | 조정 범위: `Total`(라인 합계에 직접) 또는 `Unit`(단가 × 수량) |
| `AdjustmentSource` | picklist | 조정 출처: `Discretionary`, `Promotion`, `Rule`, `System` |
| `AdjustmentType` | picklist | 조정 방식: `AdjustmentAmount`, `AdjustmentPercentage`, `OverrideAmount` |
| `AdjustmentValue` | double | 조정 값. AdjustmentAmountScope와 함께 최종 금액 결정 |
| `Description` | textarea | 설명 (v55.0-57.0) |
| `ImplementorType` | string | 구현 Object (예: `CartItemPriceAdjustment`) |
| `PriceAdjustmentCauseId` | reference → `PriceAdjCauseInterface` | 조정 원인 ID |
| `PriceAdjustmentGroupId` | reference → `PriceAdjustmentGroup` | 속한 PriceAdjustmentGroup |
| `Priority` | int | 적용 순서. 같은 그룹 내 고유 |
| `SalesTransactionItemId` | reference → `SalesTransactionItem` | 적용 대상 라인 아이템 |
| `TotalAmount` | currency | 최종 조정 금액 (수량·구독 기간 포함) |

### AdjustmentAmountScope 예시

```
// Total 범위: 수량 10, TotalLineAmount 1000, AdjustmentValue -10 (금액 조정)
TotalAmount = 1000 + (-10) = 990  ← $10 할인을 합계에 직접 적용

// Unit 범위: 수량 5, TotalLineAmount 1000, AdjustmentValue -10 (금액 조정)
TotalAmount = 1000 + (-10 × 5) = 950  ← 단위당 $10 × 수량 5
```

### TotalAmount 계산 예시 (구독)

```
AdjustmentAmountScope = Unit
AdjustmentType = AdjustmentAmount
AdjustmentValue = -10
수량 = 5, PricingTermCount(구독 기간) = 12개월

TotalAmount = 5 × 12 × (-10) = -600
```

---

## SalesTransaction

판매 트랜잭션을 나타내는 인터페이스. Order 또는 WebCart가 구현.

### 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `ImplementorType` | string | 구현 Object (예: `Order`, `WebCart`). Restricted picklist |
| `TotalAdjustmentAmount` | currency | 모든 조정 합산 금액 (분산 조정 포함). SalesTransactionItem.TotalAdjustmentAmount 합계 |
| `TotalAdjustmentDistAmount` | currency | 분산 조정 항목만의 합산 (직접 적용 제외). SalesTransactionItem.TotalAdjustmentDistAmount 합계 |
| `TotalAmount` | currency | 모든 조정 후 최종 금액. SalesTransactionItem.TotalPrice 합계 |
| `TotalListAmount` | currency | 정가 합산. SalesTransactionItem.ListPriceTotal 합계 |
| `TotalProductAmount` | currency | Product 타입 라인 아이템의 조정 전 소계. SalesTransactionItem.TotalLineAmount(type=Product) 합계 |

### SOQL 패턴

```apex
// SalesTransaction 인터페이스를 통해 Order 가격 정보 조회
List<SalesTransaction> txns = [
    SELECT ImplementorType, TotalAmount, TotalListAmount,
           TotalAdjustmentAmount, TotalProductAmount
    FROM SalesTransaction
    WHERE ImplementorType = 'Order'
    LIMIT 50
];

// PriceAdjustmentGroup 및 관련 Items 조회
List<PriceAdjustmentGroup> groups = [
    SELECT AdjustmentSource, AdjustmentType, AdjustmentValue,
           Priority, TotalAmount, SalesTransactionId
    FROM PriceAdjustmentGroup
    WHERE SalesTransactionId = :orderId
    ORDER BY Priority NULLS LAST
];

// 특정 라인 아이템의 조정 항목 조회
List<PriceAdjustmentItem> items = [
    SELECT AdjustmentAmountScope, AdjustmentType, AdjustmentValue,
           AdjustmentSource, Priority, TotalAmount
    FROM PriceAdjustmentItem
    WHERE SalesTransactionItemId = :orderItemId
    ORDER BY Priority NULLS LAST
];
```

---

## 관련 노트

- [[1 Overview]] — Field 타입·Primitive 타입 기초
- [[2 Object Behavior]] — Object 그룹·타입 분류
- [[CommerceOrders Namespace]] — Order 관련 Apex 네임스페이스
- [[CommerceBuyGrp Namespace]] — B2B Commerce BuyerGroup 관련
- [[6 Standard Objects]] — Order·WebCart 등 SalesTransaction 구현 Object 목록
