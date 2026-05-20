---
tags: [apex, system-namespace, reference, access-level, assert, request, async-options, callable, domain, feature-management, user-info, uuid]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.3584–3616)
created: 2026-05-19
aliases: [System Namespace, System 네임스페이스, AccessLevel, AccessType, Assert 클래스, AsyncInfo, AsyncOptions, Callable, Domain, FeatureManagement, UserInfo, UUID, Request class, System.debug, System.enqueueJob]
---

# System Namespace

> Apex 코어 기능을 제공하는 최상위 네임스페이스. 디버그·스케줄·잡 실행부터 보안 모드 제어·사용자 정보 조회·UUID 생성까지 Apex 개발 전반에서 사용하는 빌트인 클래스·인터페이스·열거형을 포함한다.

---

## 네임스페이스 개요

`System` 네임스페이스는 Apex Reference Guide 기준으로 **60개 이상의 클래스·인터페이스·열거형**을 포함한다. 대부분은 접두어(`System.`) 없이 직접 사용하지만, 일부는 명시적 접두어가 필요하다.

---

## 핵심 클래스 분류

### 1. 데이터베이스 실행 모드 제어

#### AccessLevel Class

DML 및 SOQL 실행 시 보안 모드를 명시적으로 지정한다.

| 프로퍼티 | 설명 |
|---|---|
| `AccessLevel.USER_MODE` | 현재 사용자의 오브젝트 권한·FLS·공유 규칙 적용 |
| `AccessLevel.SYSTEM_MODE` | 현재 사용자 권한 무시, class sharing 키워드만 적용 |

```apex
// USER_MODE: 사용자 권한 없으면 SecurityException 발생
List<Account> toInsert = new List<Account>{new Account(Name = 'Acme')};
List<Database.SaveResult> sr = Database.insert(toInsert, AccessLevel.USER_MODE);

// SYSTEM_MODE: 사용자 권한 무관하게 실행
List<Database.SaveResult> sr2 = Database.insert(toInsert, AccessLevel.SYSTEM_MODE);
```

> 참고: v67.0(Summer '26)부터 sharing 선언 없는 클래스의 기본 실행 모드가 변경됨 → [[Summer '26]] 참조

**withPermissionSetId (Developer Preview)**

특정 권한 세트를 추가로 적용하여 DML을 실행한다.

```apex
// // 구조 예시 — 실제 동작 코드 아님 (Developer Preview — scratch org에서만 동작)
Id permissionSetId = [SELECT Id FROM PermissionSet WHERE Name = 'AllowCreateToAccount' LIMIT 1].Id;
Database.insert(new Account(Name = 'foo'), AccessLevel.User_mode.withPermissionSetId(permissionSetId));
```

#### AccessType Enum

`Security.stripInaccessible()` 의 `accessCheckType` 파라미터로 사용한다.

| 값 | 설명 |
|---|---|
| `CREATABLE` | 생성 접근 권한 체크 |
| `READABLE` | 읽기 접근 권한 체크 |
| `UPDATABLE` | 수정 접근 권한 체크 |
| `UPSERTABLE` | 삽입·수정 통합 접근 권한 체크 |

```apex
// StripInaccessible와 함께 사용
SObjectAccessDecision decision = Security.stripInaccessible(
    AccessType.READABLE,
    [SELECT Id, Name, AnnualRevenue FROM Account]
);
List<Account> sanitized = (List<Account>) decision.getRecords();
```

---

### 2. 비동기 잡 제어

#### AsyncInfo Class

현재 Queueable 스택 정보와 최소 지연 시간을 조회한다.

```apex
// 현재 스택 깊이와 최대 스택 깊이 확인
Integer currentDepth = System.AsyncInfo.getCurrentQueueableStackDepth();
Integer maxDepth     = System.AsyncInfo.getMaximumQueueableStackDepth();
Boolean isMaxSet     = System.AsyncInfo.hasMaxStackDepth();
```

#### AsyncOptions Class

`System.enqueueJob()` 에 전달하여 중복 Queueable 방지와 스택 깊이 제어를 한다.

