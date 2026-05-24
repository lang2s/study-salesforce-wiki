---
tags: [DevOps, Packaging, 2GP, ManagedPackage, ScratchOrg, Snapshot, OrgShape, Agentforce, Allocations, 매니지드패키지, 스크래치오그, 스냅샷]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.15-23
created: 2026-05-23
aliases: [2GP Scratch Org 워크플로, managed 2GP scratch org, namespaced scratch org, no-namespace scratch org, package scratch org, ancestor seeding, Scratch Org Snapshot for Packages, Org Shape for Packages, Agentforce Scratch Org, Partner Scratch Org Editions, Scratch Org Allocations, Package Version Creation Limits, ActiveScratchOrg, ScratchOrgInfo, Einstein1AIPlatform]
---

# 2GP Managed Package — Scratch Org 워크플로

> managed 2GP 패키지 개발에서 scratch org를 어떻게 쓰는가. **Development(namespaced) vs Testing(no-namespace) 두 모드**, **Definition File vs Org Shape 선택**, **Snapshot으로 build 시간 단축(+managed promote 제약)**, **Agentforce·Data Cloud 활성화**, **PBO 할당량**, **Partner edition 지원**. 일반 scratch org 사용은 [[Scratch Org 생성과 정의 파일]] 참조.

---

## 1. 개요 — 패키지 개발에서 scratch org가 하는 일

scratch org는 **개발·자동화용 임시 Salesforce org**다. managed 2GP에서는 두 가지 핵심 역할을 한다.

| 역할 | 목적 | scratch org 형태 |
|---|---|---|
| **개발(Develop)** | 패키지에 들어갈 메타데이터를 만들고 수정 | **namespaced** — 메타데이터에 namespace prefix가 자동으로 붙음 |
| **테스트(Test)** | 만든 패키지 버전을 설치해서 동작 검증 | **no-namespace** — 구독자 org와 동일한 조건 시뮬레이션 |

추가 활용: **CI 자동화** — "패키지 버전 생성 → scratch org 만들기 → 그 안에 설치 → Apex 테스트 → 결과를 release manager에게 이메일" 같은 스크립트.

### 1-1. 기존 위키 페이지와의 분업

| 페이지 | 다루는 범위 |
|---|---|
| [[Scratch Org 생성과 정의 파일]] | scratch org의 일반 개념·`project-scratch-def.json` 옵션 전수·features 목록 |
| [[Scratch Org Settings 레퍼런스]] | scratch org settings 블록의 전수 옵션 |
| [[Scratch Org 배포·유저·에러코드]] | deploy/retrieve·user 관리·error code |
| [[Org Shape와 Snapshot]] | Org Shape 생성·snapshot의 일반 동작 |
| **이 페이지** | **패키지 개발 맥락**의 scratch org — namespaced/no-namespace 구분, ancestor seeding, snapshot의 managed promote 제약, Agentforce·Data Cloud 활성화, partner 할당량 |

---

## 2. Development vs Testing — 두 가지 사용 패턴

### 2-1. Development: Namespaced Scratch Org

> 패키지 **개발**할 때는 **namespaced scratch org를 권장**한다.
> namespaced scratch org는 scratch org 안에 만들거나 deploy하는 모든 메타데이터에 **package namespace를 prefix**로 붙인다.

**전제조건:**
- 사용하려는 namespace가 이미 Dev Hub org에 연결되어 있을 것 ([[2GP Managed Package 개발 환경과 사전 준비]] → Namespace를 Dev Hub에 Link)
- `sfdx-project.json`의 `namespace` 속성에 명시되어 있을 것
- scratch org definition file에 필요한 features·settings·limits 포함

**Ancestor 정보 자동 seeding** — managed 2GP의 핵심 특징:
- `sfdx-project.json`의 `ancestorId` 또는 `ancestorVersion`이 명시되어 있으면, scratch org 생성 시 그 정보가 함께 들어간다.
- 결과: scratch org에 **manageability rules가 미리 seed**되어, ancestor 버전과 호환되지 않는 메타데이터 변경을 시도하면 **경고**가 나온다. 효과는 **"패키지 버전 생성 시점이 아니라 개발 중에 문제를 발견"** — 사이클 단축.

