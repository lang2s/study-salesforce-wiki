---
tags: [DevOps, Packaging, 2GP, ManagedPackage, PackageCreate, PackageVersion, VersionNumbering, ProjectConfigFile, PackageAncestor, PackagePromote, 매니지드패키지, 패키지개발, 버전생성, 프로젝트설정파일]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.334-347
created: 2026-05-24
aliases: [2GP Develop, Develop Second-Generation Managed Packages, sf package create 2GP, sf package version create 2GP, 2GP 패키지 생성, 2GP 버전 생성, MAJOR.MINOR.PATCH.BUILD, Package Ancestor, ancestorId, ancestorVersion, HIGHEST NONE NEXT LATEST, Project Configuration File 2GP, sfdx-project.json 2GP, Package Version Promote 준비, 2GP 패키지 개발 전체 흐름]
---

# 2GP — Develop (패키지 생성 · 버전 관리 · Ancestor)

> `sf package create`로 패키지를 만들고 `sf package version create`로 버전을 생성·관리하며, `sfdx-project.json`의 Project Configuration File 파라미터와 Package Ancestor 규칙으로 2GP managed package 전체 개발 사이클을 완성하는 방법을 전수 정리한다.

---

## 1. Develop Second-Generation Managed Packages — 전체 구성

p.334 "Develop Second-Generation Managed Packages" 섹션은 아래 하위 주제로 구성된다.

| 하위 주제 | 내용 |
|---|---|
| Create a Second-Generation Managed Package | `sf package create` 명령, 메타데이터 한도 |
| View Package Details | `sf package list` |
| Create Versions | `sf package version create`, 비동기·스킵 검증 |
| Guidance for Package Version Numbering | MAJOR.MINOR.PATCH.BUILD, NEXT 키워드 |
| View Details about a Package Version | `sf package version list`, `create report` |
| Project Configuration File | `sfdx-project.json` 파라미터 전수 |
| Get Ready to Promote and Release | beta → managed-released 상태, 75% 커버리지 |
| Specify a Package Ancestor | ancestorId, ancestorVersion, HIGHEST / NONE |

---

## 2. Create a Second-Generation Managed Package

패키지는 앱·패키지의 이름·설명·네임스페이스를 담는 **최상위 컨테이너**다. `sf package create` Salesforce CLI 명령으로 생성한다.

### 2-1. sf package create

```bash
# 패키지 생성 기본 명령
sf package create --name "Expenser App" --package-type Managed \
  --path "expenser-main" --target-dev-hub my-hub \
  --error-notification-username me@devhub.org
```

- `--name`: 패키지 이름이 곧 패키지 alias가 되어 `sfdx-project.json`에 자동 추가된다.
- `--package-type Managed`: 2GP managed package 지정.
- `--path`: 패키지 메타데이터가 위치하는 디렉터리.
- `--error-notification-username`: Apex gack·설치/업그레이드/제거 실패 시 이메일 수신자(active Dev Hub org user).
- 생성된 패키지 정보는 `sfdx-project.json`에 자동 반영된다.
- 패키지 생성 후 **namespace 및 package type은 변경 불가**.

### 2-2. Update Details about a Package

기존 패키지의 이름·설명을 변경할 때 사용한다.

```bash
sf package update --package "Expense App" \
  --name "Expense Manager App" \
  --description "The Winter '21 release is packed with an exciting set of features." \
  --error-notification-username me2@devhub.org
```

- 최소 하나의 패키지 버전을 released 상태로 promote한 후에는, `sf package update`로 특정 버전을 subscribers에게 권장 버전으로 지정할 수 있다.

### 2-3. Metadata Limits in Second-Generation Managed Packages

| Metadata in package | Limit |
|---|---|
| Number of Metadata Files | 10,000 files |
| Total Metadata File Size | 600 MB |

---

## 3. View Package Details for a Second-Generation Managed Package

Dev Hub org의 모든 패키지 목록을 확인한다.

```bash
sf package list --target-dev-hub my-hub
```

