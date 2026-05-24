---
tags: [DevOps, Packaging, 2GP, ManagedPackage, Agentforce, DataCloud, ProtectedComponents, PlatformCache, MetadataAccess, PermissionSet, ProfileSettings, IP_Protection, NamespaceAccessible, DomainCreator, ConnectedApp, OrderSaveBehavior, 매니지드패키지, 특정메타데이터동작]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.314-333
created: 2026-05-24
aliases: [2GP Specific Metadata Behavior, Behavior of Specific Metadata in Second-Generation Managed Packages, 2GP 특정 메타데이터 동작, Package Agentforce Metadata, Package Data Cloud Metadata, Protected Components Managed Package, 보호 컴포넌트, Platform Cache Provider Free, Metadata Access Apex, Permission Sets Profile Settings Packages, Protecting Intellectual Property, Call Salesforce URLs Package, NamespaceAccessible annotation, Work with Services Outside Salesforce, Package Connected Apps 2GP, New Order Save Behavior, 2GP 메타데이터 동작 규칙]
---

# 2GP — Specific Metadata Behavior

> managed 2GP 패키지에서 **Agentforce·Data Cloud 메타데이터 패키징**, **보호 컴포넌트**, **Platform Cache 프로바이더 무료 용량**, **Metadata Access in Apex**, **Permission Sets vs Profile Settings**, **IP 보호**, **Salesforce URL 처리**, **@NamespaceAccessible**, **외부 서비스 연동**, **Connected App 패키징**, **New Order Save Behavior** 대응 방법을 전수 정리한다.

---

## 1. Package Agentforce Metadata Components

> Agentforce의 대화형 AI 기능을 패키지에 포함하는 방법.

패키지에 Agentforce 메타데이터를 추가하기 전 반드시:
- Agentforce를 활성화한 Scratch Org 접근 설정 완료 (Get Access to Scratch Orgs That Have Agentforce)
- Agent Action과 Topic을 **Agentforce Asset Library**에 생성 — 패키지 대상 Action/Topic은 반드시 Asset Library에 있어야 함

### 패키지 가능한 Agentforce 메타데이터

| Feature Name | Metadata Name | Available in | 참조 |
|---|---|---|---|
| Agent Actions | `GenAiFunction` | Managed 2GP, Managed 1GP | Agent Action |
| Agent Topics | `GenAiPlugin` | Managed 2GP, Managed 1GP | Agent Topic |
| Prompt Templates | `GenAiPromptTemplate` | Managed 2GP, Managed 1GP | Prompt Template |
| Agent Templates | `BotTemplate`, `GenAiPlannerBundle` | Managed 2GP, Managed 1GP | Bot Template, Gen AI Planner Bundle |

---

## 2. Develop and Package Agent Templates Using Scratch Orgs

> ISV는 Agent Template를 배포 단위로 사용한다. Agent를 패키지로 만드는 고수준 흐름:
> 1. namespaced scratch org에서 Agent 생성·테스트
> 2. DX 프로젝트로 retrieve
> 3. Salesforce CLI로 Agent Template 생성
> 4. 패키지로 묶기

**중요:** `Agent Script`를 blueprint로 사용하는 Agent로는 패키지 가능한 Agent Template을 만들 수 없다.

### 2-1. Agent와 Agent Template 메타데이터 구조

Agent를 구성하는 주요 메타데이터 타입:
- `Bot`
- `BotVersion`
- `GenAiPlannerBundle` — Agent의 Actions와 Subagent를 정의

`sf agent generate template` CLI 명령은:
1. 세 타입의 메타데이터 파일을 합쳐 특정 Agent(Bot + BotVersion)의 `BotTemplate` 파일 생성
2. 원본 `GenAiPlannerBundle` 파일과는 **다른** 새 `GenAiPlannerBundle` 파일 생성
   - 새 파일은 로컬 에셋 참조(패키지 불가) → 글로벌 에셋 참조로 교체
3. `BotTemplate` + 새 `GenAiPlannerBundle`을 이용해 managed package에 패키징

### 2-2. Agent 생성 단계

