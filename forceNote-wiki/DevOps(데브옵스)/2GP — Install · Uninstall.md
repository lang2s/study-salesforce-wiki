---
tags: [DevOps, Packaging, 2GP, ManagedPackage, PackageInstall, PackageUninstall, PackageUpgrade, InstallHandler, UninstallHandler, PostInstallScript, InstallationKey, SubscriberOrg, 패키지설치, 패키지제거, 패키지업그레이드]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.348-359
created: 2026-05-24
aliases: [2GP Install, 2GP Uninstall, sf package install 2GP, sf package uninstall 2GP, 2GP 패키지 설치, 2GP 패키지 제거, 2GP 패키지 업그레이드, Install and Uninstall Second-Generation Managed Packages, post install script, InstallHandler, UninstallHandler, InstallContext, Run Apex on Package Install Upgrade, 패키지 설치 스크립트, 패키지 언인스톨]
---

# 2GP — Install · Uninstall (패키지 설치 · 제거)

> scratch org 또는 subscriber org에 managed 2GP 패키지를 CLI·URL로 설치·업그레이드·제거하고, `InstallHandler`·`UninstallHandler` Apex 스크립트로 설치·제거 이벤트를 커스터마이즈하는 방법을 전수 정리한다.

---

## 1. Install and Uninstall Second-Generation Managed Packages — 개요

disposable scratch org에서 managed 2GP를 테스트하는 것을 권장한다. beta 버전은 업그레이드 불가이므로 UAT·스테이징 sandbox에는 설치하지 않는다.

| 방식 | CLI | URL(브라우저) | Setup UI |
|---|---|---|---|
| 설치 | `sf package install` | Installation URL | ✅ |
| 제거 | `sf package uninstall` | — | ✅ |

p.348 섹션 구성:

| 하위 주제 | 내용 |
|---|---|
| Use the CLI to Install | `sf package install` 명령, 타임아웃 제어 |
| Use a URL to Install | Installation URL 구조·설치 절차 |
| Install Notifications for Unauthorized Packages | AppExchange 미승인 패키지 알림 |
| Upgrade a Package Version | 메타데이터 변경 동작 |
| Resolve Apex Test Failures | 설치 실패 원인 진단 |
| Run Apex on Package Install/Upgrade | `InstallHandler`, `InstallContext`, `System.Version` |
| Customize Installs and Uninstalls Using Scripts | sfdx-project.json 스크립트 지정, 오류 알림 |
| Sample Script for Installing with Dependencies | bash 의존성 설치 스크립트 |
| Uninstall a Second-Generation Managed Package | `sf package uninstall`, Setup UI 절차, 제약사항 |

---

## 2. CLI로 설치 (Use the CLI to Install)

### 2-1. 기본 설치 명령

```bash
# 1단계: 설치 가능한 버전 목록 확인
sf package version list

# 2단계: 패키지 설치 (alias 또는 04t ID 사용)
sf package install --package "Expense Manager@1.2.0-12" --target-org jdoe@example.com

# default org가 이미 설정된 경우 --target-org 생략 가능
sf package install --package "Expense Manager@1.2.0-12"
```

- 기본값으로 설치 시 Admins만 접근 가능하다.
- 모든 사용자에게 접근 권한을 부여하려면 `--security-type AllUsers`를 추가한다.
- `--target-org`에 alias를 지정할 수 있다.

CLI 설치 상태 메시지:
```
Waiting for the subscriber package version install request to get processed. Status = InProgress
Successfully installed the subscriber package version: 04txx0000000FIuAAM.
```

### 2-2. 설치 타임아웃 제어 (Control Managed 2GP Package Installation Timeouts)

`sf package install` 실행 시 패키지 버전이 target org에서 가용 상태가 되기까지 몇 분이 걸린다. 두 파라미터는 상호 배타적 타이머로 동작한다.

