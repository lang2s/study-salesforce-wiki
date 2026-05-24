---
tags: [devops, metadata-api, metadata-types, apex, lwc, visualforce, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [ApexClass 메타데이터, ApexTrigger 메타데이터, ApexPage 메타데이터, LightningComponentBundle 메타데이터, AuraDefinitionBundle 메타데이터, StaticResource 메타데이터, Apex 코드 메타데이터 타입]
---

# Metadata Types — Apex & Code

> Apex 클래스·트리거·페이지, LWC·Aura 번들, 정적 리소스 등 코드 관련 메타데이터 타입 상세 필드 정의.

---

## 이 그룹의 타입 목록

| 타입명 | 파일 경로 패턴 | API 버전 |
|---|---|---|
| ApexClass | `classes/ClassName.cls` + `ClassName.cls-meta.xml` | v10.0+ |
| ApexComponent | `components/ComponentName.component` + `-meta.xml` | v12.0+ |
| ApexEmailNotifications | `apexEmailNotifications/apexEmailNotifications.notifications` | v49.0+ |
| ApexPage | `pages/PageName.page` + `PageName.page-meta.xml` | v11.0+ |
| ApexTestSuite | `testSuites/SuiteName.testSuite` | v38.0+ |
| ApexTrigger | `triggers/TriggerName.trigger` + `-meta.xml` | v10.0+ |
| AuraDefinitionBundle | `aura/BundleName/` | - |
| DataWeaveResource | - | - |
| FunctionReference | - | - |
| LightningComponentBundle | `lwc/ComponentName/` | - |
| LightningMessageChannel | `messageChannels/ChannelName.messageChannel-meta.xml` | - |
| LightningTypeBundle | - | - |
| StaticResource | `staticresources/ResourceName.resource` + `-meta.xml` | - |

---

## ApexClass

Apex 클래스. 클래스, 사용자 정의 메서드, 변수, 예외 타입, 정적 초기화 코드 포함. `MetadataWithContent` 타입을 extends.

**Supported Calls:** CRUD-Based Calls 제외한 모든 Metadata API 호출.

**파일 경로:** `classes/ClassName.cls` + `ClassName.cls-meta.xml`

**주의:** 활성 Apex 작업이 있는 경우 기본적으로 업데이트 배포 불가. 해결:
1. 배포 전 Apex 작업 취소 후 재스케줄
2. Setup → Deployment Settings → "Enable deployments with Apex jobs" 활성화

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | - | 클래스 생성 시 지정된 API 버전 |
| `content` | base64 | - | Apex 클래스 정의. Base64 인코딩. `MetadataWithContent`에서 상속 |
| `fullName` | string | - | 클래스 이름. 문자·숫자·언더스코어만 허용, 문자로 시작, 언더스코어로 끝 불가. `Metadata`에서 상속 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 목록 (v16.0+) |
| `status` | ApexCodeUnitStatus (enum) | - | `Active` / `Deleted` (ApexClass는 `Inactive` 미지원) |

### PackageVersion 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `namespace` | string | Required | 네임스페이스 프리픽스 (1~15자 영숫자, 대소문자 구분 없음) |
| `majorNumber` | int | Required | 메이저 버전 번호 |
| `minorNumber` | int | Required | 마이너 버전 번호 |

### Declarative Metadata 예시

```xml
<!-- MyHelloWorld.cls-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>66.0</apiVersion>
</ApexClass>
```

```java
// MyHelloWorld.cls
public class MyHelloWorld {
    public static void addHelloWorld(Account[] accs) {
        for (Account a : accs) {
            if (a.Hello__c != 'World') a.Hello__c = 'World';
        }
    }
}
```

**와일드카드(`*`) 지원:** 예

---

## ApexComponent

Visualforce 컴포넌트. `MetadataWithContent` 타입을 extends.

**파일 경로:** `components/ComponentName.component` + `ComponentName.component-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | - | VF 컴포넌트 API 버전 (v16.0+) |
| `content` | base64Binary | - | 컴포넌트 내용. Base64 인코딩. `MetadataWithContent` 상속 |
| `description` | string | - | 컴포넌트 설명 |
| `fullName` | string | - | 컴포넌트 개발자 이름. `Metadata` 상속 |
| `label` | string | Required | 컴포넌트 레이블 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 (v16.0+) |

**와일드카드(`*`) 지원:** 예

---

## ApexEmailNotifications

Apex 오류 이메일 알림 수신자 정의. Flow 오류에도 사용.

**파일 경로:** `apexEmailNotifications/apexEmailNotifications.notifications`

**주의:** 배포 시 기존 org의 모든 알림이 삭제되고 배포된 목록으로 교체된다. `destructiveChanges.xml` 미지원.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apexEmailNotification` | ApexEmailNotification | - | 개별 이메일 알림. 여러 개 지정 가능 |

### ApexEmailNotification 서브타입

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `email` | string | - | 외부 이메일 주소. `user` 필드와 상호 배타적 |
| `user` | string | - | Salesforce 사용자 이름. `email` 필드와 상호 배타적 |

### Declarative Metadata 예시

```xml
<!-- apexEmailNotifications.notifications — 외부 이메일 알림 -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexEmailNotifications xmlns="http://soap.sforce.com/2006/04/metadata">
  <apexEmailNotification>
    <email>admin@example.com</email>
  </apexEmailNotification>
</ApexEmailNotifications>
```

```xml
<!-- package.xml — 와일드카드 사용 -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>ApexEmailNotifications</name>
  </types>
  <version>49.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예

---

## ApexPage

Visualforce 페이지. `MetadataWithContent` 타입을 extends.

**파일 경로:** `pages/PageName.page` + `PageName.page-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | Required | VF 페이지 API 버전 (v15.0+). 15.0 미만 입력 시 15.0으로 변경 |
| `availableInTouch` | boolean | - | Salesforce 모바일 앱에서 VF 탭 사용 여부 (v27.0+). 표준 오브젝트 탭 VF 재정의는 미지원 |
| `confirmationTokenRequired` | boolean | - | GET 요청에 CSRF 토큰 필요 여부 (v28.0+). true로 변경 시 링크에 토큰 추가 필요 |
| `content` | base64Binary | - | 페이지 내용. Base64 인코딩. `MetadataWithContent` 상속 |
| `description` | string | - | 페이지 설명 |
| `fullName` | string | - | 페이지 개발자 이름. `Metadata` 상속 |
| `label` | string | Required | 페이지 레이블 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 (v16.0+) |

### Declarative Metadata 예시

```xml
<!-- SampleApexPage.page-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexPage xmlns="http://soap.sforce.com/2006/04/metadata">
  <description>This is a sample Visualforce page.</description>
  <label>SampleApexPage</label>
</ApexPage>
```

```html
<!-- SampleApexPage.page -->
<apex:page>
  <h1>Congratulations</h1>
  This is your new Page.
</apex:page>
```

**와일드카드(`*`) 지원:** 예

---

## ApexTestSuite

Apex 테스트 스위트 — 테스트 실행에 포함할 Apex 테스트 클래스 목록.

**파일 경로:** `testSuites/SuiteName.testSuite`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `testClassName` | string[] | - | 이 스위트에 포함할 Apex 테스트 클래스 이름 목록 |

### Declarative Metadata 예시

```xml
<!-- MyTestSuite.testSuite — 네임스페이스·와일드카드 혼용 -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexTestSuite xmlns="http://soap.sforce.com/2006/04/metadata">
  <testClassName>LocalTestClass</testClassName>
  <testClassName>A*Class</testClassName>           <!-- AClass, AnotherClass 등 -->
  <testClassName>Namespace1.NamespacedTestClass</testClassName>
  <testClassName>*</testClassName>                 <!-- 로컬 테스트 전체 -->
  <testClassName>Namespace1.*</testClassName>       <!-- Namespace1의 모든 테스트 -->
</ApexTestSuite>
```

```xml
<!-- package.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<Package xmlns="http://soap.sforce.com/2006/04/metadata">
  <types>
    <members>*</members>
    <name>ApexClass</name>
  </types>
  <types>
    <members>Suite1</members>
    <members>Suite2</members>
    <name>ApexTestSuite</name>
  </types>
  <version>38.0</version>
</Package>
```

**와일드카드(`*`) 지원:** 예

---

## ApexTrigger

Apex 트리거. DML 이벤트 전후에 실행되는 Apex 코드. `MetadataWithContent` 타입을 extends.

**Supported Calls:** CRUD-Based Calls 제외한 모든 Metadata API 호출.

**파일 경로:** `triggers/TriggerName.trigger` + `TriggerName.trigger-meta.xml`

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `apiVersion` | double | Required | 트리거 생성 시 지정된 API 버전 |
| `content` | base64 | - | Apex 트리거 정의. `MetadataWithContent` 상속 |
| `fullName` | string | - | 트리거 이름. `Metadata` 상속 |
| `packageVersions` | PackageVersion[] | - | 참조된 관리형 패키지 버전 목록 (v16.0+) |
| `status` | ApexCodeUnitStatus (enum) | Required | `Active` / `Inactive` / `Deleted` |

### Declarative Metadata 예시

```xml
<!-- MyHelloWorld.trigger-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>66.0</apiVersion>
</ApexTrigger>
```

```apex
// MyHelloWorld.trigger
trigger helloWorldAccountTrigger on Account (before insert) {
    Account[] accs = Trigger.new;
    MyHelloWorld.addHelloWorld(accs);
}
```

**와일드카드(`*`) 지원:** 예

---

## AuraDefinitionBundle

Aura 정의 번들. Aura 컴포넌트, 애플리케이션, 이벤트, 인터페이스, 토큰 컬렉션 및 관련 리소스(JavaScript 컨트롤러 등) 포함.

**파일 경로:** `aura/BundleName/`

---

## DataWeaveResource

DataWeave 스크립트 리소스. `DataWeaveScriptResource` 클래스가 생성되며, Apex에서 직접 호출 가능.

---

## FunctionReference

배포된 Salesforce Function 참조 정보. `Metadata` 타입을 extends.

---

## LightningComponentBundle

Lightning Web Component 번들. LWC 리소스를 포함하는 번들.

**파일 경로:** `lwc/ComponentName/`

---

## LightningMessageChannel

Lightning Message Channel. LWC, Aura, Visualforce 간 크로스-UI 통신을 위한 보안 채널.

**파일 경로:** `messageChannels/ChannelName.messageChannel-meta.xml`

---

## LightningTypeBundle

커스텀 Lightning 타입. 기본 UI 재정의로 비즈니스 요구에 맞는 커스텀 외관 구현.

---

## StaticResource

정적 리소스 파일. ZIP, 이미지, CSS, JavaScript 등. Visualforce 페이지에서 참조. org 내부 전용 (다른 앱/웹사이트 호스팅 불가).

**파일 경로:** `staticresources/ResourceName.resource` + `ResourceName.resource-meta.xml`

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록 및 분류
- [[Metadata API File-Based 호출]] — package.xml에 ApexClass, LightningComponentBundle 등 지정
- [[Metadata API CRUD 호출]] — createMetadata()로 Apex 클래스 생성
- [[Metadata API 에러 처리]] — Apex 배포 오류 처리
- [[2GP — Components: Apex & Code]] — 동일 컴포넌트의 2GP 패키징 관점 Manageability Rules 전수
