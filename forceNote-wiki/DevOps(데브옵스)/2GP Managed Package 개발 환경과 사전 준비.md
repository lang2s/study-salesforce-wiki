---
tags: [DevOps, Packaging, 2GP, ManagedPackage, Namespace, DevHub, Ancestry, Manageability, 매니지드패키지, 패키징, 네임스페이스]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.6-14
created: 2026-05-23
aliases: [2GP 개발 환경, 2GP 사전 준비, 2GP Dev Hub 설정, managed 2GP namespace, namespace 생성, Link Namespace to Dev Hub, Manageability Rules, Package Ancestry, Package Dependency Matrix, 2GP 의존성, Know Your Orgs, Limited Access User]
---

# 2GP Managed Package 개발 환경과 사전 준비

> managed 2GP 첫 패키지를 만들기 전 알아야 할 구조와 규칙. **org 역할 구분 · namespace 생성과 link · key concepts · manageability rules · ancestry · 의존성 매트릭스**를 다룬다. 개념·1GP 비교는 [[2GP Managed Package 개념과 1GP 비교]] 참조.

---

## 1. Set Up Development Environment — 도구·라이선스·사용자

### 1-1. 필요한 도구 4가지
- **Salesforce CLI** — `sf` 명령으로 모든 패키징 작업 (package create/install 등) 수행
- **소스 컨트롤 시스템** — VCS (Git 권장)
- **Dev Hub org** — managed 2GP 패키지·scratch org·namespace 관리의 중심
- **(선택) VS Code Salesforce Extension** — Salesforce 컴포넌트 개발 IDE

### 1-2. Dev Hub 활성화 (요약)
PBO에서 **Enable Dev Hub** + **Enable Unlocked Packages and Second-Generation Managed Packages** 두 체크. 둘 다 활성화 후 비활성화 불가. sandbox에서는 활성화 불가. ([[2GP Managed Package 개념과 1GP 비교]] → Dev Hub 활성화 절차 참조)

### 1-3. Limited Access User 추가 — 상세 절차

개발자에게 Dev Hub와 DX 개발 도구 접근권을 주려면 Salesforce Limited Access - Free 라이선스 + Limited Access User 프로파일로 사용자를 만들고, 권한 세트를 부여한다.

```
1. Dev Hub org에서 사용자 생성
   a. Setup → Quick Find: "Users" → Users
   b. [New User]
   c. User License = "Salesforce Limited Access - Free"
   d. Profile     = "Limited Access User"
   e. 나머지 정보 입력 → [Save]

2. 권한 세트 생성 + 할당
   → 아래 1-4의 권한 세트 구성을 따른다
```

> [!note] Limited Access - Free 라이선스는 production org에서 표준/커스텀 객체 접근이 제한된다. PBO에 100개 라이선스가 기본 포함됨. 부족하면 Salesforce Partner Support에 케이스로 요청.

### 1-4. managed 2GP 권한 세트 구성

```
[Object Settings]
  Scratch Org Info       → Read, Create, Delete
  Active Scratch Org     → Read, Delete
  Namespace Registry     → Read              ← linked namespace 사용 시

[System Permissions]
  Create and Update Second-Generation Packages
```

**Create and Update Second-Generation Packages** 권한이 부여하는 접근:

| Salesforce CLI 명령 | Tooling API 객체 (Create/Edit) |
|---|---|
| `sf package create` | `Package2` |
| `sf package version create` | `Package2VersionCreateRequest` |
| `sf package version update` | `Package2Version` |

> [!warning] scratch org 생성 시 `sfdx-project.json`에 ancestor 버전이 지정되어 있다면 위 권한이 scratch org 생성에도 필요. 대안: `sf org create`에 `--noancestors` 플래그.

---

## 2. Before You Create — 무엇을 결정·준비해야 하는가

managed 2GP를 처음 만들기 전에 결정·준비해야 하는 항목은 다음 영역에 흩어져 있다.

- **Org 역할 구분** — Dev Hub·Namespace Org·Scratch Org·설치 대상 org를 어떻게 쓰는가 → 3장
- **Namespace 설계** — 어떤 namespace를 만들고 Dev Hub에 link하는가, 패키지와의 1:N 관계 → 4장
- **Key Concepts** — app·package·metadata·version·install vs upgrade 용어 정렬 → 5장
- **Manageability Rules** — 패키지에 들어가면 무엇이 잠기는가 → 6장
- **Package Ancestry** — 버전 의사결정 전략 → 7장
- **의존할 패키지 타입** — 의존성 매트릭스 → 8장

