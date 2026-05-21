---
tags: [sobject-reference, feed, chatter, associated-objects, StandardObjectNameFeed]
source: object_reference.pdf p.55-62 (v67.0 Summer '26)
created: 2026-05-22
aliases: [Feed Objects, StandardObjectNameFeed, AccountFeed, CaseFeed, OpportunityFeed, FeedItem, 피드 오브젝트, Chatter 피드]
---

# Feed Objects (StandardObjectNameFeed)

> 표준 Object에 Feed Tracking을 활성화할 때 자동 생성되는 연관 Object. `StandardObjectNameFeed` 패턴으로 명명되며 포스트·추적 변경 내역을 저장한다.

---

## 명명 규칙

```
표준 Object API 이름 + Feed
예: Account → AccountFeed
    Case    → CaseFeed
```

특정 버전 정보는 표준 Object 문서를 참조한다.

---

## 지원 호출

```
delete(), describeSObjects(), getDeleted(), getUpdated(), query(), retrieve()
```

---

## 특수 접근 규칙

- **내부 Org:** 자신이 직접 만든 피드 아이템은 누구나 삭제 가능
- **Experience Cloud (threaded discussions + delete-blocking 활성화 시):**
  - 사이트 멤버는 자신이 만든 피드 아이템 중 하위 콘텐츠(댓글·답변·리플)가 없는 것만 삭제 가능
  - 하위 콘텐츠가 있는 아이템은 Feed Moderator 또는 Modify All Data 권한 필요
- **다른 사람의 피드 아이템 삭제** — 아래 권한 중 하나 필요:
  - `Modify All Data`
  - `Modify All Records on the parent object` (예: AccountFeed → Account의 Modify All Records)
  - `Moderate Chatter`
- `Moderate Chatter` 권한자는 자신이 볼 수 있는 피드 아이템·댓글만 삭제 가능. 비공개 그룹 아이템은 이 권한자만 삭제 가능.

---

## 필드 참조표

| 필드 | 타입 | Properties | 설명 |
|---|---|---|---|
| `BestCommentId` | reference | Filter, Group, Nillable, Sort | 질문 포스트에서 "베스트 답변"으로 선택된 댓글의 ID. API v44.0 이상 |
| `Body` | textarea | Nillable, Sort | 포스트 본문. `Type = TextPost`일 때 필수. `ContentPost` 또는 `LinkPost`일 때는 선택 |
| `CommentCount` | int | Filter, Group, Sort | 이 피드 아이템의 댓글 수. pre-moderation 환경에서는 댓글 승인 후에만 카운트 반영 |
| `ConnectionId` | reference | Filter, Group, Nillable, Sort | Salesforce-to-Salesforce(S2S) 연결 ID. S2S가 활성화된 Org에서 파트너 연결이 레코드를 수정할 때 설정. Available if S2S enabled |
| `ContentData` | base64 | Nillable | API v36.0 이하 전용. `Type = ContentPost`일 때 필수. 인코딩된 파일 데이터(0 bytes 불가). 설정 시 Type이 자동으로 ContentPost로 변경. ContentPost 타입일 때만 표시 |
| `ContentDescription` | textarea | Nillable, Sort | API v36.0 이하 전용. ContentData에 지정한 파일 설명. ContentPost 타입일 때만 표시 |
| `ContentFileName` | string | Group, Nillable, Sort | API v36.0 이하 전용. `Type = ContentPost`일 때 필수. 업로드된 파일명. 설정 시 Type이 자동으로 ContentPost로 변경. ContentPost 타입일 때만 표시 |
| `ContentSize` | int | Group, Nillable, Sort | API v36.0 이하 전용. 업로드된 파일 크기(bytes). 읽기 전용 — insert 시 자동 결정. ContentPost 타입일 때만 표시 |
| `ContentType` | string | Group, Nillable, Sort | API v36.0 이하 전용. 업로드된 파일의 MIME 타입. 읽기 전용 — insert 시 자동 결정. ContentPost 타입일 때만 표시 |
| `FeedPostId` | reference | Filter, Group, Nillable, Sort | API v22.0에서 제거됨 (하위 호환을 위해 이전 버전에서만 사용). 관련 FeedPost ID. FeedPost는 추적 필드 변경·텍스트 포스트·링크 포스트·콘텐츠 포스트 등을 표현 |
| `InsertedById` | reference | Group, Nillable, Sort | 이 아이템을 피드에 추가한 User ID. 예: 다른 앱에서 마이그레이션된 포스트를 삽입할 때 Context User ID가 설정됨 |
| `IsRichText` | boolean | Defaulted on create, Filter, Group, Sort | Body에 rich text가 포함되어 있는지 여부. SOAP API에서 rich text 포스트 작성 시 `true`로 설정하고 HTML 엔티티를 이스케이프해야 함. 그렇지 않으면 plain text로 렌더링 |
| `LikeCount` | int | Filter, Group, Sort | 이 피드 아이템의 좋아요 수 |
| `LinkUrl` | url | Nillable, Sort | `LinkPost`의 URL |
| `NetworkScope` | picklist | Group, Nillable, Restricted picklist, Sort | 이 피드 아이템이 표시되는 Experience Cloud 사이트 범위. API v26.0 이상, digital experiences 활성화 시 사용 가능. 값: `NetworkId`(특정 사이트 ID), `AllNetworks`(전체 사이트). 예외: Group/User 상위 아이템만 NetworkId 또는 null 설정 가능. 레코드 상위 아이템은 AllNetworks만 설정 가능. NetworkScope로 필터링 불가 |
| `ParentId` | reference | Filter, Group, Sort | 피드에서 추적되는 레코드 ID. 해당 레코드의 상세 페이지에 피드가 표시됨 |
| `RelatedRecordId` | reference | Group, Nillable, Sort | `ContentPost`와 관련된 ContentVersion 레코드 ID. ContentPost 타입이 아니면 null |
| `Title` | string | Group, Nillable, Sort | 피드 아이템 제목. `Type = LinkPost`일 때 LinkUrl이 URL이고 이 필드가 링크 이름 |
| `Type` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 피드 아이템 타입 (아래 Type 값 목록 참조) |
| `Visibility` | picklist | Filter, Group, Nillable, Restricted picklist, Sort | 피드 아이템 공개 범위. API v26.0 이상, digital experiences 활성화 시 사용 가능. 값: `AllUsers`(권한 있는 전체 사용자), `InternalUsers`(내부 사용자 전용). 레코드 포스트는 기본값 InternalUsers. 외부 사용자는 AllUsers만 설정 가능. User/Group 포스트는 내부 사용자만 InternalUsers 설정 가능 |

---

## Type picklist 값 전수

### 공통 Feed 타입

| 값 | 생성 조건 |
|---|---|
| `ActivityEvent` | 사용자 또는 API가 Feed 활성화 부모 레코드(이메일 태스크 케이스 제외)에 Task를 추가할 때 간접 생성. 케이스 레코드에 Task 또는 Event를 추가하거나 수정할 때(이메일·통화 로깅 제외). 반복 Task: CaseFeed 비활성화 시 시리즈에 1개만 생성. CaseFeed 활성화 시 시리즈 및 각 발생에 생성 |
| `AdvancedTextPost` | 사용자가 그룹 공지를 포스트하거나, Lightning Experience에서 API v39.0 이상 시 포스트를 공유할 때 생성 |
| `AnnouncementPost` | 미사용 |
| `ApprovalPost` | 사용자가 승인을 제출할 때 생성 |
| `BasicTemplateFeedItem` | 미사용 |
| `CanvasPost` | Canvas 앱이 피드에 포스트할 때 생성 |
| `CollaborationGroupCreated` | 사용자가 공개 그룹을 생성할 때 생성 |
| `CollaborationGroupUnarchived` | 미사용 |
| `ContentPost` | 첨부 파일이 있는 포스트. `Type = ContentPost`일 때 ContentData와 ContentFileName도 지정 필요 |
| `CreatedRecordEvent` | 사용자가 publisher에서 레코드를 생성할 때 생성 |
| `DashboardComponentAlert` | 대시보드 metric 또는 gauge가 사용자 정의 임계값을 초과할 때 생성 |
| `DashboardComponentSnapshot` | 사용자가 피드에 대시보드 스냅샷을 포스트할 때 생성 |
| `LinkPost` | URL이 첨부된 포스트 |
| `PollPost` | 피드에 게시된 설문 |
| `ProfileSkillPost` | 사용자의 Chatter 프로필에 스킬이 추가될 때 생성 |
| `QuestionPost` | 사용자가 질문을 포스트할 때 생성 |
| `ReplyPost` | Chatter Answers가 답변을 포스트할 때 생성 |
| `RypplePost` | WDC에서 사용자가 Thanks badge를 생성할 때 생성 |
| `TextPost` | 피드에 직접 작성한 텍스트 포스트 |
| `TrackedChange` | 추적된 필드의 변경 1건 또는 묶음 |
| `UserStatus` | 사용자가 포스트를 추가할 때 자동 생성. 사용 중단(Deprecated) |

### CaseFeed 전용 Feed 타입

아래 값은 모든 Feed Object의 Type picklist에 나타나지만 **CaseFeed에서만 적용**된다.

| 값 | 생성 조건 |
|---|---|
| `CaseCommentPost` | 사용자가 케이스 댓글을 추가할 때 생성 |
| `EmailMessageEvent` | 케이스와 관련된 이메일이 송수신될 때 생성 |
| `CallLogPost` | 사용자가 UI에서 케이스의 통화를 로깅할 때 생성. CTI 통화도 이 이벤트를 생성 |
| `ChangeStatusPost` | 사용자가 케이스 상태를 변경할 때 생성 |
| `AttachArticleEvent` | 사용자가 케이스에 아티클을 첨부할 때 생성 |

---

## IsRichText 지원 HTML 태그

SOAP API에서 `IsRichText = true`로 설정할 때 사용 가능한 HTML 태그:

| 태그 | 비고 |
|---|---|
| `<p>` | `<br>` 태그는 미지원. `<p>&nbsp;</p>`로 빈 줄 생성 가능 |
| `<a>` | 링크 |
| `<b>` | 굵게 |
| `<code>` | 코드 |
| `<i>` | 이탤릭 |
| `<u>` | 밑줄 |
| `<s>` | 취소선 |
| `<ul>` | 순서 없는 목록 |
| `<ol>` | 순서 있는 목록 |
| `<li>` | 목록 항목 |
| `<img>` | API를 통해서만 접근 가능. Salesforce 내 파일 참조 필요: `<img src="sfdc://069B0000000omjh"></img>` |

> API v35.0 이상: 시스템이 rich text의 특수 문자를 이스케이프된 HTML로 대체. API v34.0 이하: 모든 rich text가 plain-text 표현으로 표시.

---

## SOQL 제한

- **View All Data 권한이 없는 경우:**
  - `NewsFeed`, `UserProfileFeed` 쿼리 시 반드시 `LIMIT` 절 지정 (1,000 이하)
  - `WHERE` 절에서 관련 Object 필드 참조 불가 (루트 Object 필드만 가능)
  - `ORDER BY` 절에서 관련 Object 필드 참조 불가 (루트 Object 필드만 가능)
  - 최신 피드 아이템 조회: `ORDER BY CreatedDate DESC, Id DESC`
- **View All Data 권한 있는 경우:** SOQL 한도 없음
- `NewsFeed`, `UserProfileFeed`는 API v27.0 이상에서 SOAP API 지원 중단 → Connect REST API 사용
- Article Type__Feed: 변수 이름 형식 (예: `Offer__Feed` = Offer 타입 아티클의 피드)

### Field Service 전용 Feed Object

아래 Feed Object는 Org에 Field Service가 활성화되어야 사용 가능:
- `ServiceAppointmentFeed`, `ServiceCrewFeed`, `ServiceMemberFeed`
- `ServiceResourceCapacityFeed`, `ServiceResourceFeed`, `ServiceResourceSkillFeed`
- `ServiceTerritoryFeed`, `ServiceTerritoryMemberFeed`, `SkillRequirementFeed`

`WorkOrderFeed`는 Work Orders 또는 Field Service 활성화 필요.

`UserFeed`에서 FeedComment Object로 댓글을 작성하면 해당 User 레코드 소유자가 그 댓글을 삭제할 수 있다.

---

## 코드 예제

### Rich Text 피드 포스트 생성 (SOAP API)

```apex
// Rich text 피드 포스트 생성 — IsRichText = true + HTML 엔티티 이스케이프 필요
FeedItem post = new FeedItem();
post.ParentId = accountId;
post.Body = '<p>Rich text content with <b>bold</b> and <a href="https://example.com">link</a>.</p>';
post.IsRichText = true;
post.Type = 'TextPost';
insert post;
```

### ContentPost 생성 (파일 첨부)

```apex
// ContentPost — ContentData와 ContentFileName 필수
FeedItem filePost = new FeedItem();
filePost.ParentId = accountId;
filePost.Type = 'ContentPost';
filePost.ContentData = EncodingUtil.base64Encode(fileBlob);
filePost.ContentFileName = 'report.pdf';
insert filePost;
```

### Feed 아이템 쿼리 (최신순)

```apex
List<AccountFeed> feedItems = [
    SELECT Id, Type, Body, CreatedDate, InsertedById, LikeCount, CommentCount
    FROM AccountFeed
    WHERE ParentId = :accountId
    ORDER BY CreatedDate DESC, Id DESC
    LIMIT 50
];
```

---

## 관련 노트

- [[3 Associated Objects]] — Feed·History·Share·OwnerSharingRule·ChangeEvent 패턴 개요
- [[4 Custom Objects]] — Custom Object의 __Feed 패턴 (Custom Object Feed (__Feed))
- [[History Objects]] — 필드 변경 이력 연관 Object
- [[ChangeEventHeader]] — CDC 이벤트 헤더 상세
- [[Platform Event 발행]] — 이벤트 버스 관련
