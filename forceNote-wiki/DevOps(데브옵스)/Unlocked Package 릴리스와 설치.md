---
tags: [devops, salesforce-dx, unlocked-package, push-upgrade, package-install, package-uninstall, package-transfer, migrate-metadata]
source: sfdx_dev.pdf (Salesforce DX Developer Guide v67.0)
created: 2026-05-23
aliases: [push upgrade, package install, sf package install, sf package uninstall, package transfer, 패키지 설치, 패키지 업그레이드, 푸시 업그레이드]
---

# Unlocked Package 릴리스와 설치

> Push Upgrade 스케줄·목록·보고·중단·오류 쿼리, CLI/URL 패키지 설치, 업그레이드 타입, 의존성 설치 스크립트, Deprecated Metadata 마이그레이션, 언인스톨, 다른 Dev Hub로 전송 전수

---

## Push a Package Upgrade for Unlocked Packages

Push Upgrade는 Org 어드민이 직접 업그레이드를 수행하지 않아도 설치된 Org를 자동으로 업그레이드한다. 핫픽스 배포 등에 유용하다.

| 패키지 유형 | CLI Push Upgrade | API Push Upgrade | UI Push Upgrade |
|---|---|---|---|
| 2GP | ✅ | ✅ | ❌ |
| 1GP | ❌ | ✅ | ✅ |
| Unlocked | ✅ | ✅ | ❌ |

Unlocked Package의 Push Upgrade는 기본적으로 활성화되어 있다.

### Push Upgrade 고려사항

- 새 기능, 변경된 기능, 기능 제거 모두 Push Upgrade에 포함 가능
- Push Upgrade 설치 시 패키지의 Apex가 컴파일됨
- 패키지 버전이 비밀번호를 요구하더라도 Push Upgrade 사용 가능
- Push Upgrade 필요 권한: `Create and Update Second-Generation Packages`
- 2GP의 Push Upgrade 활성화: Salesforce Partner Support에 케이스 로그

### Push Upgrade 후 Profile 설정 주의

Push Upgrade 시 Apex 클래스 및 Field-Level Security 관련 일부 Profile 설정이 System Admin 프로파일에 자동 적용되지 않는다. 고객에게 Push Upgrade 후 Profile 설정을 검토·업데이트하도록 안내해야 한다.

---

## Schedule a Push Upgrade Using CLI

### 1. 업그레이드 대상 Org 조회

Dev Hub Org 인증 후 패키지 소유 확인:
```bash
sf org login web --set-default-dev-hub
sf package list --verbose
```

**Query Example 1 — 특정 패키지가 설치된 모든 Org 목록:**
```bash
sf data query \
  --target-org myDevHub \
  --query "SELECT OrgKey, OrgName, OrgType, InstanceName, MetadataPackageId, MetadataPackageVersionId FROM PackageSubscriber WHERE MetadataPackageId = '033xxxxxxxxxxxxxxx'" \
  --result-format json
```

**Query Example 2 — 특정 버전이 설치된 Org를 CSV로 저장:**
```bash
sf data query \
  --target-org myDevHub \
  --query "SELECT OrgKey, OrgName, OrgType FROM PackageSubscriber WHERE MetadataPackageVersionId = '04t…'" \
  --result-format csv
```

CSV 파일 활용 시 첫 줄(헤더)을 제거하고 Org ID만 남겨야 함.

**Query Example 3 — 특정 버전 미만이 설치된 Org 목록 (2단계 쿼리):**

1단계: 2.7 미만 버전의 04t ID 목록 추출:
```bash
sf data query \
  --target-org admin@packaging.com \
  --use-tooling-api \
  --query "SELECT SubscriberPackageVersionId FROM Package2Version WHERE Package2Id = '0HoPACKAGEIDxxxx' AND (MajorVersion < 2 OR (MajorVersion = 2 AND MinorVersion < 7))"
```

2단계: 해당 버전이 설치된 Org 조회:
```bash
sf data query \
  --target-org myDevHub \
  --query "SELECT OrgKey FROM PackageSubscriber WHERE MetadataPackageVersionId IN ('04tID1', '04tID2', '04tID_etc')" \
  --result-format csv > out.txt
```

### 2. Push Upgrade 스케줄

```bash
# 지정 시간에 시작, Org ID 목록 직접 지정
sf package push-upgrade schedule \
  --package 04txyz \
  --start-time "2024-12-06T21:00:00" \
  --org-list 00DAxx,00DBx

# 가능한 빨리 시작, CSV 파일로 Org 목록 지정
sf package push-upgrade schedule \
  --package 04txyz \
  --org-file upgrade-orgs.csv
```