1. Setup에서 `Agentforce Agents` 검색
2. Agentforce 설정 활성화 후 페이지 새로고침
3. **New Agent** 클릭 → Agent 유형 선택 → 안내 단계 완료 → **Create**

Agentforce가 활성화된 scratch org에서는 Agentforce Testing Center 이용 가능.

### 2-3. DX 프로젝트와 Scratch Org 설정

- `BotTemplate` 메타데이터를 패키지에 포함하려면 Dev Hub org에 Einstein Chatbot 활성화 필요
- `project-scratch-def.json`에 해당 메타데이터 명시 필요

```bash
# Step 1 — 기존 DX 프로젝트의 Apex, Flow, Prompt Template를 scratch org에 배포
sf project deploy start --source-dir force-app --target-org MyNamespacedScratchOrg
```

```bash
# Step 2 — scratch org 열기
sf org open
```

### 2-4. Agentforce 패키지 개발 단계

```bash
# Step 1 — 관련 메타데이터를 DX 프로젝트로 retrieve
sf project retrieve start --metadata Agent:My_Awesome_Agent --target-org MyNamespacedScratchOrg
```

```bash
# Step 2 — Agent Template 메타데이터 소스 파일 생성
# Bot 메타데이터 파일로부터 특정 BotVersion의 agent template 생성
# --agent-version: 버전 번호 지정
# --source-org: scratch org 지정 (필수)
sf agent generate template --agent-file \
  force-app/main/default/bots/My_Awesome_Agent/My_Awesome_Agent.bot-meta.xml \
  --agent-version 1 --source-org MyNamespacedScratchOrg
```

```bash
# Step 3 — Agent Template 메타데이터 소스 파일을 scratch org에 배포
sf project deploy start --source-dir force-app --target-org MyNamespacedScratchOrg
```

```bash
# Step 4 — scratch org에서 agent template으로 새 agent를 생성해 동작 확인

# Step 5 — 패키지 디렉토리에서 아래 메타데이터 제거:
#   a. 원본 GenAiPlannerBundle (이름에 "Template"이 없는 것) — 새 GenAiPlannerBundle 생성에만 사용, 패키징 불필요
#   b. Bot과 BotVersion — 패키징 불가, 포함 시 오류 발생

# Step 6 — Prompt Template 패키징 시: sfdx-project.json에서 권한 할당 필요

# Step 7 — 패키지 버전 생성 (template + 모든 의존성: topics, actions, Apex, flows, prompt templates)
sf package version create \
  --package "Agentforce App" \
  --installation-key "HIF83kS8kS7C" \
  --definition-file config/project-scratch-def.json \
  --code-coverage --wait 10
```

구독자가 패키지를 Agentforce가 활성화된 org에 설치하면 Agentforce UI에서 이 template으로 Agent 생성 가능.

---

## 3. Package Data Cloud Metadata Components

> 관리형 패키지에 Data Cloud 메타데이터를 포함하는 방법. 고유한 요건이 있으므로 반드시 검토한다.

### 3-1. Data Cloud for Scratch Orgs 활성화

- Partner Business Org에서 Dev Hub 활성화 필요
- Salesforce Partner Support에 케이스를 로그해 Data Cloud for Scratch Orgs 활성화 요청
- Data Cloud for Scratch Orgs는 Partner Business Org의 Dev Hub에 연결된 scratch org에서만 사용 가능

### 3-2. 전용 Data Cloud 패키지 생성

Data Cloud 메타데이터를 포함한 managed package를 만들 때:
- **Data Cloud 메타데이터는 다른 Salesforce 메타데이터와 분리**해 별도 패키지 생성
- 전용 Data Cloud 패키지와 관련 패키지 간에 **패키지 의존성** 설정

### 3-3. Data Kit에 Data Cloud 메타데이터 추가

Data Cloud 메타데이터를 패키징할 때:
1. 메타데이터를 **data kit**에 추가
2. data kit을 managed package에 추가

Data kit은 패키지 생성·설치 프로세스를 간소화한다.

### 3-4. Data Cloud One Companion Connected Orgs 제약

Data Cloud One companion org로 연결된 org에는 패키지 설치 불가.

