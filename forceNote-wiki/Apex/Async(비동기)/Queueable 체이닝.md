---
tags: [apex, async, queueable, chaining, pattern]
source: apex-recipes/QueueableRecipes.cls
created: 2026-05-17
aliases: [Queueable 체이닝, System.enqueueJob, 큐어블 체인]
---

# Queueable 체이닝

> Queueable의 `execute()` 내에서 다음 Queueable을 `System.enqueueJob()`으로 등록해 단계적 비동기 처리를 구현. 각 단계는 독립 트랜잭션으로 실행.

---

## 기본 체이닝 패턴

```apex
public class Step1Queueable implements Queueable {
    public void execute(QueueableContext ctx) {
        // Step 1 작업
        List<Account> accounts = [SELECT Id FROM Account WHERE Step1Done__c = false LIMIT 200];
        for (Account a : accounts) {
            a.Step1Done__c = true;
        }
        update accounts;

        // 다음 단계 체이닝 — 테스트에서는 체이닝 비활성화
        if (!Test.isRunningTest()) {
            System.enqueueJob(new Step2Queueable(accounts));
        }
    }
}

public class Step2Queueable implements Queueable {
    private List<Account> accounts;

    public Step2Queueable(List<Account> accounts) {
        this.accounts = accounts;
    }

    public void execute(QueueableContext ctx) {
        // Step 2 작업
        for (Account a : accounts) {
            a.Step2Done__c = true;
        }
        update accounts;
    }
}
```

---

## Callout 포함 체이닝

```apex
public class CalloutChainStep implements Queueable, Database.AllowsCallouts {

    public void execute(QueueableContext ctx) {
        // Callout + DML 조합 가능 (Queueable의 장점)
        HttpResponse response = new RestClient.makeApiCall(
            'MyAPI', RestClient.HttpVerb.GET, 'accounts/'
        );

        List<Account> toUpdate = parseAndProcess(response.getBody());
        update toUpdate;

        // 다음 단계 체이닝
        if (!Test.isRunningTest() && !toUpdate.isEmpty()) {
            System.enqueueJob(new NotificationStep(toUpdate));
        }
    }
}
```

> [!note] `Database.AllowsCallouts` 추가 필수
> Callout을 포함하는 Queueable은 반드시 `implements Queueable, Database.AllowsCallouts` 선언.

---

## Finalizer — 체이닝 에러 핸들링

```apex
public class ChainFinalizer implements Finalizer {
    public void execute(FinalizerContext ctx) {
        if (ctx.getResult() == ParentJobResult.UNHANDLED_EXCEPTION) {
            // 실패 시 보상 로직
            System.enqueueJob(new CompensationJob(ctx.getRequestId()));
        }
    }
}

public class StepWithFinalizer implements Queueable {
    public void execute(QueueableContext ctx) {
        // Finalizer 연결
        System.attachFinalizer(new ChainFinalizer());
        // 실제 작업...
    }
}
```

---

## 체이닝 깊이 제한

> [!warning] 체이닝 깊이 제한
> - 동기 컨텍스트에서: 최대 5 depth
> - 비동기 컨텍스트에서: 무제한 (단, 각 단계는 개별 AsyncApexJob)
> - 테스트에서 체이닝 금지: `if (!Test.isRunningTest())` 조건 필수

---

## AsyncApexJob으로 상태 모니터링

```apex
// Job ID 저장
Id jobId = System.enqueueJob(new Step1Queueable());

// 상태 확인
AsyncApexJob job = [
    SELECT Status, NumberOfErrors, ExtendedStatus
    FROM AsyncApexJob
    WHERE Id = :jobId
];
// Status: Queued, Processing, Completed, Failed
```

---

## 테스트

```apex
@isTest
static void testQueueableChain() {
    List<Account> accounts = [SELECT Id FROM Account];

    Test.startTest();
    System.enqueueJob(new Step1Queueable());
    Test.stopTest(); // Step1만 실행 (체이닝은 Test.isRunningTest()로 차단)

    // Step1 결과만 검증
    Integer step1Done = [SELECT COUNT() FROM Account WHERE Step1Done__c = true];
    Assert.areEqual(accounts.size(), step1Done);
}
```

---

## 관련 노트

- [[Queueable]]
- [[비동기 컨텍스트 선택]]
- [[RestClient 패턴]] — AllowsCallouts 패턴
- [[Queueable + Callout 패턴]] — HTTP Callout과 체이닝 결합

