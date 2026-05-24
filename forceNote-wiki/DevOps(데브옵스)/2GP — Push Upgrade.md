---
tags: [DevOps, Packaging, 2GP, ManagedPackage, PushUpgrade, PackagePushRequest, PackagePushJob, PackagePushError, PackageSubscriber, SOAPAPI, ISV, 푸시업그레이드, 강제업그레이드, 패키지업그레이드]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.364-373
created: 2026-05-24
aliases: [2GP Push Upgrade, Push a Package Upgrade for Second-Generation Managed Packages, push upgrade 2GP, sf package push-upgrade, PackagePushRequest, PackagePushJob, PackagePushError, PackageSubscriber, 2GP 푸시 업그레이드, 강제 패키지 업그레이드, 구독자 org 업그레이드, PushUpgradeCustomizationRepository, Enable a Package Subscriber to Restrict Push Upgrades, Assign Access to New and Changed Features, Push Upgrade Best Practices, Schedule a Push Upgrade]
---

# 2GP — Push Upgrade (구독자 org 강제 업그레이드)

> ISV가 2GP managed package를 subscriber org에 강제로 배포하는 Push Upgrade 전 과정을 다룬다. CLI·SOAP API 두 가지 방식으로 업그레이드를 스케줄·추적·취소하고, 구독자가 업그레이드를 차단할 수 있는 Customized Push Upgrade 설정, 신규 기능 접근 권한 자동 할당 Post Install Script, Best Practices를 전수 정리한다.

---

## 1. Push Upgrade 개요

Push upgrades enable you to upgrade second-generation managed packages installed in subscriber orgs, **without asking customers to install the upgrade themselves**. 업그레이드 대상 org·버전·시간을 ISV가 직접 지정할 수 있으며, hot bug fix 배포에 특히 유용하다.

Salesforce CLI 또는 SOAP API를 사용해 Push Upgrade를 시작하고, 각 job의 상태를 추적하고, 실패 시 오류 메시지를 확인한다.

### 1-1. 패키지 타입별 Push Upgrade 지원 여부

| Package Type | CLI | API | Setup UI |
|---|---|---|---|
| 2GP | ✅ | ✅ | ❌ |
| 1GP | ❌ | ✅ | ✅ |
| Unlocked | ✅ | ✅ | ❌ |

### 1-2. Push Upgrade 활성화 조건

- **AppExchange Security Review 통과** 필수 (1GP·2GP managed 패키지 공통)
- Push Upgrade 기능 활성화: Salesforce Partner Support에 케이스를 열어 요청 (p.406 참조)
- Unlocked Package는 Push Upgrade가 **기본 활성화**되어 있음
- 2GP push upgrade CLI 명령은 **2GP·Unlocked** 패키지에만 사용 가능

### 1-3. Push Upgrade Considerations for Second-Generation Managed Packages

- AppExchange Security Review를 통과한 패키지에만 Push Upgrade 가능
- 패키지 버전 업그레이드에 적용되는 **Manageability Rules**가 Push Upgrade에도 동일하게 적용
- Push Upgrade 설치 시 패키지 내 Apex 코드가 컴파일됨
- 패키지 버전이 비밀번호(Installation Key)를 요구하는 경우에도 Push Upgrade 사용 가능

---

## 2. Schedule a Push Upgrade Using CLI

CLI를 사용해 Push Upgrade를 스케줄·추적·취소한다. Push Upgrade를 시작하려면 **Create and Update Second-Generation Packages** 사용자 권한이 필요하다.

Push Upgrade 스케줄링의 고수준 흐름:

1. 업그레이드할 구독자 org와 org ID 파악
2. Push Upgrade 스케줄 설정
3. 진행·완료 상태 추적

필요 시 스케줄된 Push Upgrade 취소 또는 오류 분석도 수행한다.

> 참고: Partner는 특정 고객에게 Push Upgrade 차단 권한을 부여할 수 있다 — "Enable a Package Subscriber to Restrict Push Upgrades" 참조.

