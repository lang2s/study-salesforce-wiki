---
tags: [apex, collection, sort, comparator, pattern]
source: apex-recipes/CollectionUtils.cls
created: 2026-05-17
aliases: [Comparator, 정렬, 커스텀 소트]
---

# Comparator 인터페이스

> `Comparator<T>` 구현으로 `List.sort(comparator)`에 커스텀 정렬 로직을 주입. API 55.0 (Summer '22)부터 지원. `Comparable`을 구현할 수 없는 외부 타입 정렬에 유용.

---

## 기본 구현

```apex
// 문자열 대소문자 무시 정렬
public class CaseInsensitiveComparator implements Comparator<String> {
    public Integer compare(String a, String b) {
        return a.toLowerCase().compareTo(b.toLowerCase());
    }
}

List<String> names = new List<String>{ 'Banana', 'apple', 'Cherry' };
names.sort(new CaseInsensitiveComparator());
// 결과: ['apple', 'Banana', 'Cherry']
```

---

## compare() 반환값 규칙

| 반환값 | 의미 |
|---|---|
| 음수 (`< 0`) | a가 b보다 앞에 와야 함 |
| `0` | 같음 (순서 무관) |
| 양수 (`> 0`) | a가 b보다 뒤에 와야 함 |

---

## SObject 복잡한 정렬

```apex
// Account를 Revenue 내림차순, 같으면 Name 오름차순
public class AccountComparator implements Comparator<Account> {
    public Integer compare(Account a, Account b) {
        // 내림차순: b - a
        if (a.AnnualRevenue != b.AnnualRevenue) {
            Decimal diff = (b.AnnualRevenue ?? 0) - (a.AnnualRevenue ?? 0);
            return diff > 0 ? 1 : -1;
        }
        // 이름 오름차순 (null 안전)
        String nameA = a.Name ?? '';
        String nameB = b.Name ?? '';
        return nameA.compareTo(nameB);
    }
}

List<Account> accounts = [SELECT Id, Name, AnnualRevenue FROM Account];
accounts.sort(new AccountComparator());
```

---

## 람다 스타일 (익명 클래스 패턴)

```apex
// 재사용이 필요 없을 때 — 인라인 구현
List<Opportunity> opps = [SELECT Id, Amount FROM Opportunity];
opps.sort(new Comparator<Opportunity>() {
    public Integer compare(Opportunity a, Opportunity b) {
        Decimal diff = (a.Amount ?? 0) - (b.Amount ?? 0);
        return diff > 0 ? 1 : diff < 0 ? -1 : 0;
    }
});
```

---

## Comparable vs Comparator

| | Comparable | Comparator |
|---|---|---|
| 구현 위치 | 정렬 대상 클래스 내 | 별도 클래스 |
| 정렬 기준 | 단일 (클래스에 내장) | 다중 (여러 Comparator 적용) |
| 외부 타입 정렬 | ❌ | ✅ |
| API 버전 | 오래됨 | API 55.0+ |

---

## 실전 예: 우선순위 기반 정렬

```apex
// 상태별 우선순위 정렬 (closed → open → other)
public class CaseStatusComparator implements Comparator<Case> {

    private static Map<String, Integer> priority = new Map<String, Integer>{
        'Closed' => 2,
        'Open'   => 1,
        'New'    => 0
    };

    public Integer compare(Case a, Case b) {
        Integer pa = priority.get(a.Status) ?? -1;
        Integer pb = priority.get(b.Status) ?? -1;
        return pa - pb;
    }
}
```

---

## Collator 클래스 — 로케일 인식 문자열 정렬 *(Winter '24 추가)*

`Collator`는 로케일에 따라 문자열을 정렬한다. 한국어·일본어 등 다국어 데이터를 올바르게 정렬할 때 사용.

```apex
// 현재 사용자 로케일 기준 정렬
Collator col = Collator.getInstance();

List<String> names = new List<String>{ '나', '가', '다' };
names.sort(col);
// 로케일에 따라 올바른 가나다 순으로 정렬

// 대소문자 무시 비교
col.setStrength(Collator.SECONDARY);
Integer result = col.compare('apple', 'APPLE'); // 0 (같음)
```

`Collator.Strength` 상수:
| 상수 | 의미 |
|---|---|
| `PRIMARY` | 기본 글자 차이만 구분 (a ≠ b, a = á) |
| `SECONDARY` | 악센트 차이 구분 (a = A, a ≠ á) |
| `TERTIARY` | 대소문자 구분 (기본값, a ≠ A) |
| `IDENTICAL` | 완전 일치만 같음으로 처리 |

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| SObject 리스트를 단일 필드 기준으로 정렬 | `List.sort()` + `Comparator` 구현 |
| 복합 기준 정렬 (1차: 금액 내림차순, 2차: 이름 오름차순) | `compare()` 내부에서 다단계 조건 작성 |
| 한국어·다국어 문자열을 유니코드 순이 아닌 자연 순으로 정렬 | `Collator` 조합 |
| 런타임에 정렬 기준을 동적으로 바꿔야 할 때 | `Comparator` 구현 클래스를 교체 |

Winter '24 이전에는 `SObject.getSObjectType().getDescribe()`를 이용한 수동 비교나 Map 기반 임시방편이 필요했다. `Comparator` 도입 후 람다 스타일의 단일 메서드 구현으로 대체 가능하다.

---

## 주의사항

> [!warning] Comparator 구현 시 주의점
> - **null 처리 필수**: `compare()` 메서드에서 두 인자 중 하나가 null이면 NullPointerException 발생. 방어적 null 체크가 필요하다.
> - **삼항 규칙 준수**: `compare(a, b)`가 음수면 a < b, 0이면 같음, 양수면 a > b. 반환값을 Boolean처럼 0/1로만 반환하면 정렬이 불안정해진다.
> - **동등성 일관성**: `compare(a, b) == 0`일 때 `a.equals(b)`와 일관되지 않으면 Set·Map에서 예측 불가 동작 발생.
> - **Collator는 별도 인스턴스**: `Collator.getInstance()`를 매 `compare()` 호출마다 생성하면 성능 저하. 인스턴스를 필드로 캐싱한다.

---

## 관련 노트

- [[Iterable Iterator]]
- [[CollectionUtils]]
- [[Winter '24]] — Comparator·Collator 신규 추가 릴리즈