전체 시작 체크리스트는 **9장 (종합)**에 한 곳에 정리되어 있다.

---

## 3. Know Your Orgs — managed 2GP에 등장하는 org들

managed 2GP는 **여러 종류의 org**를 조합해 동작한다. 각 org의 고유한 역할을 먼저 이해해야 한다.

### 3-1. Dev Hub org

| 역할 | 설명 |
|---|---|
| 패키지 소유자 | `sf package create`를 실행하는 Dev Hub가 그 패키지의 **owner**가 된다 |
| Namespace 링크 보관소 | namespace org들을 link해서 모아둔다 |
| CLI 인증 대상 | `sf package` 계열 명령을 실행하려면 Dev Hub에 로그인 ([[DX 인증 방식]]) |

> [!warning] Dev Hub org가 만료되거나 삭제되면 그 Dev Hub 소유의 패키지는:
> - 다른 Dev Hub로 **이전 불가**
> - **동작 중지**, 새 패키지 버전 생성 불가
>
> → 그래서 PBO를 Dev Hub로 권장.

### 3-2. Namespace Org

namespace org의 **primary purpose는 managed 2GP 패키지를 위한 namespace 획득**이다.

| 항목 | 내용 |
|---|---|
| Edition | **Developer Edition** (별도 Developer Edition org를 만든다) |
| Dev Hub와의 관계 | **별개의 org** — Dev Hub org나 scratch org와 분리. namespace org는 namespace 소유만 담당. |
| 흐름 | ① Developer Edition org 가입 → ② 그 안에서 namespace 등록 → ③ Dev Hub org에서 namespace org를 link → ④ `sfdx-project.json`의 `namespace` 속성에 명시 |
| 1 Dev Hub ↔ N namespace org | 한 Dev Hub에 **여러 namespace org를 link 가능** (4-2의 N:1 규칙 참조) |
| 변경 가능성 | 한 번 org와 연결된 namespace는 **재사용·변경 불가** → 테스트 목적이라면 일회용 namespace 사용 권장 |

자세한 namespace 생성·link 절차는 **4장**(Namespace — 의미·생성·연결) 참조.

### 3-3. 그 외 org

| org | 용도 |
|---|---|
| Scratch org | 패키지 개발·테스트 환경 ([[Scratch Org 생성과 정의 파일]]) |
| Target/Installation org | 패키지를 설치할 대상 org (구독자 org) |

---

## 4. Namespace — 의미·생성·연결

### 4-1. Namespace란?
- **1~15자 알파뉴메릭** 식별자.
- 패키지와 그 콘텐츠를 다른 패키지와 구분.
- **패키지 생성 시점에 지정** — 이후 **변경 불가**.
- 컴포넌트 API name에 prefix로 박힘 → 예: namespace가 `Acme`이고 커스텀 객체가 `Insurance_Agent__c`면 `Acme__Insurance_Agent__c`.

> [!important] namespace 이름은 신중히 고를 것:
> - **사람 이름·닉네임·개인정보 금지**
> - 테스트용이라면 일회용 namespace 사용 권장 (한 번 org와 연결되면 **재사용·변경 불가**)

### 4-2. Namespace ↔ 패키지 관계 — 핵심 규칙

| 규칙 | managed 2GP |
|---|---|
| 하나의 namespace가 **여러** 패키지에 사용될 수 있는가? | ✅ 가능 |
| 하나의 패키지가 **여러** namespace를 가질 수 있는가? | ❌ 불가 |
| 한번 연결된 namespace 변경 가능? | ❌ 불가 |
| namespace 공유의 이점 | 같은 namespace 패키지들끼리 `@namespaceAccessible` public Apex 공유 가능 |

> 권장: **모든 managed 2GP 패키지에 단일 namespace 사용** (코드 공유가 훨씬 쉬워짐). 한 패키지를 분리·이전할 계획이 있다면 그 패키지만 독립 namespace.

### 4-3. namespace 작업 시 주의사항
- **여러 namespace를 다룬다면 각각에 대해 별도 프로젝트** 권장 (sfdx-project.json은 한 namespace 기준).
- 공유가 좋지만 **필수는 아니다** — package·namespace 전략을 신중히. 일단 연결되면 변경 불가.
- 분리할 필요가 있는 시나리오: 패키지를 별도 제품으로 판매·spinoff할 경우, **namespace를 패키지와 함께 이전**할 수 있도록 독립 namespace 부여.