```apex
AsyncOptions opts = new AsyncOptions();
opts.MaximumQueueableStackDepth = 5;
opts.DuplicateSignature = new QueueableDuplicateSignature.Builder()
    .addId(record.Id)
    .addString('MyJob')
    .build();
System.enqueueJob(new MyQueueable(), opts);
```

---

### 3. 테스트 / Assert

#### Assert Class (System.Assert)

`System.assert*` 계열 메서드를 클래스로 통합. Spring '24 이후 권장 패턴.

```apex
// 값 동일 비교 (구 System.assertEquals 대체)
Assert.areEqual(expected, actual);
Assert.areEqual(expected, actual, 'Message on fail');

// 값 불일치 확인
Assert.areNotEqual(notExpected, actual);

// null 확인
Assert.isNull(value);
Assert.isNotNull(value);

// true/false 확인
Assert.isTrue(condition);
Assert.isFalse(condition);

// 무조건 실패
Assert.fail('Should not reach here');
```

---

### 4. 현재 요청 컨텍스트

#### Request Class

현재 Salesforce 요청의 ID와 Quiddity 값을 조회한다.

```apex
// 현재 실행 컨텍스트 식별
System.Quiddity q = Request.getCurrent().getQuiddity();

// REST 요청인지 확인
Boolean isRest = (q == Quiddity.SYNCHRONOUS);

// 요청 ID 조회 (로그 상관관계 추적에 유용)
String requestId = Request.getCurrent().getRequestId();
```

`Quiddity` 열거형 값: `BATCH_APEX`, `FUTURE`, `QUEUEABLE`, `SCHEDULED`, `AURA`, `VF`, `REST`, `SYNCHRONOUS` 등 → [[QuiddityGuard]] 참조

---

### 5. 도메인 / URL 조회

#### Domain Class

Salesforce 도메인 정보를 조회한다.

```apex
// Org에 등록된 도메인 목록
List<System.Domain> domains = DomainCreator.getOrgDomains();
for (System.Domain d : domains) {
    String domainType = String.valueOf(d.getDomainType()); // MY_DOMAIN, SANDBOX 등
}
```

#### DomainCreator Class

Org의 특정 용도별 호스트명을 반환한다.

```apex
// Visualforce 호스트명 조회 (예: MyDomain.vf.force.com)
String vfHost = DomainCreator.getVisualforceHostname();
```

#### URL Class

현재 Org의 베이스 URL을 조회한다.

```apex
// 현재 Org의 Salesforce 인스턴스 URL
String baseUrl = URL.getOrgDomainUrl().toExternalForm();
// 예: https://mycompany.my.salesforce.com

// 현재 세션의 서버 URL (Visualforce 등)
String serverUrl = URL.getSalesforceBaseUrl().toExternalForm();
```

---

### 6. 패키지 관리

#### FeatureManagement Class (System.FeatureManagement)

관리 패키지 내 Feature Parameter 값을 조회·변경하고, 커스텀 권한을 확인한다.

```apex
// Boolean Feature Parameter 조회
Boolean isEnabled = FeatureManagement.checkPackageBooleanValue('My_Feature__c');

// Integer Feature Parameter 조회
Integer limit = FeatureManagement.checkPackageIntegerValue('Api_Limit__c');

// 커스텀 퍼미션 확인
Boolean hasPerm = FeatureManagement.checkPermission('My_Custom_Permission');
```

---

### 7. 사용자 정보

#### UserInfo Class

현재 실행 컨텍스트의 사용자 정보를 조회한다.

```apex
// 자주 사용하는 UserInfo 메서드
String userId       = UserInfo.getUserId();
String userName     = UserInfo.getUserName();           // 로그인 이름
String userEmail    = UserInfo.getUserEmail();
String orgId        = UserInfo.getOrganizationId();
String orgName      = UserInfo.getOrganizationName();
String locale       = UserInfo.getLocale();
String language     = UserInfo.getLanguage();
String timeZone     = UserInfo.getTimeZone().toString();
String profileId    = UserInfo.getProfileId();
Boolean isMultiCurr = UserInfo.isMultiCurrencyOrganization();
```