| 파라미터 | 기본값 | 역할 |
|---|---|---|
| `--publish-wait` | 0분 | 패키지 버전이 target org에서 가용 상태가 될 때까지 대기하는 최대 시간(분). 이 시간 안에 가용되지 않으면 설치가 종료된다. |
| `--wait` | 0분 | 패키지 가용 후 설치 완료까지 대기하는 최대 시간(분). 시간 종료 시 명령이 완료되지만 설치는 계속 진행된다. 상태는 `sf package install report`로 확인 가능. |

**중요:** `--wait` 타이머는 `--publish-wait` 시간 경과 후에 시작된다. `--publish-wait`이 초과되면 `--wait`은 아예 시작하지 않는다.

**예시 1 — publish-wait 부족으로 설치 중단:**
```bash
# Expense Manager: 가용까지 5분 필요, 설치에 11분 필요
# publish-wait 3분 → 가용 전에 종료되어 설치 중단
sf package install --package "Expense Manager@1.2.0-12" --publish-wait 3 --wait 10
```

**예시 2 — 정상 완료:**
```bash
# publish-wait 6분 → 5분 후 가용, wait 10분 시작
# 10분 후 명령 완료(설치 진행 중), 1분 후 설치 성공
sf package install --package "Expense Manager@1.2.0-12" --publish-wait 6 --wait 10
```

> `--publish-wait`을 0으로 설정하면 패키지가 이미 가용 상태가 아닌 한 설치가 즉시 실패한다.

---

## 3. URL로 설치 (Use a URL to Install)

CLI에서 패키지를 생성하면 subscriber package ID(`04t`로 시작)를 Dev Hub URL에 추가하여 Installation URL을 도출할 수 있다.

**URL 형식:**
```
https://MyDomainName.lightning.force.com/packagingSetupUI/ipLanding.app?apvId=04tB00000009oZ3JBI
```

- URL을 가진 누구나 유효한 Salesforce org 로그인으로 패키지를 설치할 수 있다.
- Installation key가 있는 패키지는 key를 입력해야 한다.

**브라우저 설치 절차:**
1. 브라우저에서 Installation URL 입력
2. 설치할 Salesforce org의 사용자명·비밀번호로 로그인
3. 패키지에 installation key가 설정된 경우 key 입력
4. 기본 설치의 경우 Install 클릭
5. 완료 시 확인 메시지 수신

---

## 4. 미승인 패키지 알림 (Install Notifications for Unauthorized Managed Packages)

AppExchange Partner Program이 승인하지 않은 managed 패키지를 배포할 때, Salesforce는 설치 프로세스 중 고객에게 알림을 표시한다. 패키지가 승인되면 알림이 제거된다.

알림이 표시되는 경우:
- 보안 심사를 받은 적 없거나 심사 중인 경우
- 보안 심사를 통과하지 못한 경우
- AppExchange Partner Program이 다른 이유로 승인하지 않은 경우

고객은 패키지 설치 설정을 구성할 때(1) 알림을 확인하며, 설치 전 패키지가 배포 승인을 받지 않았음을 인정해야 한다(2).

패키지 신버전을 publish하면 자동으로 배포 승인이 이루어진다.

---

## 5. 패키지 버전 업그레이드 (Upgrade a Second-Generation Managed Package Version)

업그레이드는 이전 버전이 이미 설치된 org에 새 패키지 버전을 설치할 때 발생한다.

**업그레이드 시 메타데이터 변경 동작:**
- 새 버전에서 추가된 메타데이터 → 업그레이드 시 설치됨
- 새 버전에서 수정된 메타데이터 → 업그레이드 시 업데이트됨
- 새 버전에서 제거된 메타데이터 → 업그레이드 시 deprecated 또는 deleted 처리됨

```bash
# 패키지 업그레이드 (sf package install 명령 동일 사용)
sf package install --package 04t... --target-org me@example.com
```

