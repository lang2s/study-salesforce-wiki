---
tags: [apex, issuecreditmemo, namespace, revenue-cloud, credit-memo, stub, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — IssueCreditMemo Namespace (doc p.2925)
created: 2026-05-20
aliases: [IssueCreditMemo Namespace, CreditLineRequestInputRepresentations, CreditRequestInputRepresentations, CreditResponseOutputRepresentations, 크레딧 메모 Apex, Revenue Cloud 크레딧 메모]
---

# IssueCreditMemo Namespace

> Revenue Cloud에서 인보이스 또는 인보이스 라인에 대한 분쟁 조정 기반 크레딧 메모를 생성·적용하는 클래스를 제공하는 네임스페이스.

> [!warning] 이 노트는 Apex Reference Guide v67.0 클래스 인벤토리만 수록한 스텁입니다. 메서드·프로퍼티 상세는 Salesforce Revenue Cloud 개발자 가이드를 참조하세요.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `CreditLineRequestInputRepresentations` | 크레딧 라인 요청 입력 표현 데이터 |
| `CreditRequestInputRepresentations` | 크레딧 요청 입력 표현 데이터 |
| `CreditResponseOutputRepresentations` | 크레딧 요청 응답 출력 표현 데이터 |

---

## 사용 컨텍스트

IssueCreditMemo 네임스페이스는 Revenue Cloud 환경에서 인보이스 또는 인보이스 라인에 대한 분쟁 조정(dispute adjustments) 시나리오에서 크레딧 메모를 Apex로 생성하고 적용할 때 사용한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// IssueCreditMemo.CreditRequestInputRepresentations request =
//     new IssueCreditMemo.CreditRequestInputRepresentations();
// IssueCreditMemo.CreditResponseOutputRepresentations response =
//     IssueCreditMemo.<serviceMethod>(request);
```

---

## 관련 노트

- [[CommerceOrders Namespace]] — B2B/D2C Commerce 주문 생성 Apex
- [[CommerceTax Namespace]] — Tax Engine ISV 어댑터 SDK