- Data Cloud 고객이 Data Cloud 메타데이터를 포함한 managed package를 설치할 때 → **Data Cloud home org**에 설치
- Data Cloud One 사용 시: home org에 설치된 패키지가 companion org에 공유된 data space에 자동 설치됨
- Companion org로 업그레이드 자동 적용

Companion connected org에서 **불가한** 작업 (home org에서만 수행):
- managed package 설치
- managed package 언인스톨
- 패키지 메타데이터 삭제
- 패키지 push upgrade 수신

---

## 4. Protected Components in Managed Packages

> 개발자는 특정 컴포넌트를 **protected(보호)**로 표시할 수 있다.

**보호 컴포넌트 특성:**
- 구독자 org에서 생성된 컴포넌트가 이 컴포넌트를 링크하거나 참조할 수 없음
- 개발자는 설치 실패 걱정 없이 미래 릴리즈에서 보호 컴포넌트를 삭제할 수 있음
- **단, 한 번 unprotected로 전환하고 globally released 상태가 되면 삭제 불가**

**managed package에서 protected로 표시 가능한 컴포넌트:**
- Custom labels
- Custom links (Home page only)
- Custom metadata types
- Custom objects
- Custom permissions
- Custom settings
- Workflow alerts
- Workflow field updates
- Workflow outbound messages
- Workflow tasks

**Subscriber Sandbox에서 보호 커스텀 오브젝트 고려사항:**
- 구독자가 sandbox template을 이용해 full 또는 partial sandbox를 생성하면, 보호 커스텀 오브젝트가 복사 대상 오브젝트 목록에 표시되지 않음
- 결과적으로 보호 커스텀 오브젝트의 레코드 데이터는 해당 sandbox에 복사되지 않음
- Sandbox template 없이 full sandbox를 생성하면 보호 커스텀 오브젝트의 데이터도 복사됨

---

## 5. Set Up a Platform Cache Partition with Provider Free Capacity

> Salesforce는 보안 심사(security-reviewed) 완료된 managed package에 **3 MB 무료 Platform Cache 용량**을 제공한다. 이를 **Provider Free 용량**이라고 하며 모든 Developer Edition org에 자동 활성화되어 있다.

```
// Provider Free 용량 특성:
// - 보안 심사된 managed package 전용
// - Developer edition org에 자동 활성화
// - 설치 후 post-install 스크립트나 수동 할당 불필요
// - 비 AppExchange 인증/보안 심사 패키지 → 설치 시 Provider Free 용량이 0으로 리셋
```

### Platform Cache Partition 생성 절차

1. Setup → Quick Find에서 **Platform Cache** 검색 → **Platform Cache** 선택
   - Org's Capacity Breakdown 도넛 차트에서 Provider Free 용량 확인 가능
2. **New Platform Cache Partition** 클릭
3. **Label** 입력 (알파뉴메릭 문자만, org 내 유일해야 함)
4. **Description** 입력 (선택)
5. **Capacity 섹션**에서 Session Cache와 Org Cache에 Provider Free 용량을 각각 배분
6. 새 Platform Cache Partition 저장

설치된 partition의 Provider Free 용량은 수정 불가. 설치된 partition 1개의 용량을 다른 partition에 사용 불가.

설치 후 partition을 편집해 org의 추가 Platform Cache 용량을 할당할 수 있다.

---

## 6. Metadata Access in Apex Code

> Apex의 `Metadata` 네임스페이스를 사용해 패키지 내 메타데이터에 접근하는 방법.

패키지는 설치나 업데이트 중에 메타데이터를 retrieve하거나 수정할 수 있다. `Metadata` 네임스페이스 in Apex는 메타데이터 타입을 나타내는 클래스와 구독자 org에 메타데이터 컴포넌트를 retrieve·deploy하는 클래스를 제공한다.

**Apex에서 메타데이터 접근 시 제약:**

```apex
// Apex에서 메타데이터 접근 제약사항:
// - create, retrieve, update는 가능. delete는 불가.
// - 현재 접근 가능한 레코드: custom metadata types, page layouts
// - Salesforce 미승인 managed package는 구독자 org의 메타데이터에 접근 불가.
//   (예외: 구독자 org에서 "Allow metadata deploy by Apex from non-certified Apex package version" 조직 환경 설정 활성화 시)
```

