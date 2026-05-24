---
tags: [DevOps, Packaging, 2GP, ManagedPackage, Workflow, Components, ManageabilityRules, PackageVersion, 매니지드패키지, 패키지워크플로, 지원컴포넌트]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.23-25
created: 2026-05-23
aliases: [2GP 워크플로, managed 2GP workflow, 2GP CLI 워크플로, sf package create workflow, Workflow for Second-Generation Managed Packages, Components Available in Second-Generation Managed Packages, 2GP 지원 컴포넌트, Manageability Rules 표, Editable Properties, IP Protection, Package Developer Can Remove, Subscriber Can Delete]
---

# 2GP Managed Package — Workflow & 지원 컴포넌트

> managed 2GP의 **표준 CLI 워크플로 10단계**와 **패키지에 포함 가능한 메타데이터 컴포넌트 manageability 규칙**. 사전 준비는 [[2GP Managed Package 개발 환경과 사전 준비]], scratch org 세부는 [[2GP Managed Package Scratch Org 워크플로]] 참조.

---

## 1. Workflow for Second-Generation Managed Packages

managed 2GP 패키지를 커맨드라인에서 직접 생성·설치하는 **10단계 표준 워크플로**.
시작 전 반드시 "Before You Create Second-Generation Managed Packages" ([[2GP Managed Package 개발 환경과 사전 준비]]) 체크리스트를 완료해야 한다.

### 1-1. 전체 10단계

```bash
# Step 1 — DX 프로젝트 생성
sf project generate --output-dir expense-manager-workspace --name expenser-app

# Step 2 — Dev Hub org 인증
sf org login web --set-default-dev-hub
# --set-default-dev-hub 옵션 포함 필수
# 팁: 각 org에 alias를 지정하면 명령마다 username을 생략할 수 있고
#     패키지 개발 사이클 반복 시 org 전환이 쉬워진다

# Step 3 — 개발용 scratch org 생성 + 앱 개발
# expenser-app 디렉토리로 이동 후:
sf org create scratch --definition-file config/project-scratch-def.json
# scratch org 안에서 VS Code + Setup UI로 패키지에 넣을 메타데이터 작성·수집

# Step 4 — 패키지 디렉토리에 컴포넌트가 있는지 확인
# 이 워크플로를 그대로 따라 하려면 최소 메타데이터 1개 이상이 있어야 다음 단계로 넘어갈 수 있다

# Step 5 — sfdx-project.json에 namespace 지정
# "namespace": "exp-mgr"
# Step 1에서 이미 namespace를 지정했다면 건너뜀
# 중요: namespace 추가 전에 Dev Hub에 link되어 있는지 확인
#        ([[2GP Managed Package 개발 환경과 사전 준비]] → namespace Dev Hub link)

# Step 6 — 패키지 생성
sf package create --name "Expense Manager" --path force-app --package-type Managed
# 이 명령으로 생성된 managed 2GP 패키지는 sfdx-project.json의 namespace를 갖는다
# 주의: 패키지 생성 후 namespace 변경·추가 불가, Dev Hub 변경 불가
```

Step 6 실행 후 CLI가 `sfdx-project.json`을 자동 업데이트한다:

```json
// 구조 예시 — Step 6 실행 후 sfdx-project.json 자동 업데이트 결과 (PDF 원문)
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true,
      "package": "Expense Manager",
      "versionName": "ver 0.1",
      "versionNumber": "0.1.0.NEXT"
    }
  ],
  "namespace": "exp-mgr",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "51.0",
  "packageAliases": {
    "Expense Manager": "0Hoxxx"
  }
}
```

> `versionName`, `versionNumber`는 placeholder — 직접 수정 가능. 의존 패키지가 있다면 이 시점에 추가.
> `--definition-file` 플래그나 `sfdx-project.json`의 `definitionFile` 필드로 scratch org definition file을 지정해 패키지 메타데이터에 필요한 features·settings를 선언한다.
> 상세: [[sfdx-project.json 레퍼런스]]

```bash
# Step 7 — sfdx-project.json 검토 (자동 업데이트 내용 확인)

# Step 8 — 패키지 버전 생성
sf package version create --package "Expense Manager" --code-coverage --installation-key test1234 --wait 10
# force-app 디렉토리 안의 패키지 메타데이터로 버전 생성

# Step 9 — 테스트용 scratch org에 패키지 버전 설치 후 검증
# Step 3에서 쓴 scratch org와 다른 scratch org 사용 (구독자 환경 시뮬레이션)
sf package install --package "Expense Manager@0.1.0-1" --target-org MyTestOrg1 --installation-key test1234 --wait 10 --publish-wait 10

# Step 10 — scratch org 열어서 패키지 상태 확인
sf org open --target-org MyTestOrg1
```

