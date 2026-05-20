---
tags: [apex, namespace, placequote, cpq, revenue-cloud, quote]
source: salesforce_apex_reference_guide.pdf p.3208
created: 2026-05-20
aliases: [PlaceQuote, PlaceQuote Namespace, CPQ Apex, Configure Price Quote Apex, 견적 생성 Apex, CPQ 네임스페이스]
---

# PlaceQuote Namespace

> Salesforce CPQ(Configure-Price-Quote) 견적 생성·수정 — 가격 책정 설정 및 구성 옵션을 포함한 Quote 레코드를 Apex에서 직접 생성하거나 업데이트할 때 사용한다.

---

## 개요

`PlaceQuote` 네임스페이스는 가격 책정 설정(Pricing Preferences)과 구성 옵션(Configuration Options)을 포함한 Quote를 생성하거나 업데이트하는 클래스와 메서드를 제공한다.

> [!note] Apex Reference Guide v67.0에는 PlaceQuote 네임스페이스의 스텁 항목(2문장)만 포함되어 있다.  
> 클래스 목록과 메서드 상세 API는 **Salesforce CPQ(Revenue Cloud) 개발자 가이드 — PlaceQuote namespace** 항목을 참조한다.

---

## 용도

| 시나리오 | 설명 |
|---|---|
| Apex에서 Quote 프로그래밍적 생성 | 가격 책정 규칙·할인·구성 옵션을 Apex 코드로 적용하여 Quote를 생성 |
| 기존 Quote 수정 | 견적 라인 수량·가격 변경 후 CPQ 가격 엔진을 통해 재계산 |
| 가격 설정(Pricing Preferences) 제어 | CPQ 가격 책정 행동을 Apex 레벨에서 세밀하게 제어 |

---

## 기본 호출 패턴

```apex
// 구조 예시 — 실제 동작 코드 아님
// PlaceQuote 네임스페이스의 실제 클래스명·메서드명은 CPQ 개발자 가이드를 참조
SBQQ__Quote__c quote = new SBQQ__Quote__c(
    SBQQ__Account__c = accountId,
    SBQQ__Opportunity2__c = opportunityId
);
insert quote;

// PlaceQuote API를 통해 가격 계산 트리거
// (실제 클래스명은 PlaceQuote 개발자 가이드 참조)
```

---

## 관련 노트

- [[Apex MOC]]
- [[Process Namespace]] — 레거시 Flow 플러그인 인터페이스 (CPQ 연동에 과거 사용됨)
- [[QuickAction Namespace]] — Quote 관련 Quick Action 프로그래밍적 실행