### 2-1. Determine the Orgs to Be Upgraded

Push Upgrade 전용 CLI 명령은 없으며, `sf data query` 명령으로 대상 org를 파악한다. Push Upgrade는 **패키지를 소유한 Dev Hub org 컨텍스트**에서 수행해야 한다.

Dev Hub org 인증:

```bash
sf org login web --set-default-dev-hub
```

쿼리에는 **Subscriber Package ID(033으로 시작)** 또는 **Subscriber Package Version ID(04t로 시작)**가 필요하다.
- Subscriber Package ID 조회: `sf package list --verbose`
- Subscriber Package Version ID 조회: `sf package version list`

#### Query Example 1: 특정 패키지가 설치된 모든 org 목록

```bash
sf data query --target-org myDevHub \
  --query "SELECT OrgKey, OrgName, OrgType, InstanceName, MetadataPackageId, MetadataPackageVersionId FROM PackageSubscriber WHERE MetadataPackageId = '033xxxxxxxxxxxxxxx'" \
  --result-format json
```

- `--target-org`: 패키지를 소유한 Dev Hub org (username 또는 alias)
- `MetadataPackageId`: 033으로 시작하는 Subscriber Package ID

#### Query Example 2: 특정 버전이 설치된 org 목록 → CSV 파일 출력

```bash
sf data query --target-org myDevHub \
  --query "SELECT OrgKey, OrgName, OrgType FROM PackageSubscriber WHERE MetadataPackageVersionId = '04t…'" \
  --result-format csv
```

CSV 파일을 `push-upgrade schedule` 명령에 사용하려면 **첫 번째 줄(헤더)을 제거**해야 한다. CSV 파일은 org ID만 한 줄에 하나씩 포함해야 한다.

#### Query Example 3: 특정 버전보다 낮은 버전이 설치된 org 목록 (2단계 쿼리)

> 참고: 패키지에는 Package ID(0Ho)와 Subscriber Package ID(033) 두 가지가 있다. 아래 Step 1에서는 0Ho ID를 사용해야 한다.

**Step 1 — 지정 버전(2.7)보다 낮은 Package Version ID 조회:**

```bash
sf data query --target-org admin@packaging.com \
  --use-tooling-api \
  --query "SELECT SubscriberPackageVersionId FROM Package2Version WHERE Package2Id = '0HoPACKAGEIDxxxx' AND (MajorVersion < 2 OR (MajorVersion = 2 AND MinorVersion < 7))"
```

**Step 2 — Step 1의 04t ID들로 PackageSubscriber 조회:**

```bash
sf data query --target-org myDevHub \
  --query "SELECT OrgKey FROM PackageSubscriber WHERE MetadataPackageVersionId IN ('04tID1', '04tID2', '04tID_etc')" \
  --result-format csv > out.txt
```

CSV 파일을 다음 명령에 사용하기 전에 첫 번째 줄을 제거해야 한다.

### 2-2. Schedule a Package Push Upgrade

대상 org ID를 확보한 후 `sf package push-upgrade schedule` 명령으로 Push Upgrade를 스케줄한다.

업그레이드 대상 org 지정 방법:
- `--org-file`: CSV 파일 경로 (org ID를 한 줄에 하나씩)
- `--org-list`: org ID 쉼표 구분 목록을 CLI에서 직접 지정

#### 예시: 지정 시간에 org ID 목록으로 스케줄

```bash
sf package push-upgrade schedule \
  --package 04txyz \
  --start-time "2024-12-06T21:00:00" \
  --org-list 00DAxx, 00DBx
```

#### 예시: 즉시 실행 (가능한 한 빨리) — CSV 파일 사용

```bash
sf package push-upgrade schedule \
  --package 04txyz \
  --org-file upgrade-orgs.csv
```

> 참고: `--start-time`을 지정하지 않으면 리소스가 가용한 즉시 Push Upgrade가 시작된다. 시작 시간은 **UTC**로 지정하며, off-peak 시간대에 스케줄하는 것을 권장한다.

