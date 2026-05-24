---
tags: [apex, test, sosl, search]
source: apex-recipes
created: 2026-05-17
aliases: [SOSL 테스트, Test.setFixedSearchResults]
---

# SOSL 테스트 패턴

> SOSL은 테스트 환경에서 결과를 반환하지 않음. `Test.setFixedSearchResults()`로 픽스처 주입.

---

## 개념

### 왜 SOSL은 테스트에서 결과를 반환하지 않는가

SOSL(Salesforce Object Search Language)은 Salesforce의 전문 검색 인덱스(Full-Text Search Index)를 기반으로 동작한다. 이 인덱스는 레코드가 저장된 후 **비동기적으로 갱신**된다. 테스트 환경에서 `insert`로 레코드를 생성하더라도 검색 인덱스에 즉시 반영되지 않기 때문에, `FIND` 쿼리는 항상 빈 결과를 반환한다.

이는 SOQL과의 핵심 차이점이다. SOQL은 실제 데이터베이스를 직접 조회하므로 테스트에서 `insert` 직후 바로 쿼리할 수 있지만, SOSL은 별도의 인덱스를 참조하므로 테스트 격리 환경에서는 사용할 수 없다.

### 언제 이 패턴이 필요한가

다음 상황에서 `Test.setFixedSearchResults()`가 필요하다.

- 프로덕션 코드가 `[FIND ... RETURNING ...]` 구문을 사용하는 경우
- 검색 결과에 따라 분기하는 로직의 커버리지를 확보해야 하는 경우
- 검색 결과가 비어 있는 경우와 결과가 있는 경우를 모두 테스트해야 하는 경우

검색 결과가 비어 있는 케이스(아무것도 설정하지 않은 상태)는 별도로 `setFixedSearchResults`를 호출하지 않아도 자동으로 빈 결과를 반환하므로 자연스럽게 테스트된다.

---

## 문제

```apex
// SOSL은 테스트에서 빈 결과 반환 → 커버리지 누락
List<List<SObject>> results = [FIND :searchTerm IN ALL FIELDS RETURNING Account, Contact];
// results[0].size() == 0 (항상)
```

---

## 해결 — Test.setFixedSearchResults()

```apex
@IsTest
static void testSearch() {
    Account acc = new Account(Name = 'Test Corp');
    insert acc;

    // SOSL 실행 전 픽스처 설정
    Test.setFixedSearchResults(new List<Id>{ acc.Id });

    // 이제 SOSL이 위 Id 목록을 반환
    List<List<SObject>> results = [
        FIND 'Test' IN ALL FIELDS RETURNING Account(Id, Name)
    ];

    Assert.areEqual(1, results[0].size());
    Assert.areEqual('Test Corp', ((Account) results[0][0]).Name);
}
```

---

## 주의사항

- `setFixedSearchResults`는 테스트 메서드당 한 번만 설정 가능 — 동일 테스트 메서드 내에서 두 번 호출하면 마지막 설정만 유효하다
- `Id` 목록만 전달 — `RETURNING Account(Id, Name)`처럼 특정 필드를 요청하더라도, 실제 필드 값은 SOSL이 내부적으로 SOQL을 실행해 채운다. 따라서 `insert` 후 Id만 넘기면 나머지 필드는 DB에서 정상 조회된다
- 여러 오브젝트 타입 반환 시 Id 목록에 혼합 가능 — `RETURNING Account, Contact` 구문이면 Account Id와 Contact Id를 동일 목록에 넣어도 Salesforce가 타입별로 분류한다
- **Governor Limit과 무관**: SOSL 쿼리는 쿼리 실행 횟수에 포함되지만, 테스트에서 `setFixedSearchResults` 사용 시에도 동일하게 집계된다. 픽스처 데이터 주입 방식이 Limit을 우회하지는 않는다
- `@TestSetup` 내에서 `setFixedSearchResults`를 호출해도 각 테스트 메서드에서 초기화되므로 **각 테스트 메서드에서 다시 설정**해야 한다

---

## 관련 노트

- [[테스트 전략]]
- [[HttpCalloutMock]]
- [[StubProvider]]
- [[Search Namespace]] — SOSL `Search.find()` 본체 API (이 페이지는 그 테스트 픽스처 전용 분기)