**CLI:**
```bash
sf org create scratch --target-dev-hub MyHub --definition-file config/project-scratch-def.json
```

ancestor seeding을 원치 않으면 `--no-ancestors` 플래그 추가.

### 2-2. Testing: No-Namespace Scratch Org

> 패키지를 **테스트**할 때는 **namespace 없는 scratch org**를 만든다. 구독자 org와 동일한 조건이라야 진짜 install 동작을 검증할 수 있다.

**CLI:**
```bash
sf org create scratch --definition-file config/project-scratch-def.json --no-namespace --no-ancestors
```

- `--no-namespace` — namespace prefix 없이 생성 (구독자 org와 동일)
- `--no-ancestors` — manageability rules·ancestry seeding 생략 (install 동작에 영향 없게)

그 다음: 패키지를 install하고 테스트 시작.

### 2-3. 두 모드 비교

| 항목 | Development (namespaced) | Testing (no-namespace) |
|---|---|---|
| `--no-namespace` 플래그 | ❌ 사용 안 함 | ✅ 사용 |
| `--no-ancestors` 플래그 | 선택 (보통 사용 안 함) | ✅ 사용 |
| 메타데이터에 namespace prefix | ✅ 자동 부착 | ❌ 부착 안 됨 |
| ancestor manageability 검사 | ✅ 개발 중 enforce | ❌ 안 함 |
| 용도 | 메타데이터 작성·수정 | 만든 패키지 버전 install 검증 |

---

## 3. Definition File vs Org Shape — scratch org 청사진

scratch org definition file (`project-scratch-def.json`)은 **scratch org 생성 시 + 패키지 버전 생성 시 둘 다** 사용된다.

```bash
# scratch org 생성 시
sf org create scratch --target-dev-hub MyHub --definition-file config/project-scratch-def.json

# 패키지 버전 생성 시 (build org에 적용할 features·settings)
sf package version create --package "Expenser App" \
  --definition-file config/project-scratch-def.json \
  --code-coverage
```

### 3-1. Definition File 직접 작성 — 일반 경우

> AppExchange에 배포할 managed 패키지 개발자는 **자기 패키지에 필요한 features·settings를 알고 있다고 가정**된다. → scratch org definition file에 명시적으로 나열한다.

`project-scratch-def.json`의 옵션 전수는 [[Scratch Org 생성과 정의 파일]] · [[Scratch Org Settings 레퍼런스]] 참조.

### 3-2. Org Shape 사용 — 유용한 시나리오

> Unlocked Package 작업이거나 **1GP에서 2GP로 이전 중**이면 **Org Shape**가 유용하다.

**Org Shape 동작:**
- source org의 **features · settings · edition · licenses · limits를 일괄 캡처**.
- scratch org definition file에 모든 항목을 수동으로 나열할 필요 없음.

**제약:**
- source org는 **sandbox·scratch org가 될 수 없음** (production org나 그에 준하는 환경).

**사용 방법** — scratch org definition file에 source org ID 명시:
```json
// 구조 예시 — 실제 동작 코드 아님
{
  "orgName": "Acme",
  "sourceOrg": "00DB1230400Ifx5"
}
```

**1GP → 2GP migration 활용 패턴:**
1GP packaging org의 org shape을 만든다 → 그 패키지에 필요한 features가 자동으로 식별됨 → 2GP scratch org definition file에 누락 없이 반영.

Org Shape의 일반적 생성·관리·snapshot 동작은 [[Org Shape와 Snapshot]] 참조.

---

## 4. Snapshots — Build 시간 단축 + 중요 제약

### 4-1. 왜 필요한가

> `sf package version create`를 실행하면 **scratch org를 백그라운드에서 만들고** 그게 **build org**가 된다. build org에 의존 패키지들을 install한 뒤 base package metadata를 deploy한다. 의존 패키지가 크면 build 시간이 길어진다.

→ 의존 패키지가 **안정**이라면 snapshot으로 그 install 단계를 우회한다.

**Scratch Org Snapshot의 정의:**
> snapshot은 scratch org configuration의 point-in-time copy. 설치된 packages · features · limits · licenses · metadata · data를 모두 포함.