패키지가 설치·업데이트 중에 메타데이터에 접근하거나, 메타데이터에 접근하는 커스텀 setup 인터페이스를 포함하면 **사용자에게 반드시 공지**해야 한다.

공지 샘플 문구 (패키지 설명에 포함):
```
This package can access and change metadata outside its namespace in the Salesforce
org where it's installed.
```

Salesforce는 보안 검토 중 이 공지를 검증한다.

---

## 7. Permission Sets and Profile Settings in Packages

> Permission Sets, Permission Set Groups, Profile Settings 비교 및 패키지에서의 동작 방식.

**원칙:** Permission Sets로 지원되지 않는 특정 접근 방식이 필요한 경우에만 Profile Setting을 사용. 그 외 모든 경우에는 Permission Sets 또는 Permission Set Groups 사용.

### 7-1. Permission Sets vs Profile Settings 비교표

| 동작 | Permission Sets | Profile Settings |
|---|---|---|
| 포함되는 권한/설정 | Custom app permissions, Custom object/field permissions, External object permissions, Custom metadata types permissions, Custom permissions, Custom settings permissions, Custom tab visibility, Apex class access, Visualforce page access, External data source access, Record types | Assigned custom apps, Assigned connected apps, Tab settings, Page layout assignments, Record type assignments, Custom metadata type permissions, Custom field permissions, Custom object permissions, Custom permissions, Custom settings permissions, External object permissions, Apex class access, Visualforce page access, External data source access |
| managed package에서 업그레이드 가능? | Yes | 설치/업그레이드 시 구독자 org의 기존 프로필에 적용 (새 컴포넌트 관련 권한만) |
| 구독자가 편집 가능? | No | Yes |
| 클론/생성 가능? | Yes (단, 클론된/구독자 생성 permission set은 이후 업그레이드에서 갱신 안 됨) | Yes (기존 프로필 클론 가능) |
| 표준 오브젝트 권한 포함? | No (master-detail에서 master가 표준 오브젝트인 custom object permissions도 불포함) | No |
| 유저 권한 포함? | No | No |
| 설치 위자드에 포함? | No (설치 후 구독자가 직접 할당) | Yes (설치/업그레이드 시 기존 프로필에 자동 적용) |
| 유저 라이선스 요건 | Permission set 설치는 구독자 org에 해당 라이선스가 최소 1개 있어야 함. 라이선스 없는 permission set은 항상 설치됨 | 구독자 유저 라이선스 override 없음 |
| 사용자 할당 방법 | 설치 후 구독자가 직접 할당 | 기존 프로필에 적용 |
| Extension package에서 base package objects 권한 부여? | 불가 (extension permission set이 base package의 parent object 또는 연관 child object 접근 권한 수정 불가) | Permission set과 동일 동작 |

**Best Practices:**
- 앱, 표준 탭, 페이지 레이아웃, 레코드 타입에 대한 접근이 필요한 사용자에게는 permission set만을 유일한 권한 부여 모델로 사용하지 않는다.
- 패키지의 커스텀 컴포넌트에 대한 접근 권한을 부여하는 packaged permission sets를 생성하되, 표준 Salesforce 컴포넌트는 포함하지 않는다.
- Permission sets는 assigned apps와 tab settings를 포함하지 않는다.

### 7-2. Permission Set Groups

Permission Set Groups에 permission set을 묶어 1GP와 2GP managed package에 포함 가능. Package upgrade 시 갱신 가능.

**주의사항:**
- Permission Set License에 의해 제한된 permission set은 managed/unmanaged package에 추가 불가
- 패키지에 포함된 메타데이터에 대한 권한만 패키징 가능
- 패키지 upgrade의 일부로 permission set group에서 permission set 추가/제거 가능
- 구독자는 muting permission이나 로컬 permission set 추가/제거로 permission set group을 수정할 수 있으나, managed package의 included permission set을 제거할 수는 없음

### 7-3. Custom Profile Settings

