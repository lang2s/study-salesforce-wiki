---
title: Object Relationships
tags: [salesforce, sobject, relationships, master-detail, lookup, many-to-many]
source: object_reference.pdf v67.0 — Ch1 pp.25–27 (물리 pp.67–69)
---

# Object Relationships

## 개요

Salesforce에서 관계는 오브젝트와 오브젝트를 연결한다. 예: 커스텀 Issues 오브젝트와 Case 표준 오브젝트 연결.

관계 필드를 생성하려면 UI 또는 Salesforce Metadata API를 사용한다.

관계 타입에 따라 **데이터 삭제 동작, 레코드 소유권, 보안, 페이지 레이아웃의 필수 여부**가 달라진다.

---

## 관계 타입

### 1. Master-Detail (1:n)

부모(Master)가 자식(Detail)의 특정 동작을 제어하는 부모-자식 관계.

**특징:**
- Master 레코드 삭제 시 → 관련 Detail 레코드도 **자동 삭제** (cascade delete)
- Detail 오브젝트의 `Owner` 필드는 사용 불가 — Master 레코드 소유자로 자동 설정
  - Detail 쪽 커스텀 오브젝트에는 **공유 규칙, 수동 공유, 큐**를 사용할 수 없다 (Owner 필드 필요)
- Detail 레코드는 Master 레코드의 **공유 및 보안 설정을 상속**
- 관계 필드는 Detail 레코드의 페이지 레이아웃에서 **필수**
- 기본적으로 Detail 레코드는 다른 Master로 **재부모화(reparenting) 불가**
  - 관리자가 관계 정의에서 "Allow reparenting" 옵션 선택 시 허용 가능

**가능한 조합:**
- 커스텀 오브젝트 ↔ 커스텀 오브젝트
- 커스텀 오브젝트 ↔ 표준 오브젝트 (표준 오브젝트는 Master 쪽만 허용)

**Master-Detail Master로 사용 불가한 표준 오브젝트 (Detail 불가):**

| 오브젝트 |
|---|
| BusinessHours |
| Idea |
| Lead |
| OrderItem |
| PriceBook2 |
| Product2 |
| QuoteLineItem |
| User |

---

### 2. Many-to-Many

두 오브젝트의 각 레코드가 상대방의 여러 레코드와 연결되는 관계.

**구현 방법:** 중간 **Junction 오브젝트**에 두 개의 Master-Detail 관계 필드 생성.

예: `Issue` 커스텀 오브젝트 ↔ `Case` 표준 오브젝트 (하나의 Issue가 여러 Case에 연결되고, 하나의 Case도 여러 Issue에 연결)

> API v11.0 이상에서 두 개의 Master-Detail 관계를 가진 커스텀 오브젝트 지원.

#### JunctionIdList 필드 타입 (v34.0+)

Junction 오브젝트 레코드를 직접 조작하지 않고 엔티티의 Many-to-many 관계를 조작하는 필드 타입.

- WSDL에서 `ID`의 unbounded array 타입으로 표시
- 구현 오브젝트: `Task`, `Event`
- **Apex에서는 모두 읽기 전용** — 기존 오브젝트에 새 값 설정 시 예외 발생

---

### 3. Lookup (1:n)

두 오브젝트를 연결하지만 **삭제나 보안에 영향 없음**.

**특징:**
- Lookup 필드는 자동으로 필수가 아님 (Master-Detail과 다름)
- 한 오브젝트의 데이터가 다른 오브젝트의 페이지 레이아웃에 커스텀 관련 목록으로 표시될 수 있음

**외부 오브젝트 전용 관계:**
- 표준 Lookup 외에 **External Lookup**, **Indirect Lookup**이 추가로 지원됨
- 외부 오브젝트는 Lookup, External Lookup, Indirect Lookup만 지원 (다른 관계 타입 불가)

---

## 관계별 동작 비교

| 항목 | Master-Detail | Lookup |
|---|---|---|
| Cascade delete | O | X |
| Owner 필드 | Master에서 자동 설정 | Detail에 별도 Owner 있음 |
| 보안 상속 | O (Master에서 상속) | X |
| 페이지 레이아웃 필수 | O | X (선택) |
| Reparenting | 기본 X (관리자 허용 가능) | O |

---

## Data Access에 영향을 주는 요소

### API 액세스 조건

- 조직의 API 액세스 활성화 필요
- 일부 오브젝트는 기능 활성화 후에만 사용 가능 (예: `Territory2` → Enterprise Territory Management 활성화 필요)
- 일부 기능은 UI에서 한 번 사용한 후에야 API에서 접근 가능 (예: `recordTypeIds` → 레코드 타입 하나 이상 생성 후)

### 오브젝트/필드 수준 보안

API는 UI의 오브젝트 수준, 필드 수준 보안 설정을 준수한다.
- 사용자에게 보이지 않는 필드는 `query()` 또는 `describeSObjects()` 응답에서 제외
- 읽기 전용 필드는 업데이트 불가

### 사용자 권한 수준

| 권한 | 허용 작업 |
|---|---|
| Read | 조회만 |
| Create | 조회 + 생성 |
| Edit | 조회 + 수정 |
| Delete | 조회 + 수정 + 삭제 |

권한을 재정의하는 특수 권한:
- `View All Records` — 공유 설정과 관계없이 해당 오브젝트의 모든 레코드 조회
- `View All Data` — 모든 레코드 조회 (오브젝트 권한이 아닌 사용자 권한)
- `Modify All Records` — 해당 오브젝트의 모든 레코드 조회·수정·삭제·전송·승인
- `Modify All Data` — 모든 레코드 조회·수정·삭제·전송·승인 (사용자 권한)

### 소유권 변경 Cascade 없음

소유권 변경은 연관 레코드에 자동으로 전파되지 않는다.  
예: Account 소유자 변경 → 관련 Contract의 소유자는 자동 변경되지 않음. 각 레코드를 개별적으로 명시적 변경 필요.

### Referential Integrity

- `create()` / `update()` 호출 시 reference 필드의 ID 값 검증
- `cascadeDelete = true`인 자식 관계 레코드는 부모 삭제 시 함께 삭제
  - 단, 자식 레코드가 삭제 불가 상태이거나 사용 중이면 부모 삭제 실패

---

## SOQL에서 관계 쿼리

```soql
-- 표준 Parent→Child (Subquery)
SELECT Id, Name, (SELECT Id, LastName FROM Contacts) FROM Account

-- 관계 필드 조회
SELECT Id, Contact.Name FROM AccountContactRole
```

자세한 관계 쿼리 문법은 [[SOQL 문법 레퍼런스]] 참조.

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[Custom Objects]] — 커스텀 오브젝트 관계 네이밍 (`__r`, `__c`) 상세
- [[Field Types]] — `reference`, `JunctionIdList` 필드 타입 상세
- [[System Fields]] — OwnerId 동작 및 소유권 이전 규칙
- [[External Objects]] — External Lookup·Indirect Lookup 관계 유형
