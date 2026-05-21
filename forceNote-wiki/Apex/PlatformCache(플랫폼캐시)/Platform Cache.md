---
tags: [apex, cache, platform-cache, performance, pattern]
source: apex-recipes/PlatformCacheRecipes.cls
created: 2026-05-17
aliases: [Platform Cache, Cache.Org, Cache.Session, 플랫폼 캐시]
---

# Platform Cache

> 세션/조직 수준의 인메모리 캐시. 반복 SOQL 쿼리, 설정값, 외부 API 응답을 캐싱해 Governor Limit과 응답 속도를 개선.

---

## 개념

Apex는 동기 트랜잭션당 SOQL 100회, CPU 10초 등 Governor Limit이 있다. 동일한 설정값이나 참조 데이터를 요청마다 SOQL로 쿼리하면 이 한도를 빠르게 소진한다. Platform Cache는 이 문제를 해결하는 Salesforce의 **인메모리 키-값 저장소**다.

트랜잭션 간에는 Apex 메모리가 공유되지 않으므로(각 트랜잭션은 독립 컨텍스트), 외부 인메모리 캐시가 필요하다. Platform Cache는 Salesforce 인프라에서 제공하는 캐시이기 때문에 Redis나 Memcached 같은 외부 서비스 없이 설정만으로 사용할 수 있다.

주요 사용 시나리오는 두 가지다. 첫째, 거의 변하지 않는 설정값(Custom Setting, Custom Metadata, 특정 SOQL 집계)을 캐시해 반복 쿼리를 제거한다. 둘째, 외부 API 응답처럼 원격 호출 비용이 큰 데이터를 단기 캐시해 callout 횟수를 줄인다.

---

## Org Cache vs Session Cache

| | Org Cache | Session Cache |
|---|---|---|
| 범위 | 전체 조직 (모든 사용자) | 현재 사용자 세션 |
| TTL | 최대 172,800초 (48시간) | 세션 만료까지 |
| 사용 | 설정값, 공통 참조 데이터 | 사용자별 임시 데이터 |
| 클래스 | `Cache.Org` | `Cache.Session` |

---

## 기본 사용법

```apex
// Org Cache 파티션 가져오기
Cache.OrgPartition partition = Cache.Org.getPartition('local.MyPartition');

// 값 저장 (TTL: 3600초 = 1시간)
partition.put('accountSettings', mySettings, 3600);

// 값 조회
Object cached = partition.get('accountSettings');
if (cached != null) {
    AccountSettings settings = (AccountSettings) cached;
}

// 키 존재 여부
Boolean exists = partition.contains('accountSettings');

// 삭제
partition.remove('accountSettings');
```

---

## 캐시-어사이드 패턴 (Cache-Aside)

```apex
// 조회 → 없으면 로드 → 저장
public static AccountSettings getSettings() {
    Cache.OrgPartition part = Cache.Org.getPartition('local.AppCache');
    final String CACHE_KEY = 'accountSettings';

    AccountSettings settings = (AccountSettings) part.get(CACHE_KEY);
    if (settings == null) {
        // 캐시 미스 → 소스에서 로드
        settings = loadSettingsFromSoql();
        part.put(CACHE_KEY, settings, 3600); // 1시간 캐싱
    }
    return settings;
}

private static AccountSettings loadSettingsFromSoql() {
    AppSettings__c raw = [
        SELECT ... FROM AppSettings__c LIMIT 1
    ];
    return new AccountSettings(raw);
}
```

---

## 캐시 무효화 패턴

```apex
// 설정 변경 시 캐시 제거
public static void invalidateSettingsCache() {
    Cache.OrgPartition part = Cache.Org.getPartition('local.AppCache');
    part.remove('accountSettings');
}

// 또는 Trigger에서 자동 무효화
trigger AppSettingsTrigger on AppSettings__c (after insert, after update, after delete) {
    CacheService.invalidateSettingsCache();
}
```

---

## @CacheBuilder 인터페이스 (자동 갱신)

```apex
// 더 선언적인 캐시 패턴
public class AccountSettingsBuilder implements Cache.CacheBuilder {
    public Object doLoad(String key) {
        return loadSettingsFromSoql(); // 캐시 미스 시 자동 호출
    }
}

// 사용 — get() 호출 시 자동으로 doLoad() 실행
AccountSettings settings = (AccountSettings)
    Cache.Org.get(AccountSettingsBuilder.class, 'accountSettings');
```

---

## TTL 전략

| 데이터 유형 | 권장 TTL |
|---|---|
| 설정값 (잘 변하지 않음) | 3600–86400초 (1시간~1일) |
| 참조 데이터 | 1800–3600초 |
| API 응답 | 300–900초 (5~15분) |
| 사용자 세션 데이터 | Session Cache 사용 |

---

## Cache Partition 설정

> [!warning] 사전 설정 필요
> Platform Cache 사용 전 Setup → Platform Cache에서 Partition을 생성해야 함.
> - 이름: `local.MyPartition`
> - Developer Edition: 0MB (코드 컴파일만, 실제 캐싱 불가)
> - Sandbox/Production: 설정한 용량만큼 사용 가능

---

## 제한사항 및 주의사항

- **Developer Edition 0MB 제한** — Developer Edition 조직은 Platform Cache 용량이 0MB이다. 파티션을 생성할 수 있지만 실제 데이터는 저장되지 않고 `partition.get()`은 항상 `null`을 반환한다. Sandbox나 Production에서만 실제 동작을 검증할 수 있다.
- **Cacheable 타입 제한** — `Blob`, `PageReference`, `SObject` 직접 저장은 지원되지 않는다. SObject를 캐시하려면 JSON 직렬화 후 `String`으로 저장한다.
- **파티션 용량 초과 시 자동 축출** — 파티션이 가득 차면 LRU(Least Recently Used) 방식으로 오래된 항목이 자동 삭제된다. TTL이 남아있어도 공간 부족 시 삭제될 수 있다.
- **캐시 일관성은 직접 관리** — 소스 데이터(SOQL, 외부 API)가 변경돼도 캐시는 자동으로 무효화되지 않는다. 캐시 무효화 로직을 트리거나 비즈니스 레이어에서 명시적으로 구현해야 한다.
- **테스트 고려** — `@isTest`에서 `Cache.Org.getPartition()`은 실제 파티션에 접근하지 않는다. 테스트 컨텍스트에서는 별도 모킹 전략이 필요하다.

## 관련 노트

- [[SOQL 패턴]] — 반복 쿼리 최적화
- [[Cache Namespace]] — Cache.Org/Partition/Session 메서드 전체
- [[비동기 컨텍스트 선택]]