---

### 8. UUID

#### UUID Class

Version 4 UUID를 생성한다. (Spring '24 GA)

```apex
// 랜덤 UUID 생성
UUID id1 = UUID.randomUUID();
String uuidStr = id1.toString(); // 예: '550e8400-e29b-41d4-a716-446655440000'

// UUID 비교
UUID id2 = UUID.randomUUID();
Boolean same = id1.equals(id2); // false (각각 랜덤)
```

---

### 9. Callable 인터페이스

패키지 간 공통 인터페이스로 느슨한 결합을 구현한다.

```apex
// 구현 측 (패키지 A)
public class MyService implements Callable {
    public Object call(String action, Map<String, Object> args) {
        if (action == 'greet') {
            return 'Hello, ' + (String) args.get('name');
        }
        throw new IllegalArgumentException('Unknown action: ' + action);
    }
}

// 호출 측 (패키지 B — 컴파일 타임 의존성 없이 호출)
Callable svc = (Callable) Type.forName('packageA', 'MyService').newInstance();
String result = (String) svc.call('greet', new Map<String, Object>{'name' => 'World'});
```

---

### 10. System 클래스 (System.System)

디버그·잡 스케줄·잡 일시정지 등 핵심 시스템 오퍼레이션을 담당한다.

```apex
// 디버그 로그
System.debug('Message');
System.debug(LoggingLevel.WARN, 'Warning: ' + someVar);

// 비동기 잡 실행
Id jobId = System.enqueueJob(new MyQueueable());

// 스케줄 잡 등록
String cronExp = '0 0 2 * * ?'; // 매일 오전 2시
System.schedule('Daily Job', cronExp, new MySchedulable());

// 배치 스케줄 (특정 배치)
System.scheduleBatch(new MyBatch(), 'Batch Label', 60); // 60분 후 실행

// 스케줄 잡 일시정지 / 재개 (Spring '25 GA)
System.pauseJobById(jobId);
System.resumeJobById(jobId);

// 현재 시간
DateTime now   = System.now();
Date    today  = System.today();

// 트랜잭션 제어
System.Savepoint sp = System.setSavepoint();
System.rollback(sp);

// 거버너 한도 확인 (Limits 클래스 참조)
Integer soqlUsed = Limits.getQueries();
```

---

## 비교표 — AccessLevel 선택 기준

| 상황 | 권장 모드 | 이유 |
|---|---|---|
| 사용자 대면 화면에서 DML | `USER_MODE` | FLS·공유 규칙 자동 적용 |
| 시스템 관리 배치 작업 | `SYSTEM_MODE` | 권한 제한 없이 전체 데이터 처리 |
| 관리자만 호출하는 유틸리티 | `SYSTEM_MODE` | 불필요한 권한 체크 방지 |
| 보안 검증 필요한 API | `USER_MODE` + `AccessType.READABLE` | StripInaccessible 병행 사용 |

---

## System Namespace 전체 클래스 목록 (요약)

PDF p.3584–3591 기준 주요 클래스 (총 60개 이상):

| 클래스/인터페이스/열거형 | 한 줄 설명 |
|---|---|
| `AccessLevel` | DML/SOQL 실행 모드 (USER_MODE, SYSTEM_MODE) |
| `AccessType` | stripInaccessible 접근 체크 타입 열거형 |
| `Address` | 주소 컴파운드 필드 접근 (getCity, getLatitude 등) |
| `Assert` | 테스트 단언 메서드 (areEqual, isTrue, fail 등) |
| `AsyncInfo` | 현재 Queueable 스택 깊이 조회 |
| `AsyncOptions` | enqueueJob 파라미터 (스택 깊이, 중복 시그니처) |
| `Callable` | 패키지 간 느슨한 결합 인터페이스 |
| `Crypto` | 암호화·해시·MAC·서명 → [[Apex 표준 클래스 레퍼런스]] |
| `Database` | DML·SOQL·Cursor → [[Database Namespace 상세]] |
| `Domain` / `DomainCreator` / `URL` | Org 도메인·URL 조회 |
| `EventBus` | Platform Event 발행 → [[EventBus Namespace]] |
| `FeatureManagement` | 패키지 Feature Parameter·커스텀 퍼미션 확인 |
| `Http` / `HttpRequest` / `HttpResponse` | HTTP Callout |
| `JSON` / `JSONGenerator` / `JSONParser` | JSON 직렬화·역직렬화 |
| `Limits` | 거버너 한도 잔여량 조회 → [[Apex 표준 클래스 레퍼런스]] |
| `Math` | 수학 연산 (max, min, abs, random 등) |
| `Network` | Experience Cloud 사이트 관리 |
| `OrgLimit` / `OrgLimits` | Org 전체 한도 조회 |
| `Pattern` / `Matcher` | 정규식 매칭 |
| `Queueable` / `QueueableContext` | 비동기 잡 인터페이스 → [[Queueable]] |
| `QueueableDuplicateSignature` | Queueable 중복 방지 시그니처 |
| `Quiddity` | 실행 컨텍스트 열거형 → [[QuiddityGuard]] |
| `Request` | 현재 요청 ID·Quiddity 조회 |
| `RestContext` / `RestRequest` / `RestResponse` | 인바운드 REST → [[Custom REST Endpoint]] |
| `Schedulable` / `SchedulableContext` | 스케줄 잡 인터페이스 → [[Scheduled Apex]] |
| `Schema` | 메타데이터 Describe → [[Schema Namespace 상세]] |
| `Search` | 동적 SOSL → [[Search Namespace]] |
| `Security` | stripInaccessible → [[StripInaccessible]] |
| `SObject` | SObject 기본 메서드 |
| `SoqlStubProvider` | Data 360 DMO 목 테스트 |
| `StubProvider` | Apex 목 프레임워크 → [[StubProvider]] |
| `System` (클래스) | debug, enqueueJob, schedule, now, today, setSavepoint |
| `Test` | @isTest 전용 메서드 → [[테스트 전략]] |
| `Trigger` | 트리거 컨텍스트 (Trigger.new, Trigger.old 등) |
| `TriggerOperation` | 트리거 이벤트 열거형 (BEFORE_INSERT 등) |
| `Type` | Apex 타입 동적 조회·인스턴스화 |
| `URL` | Org 베이스 URL 조회 |
| `UserInfo` | 현재 사용자 정보 |
| `UserManagement` | 사용자 검증 메서드·개인정보 제거 |
| `UUID` | Version 4 UUID 생성·비교 |
| `Version` | 패키지 버전 비교 |
| `WebServiceCallout` | SOAP Callout (WSDL 자동 생성) |
| `XmlStreamReader` / `XmlStreamWriter` | 스트리밍 XML 파싱·작성 |

---

## 관련 노트

- [[Apex 표준 클래스 레퍼런스]] — String / List / Map / Crypto / JSON / Limits / Math / Database 전체 API
- [[Database Namespace 상세]] — Database.insert/update/Cursor/SaveResult/LeadConvert 상세
- [[StripInaccessible]] — AccessType과 함께 사용하는 FLS 필드 제거
- [[WITH USER_MODE]] — SOQL 인라인 보안 키워드 (AccessLevel과 함께 보안 전략 수립)
- [[QuiddityGuard]] — Quiddity 열거형 기반 실행 컨텍스트 판별
- [[Scheduled Apex]] — System.schedule / System.scheduleBatch 사용 패턴
- [[Queueable]] — System.enqueueJob / AsyncOptions 활용
- [[Schema Namespace 상세]] — Schema.getGlobalDescribe / DescribeSObjectResult
- [[EventBus Namespace]] — EventBus.publish / TriggerContext
- [[Custom REST Endpoint]] — RestContext / RestRequest / RestResponse
- [[Summer '26]] — USER_MODE 기본값 변경 파괴적 변경 (v67.0)
