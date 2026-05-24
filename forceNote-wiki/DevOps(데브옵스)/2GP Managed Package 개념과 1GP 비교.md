---
tags: [DevOps, Packaging, 2GP, ManagedPackage, AppExchange, 매니지드패키지, 패키징, 1GP비교]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26)
created: 2026-05-23
aliases: [Second-Generation Managed Package, managed 2GP, 2GP 매니지드 패키지, 2세대 매니지드 패키지, 2GP vs 1GP, managed 1GP vs 2GP, 매니지드 패키지 차이]
---

# 2GP Managed Package 개념과 1GP 비교

> Second-Generation Managed Packaging(**managed 2GP**)은 AppExchange 파트너가 앱·메타데이터를 개발·배포·관리하는 새로운 방식이다. **버전 관리 시스템(VCS)이 진실의 원천**이며 packaging org / patch org가 사라진다. 모든 패키징 작업이 Salesforce CLI로 자동화 가능하다.

---

## 1. 한 줄 정의

> "managed 2GP는 packaging org를 없애고, **Dev Hub + VCS** 조합으로 매니지드 패키지를 만든다."

- **누구를 위한 도구인가**: AppExchange에 앱을 배포하려는 ISV/OEM 파트너 (고객·시스템 통합자라면 [[Unlocked Package 개념과 준비|Unlocked Package]]가 우선).
- **1GP에서 마이그레이션 가능한가**: 현재 시점에서는 **불가**. 새 패키지를 만들 때부터 managed 2GP로 시작해야 한다.
- **참고**: 공식 가이드는 Trailhead의 *Second-Generation Managed Packages* 모듈도 권장한다.

---

## 2. 1GP에서 2GP로 — 핵심 변화 8가지

### 2-1. Source-Driven Development
managed 1GP는 packaging org를 **진실의 원천**으로 삼았다. managed 2GP는 그것을 버리고, **버전 관리 시스템 안의 메타데이터**를 진실의 원천으로 본다. 패키지 메타데이터는 더 이상 org가 아니라 VCS에서 관리된다.

### 2-2. Minimal Interaction with Salesforce Orgs
managed 1GP는 패키지·patch마다 별도 Salesforce org가 필요해서, 큰 ISV는 수백 개 org와 자격증명을 관리해야 했다. managed 2GP는 **단일 Dev Hub org** 하나로 모든 패키지를 관리한다. 접속 자체도 CLI/스크립트로 한다.

### 2-3. API · CLI-first Model
managed 1GP는 API 커버리지가 **부분적**이라 자동화에 한계가 있다. managed 2GP는 **모든** 패키징 작업이 API/CLI 명령으로 가능하다 → 진정한 repeatable, scriptable, track-able ALM.

### 2-4. Flexible Versioning
managed 1GP는 선형 버전 관리라 이전 버전 위에 무조건 쌓아 올려야 했고, **한 번 패키지에 들어간 메타데이터는 제거 불가**.
managed 2GP는 **고객에게 아직 배포하지 않은** managed-released 버전이라면 폐기(abandon)하고 이전 버전을 ancestor로 다시 선택할 수 있다. 브랜치를 활용한 병렬 패키지 개발도 가능.

### 2-5. One Namespace Shared Across Multiple Packages
managed 1GP는 패키지마다 고유 namespace 필요 → 패키지 간 코드 공유를 위해 `global` Apex가 비대해지는 문제.
managed 2GP는 **여러 패키지가 같은 namespace 공유 가능**. `@namespaceAccessible` 어노테이션으로 public Apex 클래스/메서드를 같은 namespace 패키지들 사이에서 공유 → global Apex footprint 감소.

```apex
// 구조 예시 — 실제 동작 코드 아님
// managed 2GP: 같은 namespace의 다른 패키지에서 호출 가능한 public 메서드
@namespaceAccessible
public class SharedHelper {
    @namespaceAccessible
    public static String formatLabel(String raw) {
        return raw.trim().toUpperCase();
    }
}
```

### 2-6. Declarative Dependencies
managed 2GP는 패키지 간 의존성을 **`.json` 파일에 선언적으로** 명시한다 (`sfdx-project.json` — 자세한 구조는 [[sfdx-project.json 레퍼런스]] 참조).

### 2-7. Simplified Patch Versioning
managed 1GP의 patch는 **patch org**라는 별도 환경을 만들어야 했다. managed 2GP는 patch 버전 생성도 일반 버전과 동일하게 CLI 한 줄 — `sf package version create`에 patch 번호만 0이 아닌 값으로 지정하면 끝.

