---
tags: [apex, namespace, rev-sales-trxn, revenue-cloud, cpq, sales-transaction, stub]
source: salesforce_apex_reference_guide.pdf v67.0 — RevSalesTrxn Namespace (doc p.3408)
created: 2026-05-21
aliases: [RevSalesTrxn, rev sales trxn apex, revenue cloud sales transaction apex, CPQ 판매 트랜잭션 Apex, 판매 트랜잭션 생성 Apex, quote order apex]
---

# RevSalesTrxn Namespace

> 가격 책정·구성이 통합된 판매 트랜잭션(Quote·Order)을 Apex로 생성하는 Revenue Cloud 네임스페이스

> [!warning] 이 노트는 Apex Reference Guide의 클래스 인벤토리 기반으로 작성된 스텁입니다. 개별 클래스 상세 API는 Salesforce Help: **Build Your Procedure Plan Framework** 문서를 참조하세요.

---

## 개요

`RevSalesTrxn` 네임스페이스는 **가격 책정·구성이 통합된 판매 트랜잭션(Quote 또는 Order)을 생성**하는 클래스와 메서드를 제공한다.

- Quote, Order 등 판매 트랜잭션을 프로그래밍적으로 생성
- 통합 가격 책정(Integrated Pricing) 및 구성(Configuration) 지원
- Revenue Cloud CPQ 흐름과 연동

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `ConfigurationOptionsInput` | 구성 옵션 입력 데이터 |
| `GraphRequest` | 제품 구성 그래프 요청 |
| `PlaceSalesTransactionException` | 판매 트랜잭션 생성 예외 클래스 |
| `PlaceSalesTransactionExecutor` | 판매 트랜잭션 실행(메인 엔트리포인트) |
| `PlaceSalesTransactionResponse` | 판매 트랜잭션 실행 결과 응답 |
| `RecordResource` | 트랜잭션 내 레코드 리소스 표현 |
| `RecordWithReferenceRequest` | 참조 포함 레코드 요청 |

> Apex Reference Guide v67.0은 이 네임스페이스의 클래스 목록만 제공한다. 생성자·메서드·프로퍼티 상세는 아래 공식 문서를 참조.

---

## 참고 문서

- Salesforce Help: **Build Your Procedure Plan Framework**

---

## 관련 노트

- [[RevSignaling Namespace]] — 동일 그룹: Procedure Plan 커스텀 로직 확장 Apex
- [[CommercePayments Namespace]] — 결제 처리 ISV 어댑터 SDK (Revenue 흐름 연관)
- [[PlaceQuote Namespace]] — Salesforce CPQ Quote 생성·수정 Apex
