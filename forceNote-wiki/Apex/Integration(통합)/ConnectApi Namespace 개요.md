---
tags: [apex, integration, connect-api, chatter, community, namespace, reference]
source: salesforce_apex_reference_guide.pdf (Version 67.0, Summer '26) p.663
created: 2026-05-18
aliases: [ConnectApi, Connect in Apex, ConnectApi Namespace, 커넥트API, 커넥트 인 Apex]
---

# ConnectApi Namespace 개요

> Connect in Apex (ConnectApi 네임스페이스)는 Connect REST API와 동일한 데이터에 Apex로 접근하는 인터페이스. Chatter, Experience Cloud, Commerce, Einstein LLM, Data Cloud 등 광범위한 Salesforce 기능을 Apex에서 직접 호출할 수 있다.

---

## 네임스페이스 특성

- 모든 메서드는 클래스의 **정적 메서드**로 호출 (`ConnectApi.ChatterFeeds.postFeedElement(...)`)
- `communityId` 파라미터: Experience Cloud 사이트 ID, `'internal'`, 또는 `null` (내부 org)
- Chatter 관련 메서드는 **Chatter 활성화 필수**
- 각 메서드에는 per user / per namespace / per hour **rate limit** 적용
- 테스트에서는 `setTest*` 메서드로 mock 데이터를 주입해야 함 (실제 API 호출 불가)

---

## 주요 클래스 목록

### Chatter 관련

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.ChatterFeeds` | 피드 게시·조회·삭제·좋아요·댓글·검색 |
| `ConnectApi.ChatterGroups` | 그룹 정보·멤버 관리·사진 변경 |
| `ConnectApi.ChatterUsers` | 사용자 프로필·팔로워·구독·파일·그룹 |
| `ConnectApi.ChatterFavorites` | Chatter 즐겨찾기 |
| `ConnectApi.ChatterMessages` | 프라이빗 메시지 전송·검색·읽음 처리 |
| `ConnectApi.Mentions` | @멘션 정보 조회 |
| `ConnectApi.Topics` | 토픽 생성·갱신·병합·레코드 연결 |

### Experience Cloud (Community)

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.Communities` | Experience Cloud 사이트 정보 조회 |
| `ConnectApi.CommunityModeration` | 플래그된 피드 아이템·댓글 관리 |
| `ConnectApi.ManagedContent` | 관리 콘텐츠 생성·게시·삭제·DAM 연동 |
| `ConnectApi.ManagedTopics` | 사이트 관리 토픽 설정 |
| `ConnectApi.NavigationMenu` | 사이트 네비게이션 메뉴 조회 |
| `ConnectApi.Sites` | 사이트 내 검색 |

### Commerce (Order Management)

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.CommerceCart` | 장바구니 CRUD, 아이템 추가/삭제 |
| `ConnectApi.CommerceCatalog` | 상품·카테고리 조회 |
| `ConnectApi.CommerceSearch` | 상품 검색, 정렬 규칙 |
| `ConnectApi.OrderSummary` | 주문 처리 |
| `ConnectApi.Payments` | 결제 승인·캡처·환불 |
| `ConnectApi.FulfillmentOrder` | 주문 이행 |

### Einstein / AI

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.EinsteinLLM` | 프롬프트 템플릿 목록 조회, LLM 응답 생성 |
| `ConnectApi.NextBestAction` | 추천 전략 실행, 추천 항목 조회/반응 |
| `ConnectApi.SmartDataDiscovery` | Salesforce 오브젝트 예측 |

### Data Cloud (CDP)

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.CdpQuery` | Data Cloud 메타데이터 조회 및 데이터 쿼리 |
| `ConnectApi.CdpSegment` | 세그먼트 CRUD·게시 |
| `ConnectApi.CdpCalculatedInsight` | 계산 인사이트 CRUD·실행 |
| `ConnectApi.CdpIdentityResolution` | ID 해석 룰셋 CRUD·실행 |

### 기타

| 클래스 | 핵심 기능 |
|---|---|
| `ConnectApi.ActionLinks` | 피드 액션 링크 그룹 정의 생성·조회 |
| `ConnectApi.NamedCredentials` | Named Credential·External Credential CRUD |
| `ConnectApi.Search` | 키워드·자연어 검색 |
| `ConnectApi.Surveys` | 설문 초대장 이메일 발송 |
| `ConnectApi.FlowApprovalProcesses` | Flow 승인 프로세스 상태·가용 액션 조회 |

---

## 코드 패턴 — Chatter 피드 게시

```apex
// 1. 단순 텍스트 게시 (가장 간단)
ConnectApi.FeedElement feedEl = ConnectApi.ChatterFeeds.postFeedElement(
    Network.getNetworkId(),  // communityId (내부 org는 null)
    recordId,                // subjectId: 레코드 피드에 게시
    ConnectApi.FeedElementType.FeedItem,
    'Hello from Apex!'       // 텍스트
);

// 2. 리치 텍스트 + @멘션 게시 (FeedItemInput 사용)
ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

// 텍스트 세그먼트
ConnectApi.TextSegmentInput textSeg = new ConnectApi.TextSegmentInput();
textSeg.text = 'Check this record: ';
body.messageSegments.add(textSeg);

// @멘션 세그먼트
ConnectApi.MentionSegmentInput mentionSeg = new ConnectApi.MentionSegmentInput();
mentionSeg.id = userId;  // User ID
body.messageSegments.add(mentionSeg);

feedItemInput.body = body;
feedItemInput.subjectId = recordId;

ConnectApi.FeedElement result = ConnectApi.ChatterFeeds.postFeedElement(
    null,          // communityId null = 내부 org
    feedItemInput
);
```

---

## 코드 패턴 — EinsteinLLM 응답 생성

```apex
// 프롬프트 템플릿 기반 LLM 응답 생성
ConnectApi.EinsteinLLMGenerateMessagesInput input = new ConnectApi.EinsteinLLMGenerateMessagesInput();
input.promptTemplateDeveloperName = 'My_Prompt_Template';
// 추가 입력 변수가 있으면 additionalBindings 설정

ConnectApi.EinsteinLLMGenerateMessagesOutput output =
    ConnectApi.EinsteinLLM.generateMessages(input);

String responseText = output.generations[0].text;
```

---

## 테스트 패턴

```apex
// ConnectApi 메서드는 테스트에서 실제 호출 불가.
// 각 get* 메서드에는 짝이 되는 setTest* 메서드가 존재한다.

@IsTest
static void testPostFeedElement() {
    // 테스트용 FeedItem 결과 객체 생성
    ConnectApi.FeedItem mockFeedItem = new ConnectApi.FeedItem();
    mockFeedItem.id = '0D5xx000000xxxxx';

    // setTestPostFeedElement로 mock 주입
    ConnectApi.ChatterFeeds.setTestPostFeedElement(
        null,                                   // communityId
        ConnectApi.FeedElementType.FeedItem,    // feedElementType
        mockFeedItem                            // 반환될 결과
    );

    // 실제 호출 — mock이 반환됨
    ConnectApi.FeedElement result = ConnectApi.ChatterFeeds.postFeedElement(
        null, recordId, ConnectApi.FeedElementType.FeedItem, 'test'
    );
    System.assertEquals('0D5xx000000xxxxx', result.id);
}
```

> [!warning] ConnectApi 테스트 제약
> - `setTest*` 메서드 없이 `@IsTest` 내에서 ConnectApi 실제 호출 시 예외 발생
> - `setTest*` 메서드는 호출할 `get*`/`post*` 메서드 인자와 동일한 인자로 매핑해야 함
> - `ConnectApi.ConnectUtilities.unwrapApexWrapper(obj)` — Apex debug에서 `ApexMapWrapper@...` 타입으로 출력되는 중첩 객체를 `Map<String, Object>`로 언래핑

---

## 비교 — ConnectApi vs Connect REST API vs SOQL

| | ConnectApi (Apex) | Connect REST API | SOQL |
|---|---|---|---|
| 호출 위치 | Apex 서버 | 외부 시스템/브라우저 | Apex/SOQL 쿼리 |
| Chatter 게시 | `ChatterFeeds.postFeedElement` | `POST /chatter/feeds/record/{id}` | 불가 |
| 피드 조회 | `ChatterFeeds.getFeedElementsFromFeed` | `GET /chatter/feeds/...` | FeedItem SOQL (제한적) |
| 멘션 포함 | 지원 | 지원 | 불가 |
| 테스트 용이성 | setTest* mock | HTTP Mock 필요 | 쿼리 결과 직접 |

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| Apex 코드에서 Chatter 피드에 게시·@멘션·댓글을 처리해야 할 때 | `ConnectApi.ChatterFeeds` |
| Experience Cloud 사이트 콘텐츠를 Apex에서 관리할 때 | `ConnectApi.ManagedContent`, `ConnectApi.Sites` |
| Einstein/LLM 프롬프트 템플릿 결과를 Apex에서 소비할 때 | `ConnectApi.EinsteinLLM` |
| Data Cloud 세그먼트·인사이트를 Apex에서 읽거나 실행할 때 | `ConnectApi.CdpSegment`, `ConnectApi.CdpCalculatedInsight` |
| Named Credential·External Credential을 Apex로 프로그래밍 방식 관리 | `ConnectApi.NamedCredentials` |
| Connect REST API 동작을 Apex 서버에서 직접 수행해야 할 때 | ConnectApi (HTTP Callout 없이 동일 효과) |

SOQL로 접근하기 어려운 Chatter/Community/Commerce 데이터를 Apex에서 읽거나 쓸 때, 외부 HTTP 호출 없이 ConnectApi를 사용하면 코드가 단순해지고 Governor Limit 관리도 쉬워진다.

---

## 관련 노트

- [[ConnectApi Chatter 패턴]] — postFeedItemWithRichText, @멘션, Flow 리치 텍스트 변환 상세
- [[Platform Event 통합 패턴]] — 이벤트 기반 시스템 간 통합
- [[Custom REST Endpoint]] — @RestResource, inbound REST 패턴