### 2-8. Avoid Future Migration
Salesforce는 1GP → 2GP 마이그레이션 도구를 개발 중이지만, 출시되더라도 파트너 측에서 작업이 필요하다. 신규 패키지를 처음부터 managed 2GP로 시작하면 미래 마이그레이션 부담을 피할 수 있다.

---

## 3. 1GP vs 2GP 비교표

| 항목 | Managed 1GP | Managed 2GP |
|---|---|---|
| 진실의 원천 | packaging org | **버전 관리 시스템 (source-driven)** |
| Packaging/Patch org 사용 | ✅ 사용 | ❌ 사용 안 함 |
| 패키지 소유자 | packaging org | **Dev Hub** (메타데이터는 Dev Hub에 없음) |
| Dev Hub 위치 권장 | — | **Partner Business Org (PBO)** |
| 패키지 ↔ org 관계 | packaging org는 패키지 **하나만** 소유 | Dev Hub는 **여러 패키지** 소유 가능 |
| Namespace 생성 위치 | packaging org에서 생성 | **namespace org**에서 생성 후 Dev Hub에 link |
| Namespace ↔ 패키지 관계 | 1:1 (namespace는 한 패키지만) | **N:1** (여러 패키지가 같은 namespace 공유) |
| 패키지 간 Apex 공유 | `global` Apex만 가능 | `public` + **`@namespaceAccessible`** |
| 자동화 가능 작업 | 일부 작업 자동화 불가 (예: 패키지 생성·언인스톨) | **모든 패키징 작업** Salesforce CLI로 자동화 |
| 버전 관리 모델 | **선형** (이전 버전 위에만) | **유연**: 미배포 버전 폐기·브랜치·병렬 개발 가능 |
| Patch 버전 생성 | 전용 patch org 필요 | Salesforce CLI 한 줄 (patch 번호 ≠ 0) |
| 공통점 | 메타데이터 ↔ 패키지 연결, 버전·patch 이터레이션, AppExchange 보안 리뷰·등록, License Management App / Subscriber Support Console / Feature Management App 사용 가능 | 동일 |

---

## 4. 핵심 용어

| 용어 | 의미 |
|---|---|
| **Dev Hub** | managed 2GP 패키지·scratch org·namespace를 찾고 관리하는 지정 org. 활성화하면 이후 생성하는 모든 managed 2GP 패키지의 소유자가 된다. 한 번 활성화하면 **비활성화 불가**. |
| **Partner Business Org (PBO)** | Salesforce 파트너가 비즈니스를 운영하는 production org. **모든 ISV/OEM 파트너는 PBO를 Dev Hub로 지정**하는 것을 권장. |
| **Namespace org** | namespace 자체를 생성·등록하는 Developer Edition org. Dev Hub에 link되면 그 namespace를 managed 2GP에 사용할 수 있다. |
| **Scratch org** | 패키지 개발·테스트용 일회성 org. Dev Hub 인스턴스 위치에 따라 Government Cloud / Public Cloud로 생성 위치가 결정됨. ([[Scratch Org 생성과 정의 파일]]) |
| **Package version** | 생성 순간의 메타데이터·기능 집합을 담은 **불변(immutable) 아티팩트**. 같은 패키지는 계속 진화하지만 각 버전은 고정. |

---

## 5. Dev Hub 활성화 절차

```
1. Partner Business Org에 로그인
2. Setup → Quick Find: "Dev Hub" → Dev Hub 선택
3. [Enable Dev Hub] 체크          ← 활성화 후 비활성화 불가
4. [Enable Unlocked Packages and Second-Generation Managed Packages] 체크
                                   ← 이것도 활성화 후 비활성화 불가
```

> [!warning] Dev Hub는 sandbox에서 활성화할 수 없다. PBO(production)에서만 활성화 가능하다.

### 5-1. Edition 가용성

| Edition | Dev Hub 사용 가능? |
|---|---|
| Developer / Enterprise / Performance / Unlimited | ✅ |
| Sandbox | ❌ |
| Trial / Developer Edition을 Dev Hub로 쓸 때 | ⚠️ 제약 있음 (아래) |

### 5-2. Trial/Developer Edition org를 Dev Hub로 쓸 때 주의

- org 만료 시 연결된 **모든 패키지 접근 불가**.
- **하루 scratch org · 패키지 버전 6개 제한** / 동시 활성 scratch org 최대 3개.
- Trial은 만료일에, Developer Edition은 **비활성으로 만료 가능**.
- 만료된 비-production Dev Hub에 연결된 패키지는 **업데이트 불가**·새 설치 시 실패 가능.
- CI 파이프라인 등 본격 운영에는 **PBO를 Dev Hub로** 사용 권장.

