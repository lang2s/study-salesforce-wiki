---
tags: [2GP, managed-package, package-ids, namespace-collision, remove-metadata, delete-package, transfer-devhub, frequently-used-operations, partner-support, devops]
source: pkg2_dev.pdf p.393-406
created: 2026-05-24
aliases: [2GP Advanced Features Part 2, Package IDs Aliases, Namespace Collisions 2GP, Remove Metadata 2GP, Delete Package 2GP, Transfer Dev Hub 2GP, Contact Partner Support, Frequently Used Packaging Operations, Subscriber Package ID, 033 04t 0Ho 08c]
---

# 2GP — Advanced Features Part 2 (IDs · Namespace · Remove · Delete · Transfer)

> Package IDs 및 Aliases 4종 전수, Namespace Collision 방지 설치 가능 조합 테이블, Remove Metadata Components(deprecated 목록 + 절차), Delete Package/Version 규칙, Frequently Used CLI 명령 표, Transfer Dev Hub 전 과정, Contact Partner Support 절차

---

## 1. Package IDs and Aliases for Second-Generation Managed Packages

패키지 lifecycle 중 패키지와 패키지 버전은 ID 또는 package alias로 식별된다. Salesforce CLI는 패키지 또는 버전 생성 시 패키지 이름을 기반으로 package alias를 자동 생성하고 `sfdx-project.json`의 `packageAliases` 섹션에 저장한다.

Package alias는 `sfdx-project.json` 파일에 이름-값 쌍으로 저장된다. 이름은 alias이고 값은 ID다. 기존 패키지와 패키지 버전의 package alias를 수동으로 수정할 수 있다.

### 1-1. 주요 ID 유형 전수

| ID 예시 | Short ID Name | 설명 |
|---|---|---|
| `033J0000dAb27uxVRE` | Subscriber Package ID | 패키징 또는 보안 심사 지원 문의 시 사용. `sf package list --verbose`로 조회 가능. |
| `04t6A0000004eytQAA` | Subscriber Package Version ID | 패키지 버전 설치에 사용. `sf package version create`가 반환. |
| `0Hoxx00000000CqCAI` | Package ID | CLI 패키지 버전 생성 시 또는 sfdx-project.json에 입력. `sf package create`가 생성. |
| `08cxx00000000BEAAY` | Version Creation Request ID | 패키지 버전 생성 요청의 상태 확인 및 진행 모니터링 시 사용. `sf package version create report`에 사용. |

### 1-2. ID 조회 명령

```bash
# Subscriber Package ID(033) 조회 — --verbose 필수
sf package list --verbose --target-dev-hub myDevHub

# 패키지 버전 목록 조회 (Subscriber Package Version ID 04t 포함)
sf package version list --package MyPackage

# 특정 버전 상세 조회
sf package version report --package "MyPackage@1.0.0-1"

# 버전 생성 요청 상태 확인 (08c ID 사용)
sf package version create report --package-create-request-id 08cxx00000000BEAAY
```

> 문서에서는 ID를 세 글자 접두사로 줄여서 언급하는 경우가 있다. 예: 패키지 버전 ID는 항상 `04t`로 시작.

---

## 2. Avoid Namespace Collisions in Second-Generation Managed Packages

Namespace는 org에 설치 가능한 패키지 조합에 영향을 미친다.

> **중요:** 같은 namespace를 공유하는 패키지에서 컴포넌트 이름 관리에 주의해야 한다. 같은 namespace에 연결된 패키지들은 동일한 API 이름의 컴포넌트를 포함해서는 안 된다. 두 패키지가 동일한 API 이름의 컴포넌트를 포함하면 같은 org에 설치할 수 없다.

### 2-1. 설치 가능 조합 테이블

| Installation Org | No-namespace Unlocked Package | Namespaced Unlocked Package | 2GP Managed Package | 1GP Managed Package |
|---|---|---|---|---|
| **Namespace가 있는 Org** (1GP packaging org, 1GP patch org, namespace 있는 Developer Edition org, namespace 있는 scratch org) | **Fail.** namespace가 있는 org에 no-namespace unlocked 패키지 설치 불가. | Pass. namespace 일치/불일치 무관. | Pass (scratch orgs). namespace 일치/불일치 무관. | Pass. 1GP의 namespace가 org namespace와 다르더라도 여러 1GP 패키지 설치 가능. |
| **Namespace가 없는 Org** | Pass. no-namespace unlocked 패키지 여러 개 설치 가능. | Pass. namespaced unlocked 패키지 여러 개 설치 가능. | Pass. 여러 2GP managed 패키지 설치 가능. | Pass. 여러 1GP managed 패키지 설치 가능. |

