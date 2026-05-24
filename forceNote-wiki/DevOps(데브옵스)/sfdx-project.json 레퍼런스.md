---
tags: [devops, salesforce-dx, sfdx, sfdx-project-json, project-configuration, packageDirectories, string-replacement, multiple-package-directories]
source: sfdx_dev.pdf v67.0 Summer '26 — Chapter 3 (Project Setup, p.45–56)
created: 2026-05-22
aliases: [sfdx-project.json, Salesforce DX Project Configuration, packageDirectories, sourceApiVersion, sourceBehaviorOptions, replacements, string replacement]
---

# sfdx-project.json 레퍼런스

> `sfdx-project.json`의 모든 필드, 기본값, Multiple Package Directories, String Replacement를 소스 대비 전수 정리한 레퍼런스.

---

## 개요

`sfdx-project.json`은 해당 디렉토리가 Salesforce DX 프로젝트임을 나타낸다. 이 설정 파일은 다음을 담당한다:

- 프로젝트 정보 관리
- Org 인증 지원
- 2GP(Second-Generation Package) 생성 지원
- 소스 동기화 시 파일 저장 위치 지시

이 파일은 소스 컨트롤에 체크인(커밋)하는 것을 권장한다.

---

## 기본 sfdx-project.json 구조

```json
{
  "packageDirectories": [
    { "path": "force-app", "default": true },
    { "path": "unpackaged" },
    { "path": "utils" }
  ],
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "63.0"
}
```

---

## 전체 필드 레퍼런스

### `name` (선택, Salesforce Functions 필수)

```json
"name": "myproj"
```

Salesforce DX 또는 Salesforce Functions 프로젝트 이름.

---

### `namespace` (선택)

```json
"namespace": "myNS"
```

- 패키지와 함께 사용되는 글로벌 네임스페이스
- 네임스페이스는 Dev Hub org와 연결된 org에 등록되어 있어야 한다
- `org create scratch` 명령으로 생성된 Scratch org에 이 네임스페이스가 할당된다
- Unlocked Package 생성 시 네임스페이스 없이 패키지를 만들 수도 있다

> **중요:** 네임스페이스를 Salesforce에 등록한 다음, 등록된 네임스페이스를 가진 org를 Dev Hub org에 연결해야 한다.

---

### `oauthLocalPort` (선택)

```json
"oauthLocalPort": 1717
```

- 기본값: `1717`
- 1717 포트가 이미 사용 중이고 Dev Hub org에 JWT 기반 인증을 지원하는 Connected App을 만들 계획이면 변경
- 포트 변경 시 Connected App의 콜백 URL도 함께 변경해야 한다

---

### `packageAliases` (선택)

```json
"packageAliases": {
  "MyPackage": "0Ho...",
  "MyPackage@1.0.0-1": "04t..."
}
```

- 암호 같은 패키지 ID의 별칭
- 2GP(Second-Generation Package) 전용
- 상세 내용은 "Project Configuration File for a Second-Generation Managed Package" 참조

---

### `packageDirectories` (필수)

```json
"packageDirectories": [
  {
    "path": "force-app",
    "default": true
  },
  {
    "path": "unpackaged"
  },
  {
    "path": "utils"
  }
]
```

org와 소스를 동기화할 때 대상이 되는 디렉토리를 지정한다. 이 디렉토리들은 managed/unmanaged 패키지 소스 파일이나 ant tool·change set으로 생성된 비패키지 소스 파일을 담을 수 있다.

**핵심 규칙:**

| 규칙 | 설명 |
|---|---|
| 경로는 프로젝트 기준 상대경로 | 절대경로 사용 금지. `"path": "helloWorld"` 와 `"path": "./helloWorld"` 는 동일 |
| 기본 경로(default)는 1개만 | 복수의 path가 있으면 반드시 하나에만 `"default": true` 설정. path가 1개면 자동으로 default |
| 기본 패키지 디렉토리 역할 | org → 로컬 retrieve 시 변경 내용이 저장되는 기본 위치. 2GP 패키지 생성 시에도 사용 |
| 소스 변환 기본 위치 | 출력 디렉토리 미지정 시 소스 변환(메타데이터 포맷 ↔ 소스 포맷) 파일이 저장되는 위치 |

2GP 관련 추가 옵션은 "Project Configuration File for a Second-Generation Managed Package" 참조.

