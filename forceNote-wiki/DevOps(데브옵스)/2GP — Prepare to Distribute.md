---
tags: [DevOps, Packaging, 2GP, ManagedPackage, PrepareToDistribute, CodeCoverage, InstallationKey, PackagePromote, AppExchange, ReleaseNotes, PublishApp, 배포준비, 코드커버리지, 설치키, 릴리즈, 앱익스체인지]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.359-363
created: 2026-05-24
aliases: [2GP Prepare to Distribute, Prepare to Distribute Second-Generation Managed Package, 2GP 배포 준비, sf package version promote, Code Coverage 75%, Installation Key 2GP, AppExchange 등록 2GP, Release a Second-Generation Managed Package, Share Release Notes 2GP, postInstallUrl releaseNotesUrl, Publishing App on AppExchange, Register Managed 2GP Package, Recommend Package Version]
---

# 2GP — Prepare to Distribute (배포 준비 · 릴리즈 · AppExchange 등록)

> beta 버전으로 생성된 2GP managed package version을 managed-released 상태로 승격하고 AppExchange에 등록하기 위한 전 단계를 다룬다. 코드 커버리지 75% 요건, Installation Key 설정, `sf package version promote` 명령, Release Notes URL / Post-Install URL 지정, Dev Hub ↔ AppExchange 파트너 콘솔 연결 절차를 전수 정리한다.

---

## 1. Prepare to Distribute — 섹션 개요

"Prepare to Distribute Your Second-Generation Managed Package" 섹션은 아래 하위 주제로 구성된다.

| 하위 주제 | 내용 |
|---|---|
| Code Coverage for Second-Generation Managed Packages | beta → released 승격 전 75% 코드 커버리지 요건 |
| Package Installation Key for Second-Generation Managed Packages | `--installation-key` 설정 · 변경 · bypass |
| Release a Second-Generation Managed Package | `sf package version promote` — beta → managed-released |
| Share Release Notes and Post-Install Instructions | `postInstallUrl` · `releaseNotesUrl` sfdx-project.json 설정 |
| Publishing Your App on AppExchange | Dev Hub ↔ 파트너 콘솔 연결 · 패키지 등록 · LMO |
| Recommend a Specific Package Version to Your Subscribers | `sf package update --recommended-version-id` |

---

## 2. Code Coverage for Second-Generation Managed Packages

beta 버전을 managed-released 상태로 promote하려면 **Apex 코드 커버리지 최소 75%** 를 충족해야 한다. 패키지 내 모든 Apex Trigger에도 테스트 커버리지가 필요하다.

### 2-1. 코드 커버리지 계산 방법

```bash
# --code-coverage 파라미터를 포함해 패키지 버전을 생성한다
sf package version create \
  --package "Expense Manager" \
  --code-coverage \
  --installation-key "your-key" \
  --wait 10
```

- 코드 커버리지를 포함하면 패키지 버전 생성 시간이 더 오래 걸린다.
- beta 버전은 코드 커버리지 없이 생성할 수 있지만, 커버리지 없이 생성된 버전은 promote할 수 없다.
- `--skip-validation` 파라미터를 사용하면 코드 커버리지가 계산되지 않는다. 해당 버전은 promote 불가.

### 2-2. 코드 커버리지 결과 확인

```bash
# --verbose 옵션으로 코드 커버리지 정보 확인
sf package version list --verbose

# 특정 패키지 버전의 상세 보고서
sf package version report --package "Expense Manager@1.3.0-7"
```

### 2-3. promote 실패 조건

promote 시도 시 아래 중 하나라도 해당하면 실패한다:
- 해당 버전이 `--code-coverage` 없이 생성된 경우
- 코드 커버리지가 75% 미만인 경우

---

## 3. Package Installation Key for Second-Generation Managed Packages

Installation Key는 패키지 메타데이터 보안의 첫 번째 단계다. 올바른 키가 제공될 때까지 패키지 이름·컴포넌트 등 어떠한 정보도 노출되지 않는다.

- 패키지 생성자는 승인된 구독자에게 키를 제공한다.
- 구독자는 CLI 또는 브라우저로 설치 시 키를 입력한다.

### 3-1. Installation Key 설정 (버전 생성 시)

```bash
# 패키지 버전 생성 시 Installation Key 지정
sf package version create \
  --package "Expense Manager" \
  --installation-key "JSB7s8vXU93fI"
```

### 3-2. 기존 버전의 Installation Key 변경

```bash
# 기존 패키지 버전의 Installation Key를 업데이트한다
sf package version update \
  --package "Expense Manager@1.2.0-4" \
  --installation-key "HIF83kS8kS7C"
```

