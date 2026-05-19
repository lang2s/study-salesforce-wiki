---
tags: [apex, testing, flow, flowtesting, flow-test, sf-cli]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, Summer '26, p.2885)
created: 2026-05-19
aliases: [Flowtesting Namespace, flowtesting, Flow 단위 테스트, Flow Builder 테스트, sf flow run test, Flow Test Apex]
---

# Flowtesting Namespace

> Flow Builder에서 생성한 flow test를 Apex 컨텍스트에서 실행하기 위한 동적 네임스페이스 — 고정 클래스 없이 Flow와 flow test 이름을 기반으로 클래스가 동적 생성된다.

---

## 개념

`flowtesting` namespace는 Flow Builder에서 만든 flow test를 위해 **동적으로 생성되는** Apex 클래스를 제공한다 (PDF p.2885 확인).

```
The flowtesting namespace provides dynamically generated Apex classes
for flow tests that are created in Flow Builder.
The flowtesting namespace doesn't define a fixed set of classes.
The namespace reflects flows and flow tests that are created in Flow Builder.
```

### 일반 Apex 테스트 vs Flowtesting

| 항목 | 일반 Apex 테스트 | Flowtesting |
|---|---|---|
| 클래스 정의 | 개발자가 직접 `@isTest` 클래스 작성 | Flow Builder UI에서 flow test 생성 |
| 실행 방법 | Apex Test Execution, `sf apex run test` | `sf flow run test` CLI 명령 |
| 네임스페이스 | 없음 또는 패키지 네임스페이스 | `flowtesting` |
| 클래스 구조 | 고정 (직접 작성) | 동적 생성 (Flow/test 이름 기반) |
| 코드에서 직접 참조 | 가능 | 불가 (동적 생성이므로 컴파일 타임 참조 없음) |

---

## Flow Builder에서 Flow Test 생성

Flow Builder UI에서 flow test를 생성하면 `flowtesting` namespace 하위에 동적 클래스가 생성된다.

```
Flow Builder → 해당 Flow 열기 → 상단 "Run" 드롭다운 → "Flow Test" 탭
→ "New Test" → 테스트 시나리오 구성 (입력값, 기대 결과, assert 조건)
→ 저장 시 flowtesting namespace에 클래스 동적 등록
```

---

## CLI로 Flow Test 실행

`flowtesting` namespace에 등록된 flow test는 Salesforce CLI로 실행한다 (PDF p.2885 확인).

```bash
# 특정 Flow의 모든 test 실행
sf flow run test --flow-api-name My_Flow_Name

# 도움말 확인
sf flow run test --help
```

### Apex Test Execution에서 flowtesting 클래스 실행

Flow Builder에서 생성된 flow test는 Apex 테스트 실행 화면에서도 실행 가능하다.

```bash
# Apex Test Execution에서 flowtesting namespace 클래스 실행
sf apex run test --class-names flowtesting.My_Flow_Name_Test --result-format human
```

---

## Flow.Interview와의 관계

`flowtesting` namespace는 Flow Builder 생성 테스트 전용이다. Apex 코드에서 직접 Flow를 실행하고 검증하려면 `Flow.Interview`를 사용한다.

```apex
// Apex에서 Flow를 직접 실행하고 출력값을 검증하는 패턴
// (flowtesting이 아닌 Flow.Interview 사용)
@isTest
private class MyFlowTest {

    @isTest
    static void testDiscountFlow() {
        // 입력 변수 설정
        Map<String, Object> inputs = new Map<String, Object>{
            'AccountId' => '001xx000000001', // 테스트용 ID
            'DiscountPercent' => 10
        };

        // Flow 실행
        Flow.Interview.Calculate_Discount myFlow =
            new Flow.Interview.Calculate_Discount(inputs);

        Test.startTest();
        myFlow.start();
        Test.stopTest();

        // 출력 변수 검증
        Decimal result = (Decimal) myFlow.getVariableValue('FinalPrice');
        Assert.isNotNull(result, 'FinalPrice should not be null');
    }
}
```

---

## Flow Builder flow test 활용 시 권고 패턴

Flow Builder에서 flow test를 생성할 때 다루는 주요 검증 요소:

| 검증 요소 | 설명 |
|---|---|
| 입력 변수 | 테스트 실행 시 Flow에 전달할 초기값 |
| Decision 경로 | 어느 분기를 탔는지 (True/False path) |
| 출력 변수 | Flow 완료 후 기대하는 출력값 |
| DML 결과 | 레코드 생성/수정/삭제 여부 (레코드 ID 등) |

```
[권고 사항]
- Flow의 비즈니스 로직 단위 테스트 → Flow Builder flow test (flowtesting namespace)
- Apex 클래스와 Flow 통합 테스트 → @isTest + Flow.Interview
- Flow에서 호출하는 @InvocableMethod Apex 테스트 → 별도 @isTest 클래스
```

---

## 관련 노트

- [[Flow Interview API]] — Apex에서 Flow를 직접 실행하는 Flow.Interview 클래스
- [[테스트 전략]] — @isTest, TestSetup, Given-When-Then 구조
- [[System Namespace]] — System.enqueueJob, Test 클래스 관련 API