---

### `plugins` (선택)

```json
"plugins": {
  "yourPluginName": {
    "timeOutValue": "2"
  },
  "yourOtherPluginName": {
    "yourCustomProperty": true
  }
}
```

커스텀 플러그인의 설정값·설정을 추가한다. 소스 컨트롤에 체크인하려는 프로젝트 전체 팀에 영향을 주는 값만 여기에 저장한다.

---

### `pushPackageDirectoriesSequentially` (선택, Deprecated)

> **Deprecated:** `force:source:push` 명령에만 적용됨. `project deploy start`에는 영향 없음. 패키지 순차 배포가 필요하면 `project deploy start`를 여러 번 원하는 순서로 실행한다.

```json
"packageDirectories": [
  {
    "path": "es-base-custom",
    "default": true
  },
  {
    "path": "es-base-ext"
  }
],
"pushPackageDirectoriesSequentially": true
```

`true`로 설정 시 `force:source:push` 사용 시 `packageDirectories` 나열 순서대로 각 패키지 디렉토리를 별도 트랜잭션으로 push. 기본값은 `false` (단일 트랜잭션, 순서 무관).

---

### `replacements` (선택)

배포 전 또는 패키지 버전 생성 전에 메타데이터 소스 파일의 특정 문자열을 자동으로 교체한다. **소스 파일 자체는 변경되지 않으며** 배포·패키지 파일에만 적용된다.

상세 내용은 아래 "String Replacement (문자열 교체)" 섹션 참조.

---

### `sfdcLoginUrl` (선택)

```json
"sfdcLoginUrl": "https://login.salesforce.com"
```

- `org login` 명령이 사용할 로그인 URL
- 미지정 시 기본값: `https://login.salesforce.com`
- Sandbox org 인증 시: `https://test.salesforce.com`으로 설정
- 프로젝트 외부에서 `org login` 실행하거나 이 파라미터가 없으면 `--instance-url` 플래그로 인스턴스 URL을 직접 지정

---

### `sourceApiVersion` (선택)

```json
"sourceApiVersion": "63.0"
```

소스가 호환되는 API 버전을 지정한다.

**동작 원리:**
- `project deploy`, `project retrieve`, `project convert` 실행 시 각 메타데이터 타입에서 조회할 필드를 이 버전 기준으로 결정
- 최근 릴리즈에서 변경된 메타데이터 타입을 사용한다면 소스의 버전을 명시적으로 지정해야 한다

**주의:** `org-api-version` CLI 설정 변수와 이름이 비슷하지만 다르다. 기본값에 대한 자세한 내용은 "How API Version and Source API Version Work in Salesforce CLI" 참조.

---

### `sourceBehaviorOptions` (선택, Beta)

```json
"sourceBehaviorOptions": ["decomposePermissionSetBeta2", "decomposeCustomLabelsBeta2"]
```

DX 프로젝트에서 분해할 메타데이터 타입을 지정한다. Custom Objects와 Custom Object Translations는 항상 기본 분해된다.

> **주의:** `sfdx-project.json`을 직접 수정하지 말 것. `project convert source-behavior` CLI 명령을 실행하면 이 파일이 자동 업데이트된다.

> **Beta 고지:** Permission Sets, Custom Labels, Sharing Rules, Workflows 분해는 Beta/Pilot 서비스.

**가능한 값:**

| 값 | 분해 대상 |
|---|---|
| `decomposeCustomLabelsBeta2` | CustomLabels 메타데이터 타입 |
| `decomposeExternalServiceRegistrationBeta` | ExternalServiceRegistration 메타데이터 타입 |
| `decomposePermissionSetBeta2` | PermissionSet 메타데이터 타입 |
| `decomposeSharingRulesBeta` | SharingRules 메타데이터 타입 |
| `decomposeWorkflowBeta` | WorkFlow 메타데이터 타입 |

---

## Multiple Package Directories

### 개념

DX 프로젝트 로컬에서 메타데이터를 논리적 그룹으로 나눠 여러 패키지 디렉토리를 만든다. 이 구조는 **클라이언트 사이드(로컬)에만** 존재한다. `project deploy start`로 org에 배포해도 로컬 패키지 디렉토리 위치와 org의 패키지 간 연결은 없다.