### 2-2. Namespace와 패키지 유형 조합 테이블 (상세)

| Namespace and Package Type | Unlocked Package with Namespace Y | 2GP Managed Package with Namespace Y | 1GP Managed Package with Namespace Y |
|---|---|---|---|
| **1GP Managed Package with namespace X** | Pass. 1GP와 unlocked은 같은 org에 설치 가능. 같은 namespace가 아니면 됨. | Pass. 1GP와 2GP managed는 같은 org에 설치 가능. | Pass. 여러 1GP managed 패키지 설치 가능. namespace가 달라야 함. |
| **2GP Managed Package with namespace X** | Pass. 2GP managed와 namespaced unlocked 설치 가능. | Pass. 같은 namespace의 여러 2GP managed 패키지 설치 가능. 컴포넌트 API 이름 충돌 없어야 함. | Pass. 2GP managed와 1GP managed 설치 가능. |
| **2GP Managed Package with namespace X** (취소된 버전 포함) | | | **Fail.** 1GP와 2GP managed가 같은 namespace를 공유할 수 없음. |

---

## 3. Remove Metadata Components from Second-Generation Managed Packages

더 이상 managed 2GP 패키지에서 원하지 않는 Apex 클래스 등의 메타데이터 컴포넌트를 제거할 수 있다.

### 3-1. Subscriber Org에서 컴포넌트 제거의 영향

패키지 업그레이드 시 각 메타데이터 컴포넌트는 다음과 같이 처리된다:

| Metadata Component | Upon Package Upgrade, the Metadata Component is |
|---|---|
| Analytics Snapshot | Marked as deprecated |
| Apex Class (including global Apex classes) | Hard deleted |
| Apex Trigger | Hard deleted |
| Aura Component | Marked as deprecated |
| Compact Layout | Marked as deprecated |
| Custom Application | Marked as deprecated |
| Custom Field | Marked as deprecated |
| Custom Labels | Marked as deprecated |
| Custom Metadata Type Records | Marked as deprecated; if visible to subscriber org, otherwise hard-deleted |
| Custom Object | Marked as deprecated |
| Custom Permission | Marked as deprecated |
| Custom Tab | Marked as deprecated |
| Dashboard | Marked as deprecated |
| Dashboard Folder | Marked as deprecated |
| Document | Marked as deprecated |
| External Auth Identity Provider | Marked as deprecated |
| External App Header | Hard deleted |
| External Credential | Marked as deprecated |
| External Services | Marked as deprecated |
| Field Set | Marked as deprecated |
| Flow | Marked as deprecated |
| Lightning Page | Marked as deprecated |
| Lightning Web Component | Marked as deprecated |
| List View | Marked as deprecated |
| Named Credential | Marked as deprecated |
| Page Layout | Marked as deprecated |
| Permission Set | Marked as deprecated |
| Platform Event Channel | Hard deleted |
| Platform Event Channel Member | Hard deleted |
| Profile | Marked as deprecated |
| Quick Action | Marked as deprecated |
| Record Type | Marked as deprecated |
| Remote Site Setting | Marked as deprecated |
| Report | Marked as deprecated |
| Report Folder | Marked as deprecated |
| Report Type | Marked as deprecated |
| Sharing Reason | Marked as deprecated |
| Static Resource | Marked as deprecated |
| Validation Rule | Marked as deprecated |
| Visualforce Page (including global components) | Hard deleted |
| Visualforce Page | Marked as deprecated |
| Workflow Email Alert, Workflow Field Update, Workflow Outbound Message, Workflow Rule, Workflow Task | Marked as deprecated |

> **Hard deleted** 컴포넌트는 subscriber org에서 즉시 삭제된다. **Marked as deprecated** 컴포넌트는 subscriber org에서 더 이상 접근 불가하지만 데이터는 보존된다. subscriber org에서 customizations을 만든 경우 관련 customizations도 비활성화된다.

### 3-2. 메타데이터 컴포넌트 제거 절차