Custom profile을 만들 때 권장 사항:
- 프로필 이름에 앱 소속을 명시 (예: "HR2GO Approving Manager")
- 계층 구조가 있으면 이름에 위치 표시 (예: "HR2GO Level 2 Approving Manager")
- 다른 org에서 다르게 해석될 수 있는 이름 피하기
- 각 프로필에 의미 있는 설명 제공

### 7-4. 2GP에서 Profile Settings 처리 방식

**패키지 버전 생성 시:**
- Build 시스템이 DX 프로젝트 디렉토리의 **모든** 프로필 내용을 검사 (지정된 경로의 디렉토리뿐만 아니라)
- 패키지의 메타데이터와 **직접 관련된** 프로필 설정만 유지
- 프로필 자체와 패키지 메타데이터와 무관한 설정은 패키지에서 제외

**패키지 설치 시:**
- 유지된 프로필 설정이 구독자 org의 **기존 프로필**에만 적용됨
- 프로필 자체는 구독자 org에 설치되지 않음
- 어떤 프로필 설정이 포함될지 제어하려면 프로젝트 설정 파일의 `scopeProfiles` 파라미터 사용
- 프로필만 포함하고 다른 메타데이터가 없는 패키지는 패키지 버전 생성 시 실패

**설치 옵션에 따른 적용 프로필:**

| 선택 옵션 | 적용 대상 | 설치 방법 |
|---|---|---|
| Install for Admins Only | 구독자 org의 System Administrator 프로필 | 패키지 설치 페이지, `sf package install` CLI (기본 동작) |
| Install for All Users | System Administrator 프로필 및 모든 클론 프로필, Custom object CRUD 접근은 System Administration 프로필에 자동 부여 | 패키지 설치 페이지, `sf package install --security-type AllUsers` |
| Install for Specific Profiles | 구독자 org의 특정 프로필 | 패키지 설치 페이지만 (CLI 불가) |

```bash
# 모든 사용자에게 설치 (CLI)
sf package install --security-type AllUsers
```

**Push Upgrade 주의:** Push upgrade 시 Apex classes와 field-level security 관련 일부 프로필 설정이 System Admin 프로필에 자동 할당되지 않을 수 있다. Push upgrade 후 고객에게 프로필 설정 검토·업데이트를 안내한다.

---

## 8. Protecting Your Intellectual Property

> 커스텀 오브젝트, 커스텀 링크, 보고서 등 설치된 항목의 세부 내용은 악의적 콘텐츠 확인을 위해 설치자에게 공개된다. 단, 개발자의 일부 IP를 보호하는 방법이 있다.

**IP 보호 원칙:**
- 본인의 IP이고 공유 권한이 있는 패키지 컴포넌트만 게시
- AppExchange에 공개된 컴포넌트는 설치한 사람으로부터 회수 불가
- 공식(formula), VF 페이지, 숨길 수 없는 컴포넌트에 코드를 추가할 때 주의

**Apex 코드 IP 보호:**
- Managed package에 포함된 Apex class, trigger, Lightning, Visualforce 컴포넌트의 코드는 **난독화(obfuscated)**되어 설치 org에서 볼 수 없음
- 예외: `global`로 선언된 메서드 — 설치 org에서 global 메서드 시그니처는 볼 수 있음
- LMO(License Management Org) 사용자가 "View and Debug Managed Apex" 권한을 가지면 Subscriber Support Console을 통해 구독자 org에 로그인해 난독화된 Apex class 확인 가능

**Protected Custom Setting:**
- Managed package에 포함된 Custom Setting의 Visibility가 Protected면 구독자 org의 패키지 컴포넌트 목록에 표시되지 않음
- Custom Setting의 모든 데이터가 구독자에게 숨겨짐

---

## 9. Call Salesforce URLs Within a Package

> 패키지에서 Salesforce URL을 참조할 때 org 유형·설정에 따라 URL 형식이 달라진다. 모든 URL 형식을 지원하는 패키지를 만들기 위해 **가능하면 상대 URL을 사용**하고, 전체 URL이 필요하면 `System.DomainCreator` Apex 클래스를 사용한다.