샘플 출력:
```
Namespace Prefix    Name             Id                  Alias           Type
────────────────    ────────────     ──────────────────  ──────────────  ───────
db_exp_manager      Expenser App     0HoB00000004CzRKAU  Expenser App    Managed
db_exp_manager      Expenser Logic   0HoB00000004CzMKAU  Expenser Logic  Managed
db_exp_manager      Expenser Schema  0HoB00000004CzHKAU  Expenser Schema Managed
```

- `--concise`: 출력 항목 축소.
- `--verbose`: Created By, Error Notification Username, Subscriber Package ID 추가 표시.

---

## 4. Create Versions of a Second-Generation Managed Package

패키지 버전은 패키지 내용과 관련 메타데이터의 **고정 스냅샷**. 설치 가능하고 불변(immutable)인 아티팩트로, 변경 사항을 추적·관리한다.

버전 생성 전 확인 사항:
1. `sfdx-project.json`의 `versionNumber` 파라미터 갱신.
2. 변경·추가할 메타데이터가 패키지 메인 디렉터리에 있는지 확인.
3. 의존성, 패키지 ancestor, 메타데이터 검증 방식 선택 (아래 3가지 옵션).

### 4-1. Create a Managed 2GP Package Version (Default Option)

```bash
sf package version create \
  --package "Expenser App" \
  --installation-key "HIF83kS8kS7C" \
  --definition-file config/project-scratch-def.json \
  --code-coverage \
  --wait 10
```

- `--wait`: 지정 시간(분) 내에 버전이 생성되면 `sfdx-project.json`이 자동 업데이트된다. 시간 초과 시 수동으로 프로젝트 파일을 편집해야 한다.
- 버전 생성은 패키지 크기에 따라 오래 걸릴 수 있다.

버전 생성 상태 확인:

```bash
sf package version create report --package-create-request-id 08cxx00000000YDAAY
```

샘플 출력:
```
=== Package Version Create Request
NAME                        VALUE
────────────────────────────────────────────
Version Create Request Id   08cB00000004CBxIAM
Status                      InProgress
Package Id                  0HoB00000004C9hKAE
Package Version Id          05iB0000000CaaNIAS
Subscriber Package Version Id  04tB0000000NOimIAG
Tag                         git commit id 08dcfsdf
Branch
CreatedDate                 2024-05-08 09:48
Installation URL            https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000NOimIAG
```

여러 개의 pending 요청이 있을 때 목록 확인:

```bash
sf package version create list --created-last-days 0
```

```
=== Package Version Create Requests [3]
ID       STATUS   PACKAGE2 ID  PKG2 VERSION ID  SUB PKG2 VER ID  TAG  BRANCH  CREATED DATE
08c...   Error    0Ho...
08c...   Success  0Ho...       05i...           04t...                          2024-06-22 12:07
08c...   Success  0Ho...       05i...           04t...                          2024-06-23 14:55
```

### 4-2. Async Validation

CI 스크립트를 사용하는 개발팀은 **async validation**으로 패키지 검증이 완료되기 전에 설치 가능한 아티팩트를 먼저 얻어 포스트 패키지 생성 작업을 앞당길 수 있다.

```bash
sf package version create --async-validation <rest of command syntax>
```

샘플 출력:
```
Version create.... Create version status: PerformingValidations
The validations for this package version are in progress, but you can now begin testing this package version.
To determine whether all package validations complete successfully, run "sf package version create report --package-create-request-id 08cxx", and review the Status.
Async validated package versions can be promoted only if all validations complete successfully.
Successfully created the package version [08cxx. Subscriber Package Version Id: 04txx
Package Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=04txx
```

- async validated 패키지 버전은 **모든 검증이 성공적으로 완료된 경우에만** promote 가능.

### 4-3. Skip Validation

의존성·package ancestors·메타데이터 검증을 건너뛴다. 버전 생성 시간을 크게 단축하지만, **skip validation으로 생성한 버전은 released 상태로 promote 불가**.

```bash
sf package version create --skip-validation <rest of command syntax>
```

- `--skip-validation`과 `--code-coverage`는 동시 지정 불가 (코드 커버리지는 검증 중에 계산됨).
- `--skip-validation`과 `--async-validation`도 동시 지정 불가.