### 1-2. 워크플로 주요 포인트

| 단계 | 핵심 포인트 |
|---|---|
| Step 2 `--set-default-dev-hub` | 이후 `sf package` 명령에서 Dev Hub username 생략 가능 |
| Step 5 namespace | **한 번 지정 후 변경 불가** — sfdx-project.json 수정 전 반드시 Dev Hub link 완료 확인 |
| Step 6 `sf package create` | **이 명령을 실행한 Dev Hub가 패키지 소유자** — 나중에 이전 불가 |
| Step 8 `--code-coverage` | 코드 커버리지 75% 요건 (managed 패키지 promote 시 필수) |
| Step 9 다른 scratch org 사용 | Step 3 개발 org와 다른 org → 구독자 org 조건 시뮬레이션 |
| 버전 promote/release | 이 워크플로 이후 단계. "Release a Second-Generation Managed Package" 참조 |

> [!important] 패키지 버전은 **promote 전까지 beta 상태**다. beta 버전은 내부 테스트용이며 AppExchange에 배포하려면 promote해야 한다.

### 1-3. SEE ALSO

- Before You Create Second-Generation Managed Packages → [[2GP Managed Package 개발 환경과 사전 준비]]
- Namespace 생성·등록 → [[2GP Managed Package 개발 환경과 사전 준비]] (Namespace 섹션)
- Project Configuration File for a Second-Generation Managed Package → [[sfdx-project.json 레퍼런스]]
- Release a Second-Generation Managed Package (promote·배포) — 별도 topic

---

## 2. Components Available in Second-Generation Managed Packages

managed 2GP에 포함할 수 있는 메타데이터 컴포넌트 각각에는 **구독자 org에서의 동작을 결정하는 manageability rules**가 있다. 컴포넌트 목록을 보기 전 이 규칙들의 의미를 먼저 이해해야 한다.

### 2-1. Manageability Rules — 4가지 속성 정의

PDF Table 1: Manageability Rules

#### (1) Component Can Be Updated During Package Upgrade

| 값 | 의미 |
|---|---|
| **Yes** | 패키지 upgrade 시 컴포넌트가 업데이트된다. 초기 install에서 구독자 org에 deploy되고, 이후 upgrade 때마다 갱신. |
| **No** | 패키지 upgrade 시 컴포넌트가 **업데이트되지 않는다**. 초기 install에서만 deploy. 이후 upgrade는 이 컴포넌트에 영향 없음. 이 카테고리의 컴포넌트는 보통 구독자 admin이 수정 가능. |

#### (2) Subscriber Can Delete Component

| 값 | 의미 |
|---|---|
| **Yes** | 구독자(설치자)가 자신의 org에서 패키지 컴포넌트를 **삭제할 수 있다**. 삭제된 컴포넌트는 패키지 upgrade 시 재설치되지 않는다. |
| **No** | 구독자(설치자)가 자신의 org에서 패키지 컴포넌트를 **삭제할 수 없다**. |

#### (3) Package Developer Can Remove Component

| 값 | 의미 |
|---|---|
| **Yes** | 패키지가 promote·release된 후에도, 패키지 개발자가 향후 패키지 버전에서 이 컴포넌트를 **제거할 수 있다**. 대부분의 경우 제거는 컴포넌트를 deprecated 처리하며 구독자 org에서 즉시 hard delete하지 않는다. deprecated 컴포넌트는 구독자 admin이 삭제 가능. 어떤 컴포넌트가 deprecated인지 상세는 "Remove Metadata Components from Second-Generation Managed Packages" 참조. 이 기능에 접근하려면 Salesforce Partner Community에 support case 등록 필요. |
| **No** | 패키지가 promote·release된 후에는, 패키지 개발자가 향후 버전에서 이 컴포넌트를 **제거할 수 없다**. |

#### (4) Component Has IP Protection

| 값 | 의미 |
|---|---|
| **Yes** | 개발자의 IP를 보호하기 위해 컴포넌트의 메타데이터(Apex 코드, Custom Metadata 레코드 정보 등)가 **설치된 org에서 숨겨진다**. |
| **No** | 컴포넌트가 구독자 org에서 **보인다**. |

