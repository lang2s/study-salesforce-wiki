---
tags: [apex, namespace, userprovisioning, connected-app, scim, security]
source: salesforce_apex_reference_guide.pdf p.4454-4461
created: 2026-05-20
aliases: [UserProvisioning, UserProvisioningLog, UserProvisioningPlugin, ConnectorTestUtil, 사용자 프로비저닝 Apex, 커넥티드 앱 프로비저닝]
---

# UserProvisioning Namespace

> 커넥티드 앱의 아웃바운드 사용자 프로비저닝 요청을 모니터링·커스터마이즈하는 Apex 클래스 모음 — `ConnectorTestUtil`(테스트), `UserProvisioningLog`(로깅), `UserProvisioningPlugin`(Flow Builder 플러그인).

---

## 구성 클래스 요약

| 클래스 | 역할 |
|---|---|
| `ConnectorTestUtil` | 프로비저닝 테스트 전용 — 커넥티드 앱 인스턴스 생성 시뮬레이션 (`@isTest`만 호출 가능) |
| `UserProvisioningLog` | 프로비저닝 진행 상태·오류 메시지 기록 (static 메서드) |
| `UserProvisioningPlugin` | `Process.Plugin` 구현 베이스 클래스 — Flow Builder 레거시 Apex 액션으로 연결 |

---

## ConnectorTestUtil Class

커넥티드 앱 프로비저닝 커넥터 테스트 가속기. `@isTest` 메서드에서만 호출 가능하며, 실제 커넥티드 앱 레코드를 생성해 프로비저닝 플로우를 end-to-end로 테스트한다.

### 메서드

```apex
public static ConnectedApplication createConnectedApp(String connectedAppName)
// 커넥티드 앱 인스턴스 생성 — 반환: ConnectedApplication
```

### 예제

```apex
@isTest
private class SCIMCreateUserPluginTest {
    public static void callPlugin(Boolean validInputParams) {
        // 커넥티드 앱 인스턴스 생성
        ConnectedApplication capp =
            UserProvisioning.ConnectorTestUtil.createConnectedApp('TestApp');

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        // 사용자 생성
        User user = new User(
            username='testuser1@scimuserprov.test',
            Firstname='Test',
            Lastname='User1',
            email='testuser1@testemail.com',
            FederationIdentifier='testuser1@testemail.com',
            profileId=p.Id,
            communityNickName='tuser1',
            alias='tuser',
            TimeZoneSidKey='GMT',
            LocaleSidKey='en_US',
            EmailEncodingKey='ISO-8859-1',
            LanguageLocaleKey='en_US'
        );
        insert user;

        // UserProvisioningRequest (UPR) 생성 후 삽입 — 프로비저닝 플로우 트리거
        UserProvisioningRequest upr = new UserProvisioningRequest(
            appname=capp.name,
            connectedAppId=capp.id,
            operation='Create',
            state='New',
            approvalStatus='NotRequired',
            salesforceUserId=user.id
        );
        insert upr;
    }
}
```

---

## UserProvisioningLog Class

아웃바운드 프로비저닝 요청의 진행 상태와 오류 메시지를 기록한다. 모든 메서드는 static이며 세 가지 오버로드를 제공한다.

### 메서드

```apex
// 기본 메시지 기록
public static void log(String userProvisioningRequestId, String details)

// 상태 + 메시지 기록
public static void log(String userProvisioningRequestId,
                       String status,
                       String details)

// 외부 사용자 정보 포함 메시지 기록
public static void log(String userProvisioningRequestId,
                       String externalUserId,
                       String externalUserName,
                       String userId,
                       String details)
```

**파라미터:**
- `userProvisioningRequestId` — UPR의 고유 식별자 (String)
- `status` — 현재 상태 설명 (예: `'invoke'`)
- `externalUserId` — 외부 시스템의 사용자 고유 ID
- `externalUserName` — 외부 시스템의 사용자명
- `userId` — 요청을 만든 Salesforce 사용자 ID
- `details` — 메시지 본문

### 예제

```apex
String inputParamsStr = 'Input parameters: uprId=' + uprId +
    ', endpointURL=' + endpointURL +
    ', adminUsername=' + adminUsername +
    ', email=' + email +
    ', username=' + username +
    ', defaultPassword=' + defaultPassword +
    ', defaultRoles=' + defaultRoles;

UserProvisioning.UserProvisioningLog.log(uprId, inputParamsStr);
```

---

## UserProvisioningPlugin Class

`Process.Plugin`을 구현하는 베이스 클래스. 이 클래스를 상속(extends)하면 Flow Builder의 레거시 Apex 액션으로 사용자 프로비저닝 프로세스를 커스터마이즈할 수 있다.

### Flow 입력 파라미터 (기본 제공)