- `--start-time` 미지정 시 리소스 가용 즉시 시작
- 시작 시간 지정 시 오프피크 시간 권장
- 시간은 UTC 기준으로 지정

### 3. Push Upgrade 현황 조회

```bash
# 패키지의 모든 Push Upgrade 요청 목록
sf package push-upgrade list --package 033xyz --target-dev-hub myDevHub

# 최근 30일 이내 스케줄된 요청
sf package push-upgrade list --package 033xyz --scheduled-last-days 30 --target-dev-hub myDevHub

# Failed 상태 요청
sf package push-upgrade list --package 033xyz --status Failed

# Succeeded 상태 요청
sf package push-upgrade list --package 033xyz --status Succeeded

# 특정 요청 상세 보고서
sf package push-upgrade report --push-request-id 0DVxyz --target-dev-hub myDevHub
```

`package push-upgrade list` 표시 필드:
- push request ID, package version ID, package version number, status, scheduled start date/time, 예약된 Org 수, 성공 Org 수, 실패 Org 수, 생성 date/time

`package push-upgrade report`는 오류 세부 정보를 추가로 제공한다.

### 4. Push Upgrade 취소

요청 상태가 Created 또는 Pending인 경우에만 취소 가능:
```bash
sf package push-upgrade abort --push-request-id 0DVxyz
```

### 5. Push Upgrade 오류 메시지 조회

```bash
sf data query \
  --query "SELECT Id, PackagePushJobId, PackagePushJob.SubscriberOrganizationKey, ErrorDetails, ErrorMessage, ErrorSeverity, ErrorTitle, ErrorType FROM PackagePushError WHERE PackagePushJob.PackagePushRequestId='$PUSH_REQUEST_ID'" \
  --target-org myDevHub
```

---

## Install Packages with the CLI

```bash
# 설치 가능한 버전 목록 확인
sf package version list

# 패키지 설치 (패키지 alias 또는 04t ID 지정)
sf package install --package "Expense Manager@1.2.0-12" --target-org jdoe@example.com

# 기본 사용자 설정된 경우
sf package install --package "Expense Manager@1.2.0-12"

# 모든 사용자에게 접근 권한 부여
sf package install --package "Expense Manager@1.2.0-12" --security-type AllUsers
```

- 기본적으로 어드민에게만 패키지 접근 권한 부여

### 설치 타임아웃 제어

```bash
sf package install --package "Expense Manager@1.2.0-12" --publish-wait 6 --wait 10
```

| 파라미터 | 기본값 | 설명 |
|---|---|---|
| `--publish-wait` | 0 | 패키지 버전이 대상 Org에서 사용 가능해질 때까지 기다리는 최대 시간(분). 0이면 즉시 실패(이미 available한 경우 제외) |
| `--wait` | 0 | 패키지가 available 후 설치 완료까지 기다리는 최대 시간(분). 시간 종료 후 CLI 완료되지만 설치는 계속 진행 |

- `--wait` 타이머는 `--publish-wait` 완료 후 시작
- `--publish-wait` 타임아웃 시 `--wait` 타이머 시작 안 됨
- 설치 진행 상태 확인: `sf package install report`

예시:
- `--publish-wait 3 --wait 10`: 패키지 available에 5분 걸리면 3분 후 설치 중단
- `--publish-wait 6 --wait 10`: 패키지 5분 후 available → 10분 wait 시작 → 10분 후 CLI 완료 → 1분 후 설치 완료

---

## Install Unlocked Packages from a URL

subscriber package ID(04t)를 Dev Hub URL에 추가해 설치 URL 생성:
```
https://MyDomainName.lightning.force.com/packagingSetupUI/ipLanding.app?apvId=04tB00000009oZ3JBI
```

URL 소지자 + 유효한 Salesforce Org 로그인이 있으면 누구나 설치 가능.

브라우저 설치 절차:
1. 설치 URL을 브라우저에 입력
2. Salesforce Org 로그인 정보 입력 후 Login 클릭
3. (패키지가 Installation Key로 보호된 경우) 설치 키 입력
4. Install 클릭 → 완료 확인 메시지

---

## Upgrade a Version of an Unlocked Package

기존 버전이 설치된 Org에 새 버전을 설치하면 업그레이드가 발생한다.

```bash
sf package install --package 04t... --target-org me@example.com
```