> **용어 구분:**
> - **패키지 디렉토리 (Package Directory):** 로컬에서 분해된 메타데이터 파일을 담는 디렉토리 (소스 포맷)
> - **패키지 (Package):** Unlocked Package 또는 2GP 패키지

나중에 Unlocked Package 또는 2GP를 사용하려면, 이 디렉토리들이 실제 패키지에 대응한다.

### 설정 예시

```json
{
  "packageDirectories": [
    {
      "path": "es-base-custom",
      "default": true
    },
    {
      "path": "es-base-ext"
    },
    {
      "path": "es-base-styles"
    }
  ]
}
```

이 예시는 3개 패키지 디렉토리(`es-base-custom`(기본), `es-base-ext`, `es-base-styles`)를 정의한다. 프로젝트 최상위 디렉토리(`easy-spaces-lwc`)의 하위 구조:

```
easy-spaces-lwc/
├── sfdx-project.json
├── es-base-custom/          ← 기본 패키지 디렉토리
│   └── main/default/
│       ├── classes/
│       ├── lwc/
│       └── objects/
├── es-base-ext/
│   └── main/default/
│       └── ...
└── es-base-styles/
    └── main/default/
        └── ...
```

각 `es-base-*` 디렉토리는 표준 DX 프로젝트 구조를 따른다.

### 배포 (deploy)

```bash
# 모든 패키지 디렉토리의 메타데이터 배포 (기본)
sf project deploy start --target-org my-org

# 특정 패키지 디렉토리만 배포
sf project deploy start --source-dir es-base-custom --target-org my-org

# 여러 패키지 디렉토리 배포
sf project deploy start \
  --source-dir es-base-custom \
  --source-dir es-base-ext \
  --source-dir es-base-styles \
  --target-org my-org

# 모든 패키지 디렉토리에서 특정 메타데이터 타입 배포
sf project deploy start --metadata ApexClass --target-org my-org
```

**기본 배포 동작:**
- 새 org: 모든 패키지 디렉토리의 전체 메타데이터 배포
- 이후: 신규·변경·삭제 예정 메타데이터만 배포
- 기본적으로 단일 트랜잭션으로 배포 (패키지 디렉토리 순서 무관)

### 가져오기 (retrieve)

```bash
# 원격 변경 내용 모두 가져오기
sf project retrieve start --target-org my-org
# 각 컴포넌트에 대해 모든 패키지 디렉토리에서 로컬 매칭 검색
# 매칭 있으면: 해당 위치 업데이트
# 매칭 없으면: 기본 패키지 디렉토리(es-base-custom)에 복사

# 특정 패키지 디렉토리의 메타데이터만 가져오기
sf project retrieve start --source-dir es-base-custom --target-org my-org

# 모든 Apex 클래스 가져오기
sf project retrieve start --metadata ApexClass --target-org my-org
# 신규 클래스 → 기본 패키지 디렉토리
# 기존 클래스 → 로컬에 있는 해당 패키지 디렉토리
```

### 순차 배포 (Push Source Sequentially)

기본적으로 `project deploy start`는 단일 트랜잭션으로 배포. 순차 배포가 필요한 경우:

- 재조합된 메타데이터 컴포넌트 파일 수가 Salesforce 한도(retrieve/deploy당 10,000개)를 초과
- 패키지 디렉토리 간 의존성으로 특정 순서가 필요
- 여러 패키지 디렉토리에 동일 메타데이터 컴포넌트가 있고 배포 순서 제어가 필요

```bash
# 원하는 순서로 project deploy start를 여러 번 실행
sf project deploy start --source-dir es-base-custom --target-org my-org
sf project deploy start --source-dir es-base-ext --target-org my-org
sf project deploy start --source-dir es-base-styles --target-org my-org
```

---

## String Replacement (문자열 교체)

### 개요

배포 또는 패키지 버전 생성 직전에 메타데이터 소스 파일의 특정 문자열을 자동으로 원하는 값으로 교체한다.

**주요 사용 사례:**
- NamedCredential에 테스트용 엔드포인트가 있고, 프로덕션 배포 시 다른 엔드포인트로 교체
- ExternalDataSource에 레포지토리에 저장하고 싶지 않은 비밀번호가 있지만 배포 시 포함 필수
- 여러 org에 거의 동일한 코드를 배포하되, 어느 org냐에 따라 일부 값을 조건부 교체