### 4-4. Namespace 생성 절차

```
1. 새 Developer Edition org에 가입 (namespace org가 됨 — Dev Hub와 별개)
2. Setup → Quick Find: "Package Manager" → Package Manager
3. Namespace Settings에서 [Edit]
4. namespace 입력 → [Check Availability]
5. (선택) namespace에 연결할 패키지 선택, 또는 None → [Review]
6. 선택 검토 후 [Save]
```

### 4-5. Namespace를 Dev Hub에 Link

**Link해야 scratch org에서 namespace를 사용할 수 있다.**

전제조건:
- namespace가 등록된 Developer Edition org가 있을 것 (Dev Hub와 scratch org와는 **별개의 org**).
- 그 Developer Edition org에서 namespace가 이미 생성·등록되어 있을 것.

```
1. Dev Hub org에 System Administrator (또는 Salesforce DX Namespace Registry 권한 사용자)로 로그인
   ※ 브라우저가 Dev Hub org의 팝업을 허용해야 함
   a. App Launcher → "Namespace Registries"
   b. [Link Namespace]
2. 팝업으로 뜬 창에서 namespace org의 System Administrator 자격으로 로그인
```

링크된 모든 namespace 확인: **All Namespace Registries** list view.

> [!note] namespace가 **없는** org는 link 불가 — sandbox · scratch org · patch org · branch org는 모두 Namespace Registry에 link하려면 namespace가 필요.

### 4-6. namespace를 sfdx-project.json에 명시

namespace를 Dev Hub에 link한 뒤 `sfdx-project.json`의 `namespace` 속성에 지정한다. 새 2GP 패키지를 만들 때 이 namespace가 패키지와 연결된다. ([[sfdx-project.json 레퍼런스]])

```json
// 구조 예시 — 실제 동작 코드 아님
{
  "namespace": "Acme",
  "packageDirectories": [...],
  "sourceApiVersion": "67.0"
}
```

---

## 5. Key Concepts — 용어 구분

### 5-1. App vs Package vs Metadata

| 용어 | 의미 |
|---|---|
| **App** | 고객을 위해 개발하는 기능 집합 (비즈니스 단위) |
| **Metadata** | Salesforce 기능의 기술적 표현 (custom object · Apex class · Lightning page 등). 앱은 메타데이터의 집합. |
| **Package** | 앱의 Salesforce 메타데이터를 담는 **컨테이너**. 앱 배포 단위. 패키지를 설치하면 그 안의 메타데이터가 org에 deploy된다. |

### 5-2. Package vs Package Version

> 앱(=패키지)은 시간이 흐르며 계속 진화한다. 메타데이터를 바꾸고·추가하고·제거할 때마다 **새 package version**을 만든다. 각 package version은 **immutable artifact** — 특정 시점의 정적 스냅샷.
>
> 기술적으로 "패키지 설치"는 사실 "특정 package version 설치"를 의미한다.

### 5-3. Package Install vs Package Upgrade

| 동작 | 의미 |
|---|---|
| **Install** | org에 패키지가 **처음 들어가는** 경우. 패키지의 메타데이터가 org에 deploy됨. |
| **Upgrade** | org에 이전 버전이 이미 설치되어 있고 **새 버전을 설치**하는 경우. 메타데이터 변경분이 deploy — 신규 추가·수정·삭제·deprecation 모두 가능. |

> [!important] **한 org에는 같은 패키지의 한 버전만** 설치 가능 (any given point in time).

### 5-4. Package Lifecycle 가능 동작 — 빠른 답변

| 가능? | 동작 | 비고 |
|---|---|---|
| ✅ | **Push upgrade** | 구독자에게 요청 없이 강제 업그레이드 ([[2GP Managed Package 개념과 1GP 비교]]에서 언급) |
| ✅ | **Uninstall** | 패키지 컴포넌트와 연관 데이터까지 삭제됨 |
| ✅ | **Delete a package or version** | **promote/distribute 전인 경우만** Dev Hub에서 삭제 가능 |

---

## 6. Manageability Rules — 패키지에 들어간 메타데이터의 변경 제약

> managed 2GP 패키지에 포함된 각 메타데이터 컴포넌트는 **구독자 org에서의 동작을 결정하는 manageability rules**를 가진다.
> 이 규칙은 **너(개발자)와 구독자가 컴포넌트를 편집·제거할 수 있는지**를 정한다.