> **활성화 필요:** 제거 기능은 Salesforce Partner Support에 케이스를 등록해야 접근 가능하다.

1. Salesforce Partner Support에 요청해 제거 기능에 대한 접근 권한을 받는다.
2. 요청이 승인된 후 메타데이터를 소스 파일에서 제거하고 새 패키지 버전을 생성한다.

### 3-3. Before You Remove Metadata Components 주의사항

```
□ 제거하려는 컴포넌트 목록 파악
□ 패키지의 다른 컴포넌트가 제거 대상에 의존하지 않는지 확인
   → 의존 컴포넌트가 있으면 패키지 버전 생성 실패
□ 구독자가 제거 대상을 참조하는 customizations를 만들었을 수 있음
   → 패키지 제거 후 해당 customizations 접근 불가
```

### 3-4. Remove Dependencies in a Package (의존성 포함 제거)

제거하려는 메타데이터 컴포넌트를 참조하는 의존성을 먼저 제거해야 한다. 예를 들어 Field에 대한 참조가 있는 page layout을 제거하지 않고 Field를 제거하면 패키지 버전 생성이 실패한다. 해당 Field를 먼저 Visualforce 페이지에서 제거하고 참조를 소스 파일에서 제거한 후 upgrade를 구독자에게 push한다.

```
예시: page layout이 참조하는 Field 제거 절차
1. Field를 참조하는 page layout에서 field reference 제거
2. 소스 파일에서 해당 field 제거
3. 새 패키지 버전 생성
4. 구독자에게 upgrade push
```

### 3-5. 커뮤니케이션 권고사항

**팀과 동료 개발자에게:**
- 패키지에서 어떤 메타데이터 컴포넌트를 제거했는지 API 이름 포함해 통지
- 이미 deprecated된 API를 사용 중인 컴포넌트 목록 공유
- 모든 문서를 업데이트해 패키지에서 이전에 사용되던 deprecated API를 포함하지 않도록 한다

**구독자에게:**
- 패키지 업그레이드로 어떤 기능이 영향받는지 알린다
- Release Notes에 업그레이드된 패키지 버전, 제거 또는 deprecated된 컴포넌트 목록 포함

---

## 4. Delete a Second-Generation Managed Package or Package Version

`sf package version delete`와 `sf package delete` 명령으로 불필요한 패키지 및 버전을 삭제할 수 있다.

### 4-1. 삭제 가능 여부 테이블

| Package Type | beta 패키지 및 버전 삭제 가능? | released 패키지 및 버전 삭제 가능? |
|---|---|---|
| Second-Generation Managed Packages | Yes | No |
| Unlocked Packages | Yes | Yes |

### 4-2. 패키지 버전 삭제

```bash
# 패키지 버전 삭제 (package alias 또는 04t ID 사용)
sf package version delete --package "Your Package Alias"
sf package version delete --package 04t...

# 패키지 삭제
sf package delete --package 0Ho...
```

### 4-3. 삭제 시 주의사항

```
□ 삭제는 영구적이다
□ 삭제된 패키지 버전은 복구 불가
□ 삭제 전 해당 버전이 dependency로 참조되지 않는지 확인
□ managed 2GP는 released 버전은 삭제 불가 (beta만 가능)
□ Unlocked Package는 released 버전도 삭제 가능
```

---

## 5. Frequently Used Packaging Operations for Second-Generation Managed Packages

Salesforce CLI 명령어 전체 레퍼런스는 Salesforce CLI Command Reference를 참조한다.

| Salesforce CLI 명령 | 동작 |
|---|---|
| `sf package create` | 패키지 생성. 패키지 생성 시 패키지 타입과 이름을 지정한다. |
| `sf package version create` | 패키지 버전 생성. |
| `sf package install` | scratch org, sandbox, production org에 패키지 버전 설치. 메타데이터를 삭제하고 새 버전을 설치한다. |
| `sf package uninstall` | 패키지 설치 제거. |
| `sf package version promote` | 패키지 버전의 상태를 beta에서 managed-released로 변경. |
| `sf org create scratch` | Scratch org 생성. |
| `sf org open` | 브라우저에서 org를 연다. |

---

## 6. Transfer a Second-Generation Managed Package to a Different Dev Hub