업그레이드 시 메타데이터 변경 동작:
- **새 버전에서 추가된 메타데이터** → 업그레이드 중 설치
- **동일 API명 컴포넌트** → 대상 Org 컴포넌트를 새 버전으로 덮어씀
- **대상 Org에서 삭제된 컴포넌트** → 업그레이드 중 재생성
- **새 버전에서 제거된 메타데이터** → 대상 Org에서도 제거

### Apex 컴파일 옵션

```bash
sf package install --package 04t... --apex-compile all     # 모든 Apex 컴파일
sf package install --package 04t... --apex-compile package # 패키지 Apex만 컴파일
```

- 프로덕션 Org 또는 `Apex Compile on Deploy` 활성화 Org: `--apex-compile package` 지정해도 설치/업그레이드 완료 후 모든 Apex 컴파일

### Upgrade Type 지정 (API v45.0+)

```bash
sf package install --package 04t... -t Delete       # 하드 삭제 컴포넌트 삭제
sf package install --package 04t... -t DeprecateOnly # 모두 deprecated 처리
sf package install --package 04t... -t Mixed         # 기본값
```

| Upgrade Type | 동작 |
|---|---|
| Delete | 의존성 없는 제거된 컴포넌트 삭제 (Custom Object·Custom Field 제외) |
| DeprecateOnly | 제거된 컴포넌트를 deprecated 처리, 대상 Org에 남아 있음. 메타데이터를 다른 패키지로 마이그레이션할 때 유용 |
| Mixed (기본) | 일부 컴포넌트는 삭제, 일부는 deprecated |

낮은 버전 위에 낮은 버전을 설치하는 것도 가능하지만 주의 필요 (롤백은 불가).

---

## Sample Script for Installing Unlocked Packages with Dependencies

의존성이 있는 패키지를 올바른 순서로 설치하는 스크립트:

```bash
#!/bin/bash

# 오류 또는 파이프라인 실패 시 스크립트 중단
set -e

# 패키지 버전 ID (04t로 시작)
PACKAGE=04tB0000000NmnHIAS

# 구독자 Org 사용자명
USER_NAME=test-bvdfz3m9tqdf@example.com

# 패키지 설치 타임아웃 (분)
WAIT_TIME=15

echo "Retrieving dependencies for package Id: "$PACKAGE

# 패키지 의존성 JSON 조회
RESULT_JSON=`sf data query -u $USER_NAME -t -q "SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='$PACKAGE'" --json`

# Python으로 JSON 파싱해 의존성 목록 추출
DEPENDENCIES=`echo $RESULT_JSON | python -c 'import sys, json; print json.load(sys.stdin)["result"]["records"][0]["Dependencies"]'`

# 의존성이 있으면 순서대로 설치
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

# 의존성 처리 후 지정된 패키지 설치
echo "Installing package: "$PACKAGE
sf package install --package $PACKAGE -u $USER_NAME -w $WAIT_TIME --publish-wait 10

exit 0;
```

---

## Migrate Deprecated Metadata from Unlocked Packages

패키지를 리팩토링하면서 메타데이터를 한 Unlocked Package에서 다른 Unlocked Package로 이동 가능.

Package A → Package B로 이동 절차:
1. Package A에서 이동할 메타데이터 식별
2. Package A에서 메타데이터 제거 → 버전 생성 → 패키지 릴리스
3. Package B에 메타데이터 추가 → 버전 생성 → 패키지 릴리스
4. 프로덕션 Org에서 Package A 업그레이드
5. 프로덕션 Org에서 Package B 설치

---

## Uninstall an Unlocked Package

```bash
# CLI로 언인스톨
sf package uninstall --package "Expense Manager@2.3.0-5"

# 브라우저로 Org 열기
sf org open -u me@my.org
```

브라우저 언인스톨 절차:
1. Setup → Installed Packages 검색 → Installed Packages 선택
2. 언인스톨할 패키지 옆 Uninstall 클릭
3. 데이터 저장·내보내기 여부 선택
4. "Yes, I want to uninstall" 선택 → Uninstall 클릭

### 언인스톨 시 주의사항

- Custom Object가 포함된 패키지 언인스톨 시 Custom Field, Validation Rule, Custom Button, Link, Workflow Rule, Approval Process 모두 삭제
- 아래 경우 언인스톨 불가:
  - 패키지 외부 컴포넌트가 패키지 내 컴포넌트를 참조하는 경우
  - 다른 패키지의 Custom Object 컴포넌트가 이 패키지의 컴포넌트를 참조하는 경우
  - 설치 후 추가된 파일이 포함된 폴더가 있는 경우
  - 설치 후 추가된 이메일 템플릿에 사용되는 레터헤드가 있는 경우
  - Einstein Prediction Builder 또는 Case Classification이 패키지의 Custom Field를 참조하는 경우
  - 패키지가 모든 활성 비즈니스·개인 계정 레코드 유형을 삭제하는 경우
  - 백그라운드 작업이 패키지의 필드(예: roll-up summary 필드)를 업데이트 중인 경우 → 완료 후 재시도

