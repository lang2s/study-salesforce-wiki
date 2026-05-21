---
tags: [apex, soql, dynamic, security, injection, pattern]
source: apex-recipes/DynamicSOQLRecipes.cls
created: 2026-05-17
aliases: [동적 SOQL, SOQL 인젝션]
---

# Dynamic SOQL

> 사용자 입력이 포함된 동적 SOQL의 안전한 작성법. `Database.queryWithBinds`가 핵심.

---

## 개념

### Dynamic SOQL이란

정적 SOQL(`[SELECT Id FROM Account]`)은 컴파일 타임에 구문이 확정된다. 반면 Dynamic SOQL은 **런타임에 문자열로 SOQL을 조립**해 `Database.query()` 등으로 실행한다.

Dynamic SOQL이 필요한 상황:
- 쿼리 대상 오브젝트 타입을 런타임에 결정해야 할 때
- 사용자가 선택한 필드 목록에 따라 SELECT 절이 변해야 할 때
- 조건(WHERE 절)의 유무나 구조 자체가 동적으로 결정될 때
- Tooling API, Metadata API처럼 정적 SOQL이 지원하지 않는 오브젝트를 대상으로 할 때

### 왜 위험한가 — SOQL Injection

Dynamic SOQL의 가장 큰 위험은 **SOQL Injection**이다. 사용자 입력을 그대로 SOQL 문자열에 연결하면, 악의적인 사용자가 쿼리 구조 자체를 변경할 수 있다. 예를 들어 `Name = 'x' OR 1=1 --` 형태의 입력은 WHERE 절을 무력화해 모든 레코드를 반환하게 만든다.

SQL Injection과 동일한 원리지만, Salesforce 내부 데이터를 대상으로 한다는 점에서 레코드 유출, 공유 규칙 우회, 권한 없는 필드 조회 등의 피해로 이어질 수 있다.

### 안전한 작성의 핵심 원칙

1. **사용자 입력은 반드시 bind 변수로** — `queryWithBinds`의 bindMap 또는 정적 SOQL의 `:변수명` 구문을 사용
2. **WHERE 절 구조 자체를 사용자가 제어하게 하지 않는다** — 값은 bind로, 절 구조는 코드에서 화이트리스트로 관리
3. **숫자형 파라미터는 타입캐스팅으로 방어** — `Integer.valueOf(input)`으로 숫자로 강제 변환
4. **`String.escapeSingleQuotes()`만으로는 부족하다** — 따옴표 이스케이프는 문자열 값에만 유효하며, 숫자 비교나 절 구조 변조에는 효과 없음

---

## 결정 기준

| 상황 | 사용 패턴 |
|---|---|
| 정적 쿼리 문자열, 입력값 없음 | `Database.query(string, AccessLevel)` |
| 사용자 입력이 WHERE 절 값으로 사용 | `Database.queryWithBinds(string, bindMap, AccessLevel)` |
| WHERE 절 자체를 동적 구성 | `QuiddityGuard` 신뢰 컨텍스트 검증 필수 |

---

## 패턴 1: Database.queryWithBinds (표준 권장)

```apex
// ✅ 사용자 입력 → bindMap으로 안전하게 바인딩
public static List<Account> getByName(String name) {
    String queryString = 'SELECT Id, Name FROM Account WHERE Name = :name WITH USER_MODE';
    Map<String, Object> binds = new Map<String, Object>{ 'name' => name };
    return Database.queryWithBinds(queryString, binds, AccessLevel.USER_MODE);
}

// bindMap 키 = 쿼리 내 :변수명과 정확히 일치해야 함
Map<String, Object> binds = new Map<String, Object>{
    'name'   => name,
    'limit'  => 100
};
String q = 'SELECT Id FROM Account WHERE Name LIKE :name LIMIT :limit';
return Database.queryWithBinds(q, binds, AccessLevel.USER_MODE);
```

---

## 패턴 2: Database.query + AccessLevel (입력값 없는 동적 쿼리)

```apex
// ✅ WHERE 절에 사용자 입력 없음 — 구조만 동적
public static List<SObject> getRecentRecords(String objectType) {
    String queryString = 'SELECT Id, Name FROM ' + objectType
        + ' ORDER BY CreatedDate DESC LIMIT 10';
    return Database.query(queryString, AccessLevel.USER_MODE);
}
```

---

## 패턴 3: 숫자 파라미터 — 타입캐스트로 방어

```apex
// ✅ Integer.valueOf()로 숫자 타입 강제 → 문자열 인젝션 불가
public static List<Account> getLargeAccounts(String numberOfRecords) {
    String queryString = 'SELECT Id, Name FROM Account '
        + 'WHERE NumberOfEmployees > '
        + String.valueOf(Integer.valueOf(numberOfRecords)); // 타입캐스트 방어
    return Database.query(queryString, AccessLevel.USER_MODE);
}

// ❌ String.escapeSingleQuotes는 숫자 비교에 무효
// 'WHERE NumberOfEmployees > ' + String.escapeSingleQuotes(numberOfRecords)
// → '100 OR 1=1' 같은 인젝션에 취약
```

---

## 패턴 4: WHERE 절 동적 구성 시 QuiddityGuard 필수

```apex
// 사용자가 WHERE 절을 직접 제어하는 위험한 상황
public static List<Account> dynamicWhere(String whereClause) {
    // ✅ 신뢰할 수 없는 컨텍스트(AURA, REST, VF 등)에서 즉시 반환
    if (!QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities)) {
        return new List<Account>();
    }

    // 신뢰된 컨텍스트(SYNCHRONOUS, QUEUEABLE, BATCH_APEX)에서만 실행
    return Database.query(
        'SELECT Id, Name FROM Account WHERE ' + whereClause,
        AccessLevel.USER_MODE
    );
}
```

---

## ❌ 절대 하지 말아야 할 것

```apex
// ❌ 문자열 직접 연결 — SOQL 인젝션 위험
String query = 'SELECT Id FROM Account WHERE Name = \'' + userInput + '\'';

// ❌ escapeSingleQuotes만으로 충분하지 않은 경우 있음
String escaped = String.escapeSingleQuotes(userInput);
// → 숫자 필드, LIMIT 절 등에는 효과 없음
```

---

## 관련 노트

- [[SOQL 패턴]]
- [[QuiddityGuard]]
- [[WITH USER_MODE]]