**업그레이드 제약:**
- beta 버전은 업그레이드 불가. 새 beta 또는 released 버전 설치 전 기존 beta를 먼저 제거해야 한다.
- 업그레이드하려면 새 버전이 현재 설치된 패키지 버전의 **직계 자손**이어야 한다 (Package Ancestor 참조).

---

## 6. Apex 테스트 실패 해결 (Resolve Apex Test Failures)

패키지 설치나 업그레이드가 Apex 테스트 커버리지 미달로 실패할 수 있다. 일부 실패는 무시해도 안전하다.

설치 실패 시 확인 사항:
- Apex 테스트에 필요한 데이터를 subscriber 데이터에 의존하지 않고 테스트 내에서 직접 생성하고 있는지 확인한다.
- subscriber가 패키지에서 참조하는 오브젝트에 validation rule, required field, trigger를 만든 경우, 해당 오브젝트에 DML을 수행하는 테스트가 실패할 수 있다.
  - 해당 오브젝트가 런타임에 사용되지 않고 테스트 목적으로만 생성되며, 충돌로 인한 실패라면 오류를 무시하고 테스트를 계속해도 안전하다.
  - 그렇지 않으면 고객에게 연락하여 영향을 파악해야 한다.

---

## 7. 패키지 설치/업그레이드 시 Apex 실행 (Run Apex on Package Install/Upgrade)

### 7-1. Post Install Script 개요

앱 개발자는 subscriber가 managed 패키지를 설치하거나 업그레이드한 후 자동으로 실행되는 Apex 스크립트를 지정할 수 있다. 스크립트를 사용해 다음 작업이 가능하다:
- custom settings 채우기
- 샘플 데이터 생성
- 설치자에게 이메일 전송
- 외부 시스템 알림
- 새 필드를 대량 데이터에 채우는 배치 작업 시작

**제약사항:**
- post install script는 패키지에 속하는 Apex 클래스여야 한다 (단 하나만 지정 가능).
- 테스트 실행 후 호출되며, 기본 governor limits가 적용된다.
- 스크립트는 패키지를 대표하는 특수 시스템 사용자로 실행된다 (`UserInfo`로 접근 가능, 런타임에만 확인 가능).
- 스크립트 실패 시 설치/업그레이드가 중단된다. 오류는 패키지의 Notify on Apex Error 필드에 지정된 사용자에게 이메일로 전송된다.

**추가 속성:**
- batch, scheduled, future job 시작 가능
- Session ID 접근 불가
- callout은 async 작업으로만 가능 (스크립트 실행 후 설치 완료·커밋 후 발생)
- `with sharing` 또는 `inherit sharing` 키워드를 사용하는 다른 Apex 클래스는 호출 불가
- Trialforce로 프로비저닝된 신규 trial org에서는 실행되지 않음 (기존 org에 설치 시에만 실행)

### 7-2. InstallHandler 인터페이스

post install script는 `InstallHandler` 인터페이스를 구현한다.

```apex
global interface InstallHandler {
    void onInstall(InstallContext context)
}
```

`onInstall` 메서드는 `InstallContext` 타입의 context 객체를 받는다.

### 7-3. InstallContext 인터페이스

```apex
global interface InstallContext {
    ID organizationId();   // 설치가 발생하는 org의 ID
    ID installerId();      // 설치를 시작한 사용자의 ID
    Boolean isUpgrade();   // 업그레이드인지 여부
    Boolean isPush();      // push 설치인지 여부
    Version previousVersion();  // 이전에 설치된 패키지 버전 (항상 3파트: 예 1.2.0)
}
```

### 7-4. System.Version 클래스 메서드

`System.Version` 클래스를 사용해 managed 패키지 버전을 가져오고 비교한다. 버전 번호 형식: `majorNumber.minorNumber.patchNumber` (예: `2.1.3`).

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `compareTo(System.Version version)` | `Integer` | 현재 버전과 지정 버전 비교. 같으면 0, 현재가 크면 양수, 작으면 음수. 2파트와 3파트 비교 시 patch는 무시되고 major·minor만 비교. |
| `major()` | `Integer` | 현재 코드의 major 패키지 버전 반환 |
| `minor()` | `Integer` | 현재 코드의 minor 패키지 버전 반환 |
| `patch()` | `Integer` | 현재 코드의 patch 패키지 버전 반환 (없으면 null) |