### 5-3. Dev Hub 인스턴스 위치 ↔ Scratch org 위치
- Dev Hub가 **Government Cloud**에 있으면 → scratch org도 Government Cloud에 생성.
- Dev Hub가 **Public Cloud**에 있으면 → scratch org도 Public Cloud에 생성.

---

## 6. 패키지 개발 전 권한·라이선스

### 6-1. Salesforce Limited Access - Free 라이선스
- 개발자(커스터마이즈·앱 빌더) 전용. Dev Hub·개발 도구·환경에 접근 가능.
- production org에서는 **표준/커스텀 객체 접근이 제한**됨.
- PBO에 **100개 라이선스 기본 제공** (부족하면 Salesforce Partner Support에 케이스로 추가 요청).
- 일부 기능 제한:
  - **Org shape 생성·관리는 불가** — Salesforce 라이선스 필요.
  - View All Records 권한이 있으면 기존 org shape로 scratch org 생성 가능.
  - 일부 CLI 명령(예: `sf limits api display`)은 접근 불가.

### 6-2. managed 2GP 권한 세트 구성

```
[Object Settings]
  Scratch Org Info       → Read, Create, Delete
  Active Scratch Org     → Read, Delete
  Namespace Registry     → Read              ← linked namespace 사용 시

[System Permissions]
  Create and Update Second-Generation Packages
```

`Create and Update Second-Generation Packages` 권한이 부여하는 접근권:

| Salesforce CLI 명령 | Tooling API 객체 (Create/Edit) |
|---|---|
| `sf package create` | `Package2` |
| `sf package version create` | `Package2VersionCreateRequest` |
| `sf package version update` | `Package2Version` |

> [!note] scratch org 생성 시 `sfdx-project.json`에 ancestor 버전을 지정했다면 이 권한도 필요. 대안으로 `sf org create`에 `--noancestors` 플래그 사용.

---

## 7. 시작 전 최종 체크리스트

```
□ PBO에 Dev Hub와 Second-Generation Managed Packaging 활성화
□ Salesforce CLI 설치 (인증 방식은 [[DX 인증 방식]] 참조)
□ Namespace 생성 + Dev Hub에 link
□ 개발자에게 Limited Access 라이선스 + 권한 세트 부여
□ Source 관리할 VCS 결정 (Git 권장)
□ (선택) VS Code Salesforce Extension 설치
```

---

## 8. Unlocked Package와의 관계

managed 2GP와 Unlocked Package는 **둘 다 2GP 패키징 모델**을 공유한다 (source-driven, Dev Hub 소유, CLI 자동화). 차이는 **용도**에 있다.

| 구분 | Managed 2GP | Unlocked Package |
|---|---|---|
| 주 대상 | **AppExchange ISV/OEM 파트너** | 고객·시스템 통합자 |
| 가입 org에서의 상태 | **잠겨 있음** (수정 불가) | 풀려 있음 (수정 가능) |
| AppExchange 배포 | ✅ | 일반적이지 않음 |
| 메타데이터 조직화·내부 배포 | 가능하지만 과함 | **이쪽이 적합** |

→ "여러 고객 org에 같은 앱을 배포·관리·보호"가 목표면 managed 2GP, "자기 조직 메타데이터를 정리·재배포"가 목표면 Unlocked. ([[Unlocked Package 개념과 준비]])

---

## 관련 노트

- [[2GP Managed Package 개발 환경과 사전 준비]] — 이 페이지의 후속: namespace 생성·Dev Hub link·Key Concepts·Manageability Rules·Ancestry·의존성 매트릭스
- [[Salesforce DX 개요]] — DX 도구 전반 (CLI·sfdx-project·source format)
- [[Unlocked Package 개념과 준비]] — 2GP의 다른 한 갈래(잠기지 않은 패키지)
- [[Unlocked Package 릴리스와 설치]] — 패키지 버전 릴리스 흐름 (managed 2GP도 유사 패턴)
- [[sfdx-project.json 레퍼런스]] — 의존성·ancestor·packageDirectories 등 선언적 설정
- [[Scratch Org 생성과 정의 파일]] — 개발·테스트 환경 만들기
- [[Org Shape와 Snapshot]] — Limited Access 라이선스로 어디까지 가능한지
- [[DX 인증 방식]] — Dev Hub에 CLI로 로그인하는 방법
- [[2GP — LMA Part 1 Get Started]] — LMA 설치·권한·Lead·License 레코드·LMO 설정
- [[2GP — Feature Management App]] — Feature Parameters 3종·구독자별 기능 제어·FMA 전체
- [[2GP — App Analytics Part 1: Overview & Setup]] — AppExchange App Analytics 개요·ISV 사용량 데이터·CustomInteractions
