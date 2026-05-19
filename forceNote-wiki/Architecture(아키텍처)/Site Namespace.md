---
tags: [architecture, site, experience-cloud, salesforce-sites, url-rewriter, apex]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, Summer '26, p.3576–3578)
created: 2026-05-19
aliases: [Site Namespace, Site.UrlRewriter, UrlRewriter, Sites URL 재작성, Force.com Sites URL, generateUrlFor, mapRequestUrl, Site.ExternalUserCreateException]
---

# Site Namespace

> Salesforce Sites(Force.com Sites)의 URL을 사용자 친화적 주소로 재작성하는 Apex 인터페이스 — `UrlRewriter` 구현으로 SEO 최적화 및 가독성 향상.

---

## 개념

`Site` namespace는 Salesforce Sites(Force.com Sites) 환경에서 URL 재작성(URL Rewriting)을 구현하기 위한 인터페이스를 제공한다. Sites의 기본 URL은 읽기 어렵지만, UrlRewriter를 구현하면 사용자 친화적 URL로 변환할 수 있다.

**Site namespace 구성 (PDF p.3576 확인):**

| 항목 | 유형 | 설명 |
|---|---|---|
| `UrlRewriter` | Interface | Sites URL 재작성 인터페이스 |
| `Site.ExternalUserCreateException` | Exception | 외부 사용자 생성 실패 예외 |

> [!note] Site namespace는 URL 재작성 인터페이스만 포함한다. Experience Cloud 사이트 조회(`getCurrentSiteUrl`, `getBaseUrl` 등)는 `ConnectApi` 또는 `System` 네임스페이스의 별도 클래스에서 제공된다.

---

## UrlRewriter Interface

Sites URL을 사용자 친화적 URL로 변환하거나, 역방향으로 Salesforce 내부 URL로 매핑한다.

### 사용 시나리오

기본 URL 예시:
```
https://myblog.my.salesforce-sites.com/posts?id=003D000000Q0PcN
```

UrlRewriter 적용 후:
```
https://myblog.my.salesforce-sites.com/posts/my-blog-post-title
```

### 메서드 목록

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `generateUrlFor(System.PageReference[] salesforceUrls)` | `System.PageReference[]` | Salesforce URL 목록 → 사용자 친화적 URL 목록 변환 |
| `mapRequestUrl(System.PageReference userFriendlyUrl)` | `System.PageReference` | 사용자 친화적 URL → Salesforce 내부 URL 매핑 |

### generateUrlFor 시그니처

```apex
public System.PageReference[] generateUrlFor(System.PageReference[] salesforceUrls)
```

입력 배열과 출력 배열의 크기와 순서가 반드시 일치해야 한다. `generateUrlFor`는 입력 순서 기준으로 URL을 매핑한다.

### mapRequestUrl 시그니처

```apex
public System.PageReference mapRequestUrl(System.PageReference userFriendlyUrl)
```

### 구현 예시 — 블로그 슬러그 URL 재작성

```apex
// 구조 예시 — 실제 동작 코드 아님
global class BlogUrlRewriter implements Site.UrlRewriter {

    // Salesforce 내부 URL → 사용자 친화적 URL
    global System.PageReference[] generateUrlFor(
        System.PageReference[] salesforceUrls
    ) {
        System.PageReference[] friendlyUrls =
            new System.PageReference[salesforceUrls.size()];

        for (Integer i = 0; i < salesforceUrls.size(); i++) {
            PageReference sf = salesforceUrls[i];
            String postId = sf.getParameters().get('id');

            if (postId != null) {
                // 레코드에서 슬러그 조회
                Blog_Post__c post = [
                    SELECT Slug__c FROM Blog_Post__c WHERE Id = :postId LIMIT 1
                ];
                friendlyUrls[i] = new PageReference('/posts/' + post.Slug__c);
            } else {
                friendlyUrls[i] = sf; // 변환 불가 시 원본 반환
            }
        }
        return friendlyUrls;
    }

    // 사용자 친화적 URL → Salesforce 내부 URL
    global System.PageReference mapRequestUrl(System.PageReference userFriendlyUrl) {
        String path = userFriendlyUrl.getUrl();

        if (path.startsWith('/posts/')) {
            String slug = path.substringAfter('/posts/');
            Blog_Post__c post = [
                SELECT Id FROM Blog_Post__c WHERE Slug__c = :slug LIMIT 1
            ];
            return new PageReference('/apex/BlogPost?id=' + post.Id);
        }
        return null; // null 반환 시 Salesforce 기본 라우팅 사용
    }
}
```

### Sites에 UrlRewriter 등록 방법

1. `Site.UrlRewriter`를 구현한 Apex 클래스 작성
2. Setup > Sites > 해당 사이트 > URL Rewriter 필드에 클래스명 등록
3. 클래스는 `global` 또는 `public` 접근 수정자 필요

---

## Site Exceptions

`Site` namespace에는 예외 클래스가 하나 포함된다.

| 예외 | 설명 | 비고 |
|---|---|---|
| `Site.ExternalUserCreateException` | 외부 사용자(게스트/커뮤니티 사용자) 생성 실패 | 서브클래싱 및 코드에서 직접 throw 불가 |

### ExternalUserCreateException 처리

```apex
// 구조 예시 — 실제 동작 코드 아님
try {
    // 외부 사용자 생성 로직
    Site.createExternalUser(u, accountId, password);
} catch (Site.ExternalUserCreateException ex) {
    // getMessage() — 오류 메시지 반환
    // getDisplayMessages() — 사용자에게 표시할 오류 목록 반환
    List<String> displayMsgs = ex.getDisplayMessages();
    for (String msg : displayMsgs) {
        System.debug('Display Error: ' + msg);
    }
}
```

---

## UrlRewriter vs 기타 URL 관련 API 비교

| 방법 | 용도 | 네임스페이스 |
|---|---|---|
| `Site.UrlRewriter` | Sites(Force.com) URL 재작성 | `Site` |
| `ConnectApi.Communities` | Experience Cloud 사이트 정보 조회 | `ConnectApi` |
| `URL.getOrgDomainUrl()` | Org 도메인 URL 조회 | `System` |
| `System.PageReference` | Visualforce/Sites 페이지 참조 객체 | `System` |

---

## 관련 노트

- [[ConnectApi Namespace 개요]] — Experience Cloud 사이트 조회 (Communities, UserProfiles)
- [[System Namespace]] — URL.getOrgDomainUrl, URL.getSalesforceBaseUrl
- [[ConnectApi Chatter 패턴]] — Experience Cloud 커뮤니티 연동 패턴
