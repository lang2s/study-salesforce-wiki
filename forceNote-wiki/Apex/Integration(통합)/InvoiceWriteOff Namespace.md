---
tags: [apex, invoicewriteoff, namespace, revenue-cloud, write-off, credit-memo, stub, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — InvoiceWriteOff Namespace (doc p.2966)
created: 2026-05-20
aliases: [InvoiceWriteOff Namespace, WriteOffInvoiceInput, WriteOffInvoiceResponse, WriteOffInvoiceResponseError, Revenue Cloud 인보이스 상각 Apex, 인보이스 Write-Off]
---

# InvoiceWriteOff Namespace

> Revenue Cloud에서 인보이스 총 청구 금액을 상각(write-off) 금액으로 하는 크레딧 메모를 생성하는 클래스를 제공하는 네임스페이스.

> [!warning] 이 노트는 Apex Reference Guide v67.0 클래스 인벤토리만 수록한 스텁입니다. 메서드·프로퍼티 상세는 Salesforce Revenue Cloud 개발자 가이드를 참조하세요.

---

## 클래스 목록

| 클래스 | 역할 |
|---|---|
| `WriteOffInvoiceInputList` | 상각 처리할 인보이스 입력 목록 |
| `WriteOffInvoiceInput` | 개별 인보이스 상각 입력 데이터 |
| `WriteOffInvoiceResponseList` | 상각 처리 응답 목록 |
| `WriteOffInvoiceResponse` | 개별 인보이스 상각 응답 데이터 |
| `WriteOffInvoiceResponseError` | 상각 처리 중 발생한 오류 정보 |

---

## 사용 컨텍스트

InvoiceWriteOff 네임스페이스는 Revenue Cloud 환경에서 인보이스를 완전 상각(full write-off)할 때 사용한다. 인보이스의 총 청구 금액을 상각 금액으로 하는 크레딧 메모를 Apex로 생성하는 시나리오에서 활용된다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// InvoiceWriteOff.WriteOffInvoiceInput input =
//     new InvoiceWriteOff.WriteOffInvoiceInput();
// InvoiceWriteOff.WriteOffInvoiceInputList inputList =
//     new InvoiceWriteOff.WriteOffInvoiceInputList();
// InvoiceWriteOff.WriteOffInvoiceResponseList responseList =
//     InvoiceWriteOff.<serviceMethod>(inputList);
```

---

## 관련 노트

- [[IssueCreditMemo Namespace]] — 인보이스 분쟁 조정 기반 크레딧 메모 생성
- [[CommerceOrders Namespace]] — B2B/D2C Commerce 주문 생성 Apex
