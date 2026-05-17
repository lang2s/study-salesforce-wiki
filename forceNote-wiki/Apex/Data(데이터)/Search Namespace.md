---
tags: [apex, search, namespace, sosl, dynamic-sosl, suggest, search-result, knowledge]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Search Namespace, Search.find, SOSL Apex, dynamic SOSL, Search.suggest, SearchResult, SuggestionResult, KnowledgeSuggestionFilter]
---

# Search Namespace

> Apex에서 SOSL 검색 결과를 처리하고 검색 제안(autocomplete)을 구현하는 API.

---

## Search.find() — 동적 SOSL 실행

```apex
// 기본 동적 SOSL
String searchTerm = 'Salesforce';
String query = 'FIND \'' + String.escapeSingleQuotes(searchTerm) +
    '\' IN ALL FIELDS RETURNING Account(Id, Name), Contact(Id, Name, Email)';

Search.SearchResults results = Search.find(query);

// 오브젝트별 결과 추출
List<Search.SearchResult> accountResults = results.get('Account');
List<Search.SearchResult> contactResults = results.get('Contact');

for (Search.SearchResult sr : accountResults) {
    Account acc = (Account) sr.getSObject();
    System.debug(acc.Name);
}
```

---

## SearchResult — 검색 결과 래퍼

```apex
List<Search.SearchResult> searchResults = results.get('Account');

for (Search.SearchResult sr : searchResults) {
    SObject record = sr.getSObject();                // 레코드 sObject
    String snippet = sr.getSnippet();                // 기본 필드 스니펫
    String caseSnippet = sr.getSnippet('Case.Casenumber');  // 필드 지정 스니펫
    // 유효한 필드: Case.Casenumber, FeedPost.Title, KnowledgeArticleVersion.Title
}
```

---

## SearchResults — 결과 컨테이너

```apex
Search.SearchResults results = Search.find(query);

// 특정 오브젝트 결과 가져오기
List<Search.SearchResult> accountResults = results.get('Account');
// 결과가 없으면 빈 리스트 반환 (null 아님)
```

---

## Search.suggest() — 검색 제안 (Autocomplete)

```apex
// 레코드 제안 — 사용자가 입력 중인 텍스트로 관련 레코드 제안
Search.SuggestionOption opts = new Search.SuggestionOption();
opts.setLimit(10);  // 기본값 5, 최대 반환 수 조정

Search.SuggestionResults suggResults =
    Search.suggest('acme', 'Account', opts);

for (Search.SuggestionResult sr : suggResults.getSuggestionResults()) {
    Account acc = (Account) sr.getSObject();
    System.debug(acc.Name);
}

// 더 많은 결과가 있는지 확인
if (suggResults.hasMoreResults()) {
    // limit을 늘려서 다시 조회 가능
}
```

---

## Knowledge Article 제안 — KnowledgeSuggestionFilter

```apex
// Knowledge Article 전용 필터 설정
Search.KnowledgeSuggestionFilter filter = new Search.KnowledgeSuggestionFilter();
filter.setLanguage('en_US');                // 필수 — 언어 코드
filter.setPublishStatus('Online');          // 필수 — Draft | Online | Archived
filter.setChannel('App');                   // 선택 — App | Pkb | Csp | Prm | AllChannels
filter.addArticleType('ka0');               // 선택 — 아티클 타입 ID 접두어
filter.addDataCategory('Products', 'All'); // 선택 — 데이터 카테고리 필터

Search.SuggestionOption opts = new Search.SuggestionOption();
opts.setFilter(filter);
opts.setLimit(5);

Search.SuggestionResults results =
    Search.suggest('error', 'KnowledgeArticleVersion', opts);

for (Search.SuggestionResult sr : results.getSuggestionResults()) {
    KnowledgeArticleVersion article = (KnowledgeArticleVersion) sr.getSObject();
    System.debug(article.Title);
}
```

---

## Chatter 질문 제안 — QuestionSuggestionFilter

```apex
Search.QuestionSuggestionFilter qFilter = new Search.QuestionSuggestionFilter();
qFilter.addGroupId(groupId);         // 선택 — Chatter 그룹 필터
qFilter.addNetworkId(networkId);     // 선택 — Experience Cloud 네트워크 필터
qFilter.addUserId(userId);           // 선택 — 특정 사용자 질문 필터

Search.SuggestionOption opts = new Search.SuggestionOption();
opts.setFilter(qFilter);

Search.SuggestionResults results =
    Search.suggest('how to', 'FeedItem', opts);
```

---

## SOSL 인젝션 방어

```apex
// 반드시 escapeSingleQuotes 사용
String userInput = 'test\'s company';
String safeInput = String.escapeSingleQuotes(userInput);
String query = 'FIND \'' + safeInput + '\' IN ALL FIELDS RETURNING Account';
Search.SearchResults results = Search.find(query);

// 테스트에서 SOSL 결과 고정
@IsTest
static void testSearch() {
    Account acc = new Account(Name = 'Test Account');
    insert acc;
    Test.setFixedSearchResults(new List<Id>{ acc.Id });

    Search.SearchResults results = Search.find(
        'FIND \'Test\' IN ALL FIELDS RETURNING Account'
    );
    List<Search.SearchResult> accResults = results.get('Account');
    System.assertEquals(1, accResults.size());
}
```

---

## 비교표 — SOSL 방식 선택

| 방식 | 구문 | 결과 타입 | 용도 |
|---|---|---|---|
| 인라인 SOSL | `[FIND 'term' ...]` | `List<List<SObject>>` | 정적 검색 |
| `Search.find()` | 문자열 쿼리 | `Search.SearchResults` | 동적 검색 |
| `Search.suggest()` | 검색어 + 오브젝트 | `Search.SuggestionResults` | 자동완성/제안 |

### 인라인 SOSL vs Search.find() 결과 처리

```apex
// 인라인 SOSL — List<List<SObject>> 반환
List<List<SObject>> inline = [
    FIND 'Acme' IN ALL FIELDS RETURNING Account, Contact
];
List<Account> accts = (List<Account>) inline[0];
List<Contact> cons  = (List<Contact>) inline[1];

// Search.find() — SearchResults 래퍼 반환 (오브젝트 이름으로 접근)
Search.SearchResults dynamic = Search.find(
    'FIND \'Acme\' IN ALL FIELDS RETURNING Account, Contact'
);
List<Search.SearchResult> acctResults = dynamic.get('Account');
```

---

## SuggestionOption 메서드

| 메서드 | 설명 |
|---|---|
| `setLimit(Integer)` | 반환 최대 건수 (기본 5) |
| `setFilter(KnowledgeSuggestionFilter)` | Knowledge 필터 설정 |
| `setFilter(QuestionSuggestionFilter)` | Chatter Question 필터 설정 |

## SuggestionResults 메서드

| 메서드 | 설명 |
|---|---|
| `getSuggestionResults()` | `List<SuggestionResult>` |
| `hasMoreResults()` | 추가 결과 존재 여부 (limit 초과 시 true) |

---

## 관련 노트

- [[SOQL 패턴]] — 정적/동적 SOQL (SELECT 기반 검색)
- [[Dynamic SOQL]] — `Database.queryWithBinds`, SOQL 인젝션 방어
- [[SOSL 테스트 패턴]] — `Test.setFixedSearchResults` 상세
