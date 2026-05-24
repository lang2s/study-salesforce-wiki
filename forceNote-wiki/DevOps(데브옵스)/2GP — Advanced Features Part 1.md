---
tags: [2GP, managed-package, package-ancestors, patch-version, package-dependencies, advanced-config, keywords, branches, unpackaged-metadata, sfdx-project, devops]
source: pkg2_dev.pdf p.374-392
created: 2026-05-24
aliases: [2GP Advanced Features, Package Ancestors, Patch Versions 2GP, 2GP Dependencies, Package Keywords, Branches 2GP, calculateTransitiveDependencies, ancestorVersion, HIGHEST NONE NEXT LATEST RELEASED]
---

# 2GP — Advanced Features Part 1 (Ancestors · Patch · Dependencies · Config)

> Package Ancestry 모델, Patch Version 제약, 패키지 간 Dependencies 설정, Advanced sfdx-project.json 파라미터, Keywords(NEXT/LATEST/RELEASED/HIGHEST/NONE), Release 타겟팅, Branch 태깅, Unpackaged Metadata 지정 전수

---

## 1. Package Ancestors for Second-Generation Managed Packages

### 1-1. 개념

Managed 2GP는 **유연한 버전 관리 모델**을 제공한다. 선형 버전 번호에서 벗어나 "더 이상 기반으로 삼지 않을 버전"을 abandon하고 다른 버전을 ancestor로 지정할 수 있다. 이 의사결정 체계를 **Package Ancestry**라고 한다.

> **핵심 제약:** Ancestor로 지정할 수 있는 버전은 **managed-released 상태의 버전만** 가능하다.

선형 버전 번호 예시 (`major.minor`):
```
1.0 → 1.1 → 1.2 → 2.0
```
다음 버전은 2.0보다 높아야 한다.

### 1-2. 비선형 버전 관리 (Abandon)

개발 중 원하지 않는 버전이 생겼을 때 abandon하고 이전 버전을 ancestor로 지정할 수 있다.

예시:
- 1.0 → 1.1 → **1.2**(mess 발생) → abandon 1.2 → 1.3의 ancestor를 **1.1**로 지정
- 또는: 1.4 → **1.5**(abandon) → 1.6의 ancestor를 **1.4**로 지정

이 트리 형태 버전 관리는 두 팀 이상의 **병렬 패키지 개발**도 가능하게 한다.

> **책임:** Abandoned 버전(1.2, 1.5 등)이 고객 org에 설치되어 있으면 해당 고객은 업그레이드 경로가 없어진다. 패키지는 ancestry line을 따라서만 업그레이드된다.

### 1-3. Patch Versions and Package Ancestry

- patch 버전(예: 1.0.2)을 non-patch 버전의 direct ancestor로 지정할 수 없다.
- 대신 키워드 `"ancestorVersion": "HIGHEST"` 또는 non-patch 버전을 ancestor로 지정한다.
- 설치된 patch 버전은 같은 major.minor 번호를 가진 non-patch 버전의 upgrade path를 상속한다.
  - 예: patch 버전 1.0.3은 1.0.0과 동일한 upgrade path를 갖는다.

### 1-4. Understanding Package Upgrades with Ancestry

아래 테이블과 ancestry tree를 참조해 어떤 업그레이드가 허용되는지 확인한다.

| Upgrade From | Upgrade To | 성공 여부 | 이유 |
|---|---|---|---|
| 1.1 | 1.7 | Yes | ancestry path 공유 |
| 1.3.2 | 1.3.4 | Yes | 같은 major.minor patch 버전 간 업그레이드 허용 |
| 1.3.1 | 1.7 | Yes | 1.3.1은 patch 버전; 1.3→1.7이 허용되므로 1.3.x→1.7도 허용 |
| 1.2 | 1.3 | **No** | ancestry path 공유 안 함 |
| 1.5 | 1.7 | **No** | ancestry path 공유 안 함 |
| 1.4 | 1.3.3 | **No** | Downgrade 불가 |
| 1.0 | 1.8 | Yes | ancestry path 공유 |

### 1-5. View Package Ancestry (CLI)

```bash
# 패키지 버전의 ancestor 정보 확인
sf package version report --package "MyPackage@1.3.0-1"

# 버전 목록에서 ancestor 확인
sf package version list --package MyPackage

# 패키지 ancestry 트리 시각화
sf package version displayancestry --package MyPackage

# dot-code 형식으로 출력 (그래프 시각화 소프트웨어용)
sf package version displayancestry --package MyPackage --dot-code
```