**동작 시점:**
- `project deploy start`: 소스 포맷 파일이 Metadata API 형식으로 변환되고 ZIP 생성 후 배포될 때
- `package version create`: 패키지 생성 과정에서 소스 파일이 변환될 때

> **소스 파일은 변경되지 않는다.** 교체는 배포·패키지 파일에만 적용된다.

### 설정 방법

`sfdx-project.json`에 `replacements` 속성을 추가한다.

#### 기본 예시

```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "name": "myproj",
  "replacements": [
    {
      "filename": "force-app/main/default/classes/myClass.cls",
      "stringToReplace": "replaceMe",
      "replaceWithEnv": "THE_REPLACEMENT"
    }
  ]
}
```

### `replacements` 속성 키 전수

#### 파일 위치 (둘 중 하나 필수)

| 키 | 설명 | 예시 |
|---|---|---|
| `filename` | 교체할 문자열이 포함된 단일 파일 | `"force-app/main/default/classes/myClass.cls"` |
| `glob` | 교체할 문자열이 포함된 파일 집합 (글로브 패턴) | `"**/classes/*.cls"` |

#### 교체할 문자열 (둘 중 하나 필수)

| 키 | 설명 | 예시 |
|---|---|---|
| `stringToReplace` | 교체할 리터럴 문자열 | `"replaceMe"` |
| `regexToReplace` | 교체할 문자열 패턴을 지정하는 정규 표현식 | `"<apiVersion>\\\\d+\\\\.0</apiVersion>"` |

#### 교체 값 (셋 중 하나 필수)

| 키 | 설명 | 예시 |
|---|---|---|
| `replaceWithEnv` | 지정한 환경 변수의 값으로 교체 | `"THE_REPLACEMENT"` |
| `replaceWithFile` | 지정한 파일의 내용으로 교체 | `"replacementFiles/copyright.txt"` |

#### 조건부 처리 (선택)

| 키 | 설명 | 예시 |
|---|---|---|
| `replaceWhenEnv` | 특정 환경 변수가 특정 값일 때만 교체 수행. `env`(환경 변수명)와 `value`(트리거 값) 속성 포함 | 아래 예시 참조 |
| `allowUnsetEnvVariable` | `replaceWithEnv`와 함께 사용. `true`이면 환경 변수가 미설정 시 교체 문자열을 **빈 문자열로 제거**. `false`(기본값)이면 환경 변수 미설정 시 오류 | `true` / `false` |

### 문법 규칙

```
- 디렉토리 구분자: 항상 forward slash(/) 사용 (Windows에서도 동일)
- JSON과 정규식 모두 backslash(\)를 이스케이프 문자로 사용
  - 점(.)을 매칭하려면(이스케이프 필요): "regexToReplace": "\\."
  - 단일 backslash를 매칭하려면: "regexToReplace": "\\\\"
```

---

### String Replacement 예시 모음

#### 두 파일에 동일한 교체 설정

```json
"replacements": [
  {
    "filename": "force-app/main/default/classes/FirstApexClass.cls",
    "stringToReplace": "replaceMe",
    "replaceWithEnv": "THE_REPLACEMENT"
  },
  {
    "filename": "force-app/main/default/classes/SecondApexClass.cls",
    "stringToReplace": "replaceMe",
    "replaceWithEnv": "THE_REPLACEMENT"
  }
]
```

#### 조건부 교체 (`replaceWhenEnv`)

`DEPLOY_DESTINATION` 환경 변수가 `PROD`일 때만 교체:

```json
"replacements": [
  {
    "filename": "force-app/main/default/classes/myClass.cls",
    "stringToReplace": "replaceMe",
    "replaceWithEnv": "THE_REPLACEMENT",
    "replaceWhenEnv": [{
      "env": "DEPLOY_DESTINATION",
      "value": "PROD"
    }]
  }
]
```

#### 환경 변수 미설정 시 문자열 제거 (`allowUnsetEnvVariable`)

`SOME_ENV_THAT_CAN_BE_BLANK`가 미설정이면 `myNS__`를 제거(빈 문자열로 교체). 설정되면 그 값으로 교체:

```json
"replacements": [
  {
    "filename": "/force-app/main/default/classes/myClass.cls",
    "stringToReplace": "myNS__",
    "replaceWithEnv": "SOME_ENV_THAT_CAN_BE_BLANK",
    "allowUnsetEnvVariable": true
  }
]
```

