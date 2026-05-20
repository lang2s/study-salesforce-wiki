---
tags: [apex, namespace, rules-app-in, revenue-cloud, payments-credits, invocable-action, stub]
source: salesforce_apex_reference_guide.pdf v67.0 — RulesAppIn Namespace (doc p.3457)
created: 2026-05-21
aliases: [RulesAppIn, rules app in apex, applyPaymentsAndCreditsByRules, 규칙 기반 결제 적용 Apex, Revenue Cloud 결제 크레딧 규칙]
---

# RulesAppIn Namespace

> 규칙 기반 결제·크레딧 적용(`applyPaymentsAndCreditsByRules` Invocable Action)의 출력 클래스를 담는 Revenue Cloud 네임스페이스

> [!warning] 이 노트는 Apex Reference Guide의 클래스 인벤토리 기반으로 작성된 스텁입니다. 개별 클래스 상세 API는 Revenue Cloud Developer Guide: **Apply Payments and Credits by Rules Action** 문서를 참조하세요.

---

## 개요

`RulesAppIn` 네임스페이스는 **규칙 기반 결제·크레딧 적용 결과를 저장하는 출력 전용 클래스**를 포함한다.

- 규칙은 `applyPaymentsAndCreditsByRules` Invocable Action으로 적용
- 이 네임스페이스의 클래스는 직접 인스턴스화하지 않고 Action 실행 결과로 수신
- Revenue Cloud Developer Guide의 Apply Payments and Credits by Rules Action 참조

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `RulesApplicationResponse` | 규칙 기반 결제/크레딧 적용 전체 응답 |
| `RulesApplicationSummaryResponse` | 적용 결과 요약 정보 |
| `RulesApplicationErrorResponse` | 적용 중 발생한 오류 정보 |

> Apex Reference Guide v67.0은 이 네임스페이스의 클래스 목록만 제공한다. 생성자·메서드·프로퍼티 상세는 아래 공식 문서를 참조.

---

## 참고 문서

- Revenue Cloud Developer Guide: **Apply Payments and Credits by Rules Action**

---

## 관련 노트

- [[RevSalesTrxn Namespace]] — 동일 Revenue Cloud 그룹: 판매 트랜잭션 생성 Apex
- [[CommercePayments Namespace]] — Payment Gateway ISV 어댑터 SDK (결제 처리 연관)