**System 클래스의 패키지 버전 관련 메서드:**
- `System.requestVersion()`: 패키지의 major·minor 버전을 포함하는 2파트 버전 반환. calling code가 참조하는 패키지의 설치 버전을 확인해 조건부 로직에 활용 가능.
- `System.runAs(System.Version)`: 현재 패키지 버전을 인수로 지정한 버전으로 변경.

### 7-5. Post Install Script 예시

```apex
public class PostInstallClass implements InstallHandler {
    global void onInstall(InstallContext context) {
        if (context.previousVersion() == null) {
            // 최초 설치인 경우
            Account a = new Account(name='Newco');
            insert(a);
            Survey__c obj = new Survey__c(name='Client Satisfaction Survey');
            insert obj;
            User u = [Select Id, Email from User where Id =: context.installerID()];
            String toAddress = u.Email;
            String[] toAddresses = new String[]{ toAddress };
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('support@package.dev');
            mail.setSenderDisplayName('My Package Support');
            mail.setSubject('Package install successful');
            mail.setPlainTextBody('Thanks for installing the package.');
            Messaging.sendEmail(new Messaging.Email[]{ mail });
        } else if (context.previousVersion().compareTo(new Version(1, 0)) == 0) {
            // 이전 버전이 1.0인 경우
            Survey__c obj = new Survey__c(name='Upgrading from Version 1.0');
            insert(obj);
        }
        if (context.isUpgrade()) {
            Survey__c obj = new Survey__c(name='Sample Survey during Upgrade');
            insert obj;
        }
        if (context.isPush()) {
            Survey__c obj = new Survey__c(name='Sample Survey during Push');
            insert obj;
        }
    }
}
```

**Post Install Script 테스트:**

```apex
@isTest
static void testInstallScript() {
    PostInstallClass postinstall = new PostInstallClass();
    Test.testInstall(postinstall, null);                        // 최초 설치 시뮬레이션
    Test.testInstall(postinstall, new Version(1, 0), true);    // 1.0에서 push 업그레이드 시뮬레이션
    List<Account> a = [Select id, name from Account where name = 'Newco'];
    System.assertEquals(1, a.size(), 'Account not found');
}
```

`Test.testInstall` 인수:
- `InstallHandler` 인터페이스를 구현한 클래스
- 기존 패키지 버전을 지정하는 `Version` 객체
- (선택) push 여부 Boolean (기본값 false)

### 7-6. Post Install Script 지정 방법

테스트 완료 후 Package Detail 페이지의 **Post Install Script** lookup 필드에 지정한다. 후속 patch 릴리즈에서 스크립트 내용은 변경 가능하지만 Apex 클래스는 변경 불가.

Metadata API를 통해서도 지정 가능: `Package.postInstallClass` → `package.xml`의 `<postInstallClass>foo</postInstallClass>` 엘리먼트.

---

## 8. 설치·제거 스크립트 커스터마이즈 (Customize Installs and Uninstalls Using Scripts)

`sfdx-project.json`에서 post install script와 uninstall script를 함께 지정한다.

```json
{
  "packageDirectories": [
    {
      "path": "expenser-schema",
      "default": true,
      "package": "Expense Schema",
      "versionName": "ver 0.3.2",
      "versionNumber": "0.3.2.NEXT",
      "postInstallScript": "PostInstallScript",
      "uninstallScript": "UninstallScript",
      "postInstallUrl": "https://expenser.com/post-install-instructions.html",
      "releaseNotesUrl": "https://expenser.com/winter-2020-release-notes.html"
    }
  ],
  "namespace": "db_exp_manager",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "47.0",
  "packageAliases": {
    "Expenser Schema": "0HoB00000004CzHKAU",
    "Expenser Schema@0.1.0-1": "04tB0000000719qIAA"
  }
}
```