> **보안 활용:** promote를 되돌릴 수 없는 상황에서 배포를 막아야 할 경우, `sf package version update`로 Installation Key를 복잡하고 추측하기 어려운 값으로 변경해 inadvertent 설치를 방지한다.

### 3-3. Installation Key 없이 버전 생성 (bypass)

패키지 메타데이터 보호가 필요하지 않은 경우, Installation Key 없이 버전을 생성할 수 있다.

```bash
# Installation Key를 요구하지 않는 버전 생성
sf package version create \
  --package "Expense Manager" \
  --installation-key-bypass
```

### 3-4. Installation Key 요건 확인

```bash
# 특정 버전이 Installation Key를 요구하는지 확인
sf package version list
```

### 3-5. Installation Key를 사용한 패키지 설치

```bash
# 설치 시 Installation Key 제공
sf package install \
  --package "Expense Manager" \
  --installation-key "JSB7s8vXU93fI"
```

---

## 4. Release a Second-Generation Managed Package

새로 생성된 모든 패키지 버전은 **beta** 상태다. beta 버전은 scratch org와 sandbox에만 설치할 수 있다. AppExchange 등록 및 customer org 설치는 managed-released 버전만 가능하다.

### 4-1. promote 전 사전 조건

| 조건 | 내용 |
|---|---|
| 권한 | Dev Hub org에서 "Promote a package version to released" user permission 필요. Permission Set을 만들어 적절한 profile에 할당 권장 |
| 코드 커버리지 | 75% 이상 (`--code-coverage` 포함해 생성된 버전) |
| 버전당 한 번 | 각 minor 버전 번호(예: 2.3)에서 하나의 beta 버전만 promote 가능 |

### 4-2. sf package version promote

```bash
# beta 버전을 managed-released 상태로 승격
sf package version promote --package "Expense Manager@1.3.0-7"
```

성공 시 확인 메시지:
```
Successfully promoted the package version, ID: 04tB0000000719qIAA to released.
```

### 4-3. promote 후 결과 확인

```bash
# 패키지 버전 상세 보고서로 Released 속성 확인
sf package version report --package "Expense Manager@1.3.0.7"
```

예시 출력:

```
=== Package Version
NAME                          VALUE
──────────────────────────── ───────────────────
Name                          ver 1.0
Alias                         Expense Manager-1.0.0.5
Package Version Id            05iB0000000CaahIAC
Package Id                    0HoB0000000CabmKAC
Subscriber Package Version Id 04tB0000000NPbBIAW
Version                       1.0.0.5
Description                   update version
Branch
Tag                           git commit id 08dcfsdf
Released                      true
Created Date                  2021-05-08 09:48
Installation URL              https://login.salesforce.com/packaging/installPackage.apexp?p0=04tB0000000NPbBIAW
```

`Released: true`를 확인한다.

### 4-4. promote 제약사항

- promote는 **되돌릴 수 없다** (beta 상태로 역전 불가).
- 배포를 원하지 않게 된 경우 → `sf package version update`로 Installation Key를 추측 불가 값으로 변경.
- 각 minor 버전에서 promote는 **단 한 번**. 버전 2.3 promote 후, 새 개발은 2.4부터 시작.

---

## 5. Share Release Notes and Post-Install Instructions for Second-Generation Managed Packages

릴리즈된 2GP managed package의 변경 내용을 구독자와 공유하는 방법.

- **releaseNotesUrl**: 구독자 org의 Package Detail 페이지에 표시. Installed Packages 페이지에도 표시.
- **postInstallUrl**: 패키지 설치 또는 업그레이드 성공 후 구독자가 리디렉션되는 URL.
- Installation URL로 설치하는 구독자에게는 패키지 설치 페이지에 release notes 링크가 표시된다.

### 5-1. sfdx-project.json에서 설정

```json
// 구조 예시 — 실제 동작 설정 아님
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
{
  "namespace": "db_exp_manager",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "47.0",
  "packageAliases": {
    "Expenser Schema": "0HoB00000004CzHKAU",
    "Expenser Schema@0.1.0-1": "04tB0000000719qIAA"
  }
}
```

### 5-2. sf package version create CLI 파라미터

```bash
# CLI 파라미터는 sfdx-project.json 설정을 override한다
sf package version create \
  --package "Expense Schema" \
  --post-install-url "https://expenser.com/post-install-instructions.html" \
  --release-notes-url "https://expenser.com/winter-2020-release-notes.html" \
  --installation-key "your-key"
```

> CLI 파라미터(`--post-install-url`, `--release-notes-url`)는 `sfdx-project.json`에 지정된 URL을 override한다.

---

## 6. Publishing Your App on AppExchange