**작동 원리:**
1. scratch org 만들고 의존 패키지 install
2. snapshot 생성 (이때 의존 패키지 install된 상태가 캡처됨)
3. 새 패키지 버전 생성 시 그 snapshot 지정 → build process가 의존 패키지 install 단계 건너뜀

**효과:** 패키지 버전 build 시간이 fraction으로 단축됨.

### 4-2. 결정적 제약 — Managed 패키지의 promote 차단

> Scratch org snapshot의 목적은 **개발 단계에서 패키지 생성 시간 단축**.
> **promote·release 단계에서는 snapshot 기반 버전을 사용할 수 없다.**

| 패키지 타입 | snapshot 기반 버전 promote 가능? |
|---|---|
| Managed 2GP (이 페이지) | ❌ **불가** |
| Unlocked Package | ✅ 가능 |

> [!important] managed 2GP에서 promote·release 준비가 되면, snapshot에 의존하지 않는 새 패키지 버전을 다시 생성해야 한다.

### 4-3. Sample Workflow — Org Shape 기반 snapshot 생성

PDF의 7단계 워크플로 (org shape으로 초기 scratch org 만들고 → 안정된 의존 패키지 설치 → snapshot 생성 → 그 snapshot으로 패키지 버전 생성).

```bash
# 1. source org에서 org shape 만들기
sf org create shape --target-org source-org1

# 2. scratch org definition file에 sourceOrg ID 지정
#    config/scratch-def-with-shape-id.json :
#    { "orgName": "Salesforce", "sourceOrg": "00DB1230400Ifx5" }

# 3. shape 기반 scratch org 생성
sf org create scratch \
  --duration-days 30 \
  --no-namespace \
  --no-ancestors \
  --definition-file config/scratch-def-with-shape-id.json \
  --alias dev1-with-shape

# default Dev Hub이 org shape 소유 org가 아니면 CLI에 명시

# 4. 의존 패키지 설치
sf package install --package 04txx --target-org dev1-with-shape

# 5. snapshot 생성
sf org create snapshot \
  --name dhsnapshot \
  --source-org dev1-with-shape \
  --target-dev-hub dev-hub

# 6. snapshot 정보 들어간 새 definition file
#    scratch-def-with-snapshot-id.json :
#    { "orgName": "Salesforce", "snapshot": "dhsnapshot" }

# 7. snapshot 기반 패키지 버전 생성
sf package version create \
  --package hc-ext1 \
  --code-coverage \
  --installation-key-bypass \
  --async-validation \
  --definition-file scratch-def-with-snapshot-id.json
```

대안 workflow (PDF에 명시):
- org shape 없이 scratch org definition file을 직접 작성하는 경로
- 어떤 경로든 **scratch org 생성 → 의존 패키지 install → snapshot 생성** 패턴은 동일

---

## 5. Agentforce·Data Cloud Scratch Orgs

managed 2GP 패키지가 Agentforce 기능을 활용한다면 scratch org에 Agentforce를 활성화해야 한다.

### 5-1. Agentforce + Prompt Builder

scratch org definition file 예시:
```json
// 구조 예시 — 실제 동작 코드 아님 (PDF 원문 그대로)
{
  "orgName": "GenAI Scratch Org",
  "edition": "Partner Developer",
  "features": ["Einstein1AIPlatform"],
  "settings": {
    "einsteinGptSettings" : {
      "enableEinsteinGptPlatform" : true
    }
  }
}
```

**지원 edition** (Einstein1AIPlatform feature 활성화 가능):
- Partner Developer
- Partner Enterprise
- Developer
- Enterprise

**CLI:**
```bash
sf org create scratch \
  --definition-file config/my-agentforce-project-scratch-def.json \
  --alias MyNamespacedScratchOrg \
  --set-default \
  --target-dev-hub MyDevHubOrg
```

### 5-2. Agentforce + Data Cloud 동시 활성화

> 일부 use case — 예를 들면 **RAG·Retrievers·BYO LLM을 사용하는 prompt template** 등 — 에서는 Agentforce와 Data Cloud를 동시에 활성화한 scratch org가 필요.
> **단, Data Cloud 포함은 scratch org 생성 시간을 크게 증가시킨다** → 정말 필요할 때만.