**배경:**
- Production과 sandbox org의 My Domain URL 형식이 다름
- Partitioned domains의 경우 demo, Developer Edition, free, patch, scratch org 등에서 hostname 형식이 다양
- 현재 sandbox My Domain login hostname 형식 2가지, Visualforce hostname 형식 10가지 등 복잡

**`System.DomainCreator` API 버전:** v54.0 이상에서 사용 가능

### 9-1. My Domain Login URL 가져오기

```apex
// My Domain login hostname 가져오기
String myDomainHostname = DomainCreator.getOrgMyDomainHostname();
// 예: production org, My Domain 이름이 "mycompany"인 경우
// → mycompany.my.salesforce.com
```

### 9-2. 상대 URL 사용 (권장)

```apex
// 구조 예시 — 상대 URL 사용 (Visualforce page 링크)
// 전체 URL: https://MyDomainName--PackageName.vf.force.com/apex/myCases
// 같은 도메인 내 다른 VF 페이지 링크:
String relativeUrl = '/apex/newCase';
// 전체 URL 대신 상대 경로를 사용하면 org 유형에 무관하게 작동
```

### 9-3. 전체 URL이 필요한 경우 — Hostname 생성

```apex
// 패키지명 정의
String packageName = 'abcpackage';

// Visualforce hostname 가져오기
String vfHostname = DomainCreator.getVisualforceHostname(packageName);

// 새 케이스 생성 VF 페이지 URL 빌드
System.URL vfNewCaseUrl = new URL('https', vfHostname, '/apex/newCase');

// 예: enhanced domains + My Domain 이름 "mycompany" + 패키지 "abcpackage" production org
// → https://mycompany--abcpackage.vf.force.com/apex/newCase
```

### 9-4. URL의 일부 파싱 — DomainParser 사용

```apex
// 알려진 URL을 파싱해 도메인 정보 추출
System.Domain domain = DomainParser.parse('https://mycompany--abcpackage.vf.force.com');

// 도메인 타입 가져오기
System.DomainType domainType = domain.getDomainType();
// → VISUALFORCE_DOMAIN

// org의 My Domain 이름 가져오기
String myDomainName = domain.getMyDomainName();
// → mycompany

// 패키지 이름 가져오기
String packageName = domain.getPackageName();
// → abcpackage
```

특정 URL 형식을 파싱해 값을 추출하는 코드는 형식이 바뀌면 실패할 수 있으므로, 위 Apex 클래스들을 사용한다.

---

## 10. Namespace-Based Visibility for Apex Classes in Second-Generation Managed Packages

> `@NamespaceAccessible` annotation을 사용하면 패키지의 public Apex를 **같은 namespace를 사용하는 다른 패키지**에서 접근할 수 있게 된다.

**기본 동작:**
- annotation 없이 2GP managed package에 정의된 Apex class, method, interface, property는 같은 namespace를 공유하는 다른 패키지에서 접근 불가
- `global`로 선언된 Apex는 annotation 없이도 모든 namespace에서 접근 가능

### 10-1. @NamespaceAccessible 사용 고려사항

- `@AuraEnabled` Apex 메서드나 `@InvocableMethod` Apex 메서드에는 사용 불가
- managed released 코드에도 언제든지 annotation 추가/제거 가능 (단, 다른 패키지가 의존하고 있는지 반드시 확인)
- annotation 추가/제거 전, push upgrade 시 실패할 수 있는 설치 버전이 있는지 확인
- public interface가 `@NamespaceAccessible`로 선언되면 모든 interface member가 annotation 상속 — 개별 member에 annotation 불가
- public/protected 변수나 메서드가 `@NamespaceAccessible`이면, 해당 클래스도 global이거나 `@NamespaceAccessible`인 public이어야 함
- public/protected inner class가 `@NamespaceAccessible`이면, enclosing class도 global이거나 `@NamespaceAccessible`인 public이어야 함

### 10-2. @NamespaceAccessible 예제