Managed 2GP 패키지의 소유권을 한 Dev Hub org에서 다른 Dev Hub org로 이전할 수 있다. 이전은 회사 내 두 Dev Hub org 사이에서 내부적으로 또는 다른 Salesforce Partner나 ISV에게 외부적으로 진행 가능하다. 이 기능으로 managed 2GP 패키지를 다른 회사에 판매하는 방법을 제공한다.

> **제약:** 패키지 이전은 AppExchange 보안 심사를 통과한 managed 2GP 패키지에만 가능하다. Dev Hub가 Government Cloud에 위치하고 Dev Hub가 일반 Public Cloud에 있는 경우 또는 그 반대 방향으로의 패키지 이전은 불가하다.

### 6-1. 이전 요청 방법

Salesforce Customer Support에 케이스를 등록하고 다음 정보를 제공한다.

**케이스 주제:**
```
Subject: Managed 2GP Package Transfer to a Different Dev Hub
```

**케이스 설명에 포함해야 할 정보:**
- 이전하려는 패키지의 Subscriber Package ID (033으로 시작)
  - 조회 방법: `sf package list --verbose` 실행 (source Dev Hub에 대해)
- source Dev Hub org ID
- destination Dev Hub org ID
- 이전이 internal인지 external인지
- namespace 정보 (패키지의 namespace가 destination Dev Hub와 연결되어 있는지)
- Details about whether the package transfer is from one of your company's Dev Hub org to another (internal) or to another Salesforce Partner or ISV (external)

### 6-2. Package Transfers to External Customers (외부 고객 이전)

다른 Salesforce Partner나 ISV에게 패키지를 이전할 때:
- 패키지 소스 설정에 필요한 정보(sfdx-project.json 파일, Scratch Org Definition File, features·settings 목록)와 완전한 기능·설정 목록을 제공한다.
- 패키지 버전 관련 모든 구성 설정을 지정하는 sfdx-project.json 파일이 필요하다.
- `--definition-file` 파라미터를 사용해 새 패키지 버전 생성 시 사용하는 definition file 정보가 필요하다.
- namespace 연결 정보도 destination Dev Hub org에 링크된 namespace org에서 로그인 자격 증명이 필요하다.

### 6-3. During the Package Transfer Process (이전 프로세스 중)

- 이전이 완료되기 전에 모든 패키지 버전 생성 프로세스가 완료되어야 한다.
- 패키지 이전이 진행 중인 동안 패키지 버전 생성이 완료되면 Salesforce Customer Support에 알려야 한다.
- 이전이 완료되면 Salesforce Customer Support가 통지한다.

이전이 완료된 후:
- 이전된 패키지는 source Dev Hub org에서 더 이상 보이지 않는다.
- `sf package list`를 실행해 패키지가 destination Dev Hub와 연결되었는지 확인한다.

### 6-4. After the Package Transfer is Complete

Subscriber Notification User를 선택적으로 설정하기 위해 `sf package update` 명령을 사용하고 `--error-notification-username` 파라미터를 지정한다. 이 사용자는 push upgrade 실패 같은 패키지 오류 알림을 받는다. 파라미터에 아무 값도 없으면 이전의 Dev Hub Org ID 오류 알림 기본값이 사용된다.

### 6-5. Impact of Package Transfers on Package IDs

| ID Type | Starts with | After package transfer is complete |
|---|---|---|
| Subscriber Package ID | 033 | This ID remains the same |
| Subscriber Package Version ID | 04t | This ID remains the same |
| Package ID | 0Ho | The transferred package receives a new and unique package ID |

### 6-6. Update Your Package Project File

이전 후 source Dev Hub에서 새 패키지 버전을 생성하려면:
- `sfdx-project.json` 파일에서 새 package ID(`0Ho`)로 모든 참조를 업데이트한다.
- 패키지 directory 섹션의 package aliases를 업데이트한다.

destination Dev Hub를 사용하는 경우 패키지 dependency 섹션도 업데이트해야 한다:

```json
// 이전 후 dependency 업데이트 예시 (0Ho ID 방식)
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.2.0.LATEST"
  }
]

// 또는 04t ID 방식
"dependencies": [
  {
    "package": "04txx000000000ABCDE1A"
  }
]

// 또는 package alias 방식
"packageAliases": {
  "pkgB@1.0.0-1": "04txx000000ABCDEF1A"
}
```