### 2-3. Retrieve Details about Scheduled Package Push Upgrades

`sf package push-upgrade list` 또는 `sf package push-upgrade report` 명령으로 스케줄됐거나 완료된 Push Upgrade 세부 정보를 조회한다.

#### package push-upgrade list 예시

```bash
# 특정 패키지의 모든 Push Upgrade 요청 목록
sf package push-upgrade list --package 033xyz --target-dev-hub myDevHub

# 최근 30일 이내 스케줄된 요청 목록
sf package push-upgrade list --package 033xyz --scheduled-last-days 30 --target-dev-hub myDevHub

# 상태가 Failed인 요청 목록 (하나 이상의 org에서 실패한 경우)
sf package push-upgrade list --package 033xyz --status Failed

# 상태가 Succeeded인 요청 목록
sf package push-upgrade list --package 033xyz --status Succeeded
```

`package push-upgrade list` 출력 필드:
- Push Request ID
- Package Version ID
- Package Version Number
- Status (Push Upgrade 요청 상태)
- Scheduled Start Date/Time
- 스케줄된 org 수
- 성공한 org 수
- 실패한 org 수
- Created Date/Time

#### package push-upgrade report 예시

```bash
sf package push-upgrade report --push-request-id 0DVxyz --target-dev-hub myDevHub
```

`package push-upgrade report`는 오류 세부 정보를 포함한 추가 정보를 제공한다.

### 2-4. Cancel a Pending Package Push Upgrade Request

Push Upgrade 요청 상태가 **Created** 또는 **Pending**이면 취소할 수 있다.

```bash
sf package push-upgrade abort --push-request-id 0DVxyz
```

취소 전에 `package push-upgrade list` 또는 `package push-upgrade report`로 현재 상태를 확인한다.

### 2-5. Retrieve Error Messages for a Package Push Upgrade

오류 메시지 전용 CLI 명령은 없으며, `sf data query`로 `PackagePushError` 오브젝트를 조회한다.

```bash
sf data query \
  --query "SELECT Id, PackagePushJobId, PackagePushJob.SubscriberOrganizationKey, ErrorDetails, ErrorMessage, ErrorSeverity, ErrorTitle, ErrorType FROM PackagePushError WHERE PackagePushJob.PackagePushRequestId='$PUSH_REQUEST_ID'" \
  --target-org myDevHub
```

---

## 3. Schedule a Push Upgrade Using SOAP API

1GP 및 2GP managed package 모두 지원. SOAP API를 사용하면 더 세밀한 제어가 가능하다.

SOAP API Push Upgrade 절차:

1. Dev Hub org에 인증
2. `MetadataPackage`를 쿼리해 패키지 세부 정보 확인
3. `MetadataPackageVersion`을 쿼리해 업그레이드에 사용할 패키지 버전 확인
4. `PackageSubscriber`를 쿼리해 구독자 org ID와 설치된 패키지 버전 정보 조회 (2,000개 초과 시 SOAP API `queryMore()` 호출 사용)
5. `PackagePushRequest` 오브젝트 생성 — `PackageVersionId`와 `ScheduledStartTime`(선택) 지정. `ScheduledStartTime` 생략 시 상태를 Pending으로 변경할 때 Push 시작
6. 각 구독자마다 `PackagePushJob` 생성 — 이전 단계의 `PackagePushRequest`와 연결
7. `PackagePushRequest` 상태를 **Pending**으로 변경해 Push Upgrade 스케줄

> 참고: 스케줄된 Push Upgrade는 Salesforce 인스턴스에 리소스가 가용한 시점에 시작된다. 지정한 시작 시간 이후 몇 시간 뒤에 시작될 수도 있다.

> 참고: Partner는 특정 고객에게 Push Upgrade 차단 권한을 부여할 수 있다 — "Enable a Package Subscriber to Restrict Push Upgrades" 참조.

---

## 4. Enable a Package Subscriber to Restrict Push Upgrades

