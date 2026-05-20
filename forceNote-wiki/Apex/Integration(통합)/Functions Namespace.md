---
tags: [apex, functions, namespace, salesforce-functions, invoke, async, mock, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — Functions Namespace (doc p.2905~2920)
created: 2026-05-20
aliases: [Functions Namespace, functions.Function, FunctionInvocation, FunctionCallback, FunctionInvokeMock, MockFunctionInvocationFactory, FunctionErrorType, FunctionInvocationStatus, Salesforce Functions Apex, 함수 호출 Apex]
---

# Functions Namespace

> Salesforce Functions를 Apex에서 동기/비동기로 호출하고 결과를 받기 위한 클래스·인터페이스·Enum 모음. 테스트 모킹 전용 클래스(FunctionInvokeMock / MockFunctionInvocationFactory)까지 포함.

---

## 클래스/인터페이스 목록

| 이름 | 종류 | 설명 |
|---|---|---|
| `Function` | 클래스 | 배포된 Function 인스턴스 조회 + 동기/비동기 호출 |
| `FunctionCallback` | 인터페이스 | 비동기 호출 완료 시 Salesforce가 호출하는 콜백 |
| `FunctionInvocation` | 인터페이스 | 호출 결과(응답·상태·오류·ID) 조회 |
| `FunctionInvocationError` | 인터페이스 | 실패 호출의 상세 오류 정보 조회 |
| `FunctionInvokeMock` | 인터페이스 | 테스트용 모의 응답 구현 |
| `MockFunctionInvocationFactory` | 클래스 | 테스트용 성공/오류 응답 생성 헬퍼 |
| `FunctionErrorType` | Enum | 오류 유형 (3가지) |
| `FunctionInvocationStatus` | Enum | 호출 상태 (3가지) |

---

## Function 클래스

배포된 Salesforce Function을 Apex에서 가져와 호출한다.

### 메서드 전체

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `get(String functionName)` | `functions.Function` | `"project.function"` 형식으로 Function 인스턴스 반환 (static) |
| `get(String namespace, String functionName)` | `functions.Function` | 네임스페이스 지정 크로스-네임스페이스 조회 (global org 필요) (static) |
| `invoke(String payload)` | `functions.FunctionInvocation` | 동기 호출 — JSON 페이로드 전달 |
| `invoke(String payload, functions.FunctionCallback callback)` | `functions.FunctionInvocation` | 비동기 호출 — 완료 시 callback.handleResponse() 실행 |

### 동기 호출 예시

```apex
functions.Function accountFunction =
    functions.Function.get('MyProject.accountfunction');

functions.FunctionInvocation invocation = accountFunction.invoke(
    '{ "accountName": "Acct", "contactName": "MyContact", "opportunityName": "Oppty" }'
);
String jsonResponse = invocation.getResponse();
```

### 비동기 호출 예시

```apex
functions.Function accountFunction =
    functions.Function.get('MyProject.accountfunction');

// 비동기 — 콜백 클래스 전달
accountFunction.invoke(
    '{ "accountName": "Acct", "contactName": "MyContact", "opportunityName": "Oppty" }',
    new MyCallback()
);

public class MyCallback implements functions.FunctionCallback {
    public void handleResponse(functions.FunctionInvocation result) {
        String jsonResponse = result.getResponse();
        System.debug('Got response ' + jsonResponse);
        JSONParser parser = JSON.createParser(jsonResponse);
        // Process JSON using your own data class...
    }
}
```

### get() 예외

- `InvalidParameterValueException` — `functionName`이 `project.function` 형식이 아님
- `NoDataFoundException` — 프로젝트/Function 이름 오류 또는 배포 안 됨
- `RuntimeException` — public 함수로 크로스-네임스페이스 조회 시도 (global org만 허용)

### invoke() 예외

- `CalloutException` — Functions 미활성화, 테스트 환경, 페이로드 JSON 오류, 미배포, 트리거 내 동기 호출, 타임아웃(2분 초과), 5xx 오류 등
- `InvalidParameterValueException` — callback이 null 또는 FunctionCallback 미구현 클래스
- `NoDataFoundException` — Function 레퍼런스를 찾을 수 없음

---

## FunctionCallback 인터페이스

비동기 호출이 완료되면 Salesforce가 이 인터페이스의 `handleResponse`를 호출한다.

```apex
public class MyCallback implements functions.FunctionCallback {
    public void handleResponse(functions.FunctionInvocation result) {
        String jsonResponse = result.getResponse();
        System.debug('Got response ' + jsonResponse);
        JSONParser parser = JSON.createParser(jsonResponse);
    }
}
```

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `handleResponse(functions.FunctionInvocation var1)` | `void` | 비동기 호출 완료 시 실행 |

---

## FunctionInvocation 인터페이스

동기/비동기 호출 결과 객체. 응답 파싱과 오류 처리에 사용.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getError()` | `functions.FunctionInvocationError` | 오류 정보 (성공이면 null) |
| `getInvocationId()` | `String` | 호출 ID (동기/비동기 모두 사용 가능) |
| `getResponse()` | `String` | 원시 JSON 응답 문자열 |
| `getStatus()` | `functions.FunctionInvocationStatus` | 호출 상태 (SUCCESS / ERROR / PENDING) |

---

## FunctionInvocationError 인터페이스

호출 실패 시 `FunctionInvocation.getError()`에서 반환된다.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getMessage()` | `String` | 오류 메시지 반환 |
| `getType()` | `functions.FunctionErrorType` | 오류 유형 반환 |

---

## FunctionErrorType Enum

| 값 | 설명 |
|---|---|
| `FUNCTION_EXCEPTION` | Function 로직에서 발생한 알려진 예외 (코드 오류, 라이브러리 예외 등) |
| `RUNTIME_EXCEPTION` | Functions 런타임에서 발생한 알려진 예외 (잘못된 페이로드 등) |
| `UNEXPECTED_FUNCTION_EXCEPTION` | 알 수 없는 예외 (네트워크/시스템 수준 문제) |

---

## FunctionInvocationStatus Enum

| 값 | 설명 |
|---|---|
| `ERROR` | 호출 실패 — FunctionInvocation.getError()로 디버깅 |
| `PENDING` | 호출 대기 중 — 비동기 큐에 있음 |
| `SUCCESS` | 호출 성공 — getResponse()로 응답 조회 |

---

## 테스트 모킹

Functions는 Apex 테스트 내에서 직접 호출 불가(`CalloutException` 발생). `FunctionInvokeMock`을 구현하고 `Test.setMock()`에 등록해 모킹한다.

### FunctionInvokeMock 인터페이스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `respond(String functionName, String payload)` | `functions.FunctionInvocation` | `Test.setMock()` 호출 시 런타임이 실제 Function 대신 이 메서드를 실행 |

### MockFunctionInvocationFactory 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `createSuccessResponse(String invocationId, String response)` | `functions.FunctionInvocation` | 성공 응답 생성 (static) |
| `createErrorResponse(String invocationId, functions.FunctionErrorType functionsErrorType, String errMsg)` | `functions.FunctionInvocation` | 오류 응답 생성 (static) |

### 완전한 테스트 예시

```apex
// 1. Mock 구현
@isTest
public class FunctionsInvokeMockImpl implements functions.FunctionInvokeMock {
    public functions.FunctionInvocation respond(String functionName, String payload) {
        String invocationId = '000000000000000';
        String response     = 'mockResponse';
        return functions.MockFunctionInvocationFactory.createSuccessResponse(
            invocationId, response);
    }
}

// 2. 테스트 클래스
@isTest
public class FunctionTest {
    @isTest
    static void testSyncFunctionCall() {
        Test.setMock(functions.FunctionInvokeMock.class,
                     new FunctionsInvokeMockImpl());

        functions.Function mockedFunction =
            functions.Function.get('example.function');

        Test.startTest();
        functions.FunctionInvocation invokeResult =
            mockedFunction.invoke('{}');
        Test.stopTest();

        System.assertEquals(
            functions.FunctionInvocationStatus.SUCCESS,
            invokeResult.getStatus());
        System.assertEquals('mockResponse', invokeResult.getResponse());
        System.assertEquals('000000000000000', invokeResult.getInvocationId());
    }
}
```

### 오류 응답 모킹

```apex
return functions.MockFunctionInvocationFactory.createErrorResponse(
    invocationId,
    functions.FunctionErrorType.FUNCTION_EXCEPTION,
    'bang');
```

---

## FunctionInvocation 커스텀 구현 (테스트용)

`FunctionInvocation` 인터페이스를 직접 구현해 `Function.invoke()` 결과를 대체할 수도 있다.

```apex
public class MyFunctionInvocation implements functions.FunctionInvocation {
    public functions.FunctionInvocationStatus getStatus() {
        return functions.FunctionInvocationStatus.ERROR;
    }
    public String getResponse()     { return 'Mock response for testing'; }
    public String getInvocationId() { return 'MOCKTESTID'; }
    public functions.FunctionInvocationError getError() {
        return new MyFunctionInvocationError();
    }
}
```

---

## 관련 노트

- [[HttpCalloutMock]] — HTTP 외부 호출 모킹 패턴 (구조 동일: 인터페이스 구현 → Test.setMock)
- [[Queueable]] — 비동기 Apex 실행 (Functions 비동기와 Queueable 한도는 별개)
- [[Future 메서드]] — callout=true 패턴과 비교