### 4-4. Update Details about a Managed 2GP Package Version

버전의 대부분 속성을 커맨드라인에서 변경할 수 있다. 단, **release status는 변경 불가**.

```bash
# tag 파라미터 추가 예시
sf package version update \
  --package "Expenser App@1.3.0-5" \
  --tag "git commit id 08dcfsdf"
```

출력: `Successfully updated the package version. 04tB0000000KPhnIAG`

### 4-5. 하루 버전 생성 한도 확인

```bash
sf limits api display
```

`Package2VersionCreates` 항목 확인:
```
NAME                        REMAINING  MAXIMUM
─────────────────────────── ─────────  ───────
Package2VersionCreates      23         50
```

---

## 5. Guidance for Package Version Numbering

버전 번호 형식: **MAJOR.MINOR.PATCH.BUILD** (예: `2.2.0.1`)

모든 패키지 버전은 개발자가 지정하는 버전 번호 + 버전 생성 시 자동 할당되는 고유 subscriber package version ID(04t로 시작)를 동시에 가진다.

### 5-1. 버전 번호 지정 방법

`sfdx-project.json`의 `versionNumber` 속성이 다음 버전 생성 시 할당될 번호를 결정한다. 새 버전을 만들기 전 **반드시 수동으로 increment**해야 한다. 그렇지 않으면 같은 버전 번호에 다른 04t ID를 가진 패키지 버전이 여러 개 생긴다.

```json
{
  "packageDirectories": [
    {
      "versionNumber": "2.2.0.1"
    }
  ]
}
```

### 5-2. NEXT 키워드로 고유 Build Number 보장

베스트 프랙티스로, `versionNumber`에 `NEXT` 키워드를 사용하면 build 부분이 자동으로 다음 가용 번호로 증가하여 수동 increment 없이도 고유성이 보장된다.

```json
{
  "packageDirectories": [
    {
      "versionNumber": "2.2.0.NEXT"
    }
  ]
}
```

### 5-3. CLI 플래그로 버전 번호 재정의

```bash
sf package version create -p "my2gp" --version-number 2.2.0.NEXT <rest of command syntax>
```

- `--version-number` 플래그는 `sfdx-project.json`을 업데이트하지 않는다. 파일의 `versionNumber`는 수동으로 최신 상태로 유지해야 한다.

### 5-4. Promote 이후 규칙

- 특정 `MAJOR.MINOR.PATCH` 버전을 promote한 후에는 동일한 `MAJOR.MINOR.PATCH` 번호로 새 버전을 만들 수 없다.
- `MAJOR` vs `MINOR` 변경 기준: 제약 사항이 있는 변경은 patch 버전에서만 허용. major vs minor 구분은 개발자 재량.
- 각 minor 패키지 버전에 대해 promote할 수 있는 beta 버전은 **하나뿐**이다.

---

## 6. View Details about a Second-Generation Managed Package Version

### 6-1. 생성 요청 상태 확인

```bash
sf package version create report --package-create-request-id 08cxx00000000YDAAY
```

### 6-2. Dev Hub org의 모든 버전 목록

```bash
sf package version list --target-dev-hub my-hub
```

샘플 출력:
```
Package Name     Namespace        Version  Sub Pkg Ver Id       Alias                    Released
───────────────  ───────────────  ───────  ───────────────────  ───────────────────────  ────────
Expenser Schema  db_exp_manager   0.1.0.1  04tB0000000719qIAA   Expenser Schema@0.1.0-1  true
Expenser Schema  db_exp_manager   0.2.0.1  04tB000000071AjIAI   Expenser Schema@0.2.0-1  true
Expenser Schema  db_exp_manager   0.3.0.1  04tB000000071AtIAI   Expenser Schema@0.3.0-1  false
Expenser Schema  db_exp_manager   0.3.0.2  04tB000000071AyIAI   Expenser Schema@0.3.0-2  true
Expenser Logic   db_exp_manager   0.1.0.1  04tB0000000719vIAA   Expenser Logic@0.1.0-1   true
Expenser App     db_exp_manager   0.1.0.1  04tB000000071A0IAI   Expenser App@0.1.0-1     true
```