### 2-2. Editable Properties After Package Promotion or Installation

managed 패키지가 설치된 후 편집 가능한 속성의 3가지 카테고리:

| 카테고리 | 의미 | 예시 |
|---|---|---|
| **Only Package Developer Can Edit** | 패키지 개발자만 특정 컴포넌트 속성을 편집 가능. 구독자 org에서는 잠김. 패키지 upgrade 시 개발자 변경이 구독자 org에 적용됨. | Apex class 코드, permission set의 custom permission |
| **Both Subscriber and Package Developer Can Edit** | 구독자·개발자 모두 편집 가능. 단 개발자 변경은 **신규 구독자 설치 시에만** 적용 — 기존 구독자의 변경을 덮어쓰지 않도록. | custom field의 help text, custom object의 page layout |
| **Neither Subscriber or Package Developer Can Edit** | 패키지가 promote·release된 후에는 개발자도 구독자도 편집 불가. 완전히 잠김. | 패키지 컴포넌트의 API 이름 |

> [!note] "Both ... Can Edit" 카테고리의 핵심: 구독자가 자신의 page layout이나 help text를 수정해도 향후 패키지 upgrade에 의해 그 수정이 덮어쓰이지 않는다 — 구독자 신뢰를 위한 설계.

### 2-3. Supported Components in Second-Generation Managed Packages (목록)

아래는 PDF p.25-에서 시작하는 "Supported Components" 알파벳순 목록이다. 각 컴포넌트에 대해 manageability 속성(Can Be Updated / Subscriber Can Delete / Developer Can Remove / IP Protection)의 상세값은 PDF의 Supported Components 표에서 컴포넌트별로 확인한다.

> [!note] 아래 목록은 PDF p.25-38 범위에서 추출한 항목이다. PDF 전체에 걸쳐 컴포넌트 목록이 계속되며, 전수 목록은 공식 가이드 "Components Available in Second-Generation Managed Packages" 페이지를 참조한다.