### 6-1. Manageability Rules의 적용 범위

| 수준 | 예 |
|---|---|
| 컴포넌트 수준 | "이 custom field를 삭제할 수 있는가?" |
| 컴포넌트 속성 수준 | "이 custom field의 Field Label / Default Value / 기타 속성을 편집할 수 있는가?" |

### 6-2. 강제 시점

- **모든 1GP·2GP managed package에서 package version 생성 시점에 enforce**.
- 어떤 변경이 manageability rule을 위반하면 → **package version 생성 자체가 실패**.

→ 즉, 한 번 패키지에 들어가서 release된 메타데이터는 자유롭게 못 바꾼다. 패키지에 넣기 **전에** 구조를 안정화해야 한다.

---

## 7. Package Ancestry — 유연한 선형 버전 관리

### 7-1. Ancestry란?
managed 2GP는 선형 버전 관리지만 **버전 abandon**과 **이전 버전을 ancestor로 재선택**이 가능 → 이 의사결정의 흔적이 "package ancestry".

각 package version을 생성할 때 **어떤 버전이 ancestor인지 반드시 지정**해야 한다.

### 7-2. abandoned 버전이 있는 ancestry 예

> PDF에는 ancestry tree 다이어그램이 있으나 pdftotext가 못 잡는 시각 자료다. PDF 본문은 "version 1.2 and 1.5 have been abandoned" 한 줄만 명시. 아래는 그 문구를 텍스트로 재현한 것 — 실제 PDF 다이어그램의 정확한 형태는 공식 가이드 "Package Ancestors" 토픽 확인 필요.

```
// 구조 예시 — 실제 PDF 다이어그램 아님 (텍스트 재현)
//
// 버전: 1.0  1.1  1.2  1.3  1.4  1.5  1.6
// 상태: 정상 정상 ✗abandoned 정상 정상 ✗abandoned 정상
//
// 의미: abandon된 버전(1.2, 1.5)은 ancestor로 선택할 수 없고,
//       다음 버전을 만들 때는 abandon되지 않은 이전 버전 중에서 ancestor를 지정한다.
```

자세한 ancestry 규칙은 공식 가이드 *"Package Ancestors for Second-Generation Managed Packages"* 참조.

### 7-3. Manageability Rules + Ancestry가 Upgrade에 미치는 영향

| 측면 | 영향 |
|---|---|
| **manageability rule** | 패키지 버전 upgrade 시 신규·변경 컴포넌트마다 enforce. 어떤 메타데이터는 추가·수정·삭제되고, **어떤 변경은 적용 안 됨**. |
| 예: page layout | upgrade 시 **갱신되지 않음** — 변경된 page layout은 **신규 가입자만** 받음. 기존 구독자는 변경 안 받음. |
| 예: Apex code / 수식 필드 | upgrade 시 갱신됨. |
| **package ancestry** | upgrade 경로 결정. 구독자가 어떤 버전에서 어떤 버전으로 upgrade 가능한지는 **ancestry tree를 따른 경우만** 허용. |

> [!note] ancestry는 "subscriber가 이 버전으로 upgrade해도 되는지"를 결정. ancestor가 잘못 지정된 버전은 구독자에게 깨질 수 있다. 자세한 동작은 "Understanding Package Upgrades with Ancestry" 토픽 참조.

---

## 8. Package Dependency Matrix — 어떤 패키지에 의존할 수 있는가

> managed 2GP·unlocked 패키지는 **작은 모듈러 패키지들로 분할**하고 의존성을 선언적으로 명시할 수 있다.
> 분할하면: 패키지 생성·설치 속도 ↑, 한도 hit 가능성 ↓.

### 8-1. 의존성 매트릭스

| **이 패키지가 ↓ / 이 타입에 의존 가능? →** | Managed 1GP | Managed 2GP | Unlocked Package | Unmanaged |
|---|---|---|---|---|
| **Managed 1GP** | ✅ | ❌ (`No¹`) | 권장 안 함 | 권장 안 함 |
| **Managed 2GP** | ✅ | ✅ | 권장 안 함 | 권장 안 함 |
| **Unlocked Package** | ✅ | ✅ | ✅ | 권장 안 함 |
| **Unmanaged Package** | ❌ | ❌ | ❌ | ❌ |

