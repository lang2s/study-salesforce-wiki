---
tags: [apex, integration, fsc, compliance, namespace, reference, stub]
source: salesforce_apex_reference_guide.pdf (doc p.646, class inventory only — Apex Reference Guide v67.0)
created: 2026-05-20
aliases: [ComplianceMgmt, ComplianceEvaluation, 규정 준수 관리 Apex, FSC 컴플라이언스]
---

# ComplianceMgmt Namespace

> Financial Services Cloud(FSC) 규정 준수 제어 — `ComplianceEvaluation` 인터페이스를 구현해 컴플라이언스 룰 프로세서를 Apex로 정의한다.

> [!warning] 이 노트는 Apex Reference Guide v67.0 doc p.646의 클래스 인벤토리 목록을 기반으로 작성되었습니다. 메서드 레벨 API 시그니처는 Apex Reference Guide PDF에 수록되지 않았으며, 상세 문서는 Financial Services Cloud 개발자 가이드를 참조해야 합니다.

---

## 개요

`ComplianceMgmt` 네임스페이스는 Salesforce Financial Services Cloud(FSC)의 규정 준수(Compliance) 제어 룰 프로세서를 구현하기 위한 클래스와 인터페이스를 제공한다.

### 클래스 인벤토리 (6개)

| 클래스 | 유형 | 역할 |
|---|---|---|
| `ComplianceEvaluation` | Interface | 컴플라이언스 룰 프로세서 구현 대상 인터페이스 |
| `ControlEvaluationInput` | Class | 규정 준수 평가 제어 입력 |
| `ControlInput` | Class | 규정 준수 제어 입력 |
| `ComplianceEvaluationResponse` | Class | 규정 준수 평가 응답 |
| `EvaluationResult` | Class | 평가 결과 |
| `ComplianceControlLog` | Class | 규정 준수 제어 로그 |

---

## 기본 패턴 (구조 추정)

```apex
// 구조 예시 — 실제 동작 코드 아님
// ComplianceEvaluation 인터페이스를 구현해 규정 준수 룰 프로세서를 정의
global class MyComplianceProcessor implements compliancemgmt.ComplianceEvaluation {
    // 인터페이스 메서드 구현 — 실제 시그니처는 FSC 개발자 가이드 참조
    global compliancemgmt.ComplianceEvaluationResponse evaluate(
        compliancemgmt.ControlEvaluationInput input
    ) {
        compliancemgmt.ComplianceEvaluationResponse response =
            new compliancemgmt.ComplianceEvaluationResponse();
        // 룰 평가 로직
        return response;
    }
}
```

---

## 사용 맥락

- **대상 제품:** Salesforce Financial Services Cloud (FSC)
- **사용 목적:** FSC의 Financial Compliance 기능에서 커스텀 규정 준수 평가 로직을 Apex로 구현할 때 사용
- **활성화 조건:** FSC 라이선스 및 Compliance Control 기능 활성화 필요

---

## 상세 API 참조

Apex Reference Guide v67.0에는 클래스 목록만 수록되어 있습니다. 각 클래스의 생성자·메서드·프로퍼티는 다음을 참조하세요:

- **Financial Services Cloud Developer Guide** — Apex Compliance Control 섹션
- Salesforce 공식 도움말: "Implement Compliance Rule Processors Using Apex"

---

## 관련 노트

- [[TxnSecurity Namespace]] — 동일한 "인터페이스 구현" 패턴 — Transaction Security Policy Apex 구현
- [[CommercePayments Namespace]] — ISV 어댑터 패턴 참조
- [[CommerceTax Namespace]] — ISV 어댑터 패턴 참조