| 파라미터 | 설명 |
|---|---|
| `userProvisioningRequestId` | 플러그인이 처리할 UPR의 고유 ID |
| `userId` | 요청과 연결된 사용자 ID |
| `NamedCredDevName` | Named Credential API명 — 써드파티 인증 식별 |
| `reconFilter` | 사용자 수집 범위 제한 필터 |
| `reconOffset` | 사용자 수집 시작 오프셋 (10,000 DML 한도 우회용) |

> 추가 입력/출력 파라미터는 `buildDescribeCall()`에서 정의한다.

### Flow 출력 파라미터 (기본 제공)

| 파라미터 | 설명 |
|---|---|
| `Status` | 써드파티 프로비저닝 작업 상태 |
| `Details` | 써드파티 상태 관련 메시지 |
| `ExternalUserId` | 써드파티 사용자 고유 ID |
| `ExternalUsername` | 써드파티 사용자명 |
| `ExternalEmail` | 써드파티 이메일 |
| `ExternalFirstName` | 써드파티 이름 |
| `ExternalLastName` | 써드파티 성 |
| `reconState` | 수집 프로세스 상태 — `'complete'`이면 종료 |
| `nextReconOffset` | 트랜잭션 한도 초과 시 다음 호출 오프셋 |

### 메서드

```apex
public Process.PluginDescribeResult buildDescribeCall()
// 베이스 클래스의 입력/출력 파라미터에 추가 파라미터를 더할 때 재정의

public Process.PluginDescribeResult describe()
// Process.PluginDescribeResult 객체 반환 — 이 메서드 호출 기술

public String getPluginClassName()
// 플러그인을 구현한 클래스명 반환

public Process.PluginResult invoke(Process.PluginRequest request)
// 시스템이 클래스 인스턴스화 시 호출하는 핵심 메서드 — 재정의 필수
```

### 예제 — reconOffset으로 10,000 DML 한도 우회

```apex
global class SampleConnector extends UserProvisioning.UserProvisioningPlugin {

    // 추가 파라미터 정의
    global override Process.PluginDescribeResult buildDescribeCall() {
        Process.PluginDescribeResult describeResult = new Process.PluginDescribeResult();
        describeResult.inputParameters = new List<Process.PluginDescribeResult.InputParameter>{
            new Process.PluginDescribeResult.InputParameter(
                'testInputParam',
                Process.PluginDescribeResult.ParameterType.STRING,
                false
            )
        };
        describeResult.outputParameters = new List<Process.PluginDescribeResult.OutputParameter>{
            new Process.PluginDescribeResult.OutputParameter(
                'testOutputParam',
                Process.PluginDescribeResult.ParameterType.STRING
            )
        };
        return describeResult;
    }

    // 핵심 프로비저닝 로직 — reconOffset으로 5,000행씩 처리
    global override Process.PluginResult invoke(Process.PluginRequest request) {
        Map<String,String> result = new Map<String,String>();
        String uprId = (String) request.inputParameters.get('userProvisioningRequestId');

        UserProvisioning.UserProvisioningLog.log(uprId, 'Inserting Log from test Apex connector');

        UserProvisioningRequest upr = [
            SELECT id, operation, connectedAppId, state
            FROM userprovisioningrequest
            WHERE id = :uprId
        ];

        if (upr.operation.equals('Reconcile')) {
            String reconOffsetStr = (String) request.inputParameters.get('reconOffset');
            Integer reconOffset = 0;
            if (reconOffsetStr != null) {
                reconOffset = Integer.valueOf(reconOffsetStr);
            }

            if (reconOffset > 44999) {
                result.put('reconState', 'Completed');  // 5회 청크 후 종료
            }

            Integer i = 0;
            List<UserProvAccountStaging> upasList = new List<UserProvAccountStaging>();
            for (i = 0; i < 5000; i++) {
                UserProvAccountStaging upas = new UserProvAccountStaging();
                upas.Name = i + reconOffset + '';
                upas.ExternalFirstName = upas.Name;
                upas.ExternalEmail = 'externaluser@externalsystem.com';
                upas.LinkState = 'Orphaned';
                upas.Status = 'Active';
                upas.connectedAppId = upr.connectedAppId;
                upasList.add(upas);
            }
            insert upasList;
            result.put('nextReconOffset', reconOffset + 5000 + '');
        }

        return new Process.PluginResult(result);
    }
}
```

---

## 관련 노트

- [[Auth Namespace]] — OAuth JWT Bearer Token, 커넥티드 앱 인증
- [[Process Namespace]] — Process.Plugin, Process.PluginRequest, Process.PluginDescribeResult (deprecated, @InvocableMethod 권장)
- [[TxnSecurity Namespace]] — 트랜잭션 보안 정책
- [[Apex MOC]]