| 컴포넌트 | 설명 |
|---|---|
| Account Plan Objective Measure Calculation Definition | 판매 계정 플랜 목표 측정의 현재 값 계산 대상 객체·롤업 필드·로직 정의 |
| Account Relationship Share Rule | 공유 객체 레코드, 공유 방식, 계정 관계 유형, 액세스 수준 결정 |
| Action Link Group Template | 액션 링크 그룹 템플릿. 액션 링크 정의를 재사용하고 패키징·배포 가능 |
| Action Plan Template | 액션 플랜 템플릿 인스턴스 |
| Actionable List Definition | 실행 가능한 목록과 연결된 데이터 소스 정의 |
| Actionable List KPI Definition | 객체의 특정 필드에 정의된 커스텀 KPI |
| Activation Platform | ActivationPlatform 설정 (플랫폼 이름·배포 일정·출력 형식·대상 폴더) |
| AffinityScoreDefinition | 마케팅 목적의 연락처 분석·분류에 사용되는 친화도 정보 |
| Agent Action | Agentforce에서 사용하는 액션 |
| Agent Topic | Agentforce에서 사용하는 토픽 |
| AI Application | AI 애플리케이션 인스턴스 (예: Einstein Prediction Builder) |
| AI Application Config | AI 애플리케이션 관련 추가 예측 정보 |
| AIUsecaseDefinition | 머신러닝 유스케이스 정의·실시간 예측용 필드 컬렉션 |
| Analytics | 분석 앱·대시보드·데이터플로·데이터셋·렌즈·레시피·user XMD 포함 |
| Analytics Visualization | Tableau Next 시각화 |
| Analytics Workspace | Tableau Next 워크스페이스 |
| Apex Class | Apex 클래스 (템플릿/청사진, 메서드·변수·예외 타입·정적 초기화 코드 포함) |
| Apex Sharing Reason | 커스텀 객체에 공유가 구현된 이유를 나타내는 Apex 공유 이유 |
| Apex Trigger | DML 이벤트 발생 전후에 실행되는 Apex 트리거 |
| App Framework Template Bundle | Data Cloud·Tableau Next 자산용 앱 프레임워크 템플릿 번들 |
| Application Subtype Definition | 애플리케이션 도메인 내 애플리케이션 서브타입 |
| AssessmentConfiguration | Assessment 컴포넌트 설정 (이메일 발송·환자 평가 리마인더 등 사용자 플로우 구성) |
| AssessmentQuestion | 평가에 필요한 질문을 저장하는 컨테이너 객체 |
| AssessmentQuestionSet | Assessment Question 컨테이너 객체 |
| Aura Component | Aura 정의 번들 (컴포넌트·앱·이벤트·인터페이스·토큰 컬렉션 포함) |
| Batch Calc Job Definition | Data Processing Engine 정의 |
| Batch Process Job Definition | Batch Management 작업 정의 세부사항 |
| Benefit Action | 혜택(benefit)에 대해 트리거될 수 있는 액션 세부사항 |
| Bot Template | Einstein Bot 템플릿 설정 (다이얼로그·변수 포함) |
| Branding Set | Experience Builder 사이트의 브랜딩 속성 집합 정의 |
| Briefcase Definition | Salesforce Field Service 모바일 앱에서 오프라인 시 보기 위한 레코드 세트 |
| Building Energy Intensity Record Type Configuration | 빌딩 에너지 집약도 레코드 타입과 내부 enum 간 매핑 설정 |
| Business Process | 프로필 기반으로 다른 피클리스트 값을 표시하는 메타데이터 타입 |
| Business Process Group | 고객 경험 추적을 위한 서베이 |
| Business Process Type Definition | 규칙에 적용되는 비즈니스 프로세스 타입 정의 |
| Care Benefit Verify Settings | 혜택 검증 요청 설정 |
| Care Limit Type | 혜택 제공 한도 특성 정의 |
| Care Request Configuration | 레코드 타입별 세부사항 (서비스 요청·약품 요청·입원 요청 등) |
| Care System Field Mapping | 소스 시스템 필드 → Salesforce 대상 엔티티·속성 매핑 |
| Channel Layout | 커뮤니케이션 채널 레이아웃 관련 메타데이터 |
| Chatter Extension | Chatter 게시자에 통합된 Rich Publisher App 메타데이터 |
| Claim Financial Settings | 보험 청구 금융 서비스 설정 |
| CommunicationChannelType | 프로모션 추천용 커뮤니케이션 채널 타입 (WhatsApp·SMS 등) |
| Community Template Definition | Experience Builder 사이트 템플릿 정의 |
| Community Theme Definition | Experience Builder 사이트 테마 정의 |
| Compact Layout | 컴팩트 레이아웃 관련 메타데이터 |
| Conditional Formatting Ruleset | Dynamic Forms-enabled Lightning page 필드 인스턴스의 스타일·가시성 규칙 집합 |
| Connected App | 외부 애플리케이션과 Salesforce API 통합을 위한 연결된 앱 설정 (SAML·OAuth·OpenID Connect) |
| Context Definition | 노드·속성 간 관계 정의. 데이터 소스의 매핑된 데이터에 효율적으로 접근 가능. 여러 Salesforce 제품이 사전 정의된 컨텍스트 정의 제공 |
| Contract Type | 계약 유형 그룹 (라이프사이클 상태·액세스 사용자·템플릿·조항 등 공통 특성) |
| Conversation Channel Definition | Interaction Service의 BYOC·CCaaS 메시징 채널 정의 |
| Conversation Vendor Info | 파트너 벤더 시스템을 Service Cloud 기능과 연결하는 설정 객체 |
| CORS Allowlist | CORS 허용 목록의 오리진 |
| CSP Trusted Site | 신뢰할 URL. Content Security Policy·권한 정책 디렉티브 지정 가능 |
| Custom Application | 커스텀 애플리케이션 |
| Custom Button or Link | 홈 페이지 컴포넌트에 정의된 커스텀 링크 |
| Custom Console Components | Salesforce 콘솔 앱의 커스텀 콘솔 컴포넌트 (VF 페이지) |
| Custom Field on Standard or Custom Object | 표준·커스텀 객체의 커스텀 필드 정의 생성·수정·삭제 |
| Custom Field on Custom Metadata Type | 커스텀 메타데이터 타입의 커스텀 필드 |
| Custom Field Display | 제품 속성 커스텀 필드의 CustomFieldDisplay 뷰 타입 |
| Custom Help Menu Section | Lightning Experience 도움말 메뉴의 커스텀 섹션 |
| Custom Index | 쿼리 속도 향상을 위한 인덱스 |
| Custom Label | 다국어·지역·통화용으로 현지화 가능한 커스텀 레이블 |
| Custom Metadata Type Records | 커스텀 메타데이터 타입 레코드 |
| Custom Metadata Type | 커스텀 메타데이터 타입 |
| Custom Notification Type | 커스텀 알림 타입 관련 메타데이터 |
| Custom Object | 커스텀 객체 또는 외부 데이터 저장소와 매핑되는 외부 객체 |
| Custom Object Translation | 커스텀 객체 다국어 번역 |
| Custom Permission | 커스텀 기능 접근 권한 |
| Custom Tab | 커스텀 탭 (커스텀 객체 데이터 또는 웹 콘텐츠 표시) |
| Dashboard | 핵심 지표·성과를 한눈에 보여주는 대시보드 |
| DataCalcInsightTemplate | Data Cloud 객체의 데이터 계산·인사이트 객체 템플릿 |
| Data Connector Ingest API | Ingestion API 연결 정보 |
| Data Connector S3 | Amazon S3 연결 정보 |
| Data Kit Object Dependency | Data Kit 내 객체 간 의존성·관계 |
| Data Kit Object Template | Data Kit 내 객체 템플릿 |
| DataObjectBuildOrgTemplate | 사용자가 data kit에 포함한 컴포넌트의 출력 객체 |
| Data Package Kit Definition | 최상위 Data Kit 컨테이너 정의 |
| Data Package Kit Object | Data Kit Content Object |
| Data Source | 데이터 출처 시스템 표현 |
| Data Source Bundle Definition | 사용자가 data kit에 추가한 스트림 번들 |
| Data Source Object | 데이터 출처 객체 |
| Data Src Data Model Field Map | 소스 필드와 데이터 모델 필드 간 설계 시점 번들 수준 매핑 |
| Data Stream Definition | 데이터 수집 정보 (연결·API·파일 검색 설정) |
| Data Stream Template | 사용자가 data kit에 추가한 데이터 스트림 |
| DataWeaveResource | DataWeave 스크립트용 DataWeaveScriptResource 클래스. DataWeave 스크립트를 Apex에서 직접 호출 가능 |
| Decision Matrix Definition | 의사결정 매트릭스 정의 |
| Decision Matrix Definition Version | 의사결정 매트릭스 버전 정의 |
| Decision Table | 의사결정 테이블 정보 |
| Decision Table Dataset Link | 의사결정 테이블과 연결된 데이터셋 링크 (결과를 제공할 레코드 대상 객체 선택) |
| Digital Experience | 조직 워크스페이스의 텍스트 기반 코드 구조 |
| Digital Experience Bundle | 조직 워크스페이스의 텍스트 기반 코드 구조 |
| Disclosure Definition | 공시 타입 정의 (게시자·벤더 세부사항 등) |
| Disclosure Definition Version | 공시 정의 버전 정보 |
| Disclosure Type | 개인·조직의 공시 타입과 관련 메타데이터 |
| Discovery AI Model | Einstein Discovery에서 사용하는 모델 관련 메타데이터 |
| Discovery Goal | Einstein Discovery 예측 정의 관련 메타데이터 |
| Discovery Story | Einstein Discovery 스토리 관련 메타데이터 |
| Document | 문서. 모든 문서는 문서 폴더(예: sampleFolder/TestDocument) 안에 있어야 함 |
| Document Generation Setting | 템플릿에서 자동 문서 생성 설정 |
| Eclair GeoData | Analytics 커스텀 맵 차트 (사용자 정의 맵) |
| Email Template (Classic) | 머지 필드 포함 이메일 템플릿 |
| Email Template (Lightning) | 이메일·대량 이메일·목록 이메일·Sales Engagement 이메일 템플릿 |
| Embedded Service Config | Embedded Service for Web 배포 설정 노드 |
| Embedded Service Menu Settings | 채널 메뉴 배포 설정 노드 |
| Enablement Measure Definition | Enablement 측정값 (작업 수행 추적 소스 객체·관련 객체·필드 필터 포함) |
| Enablement Program Definition | Enablement 프로그램 (연습·측정 가능한 마일스톤 포함) |
| Enablement Program Task Subcategory | 커스텀 운동 유형 (Program Builder에서 Enablement admin이 추가) |
| Entitlement Template | 제품에 빠르게 추가할 수 있는 사전 정의된 고객 지원 조건 |
| ESignature Config | 전자 서명 API·UI 지원을 위한 관리자 설정 |
| ESignature Envelope Config | 전자 서명 봉투의 기본 리마인더·만료 설정 |
| Event Relay | Salesforce에서 Amazon EventBridge로 플랫폼 이벤트·변경 데이터 캡처 이벤트 전송 |
| Explainability Action Definition | Public Sector Solutions의 Decision Explainer 비즈니스 규칙 메타데이터 저장 위치 정의 |
| Explainability Action Version | Decision Explainer 비즈니스 규칙의 설명 가능성 액션 버전 정의·저장 |
| Explainability Message Template | 특정 표현식 세트 단계 타입의 의사결정 설명 메시지 템플릿 |
| Expression Set Definition | 표현식 세트 정의 |
| Expression Set Definition Version | 표현식 세트 버전 정의 |
| Expression Set Object Alias | 표현식 세트에서 사용되는 소스 객체의 별칭 |
| Expression Set Message Token | 설명 가능성 메시지 템플릿의 토큰 (API v59.0 이상) |
| External Auth Identity Provider | 네임드 크레덴셜 callout에서 OAuth 토큰을 가져오는 외부 인증 ID 제공자 |
| External Client App Canvas Settings | 외부 클라이언트 앱의 캔버스 앱 설정 |
| External Client App Header | 외부 클라이언트 앱 설정 헤더 파일 |
| External Client App Notification Settings | 외부 클라이언트 앱 알림 플러그인 설정 |
| External Client App OAuth Settings | 외부 클라이언트 앱 OAuth 플러그인 설정 |
| External Client App Push Settings | 외부 클라이언트 앱 푸시 알림 플러그인 설정 |
| External Credential | Salesforce의 외부 시스템 인증 세부사항 |
| External Data Connector | 데이터 출처 객체 표현 |
| External Data Source | 외부 데이터 소스 메타데이터 (Salesforce org 외부 데이터·콘텐츠 연결) |
| External Data Transport Field Template | Data Cloud 스키마 필드 정의 |
| External Data Transport Field | managed 패키지에 Data Cloud 스키마 필드 추가 (ExternalDataTranObject에 필드 추가) |
| External Data Transport Object Template | Data Cloud 스키마 객체 정의 |
| External Data Transport Object | managed 패키지에 Data Cloud 스키마 객체 포함 |
| External Document Storage Configuration | 외부 드라이브 문서 저장용 드라이브·경로·네임드 크레덴셜 설정 |
| External Services | 외부 서비스 설정 |
| Feature Parameter Boolean | Feature Management App의 Boolean 기능 파라미터 (앱 동작 제어·활성화 지표 추적) |
| Feature Parameter Date | Feature Management App의 Date 기능 파라미터 |
| Feature Parameter Integer | Feature Management App의 Integer 기능 파라미터 |
| FieldMappingConfig | 소스 객체와 하나 이상의 대상 객체·필드 간 매핑 설정 (API v63.0 이상) |
| Field Set | 필드 집합 (예: 이름·직함 등 관련 필드 그룹) |
| Field Source Target Relationship | 데이터 모델 객체(DMO)와 필드 간 관계 저장 (예: Individual.Id → ContactPointEmail.PartyId 1:M) |
| Flow | Flow 메타데이터 (레코드 쿼리·업데이트, 로직·분기 포함 동적 앱 생성) |
| Flow Category | 카테고리로 그룹화된 플로우 목록 |
| Flow Definition | 플로우 정의의 설명·활성 버전 번호 |
| Flow Test | 레코드 트리거 플로우 테스트 메타데이터 (활성화 전 검증) |
| Folder | 폴더 |
| Fuel Type | 커스텀 연료 타입 |
| Fuel Type Sustainability UoM | 커스텀 연료 타입과 UOM 값 매핑 |
| Fundraising Config | 모금 제품 설정 컬렉션 |
| Gateway Provider Payment Method Type | 주문 결제 데이터 수신 결제 수단 선택용 통합자·결제 제공자 엔티티 |
| Gen Ai Planner Bundle | 에이전트·에이전트 템플릿용 플래너 (모든 토픽·액션 컨테이너, LLM과 상호작용) |
| Generative AI Prompt Template | Agentforce용 생성형 AI 프롬프트 템플릿 |
| Global Picklist | 전역 피클리스트 값 세트 메타데이터 (공유 값 집합, 필드 자체는 아님) |
| Home Page Component | Salesforce Classic 홈 탭 컴포넌트 (사이드바 링크·회사 로고·대시보드 스냅샷·커스텀 컴포넌트) |
| Home Page Layout | 홈 페이지 레이아웃 메타데이터 (프로필 기반 레이아웃 할당) |
| Identity Verification Proc Def | 신원 확인 프로세스 정의 |
| Inbound Network Connection | 서드파티 데이터 서비스와 Salesforce org 간 인바운드 프라이빗 연결 |
| IndustriesEinsteinFeatureSettings | Industries Einstein 기능 활성화 설정 |
| IntegrationProviderDef | 서비스 프로세스와 연결된 통합 정의 (비동기 요청 인보커블 액션) |
| Invocable Action Extension | 인보커블 액션으로 사용되는 Apex 클래스의 확장 메타데이터 |
| LearningAchievementConfig | Learning Achievement 타입과 레코드 타입 간 매핑 세부사항 |
| Learning Item Type | Guidance Center의 Enablement 프로그램 커스텀 운동 유형 |
| Letterhead | 이메일 템플릿의 레터헤드 서식 (로고·페이지 색상·텍스트 설정) |
| Life Science Config Category | Life Sciences 설정 레코드 분류 카테고리 |
| Life Science Config Record | Life Sciences 설정 레코드 |
| Lightning Bolt | Lightning Bolt Solution 정의 (커스텀 앱·플로우 카테고리·Experience Builder 템플릿 포함 가능) |
| Lightning Message Channel | Lightning Message Channel 메타데이터 (LWC·Aura·VF 간 보안 통신 채널) |
| Lightning Page | Lightning 페이지 메타데이터 (Lightning 컴포넌트로 구성된 커스터마이즈 가능한 화면) |
| Lightning Type | 커스텀 Lightning 타입 (기본 UI 오버라이드·커스터마이즈 외관) |
| Lightning Web Component | LWC 번들 (Lightning 웹 컴포넌트 리소스 포함) |
| List View | 필터링된 레코드 목록 (연락처·계정·커스텀 객체 등) |
| Live Chat Sensitive Data Rule | 특정 패턴 데이터 마스킹·삭제 규칙 (regex 기반, 신용카드·SSN·전화번호 등) |
| Loyalty Program Setup | 로열티 프로그램 프로세스 설정 (파라미터·규칙, 트랜잭션 저널 처리 방식 포함) |
| Managed Content Type | Salesforce CMS 커스텀 콘텐츠 타입 정의 |
| Marketing App Extension | 서드파티 앱과의 통합 (잠재고객 외부 활동 생성) |
| Marketing App Extension Activity | 서드파티 앱에서 발생하는 잠재고객 활동 타입 |
| Market Segment Definition | 세그먼트 메타데이터 내보내기 가능 정의 (DBT 형식, AppExchange 배포 가능) |
| MktCalculatedInsightsObjectDef | 표현식을 포함한 Calculated Insight 정의 |
| MktDataConnection | 외부 커넥터 연결 정보 (Data Cloud 데이터 수집·읽기·쓰기) |
| MktDataTranObject | 소스에서 대상 landing 엔티티로 데이터 전송 스키마 (파일·API·이벤트 등) |
| Named Credential | 네임드 크레덴셜 (callout 엔드포인트 URL + 인증 파라미터 한 곳에 정의) |
| Object Source Target Map | 소스·대상 객체 간 객체 수준 매핑 (MktDataLakeObject 또는 MktDataModelObject) |
| Object Integration Provider Definition Mapping | 컨텍스트 정의의 논리적 데이터 노드 → Salesforce 객체 필드 또는 외부 데이터 소스 매핑 |
| OcrSampleDocument | OCR에서 정보 추출·매핑 시 참조용 샘플 문서·문서 타입 세부사항 |
| OcrTemplate | Intelligent Form Reader의 양식과 Salesforce 객체 간 매핑 |
| Outbound Network Connection | Salesforce org에서 서드파티 데이터 서비스로의 아웃바운드 프라이빗 연결 |
| Page Layout | 페이지 레이아웃 관련 메타데이터 |
| Path Assistant | Path 레코드 |
| Payment Gateway Provider | 결제 게이트웨이 제공자 관련 메타데이터 |
| Permission Set | 권한 세트 (프로필 변경 없이 추가 접근 권한 부여) |
| Permission Set Groups | 권한 세트 그룹 (직무·작업 기반 권한 세트 조직화, 패키징 가능) |
| Platform Cache | Platform Cache의 파티션 |
| Platform Event Channel | 이벤트 스트림 수신을 위한 구독 채널 |
| Platform Event Channel Member | 변경 데이터 캡처 알림 대상 엔티티 또는 커스텀 채널의 플랫폼 이벤트 |
| Platform Event Subscriber Configuration | 플랫폼 이벤트 Apex 트리거 설정 (배치 크기·실행 사용자·병렬 구독 설정) |
| Pricing Action Parameters | 컨텍스트 정의·가격 책정 절차와 연결된 가격 책정 액션 |
| Pricing Recipe | 설계·런타임에서 가격 책정 데이터 저장소가 사용하는 데이터 모델 집합 |
| Procedure Output Resolution | 전략 이름·수식을 이용한 가격 책정 요소의 가격 해결 |
| Process | **Flow 사용 권장** (deprecated) |
| Process Flow Migration | 프로세스의 마이그레이션된 기준·플로우 |
| Product Attribute Set | 제품 속성 정보 (color_c·size_c 등) |
| Product Specification Type | 산업별 제품 사양 타입 (제품 레코드 타입과 연결) |
| Product Specification Record Type | 산업별 제품 사양과 제품 레코드 타입 간 관계 |
| Prompts (In-App Guidance) | 인앱 가이던스 메타데이터 (프롬프트·워크스루) |
| Quick Action | 객체의 create·update 빠른 액션 (Chatter 게시자에서 사용 가능) |
| Recommendation Strategy | 추천 전략 (데이터 검색·분기·로직 연산으로 추천 결정, 데이터플로와 유사) |