`--verbose` 추가 표시 항목: Ancestor, Ancestor Version, Branch, Build Duration in Seconds, Code Coverage, Code Coverage Met, Created By, Created Date, Description, Installation URL, Language, Managed Metadata Removed, Metadata File Size, Number of Metadata Files, Package ID, Package Version ID, Release Version, Tag, Validation Skipped, WasTransferred

---

## 7. Project Configuration File for a Second-Generation Managed Package

`sfdx-project.json`은 프로젝트의 **blueprint**. managed 2GP 패키지 속성과 패키지 내용을 결정한다. `sf project generate` CLI 명령으로 기본 파일을 생성할 수 있다.

### 7-1. packageDirectories 파라미터 전수

| 파라미터 | 필수 여부 | 기본값 | 설명 |
|---|---|---|---|
| `ancestorId` | 이전 promoted 버전 있으면 필수 | None | 패키지 ancestry tree의 직계 부모 버전 ID(04t) 또는 alias. `ancestorVersion`과 택일. 예: `"Expenser Logic@0.1.0-1"` |
| `ancestorVersion` | 이전 promoted 버전 있으면 필수 | None | 직계 부모 버전 번호(major.minor.patch.build). `ancestorId`와 택일. 예: `"0.1.0.1"` |
| `default` | 패키지 디렉터리가 둘 이상이면 필수 | true | 기본 패키지 디렉터리. `sf project retrieve` 시 메타데이터가 이 경로에 배치됨. 하나만 true 가능. |
| `definitionFile` | 아니오 | None | 패키지 메타데이터에 필요한 features·org settings를 지정하는 외부 .json 파일 참조. 예: `"config/project-scratch-def.json"` |
| `namespace` | 예 | None | 패키지와 내용을 다른 개발자 패키지와 구별하는 1~15자 알파뉴메릭 식별자. |
| `package` | 예 | None | 패키지 이름. |
| `packageAliases` | 아니오 | CLI가 자동 업데이트 | 패키지·버전 생성 시 자동 추가. 암호화된 패키지 ID 대신 sf package 명령 실행 시 alias 사용 가능. |
| `path` | 예 | None | 패키지 메타데이터 위치. `sf package create`의 `--path` 속성과 동일. |
| `seedMetadata` | 아니오 | None | seedMetadata 디렉터리 경로. 표준 value set에만 사용 가능. 패키지가 standard value set에 의존하는 경우 해당 value set이 있는 seed metadata 디렉터리를 지정. |
| `versionDescription` | 아니오 | None | 버전 설명. |
| `versionName` | 아니오 | versionNumber | 버전 이름. 미지정 시 CLI가 versionNumber를 버전 이름으로 사용. |
| `versionNumber` | 예 | None | 다음 버전 생성 시 할당할 버전 번호. 형식: MAJOR.MINOR.PATCH.BUILD (예: 1.2.1.8). 새 버전 생성 전 반드시 increment. `NEXT` 키워드 사용 가능. |

### 7-2. 전체 예시 sfdx-project.json

```json
{
  "namespace": "exp-mgr",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "61.0",
  "packageDirectories": [
    {
      "path": "util",
      "default": true,
      "package": "Expense Manager - Util",
      "versionName": "Summer '24",
      "versionDescription": "Welcome to Summer 2024 Release of Expense Manager Util Package",
      "versionNumber": "4.7.0.NEXT",
      "definitionFile": "config/scratch-org-def.json"
    },
    {
      "path": "exp-core",
      "default": false,
      "package": "Expense Manager",
      "versionName": "v 3.2",
      "versionDescription": "Summer 2024 Release",
      "versionNumber": "3.2.0.NEXT",
      "ancestorVersion": "3.0.0.7",
      "definitionFile": "config/scratch-org-def.json",
      "dependencies": [
        {
          "package": "Expense Manager - Util",
          "versionNumber": "4.7.0.LATEST"
        },
        {
          "package": "External Apex Library - 1.0.0.4"
        }
      ]
    }
  ],
  "packageAliases": {
    "Expense Manager - Util": "0HoB00000004CFpKAM",
    "External Apex Library@1.0.0.4": "04tB0000000IB1EIAW",
    "Expense Manager": "0HoB00000004CFuKAM"
  }
}
```