1GP managed package와 달리, 2GP managed package는 Dev Hub org를 AppExchange 파트너 콘솔에 연결하면 **released된 모든 버전이 파트너 콘솔에 자동으로 표시**된다.

AppExchange에 앱을 등록하려면 AppExchange Security Review를 통과해야 한다.

### 6-1. Dev Hub를 AppExchange 파트너 콘솔에 연결

```
// 구조 예시 — 실제 동작 코드 아님
1. Salesforce Partner Community에 로그인
2. Publishing 탭 선택
3. Technologies 클릭
4. Org 클릭
5. Connect Technology 클릭 후 Org 선택
6. Connect Org 클릭 후 Allow 클릭
7. Dev Hub org의 로그인 크레덴셜 입력
```

### 6-2. Managed 2GP Package 등록

```
// 구조 예시 — 실제 동작 코드 아님
1. Solutions 탭에서 등록할 패키지 버전 찾기
2. Register Package 클릭 (패키지를 License Management App에 연결)
3. 모달 창에서 해당 패키지와 연결된 Dev Hub org 로그인 크레덴셜 입력
4. 기본 라이선스 동작 설정 (trial 기간, 라이선스에 포함된 시트 수) 후 Save
```

### 6-3. License Management Org (LMO) 고려사항

- 동일 namespace를 공유하는 패키지는 동일한 LMO에 연결하거나, 각각 다른 LMO에 연결할 수 있다.

---

## 7. Recommend a Specific Package Version to Your Subscribers

구독자가 특정 released 버전으로 업그레이드하도록 권장할 수 있다. 권장 버전이 설정되면 구독자의 org Installed Packages 페이지에 "Upgrade to Recommended Version" 옵션이 표시된다.

### 7-1. 권장 버전 설정

```bash
# sf package update 명령으로 권장 버전 설정
sf package update \
  --package 0Ho.. \
  --target-dev-hub devhub@example.com \
  --recommended-version-id PackageA@1.0
```

### 7-2. 권장 버전 요건 및 고려사항

| 항목 | 내용 |
|---|---|
| 수량 제한 | 패키지당 권장 버전은 **하나** |
| 버전 조건 | released 버전만 설정 가능 |
| 최신 버전 | 최신 released 버전이 아니어도 무방 |
| Ancestry 요건 | 새 권장 버전은 이전 권장 버전의 **descendant**여야 함. Ancestry 공유 불가 시 오류 발생 |
| Ancestry 우회 | `--skip-ancestor-check` 플래그 사용 가능 |

---

## 8. Prepare to Distribute 전체 체크리스트

| 단계 | 작업 | 명령 |
|---|---|---|
| 1 | 코드 커버리지 75% 충족 확인 | `sf package version create --code-coverage` 후 `sf package version list --verbose` |
| 2 | Installation Key 설정 | `sf package version create --installation-key "..."` |
| 3 | Release Notes / Post-Install URL 지정 | `sfdx-project.json`의 `releaseNotesUrl` · `postInstallUrl` |
| 4 | Promote 권한 확인 | Dev Hub org에서 "Promote a package version to released" permission 확인 |
| 5 | Beta 버전을 released로 승격 | `sf package version promote --package "..."` |
| 6 | 승격 결과 확인 | `sf package version report --package "..."` (`Released: true`) |
| 7 | Dev Hub ↔ AppExchange 파트너 콘솔 연결 | Salesforce Partner Community에서 Org 연결 |
| 8 | 패키지 등록 및 LMO 설정 | Solutions 탭에서 Register Package |

---

## 관련 노트

- [[2GP — Develop]] — sf package version create, Package Ancestor, beta 버전 생성
- [[2GP — Install · Uninstall]] — sf package install, PostInstallScript, InstallHandler, 의존성 설치 스크립트
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로 10단계, Manageability Rules, Supported Components
- [[Unlocked Package 개발과 버전]] — Unlocked Package의 코드 커버리지 · sf package version promote
- [[2GP — Push Upgrade]] — beta → released 이후 subscriber org에 Push Upgrade 스케줄·관리·Best Practices
- [[2GP — Advanced Features Part 1]] — Package Ancestors, Dependencies, Keywords, Advanced Config Parameters
- [[2GP — Advanced Features Part 2]] — Package IDs, Namespace Collisions, Remove Metadata, Transfer Dev Hub
- [[2GP — Best Practices]] — 2GP 개발 모범 사례 (Dev Hub owner·--tag·Alias·non-GA 주의)
- [[2GP — LMA Part 1 Get Started]] — License Management App 설치·권한·Lead·License 레코드 관리
- [[2GP — LMA Part 2 Troubleshoot]] — LMA 트러블슈팅·구독자 지원·ISV Customer Debugger
