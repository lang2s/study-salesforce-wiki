---
tags: [DevOps, Packaging, 2GP, ManagedPackage, BestPractices, 모범사례, ISV, AppExchange]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.407
created: 2026-05-24
aliases: [2GP Best Practices, Best Practices for Second-Generation Managed Packages, 2GP 모범 사례, 2GP 개발 권장 사항, Package IDs Aliases, --tag packaging]
---

# 2GP — Best Practices (모범 사례)

> Salesforce가 권장하는 Second-Generation Managed Package 개발·버전 관리·배포 모범 사례 전수. p.407 전체 내용 기반.

---

## 1. Best Practices for Second-Generation Managed Packages

Salesforce가 2GP managed packages 작업 시 따르도록 권장하는 모범 사례:

### 1-1. Dev Hub 사용 원칙

- **하나의 Dev Hub만 사용**하고, 파트너 비즈니스 org에서 Dev Hub를 활성화한다.
- `sf package create` 명령을 실행한 Dev Hub org가 패키지의 **owner**가 된다.  
  Dev Hub org가 만료되거나 삭제되면 해당 패키지는 더 이상 작동하지 않는다.

### 1-2. 버전 태그(--tag) 사용

- `sf package version create`와 `sf package version update` 명령을 사용할 때는 **`--tag` 옵션을 항상 포함**한다.  
  이 옵션은 버전 관리 시스템(VCS)의 태그와 특정 패키지 버전을 동기화하는 데 도움이 된다.

```bash
# 버전 생성 시 git commit hash를 tag로 지정
sf package version create \
  --package "MyManagedPackage" \
  --installation-key "" \
  --code-coverage \
  --tag "$(git rev-parse HEAD)"

# 버전 업데이트 시에도 tag 포함
sf package version update \
  --package "MyManagedPackage@1.0.0.1" \
  --tag "$(git rev-parse HEAD)"
```

### 1-3. 사용자 친화적 Alias 생성

- 패키징 ID에 대한 **사용자 친화적 Alias**를 만들고, Salesforce DX project file(`sfdx-project.json`)에 해당 Alias를 포함한다.
- CLI 패키징 명령을 실행할 때도 Alias를 활용한다.
- 자세한 내용: `2GP — Advanced Features Part 2` → Package IDs and Aliases 섹션 참조.

```json
// sfdx-project.json — packageAliases 예시 (구조 예시 — 실제 동작 설정 아님)
{
  "packageAliases": {
    "MyManagedPackage": "0Ho...",
    "MyManagedPackage@1.0.0-1": "04t..."
  }
}
```

### 1-4. non-GA 컴포넌트 주의

- 패키지에 컴포넌트를 추가할 때 해당 컴포넌트의 제품 문서를 확인해 **GA(Generally Available) 상태인지 반드시 점검**한다.
- non-GA 컴포넌트를 포함하면 제한 사항이 있고 GA 보장이 되지 않는다.
- **특히 위험한 경우:** 컴포넌트를 managed package에서 제거할 수 없는 경우(non-removable component).

### 1-5. LMA(License Management App) 연동 요약

p.407 하단의 LMA 기능별 접근 요약 표:

| I need to... | Permissions | For details, see... |
|---|---|---|
| Configure the LMA | System Admin profile | LMA 시작 가이드 |
| Bill subscribers or monitor license expiration | Object Permissions: Read | Lead and License Records in the LMA |
| Convert trial subscriptions into paying customers | Object Permissions: Edit | Modify a License Record |
| Customize the LMO | Object Permissions: Edit | Extending the LMA |
| Provision licenses to a subscriber | Object Permissions: Edit | Modify a License Record |
| Support subscribers with technical issues | Various permissions (see Assign Permissions to the Subscriber Support Console for details) | Troubleshoot Subscriber Issues |

> Note: LMA는 **영어 전용**이다. Salesforce 파트너 프로그램에 가입한 파트너만 이용 가능. 파트너 자격 관련: https://partners.salesforce.com

---

## 관련 노트

- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로 10단계, Manageability Rules, Supported Components
- [[2GP — Develop]] — sf package version create, Package Ancestor, 버전 번호 가이드
- [[2GP — Prepare to Distribute]] — beta → released 승격, 코드 커버리지 75%, AppExchange 등록
- [[2GP — Push Upgrade]] — subscriber org 강제 업그레이드 Best Practices
- [[2GP — Advanced Features Part 1]] — Package Ancestors, Dependencies, Keywords
- [[2GP — Advanced Features Part 2]] — Package IDs Aliases (사용자 친화적 Alias 생성)
- [[2GP — LMA Part 1 Get Started]] — License Management App 설치·권한·레코드
- [[2GP — Feature Management App]] — Feature Parameters 설정·운영
- [[2GP — App Analytics Part 2: Best Practices & Query Strategy]] — App Analytics 쿼리 Best Practices·파트너 규모별 전략
- [[Metadata Coverage 보고서]] — 컴포넌트별 지원 채널 확인 (GA 여부 판단)
