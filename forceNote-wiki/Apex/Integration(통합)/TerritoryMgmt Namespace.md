---
tags: [apex, namespace, territorymgmt, territory2, sales-cloud, opportunity]
source: salesforce_apex_reference_guide.pdf p.4441-4444
created: 2026-05-20
aliases: [TerritoryMgmt, OpportunityTerritory2AssignmentFilter, 테리토리 관리 Apex, Enterprise Territory Management Apex, 영업 구역 배정 필터]
---

# TerritoryMgmt Namespace

> Enterprise Territory Management (ETM) — `OpportunityTerritory2AssignmentFilter` 인터페이스를 구현해 Opportunity Territory Assignment 잡이 각 Opportunity에 배정할 Territory2를 Apex로 커스터마이즈한다.

---

## 구성 인터페이스 요약

| 인터페이스 | 역할 |
|---|---|
| `OpportunityTerritory2AssignmentFilter` | Opportunity 1건당 Territory2 1개를 배정하는 로직을 Apex로 구현 |

---

## OpportunityTerritory2AssignmentFilter Global Interface

Opportunity Territory Assignment 잡이 호출하는 글로벌 인터페이스. 이 인터페이스를 구현하는 클래스를 작성하면, 잡이 `IsExcludedFromTerritory2Filter=false`인 Opportunity ID 목록(최대 1,000개)을 넘겨주고, 구현 클래스는 `OpportunityId → Territory2Id` 매핑을 반환한다. 잡은 이 매핑으로 Opportunity의 `Territory2Id` 필드를 업데이트한다.

**반환 Map 동작 규칙:**
- 값이 `null` → Opportunity의 `Territory2Id`를 제거
- 키가 없음(Map에 미포함) → `Territory2Id` 변경 없음

### 메서드

```apex
public Map<Id,Id> getOpportunityTerritory2Assignments(List<Id> opportunityIds)
// opportunityIds: IsExcludedFromTerritory2Filter=false인 Opportunity ID 목록
// 반환: Map<OpportunityId, Territory2Id>
```

### 예제 — 기본 우선순위 로직 구현

Account에 배정된 Territory2 중 우선순위가 가장 높은 1개를 선택하는 기본 로직. 동일 최고 우선순위가 둘 이상이면 `null`(미배정)을 반환한다.

```apex
global class OppTerrAssignDefaultLogicFilter
        implements TerritoryMgmt.OpportunityTerritory2AssignmentFilter {

    global OppTerrAssignDefaultLogicFilter() {}

    global Map<Id,Id> getOpportunityTerritory2Assignments(List<Id> opportunityIds) {
        Map<Id, Id> OppIdTerritoryIdResult = new Map<Id, Id>();
        Id activeModelId = getActiveModelId();

        if (activeModelId != null) {
            List<Opportunity> opportunities = [
                Select Id, AccountId, Territory2Id
                FROM Opportunity
                WHERE Id IN :opportunityIds
            ];

            // Account ID 집합 구성
            Set<Id> accountIds = new Set<Id>();
            for (Opportunity opp : opportunities) {
                if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
                }
            }

            // Account별 최고 우선순위 Territory2 조회
            Map<Id, Territory2Priority> accountMaxPriorityTerritory =
                getAccountMaxPriorityTerritory(activeModelId, accountIds);

            // 각 Opportunity에 배정
            for (Opportunity opp : opportunities) {
                Territory2Priority tp = accountMaxPriorityTerritory.get(opp.AccountId);
                // 최고 우선순위가 유일한 경우만 배정, 동순위 둘 이상이면 null
                if ((tp != null) &&
                    (tp.moreTerritoriesAtPriority == false) &&
                    (tp.territory2Id != opp.Territory2Id)) {
                    OppIdTerritoryIdResult.put(opp.Id, tp.territory2Id);
                } else {
                    OppIdTerritoryIdResult.put(opp.Id, null);
                }
            }
        }
        return OppIdTerritoryIdResult;
    }

    // Account에 배정된 Territory2 중 최고 우선순위 Territory2 조회
    private Map<Id,Territory2Priority> getAccountMaxPriorityTerritory(
            Id activeModelId, Set<Id> accountIds) {
        Map<Id, Territory2Priority> accountMaxPriorityTerritory = new Map<Id, Territory2Priority>();
        for (ObjectTerritory2Association ota : [
            Select ObjectId, Territory2Id, Territory2.Territory2Type.Priority
            FROM ObjectTerritory2Association
            WHERE objectId IN :accountIds
            AND Territory2.Territory2ModelId = :activeModelId
        ]) {
            Territory2Priority tp = accountMaxPriorityTerritory.get(ota.ObjectId);
            if ((tp == null) || (ota.Territory2.Territory2Type.Priority > tp.priority)) {
                tp = new Territory2Priority(
                    ota.Territory2Id,
                    ota.Territory2.Territory2Type.Priority,
                    false
                );
            } else if (ota.Territory2.Territory2Type.Priority == tp.priority) {
                tp.moreTerritoriesAtPriority = true;  // 동순위 감지
            }
            accountMaxPriorityTerritory.put(ota.ObjectId, tp);
        }
        return accountMaxPriorityTerritory;
    }

    // 활성 Territory2Model ID 조회
    private Id getActiveModelId() {
        List<Territory2Model> models = [
            Select Id FROM Territory2Model WHERE State = 'Active'
        ];
        return (models.size() == 1) ? models.get(0).Id : null;
    }

    // 내부 헬퍼 클래스 — Territory2 ID·우선순위·동순위 여부 보관
    private class Territory2Priority {
        public Id territory2Id { get; set; }
        public Integer priority { get; set; }
        public Boolean moreTerritoriesAtPriority { get; set; }

        Territory2Priority(Id territory2Id, Integer priority, Boolean moreTerritoriesAtPriority) {
            this.territory2Id = territory2Id;
            this.priority = priority;
            this.moreTerritoriesAtPriority = moreTerritoriesAtPriority;
        }
    }
}
```

---

## 배정 로직 결정 트리

```
Account에 배정된 Territory2가...
  0개  → Territory2Id = null  (미배정)
  1개  → Territory2Id = 해당 Territory2Id
  2개+ → 최고 우선순위 Territory2Type.Priority 확인
           유일한 최고 우선순위  → Territory2Id = 해당 Territory2Id
           동순위 둘 이상       → Territory2Id = null (충돌)
```

---

## 관련 노트

- [[Apex MOC]]
