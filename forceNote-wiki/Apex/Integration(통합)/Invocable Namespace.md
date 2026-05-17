---
tags: [apex, invocable, action, flow-action, dynamic-invocation, integration]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Invocable.Action, createStandardAction, createCustomAction, 동적 액션 호출, invoke action from apex, Invocable namespace]
---

# Invocable Namespace

> Apex에서 **Invocable Action**(Flow 액션, Quick Action, 표준 액션 등)을 동적으로 호출하는 API. Flow 에서만 쓰던 액션을 Apex 코드에서 직접 실행 가능.

---

## 기본 호출 패턴 — 표준 액션

```apex
// 표준 액션 (sendEmail, postFeedItem 등) 호출
Invocable.Action action = Invocable.Action.createStandardAction('sendEmail');

// 하나의 호출(invocation) 추가 후 파라미터 설정
action.addInvocation();
action.setInvocationParameter('emailAddresses', new List<String>{'user@example.com'});
action.setInvocationParameter('emailSubject',   'Hello from Apex');
action.setInvocationParameter('emailBody',      'This is a test');

// 실행
List<Invocable.Action.Result> results = action.invoke();
for (Invocable.Action.Result r : results) {
    System.debug('성공: ' + r.isSuccess());
    if (!r.isSuccess()) {
        for (Invocable.Action.Error err : r.getErrors()) {
            System.debug(err.getStatusCode() + ': ' + err.getMessage());
        }
    }
}
```

---

## 커스텀 액션 호출

```apex
// 커스텀 Apex @InvocableMethod 호출
Invocable.Action customAction = Invocable.Action.createCustomAction('apex', 'MyApexAction');

customAction.addInvocation();
customAction.setInvocationParameter('inputText', '처리할 텍스트');

List<Invocable.Action.Result> results = customAction.invoke();
Object output = results[0].getOutputParameter('result');
```

---

## 다중 호출(Bulk Invocation)

```apex
// 여러 invocation을 한 번에 실행 — bulkify 지원 액션에서 효율적
Invocable.Action action = Invocable.Action.createStandardAction('someAction');

for (String item : myList) {
    action.addInvocation();
    action.setInvocationParameter('input', item);
}

// 한 번의 invoke()로 모든 invocation 실행
List<Invocable.Action.Result> results = action.invoke();
```

---

## 액션 메타데이터 조회 (getDescribe)

```apex
// 액션의 입출력 파라미터, 레이블, 타입 등 메타데이터 확인
Invocable.Action action = Invocable.Action.createStandardAction('sendEmail');
List<Invocable.Action.DescribeResult> describes = action.getDescribe();

for (Invocable.Action.DescribeResult dr : describes) {
    System.debug('이름: '   + dr.getName());
    System.debug('레이블: ' + dr.getLabel());
    System.debug('설명: '   + dr.getDescription());
    System.debug('Callout: ' + dr.getHasCallout());

    // 입력 파라미터 목록
    for (Invocable.Action.InputParameter inp : dr.getInputs()) {
        System.debug('  입력: ' + inp.getName()
            + ' (' + inp.getType() + ')'
            + ' 필수: ' + inp.getRequired());
    }
    // 출력 파라미터 목록
    for (Invocable.Action.OutputParameter out : dr.getOutputs()) {
        System.debug('  출력: ' + out.getName() + ' (' + out.getType() + ')');
    }
}
```

---

## 액션 생성 메서드 비교

| 메서드 | 대상 | 예시 |
|---|---|---|
| `createStandardAction(type)` | Salesforce 표준 액션 | `createStandardAction('sendEmail')` |
| `createCustomAction(type, name)` | 현재 org 커스텀 액션 | `createCustomAction('apex', 'MyClass')` |
| `createCustomAction(type, namespace, name)` | 패키지 커스텀 액션 | `createCustomAction('apex', 'myNs', 'MyClass')` |
| `createCustomAction(type, namespace, name, version)` | 버전 지정 커스텀 액션 | — |

---

## Action 주요 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `addInvocation()` | `Invocable.Action` | 빈 호출 추가 (체이닝 가능) |
| `setInvocationParameter(name, value)` | `Invocable.Action` | 파라미터 설정 |
| `setInvocations(List<Map<String,ANY>>)` | `Invocable.Action` | 기존 invocation 목록으로 초기화 |
| `clearInvocations()` | `Invocable.Action` | invocation 목록 초기화 |
| `invoke()` | `List<Action.Result>` | 액션 실행 |
| `getDescribe()` | `List<Action.DescribeResult>` | 메타데이터 조회 |
| `getName()` | `String` | 액션 이름 |
| `getType()` | `String` | 액션 타입 |
| `isStandard()` | `Boolean` | 표준 액션 여부 |

---

## 관련 노트

- [[@InvocableMethod 패턴]] — Apex 메서드를 Flow Action으로 노출하는 방법 (반대 방향)
- [[RestClient 패턴]] — HTTP 외부 호출 패턴
- [[Custom REST Endpoint]] — Apex → 외부 Inbound REST 정의
