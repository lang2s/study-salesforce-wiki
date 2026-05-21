---
tags: [sobject-reference, history, field-history, associated-objects, StandardObjectNameHistory]
source: object_reference.pdf p.63-64 (v67.0 Summer '26)
created: 2026-05-22
aliases: [History Objects, StandardObjectNameHistory, AccountHistory, CaseHistory, FieldHistory, 필드 변경 이력, 히스토리 오브젝트, Field History Tracking]
---

# History Objects (StandardObjectNameHistory)

> 표준 Object에 Field History Tracking을 활성화할 때 자동 생성되는 연관 Object. `StandardObjectNameHistory` 패턴으로 명명되며 필드 값 변경 이력을 저장한다.

---

## 명명 규칙

```
표준 Object API 이름 + History
예: Account → AccountHistory
    Case    → CaseHistory
```

특정 버전 정보는 표준 Object 문서를 참조한다.

---

## 지원 호출

```
describeSObjects(), getDeleted(), getUpdated(), query(), retrieve()
```

> API v42.0 이상에서 `delete()`를 추가로 활성화할 수 있다. — "Enable delete of Field History and Field History Archive" 참조.

---

## 특수 접근 규칙

각 표준 Object에 대한 특수 접근 규칙은 해당 Object 문서를 참조한다. 예: `AccountHistory` → Account 특수 접근 규칙 참조.

---

## 필드 참조표

| 필드 | 타입 | Properties | 설명 |
|---|---|---|---|
| `StandardObjectNameId` | reference | Filter, Group, Sort | 변경 대상 표준 Object 레코드의 ID. 예: AccountHistory의 경우 AccountId에 해당 |
| `DataType` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 변경된 필드의 데이터 타입 |
| `Field` | picklist | Filter, Group, Restricted picklist, Sort | 변경된 필드의 API 이름 |
| `NewValue` | anyType | Nillable, Sort | 변경 후 새 값 |
| `OldValue` | anyType | Nillable, Sort | 변경 전 이전 값 |

### 시스템 공통 필드 (History Object에 포함)

| 필드 | 타입 | 설명 |
|---|---|---|
| `Id` | ID | 히스토리 레코드 고유 ID |
| `CreatedById` | reference | 이 변경을 만든 User ID |
| `CreatedDate` | dateTime | 변경이 발생한 일시 |

---

## v42.0+ delete() 활성화 방법

기본적으로 History Object는 `delete()` 호출을 지원하지 않는다. API v42.0 이상에서 아래 절차로 활성화한다:

1. Salesforce Setup에서 **Field History Archive** 기능을 활성화
2. **Enable delete of Field History** 설정 켜기
3. 활성화 후 `delete()` 호출로 History 레코드 삭제 가능

> Field History Archive: 오래된 히스토리 데이터를 BigObjects 기반 아카이브로 이동시키는 기능 (`FieldHistoryArchive` Object).

---

## 코드 예제

### 특정 레코드의 필드 변경 이력 조회

```apex
// 계정 레코드의 최근 변경 이력 50건 조회 (최신순)
List<AccountHistory> historyList = [
    SELECT Field, OldValue, NewValue, CreatedDate, CreatedById
    FROM AccountHistory
    WHERE AccountId = :accountId
    ORDER BY CreatedDate DESC
    LIMIT 50
];

for (AccountHistory h : historyList) {
    System.debug(
        h.Field + ': ' + h.OldValue + ' → ' + h.NewValue +
        ' (' + h.CreatedDate + ')'
    );
}
```

### 특정 필드의 변경 이력만 조회

```apex
// Industry 필드의 변경 이력만 조회
List<AccountHistory> industryHistory = [
    SELECT OldValue, NewValue, CreatedDate, CreatedById
    FROM AccountHistory
    WHERE AccountId = :accountId
    AND Field = 'Industry'
    ORDER BY CreatedDate DESC
];
```

### History 레코드 삭제 (v42.0+ 활성화 후)

```apex
// delete() 활성화된 경우 — 오래된 히스토리 정리
List<AccountHistory> oldHistory = [
    SELECT Id
    FROM AccountHistory
    WHERE AccountId = :accountId
    AND CreatedDate < :cutoffDate
];
delete oldHistory;
```

---

## 관련 노트

- [[3 Associated Objects]] — Feed·History·Share·OwnerSharingRule·ChangeEvent 패턴 개요
- [[Feed Objects]] — 피드 연관 Object
- [[Share Objects]] — 레코드 공유 연관 Object
- [[System Fields]] — Id·CreatedDate·CreatedById 등 시스템 필드
- [[Big Objects]] — FieldHistoryArchive 아카이브 저장소
