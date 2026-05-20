---
tags: [apex, ind_mfg_sample_mgmt_apex, namespace, manufacturing-cloud, product-requirement, stub, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — ind_mfg_sample_mgmt_apex Namespace (doc p.2925)
created: 2026-05-20
aliases: [ind_mfg_sample_mgmt_apex Namespace, ProductRequirementSpecification, ProductRequirementSpecificationItem, ProductRequirementSpecificationVersion, Manufacturing Cloud Apex, 제조 샘플 관리 Apex, 제품 요구사양 Apex]
---

# ind_mfg_sample_mgmt_apex Namespace

> Manufacturing Cloud에서 제품 요구사양(Product Requirement Specification) 레코드의 생애주기와 문서화를 관리하는 클래스를 제공하는 네임스페이스.

> [!warning] 이 노트는 Apex Reference Guide v67.0 클래스 인벤토리만 수록한 스텁입니다. 메서드·프로퍼티 상세는 Salesforce Manufacturing Cloud 개발자 가이드를 참조하세요.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `ProductRequirementSpecification` | 제품 요구사양 레코드 생성·업데이트·버전 관리 |
| `ProductRequirementSpecificationItem` | 요구사양 항목(Item) 관리 |
| `ProductRequirementSpecificationVersion` | 요구사양 버전 관리 |

---

## 사용 컨텍스트

ind_mfg_sample_mgmt_apex 네임스페이스는 Manufacturing Cloud 환경에서 제품 요구사양(Product Requirement Specification) 레코드를 Apex로 생성·업데이트·버전 관리할 때 사용한다. 샘플 데이터를 생산 표준과 일관성 있고 규정을 준수하는 상태로 유지하는 데 활용된다.

```apex
// 구조 예시 — 실제 동작 코드 아님
// ind_mfg_sample_mgmt_apex.ProductRequirementSpecification spec =
//     new ind_mfg_sample_mgmt_apex.ProductRequirementSpecification();
// ind_mfg_sample_mgmt_apex.ProductRequirementSpecificationItem item =
//     new ind_mfg_sample_mgmt_apex.ProductRequirementSpecificationItem();
// ind_mfg_sample_mgmt_apex.ProductRequirementSpecificationVersion version =
//     new ind_mfg_sample_mgmt_apex.ProductRequirementSpecificationVersion();
```

---

## 관련 노트

- [[Context Namespace]] — Industries Cloud 컨텍스트 서비스
