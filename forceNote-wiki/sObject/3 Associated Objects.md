---
tags: [sobject-reference, associated-objects, feed, history, share, owner-sharing-rule, change-event, cdc]
source: object_reference.pdf p.55-77 (v67.0 Summer '26)
created: 2026-05-22
aliases: [3 Associated Objects, Feed Object, History Object, Share Object, OwnerSharingRule, ChangeEvent CDC, StandardObjectNameFeed]
---

# 3 Associated Objects — Feed·History·Share·OwnerSharingRule·ChangeEvent

> 표준 Object에 자동 생성되는 연관 Object 5종 패턴 — 모두 `StandardObjectName + 접미사` 형식

---

## 개요

표준 Object를 생성·활성화할 때 Salesforce가 자동으로 생성하는 연관 Object.

| 연관 Object | 용도 | 예시 |
|---|---|---|
| `StandardObjectNameFeed` | Feed 포스트·추적 변경 | `AccountFeed` |
| `StandardObjectNameHistory` | 필드 변경 이력 | `AccountHistory` |
| `StandardObjectNameOwnerSharingRule` | 소유자 공유 규칙 | `AccountOwnerSharingRule` |
| `StandardObjectNameShare` | 공유 항목 | `AccountShare` |
| `StandardObjectNameChangeEvent` | CDC 변경 이벤트 | `AccountChangeEvent` |

---

## StandardObjectName Feed → [[Feed Objects]]

### 지원 호출

```
delete(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve()
```

### 특수 접근 규칙

- 내부 Org: 자신이 만든 피드 아이템은 누구나 삭제 가능
- Experience Cloud (threaded discussions): 중첩 콘텐츠(댓글·답변·리플)가 있는 피드 아이템은 Moderator 또는 Modify All Data 권한 필요
- 삭제 권한: `Modify All Data`, `Modify All Records on Parent`, `Moderate Chatter` 중 하나

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `BestCommentId` | reference | 질문 포스트의 베스트 댓글 ID. v44.0+ |
| `Body` | textarea | 포스트 본문. `TextPost` 타입 필수 |
| `CommentCount` | int | 댓글 수 (pre-moderation 환경에서는 승인 후 카운트) |
| `ConnectionId` | reference | S2S(Salesforce-to-Salesforce) 연결 ID |
| `InsertedById` | reference | 피드에 아이템을 추가한 User ID |
| `IsRichText` | boolean | Body에 rich text 포함 여부. SOAP API 사용 시 true 설정 + HTML 이스케이프 |
| `LikeCount` | int | 좋아요 수 |
| `LinkUrl` | url | LinkPost의 URL |
| `NetworkScope` | picklist | `NetworkId`(특정 Experience Cloud) / `AllNetworks`(전체) |
| `ParentId` | reference | 추적 대상 레코드 ID |
| `RelatedRecordId` | reference | ContentPost 관련 ContentVersion ID |
| `Title` | string | 피드 아이템 제목 (LinkPost의 링크 명칭) |
| `Type` | picklist | 피드 타입 (아래 목록 참조) |
| `Visibility` | picklist | `AllUsers` / `InternalUsers` |

### Feed Type 값

```
TextPost            — 직접 텍스트 포스트
ContentPost         — 파일 첨부 포스트 (ContentData + ContentFileName 필수)
LinkPost            — URL 포스트
AdvancedTextPost    — 그룹 공지 / 포스트 공유 (v39.0+)
PollPost            — 설문 포스트
QuestionPost        — 질문 포스트
TrackedChange       — 추적 필드 변경 (하나 또는 묶음)
ActivityEvent       — Task/Event 관련 이벤트
ApprovalPost        — 승인 제출 이벤트
DashboardComponentAlert     — 대시보드 임계값 초과
DashboardComponentSnapshot  — 대시보드 스냅샷 포스트
CollaborationGroupCreated   — 공개 그룹 생성
ProfileSkillPost    — Chatter 프로필 스킬 추가
```

Case 전용 Feed 타입:
```
CaseCommentPost     — 케이스 댓글
EmailMessageEvent   — 이메일 수신/발신
CallLogPost         — 통화 로그
ChangeStatusPost    — 케이스 상태 변경
AttachArticleEvent  — 아티클 첨부
```

### IsRichText 사용 예시

```apex
// Rich text 피드 포스트 생성 (SOAP API 방식)
FeedItem post = new FeedItem();
post.ParentId = accountId;
post.Body = '<p>Rich text content with <b>bold</b>.</p>';
post.IsRichText = true;
post.Type = 'TextPost';
insert post;
```

---

## StandardObjectName History → [[History Objects]]

### 지원 호출

```
describeSObjects(), getDeleted(), getUpdated(), query(), retrieve()
// v42.0+: delete() 활성화 가능 (Enable delete of Field History)
```

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `Id` | ID | 히스토리 레코드 ID |
| `ParentId` | reference | 변경 대상 레코드 ID |
| `CreatedById` | reference | 변경한 User ID |
| `CreatedDate` | dateTime | 변경 일시 |
| `Field` | picklist | 변경된 필드 API 이름 |
| `OldValue` | anyType | 이전 값 |
| `NewValue` | anyType | 새 값 |

### SOQL 패턴

```apex
// 특정 계정의 최근 필드 변경 이력 조회
List<AccountHistory> history = [
    SELECT Field, OldValue, NewValue, CreatedDate, CreatedBy.Name
    FROM AccountHistory
    WHERE ParentId = :accountId
    ORDER BY CreatedDate DESC
    LIMIT 200
];
```

---

## StandardObjectName OwnerSharingRule → [[Share Objects]]

소유자가 아닌 다른 사용자에게 레코드를 공유하는 규칙.

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `Id` | ID | |
| `DeveloperName` | string | 공유 규칙 API 이름 |
| `MasterLabel` | string | UI 표시 레이블 |
| `Description` | textarea | 설명 |
| `UserOrGroupId` | reference | 공유 대상 User 또는 Group ID |
| `AccessLevel` | picklist | `Read`, `Edit` |
| `OwnerCriteriaValue` | string | 기준 Owner 조건 |

---

## StandardObjectName Share → [[Share Objects]]

레코드 단위 공유 항목. Org-Wide Default + 공유 규칙·수동 공유 결합.

### 지원 호출

```
create(), delete(), describeSObjects(), query(), retrieve(), update()
```

### 주요 필드

| 필드 | 타입 | 설명 |
|---|---|---|
| `Id` | ID | |
| `ParentId` | reference | 공유 대상 레코드 ID |
| `UserOrGroupId` | reference | 공유 대상 User 또는 Group ID |
| `AccessLevel` | picklist | `Read`, `Edit`, `All` |
| `RowCause` | picklist | 공유 이유: `Owner`, `Manual`, `Rule`, `ImplicitParent`, `Team` 등 |

### SOQL 패턴

```apex
// 특정 레코드의 공유 현황 조회
List<AccountShare> shares = [
    SELECT UserOrGroupId, AccessLevel, RowCause
    FROM AccountShare
    WHERE ParentId = :accountId
    AND RowCause = 'Manual'
];

// 수동 공유 추가
AccountShare share = new AccountShare();
share.AccountId = accountId;  // AccountShare는 ParentId 대신 AccountId 사용
share.UserOrGroupId = userId;
share.AccountAccessLevel = 'Edit';
share.OpportunityAccessLevel = 'Read';
share.CaseAccessLevel = 'None';
insert share;
```

---

## StandardObjectNameChangeEvent (CDC) → [[ChangeEvent Objects]]

Change Data Capture(CDC)를 지원하는 모든 Object에 자동 생성된다.

> [!important] ChangeEvent는 Salesforce Object가 아님 — CRUD 작업·쿼리 불가. CDC 스트림 구독 전용.

### 변경 이벤트 타입

- `CREATE` — 레코드 생성
- `UPDATE` — 기존 레코드 수정
- `DELETE` — 레코드 삭제
- `UNDELETE` — 삭제 취소 (휴지통 복원)

### ChangeEventHeader 필드

| 필드 | 설명 |
|---|---|
| `entityName` | Object API 이름 (예: `Account`) |
| `recordIds` | 변경된 레코드 ID 배열 |
| `changeType` | `CREATE`, `UPDATE`, `DELETE`, `UNDELETE` |
| `changedFields` | 변경된 필드 목록 |
| `changeOrigin` | 변경 출처 (API, UI 등) |
| `transactionKey` | 같은 트랜잭션 묶음 식별자 |
| `sequenceNumber` | 트랜잭션 내 순서 |
| `commitTimestamp` | 변경 커밋 시간 (milliseconds) |
| `commitUser` | 변경한 User ID |
| `commitNumber` | 커밋 번호 |

### Apex CDC 구독 예시

```apex
// Apex Trigger on ChangeEvent (CDC Trigger)
trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    List<AccountChangeEvent> events = Trigger.new;
    for (AccountChangeEvent event : events) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        if (header.changeType == 'UPDATE') {
            List<String> changedFields = header.changedFields;
            // 변경된 필드 처리
        }
    }
}
```

---

## 관련 노트

- [[1 Overview]] — Field 타입·시스템 필드 기초
- [[2 Object Behavior]] — Object 타입별 Associated Object 지원 여부
- [[4 Custom Objects]] — Custom Object의 __Feed 패턴
- [[ChangeEventHeader]] — CDC Header 상세
- [[Platform Event 발행]] — 이벤트 버스 관련
- [[Feed Objects]] — StandardObjectNameFeed 필드 전수·Type 26개·SOQL 제한
- [[History Objects]] — StandardObjectNameHistory 필드·v42.0+ delete() 활성화
- [[Share Objects]] — Share 필드·OwnerSharingRule 필드·RowCause=Manual 쓰기 규칙
- [[ChangeEvent Objects]] — CDC 지원 오브젝트 목록 전수·JSON 이벤트 예제·ChangeEventHeader 상세