CLI 파라미터로도 지정 가능 (`sfdx-project.json` 값 덮어쓰기):
```bash
sf package version create \
  --package "Expense Schema" \
  --post-install-script PostInstallScript \
  --uninstall-script UninstallScript \
  --post-install-url "https://expenser.com/post-install-instructions.html" \
  --release-notes-url "https://expenser.com/winter-2020-release-notes.html"
```

**중요:** post-install·uninstall 스크립트의 Apex 클래스는 패키지 메타데이터에 포함해야 한다.

**오류 알림 지정:**
```bash
# 패키지 생성 시 지정
sf package create --error-notification-username me@devhub.org

# 기존 패키지 업데이트 시 지정
sf package update --error-notification-username me@devhub.org
```

Tooling API에서는 `Package2` 오브젝트의 `PackageErrorUsername` 필드 사용.

---

## 9. 의존성 패키지 설치 샘플 스크립트 (Sample Script for Installing Packages with Dependencies)

이 스크립트는 의존하는 패키지를 올바른 의존성 순서로 자동 설치한다.

```bash
#!/bin/bash

# 오류 발생 시 스크립트 중단
set -e

# 설치할 패키지 버전 ID (04t로 시작)
PACKAGE=04tB0000000NmnHIAS

# Subscriber org의 사용자명
USER_NAME=test-bvdfz3m9tqdf@example.com

# 패키지 설치 타임아웃 (분)
WAIT_TIME=15

echo "Retrieving dependencies for package Id: "$PACKAGE

# SOQL 쿼리로 패키지 의존성을 JSON 형식으로 조회
RESULT_JSON=`sf data query -u $USER_NAME -t -q "SELECT Dependencies FROM \
SubscriberPackageVersion WHERE Id='$PACKAGE'" --json`

# Python으로 JSON 파싱 — 의존성 존재 여부 확인
DEPENDENCIES=`echo $RESULT_JSON | python -c 'import sys, json; print \
json.load(sys.stdin)["result"]["records"][0]["Dependencies"]'`

# 의존성이 있으면 각 패키지를 순서대로 설치
if [[ "$DEPENDENCIES" != 'None' ]]; then
    DEPENDENCIES=`echo $RESULT_JSON | python -c '
import sys, json
ids = json.load(sys.stdin)["result"]["records"][0]["Dependencies"]["ids"]
dependencies = []
for id in ids:
    dependencies.append(id["subscriberPackageVersionId"])
print " ".join(dependencies)
'`
    echo "The package you are installing depends on these packages (in correct dependency order): "$DEPENDENCIES
    for id in $DEPENDENCIES
    do
        echo "Installing dependent package: "$id
        sf package install --package $id -u $USER_NAME -w $WAIT_TIME --publish-wait 10
    done
else
    echo "The package has no dependencies"
fi

# 의존성 처리 후 지정 패키지 설치
echo "Installing package: "$PACKAGE
sf package install --package $PACKAGE -u $USER_NAME -w $WAIT_TIME --publish-wait 10