```apex
// Namespace 내에서 접근 가능한 Apex 클래스
@NamespaceAccessible
public class MyClass {
    private Boolean bypassFLS;

    // Namespace 내에서 접근 가능한 생성자 — 안전한 사용만 허용
    @NamespaceAccessible
    public MyClass() {
        bypassFLS = false;
    }

    // Package private 생성자 — 패키지 내부의 신뢰된 컨텍스트에서만 사용
    // @NamespaceAccessible 없음 → 같은 namespace의 다른 패키지에서 접근 불가
    public MyClass (Boolean bypassFLS) {
        this.bypassFLS = bypassFLS;
    }

    @NamespaceAccessible
    protected Boolean getBypassFLS() {
        return bypassFLS;
    }
}
```

---

## 11. Work with Services Outside of Salesforce

> Salesforce 데이터가 변경될 때 외부 서비스를 업데이트하거나, 외부 변경 시 Salesforce를 업데이트하는 패키지 구성 방법.

외부 서비스 연동 방법:
- custom link 또는 formula field로 외부 서비스에 정보 전달
- Platform API로 데이터 주고받기
- Apex class의 Web service method 활용

**보안 경고:** 외부 서비스 내에 username과 password를 저장하지 않는다.

### 11-1. 외부 서비스 프로비저닝

외부 서비스와 링크되는 앱의 경우, 설치 사용자가 서비스에 가입해야 한다. 두 가지 접근 방식:
- 개인 식별이 불필요한 org 전체 사용자 접근
- 개인 식별이 중요한 사용자별 접근

Salesforce는 두 가지 globally unique ID를 제공:
- **User ID** — 개인 식별, 모든 org에서 고유, 재사용 없음
- **Organization ID** — org 고유 식별

**권고 사항:**
- email 주소, 회사명, Salesforce username으로 외부 서비스 접근 제공 금지 (username은 변경될 수 있고, email/회사명은 중복 가능)
- SSO(Single Sign-On) 기법으로 새 사용자 식별
- 각 진입점(custom link, web tab)에 parameter string에 user ID 포함
  - 서비스가 user ID를 검사해 알려진 사용자인지 확인
  - parameter string에 session ID 포함 → 서비스가 Lightning Platform API로 읽어 사용자의 활성 세션·인증 확인
- 알려진 사용자에게는 외부 서비스 제공, 신규 사용자에게는 정보 수집 페이지 표시
- 개인별 패스워드 저장 금지 (보안 위험 + 정기 비밀번호 리셋 문제)
- 비동기 업데이트가 필요한 경우 별도 관리자 user license 할당

---

## 12. Package Connected Apps in Second-Generation Managed Packaging

> 2GP managed package에 connected app을 추가하는 방법.

**참고:** External Client Apps 사용을 고려한다 — connected app의 개선된 새 세대.

### 12-1. Connected App 패키징 절차

1. **1GP managed package 생성** 후 connected app 추가 (2GP와 동일한 namespace 사용)
   - connected app의 버전 번호 기록

2. **Packaging org에서 1GP 패키지를 upload**해 패키지 버전 생성

3. **1GP 버전을 released 상태로 promote**
   - 이 단계가 connected app을 2GP managed package에 포함할 수 있게 해줌
   - 1GP 버전을 org에 설치할 필요 없음

4. **connected app 소스 탐색** 또는 개발 중인 org에서 source pull

5. **2GP 디렉토리에 소스 .xml 파일 생성** 후 포함할 connected app 참조

6. **2GP managed package 생성** 후 connected app 소스 코드 수동 추가
   - `sf project retrieve start`나 Metadata API `retrieve()`로 추가 불가 — 반드시 수동으로 소스 코드 추가

### 12-2. 소스 파일 예시

```xml
<ConnectedApp xmlns="http://soap.sforce.com/2006/04/metadata">
  <developerName>db_0110_ns4__A_Connected_App</developerName>
  <label>A Connected App</label>
  <version>1.0</version>
</ConnectedApp>
```

- `developerName`: namespace(db_0110_ns4) + connected app 이름(A_Connected_App) 조합
- `version`: connected app의 버전 번호 (decimal 형식)
  - 1GP 패키지에 추가되기 **이전** 버전 번호를 사용
  - 1GP 패키지에 추가되면 버전 번호가 자동 증가 (예: 4.0 → 1GP에서 5.0으로 증가하면, 소스 파일에는 4.0 기재)

