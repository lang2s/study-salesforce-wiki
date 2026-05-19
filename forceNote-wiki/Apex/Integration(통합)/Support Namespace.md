---
tags: [apex, support, case-feed, milestone, email-template, classic-only, service-cloud]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.3580~3583)
created: 2026-05-20
aliases: [Support Namespace, Support.EmailTemplateSelector, Support.MilestoneTriggerTimeCalculator, Case Feed 이메일 기본값, 마일스톤 트리거 시간, EmailTemplateSelector, MilestoneTriggerTimeCalculator]
---

# Support Namespace

> Case Feed 이메일 기본 템플릿 선택과 마일스톤 동적 트리거 시간 계산을 Apex로 커스터마이징하는 인터페이스 모음.

> [!warning] EmailTemplateSelector — Salesforce Classic 전용
> `Support.EmailTemplateSelector`는 Salesforce Classic의 Case Feed에서만 동작합니다. Lightning Experience에서 Case Feed 이메일 기본값을 커스터마이징하려면 [[QuickAction Namespace]]의 `QuickActionDefaultsHandler` 인터페이스를 사용합니다.

---

## 개념

`Support` 네임스페이스는 Service Cloud Case Feed와 관련된 두 가지 커스터마이징 인터페이스를 제공한다.

| 인터페이스 | 목적 | 적용 환경 |
|---|---|---|
| `Support.EmailTemplateSelector` | Case Feed에서 케이스를 열 때 자동으로 이메일 템플릿 선택 | Salesforce Classic만 |
| `Support.MilestoneTriggerTimeCalculator` | Entitlement 마일스톤의 동적 트리거 시간(분) 계산 | 모든 환경 |

---

## 언제 쓰나

- 케이스의 Origin, Subject, Custom Field 값에 따라 Case Feed 이메일 템플릿을 자동 선택해야 할 때 (`EmailTemplateSelector`)
- 마일스톤 트리거 시간을 케이스 Priority, 케이스 타입, 연관 오브젝트 조건에 따라 동적으로 계산해야 할 때 (`MilestoneTriggerTimeCalculator`)
- Entitlement Process에서 일률적인 트리거 시간이 아닌 케이스별 SLA 시간이 필요할 때

---

## Support.EmailTemplateSelector 인터페이스

Case Feed가 열릴 때 Salesforce가 이 인터페이스의 `getDefaultTemplateId()`를 호출해 미리 로드할 이메일 템플릿 ID를 얻는다.

### 구현 규칙

- 클래스 선언에 `implements Support.EmailTemplateSelector` 추가
- **빈 파라미터 없는 생성자 필수** — Salesforce가 인스턴스를 생성할 때 사용
- Setup > Case Feed Settings에서 구현 클래스를 등록

### getDefaultTemplateId(caseId)

```apex
public ID getDefaultTemplateId(ID caseId)
```

| 항목 | 내용 |
|---|---|
| 파라미터 | `caseId` — 현재 Case Feed에서 열린 케이스 ID |
| 반환값 | 미리 로드할 EmailTemplate 레코드 ID. `null` 반환 시 기본값 없음 |

### 구현 예제 — Subject 키워드로 템플릿 선택

PDF p.3581에서 발췌. 케이스 Subject에 특정 키워드가 포함되면 해당 템플릿을 반환한다.

```apex
global class MyCaseTemplateChooser implements Support.EmailTemplateSelector {
    // 빈 생성자 필수
    global MyCaseTemplateChooser() { }

    global ID getDefaultEmailTemplateId(ID caseId) {
        // 케이스의 Subject와 Description 조회
        Case c = [SELECT Subject, Description FROM Case WHERE Id = :caseId];

        EmailTemplate et;

        if (c.Subject.contains('LX-1150')) {
            et = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'LX1150_template'];
        } else if (c.Subject.contains('LX-1220')) {
            et = [SELECT id FROM EmailTemplate WHERE DeveloperName = 'LX1220_template'];
        }

        return et?.Id;
    }
}
```

### 테스트 클래스 패턴

```apex
@isTest
private class MyCaseTemplateChooserTest {
    static testMethod void testChooseTemplate() {
        MyCaseTemplateChooser chooser = new MyCaseTemplateChooser();

        // 케이스 생성
        Case c = new Case();
        c.Subject = 'I\'m having trouble with my LX-1150';
        Database.insert(c);

        // 실제 호출 — 반환된 템플릿 ID 검증
        Id actualTemplateId = chooser.getDefaultEmailTemplateId(c.Id);
        EmailTemplate expectedTemplate =
            [SELECT id FROM EmailTemplate WHERE DeveloperName = 'LX1150_template'];
        System.assertEquals(expectedTemplate.Id, actualTemplateId);
    }
}
```