exit 0;
```

> 패키지 버전 ID와 scratch org 사용자명을 실제 값으로 교체해야 한다.

---

## 10. 패키지 제거 (Uninstall a Second-Generation Managed Package)

패키지를 제거하면 해당 패키지의 모든 컴포넌트 — 이전에 연관되었던 deprecated 컴포넌트 포함 — 가 org에서 삭제된다.

### 10-1. CLI로 제거

```bash
# Dev Hub org를 인증한 후 실행
sf package uninstall --package "Expense Manager@2.3.0-5"
```

### 10-2. Setup UI로 제거

```bash
# 먼저 org 열기
sf org open -u me@my.org
```

이후 Setup에서:
1. Quick Find에서 **Installed Packages** 검색 후 선택
2. 제거할 패키지 옆의 **Uninstall** 클릭
3. 패키지 데이터 복사본 저장 여부를 선택하는 라디오 버튼 선택
4. **Yes, I want to uninstall** 선택 후 Uninstall 클릭

### 10-3. 제거 시 제약사항 (Considerations on Uninstalling Packages)

| 제약 상황 | 설명 |
|---|---|
| Custom Object 포함 패키지 | custom object의 모든 컴포넌트(custom field, validation rule, custom button·link, approval process)도 함께 삭제됨 |
| 다른 컴포넌트가 패키지 컴포넌트를 참조하는 경우 | 제거 불가. 예: 패키지의 custom user field를 트리거하는 workflow rule이 있는 경우 |
| 설치되지 않은 다른 패키지의 컴포넌트가 참조하는 경우 | 두 패키지가 서로 참조하면 제거 불가. 예: expense report 앱의 custom user field를 다른 패키지의 validation rule이 참조 |
| 설치 후 추가된 컴포넌트가 포함된 folder | 폴더에 설치 후 추가한 컴포넌트가 있으면 제거 불가 |
| Letterhead가 설치 후 추가된 email template에 사용 중인 경우 | 제거 불가 |
| Einstein Prediction Builder 또는 Case Classification이 참조하는 custom field 포함 | 제거 불가. 패키지 제거 전 Prediction Builder 또는 Case Classification 편집하여 참조 해제 필요 |
| 모든 active account record type 제거 | 활성 business 또는 person account record type을 모두 제거하는 패키지는 제거 불가. 다른 record type 하나 이상 활성화 후 재시도 |
| background job이 패키지 필드를 업데이트 중인 경우 | 제거 불가 (예: roll-up summary field 업데이트 중). job 완료 후 재시도 |

---

## 비교표 — 설치 방식 선택

| 방식 | CLI | URL | Setup UI |
|---|---|---|---|
| 패키지 설치 | `sf package install` | Installation URL | ✅ |
| 패키지 제거 | `sf package uninstall` | — | ✅ |
| 타임아웃 제어 | `--publish-wait` / `--wait` | — | — |
| installation key 입력 | `--installation-key` | 브라우저 입력 | 브라우저 입력 |
| 스크립팅·자동화 | ✅ (CI/CD 적합) | 제한적 | ❌ |

---

## 비교표 — Post Install Script 제약 vs 허용

| 항목 | 허용 | 제약 |
|---|---|---|
| Batch/Scheduled/Future job 시작 | ✅ | |
| Session ID 접근 | | ❌ |
| Callout | async 전용 (설치 완료·커밋 후 발생) | 동기 callout ❌ |
| `with sharing`/`inherit sharing` 클래스 호출 | | ❌ |
| Trialforce 신규 trial org | | ❌ (기존 org에만 실행) |
| Governor limits | 기본 governor limits 적용 | |

---

## 관련 노트
- [[2GP — Develop]] — `sf package version create`, Package Ancestor, beta→released promote 절차
- [[2GP Managed Package — Workflow]] — 전체 2GP CLI 워크플로 10단계 및 지원 컴포넌트 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — Package Ancestry, Manageability Rules, namespace 설정
- [[2GP Managed Package Scratch Org 워크플로]] — scratch org에서 beta 패키지 테스트 환경 구성
- [[2GP — Specific Metadata Behavior]] — Permission Set/Profile Settings, IP 보호, post/uninstall script 지정 (sfdx-project.json)
- [[Unlocked Package 릴리스와 설치]] — Unlocked Package 설치·업그레이드 타입·의존성 스크립트 비교
- [[2GP — Prepare to Distribute]] — 설치 이전 단계: 코드 커버리지 75%·Installation Key·sf package version promote·AppExchange 등록
- [[2GP — Push Upgrade]] — subscriber org에 강제 Push Upgrade·CLI·SOAP API·Customized Push Upgrade·Best Practices
