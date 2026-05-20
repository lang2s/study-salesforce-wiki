---
tags: [apex, isvpartners, namespace, appexchange, app-analytics, isv, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — IsvPartners Namespace (doc p.2966~2967)
created: 2026-05-20
aliases: [IsvPartners Namespace, AppAnalytics, logCustomInteraction, ISV App Analytics Apex, AppExchange 앱 분석 Apex, 커스텀 상호작용 로깅]
---

# IsvPartners Namespace

> Salesforce ISV 파트너를 위한 네임스페이스. AppExchange 앱 분석(App Analytics)에서 구독자 이탈 최소화·제품 인사이트 확보 등의 사용 사례를 지원한다.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `AppAnalytics` | AppExchange App Analytics 커스텀 상호작용 로깅 메서드 |

---

## AppAnalytics 클래스

AppExchange 패키지에서 커스텀 상호작용(custom interactions)을 App Analytics 사용 로그에 기록한다. 구독자 이탈 최소화·피처 채택률 분석 등에 활용한다.

### 메서드

모든 메서드는 `static`이다.

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `logCustomInteraction(interactionLabel, interactionId)` | `public static void logCustomInteraction(Object interactionLabel, Id interactionId)` | enum 라벨 + Apex Id로 상호작용 기록 |
| `logCustomInteraction(interactionLabel, interactionUuid)` | `public static void logCustomInteraction(Object interactionLabel, System.UUID interactionUuid)` | enum 라벨 + Apex UUID로 상호작용 기록 |
| `logCustomInteraction(interactionLabel)` | `public static void logCustomInteraction(Object interactionLabel)` | enum 라벨만으로 상호작용 기록 |

#### 파라미터 상세

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `interactionLabel` | `Object` | 상호작용 라벨로 사용할 enum 값. **반드시 `logCustomInteraction` 호출 코드와 같은 네임스페이스의 enum이어야 한다.** |
| `interactionId` | `Id` | 상호작용과 연결된 Apex Id. App Analytics 패키지 사용 로그에 포함되기 전에 해시·토큰화된다. |
| `interactionUuid` | `System.UUID` | 상호작용과 연결된 Apex UUID. 마찬가지로 해시·토큰화된다. |

---

## 코드 예시

```apex
// ISV 패키지 내 Apex 클래스 — 커스텀 상호작용 로깅
// interactionLabel은 반드시 동일 네임스페이스의 enum 값이어야 함
public void submitClicked() {
    Id jobId = System.enqueueJob(new MyQueueeable(colorValue));
    IsvPartners.AppAnalytics.logCustomInteraction(
        MyPageInteractions.SUBMIT_CLICKED, jobId);
}

// UUID 버전 — 트랜잭션 ID 등 UUID 기반 추적이 필요할 때
IsvPartners.AppAnalytics.logCustomInteraction(
    MyFeatureInteractions.FEATURE_USED,
    System.UUID.randomUUID()
);

// interactionId 없이 라벨만 기록
IsvPartners.AppAnalytics.logCustomInteraction(
    MyPageInteractions.PAGE_VIEWED
);
```

---

## 관련 노트

- [[System Namespace]] — `System.UUID.randomUUID()` 생성 API
- [[Queueable]] — `System.enqueueJob()` 비동기 잡 패턴