---

## 2. Patch Versions for Second-Generation Managed Packages

### 2-1. 개념

Patch 버전은 주요 기능 변경 없이 소규모 버그를 수정하는 방법이다. 이전 버전의 고객이 주요 버전 업그레이드 없이 패치를 설치할 수 있다.

버전 번호 형식: `major.minor.patch.build`
- non-zero patch 번호가 있으면 patch 버전: `1.1.2.5` → patch 버전
- `1.1.0.4` → patch 버전 아님

### 2-2. Patch 버전에서 할 수 없는 작업 (전수)

```
□ 패키지 컴포넌트 추가 불가
□ 기존 패키지 컴포넌트 삭제 불가
□ API 및 dynamic Apex access control 변경 불가
□ Apex 코드 Deprecate 불가
□ 새 Apex class relationship(extends 등) 추가 불가
□ Apex access modifier(virtual, global 등) 추가 불가
□ 기능, 설정, 패키지 의존성, 웹 서비스 추가 불가
□ 컴포넌트를 protected에서 global로 변경 불가
□ CustomSettings 또는 CustomMetadataType visibility를 protected에서 public으로 변경 불가
```

### 2-3. Patch 버전 생성 규칙

- patch 버전 생성 시 반드시 package ancestor를 지정해야 한다.
- patch 버전과 ancestor의 **major.minor 번호가 반드시 일치**해야 한다.
- 지정된 ancestor는 **managed-released 상태**여야 한다.
- patch 버전을 다른 patch 버전의 ancestor로 지정할 수 있다.
- 단, patch 버전을 non-patch 버전의 direct ancestor로는 지정 불가 (HIGHEST 또는 non-patch 지정).
- patch 버전은 ancestor scratch org definition file의 features/settings를 자동으로 상속한다.

> **활성화 필요:** Patch 버전 기능은 Salesforce Partner Support에 케이스를 등록해야 활성화된다. AppExchange 보안 심사를 통과한 패키지에만 적용 가능.

---

## 3. Create Dependencies Between Second-Generation Managed Packages

### 3-1. 개념

모놀리식 패키지 개발을 피하려면 유사한 기능을 묶은 소규모 모듈 패키지를 개발하고 패키지 간 **dependency**를 정의한다. 의존성은 한 패키지의 메타데이터가 다른 패키지의 메타데이터에 의존할 때 발생한다.

### 3-2. 의존성 지정 방법

**같은 Dev Hub에 연결된 managed 패키지 의존성 (별칭 방식):**
```json
"dependencies": [
  {
    "package": "MyPackageName@0.1.0.1"
  }
]
```

**같은 Dev Hub에 연결된 managed 패키지 의존성 (이름+버전 방식):**
```json
"dependencies": [
  {
    "package": "MyPackageName",
    "versionNumber": "1.0.0.RELEASED"
  }
]
```

**다른 Dev Hub의 managed 패키지 의존성 (04t ID 사용):**
```json
"dependencies": [
  {
    "package": "04txxx"
  }
]
```

> ID로 의존성 지정 시: 패키지 ID와 버전 번호를 함께 지정하면 `0Ho` ID 사용, 패키지 버전 ID만 지정하면 `04t` ID 사용.

### 3-3. 다중 의존성 지정

패키지가 여러 의존성을 가진 경우 **설치 순서대로** 콤마로 구분해 나열한다.

예시: 패키지가 `Expense Manager - Util`에 의존하고, 그 패키지는 `External Apex Library`에 의존하는 경우:

```json
"dependencies": [
  {
    "package": "External Apex Library - 1.0.0.4"
  },
  {
    "package": "Expense Manager - Util",
    "versionNumber": "4.7.0.RELEASED"
  }
]
```

### 3-4. calculateTransitiveDependencies

다단계 의존성이 있을 때 `calculateTransitiveDependencies`를 `true`로 설정하면 직접 의존성만 지정해도 간접(transitive) 의존성이 자동 계산된다.

**calculateTransitiveDependencies = false (기본값) 예시:**

pkgC는 pkgA와 pkgB 모두 설치 순서대로 명시해야 한다:

```json
{
  "packageDirectories": [
    {
      "path": "pkgA-wsp",
      "default": true,
      "package": "pkgA",
      "versionName": "ver 1.3",
      "versionNumber": "1.3.0.NEXT",
      "ancestorVersion": "1.1.0.RELEASED"
    },
    {
      "path": "pkgB-wsp",
      "default": false,
      "package": "pkgB",
      "versionName": "ver 2.3",
      "versionNumber": "2.3.0.NEXT",
      "ancestorVersion": "2.0.0.RELEASED",
      "dependencies": [
        {
          "package": "pkgA@1.1.0.RELEASED"
        }
      ]
    },
    {
      "path": "pkgC-wsp",
      "default": false,
      "package": "pkgC",
      "versionName": "ver 0.1",
      "versionNumber": "0.1.0.NEXT",
      "dependencies": [
        {
          "package": "pkgA@1.1.0.RELEASED"
        },
        {
          "package": "pkgB@2.0.0.RELEASED"
        }
      ]
    }
  ]
}
```

**calculateTransitiveDependencies = true 예시:**

pkgC는 pkgB만 직접 지정하면 pkgA는 자동 계산된다:

```json
{
  "packageDirectories": [
    {
      "path": "pkgA-wsp",
      "default": true,
      "package": "pkgA",
      "versionName": "ver 1.3",
      "versionNumber": "1.3.0.NEXT",
      "ancestorVersion": "1.1.0.RELEASED"
    },
    {
      "path": "pkgB-wsp",
      "default": false,
      "package": "pkgB",
      "versionName": "ver 2.3",
      "versionNumber": "2.3.0.NEXT",
      "ancestorVersion": "2.0.0.RELEASED",
      "dependencies": [
        {
          "package": "pkgA@1.1.0.RELEASED"
        }
      ]
    },
    {
      "path": "pkgC-wsp",
      "default": false,
      "package": "pkgC",
      "versionName": "ver 0.1",
      "versionNumber": "0.1.0.NEXT",
      "calculateTransitiveDependencies": true,
      "dependencies": [
        {
          "package": "pkgB@2.0.0.RELEASED"
        }
      ]
    }
  ]
}
```

### 3-5. 지원되는 의존성 유형

| 유형 | 설명 | 지원 여부 |
|---|---|---|
| 순환 의존성 (Circular) | pkgC → pkgB → pkgA → pkgC | **미지원** |
| 다단계 의존성 (Multi-level) | pkgC → pkgB → pkgA | **지원** |

> 지정된 패키지 버전 번호가 설치 조건에도 영향을 미친다. pkgB를 설치하기 전에 pkgA 버전 1.1 이상이 먼저 설치되어야 한다. 조건 미충족 시 pkgB 설치 실패.

---

## 4. Considerations for Promoting Packages with Dependencies

### 4-1. 주요 확인 질문

promote(릴리즈) 전 아래 질문 중 하나라도 "Yes"이면 추가 검토가 필요하다:

1. base 패키지와 extension 패키지를 **병렬로 개발 중**인가?
2. 새 패키지 버전 생성 시 **skip validation**을 사용 중인가?
3. 패키지 의존성 지정 시 **LATEST 또는 RELEASED 키워드**를 사용 중인가?

모두 "No"이면 준비가 된 시점에 promote하면 된다.

### 4-2. Skip Validation 사용 시 주의사항

skip validation으로 패키지 버전을 생성하면 의존성, package ancestors, 메타데이터 검증이 생략된다.

base 패키지를 skip validation으로 개발 중일 때 extension 패키지는:
- **이전에 promote된 안정 버전**의 base 패키지, 또는
- **skip validation을 사용하지 않은 base 패키지 버전**으로 테스트해야 한다.

base + extension 병렬 개발 시 promote 순서:
1. **먼저 base 패키지 버전을 promote한다.**
2. extension 패키지 dependency를 promoted 버전으로 업데이트 (`RELEASED` 키워드 사용).
3. **그 후 extension 패키지 버전을 생성한다.**
4. 테스트 후 extension 패키지 버전을 promote한다.

### 4-3. LATEST vs RELEASED 키워드 차이

```
버전 생성 순서: 1.0.0.1, 1.0.0.2, 1.0.0.3
promote 버전: 1.0.0.2

→ 1.0.0.RELEASED = 1.0.0.2  (promoted & released 버전)
→ 1.0.0.LATEST   = 1.0.0.3  (가장 최근에 생성된 버전)
```

**실전 예시:**

PkgBase가 활발히 개발 중이고 skip-validation 버전을 생성하는 경우, PkgExtn의 sfdx-project.json:

```json
{
  "path": "pkg-extension",
  "default": false,
  "package": "PkgExtn",
  "versionName": "v 2.3",
  "versionDescription": "Winter 2025",
  "versionNumber": "2.3.0.NEXT",
  "dependencies": [
    {
      "package": "PkgBase",
      "versionNumber": "1.1.0.LATEST"
    }
  ]
}
```

PkgExtn 2.3을 promote하기 전: dependency를 `1.1.0.LATEST` → `1.1.0.RELEASED`로 변경하고, 새 버전을 생성해 테스트한 후 promote한다.

---

## 5. Advanced Project Configuration Parameters for Second-Generation Managed Packages

`sfdx-project.json` 파일의 `packageDirectories` 섹션에 사용 가능한 선택적 고급 파라미터 전수.

### 5-1. apexTestAccess

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 패키지 버전 생성 시 Apex 테스트 실행 컨텍스트 사용자에게 Permission Set과 Permission Set License를 할당한다. |

```json
"apexTestAccess": {
  "permissionSets": [
    "Permission_Set_1",
    "Permission_Set_2"
  ],
  "permissionSetLicenses": [
    "SalesConsoleUser"
  ]
}
```

> User license 할당은 `runAs` Method를 사용해야 한다. User license는 sfdx-project.json에서 할당 불가.

### 5-2. branch

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 패키지에 branch가 연결되어 있지만 패키지 의존성이 다른 branch에 있을 때 사용한다. |

**패키지에 branch가 있고 의존성도 다른 branch에 있는 경우:**
```json
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.3.0.LATEST",
    "branch": "featureC"
  }
]
```

**패키지에 branch가 있지만 의존성에 branch가 없는 경우:**
```json
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.3.0.LATEST",
    "branch": ""
  }
]
```

### 5-3. calculateTransitiveDependencies

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | false |
| 설명 | 패키지의 간접 의존성을 자동 계산한다. true로 설정하면 직접 의존성만 지정하면 된다. |

`calculateTransitiveDependencies`가 활성화되면 `package version displaydependencies` CLI 명령으로 의존성 계층 그래프를 생성할 수도 있다.

### 5-4. dependencies

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 다른 패키지에 대한 의존성을 지정한다. |

**같은 Dev Hub 내 managed 패키지 (별칭 방식):**
```json
"dependencies": [
  {
    "package": "MyPackageName@1.1.0.1"
  }
]
```

**같은 Dev Hub 내 managed 패키지 (이름+버전 방식):**
```json
"dependencies": [
  {
    "package": "MyPackageName",
    "versionNumber": "1.1.0.RELEASED"
  }
]
```

**Dev Hub 외부 managed 패키지 (04t ID 방식):**
```json
"dependencies": [
  {
    "package": "04txxx"
  }
]
```

버전 번호에 `RELEASED` 또는 `LATEST` 키워드 사용 가능.

ID 방식 규칙:
- 패키지 ID + 버전 번호 함께 지정 → `0Ho` ID 사용
- 패키지 버전 ID만 지정 → `04t` ID 사용

### 5-5. postInstallScript

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | managed 패키지 설치 또는 업그레이드 후 subscriber org에서 자동으로 실행되는 Apex 스크립트. |

### 5-6. postInstallURL

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 구독자를 위한 post-install 안내 URL. |

### 5-7. releaseNotesUrl

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 릴리즈 노트 URL. |

### 5-8. scopeProfiles

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | false |
| 설명 | `packageDirectories`의 자식 파라미터. true로 설정하면 해당 package directory의 profile settings만 포함하고, 외부 profile settings는 무시한다. |

- `true`: 해당 package directory의 profile settings만 포함
- `false` (기본값): `sfdx-project.json`에 정의된 모든 package directory의 관련 profile settings 조각을 포함

### 5-9. unpackagedMetadata

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | 패키지에 포함되지 않지만 Apex 테스트에 필요한 메타데이터 경로를 지정한다. 패키지에 포함되지 않으며 subscriber org에 설치되지 않는다. |

### 5-10. uninstallScript

| 항목 | 내용 |
|---|---|
| 필수 여부 | No |
| 기본값 | None |
| 설명 | managed 패키지 제거 전 subscriber org에서 자동으로 실행되는 Apex 스크립트. |

---

## 6. Second-Generation Managed Packaging Keywords

키워드는 패키지 버전 번호를 지정할 때 사용하는 변수다.