**전제조건 (반드시):**
> [!warning] **PBO Dev Hub에 Data Cloud scratch org 생성 권한을 받기 위해 Salesforce Partner Community에 케이스를 먼저 등록**해야 한다. 이 요청은 PBO org에만 허용됨.

scratch org definition file 예시:
```json
// 구조 예시 — 실제 동작 코드 아님 (PDF 원문 그대로)
{
  "orgName": "GenAI & Data Cloud Scratch Org",
  "edition": "Partner Developer",
  "features": ["CustomerDataPlatform", "CustomerDataPlatformLite", "Einstein1AIPlatform"],
  "settings": {
    "einsteinGptSettings" : {
      "enableEinsteinGptPlatform" : true
    },
    "customerDataPlatformSettings": {
      "enableCustomerDataPlatform": true
    }
  }
}
```

### 5-3. scratch org 생성 후 Agentforce 활성화 단계
- scratch org에 **수동으로 Agent 생성**
- Agent Action에 prompt template 사용하려면 **prompt template permission 할당**

### 5-4. 일반 Data Cloud for Scratch Orgs (Agentforce 없이)
Data Cloud 컴포넌트만 scratch org에서 쓰거나 패키지에 추가하려면 **Data Cloud for Scratch Orgs** 활성화 필요. 동일하게 Salesforce Partner Support에 케이스 등록 — **PBO Dev Hub에 연결된 scratch org만** 사용 가능.

---

## 6. Scratch Org Allocations — Partner 할당량

> 최적 성능을 위해 Salesforce는 PBO마다 scratch org 개수를 할당한다. 일일 생성량과 동시 활성 개수를 결정.
> 기본 동작: scratch org 만료 시 그 org와 연결된 ActiveScratchOrg 레코드도 Dev Hub에서 자동 삭제.

### 6-1. PBO 타입별 할당량

| 항목 | Active PBO | Trial PBO |
|---|---|---|
| 동시 활성 scratch orgs | 150 | 20 |
| 일일 scratch orgs | 300 | 40 |
| Salesforce Limited Access - Free user 라이선스 | 100 (모든 파트너 공통) | 100 (모든 파트너 공통) |

### 6-2. Snapshot 할당량

PDF 원문: *"The number of snapshots you can create (active and daily) is the same as the active scratch org allocation."*

→ **active snapshot 수와 daily snapshot 수 둘 다 = active scratch org 할당량**:

| | Active PBO | Trial PBO |
|---|---|---|
| active snapshot 수 | 150 (= active scratch org) | 20 (= active scratch org) |
| daily snapshot 수 | **150** (= active scratch org, daily scratch org 할당량(300)이 아님) | **20** (= active scratch org, daily 40이 아님) |

> [!warning] daily snapshot 수는 daily scratch org 할당량(300/40)이 아니라 **active scratch org 할당량(150/20)** 과 같다. PDF의 단일 reference value 한 줄이 두 metric에 모두 적용되는 케이스.

### 6-3. Package Version Creation Limits

```
일일 패키지 버전 생성 한도 = 일일 scratch org 할당량
```

예: Active PBO는 daily 300 scratch org → daily 300 package version까지.

`--skipvalidation` 플래그를 사용해 패키지 버전을 만들면 한도가 **500/day**로 증가.

---

## 7. Dev Hub에서 Scratch Org 관리

### 7-1. 두 가지 standard object

| Object | 의미 |
|---|---|
| `ActiveScratchOrg` | **현재 사용 중인** scratch orgs |
| `ScratchOrgInfo` | scratch org를 만들기 위해 **사용된 요청** (이력 컨텍스트) |

### 7-2. 관리 절차

