---
tags: [apex, trigger, cmdt, pattern, metadata]
source: apex-recipes/MetadataTriggerHandler.cls, MetadataTriggerService.cls
created: 2026-05-17
aliases: [MetadataTriggerHandler, CMDT 트리거]
---

# CMDT 기반 메타데이터 트리거

> 배포 없이 CMDT 레코드만 수정해서 트리거 핸들러를 등록/비활성화. 특정 사용자만 선택적으로 비활성화 가능.

---

## 개념

전통적인 트리거 아키텍처에서는 새 핸들러 클래스를 추가하거나 실행 순서를 바꿀 때마다 코드 배포가 필요하다. 운영 중인 조직에서 특정 통합 사용자의 트리거 동작을 임시로 끄려면 코드를 수정하고 배포해야 하며, 이는 변경 관리 프로세스와 충돌한다.

CMDT 기반 메타데이터 트리거는 이 문제를 해결하기 위해 트리거의 **등록·순서·활성화 여부를 Custom Metadata Type(CMDT) 레코드로 관리**한다. 트리거 파일 자체는 `new MetadataTriggerHandler().run()` 한 줄만 남고, 실제 어떤 핸들러를 어떤 순서로 실행할지는 런타임에 CMDT를 쿼리해서 결정한다.

핵심 장점은 배포 없는 변경이다. CMDT 레코드는 일반 레코드처럼 Setup UI에서 수정할 수 있어, `Enabled__c` 체크박스 하나로 특정 핸들러를 즉시 비활성화할 수 있다. `Disabled_for__mdt`를 통해 특정 사용자(예: 데이터 마이그레이션 계정)에게만 선택적으로 트리거를 우회하는 것도 코드 변경 없이 가능하다.

이 패턴은 apex-recipes의 `MetadataTriggerHandler.cls`와 `MetadataTriggerService.cls`에 구현되어 있으며, 기존 `TriggerHandler` 프레임워크 위에 동작한다.

---

## 구조

```
Trigger (1줄: new MetadataTriggerHandler().run())
    ↓
MetadataTriggerHandler.run()
    ↓ CMDT 쿼리 (Object, Class, Execution_Order, Enabled)
    ↓ Type.forName(trygger.class__c).newInstance()
각 TriggerHandler 구현 클래스 (beforeInsert, afterInsert 등)
```

---

## MetadataTriggerHandler 핵심 코드

```apex
public with sharing class MetadataTriggerHandler extends TriggerHandler {

    @testVisible
    private MetadataTriggerService mts = new MetadataTriggerService();
    private List<Metadata_Driven_Trigger__mdt> tryggers;
    private TriggerHandler activeHandler;

    public override void run() {
        if (!validateRun()) return;
        addToLoopCount();

        this.tryggers = this.mts.getMetadataTriggers();

        for (Metadata_Driven_Trigger__mdt trygger : tryggers) {
            // 클래스명으로 동적 인스턴스화
            activeHandler = (TriggerHandler) Type.forName(trygger.Class__c).newInstance();

            switch on Trigger.operationType {
                when BEFORE_INSERT  { activeHandler.beforeInsert();  }
                when BEFORE_UPDATE  { activeHandler.beforeUpdate();  }
                when BEFORE_DELETE  { activeHandler.beforeDelete();  }
                when AFTER_INSERT   { activeHandler.afterInsert();   }
                when AFTER_UPDATE   { activeHandler.afterUpdate();   }
                when AFTER_DELETE   { activeHandler.afterDelete();   }
                when AFTER_UNDELETE { activeHandler.afterUndelete(); }
            }
        }
    }
}
```

---

## MetadataTriggerService — CMDT 쿼리 (사용자별 비활성화)

```apex
public with sharing class MetadataTriggerService {
    public List<Metadata_Driven_Trigger__mdt> getMetadataTriggers() {
        return [
            SELECT Class__c
            FROM Metadata_Driven_Trigger__mdt
            WHERE Object__r.QualifiedApiName = :getSObjectType()  // 현재 트리거 Object
              AND Enabled__c = TRUE
              AND Id NOT IN (
                  SELECT Metadata_Driven_Trigger__c
                  FROM Disabled_for__mdt
                  WHERE User_Email__c = :UserInfo.getUsername() // 사용자별 선택 비활성화
              )
            ORDER BY Execution_Order__c
        ];
    }
}
```

---

## CMDT 구조 (Metadata_Driven_Trigger__mdt)

| 필드 | 타입 | 설명 |
|---|---|---|
| `Object__c` | EntityDefinition | 어느 SObject에 적용 |
| `Class__c` | Text | 핸들러 클래스명 (TriggerHandler를 extends해야 함) |
| `Execution_Order__c` | Number | 실행 순서 (낮을수록 먼저) |
| `Enabled__c` | Checkbox | 활성/비활성 |

## CMDT 구조 (Disabled_for__mdt)

| 필드 | 타입 | 설명 |
|---|---|---|
| `Metadata_Driven_Trigger__c` | MasterDetail | 비활성할 핸들러 |
| `User_Email__c` | Email | 비활성화할 사용자 이메일 |

---

## 트리거 파일

```apex
// AccountTrigger.trigger — MetadataTriggerHandler 방식
trigger AccountTrigger on Account (
    before insert, before update, before delete,
    after insert, after update, after delete, after undelete
) {
    new MetadataTriggerHandler().run();
}
```

---

## 장점과 단점

> [!tip] 장점
> - 새 핸들러 추가: 코드 배포 없이 CMDT 레코드 생성만으로 가능
> - 운영 중 비활성화: Enabled__c = false로 즉시 비활성화
> - 통합 사용자 우회: Disabled_for__mdt로 특정 사용자만 스킵

> [!warning] 단점
> - 실행 순서를 CMDT로 관리해야 해서 가시성이 낮음
> - 디버깅 시 어느 핸들러가 실행됐는지 추적이 어려울 수 있음
> - Type.forName()으로 인스턴스화하므로 클래스명 오타 시 런타임 에러

---

## 관련 노트

- [[TriggerHandler 패턴]]
- [[서비스 레이어 패턴]]
