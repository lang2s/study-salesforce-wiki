---
tags: [sobject-reference, share, owner-sharing-rule, associated-objects, StandardObjectNameShare, StandardObjectNameOwnerSharingRule, 공유 오브젝트]
source: object_reference.pdf p.65-67 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Share Objects, OwnerSharingRule, StandardObjectNameShare, StandardObjectNameOwnerSharingRule, AccountShare, AccountOwnerSharingRule, RowCause, 수동 공유, Manual Share, 소유자 공유 규칙]
---

# Share & OwnerSharingRule Objects

> 표준 Object의 레코드 단위 공유 항목(`StandardObjectNameShare`)과 소유자 기반 공유 규칙(`StandardObjectNameOwnerSharingRule`) — 두 연관 Object의 필드 참조 및 사용 규칙

---

## 명명 규칙

```
표준 Object API 이름 + Share            → 공유 항목
표준 Object API 이름 + OwnerSharingRule → 소유자 공유 규칙

예: Account → AccountShare, AccountOwnerSharingRule
    Case    → CaseShare,    CaseOwnerSharingRule
```

---

## StandardObjectName Share

레코드 단위 공유 항목을 나타낸다. Org-Wide Default(OWD)에 공유 규칙과 수동 공유가 결합되어 실제 공유 현황이 결정된다.

### RowCause = Manual 전용 쓰기 규칙

```
RowCause = Manual인 Share 레코드만 create · edit · delete 가능.
다른 RowCause 값(Owner, Rule, ImplicitParent, Team 등)의 Share 레코드는
Salesforce Org의 공유 설정에 의해 자동 생성되며 읽기 전용.
```

> 일부 공유 메커니즘(예: Sharing Sets)은 Share 레코드를 아예 저장하지 않는다.
> Salesforce는 성능 향상을 위해 특정 Share 레코드 저장을 중단할 수 있다. 이러한 공유 항목 존재에 의존하는 커스터마이징은 베스트 프랙티스상 권장하지 않는다.

### 지원 호출

```
create(), delete(), describeSObjects(), query(), retrieve(), update(), upsert()
```

### 필드 참조표

| 필드 | 타입 | Properties | 설명 |
|---|---|---|---|
| `AccessLevel` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 허용된 접근 수준. 값: `All`(소유자 수준), `Edit`(읽기/쓰기), `Read`(읽기 전용) |
| `ParentId` | reference | Create, Filter, Group, Sort | 공유 대상 부모 레코드 ID |
| `RowCause` | picklist | Create, Filter, Group, Nillable, Restricted picklist, Sort | 공유 항목이 존재하는 이유. `Manual` 값만 create/update/delete 가능 |
| `UserOrGroupId` | reference | Create, Filter, Group, Sort | 접근을 부여받은 User 또는 Group ID |

---

## StandardObjectName OwnerSharingRule

소유자가 아닌 다른 사용자에게 레코드를 공유하는 규칙 Object.

> **참고:** 이 Object에 대한 접근 활성화는 Salesforce 고객 지원에 문의해야 한다.
> 단, 소유자 공유 규칙을 프로그래밍 방식으로 업데이트하려면 **Metadata API의 SharingRules 타입 사용을 권장**한다 — Metadata API는 모든 Org에서 활성화되어 있으며, 자동 공유 규칙 재계산을 트리거한다.

### 지원 호출

```
create(), delete(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve(), update(), upsert()
```

### 특수 접근 규칙

각 표준 Object에 대한 특수 접근 규칙은 해당 Object 문서를 참조한다. 예: `ChannelProgramOwnerSharingRule` → ChannelProgram 특수 접근 규칙 참조.

### 필드 참조표

| 필드 | 타입 | Properties | 설명 |
|---|---|---|---|
| `AccessLevel` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 사용자에게 부여할 접근 수준. 값: `Read`(읽기 전용), `Edit`(읽기/쓰기) |
| `Description` | textarea | Create, Filter, Nillable, Sort, Update | 공유 규칙 설명. 최대 1,000자 |
| `DeveloperName` | string | Create, Filter, Group, Nillable, Sort, Update | API에서 사용하는 고유 이름. 밑줄과 영숫자만 가능. 공백 불가. 밑줄로 시작/끝 불가. 연속 밑줄 불가. 관리 패키지에서 네이밍 충돌 방지. 대용량 데이터 생성 시 항상 고유 DeveloperName 지정 권장 (미지정 시 성능 저하 가능) |
| `GroupId` | reference | Create, Filter, Group, Sort | 소스 그룹 ID. 이 그룹의 멤버가 소유한 레코드가 규칙을 트리거하여 접근 권한을 부여 |
| `Name` | string | Create, Filter, Group, idLookup, Sort, Update | UI에 표시되는 공유 규칙 레이블. 최대 80자 |
| `UserOrGroupId` | reference | Create, Filter, Group, Sort | 접근을 부여받을 User 또는 Group ID |

---

## 비교: Share vs OwnerSharingRule

| 구분 | StandardObjectNameShare | StandardObjectNameOwnerSharingRule |
|---|---|---|
| 목적 | 레코드 단위 공유 항목 저장 | 소유자 기반 공유 규칙 정의 |
| 쓰기 가능 조건 | `RowCause = Manual`인 경우만 | 전체 CRUD 지원 (Salesforce 지원 활성화 필요) |
| 추천 관리 방법 | Apex DML (수동 공유) | Metadata API SharingRules 타입 |
| 자동 재계산 | 없음 (수동 공유는 Org 공유 설정 변경 시 유지) | Metadata API 사용 시 자동 재계산 |

---

## 코드 예제

### 수동 공유 추가 (AccountShare)

```apex
// AccountShare는 ParentId 대신 AccountId 필드를 사용
AccountShare share = new AccountShare();
share.AccountId = accountId;        // ParentId 역할
share.UserOrGroupId = userId;
share.AccountAccessLevel = 'Edit';
share.OpportunityAccessLevel = 'Read';
share.CaseAccessLevel = 'None';
insert share;
```

### 수동 공유 레코드 조회

```apex
// 특정 레코드의 수동 공유 현황 조회
List<AccountShare> manualShares = [
    SELECT UserOrGroupId, AccessLevel, RowCause
    FROM AccountShare
    WHERE AccountId = :accountId
    AND RowCause = 'Manual'
];
```

### 수동 공유 삭제

```apex
// 수동 공유 레코드만 삭제 가능 (RowCause = Manual)
List<AccountShare> sharesToDelete = [
    SELECT Id
    FROM AccountShare
    WHERE AccountId = :accountId
    AND RowCause = 'Manual'
    AND UserOrGroupId = :userId
];
if (!sharesToDelete.isEmpty()) {
    delete sharesToDelete;
}
```

### 그룹에 수동 공유 추가

```apex
// Public Group에 공유
AccountShare groupShare = new AccountShare();
groupShare.AccountId = accountId;
groupShare.UserOrGroupId = groupId;  // Group ID
groupShare.AccountAccessLevel = 'Read';
groupShare.OpportunityAccessLevel = 'None';
groupShare.CaseAccessLevel = 'None';
insert groupShare;
```

---

## 관련 노트

- [[3 Associated Objects]] — Feed·History·Share·OwnerSharingRule·ChangeEvent 패턴 개요
- [[Object Relationships]] — Master-Detail·Lookup 관계와 OLS·FLS·Sharing 데이터 접근 팩터
- [[History Objects]] — 필드 변경 이력 연관 Object
- [[ChangeEvent Objects]] — CDC 변경 이벤트 연관 Object