| 키워드 | 용도 | 예시 |
|---|---|---|
| `LATEST` | 의존성 지정 시 가장 최근에 생성된 버전 사용 | `"versionNumber": "0.1.0.LATEST"` |
| `NEXT` | build 번호를 다음 가용 번호로 자동 증가 | `"versionNumber": "1.2.0.NEXT"` |
| `RELEASED` | 의존성 지정 시 가장 최근에 promoted & released된 버전 사용 | `"versionNumber": "2.1.0.RELEASED"` |
| `HIGHEST` | ancestor를 가장 높은 promoted & released 버전으로 자동 설정 (ancestor 필드에만 사용) | `"ancestorVersion": "HIGHEST"` |
| `NONE` | ancestor 미지정 (이 버전으로의 업그레이드 경로 없음 — 기존 고객 업그레이드 불가) | `"ancestorVersion": "NONE"` |

```json
// LATEST: 가장 최근 생성 버전 (promoted 여부 무관)
"dependencies": [
  {
    "package": "MyPackageName",
    "versionNumber": "0.1.0.LATEST"
  }
]

// NEXT: build 번호 자동 증가
"versionNumber": "1.2.0.NEXT"

// RELEASED: promoted & released 버전
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "2.1.0.RELEASED"
  }
]

// HIGHEST: 가장 높은 released 버전을 ancestor로
"packageDirectories": [
  {
    "path": "util",
    "package": "Expense Manager - Util",
    "versionNumber": "4.7.0.NEXT",
    "ancestorVersion": "HIGHEST"
  }
]

// NONE: ancestor 없음 (upgrade path 없음)
"packageDirectories": [
  {
    "path": "util",
    "package": "Expense Manager - Util",
    "versionNumber": "4.7.0.NEXT",
    "ancestorVersion": "NONE"
  }
]
```

> `NEXT`를 사용하지 않고 sfdx-project.json 버전 번호를 업데이트하지 않으면 새 패키지 버전이 이전 버전과 같은 번호를 사용한다. 버전 번호 고유성은 강제되지 않지만 각 버전은 고유한 subscriber package version ID(04t로 시작)를 할당받는다.

---

## 7. Target a Specific Release During Salesforce Release Transitions

주요 Salesforce 릴리즈 전환 기간 중 패키지 버전을 생성할 때 `preview` 또는 `previous`를 지정할 수 있다. 이를 통해 Dev Hub org의 릴리즈와 무관하게 특정 릴리즈 버전을 기반으로 패키지 버전을 생성할 수 있다.

### 7-1. 설정 방법

scratch org definition file에 다음 중 하나를 포함:

```json
// 이전 릴리즈 기반
{ "release": "previous" }

// 미리보기 릴리즈 기반
{ "release": "preview" }
```

`sfdx-project.json`의 `sourceApiVersion`을 해당 릴리즈 버전에 맞게 설정한다. `previous` 타겟의 경우 현재 릴리즈보다 낮은 아무 `sourceApiVersion`이나 허용된다.

그 후 패키지 버전 생성 시 해당 scratch org definition file을 지정:

```bash
sf package version create --package pkgA --definition-file config/project-scratch-def.json
```

### 7-2. Salesforce Release 타임라인 (기준일 정보)

| Release Version | Preview Start Date | Preview End Date |
|---|---|---|
| Spring '26 | January 11, 2026 | February 21, 2026 |
| Summer '26 | May 10, 2026 | June 13, 2026 |
| Winter '27 | August 30, 2026 | October 10, 2026 |

> Preview start date: sandbox 인스턴스 업그레이드 시작일. Preview end date: 모든 인스턴스가 GA 릴리즈로 전환 완료일.

---

## 8. Use Branches in Second-Generation Managed Packaging

### 8-1. 브랜치 태깅

소스 컨트롤 시스템(SCS)의 특정 브랜치 메타데이터를 기반으로 패키지 버전을 빌드할 때 `--branch` 속성으로 브랜치 이름을 태깅한다:

```bash
# CLI 플래그로 브랜치 지정 (최대 240자 알파뉴메릭)
sf package version create --branch featureA
```

`sfdx-project.json`의 `packageDirectories` 섹션에도 지정 가능:

```json
"packageDirectories": [
  {
    "path": "util",
    "default": true,
    "package": "pkgA",
    "versionName": "Spring '21",
    "versionNumber": "4.7.0.NEXT",
    "branch": "featureA"
  }
]
```