특정 시나리오에서 Salesforce 고객이 설치된 managed package의 Push Upgrade를 차단해야 할 수 있다. **Customized Push Upgrades**는 Salesforce Partner가 특정 고객 org의 특정 패키지에 대해 Push Upgrade를 제한하는 권한을 부여한다.

설정은 **Salesforce Partner 단계**와 **Salesforce Customer 단계** 두 단계로 나뉜다.

### 4-1. Step 1 — Salesforce Partner: Customized Push Upgrade 활성화

1. 1GP packaging org 또는 Dev Hub org(managed 2GP)에 시스템 관리자 계정으로 로그인
2. 기어 아이콘 → Developer Console 선택
3. Debug → Open Execute Anonymous Window 선택
4. 아래 코드를 입력 (packageID와 subscriberOrgID를 실제 값으로 교체):

```apex
String pucId1 = PushUpgradeCustomizationRepository.create('packageID', 'subscriberOrgID', true);
System.debug('pucId1 =' + pucId1);
```

만료 기간을 설정하려면 (예: 90일 후 만료):

```apex
String pucId1 = PushUpgradeCustomizationRepository.create('packageID', 'subscriberOrgID', true, 90);
System.debug('pucId1 =' + pucId1);
```

여러 Production org에 Push Upgrade 차단 권한 부여:

```apex
String pucId1 = PushUpgradeCustomizationRepository.create('packageID', 'subscriberOrgID', true);
System.debug('pucId1 =' + pucId1);
String pucId2 = PushUpgradeCustomizationRepository.create('packageID', 'subscriberOrgID', true);
System.debug('pucId2 =' + pucId2);
```

5. Open Log → Execute 클릭
6. Debug Only 체크박스 클릭 후 Push Upgrade Customization 레코드 생성 확인
   - 레코드 예시: `11:09:15:814 USER_DEBUG [2]|DEBUG|pucId1 =12COK000000000B`
7. Salesforce Customer에게 Customized Push Upgrade 활성화 완료를 알림

> 참고: Sandbox org는 부모 Production org가 Push Upgrade 차단 권한을 부여받은 경우 자동으로 차단 권한을 가짐

### 4-2. Step 2 — Salesforce Customer: Push Upgrade 차단 (Setup에서)

1. 고객 org에 로그인
2. Setup → Installed Packages → 차단할 패키지 선택
3. **Block Push Upgrades** 선택
4. **Push upgrades are now blocked** 체크박스 선택 확인

Salesforce Customer는 **Allow Push Upgrades** 버튼으로 언제든지 Push Upgrade를 다시 허용할 수 있다. 차단 중에는 패키지 업그레이드를 수동으로만 설치할 수 있다.

### 4-3. PushUpgradeCustomizationRepository 관리

Salesforce Partner는 `PushUpgradeCustomizationRepository` Apex 클래스로 기존 Customized Push Upgrade를 조회·관리할 수 있다.

만료 기간 업데이트 (index 기반):

```apex
PushUpgradeCustomizationRepository.setExpirationDaysForIndex('packageID', 'subscriberOrgID', 100);
System.debug('Expiration days updated successfully');
```

만료 기간 업데이트 (PushUpgradeCustomization 레코드 ID 기반, 예: 120일로 변경):

```apex
PushUpgradeCustomizationRepository.setExpirationDaysForId('12Cxx000000ABCDEF1', 120);
System.debug('Expiration days updated successfully');
```

> 참고: 고객이 구독자 org에서 Push Upgrade를 차단한 상태이면 만료 기간을 **단축(감소)**하는 것은 불가능하다.

### 4-4. Customized Push Upgrade 주의사항

- managed 2GP에 Customized Push Upgrade가 활성화된 상태에서 패키지 소유권을 다른 Dev Hub로 이전하면, 새 Dev Hub는 필요한 권한을 유지하지 않으며 `PushUpgradeCustomizationRepository` 레코드도 유지되지 않는다. 새 Dev Hub로 이전 후 Step 1과 2를 다시 수행해야 한다.
- **Patch 버전**이 설치된 org에서는 Push Upgrade를 차단할 수 없다. 고객은 비-patch 버전으로 업그레이드한 후 차단해야 한다.