#### 파일 내용으로 교체 (`replaceWithFile`)

특정 디렉토리의 Apex 클래스 파일 배포 시 `replaceMe` 문자열을 파일 내용으로 교체:

```json
"replacements": [
  {
    "glob": "force-app/main/default/classes/*.cls",
    "stringToReplace": "replaceMe",
    "replaceWithFile": "replacementFiles/copyright.txt"
  }
]
```

#### 정규 표현식으로 `<apiVersion>` 교체

```json
"replacements": [
  {
    "glob": "force-app/main/default/classes/*.xml",
    "regexToReplace": "<apiVersion>\\d+\\.0</apiVersion>",
    "replaceWithFile": "replacementFiles/latest-api-version.txt"
  }
]
```

Apex 클래스 XML 예시 (교체 대상):
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
  <apiVersion>55.0</apiVersion>
  <status>Active</status>
</ApexClass>
```

---

### String Replacement 팁

```bash
# macOS/Linux: 환경 변수를 단일 명령에 앞에 붙여 적용 (터미널 기록에 남으므로 주의)
THE_REPLACEMENT="some text" DEPLOY_DESTINATION=PROD sf project deploy start

# .env 파일 활용 (dotenv-cli)
dotenv -e .env1 -e .env2 sf project deploy start
```

> **경고:** 비밀번호나 시크릿을 이 방식으로 설정하면 터미널 기록에 남는다. `.env` 파일에 비밀번호나 시크릿을 커밋하지 말 것.

**JSON 출력 확인:**
```bash
# replacements 결과 포함 JSON 출력
sf project deploy start --json

# --concise와 함께 사용하면 replacements 정보 제외
sf project deploy start --json --concise

# 사람이 읽을 수 있는 출력에서 교체 정보 확인
sf project deploy start --verbose
```

---

### String Replacement 테스트

실제 배포 없이 교체 결과 확인:

```bash
# 1. 환경 변수 설정
export SF_APPLY_REPLACEMENTS_ON_CONVERT=true

# 2. 소스를 Metadata API 형식으로 변환
sf project convert source --output-dir mdapiOut --source-dir force-app

# 3. 출력 디렉토리(mdapiOut)에서 교체 결과 확인
```

> **경고:** 테스트 중 파일시스템에 비밀번호나 시크릿이 기록될 수 있다. 테스트 후 환경 변수를 반드시 초기화한다.

---

### String Replacement 제한 사항

| 제한 | 설명 |
|---|---|
| 다수 파일의 성능 저하 | 여러 파일에 교체를 설정하면 배포 성능 저하 가능. 가능하면 `filename` 키 사용. `glob` 사용 시 범위를 최소화 (예: `"force-app/main/default/classes/*.cls"`가 `"**/classes/**"`보다 좋음) |
| Static Resources 주의 | Static Resource 디렉토리에 교체를 설정하면 CLI가 더 많은 파일을 검사해야 해 성능 저하 가능 |
| Metadata 형식 배포 불가 | `project deploy start --metadata-dir`로 metadata 형식으로 배포할 때는 문자열 교체 불가 |
| 비동기 배포 시 | `--async` 플래그 사용 또는 타임아웃 후 `project deploy resume`/`project deploy report`로 확인 시 교체는 적용되지만 교체 정보는 `project deploy start --verbose`와 동일하게 출력되지 않음 |

---

## 관련 노트

- [[Salesforce DX 개요]] — sfdx-project.json, Source Format, .forceignore 요약 개요
- [[DX 프로젝트 구조와 소스 포맷]] — DX 프로젝트 생성·디렉토리 구조·소스 포맷 전수
- [[메타데이터 분해와 forceignore]] — sourceBehaviorOptions 분해 타입 전수, .forceignore 전수
- [[Unlocked Package 패턴]] — packageAliases, packageDirectories 패키지 설정
- [[Scratch Org 패턴]] — Scratch org 생성, 설정, 스냅샷
- [[CI CD 패턴]] — JWT 인증, 자동화 배포 파이프라인
- [[2GP — Develop]] — 2GP 전용 packageDirectories 파라미터(ancestorId/ancestorVersion/seedMetadata 등)·전체 예시 JSON