> 범례: ✅ 지원 · ❌ 차단 · 권장 안 함 = 기술적으로 가능하나 Salesforce가 비권장
>
> ¹ Managed 1GP가 Managed 2GP에 의존하는 시나리오는 지원되지 않으며, **managed 2GP 패키지의 managed 1GP packaging org 설치가 차단된다.** 다만 개별 케이스 단위로 **override 가능** — 시나리오를 공유하고 override를 요청하려면 Salesforce Partner Support에 케이스를 등록한다. Salesforce는 이 의존 시나리오를 더 넓게 지원하는 방안을 조사 중.

### 8-2. 의존성 매트릭스 읽기

- **Managed 2GP는 다른 managed 2GP·managed 1GP에 의존 가능** → 안전한 확장.
- **Managed 2GP가 Unlocked에 의존하는 건 "권장 안 함"** → 기술적으로 가능하지만 비권장. Unlocked는 구독자 측에서 수정 가능 → managed에서 의존하면 깨질 위험.
- **모든 패키지가 Unmanaged에 의존하는 것도 "권장 안 함"** (managed 1GP·managed 2GP·Unlocked가 Unmanaged에 의존하는 경우 모두 동일). 단, **Unmanaged 자신은 어떤 패키지에도 의존 불가** — 의존성 그래프에서 사실상 leaf only로 사용한다.
- **Managed 1GP → Managed 2GP는 차단**되지만 Partner Support에 override 요청 가능 (footnote ¹ 참조).

### 8-3. 선언 방법
의존성은 `sfdx-project.json`의 `dependencies`에 **선언적으로 명시** ([[sfdx-project.json 레퍼런스]]).

```json
// 구조 예시 — 실제 동작 코드 아님
{
  "packageDirectories": [{
    "path": "force-app",
    "package": "MyManaged2GP",
    "versionNumber": "1.0.0.NEXT",
    "dependencies": [
      { "package": "MyBasePackage@1.2.0-3" },
      { "package": "0Ho1x000000ABCXxxx" }
    ]
  }]
}
```

---

## 9. 종합 — managed 2GP 시작 전 체크리스트

```
□ Dev Hub org 결정 (PBO 권장) + 활성화
□ Limited Access User 추가 + 권한 세트 (Create and Update Second-Generation Packages 포함)
□ Namespace org에서 namespace 생성·등록
□ Dev Hub에 namespace link
□ sfdx-project.json에 namespace 명시 + sourceApiVersion 설정
□ 의존성 매트릭스 검토 — 의존할 패키지 타입이 허용되는지 확인
□ Manageability Rules 인지 — "한번 들어가면 못 바꾸는" 컴포넌트 식별
□ Ancestry 전략 결정 — 어떤 버전을 ancestor로 둘지, abandon 정책
```

---

## 관련 노트

- [[2GP Managed Package 개념과 1GP 비교]] — 개념·1GP 차이·Dev Hub 활성화 기본
- [[2GP Managed Package Scratch Org 워크플로]] — 이 페이지의 후속: Develop vs Test scratch org·Snapshot·Agentforce·할당량
- [[2GP — Develop]] — 패키지·버전 생성 CLI 전수, Project Config File 파라미터, Ancestor 지정, Promote 준비
- [[2GP Managed Package — Workflow]] — 사전 준비 다음 단계: 표준 CLI 워크플로 10단계 + Manageability Rules 전수 + Supported Components 목록
- [[sfdx-project.json 레퍼런스]] — namespace·dependencies·packageDirectories 필드 전수
- [[Salesforce DX 개요]] — DX 도구 전반
- [[DX 인증 방식]] — Dev Hub에 CLI 로그인 (JWT·web flow)
- [[Scratch Org 생성과 정의 파일]] — 개발·테스트용 scratch org
- [[Unlocked Package 개념과 준비]] — 2GP의 다른 한 갈래, dependency matrix에서 자주 등장
- [[Unlocked Package 생성과 설정]] — namespace 옵션·@namespaceAccessible 활용 패턴
- [[2GP — Specific Metadata Behavior]] — Agentforce·Data Cloud 패키징 특수 요건·보호 컴포넌트·Platform Cache Provider Free·Permission Set vs Profile 비교·IP 보호·DomainCreator·@NamespaceAccessible·Connected App·New Order Save Behavior
- [[2GP — Advanced Features Part 1]] — Package Ancestors 상세 업그레이드 경로 테이블·Dependencies 전수·Keywords·Branches
- [[2GP — Advanced Features Part 2]] — Package IDs·Namespace Collision 설치 조합·Remove Metadata·Transfer Dev Hub