```
1. Dev Hub org에 System Administrator (또는 Salesforce DX 권한 사용자)로 로그인
2. App Launcher → "Active Scratch Orgs" → 활성 scratch org 목록
3. 상세 보기: Number 열의 링크 클릭
4. 활성 scratch org 삭제: dropdown → Delete
   ⚠️ 삭제하면 ActiveScratchOrg는 사라지지만 ScratchOrgInfo(요청)는 남음
   → 할당량은 freed
5. 요청 보기: App Launcher → "Scratch Org Infos"
   각 요청의 active/expired/deleted 상태 확인
6. 요청 삭제: dropdown → Delete
   ⚠️ ScratchOrgInfo를 삭제하면 그게 만든 ActiveScratchOrg도 함께 삭제됨
```

**핵심 차이**:
- ActiveScratchOrg만 삭제 → 활성 org 없어지고 할당량 회복, 요청 이력은 남음
- ScratchOrgInfo 삭제 → 그게 만든 활성 org까지 같이 삭제 (cascade)

---

## 8. Supported Scratch Org Editions for Partners

Partner business org에서 만들 수 있는 partner edition scratch orgs:

- **Partner Developer**
- **Partner Enterprise**
- **Partner Group**
- **Partner Professional**

### 8-1. Definition File에 edition 지정

```json
// 구조 예시 — 실제 동작 코드 아님
{
  "edition": "Partner Enterprise"
}
```

### 8-2. 권한 오류 시

```
ERROR: You don't have permission to create Partner Edition organizations.
To enable this functionality, please log a case in the Partner Community.
```

→ 사용 중인 org가 **active partner business org**인지 확인. 아니면 Partner Community에 문의.

라이선스 한도는 Environment Hub에서 만든 partner edition org와 유사. 상세는 Partner Community 참조.

---

## 9. 종합 워크플로 요약

```
[개발 단계]
  1. namespaced scratch org 생성 (sf org create scratch, --no-namespace 없이)
  2. ancestor seeding 활용 → manageability 위반을 개발 중 즉시 감지
  3. 메타데이터 작성·수정

[빌드 시간 단축이 필요하면]
  4. (의존 패키지가 안정적이면) snapshot 생성
  5. snapshot 기반 패키지 버전 생성
  ⚠️ managed 패키지는 snapshot 기반 버전 promote/release 불가
      → release 단계에 snapshot 없는 버전을 다시 생성

[테스트 단계]
  6. no-namespace scratch org 생성 (--no-namespace --no-ancestors)
  7. 패키지 install → 동작 검증

[Agentforce·Data Cloud 필요 시]
  8. Einstein1AIPlatform feature + einsteinGptSettings 활성화
  9. Data Cloud 동시 필요하면 Partner Community 케이스 선행

[관리]
 10. ActiveScratchOrg(현재) / ScratchOrgInfo(요청) 두 객체로 관리
 11. 할당량 모니터링: Active PBO 150 활성·300 일일 / Trial PBO 20·40
```

---

## 관련 노트

- [[2GP Managed Package 개념과 1GP 비교]] — 2GP 개념·1GP와의 차이
- [[2GP Managed Package 개발 환경과 사전 준비]] — namespace Dev Hub link·Manageability Rules·Ancestry·dependency matrix (선행 페이지)
- [[Scratch Org 생성과 정의 파일]] — `project-scratch-def.json` 옵션 전수·features 목록
- [[Scratch Org Settings 레퍼런스]] — settings 블록 전수
- [[Scratch Org 배포·유저·에러코드]] — scratch org 사용자·error codes
- [[Org Shape와 Snapshot]] — Org Shape·Snapshot의 일반 동작
- [[sfdx-project.json 레퍼런스]] — `namespace`·`ancestorId`·`ancestorVersion`·`dependencies` 필드
- [[DX 인증 방식]] — Dev Hub 로그인
- [[2GP — Develop]] — scratch org 이후: sf package create·version create·버전 번호·Ancestor·Promote 전수
- [[Unlocked Package 개발과 버전]] — Unlocked는 snapshot 기반 버전 promote 가능 (managed와 대조)
- [[2GP Managed Package — Workflow]] — scratch org 준비 이후 단계: 표준 CLI 워크플로 10단계 + Supported Components
- [[2GP — Specific Metadata Behavior]] — Agentforce Agent Template 패키징 절차(sf agent generate template)·Data Cloud 패키지 전용 패키지 요건·패키지 내 특정 메타데이터 동작 전수