---

## 13. Test and Respond to the New Order Save Behavior

> Order object를 포함하는 패키지가 새 Order Save Behavior에 대응하는 방법.

**Enable New Order Save Behavior 설정:**
- Order item 레코드 업데이트로 parent order 레코드가 변경될 때, Salesforce가 커스텀 application logic을 올바르게 평가·실행하도록 도움
- 이 설정이 활성화되면 Order item 레코드 업데이트가 parent order 레코드를 변경할 때마다 다음이 평가·실행됨:
  - Order·Order item 유효성 검사 규칙
  - Order·Order item Apex triggers·classes
  - Order·Order item Flow·Process

**영향 범위:** 모든 패키지 유형 (unlocked, unmanaged, 1GP, 2GP)

새 Order Save Behavior를 사용하는 subscriber org에, 구 동작을 지원하는 패키지를 설치할 수 있다. 단, 새 동작과의 호환성 검증 필수.

### 13-1. Unmanaged / 1GP 패키지 테스트

1. Setup → **Release Updates** 검색 → Release Updates 선택
2. **Enable New Order Save Behavior** 타일 찾아 **Enable Test Run** 선택
3. order 또는 order item 수정 시 새 동작의 영향 테스트
   - 검토 대상: 유효성 검사 규칙, Apex trigger·class, workflow rule, flow, process
4. 패키지가 새 Order Save Behavior와 호환됨을 증명하려면:
   - Setup → Package 검색 → 테스트한 패키지 선택 → **Upload**
   - **Package Requirements 섹션**에서 **New Order Save Behavior** 비활성화
   - 이 설정이 비활성화되고 release update가 활성화된 경우, 새/구 Order Save Behavior 모두에서 패키지 설치 가능

### 13-2. Unlocked / 2GP 패키지 테스트

1. scratch org 생성 후 Release Update 활성화
2. Setup → **Release Updates** 검색 → **Enable New Order Save Behavior** 타일 → **Enable Test Run**
3. order 또는 order item 수정 시 새 동작 영향 테스트
4. 패키지 버전 생성 시 definition file에 Order Save Behavior 지정:

### 13-3. Order Save Behavior 설정 옵션

**구 Order Save Behavior (Old):**
```json
{
  "features": [],
  "settings": {
    "orderSettings": {
      "enableOrders": true
    }
  }
}
```

**신 Order Save Behavior (New):**
```json
{
  "features": ["OrderSaveLogicEnabled"],
  "settings": {
    "orderSettings": {
      "enableOrders": true
    }
  }
}
```

**구·신 Order Save Behavior 모두 지원 (Both):**
```json
{
  "features": ["OrderSaveBehaviorBoth"],
  "settings": {
    "orderSettings": {
      "enableOrders": true
    }
  }
}
```

---

## 관련 노트

- [[2GP Managed Package 개발 환경과 사전 준비]] — Manageability Rules 기초, Package Ancestry, Dependency Matrix
- [[2GP Managed Package — Workflow]] — 2GP 표준 CLI 워크플로 10단계, 지원 컴포넌트 전수 목록
- [[2GP Managed Package Scratch Org 워크플로]] — Agentforce scratch org, Data Cloud scratch org 설정 상세
- [[2GP — Components: Security & Access]] — Permission Set, Permission Set Group, Profile 패키징 규칙 (Manageability Rules 4속성)
- [[2GP — Components: Einstein & Analytics]] — GenAiFunction, GenAiPlugin, GenAiPlannerBundle, BotTemplate Manageability Rules
- [[2GP — Components: Integration & Platform]] — PlatformCachePartition, FeatureParameter, NamedCredential 패키징 규칙
- [[sfdx-project.json 레퍼런스]] — scopeProfiles, ancestorId, versionNumber, definitionFile 파라미터 전수
- [[Unlocked Package 개발과 버전]] — sf package version create Async/Skip Validation, 버전 번호 NEXT 키워드
- [[2GP — Develop]] — sf package create·version create 전수, MAJOR.MINOR.PATCH.BUILD, Ancestor 지정, Promote 75% 커버리지