### 7-3. 자동 업데이트 비활성화 환경 변수

`sfdx-project.json`의 자동 업데이트를 억제할 때:

| 명령 | 환경 변수 (true로 설정) |
|---|---|
| `sf package create` | `SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_CREATE` |
| `sf package version create` | `SFDX_PROJECT_AUTOUPDATE_DISABLE_FOR_PACKAGE_VERSION_CREATE` |

---

## 8. Get Ready to Promote and Release a Second-Generation Managed Package Version

### 8-1. Beta vs Released 상태

- 생성된 모든 패키지 버전은 **beta** 상태.
- beta 버전은 **scratch org와 sandbox에만** 설치 가능.
- beta 버전을 org에 설치한 후에는 해당 설치된 beta 버전을 upgrade할 수 없다.
- beta 버전을 released로 promote하려면 **75% 코드 커버리지** 충족이 필수.

### 8-2. Promote 명령

```bash
sf package version promote <package-version-id>
```

### 8-3. Promote 후 규칙

- promote 후에는 **역방향 취소 불가** (beta 상태로 되돌릴 수 없음).
- 배포하고 싶지 않은 released 버전이 있다면 `sf package version update`로 installation key를 알아보기 어려운 값으로 변경하여 실수로 설치되지 않도록 한다.
- promoted 버전은 production org 및 개발 org에 설치 가능하며 고객에게 배포할 수 있다.
- 각 minor 패키지 버전에서 promote 가능한 beta 버전은 **하나뿐**. (예: 버전 2.3의 여러 beta 중 하나만 promote 가능. promote 후에는 2.4부터 새로 개발.)

---

## 9. Specify a Package Ancestor in the Project File

2GP 버전 생성 시 `sfdx-project.json`에 **package ancestor**를 지정해야 한다. 지정하는 ancestor는 해당 패키지의 **가장 높은 promoted 버전 번호**여야 한다.

### 9-1. HIGHEST 키워드 (권장)

`ancestorId` 또는 `ancestorVersion`에 `HIGHEST` 키워드를 사용하면 자동으로 가장 높은 promoted 버전으로 설정된다. 선형 버전 관리를 유지하는 한 가장 쉬운 방법.

```json
{
  "packageDirectories": [
    {
      "path": "util",
      "package": "Expense Manager - Util",
      "versionNumber": "4.7.0.NEXT",
      "ancestorVersion": "HIGHEST"
    }
  ]
}
```

### 9-2. ancestorVersion 속성 직접 지정

`major.minor.patch` 번호로 ancestor를 지정한다. major·minor·patch 값이 변경될 때마다 수동 갱신이 필요하다.

```json
{
  "packageDirectories": [
    {
      "path": "util",
      "package": "Expense Manager - Util",
      "versionNumber": "4.7.0.NEXT",
      "ancestorVersion": "4.6.0"
    }
  ]
}
```

### 9-3. ancestorId 속성 직접 지정

`04t` ID 또는 패키지 버전 alias로 지정한다. 버전을 생성할 때마다 수동 갱신이 필요하다.

```json
// 04t ID로 지정
{
  "packageDirectories": [
    {
      "path": "util",
      "package": "Expense Manager - Util",
      "versionNumber": "4.7.0.NEXT",
      "ancestorId": "04tB0000000cWwnIAE"
    }
  ]
}
```

```json
// alias로 지정
{
  "packageDirectories": [
    {
      "path": "util",
      "package": "Expense Manager - Util",
      "versionNumber": "4.7.0.NEXT",
      "ancestorId": "expense-manager@4.6.0.1"
    }
  ]
}
```

> 주의: ancestor로 지정할 수 있는 버전은 **managed-released 상태로 promote된 버전만** 가능.

