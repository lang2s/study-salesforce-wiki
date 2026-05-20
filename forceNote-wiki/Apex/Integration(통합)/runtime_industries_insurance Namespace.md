---
tags: [apex, namespace, runtime-industries-insurance, insurance, financial-services-cloud, managed-package, stub]
source: salesforce_apex_reference_guide.pdf v67.0 — runtime_industries_insurance Namespace (doc p.3458)
created: 2026-05-21
aliases: [runtime_industries_insurance, industries insurance apex, 보험 견적 Apex, 보험 조항 생성 Apex, 보험 레이팅 Apex, Insurance Cloud Apex]
---

# runtime_industries_insurance Namespace

> 보험 견적 생성·수정, 보험 조항 생성, 보험 레이팅 실행을 위한 Industries Insurance Apex 네임스페이스 (managed package)

> [!warning] 이 노트는 Apex Reference Guide의 클래스 인벤토리 기반으로 작성된 스텁입니다. 개별 클래스 상세 API는 Industries Insurance 공식 문서를 참조하세요.

---

## 개요

`runtime_industries_insurance` 네임스페이스는 **보험 운영을 위한 옵션(입력) 클래스**를 제공한다.

- 보험 견적(Quote) 생성 및 수정
- 보험 조항(Clause) 생성 및 적격 조항 추가
- 보험 레이팅(Rating) 실행
- managed package 기반 (`runtime_` prefix) — 패키지 전용 문서에 API 공개
- 클래스명의 `Options` suffix는 Invocable Action 입력 파라미터 클래스 관례

---

## 클래스 목록

| 클래스 | 관련 동작 |
|---|---|
| `AddEligibleInsuranceClausesOptions` | 적격 보험 조항 추가 |
| `CreateInsuranceQuoteOptions` | 보험 견적 생성 |
| `CreateInsuranceRatingOptions` | 보험 레이팅 실행 |
| `GenerateInsuranceClausesOptions` | 보험 조항 생성 |
| `UpdateInsuranceQuoteOptions` | 보험 견적 수정 |

> Apex Reference Guide v67.0은 이 네임스페이스의 클래스 목록만 제공한다. 생성자·메서드·프로퍼티 상세는 Industries Insurance 공식 문서를 참조.

---

## 참고 문서

- Salesforce Industries Insurance 개발자 가이드

---

## 관련 노트

- [[runtime_industries_cpq Namespace]] — 동일 그룹: Industries managed package 네임스페이스
