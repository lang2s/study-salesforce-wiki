---
tags: [apex, cache, namespace, platform-cache, cachebuilder, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — Cache Namespace (p.220~)
created: 2026-05-18
aliases: [Cache Namespace, CacheBuilder, Cache.Org, Cache.Session, Cache.OrgPartition, Cache.SessionPartition, 플랫폼 캐시 네임스페이스]
---

# Cache Namespace

> Apex에서 Platform Cache를 관리하는 클래스 모음. Org Cache(세션 무관)와 Session Cache(로그인 동안)로 구분.

---

## 클래스 목록

| 클래스/인터페이스 | 설명 |
|---|---|
| `CacheBuilder` | 캐시 미스를 안전하게 처리하는 인터페이스 |
| `Cache.Org` | Org 캐시 직접 접근 (정적 메서드) |
| `Cache.OrgPartition` | 특정 파티션의 Org 캐시 접근 (인스턴스 메서드) |
| `Cache.Session` | Session 캐시 직접 접근 (정적 메서드) |
| `Cache.SessionPartition` | 특정 파티션의 Session 캐시 접근 (인스턴스 메서드) |
| `Cache.Partition` | OrgPartition / SessionPartition의 베이스 클래스 |
| `Cache.Visibility` | 캐시 값의 네임스페이스 가시성 Enum |

---

## 캐시 키 형식

| 형식 | 설명 |
|---|---|
| `namespace.partition.key` | 완전 한정 키 |
| `key` | 기본(default) 파티션 사용 시 |
| `local.partition.key` | 네임스페이스 없는 org에서 org 네임스페이스 참조 |

> 기본 파티션 미설정 상태에서 키 미한정 호출 → `Cache.Org.OrgCacheException` 발생.

---

## CacheBuilder Interface

캐시 미스를 자동 처리하는 인터페이스. null 체크 없이 안전하게 값을 가져온다.

```apex
public class UserInfoCache implements Cache.CacheBuilder {
    public Object doLoad(String userId) {
        // 캐시 미스 시 자동 호출 — 값을 생성해 반환
        User u = [SELECT Id, IsActive, Username FROM User WHERE Id = :userId];
        return u;
    }
}

// 사용: 값이 없으면 doLoad() 자동 실행 후 캐시에 저장
User batman = (User) Cache.Org.get(UserInfoCache.class, '00541000000ek4c');
```

### doLoad(var)

```apex
public Object doLoad(String var)
```

- `var`: 캐시 값을 구분하는 케이스 센서티브 키 (고유 키의 일부로 사용)
- 반환: 캐시에 저장할 값 (적절한 타입으로 캐스트 필요)

---

## Cache.Org — Org 캐시

세션과 무관하게 org 전체에 공유되는 캐시. 모든 사용자 접근 가능.

### 핵심 메서드

```apex
// 저장
Cache.Org.put('counter', 0);
Cache.Org.put('counter', 0, 3600); // TTL 3600초

// 조회
Integer counter = (Integer) Cache.Org.get('counter');

// 존재 확인
if (Cache.Org.contains('counter')) { ... }

// 삭제
Cache.Org.remove('datetime');

// 전체 키 목록
Set<String> keys = Cache.Org.getKeys();
```

### 실전 예제 — 조건부 캐시 패턴

```apex
public class OrgCacheController {
    public void init() {
        // 없을 때만 추가
        if (!Cache.Org.contains('counter')) {
            Cache.Org.put('counter', 0);
        } else {
            Cache.Org.put('counter', (Integer)Cache.Org.get('counter') + 1);
        }

        if (!Cache.Org.contains('datetime')) {
            Cache.Org.put('datetime', DateTime.now());
        }
    }

    public void remove() {
        Cache.Org.remove('datetime');
    }
}
```

---

## Cache.Session — Session 캐시

사용자 세션 동안만 유지. 세션 만료 시 자동 삭제.

```apex
Cache.Session.put('userPref', 'dark');
String pref = (String) Cache.Session.get('userPref');
Cache.Session.remove('userPref');
Boolean exists = Cache.Session.contains('userPref');
```

---

## Cache.OrgPartition — 파티션 단위 Org 캐시

특정 파티션을 명시적으로 지정해 사용.

```apex
Cache.OrgPartition orgPart = Cache.Org.getPartition('local.myPartition');
orgPart.put('key1', 'value1');
String val = (String) orgPart.get('key1');
orgPart.remove('key1');
Boolean exists = orgPart.contains('key1');
Set<String> keys = orgPart.getKeys();
```

---

## Cache.SessionPartition — 파티션 단위 Session 캐시

```apex
Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.myPartition');
sessionPart.put('sessionKey', someObject, 900); // TTL 900초
Object val = sessionPart.get('sessionKey');
```

---

## Cache.Visibility Enum

| 값 | 설명 |
|---|---|
| `ALL` | 모든 네임스페이스에서 접근 가능 |
| `NAMESPACE` | 값을 저장한 네임스페이스 내에서만 접근 가능 |

```apex
Cache.Org.put('key', value, 300, Cache.Visibility.ALL, false);
// (key, value, ttlSecs, visibility, immutable)
```

---

## Cache.Org / Cache.Session put() 시그니처 전체

```apex
// 기본
public static void put(String key, Object value)

// TTL 지정 (초 단위)
public static void put(String key, Object value, Integer ttlSecs)

// TTL + 가시성 + 불변 여부
public static void put(String key, Object value, Integer ttlSecs,
                       Cache.Visibility visibility, Boolean immutable)
```

---

## Org Cache vs Session Cache 비교

| | Org Cache | Session Cache |
|---|---|---|
| 수명 | org 전체 (TTL 만료 전까지) | 사용자 세션 동안만 |
| 접근 범위 | 모든 사용자 | 현재 사용자 세션 |
| 사용 사례 | 공통 참조 데이터, SOQL 결과 | 사용자별 임시 상태 |
| 클래스 | `Cache.Org` / `Cache.OrgPartition` | `Cache.Session` / `Cache.SessionPartition` |

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| 반복 조회되는 설정 데이터(Custom Setting 등)를 SOQL 없이 재사용 | `Cache.Org` + `CacheBuilder` |
| 사용자 세션 동안 유지할 임시 상태(장바구니, 선택 항목 등) | `Cache.Session` |
| 여러 파티션을 운영하며 격리된 캐시 공간이 필요할 때 | `Cache.OrgPartition` / `Cache.SessionPartition` |
| 캐시 미스 시 자동 로딩 로직이 필요할 때 | `CacheBuilder` 인터페이스 구현 |

SOQL 호출이 Governor Limit에 가까워지는 트리거·배치 환경에서 가장 효과적이다. 캐시 히트 시 SOQL 카운트를 아예 소모하지 않는다.

---

## 주의사항

> [!warning] Platform Cache 사용 시 주의점
> - **캐시는 보장되지 않는다**: LRU 방식으로 용량 초과 시 무작위 삭제. 캐시 히트를 가정한 비즈니스 로직은 금지. 항상 미스 핸들러를 작성한다.
> - **직렬화 가능한 타입만 저장 가능**: `Cache.Org.put()`에 넣을 수 있는 값은 `Cacheable`(직렬화 가능) 타입만. SObject는 기본 지원되지만 Apex 커스텀 타입은 `Cache.CacheBuilder` 또는 JSON 변환 후 저장.
> - **기본 파티션 미설정 에러**: 파티션을 설정하지 않은 상태에서 단순 키(namespace 없이)로 접근하면 `Cache.Org.OrgCacheException` 발생. Setup > Platform Cache > Default Partition 설정 필수.
> - **TTL 기본값**: `put(key, value)` 호출 시 TTL을 지정하지 않으면 기본값 86400초(24시간). 짧은 TTL이 필요한 데이터는 명시적으로 지정.
> - **Session Cache는 Batch에서 사용 불가**: Batch Apex는 사용자 세션 컨텍스트가 없으므로 `Cache.Session`에 접근 시 예외 발생.

---

## 관련 노트

- [[Platform Cache]] — 패턴 중심 사용 가이드 (CacheBuilder, Cache-Aside 패턴)