---

## Transfer an Unlocked Package to a Different Dev Hub

Unlocked Package의 소유권을 한 Dev Hub Org에서 다른 Dev Hub Org로 이전 가능.

### 이전 요청

Salesforce Customer Support에 케이스 로그:
- Subject: `Unlocked Package Transfer to a different Dev Hub`
- Description에 포함할 내용:
  - 이전 패키지의 Subscriber Package ID (033으로 시작) — `sf package list --verbose`로 확인
  - 소스 Dev Hub Org ID
  - 대상 Dev Hub Org ID (Developer Edition·Trial Org 불가)
  - (선택) 패키지 Namespace (No-namespace 패키지는 생략)
  - 준비 단계 완료 확인

패키지가 여러 개인 경우 패키지별 별도 케이스 필요.

정부 클라우드 ↔ 일반 클라우드 간 이전 불가.

### 이전 전 준비사항

- Namespace가 있는 패키지: 이전 전 Namespace를 소스·대상 Dev Hub 양쪽에 연결
- 이전 시작 전 모든 Push Upgrade·버전 생성 프로세스 완료
- 불필요한 패키지 버전 삭제
- 오류 알림 사용자 초기화: `sf package update --error-notification-username=`

### 이전 후 Package ID 영향

| ID 유형 | 시작 문자 | 이전 후 |
|---|---|---|
| Subscriber Package ID | 033 | 변경 없음 |
| Subscriber Package Version ID | 04t | 변경 없음 |
| Package ID | 0Ho | 새 ID 부여 |

### 이전 후 sfdx-project.json 업데이트 (소스 측)

```json
// 의존성에 04t ID로 명시적 지정
"dependencies": [
  {
    "package": "04tB0000000UzH5IAK"
  }
]

// 또는 패키지 alias 사용
"dependencies": [
  {
    "package": "pkgA2.0.0-1"
  }
]
"packageAliases": {
  "pkgA2.0.0-1": "04tB0000000UzH5IAK"
}
```

### 이전되는 정보 vs. 이전되지 않는 정보

이전됨:
- 패키지 이름, Namespace, 유형, ID (0Ho는 새 ID)
- 패키지 버전 정보 전체 (`sf package version list` / `sf package version report` 표시 정보)

이전 안 됨:
- Push Upgrade 이력
- 패키지 버전 생성 요청
- Apex 오류 알림 수신 Dev Hub 사용자 정보
- 이전 전 삭제된 패키지 버전

---

## Take Ownership of a Transferred Package

다른 Dev Hub Org에서 이전받은 Unlocked Package 소유권 취득.

### 수신 준비

Namespace가 있는 패키지: 내 Dev Hub Org에 해당 Namespace를 연결.

### 이전 완료 후

```bash
# 이전된 패키지가 내 Dev Hub에 연결되었는지 확인
sf package list
```

### sfdx-project.json 업데이트 (수신 측)

1. 이전받은 패키지 관련 `sfdx-project.json` 내용 검토
2. Scratch Org Definition File 검토
3. `packageDirectories`에서 이전받지 않은 패키지 참조 제거
4. `packageAliases`에서 이전받지 않은 alias 제거
5. 이전받은 패키지 alias를 새 0Ho ID로 업데이트

### 새 패키지 버전 생성 전 준비

```bash
# 오류 알림 사용자 설정
sf package update --error-notification-username me@devhub.org
```

---

## 관련 노트

- [[Unlocked Package 개념과 준비]]
- [[Unlocked Package 생성과 설정]]
- [[Unlocked Package 개발과 버전]]
- [[CI 통합 전수 (CircleCI·Jenkins·Travis)]]
- [[DX 인증 방식]]
- [[Scratch Org 배포·유저·에러코드]]
- [[2GP — Push Upgrade]] — 2GP managed package Push Upgrade 전용 CLI·SOAP API·Customized Push Upgrade·Best Practices
- [[2GP — Install · Uninstall]] — managed 2GP 설치·업그레이드·제거 전수 (비교: Unlocked과 동일 sf package install 명령 사용)
