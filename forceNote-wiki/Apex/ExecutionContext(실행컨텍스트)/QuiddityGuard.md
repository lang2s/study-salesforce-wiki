---
tags: [apex, security, quiddity, context, pattern]
source: apex-recipes/QuiddityGuard.cls, RestClient.cls
created: 2026-05-17
aliases: [QuiddityGuard, Quiddity, 실행 컨텍스트 검증]
---

# QuiddityGuard — 실행 컨텍스트 검증

> `System.Quiddity`는 현재 코드가 어떤 컨텍스트에서 실행 중인지 나타내는 열거형. `QuiddityGuard`는 신뢰할 수 있는 컨텍스트인지 검사하는 유틸리티.

---

## Quiddity 주요 값

| Quiddity | 실행 컨텍스트 |
|---|---|
| `ANONYMOUS` | Developer Console / Execute Anonymous |
| `AURA` | Lightning Web Component / Aura |
| `BATCH_APEX` | Batch Apex (execute 메서드) |
| `FUTURE` | @future 메서드 |
| `INBOUND_EMAIL_SERVICE` | Email Service |
| `INVOCABLE_ACTION` | Flow, Process Builder |
| `QUEUEABLE` | Queueable |
| `REST` | REST API 호출 |
| `RUNTEST_ASYNC` | @isTest 비동기 테스트 |
| `RUNTEST_SYNC` | @isTest 동기 테스트 |
| `SCHEDULED` | Scheduled Apex |
| `SYNCHRONOUS` | 일반 동기 실행 (Trigger 등) |

---

## QuiddityGuard 구조

```apex
public class QuiddityGuard {

    // 신뢰할 수 있는 컨텍스트 목록
    public static final List<System.Quiddity> trustedQuiddities =
        new List<System.Quiddity>{
            System.Quiddity.AURA,
            System.Quiddity.REST,
            System.Quiddity.SYNCHRONOUS,
            System.Quiddity.QUEUEABLE,
            System.Quiddity.SCHEDULED,
            System.Quiddity.BATCH_APEX,
            System.Quiddity.INVOCABLE_ACTION,
            System.Quiddity.FUTURE,
            System.Quiddity.RUNTEST_SYNC,     // 테스트에서도 통과
            System.Quiddity.RUNTEST_ASYNC
        };

    // ANONYMOUS 제외 버전 — 더 엄격
    public static final List<System.Quiddity> trustedQuiditiesWithoutAnon = ...;

    @testVisible
    private static Quiddity testQuiddityOverride; // 테스트에서 덮어쓰기

    public static Boolean isAcceptableQuiddity(List<System.Quiddity> acceptableList) {
        Quiddity current = testQuiddityOverride != null
            ? testQuiddityOverride
            : Request.getCurrent().getQuiddity();
        return acceptableList.contains(current);
    }
}
```

---

## 사용 패턴

```apex
// 신뢰되지 않은 컨텍스트에서 조기 반환
public List<Account> getAccounts() {
    if (!QuiddityGuard.isAcceptableQuiddity(QuiddityGuard.trustedQuiddities)) {
        return new List<Account>(); // ANONYMOUS, 알 수 없는 컨텍스트 차단
    }
    return [SELECT Id, Name FROM Account WITH USER_MODE];
}

// 현재 Quiddity 직접 조회
System.Quiddity current = Request.getCurrent().getQuiddity();
System.debug('Running as: ' + current);
```

---

## 테스트에서 Quiddity 오버라이드

```apex
@isTest
static void testWithSpecificQuiddity() {
    // 특정 컨텍스트 시뮬레이션
    QuiddityGuard.testQuiddityOverride = System.Quiddity.ANONYMOUS;

    List<Account> result = MyService.getAccounts();
    Assert.isTrue(result.isEmpty(), 'ANONYMOUS 컨텍스트에서는 빈 결과');
}
```

---

## OrgShape와 함께 사용

```apex
// 환경 타입 + 컨텍스트 모두 확인
public Boolean canExecute() {
    Boolean trustedContext = QuiddityGuard.isAcceptableQuiddity(
        QuiddityGuard.trustedQuiddities
    );
    Boolean isSandbox = OrgShape.isSandbox();

    return trustedContext && (isSandbox || isProductionSafe);
}
```

---

## 언제 쓰나

| 상황 | 권장 |
|---|---|
| Trigger 로직을 Batch/Future/Queueable 실행 시에만 건너뛰어야 할 때 | `QuiddityGuard.isAcceptableQuiddity()` |
| 테스트 컨텍스트(`@isTest`)에서만 특정 분기를 활성화해야 할 때 | `Request.getQuiddity() == Quiddity.RUNTEST_*` |
| 외부 패키지·자동화가 트리거를 재귀 호출하지 않도록 막아야 할 때 | Quiddity 화이트리스트 패턴 |
| 조직이 Sandbox인지 Production인지에 따라 로직을 분기해야 할 때 | `OrgShape.isSandbox()` 조합 |

여러 비동기 컨텍스트(Batch, Future, Queueable, Scheduled)가 혼재하는 대형 프로젝트에서 Guard 패턴을 쓰면 trigger 로직 중복 실행을 막을 수 있다.

---

## 주의사항

> [!warning] QuiddityGuard 사용 시 주의점
> - **화이트리스트 누락**: 허용할 Quiddity 값을 빠뜨리면 정상 실행 컨텍스트가 차단된다. `SYNCHRONOUS`, `QUEUEABLE` 등 프로젝트에서 사용하는 모든 컨텍스트를 명시해야 한다.
> - **테스트 컨텍스트 구분**: `RUNTEST_ASYNC` vs `RUNTEST_SYNC` 두 값이 별도로 존재한다. 테스트 실행 방식에 따라 다른 Quiddity가 반환될 수 있다.
> - **패키지 컨텍스트**: 관리 패키지 코드는 `Quiddity.INVOCATION_TYPE` 등 추가 값이 반환될 수 있으므로 범용 Guard는 방어적으로 작성한다.
> - **Request.getQuiddity() 비용 없음**: Governor Limit을 소모하지 않는 경량 호출이지만, 트리거마다 매 호출마다 평가되므로 싱글턴 캐싱을 고려할 수 있다.

---

## 관련 노트

- [[OrgShape]]
- [[Dynamic SOQL]] — `QuiddityGuard.isAcceptableQuiddity` 조합 예시
- [[testVisible 회로차단기]]

