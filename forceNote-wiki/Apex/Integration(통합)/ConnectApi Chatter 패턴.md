---
tags: [apex, integration, chatter, connect-api, pattern]
source: automation-components/src-messaging/PostRichChatter.cls, ConnectApiHelper.cls
created: 2026-05-17
aliases: [ConnectApi, Chatter 게시, postFeedItemWithRichText, Chatter 멘션, ConnectApiHelper]
---

# ConnectApi Chatter 패턴

> Apex에서 ConnectApi 네임스페이스로 Chatter 피드를 게시하는 패턴. 리치 텍스트, @멘션, 인라인 이미지를 지원한다.

---

## 기본 구조 — postFeedItemWithRichText

```apex
// ConnectApiHelper 유틸리티 클래스 경유 (권장)
ConnectApi.FeedElement feedElement = ConnectApiHelper.postFeedItemWithRichText(
    communityId,  // String: 커뮤니티 Id, 'internal', 또는 null
    targetId,     // Id: 사용자 Id, 그룹 Id, 또는 레코드 Id
    richTextBody  // String: HTML 마크업 본문
);

Id feedItemId = feedElement.id;
```

---

## targetId 결정 — 이름 또는 Id 자동 판별

```apex
Id targetId;
try {
    targetId = Id.valueOf(input.targetNameOrId);  // Id 형식이면 바로 사용
} catch (System.StringException e) {
    // 이름인 경우 그룹 또는 사용자 검색
    List<Group> groups = [SELECT Id FROM Group WHERE Name = :name WITH USER_MODE];
    if (!groups.isEmpty()) {
        targetId = groups[0].Id;
        return;
    }
    List<User> users = [SELECT Id FROM User WHERE Username = :name WITH USER_MODE];
    if (!users.isEmpty()) {
        targetId = users[0].Id;
        return;
    }
    throw new InvalidNameException('User or Group not found: ' + name);
}
```

---

## ConnectApi 리치 텍스트 지원 HTML 태그

```apex
// ConnectApiHelper가 지원하는 태그 → ConnectApi.MarkupType 변환
Map<String, ConnectApi.MarkupType> supportedMarkup = new Map<String, ConnectApi.MarkupType> {
    'b'    => ConnectApi.MarkupType.Bold,
    'i'    => ConnectApi.MarkupType.Italic,
    'u'    => ConnectApi.MarkupType.Underline,
    's'    => ConnectApi.MarkupType.Strikethrough,
    'code' => ConnectApi.MarkupType.Code,
    'p'    => ConnectApi.MarkupType.Paragraph,
    'ol'   => ConnectApi.MarkupType.OrderedList,
    'ul'   => ConnectApi.MarkupType.UnorderedList,
    'li'   => ConnectApi.MarkupType.ListItem
};
```

---

## @멘션 포함 게시

```apex
// {UserId} 형식으로 멘션 삽입
String body = 'Hello {005xx000001Ab2c}, please review this case.';

ConnectApi.FeedElement feedElement = ConnectApiHelper.postFeedItemWithMentions(
    null,       // communityId (internal = null)
    recordId,   // 레코드 피드에 게시
    body
);
```

---

## Flow 리치 텍스트 → Chatter 변환 처리

Flow의 리치 텍스트는 Chatter와 HTML 방언이 다르다. 변환 필수 항목:

```apex
// 1. span 태그 제거 (Chatter 미지원 — 색상, 폰트 크기 등)
body = Pattern.compile('<\\/?span[^>]*>').matcher(body).replaceAll('');

// 2. 들여쓰기 클래스 제거
body = Pattern.compile(' class="ql-indent-[1-4]"').matcher(body).replaceAll('');

// 3. 이미지 태그 → 텍스트 URL로 변환
body = Pattern.compile('<img src="([^"]+)">').matcher(body).replaceAll('image: $1');
```

---

## 비교표 — Chatter 게시 방법

| 상황 | 방법 |
|---|---|
| 단순 텍스트 + 멘션 | `ConnectApiHelper.postFeedItemWithMentions()` |
| 리치 텍스트 (볼드, 목록) | `ConnectApiHelper.postFeedItemWithRichText()` |
| Flow에서 Chatter 게시 | `PostRichChatter` @InvocableMethod |
| 파일 첨부 포함 | `ConnectApi.ChatterFeeds.postFeedElement()` 직접 사용 |

---

## 주의 사항

> [!warning] ConnectApi 테스트 제한
> `ConnectApi` 메서드는 테스트에서 실제 호출 불가. `Test.setMock()` 대신
> `ConnectApi.setTestGetFeedElement()` 등 ConnectApi 전용 mock 메서드 사용.

> [!tip] 커뮤니티 게시
> `communityId` 파라미터에 Experience Cloud 사이트 Id를 전달하면 해당 커뮤니티 피드에 게시.
> 내부 org는 `null` 또는 `'internal'` 사용.

---

## 관련 노트

- [[Flow 유틸리티 액션 모음]] — PostRichChatter Invocable Action
- [[@InvocableMethod 패턴]] — Invocable Action 구조