### 9-4. 선형 버전 관리 이탈 (Override Linear Package Ancestry)

가장 높은 promoted 버전이 아닌 다른 버전을 ancestor로 지정하려면 `--skip-ancestor-check` 플래그를 사용한다.

```bash
sf package version create --package "Expenser App" --skip-ancestor-check
```

### 9-5. NONE 키워드

ancestor를 지정하지 않으려면 `NONE` 키워드를 사용한다. 단, `NONE`으로 만든 버전은 **기존 고객이 해당 버전으로 upgrade할 수 없다**. promote 계획이 없는 버전에만 사용한다.

```json
{
  "packageDirectories": [
    {
      "path": "util",
      "package": "Expense Manager - Util",
      "versionNumber": "4.7.0.NEXT",
      "ancestorVersion": "NONE"
    }
  ]
}
```

- 이전 promoted 버전이 이미 있는 경우, `NONE`으로 새 버전을 만들 때는 `--skip-ancestor-check`를 함께 지정해야 한다.

### 9-6. Package Ancestry 주의 사항

- Package ancestry는 기존 패키지가 새 버전으로 upgrade될 수 있는지를 결정한다.
- 선형 버전 관리를 벗어나거나 고객 org에 설치된 버전을 abandon하려는 경우, 기존 고객에 대한 영향 및 upgrade path 가용 여부를 반드시 고려한다.
- 버전을 abandon하면 `sf package version delete`로 삭제하거나, 삭제가 불가능하면 `sf package version update`로 installation key를 업데이트하여 실수로 설치되지 않도록 한다.

---

## 비교표 — Ancestor 지정 방법 3가지

| 방법 | 속성 | 자동 업데이트 | 수동 갱신 필요 시 |
|---|---|---|---|
| HIGHEST 키워드 (권장) | `ancestorVersion: "HIGHEST"` | 자동 | 없음 |
| ancestorVersion 직접 지정 | `ancestorVersion: "4.6.0"` | 수동 | major·minor·patch 변경 시 |
| ancestorId 직접 지정 | `ancestorId: "04t..."` 또는 alias | 수동 | 매 버전 생성 시 |

---

## 비교표 — 버전 생성 옵션 3가지

| 옵션 | 명령 플래그 | 검증 완료 전 installable | Promote 가능 |
|---|---|---|---|
| Default (전체 검증) | 없음 | 아니오 | 예 (검증 통과 시) |
| Async Validation | `--async-validation` | 예 (검증 진행 중 설치 가능) | 예 (검증 성공 시만) |
| Skip Validation | `--skip-validation` | 예 | 아니오 |

---

## 관련 노트
- [[2GP Managed Package — Workflow]] — 전체 10단계 CLI 워크플로 및 지원 컴포넌트 목록
- [[2GP Managed Package 개발 환경과 사전 준비]] — namespace 등록, Dev Hub 연결, Org 준비
- [[2GP Managed Package Scratch Org 워크플로]] — namespaced scratch org 생성, ancestor seeding
- [[2GP — Specific Metadata Behavior]] — Permission Sets, Profile Settings, Protecting IP, @NamespaceAccessible, Connected Apps, Order Save Behavior
- [[sfdx-project.json 레퍼런스]] — sfdx-project.json 전체 파라미터 레퍼런스 (DX 공통)
- [[Unlocked Package 개발과 버전]] — Unlocked Package 버전 생성 비교 (MAJOR.MINOR.PATCH.BUILD 동일 체계)
- [[2GP — Install · Uninstall]] — sf package install·sf package uninstall, InstallHandler, 업그레이드 동작, 의존성 스크립트
- [[2GP — Prepare to Distribute]] — beta→released 승격 후 단계: 코드 커버리지 확인·Installation Key·sf package version promote·AppExchange 등록 절차
- [[2GP — Advanced Features Part 1]] — Package Ancestors 상세, Patch Versions, Dependencies, Keywords, Branches, Advanced Config Parameters
- [[2GP — Advanced Features Part 2]] — Package IDs, Namespace Collisions, Remove Metadata, Delete Package, Transfer Dev Hub
