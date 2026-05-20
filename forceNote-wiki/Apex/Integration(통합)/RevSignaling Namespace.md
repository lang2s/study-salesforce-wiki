---
tags: [apex, namespace, rev-signaling, procedure-plan, revenue-lifecycle, stub]
source: salesforce_apex_reference_guide.pdf v67.0 — RevSignaling Namespace (doc p.3408)
created: 2026-05-21
aliases: [RevSignaling, rev signaling apex, 프로시저 플랜 Apex, procedure plan apex, 수익 라이프사이클 시그널링]
---

# RevSignaling Namespace

> 커스텀 로직으로 표준 Procedure Plan 구현을 확장하는 Apex 네임스페이스 — Revenue Lifecycle Management용

> [!warning] 이 노트는 Apex Reference Guide의 클래스 인벤토리 기반으로 작성된 스텁입니다. 개별 클래스 상세 API는 Salesforce Help: **Build Your Procedure Plan Framework** 문서를 참조하세요.

---

## 개요

`RevSignaling` 네임스페이스는 **표준 Procedure Plan 구현을 커스텀 로직으로 확장**하는 클래스를 제공한다.

- Procedure(절차) 설정 및 실행 설정 구성
- 여러 Procedure를 Context Definition과 연결해 하나의 중앙 정의로 관리
- Revenue Lifecycle Management 프로세스에서 커스텀 시그널링 로직 주입

---

## 클래스 목록

| 클래스 / 인터페이스 | 설명 |
|---|---|
| `ProcedurePlan` | Procedure Plan 표현 클래스 |
| `SignalingApexProcessor` | 커스텀 시그널링 처리 로직 구현 인터페이스 |
| `TransactionRequest` | 트랜잭션 요청 데이터 클래스 |
| `TransactionResponse` | 트랜잭션 응답 데이터 클래스 |

> Apex Reference Guide v67.0은 이 네임스페이스의 클래스 목록만 제공한다. 생성자·메서드·프로퍼티 상세는 아래 공식 문서를 참조.

---

## 참고 문서

- Salesforce Help: **Build Your Procedure Plan Framework**

---

## 관련 노트

- [[RevSalesTrxn Namespace]] (미작성) — 동일 그룹: 가격·구성 통합 판매 트랜잭션 생성 Apex
- [[RichMessaging Namespace]] — Enhanced Messaging 채널 Apex SDK (같은 Apex 참조 가이드 섹션)