---

## Support.MilestoneTriggerTimeCalculator 인터페이스

Entitlement Process의 마일스톤 트리거 시간을 케이스·마일스톤 타입에 따라 동적으로 계산한다. 반환값은 **분(minute) 단위**의 Integer.

### calculateMilestoneTriggerTime(caseId, milestoneTypeId)

```apex
public Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId)
```

| 항목 | 내용 |
|---|---|
| `caseId` | 마일스톤이 적용된 케이스 ID (String) |
| `milestoneTypeId` | 마일스톤 타입 ID (String) |
| 반환값 | 트리거 시간 (분). 이 값이 마일스톤의 TimeTriggered 필드에 사용됨 |

### 구현 예제 — Priority와 MilestoneType에 따라 다른 SLA 시간 적용

PDF p.3583에서 발췌. High Priority + 'M1' 마일스톤 = 7분, High Priority 기타 = 5분, 그 외 = 18분.

```apex
global class myMilestoneTimeCalculator implements Support.MilestoneTriggerTimeCalculator {
    global Integer calculateMilestoneTriggerTime(String caseId, String milestoneTypeId) {
        Case c = [SELECT Priority FROM Case WHERE Id = :caseId];
        MilestoneType mt = [SELECT Name FROM MilestoneType WHERE Id = :milestoneTypeId];

        if (c.Priority != null && c.Priority.equals('High')) {
            if (mt.Name != null && mt.Name.equals('m1')) {
                return 7;
            } else {
                return 5;
            }
        } else {
            return 18;
        }
    }
}
```

### 테스트 클래스 패턴

```apex
@isTest
private class MilestoneTimeCalculatorTest {
    static testMethod void testMilestoneTimeCalculator() {
        // 기존 MilestoneType 조회
        MilestoneType[] mtLst = [SELECT Id, Name FROM MilestoneType LIMIT 1];
        if (mtLst.size() == 0) { return; }
        MilestoneType mt = mtLst[0];

        // 케이스 생성
        Case c = new Case(priority = 'High');
        insert c;

        myMilestoneTimeCalculator calculator = new myMilestoneTimeCalculator();
        Integer actualTriggerTime = calculator.calculateMilestoneTriggerTime(c.Id, mt.Id);

        if (mt.Name != null && mt.Name.equals('m1')) {
            System.assertEquals(7, actualTriggerTime);
        } else {
            System.assertEquals(5, actualTriggerTime);
        }

        // Priority 변경 후 재검증
        c.Priority = 'Low';
        update c;
        actualTriggerTime = calculator.calculateMilestoneTriggerTime(c.Id, mt.Id);
        System.assertEquals(18, actualTriggerTime);
    }
}
```

---

## 주의사항

### 1. EmailTemplateSelector — Lightning Experience 미지원

`Support.EmailTemplateSelector`는 Classic Case Feed 전용이다. Lightning Experience에서 동작하지 않으므로, Lightning Experience를 사용 중이라면 [[QuickAction Namespace]]의 `QuickActionDefaultsHandler` 인터페이스를 구현해야 한다.

### 2. 빈 생성자 필수 (EmailTemplateSelector)

Salesforce가 런타임에 인스턴스를 직접 생성하므로, **파라미터 없는 생성자**가 반드시 있어야 한다. 생략하면 케이스 열기 시 오류가 발생한다.

### 3. MilestoneTriggerTimeCalculator 등록

구현 클래스를 작성한 뒤 Setup > Entitlement Processes > 해당 Entitlement Process > Milestones에서 "Apex Class"로 등록해야 실제로 호출된다.

### 4. SOQL Governor Limit

두 인터페이스 모두 케이스 조회 SOQL을 포함하는 경우가 일반적이다. 대량 처리 시(예: 마일스톤 트리거가 다수 케이스에 동시 적용) SOQL Limit을 주의한다.

---

## 관련 노트

- [[QuickAction Namespace]] — Lightning Experience에서 Case Feed 이메일 기본값 커스터마이징 (`QuickActionDefaultsHandler`)
- [[Auth Namespace]] — 세션·인증 관련 보안 API