### 6-7. What Package History is Transferred?

패키지 이전 시 전송되는 정보:
- 패키지 이름, 유형, ID 등
- 패키지 버전 ID
- 패키지가 수신한 Apex 및 기타 유형의 오류 알림 (이 선택적 정보는 `sf package update` 명령을 사용해 설정)

전송되지 않는 정보:
- Push upgrade history
- Package version create requests
- 이전에 Admin이 AppExchange에서 삭제한 패키지 버전
- Deleted package versions가 이전에 recovered되었을 경우

### 6-8. Take Ownership of a Second-Generation Managed Package Transferred from Another Dev Hub

다른 Dev Hub org에서 이전된 2GP managed 패키지의 소유권을 받을 때:

**다음 단계를 완료:**
1. 소유권을 받은 패키지가 Dev Hub org와 연결되었는지 확인: `sf package list`
2. AppExchange에 앱을 게시했다면 AppExchange 목록 업데이트

이것이 external 이전이면 비즈니스 관리에 필요한 몇 가지 항목을 완료해야 한다:
1. org login으로 destination Dev Hub org에 인증한다.
2. `sf package version list` 명령으로 이전된 패키지 버전을 확인한다.

**Next Steps:**
1. 패키지가 Dev Hub org와 연결되었는지 확인하고 `sfdx-project.json` 파일을 업데이트한다.
2. AppExchange에 앱을 게시했다면 AppExchange 목록을 publish한다.

**Before You Create a New Package Version:**

모든 항목이 이전되면 `sfdx-project.json` 파일을 업데이트해야 한다:
- sfdx-project.json 버전 번호를 업데이트하고 새 Package ID로 ancestorId를 HIGHEST로 업데이트한다.
- sfdx-project.json 파일의 source version control 시스템에서 수신한 모든 scratch org definition file을 검토한다.
- 개발 중 사용하는 추가 패키지(unpackaged) 가 있다면 패키지 dependency 섹션을 업데이트한다.
- 패키지 Ancestor ID(`ancestorId`)를 Salesforce CLI command `sf package version list --verbose`를 통해 조회한 최신 released 버전으로 업데이트한다.

---

## 7. Contact Salesforce Partner Support to Enable Specific Packaging Features

다음 특정 패키징 기능은 Salesforce Partner Support에 케이스를 등록해야만 활성화된다.

### 7-1. Partner Support 케이스 등록 절차

1. [Salesforce Partner Community](https://partners.salesforce.com)에 로그인한다.
2. 질문 아이콘을 클릭한 후 **Log a Case for Help**를 클릭한다.
3. **Subject**와 **Description** 필드를 입력한다.
4. Topic으로 **AppExchange & Managed Packages**를 선택한다.
5. **ISV Technology Request**를 선택한다.
6. 필요한 추가 정보를 입력한 후 **Create Case**를 클릭한다.

### 7-2. Partner Support가 필요한 기능 목록

| 기능 | 케이스 설명 |
|---|---|
| Push Upgrade 활성화 | 2GP managed 패키지에 push upgrade를 활성화 요청 |
| Patch Versioning 활성화 | 패키지의 namespace를 생성한 org에 patch versioning 활성화 요청 (AppExchange 보안 심사 통과 패키지만) |
| Metadata Component 제거 기능 활성화 | 패키지에서 특정 메타데이터 컴포넌트 제거 기능 요청 |
| Package Transfer | 특정 Dev Hub에서 다른 Dev Hub로 패키지 이전 요청 |

---

## 관련 노트
- [[2GP — Advanced Features Part 1]] — Package Ancestors, Patch Versions, Dependencies, Keywords, Branches, Advanced Config
- [[2GP — Develop]] — sf package create, sf package version create, NEXT 키워드, Package Ancestor 지정
- [[2GP — Prepare to Distribute]] — AppExchange 배포 준비, Release Notes URL
- [[2GP — Push Upgrade]] — Push Upgrade 스케줄, SOAP API, Best Practices
- [[2GP — Install · Uninstall]] — 설치, 업그레이드, 제거 전체 흐름
- [[2GP Managed Package 개발 환경과 사전 준비]] — Namespace 생성, Dev Hub link, Package Dependency Matrix
- [[Unlocked Package 릴리스와 설치]] — Unlocked Package Transfer 비교