브랜치를 지정하면 `packageAliases`에 브랜치 이름이 자동으로 추가된다:

```json
"packageAliases": {
  "pkgA@1.0.0.4-featureA": "04tB0000000IB1EIAW"
}
```

### 8-2. 브랜치별 버전 번호

버전 번호는 **브랜치 내에서만** 증가하며, 브랜치 간에 공유되지 않는다. 따라서 같은 버전 번호의 beta 버전이 여러 브랜치에 존재할 수 있다:

| Branch Name | Package Version Alias |
|---|---|
| featureA | pkgA@1.3.0-1-featureA |
| featureB | pkgA@1.3.0-1-featureB |
| (없음) | pkgA@1.3.0-1 |

> 하나의 `major.minor.patch` 버전 번호에 대해 promoted & released 버전은 단 하나만 존재할 수 있다.

### 8-3. Package Dependencies and Branches

| 의존성 지정 시나리오 | 사용 형식 |
|---|---|
| branch 속성 사용 (다른 브랜치 의존성) | `"branch": "featureC"` 명시 |
| 가장 최근 promoted & released 버전 사용 | `"versionNumber": "2.1.0.RELEASED"` |
| 의존 패키지에 브랜치가 없는 경우 | `"branch": ""` (빈 문자열) |
| package alias 사용 | `"package": "pkgB@2.1.0-1-featureC"` |

```json
// 브랜치 속성으로 다른 브랜치 의존성 지정
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.3.0.LATEST",
    "branch": "featureC"
  }
]

// 의존 패키지에 브랜치가 없는 경우
"dependencies": [
  {
    "package": "pkgB",
    "versionNumber": "1.3.0.LATEST",
    "branch": ""
  }
]

// package alias 방식
"dependencies": [
  {
    "package": "pkgB@2.1.0-1-featureC"
  }
]
```

---

## 9. Specify Unpackaged Metadata or Apex Access for Package Version Creation Tests

### 9-1. Specify Unpackaged Metadata for Package Version Creation Tests

패키지에 포함되지 않지만 Apex 테스트 실행에 필요한 메타데이터 경로를 `sfdx-project.json`에 지정한다. 이 메타데이터는 패키지에 포함되지 않고 subscriber org에도 설치되지 않는다.

```json
"packageDirectories": [
  {
    "path": "force-app",
    "package": "TV_unl",
    "versionName": "ver 0.1",
    "versionNumber": "0.1.0.NEXT",
    "default": true,
    "unpackagedMetadata": {
      "path": "my-unpackaged-directory"
    }
  }
]
```

> `unpackagedMetadata` 속성은 패키지에 포함되지 않는 메타데이터를 위한 것이다. 동일한 메타데이터를 unpackaged directory와 packaged directory 양쪽에 포함할 수 없다.

### 9-2. Manage Apex Access for Package Version Creation Tests

Apex 테스트가 특정 permission set 또는 permission set license가 필요한 경우 `apexTestAccess`를 사용해 테스트 실행 컨텍스트 사용자에게 할당한다:

```json
"packageDirectories": [
  {
    "path": "force-app",
    "package": "TV_unl",
    "versionName": "ver 0.1",
    "versionNumber": "0.1.0.NEXT",
    "default": true,
    "unpackagedMetadata": {
      "path": "my-unpackaged-directory"
    },
    "apexTestAccess": {
      "permissionSets": [
        "Permission_Set_1",
        "Permission_Set_2"
      ],
      "permissionSetLicenses": [
        "SalesConsoleUser"
      ]
    }
  }
]
```

> User license 할당은 `runAs` Method를 사용해야 한다. User license는 sfdx-project.json 파일에서 할당 불가.

---

## 관련 노트
- [[2GP — Advanced Features Part 2]] — Package IDs·Aliases, Namespace Collisions, Remove Metadata, Delete, Transfer Dev Hub
- [[2GP — Develop]] — sf package create, sf package version create, Ancestor 지정, promote 전체 흐름
- [[2GP — Prepare to Distribute]] — AppExchange 배포 준비, Release Notes URL, postInstallUrl
- [[2GP Managed Package 개발 환경과 사전 준비]] — Package Ancestry 개념, Dependency Matrix
- [[sfdx-project.json 레퍼런스]] — sfdx-project.json 전체 파라미터
- [[Unlocked Package 생성과 설정]] — Unlocked Package에서의 Keywords·Dependencies 비교