> [!note] 위 목록은 PDF p.25-38에서 확인된 범위다. 알파벳 R 이후(Record Type, Report, Role 등)와 S~Z 범위 컴포넌트는 PDF 이후 페이지에 계속된다. 전체 목록은 공식 Salesforce 문서 "Components Available in Second-Generation Managed Packages" 참조.

---

## 관련 노트

- [[2GP Managed Package 개념과 1GP 비교]] — 2GP 전환 이유·1GP 차이·Dev Hub 활성화
- [[2GP Managed Package 개발 환경과 사전 준비]] — 이 워크플로 시작 전 사전 준비 전수 (namespace·Key Concepts·Manageability·Ancestry·Dependency Matrix)
- [[2GP Managed Package Scratch Org 워크플로]] — 개발·테스트용 scratch org 상세 (namespaced vs no-namespace·Snapshot·Agentforce·할당량)
- [[sfdx-project.json 레퍼런스]] — `namespace`·`packageDirectories`·`packageAliases`·`definitionFile` 필드 전수
- [[Unlocked Package 개발과 버전]] — snapshot 기반 버전 promote 가능 (managed와 대조)
- [[2GP — Develop]] — 워크플로 이후: sf package create·version create·버전 번호 체계·Project Config File·Ancestor 지정·Promote 준비 전수
- [[2GP — Prepare to Distribute]] — 배포 준비: 코드 커버리지·Installation Key·promote·AppExchange 등록 절차
- [[2GP — Components: Apex & Code]] — Apex·LWC·Aura·Visualforce·Static Resource 8종 컴포넌트 Manageability Rules 상세
- [[2GP — Components: Automation]] — Flow·Workflow·Approval Process·Decision Table 등 자동화 24종 패키징 동작
- [[2GP — Components: Einstein & Analytics]] — AI Application·Dashboard·Bot·Generative AI 19종 패키징 동작
- [[2GP — Components: Integration & Platform]] — Named Credential·External Service·Feature Parameter 등 21종 패키징 동작
- [[2GP — Components: Objects & Fields]] — Custom Object·Custom Field·Global Value Set 등 19종 패키징 동작
- [[2GP — Components: Security & Access]] — Permission Set·Connected App·External Credential 등 10종 패키징 동작
- [[2GP — Components: UI & Layout]] — FlexiPage·Lightning Message Channel·Custom App 등 21종 패키징 동작
- [[2GP — Components: Other]] — Sustainability·Service Catalog·Translation·Slack·Healthcare 등 60+ 미분류 컴포넌트 패키징 동작
- [[2GP — Specific Metadata Behavior]] — Agentforce·Data Cloud 패키징·보호 컴포넌트·Platform Cache Provider Free·Permission Set vs Profile Settings·IP 보호·DomainCreator·@NamespaceAccessible·Connected App 패키징·New Order Save Behavior
- [[2GP — Install · Uninstall]] — managed 2GP 설치·업그레이드·제거 전수 (InstallHandler·InstallContext·의존성 스크립트·제약사항)