---

## 5. Assign Access to New and Changed Features

Push Upgrade에 포함된 신규 컴포넌트는 기본적으로 **관리자(Admin)에게만** 할당된다. 기존 비-관리자 사용자에게 접근 권한을 부여하는 방법을 결정해야 한다.

| Push Upgrade 내용 | 권장 조치 |
|---|---|
| 신규 기능(New features) | 관리자에게 변경 사항을 알리고 사용자에게 권한을 수동 할당하도록 요청. 이 방식은 관리자가 신규 기능 제공 시기를 직접 결정할 수 있게 한다. |
| 기존 기능 개선(Enhancements to existing features) | 신규 컴포넌트나 필드에 대한 권한을 자동으로 할당하는 Post-Install Script를 패키지에 포함. 기존 사용자가 중단 없이 기능을 계속 사용할 수 있게 한다. |

> 참고: Post-Install Script는 Unlocked Package에서는 사용 불가.

---

## 6. Sample Post Install Script for a Push Upgrade

신규 컴포넌트의 접근 권한을 기존 사용자에게 자동으로 할당하는 Post Install Script 예시.

> 참고: Post-Install Script는 1GP·2GP managed package에서만 사용 가능.

이 샘플 스크립트는 패키지 업그레이드에 새 Visualforce 페이지와 해당 페이지에 접근 권한을 부여하는 새 Permission Set이 포함된 경우를 가정한다.

수행 작업:
1. 이전 버전의 Visualforce 페이지 ID 조회
2. 해당 페이지에 접근 권한이 있는 Permission Set 조회
3. 해당 Permission Set과 연결된 Profile 목록 조회
4. 해당 Profile이 할당된 사용자 목록 조회
5. 신규 패키지의 Permission Set을 해당 사용자에게 할당

```apex
global class PostInstallClass implements InstallHandler {
    global void onInstall(InstallContext context) {
        // Get the Id of the Visualforce pages
        List<ApexPage> pagesList = [SELECT Id FROM ApexPage WHERE NamespacePrefix = 'TestPackage' AND Name = 'vfpage1'];

        // Get the permission sets that have access to those pages
        List<SetupEntityAccess> setupEntityAccessList = [SELECT Id, ParentId, SetupEntityId, SetupEntityType FROM SetupEntityAccess WHERE SetupEntityId IN :pagesList];
        Set<ID> PermissionSetList = new Set<ID>();
        for (SetupEntityAccess sea : setupEntityAccessList) {
            PermissionSetList.add(sea.ParentId);
        }

        List<PermissionSet> PermissionSetWithProfileIdList =
            [SELECT id, Name, IsOwnedByProfile, Profile.Name, ProfileId FROM PermissionSet WHERE IsOwnedByProfile = true AND Id IN :PermissionSetList];

        // Get the list of profiles associated with those permission sets
        Set<ID> ProfileList = new Set<ID>();
        for (PermissionSet per : PermissionSetWithProfileIdList) {
            ProfileList.add(per.ProfileId);
        }

        // Get the list of users who have those profiles assigned
        List<User> UserList = [SELECT id FROM User where ProfileId IN :ProfileList];

        // Assign the permission set in the new package to those users
        List<PermissionSet> PermissionSetToAssignList = [SELECT id, Name FROM PermissionSet WHERE Name='TestPermSet' AND NamespacePrefix = 'TestPackage'];
        PermissionSet PermissionSetToAssign = PermissionSetToAssignList[0];
        List<PermissionSetAssignment> PermissionSetAssignmentList = new List<PermissionSetAssignment>();
        for (User us : UserList) {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.PermissionSetId = PermissionSetToAssign.id;
            psa.AssigneeId = us.id;
            PermissionSetAssignmentList.add(psa);
        }
        insert PermissionSetAssignmentList;
    }
}
```

테스트 클래스:

```apex
@isTest
private class PostInstallClassTest {
    @isTest
    public static void test() {
        PostInstallClass myClass = new PostInstallClass();
        Test.testInstall(myClass, null);
    }
}
```

---

## 7. Push Upgrade Best Practices

Push Upgrade는 Partner에게 제공되는 가장 강력한 기능 중 하나다. 계획과 준비 없이 업그레이드를 Push하면 심각한 고객 만족도 문제가 발생할 수 있다.

### 7-1. Plan, Test, and Communicate (계획·테스트·소통)

- **업그레이드 타임라인 공유**: 고객에게 업그레이드 시기와 빈도를 미리 알린다
- **고객 일정 고려**: 대부분의 고객은 월말, 분기말, 연말, 감사 기간에 변경을 원하지 않는다. 직원이 없거나 변경 사항을 검증할 수 없는 시기도 고려한다
- **Off-peak 시간대 스케줄**: 늦은 저녁·밤 시간대에 Push Upgrade를 스케줄한다. 고객이 미국 외 지역에 있어 off-peak 시간이 다를 수 있으므로 시간대를 고려한다. 시간대별로 org를 그룹화하는 것을 고려한다
- **Salesforce 유지 보수 기간 회피**: 대부분의 경우 주요 Salesforce 릴리즈 후 3~4주 이상 기다린 후 major upgrade를 Push한다
- **철저한 테스트**: ISV가 변경 사항을 Push하므로 모든 고객 설정에서 새 버전이 잘 동작하는지 확인하는 기준이 더 높다

### 7-2. Stagger Your Push Upgrades (단계적 배포)

- **전체 고객에게 동시에 Push하지 않는다**: 문제 발생 시 지원 역량이 충분해야 하며, 전체 고객 기반이 영향받기 전에 이슈를 발견해야 한다
- **자체 테스트 org에 먼저 Push**: Push가 원활하게 이루어지는지 확인하고, 로그인 후 모든 것이 예상대로 동작하는지 검증한다
- **해당 시 고객 Sandbox org에 먼저 Push**: Production org에 Push하기 전에 Sandbox에서 1주일 이상 테스트·검증·수정 기간을 준다
- **소규모 배치로 시작**: 예를 들어 고객이 1,000개라면 처음에는 50~100개씩 Push한다. 결과에 자신감이 생기면 더 큰 배치로 업그레이드한다

### 7-3. Focus on Customer Trust (고객 신뢰)

- **고객 org에 부정적 영향을 주지 않는다**: 고객이 외부 통합에서 사용하는 Validation Rule·Formula Field 변경 같은 패키지 변경을 피한다. 반드시 해야 한다면 사전에 충분한 테스트와 소통을 한다. Upgrade는 메타데이터뿐만 아니라 **고객 데이터**에도 영향을 줄 수 있다
- **설치 시 기본 Sanity Test 작성**: 업그레이드된 앱이 예상대로 동작하는지 기본 검증을 수행하는 Apex 테스트를 작성한다
- **기존 기능 개선 시**: Post-Install Script를 사용해 Permission Set으로 신규 컴포넌트를 기존 사용자에게 자동 할당한다
- **신규 기능 추가 시**: 기존 사용자에게 자동 할당하지 않는다. 고객 org 관리자와 소통해 신규 기능 접근 권한 대상과 롤아웃 시기를 결정하게 한다

---

## 관련 노트

- [[2GP — Prepare to Distribute]] — beta → released 승격, AppExchange 등록, Recommend Package Version
- [[2GP — Install · Uninstall]] — sf package install, InstallHandler, InstallContext, System.Version, PostInstallScript 기본
- [[2GP — Develop]] — sf package version create, Package Ancestry, beta→released 75% 코드 커버리지
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 10단계 워크플로, Manageability Rules
- [[Unlocked Package 릴리스와 설치]] — Unlocked Package Push Upgrade 기본 설명
- [[2GP — Advanced Features Part 2]] — Package Transfer Dev Hub, Remove Metadata, Delete Package, Partner Support 케이스 등록
