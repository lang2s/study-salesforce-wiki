---
tags: [apex, namespace, commercebuygrp, b2b-commerce, d2c-commerce, buyer-group]
source: salesforce_apex_reference_guide.pdf p.301-306
created: 2026-05-20
aliases: [CommerceBuyGrp, BuyerGroupEvaluationService, BuyerGroupRequest, BuyerGroupResponse, Buyer Group Apex, 바이어 그룹 배정 Apex, B2B Commerce Buyer Group]
---

# CommerceBuyGrp Namespace

> B2B/D2C Commerce에서 사용자를 Buyer Group에 동적 배정하는 커스텀 비즈니스 로직 — `BuyerGroupEvaluationService`를 구현해 Account·Market·Data Segment 기반을 넘어서는 맞춤형 배정 전략을 구현한다.

---

## 구성 요소 요약

| 클래스 | 역할 |
|---|---|
| `CommerceBuyGrp.BuyerGroupEvaluationService` | 커스텀 Buyer Group 배정 로직 진입점 (확장 클래스) |
| `CommerceBuyGrp.BuyerGroupRequest` | 요청 컨텍스트 — accountId, storeId, 런타임 파라미터 |
| `CommerceBuyGrp.BuyerGroupResponse` | 응답 — 배정된 buyerGroupIds Set 또는 에러 |

---

## BuyerGroupEvaluationService Class

커스텀 Buyer Group 배정 로직을 정의하고 실행한다. 이 클래스를 상속해 구현하면 런타임에 Account·Market·Data Segment 기준 외의 조건으로 Buyer Group을 결정할 수 있다.

**지원 범위:** B2B Store 및 커스텀 체크아웃이 활성화된 D2C Store. 관리형 체크아웃을 사용하는 스토어는 미지원.

> [!important] CDN·캐싱 주의  
> Buyer Group 배정이 즉시 반영되지 않을 수 있다. CDN(Salesforce Content Delivery Network)과 Salesforce Edge Network를 비활성화해야 실시간 적용된다.  
> **My Domain Settings**에서 두 옵션을 모두 꺼야 한다. 샌드박스에서 먼저 테스트 후 프로덕션 적용.

### 메서드

```apex
public CommerceBuyGrp.BuyerGroupResponse getBuyerGroupIds(
    CommerceBuyGrp.BuyerGroupRequest request)
// request: 사용자의 accountId, storeId, 런타임 컨텍스트 파라미터 포함
// 반환: 배정할 buyerGroupIds Set 또는 에러 정보
```

---

## BuyerGroupRequest Class

사용자와 스토어 정보를 담아 `getBuyerGroupIds()` 호출 시 전달된다.

```apex
public String getAccountId()           // 사용자의 Account ID
public String getStoreId()             // Web Store ID

public Map<String,Object> getRequestContextParameters()
// 런타임에 평가된 사용자 컨텍스트 파라미터 Map
```

### `getRequestContextParameters()` 반환 키

| 키 | 타입 | 설명 |
|---|---|---|
| `guest_uuid_essential_{siteId}` | String | 스토어별 게스트 UUID 쿠키. `siteId`는 Site의 15자리 ID |
| `isGuestUser` | Boolean | 게스트 사용자(`true`) 또는 인증 사용자(`false`) |
| `locale` | String | 사용자 로케일 |

---

## BuyerGroupResponse Class

배정 결과 또는 에러를 담는 응답 객체.

### 생성자

```apex
public BuyerGroupResponse(Set<String> buyerGroupIds) // buyerGroupIds로 초기화
public BuyerGroupResponse()                          // 기본 생성자
```

### 메서드

```apex
public Set<String> getBuyerGroupIds()                // 배정된 Buyer Group ID Set 조회
public void setBuyerGroupIds(Set<String> buyerGroupIds) // Buyer Group ID Set 설정
public void setError(String errorMessage, String localizedErrorMessage)
// errorMessage:           에러 원인 메시지
// localizedErrorMessage:  번역된 에러 메시지
```

---

## 구현 패턴

```apex
public class MyBuyerGroupService extends CommerceBuyGrp.BuyerGroupEvaluationService {

    public override CommerceBuyGrp.BuyerGroupResponse getBuyerGroupIds(
            CommerceBuyGrp.BuyerGroupRequest request) {

        Map<String, Object> ctx = request.getRequestContextParameters();
        Boolean isGuest = (Boolean) ctx.get('isGuestUser');
        String locale   = (String)  ctx.get('locale');
        String accountId = request.getAccountId();

        Set<String> groupIds = new Set<String>();

        // 예: 로케일에 따라 다른 Buyer Group 배정
        if ('en_US'.equals(locale)) {
            groupIds.add('US_BUYER_GROUP_ID');
        } else if (isGuest) {
            groupIds.add('GUEST_BUYER_GROUP_ID');
        }

        return new CommerceBuyGrp.BuyerGroupResponse(groupIds);
    }
}
```

---

## 관련 노트

- [[Apex MOC]]
- [[CommerceExtension Namespace]] — B2B/D2C Commerce 확장 포인트 Resolution 전략
