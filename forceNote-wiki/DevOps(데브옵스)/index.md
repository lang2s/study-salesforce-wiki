---
tags: [index, devops, salesforce-dx, ci-cd, packaging, metadata-api]
created: 2026-05-18
---

# DevOps(데브옵스) — 로컬 인덱스

> Salesforce DX — 소스 중심 개발, Scratch Org, Unlocked Package, CI/CD 자동화, Metadata API 배포

**상위:** [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Salesforce DX 개요]] | sfdx-project.json, sf CLI 기본 명령, Source Format, .forceignore, JWT 인증 | #overview |
| [[Scratch Org 패턴]] | Scratch Org 생성·관리, project-scratch-def.json, Org Shape, Snapshot | #pattern |
| [[Unlocked Package 패턴]] | sf package create/version create/install, 2GP, Org-Dependent, packageAliases | #pattern |
| [[CI CD 패턴]] | Jenkins Jenkinsfile, CircleCI, JWT 인증 자동화, 패키지 빌드 파이프라인 | #pattern |
| [[DX 프로젝트 구조와 소스 포맷]] | DX 프로젝트 생성·디렉토리 구조·소스 포맷·정적 리소스·기존 소스 마이그레이션 전수 | #reference |
| [[메타데이터 분해와 forceignore]] | Decomposed Metadata Types 전수(기본+선택 Beta), .forceignore 문법·예제 전수 | #reference |
| [[sfdx-project.json 레퍼런스]] | 모든 필드·기본값, Multiple Package Dirs, String Replacement 전수 | #reference |
| [[DX 인증 방식]] | org login web·JWT Flow·External Client App·Connected App·SFDX Auth URL·Logout 전수 | #reference |
| [[Scratch Org 생성과 정의 파일]] | Scratch Org 개념·Editions/Allocations·생성 명령 전수·Definition File 옵션 전수·Features 전수 목록 | #reference |
| [[Scratch Org Settings 레퍼런스]] | settings 블록 전수 옵션·주요 Settings 예시·Features와 Settings 조합 패턴 | #reference |
| [[Org Shape와 Snapshot]] | Org Shape 생성·권한·Troubleshoot 전수, Snapshot 생성·관리·릴리즈 버전 결정 전수 | #reference |
| [[Scratch Org 배포·유저·에러코드]] | project deploy/retrieve start 전수, org create user·User Definition File·비밀번호 관리, Error Codes 전수표 | #reference |
| [[Source Tracking 변경 추적]] | Org 에디션별 지원·Manage Tracking·Preview·Deploy/Retrieve·Profile 추적 동작·Conflicts 해결·Best Practices·Performance 전수 | #reference |
| [[DX 개발 워크플로]] | Develop Against Any Org·sf apex generate class/trigger·sf lightning generate component·sf schema generate·Anonymous Apex·Run Tests·Debug Logs 전수 | #reference |
| [[DX 도구 접근 권한]] | Dev Hub 선택·활성화·추가 기능·라이선스·사용자 추가·Permission Set 권한 전수 | #reference |
| [[Sandbox 관리]] | org create/clone/refresh/delete sandbox, sandbox-def.json 전체 옵션 전수 | #reference |
| [[DX 데이터 작업]] | data export/import tree, Bulk API 2.0 전수, record CRUD, SOQL/SOSL CLI, 파일 업로드 | #reference |
| [[Metadata API 빌드·릴리스 워크플로]] | Org Development Model 4단계·배포 검증·빠른 배포·취소 전수 | #reference |
| [[Unlocked Package 개념과 준비]] | 패키지 개념·불변 버전·Org 역할·Org-Dependent 비교·사전 준비 체크리스트 전수 | #reference |
| [[Unlocked Package 생성과 설정]] | sf package create·sfdx-project.json 18개 파라미터·Keywords·Installation Key·Namespace·Profile Settings 전수 | #reference |
| [[Unlocked Package 개발과 버전]] | 버전 생성 3가지 옵션·버전 번호 가이드·코드 커버리지·브랜치·Hard-Delete 컴포넌트 전수 | #reference |
| [[Unlocked Package 릴리스와 설치]] | Push Upgrade·CLI/URL 설치·업그레이드 타입·의존성 스크립트·언인스톨·패키지 이전 전수 | #reference |
| [[2GP Managed Package 개념과 1GP 비교]] | managed 2GP 개념·1GP 8가지 변화·Dev Hub/PBO/namespace org·권한 세트·Limited Access 라이선스·Unlocked와의 차이 | #reference |
| [[2GP Managed Package 개발 환경과 사전 준비]] | Limited Access User 추가·Know Your Orgs·namespace 생성과 Link to Dev Hub·Key Concepts(app/package/metadata, version, install/upgrade)·Manageability Rules·Package Ancestry·의존성 매트릭스 전수 | #reference |
| [[2GP Managed Package Scratch Org 워크플로]] | Develop(namespaced) vs Test(no-namespace)·ancestor seeding·Definition File vs Org Shape·Snapshot(+managed promote 불가)·Agentforce·Data Cloud scratch org·PBO 할당량·Partner edition 전수 | #reference |
| [[2GP Managed Package — Workflow]] | 2GP 표준 CLI 워크플로 10단계(sf project generate~sf org open)·sfdx-project.json 자동 업데이트·Manageability Rules 4속성·Editable Properties 3카테고리·Supported Components 전수 목록 | #reference |
| [[2GP — Components: Apex & Code]] | Apex Class·Trigger·Sharing Reason·Aura·LWC·Static Resource·Visualforce 컴포넌트·페이지 8종 Manageability Rules 4속성 전수·Editable Properties·패키징 고려사항·IP Protection | #reference |
| [[2GP — Components: Automation]] | Flow·Workflow·Decision Table·Expression Set·Batch·Business Process Group 등 자동화 컴포넌트 Manageability Rules 4속성 전수·IP Protection·2GP-only 제한 | #reference |
| [[2GP — Components: Einstein & Analytics]] | AffinityScoreDefinition·AIApplication·AIUsecaseDefinition·BotTemplate·Dashboard·DiscoveryAI·GenAiFunction·GenAiPlugin·GenAiPlannerBundle·GenAiPromptTemplate·RecommendationStrategy·Report·ReportType 등 Einstein·Analytics·Agentforce 도메인 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components: Integration & Platform]] | AppFrameworkTemplateBundle·CareBenefitVerifySettings·ChatterExtension·ContextDefinition·ConversationVendorInfo·EmbeddedServiceConfig·EventRelayConfig·ExternalDataSource·ExternalServiceRegistration·FeatureParameter 3종·GatewayProviderPaymentMethodType·InboundNetworkConnection·IndustriesEinsteinFeatureSettings·IntegrationProviderDef·NamedCredential·PlatformCachePartition·RemoteSiteSetting 21종 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components: Objects & Fields]] | AssessmentQuestion·BriefcaseDefinition·CareLimitType·CareRequestConfiguration·CustomField·CustomIndex·CustomLabels·CustomMetadata·CustomObject·CustomPermission·Document·FieldMappingConfig·FieldSet·FieldSourceTargetRelationship·Folder·GlobalValueSet·RelationshipGraphDefinition 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components: Security & Access]] | AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·CspTrustedSite·ExternalAuthIdentityProvider·ExternalCredential·IdentityVerificationProcDef·LiveChatSensitiveDataRule(1GP only)·PermissionSet·PermissionSetGroup 10종 Manageability Rules 4속성 전수·Certificate 패키징 불가·Profile 2GP 미지원 상세·Permission Set vs Profile Settings 비교 | #reference |
| [[2GP — Components: UI & Layout]] | FlexiPage·CustomApplication·CustomTab·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·DigitalExperienceBundle·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·HomePageComponent·HomePageLayout·Layout·CompactLayout·ActionLinkGroupTemplate·ActionableListDefinition·Prompt 21종 UI 레이아웃 도메인 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Components: Other]] | FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 Other 도메인 컴포넌트 Manageability Rules 4속성 전수 | #reference |
| [[2GP — Specific Metadata Behavior]] | Agentforce Agent Template 패키징·Data Cloud 패키지 요건·보호 컴포넌트·Platform Cache Provider Free 3MB·Metadata Access Apex·Permission Set vs Profile Settings 전수·IP 보호·Salesforce URL DomainCreator·@NamespaceAccessible·외부 서비스·Connected App 패키징·New Order Save Behavior 대응 | #reference |
| [[2GP — Develop]] | sf package create·sf package version create 3가지 옵션·MAJOR.MINOR.PATCH.BUILD·NEXT 키워드·Project Configuration File 파라미터 전수·Package Ancestor(HIGHEST/NONE)·beta→released 75% 커버리지·sf package version promote 전수 | #reference |
| [[2GP — Install · Uninstall]] | sf package install·sf package uninstall·--publish-wait/--wait 타임아웃·Installation URL·InstallHandler·InstallContext·System.Version·PostInstallScript·의존성 설치 스크립트·Uninstall 제약사항 전수 | #reference |
| [[2GP — Prepare to Distribute]] | beta→released 승격 전 코드 커버리지 75%·Installation Key 설정·sf package version promote·Release Notes URL·postInstallUrl·AppExchange 파트너 콘솔 연결·패키지 등록·권장 버전 설정 전수 | #reference |
| [[2GP — Push Upgrade]] | ISV가 subscriber org에 강제 업그레이드를 Push하는 전 과정·CLI 명령·SOAP API·Customized Push Upgrade·Best Practices 전수 | #reference |
| [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] | CircleCI 환경 설정·서버키 암호화·Dev Hub 연결, Jenkins Jenkinsfile 전체 코드, Travis CI, Sample CI 레포 전수 표 | #reference |
| [[DX 도구 개요와 워크플로 전환]] | DX가 개발 방식을 바꾸는 이유·샘플 레포 시작·신규 프로젝트·마이그레이션 3가지 시작 경로 전수 | #reference |
| [[Metadata Coverage 보고서]] | Metadata API·Scratch Org Source Tracking·Unlocked Package 등 채널별 메타데이터 지원 여부 공식 참조 | #reference |
| [[DX MCP Server (Beta)]] | VS Code+Copilot Quick Start·60+ MCP 도구·toolset 14개·Core Tools 12개 전수 | #reference |
| [[DX 트러블슈팅]] | org login web/jwt 오류 전수(12가지)·No default dev hub·포트 점유·consumer key 중복 해결 | #reference |
| [[DX 제약사항]] | CLI·Dev Hub·Source Management·배포·1GP/2GP·Unlocked Package 알려진 제약 13건 전수 | #reference |

### Metadata API (서브폴더 → [[MetadataAPI(메타데이터API)/index]])

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[MetadataAPI(메타데이터API)/Metadata API 개요]] | API 개념·에디션·권한·버전 생명주기·호출 목록 | #overview |
| [[MetadataAPI(메타데이터API)/Metadata API Quick Start]] | WSDL/WSC Java 클라이언트 연결·빠른 시작 | #quickstart |
| [[MetadataAPI(메타데이터API)/Metadata API File-Based 호출]] | deploy·retrieve·package.xml·DeployOptions 전체 | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API CRUD 호출]] | createMetadata·readMetadata·updateMetadata·deleteMetadata | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API REST]] | deployRequest REST 엔드포인트 + curl 예제 | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API Utility Calls]] | describeMetadata·listMetadata·checkStatus | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API Result Objects]] | DeployResult·RetrieveResult·RunTestsResult·Error 전수 | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API Headers]] | AllOrNoneHeader·DebuggingHeader·SessionHeader | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API 에러 처리]] | SOAP fault·비동기/동기 CRUD 오류·세션 만료 처리 | #reference |
| [[MetadataAPI(메타데이터API)/Metadata API MCP Tool]] | MCP 서버(Beta)·5개 도구·Cursor/Claude/Agentforce 설정 | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — 개요 및 분류]] | 300+ 타입 전체 목록·그룹 분류·Type Limits | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Apex & Code]] | ApexClass·ApexTrigger·LightningComponentBundle·StaticResource | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Objects & Fields]] | CustomObject·CustomField·RecordType·ValidationRule | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Automation]] | Flow·ApprovalProcess·WorkflowRule·DuplicateRule | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Security & Access]] | PermissionSet·Profile·SharingRules·ConnectedApp | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — UI & Layout]] | Layout·FlexiPage·CustomApplication·ExperienceBundle | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Integration & Platform]] | NamedCredential·RemoteSiteSetting·PlatformEventChannel | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Einstein & Analytics]] | WaveApplication·GenAiPlanner·Bot·DiscoveryAIModel | #reference |
| [[MetadataAPI(메타데이터API)/Metadata Types — Other]] | Metadata·MetadataWithContent·FuelType·기타 타입 | #reference |

---

## 빠른 선택

- DX 프로젝트 생성부터 배포까지? → [[Salesforce DX 개요]]
- DX 프로젝트 디렉토리 구조와 소스 포맷 전수? → [[DX 프로젝트 구조와 소스 포맷]]
- Decomposed Metadata Types 전수 / .forceignore 문법? → [[메타데이터 분해와 forceignore]]
- sfdx-project.json 모든 필드·String Replacement? → [[sfdx-project.json 레퍼런스]]
- Scratch Org 만들고 스냅샷 찍기? → [[Scratch Org 패턴]]
- Unlocked Package 버전 만들고 설치하기? → [[Unlocked Package 패턴]]
- Jenkins/CircleCI로 자동화 파이프라인 구성? → [[CI CD 패턴]]
- JWT 인증 설정? → [[DX 인증 방식]] — JWT Flow·External Client App·OpenSSL 명령 전수
- SFDX Auth URL 사용법? → [[DX 인증 방식]] → SFDX Authorization URL
- Org Shape vs Snapshot 차이? → [[Org Shape와 Snapshot]]
- Scratch Org Definition File 옵션 전수? → [[Scratch Org 생성과 정의 파일]]
- Scratch Org Features 전수 목록? → [[Scratch Org 생성과 정의 파일]] → Features 전수 목록
- Scratch Org settings 블록 옵션? → [[Scratch Org Settings 레퍼런스]]
- Org Shape 생성·권한 설정? → [[Org Shape와 Snapshot]] → Org Shape
- Snapshot 생성·관리·CLI 명령? → [[Org Shape와 Snapshot]] → Scratch Org Snapshots
- project deploy/retrieve start 상세? → [[Scratch Org 배포·유저·에러코드]]
- Scratch Org 추가 사용자 생성? → [[Scratch Org 배포·유저·에러코드]] → Scratch Org Users
- Scratch Org 오류 코드 전수? → [[Scratch Org 배포·유저·에러코드]] → Error Codes
- Source Tracking 활성화·비활성화? → [[Source Tracking 변경 추적]] → Manage Source Tracking
- 배포 전 충돌 확인·해결? → [[Source Tracking 변경 추적]] → Resolve Conflicts
- Source Tracking 성능 문제·느린 명령? → [[Source Tracking 변경 추적]] → Performance Considerations
- Profile 검색이 예상보다 많은 정보를 반환? → [[Source Tracking 변경 추적]] → Retrieve Changes to Profiles
- CLI에서 Apex 클래스 생성? → [[DX 개발 워크플로]] → Create an Apex Class
- CLI에서 LWC 또는 Aura 컴포넌트 생성? → [[DX 개발 워크플로]] → Create Lightning Web Components
- CLI에서 Apex Trigger 생성? → [[DX 개발 워크플로]] → Create an Apex Trigger
- CLI에서 Custom Object 생성? → [[DX 개발 워크플로]] → Create a Custom Object
- Anonymous Apex 실행? → [[DX 개발 워크플로]] → Execute Anonymous Apex
- Apex 테스트 실행·코드 커버리지 확인? → [[DX 개발 워크플로]] → Run Apex Tests
- Apex Debug Log 조회? → [[DX 개발 워크플로]] → Generate and View Apex Debug Logs
- Non-Source-Tracked Org에 배포·검색? → [[DX 개발 워크플로]] → Develop Against Any Org
- Dev Hub 활성화·라이선스 설정? → [[DX 도구 접근 권한]] → Enable Dev Hub
- Dev Hub Org에 사용자 추가? → [[DX 도구 접근 권한]] → 사용자 추가
- Sandbox CLI로 생성·클론·새로 고침? → [[Sandbox 관리]]
- sandbox-def.json 옵션 전수? → [[Sandbox 관리]] → Sandbox Definition File
- sObject Tree 포맷 소규모 데이터 이동? → [[DX 데이터 작업]] → Small Datasets
- Bulk API 2.0 대용량 데이터 처리? → [[DX 데이터 작업]] → Large Datasets
- 단건 레코드 CRUD? → [[DX 데이터 작업]] → Individual Records
- Sandbox 기반 Org Development Model 배포 파이프라인? → [[Metadata API 빌드·릴리스 워크플로]]
- project deploy validate / quick / cancel? → [[Metadata API 빌드·릴리스 워크플로]] → Step 3–4
- Unlocked Package 개념 설명? → [[Unlocked Package 개념과 준비]]
- Org-Dependent Unlocked Package란? → [[Unlocked Package 개념과 준비]] → Org-Dependent
- managed 2GP가 뭔가? AppExchange 파트너 패키지 만들기? → [[2GP Managed Package 개념과 1GP 비교]]
- managed 1GP에서 managed 2GP로 전환 이유? → [[2GP Managed Package 개념과 1GP 비교]] → 1GP에서 2GP로 — 핵심 변화 8가지
- managed 1GP vs 2GP 비교표? → [[2GP Managed Package 개념과 1GP 비교]] → 1GP vs 2GP 비교표
- Dev Hub 활성화 절차·sandbox에서 가능? → [[2GP Managed Package 개념과 1GP 비교]] → Dev Hub 활성화 절차
- @namespaceAccessible 어노테이션은 뭐? → [[2GP Managed Package 개념과 1GP 비교]] → One Namespace Shared Across Multiple Packages
- 2GP Managed 권한 세트(Package2/Package2VersionCreateRequest)? → [[2GP Managed Package 개념과 1GP 비교]] → managed 2GP 권한 세트 구성
- Salesforce Limited Access - Free 라이선스 제약? → [[2GP Managed Package 개념과 1GP 비교]] → Salesforce Limited Access - Free 라이선스
- managed 2GP namespace 생성·Dev Hub link 절차? → [[2GP Managed Package 개발 환경과 사전 준비]] → Namespace
- 2GP에서 한 namespace로 여러 패키지 공유? → [[2GP Managed Package 개발 환경과 사전 준비]] → Namespace ↔ 패키지 관계
- Manageability Rules는 뭔가? 어떤 변경이 차단되나? → [[2GP Managed Package 개발 환경과 사전 준비]] → Manageability Rules
- Package Ancestry란? abandon 가능 조건? → [[2GP Managed Package 개발 환경과 사전 준비]] → Package Ancestry
- managed 2GP가 unlocked package에 의존 가능? 매트릭스? → [[2GP Managed Package 개발 환경과 사전 준비]] → Package Dependency Matrix
- managed 2GP에 등장하는 org 종류? → [[2GP Managed Package 개발 환경과 사전 준비]] → Know Your Orgs
- Limited Access User 추가 절차? → [[2GP Managed Package 개발 환경과 사전 준비]] → Limited Access User 추가
- managed 2GP에서 namespaced vs no-namespace scratch org는 언제? → [[2GP Managed Package Scratch Org 워크플로]] → Development vs Testing
- ancestor seeding이란? --no-ancestors 언제 쓰나? → [[2GP Managed Package Scratch Org 워크플로]] → Development
- 2GP 패키지 build 시간 단축하려면? snapshot 활용? → [[2GP Managed Package Scratch Org 워크플로]] → Snapshots
- managed 패키지를 snapshot 기반으로 promote 가능? → [[2GP Managed Package Scratch Org 워크플로]] → Snapshot 제약 (불가)
- Agentforce·Data Cloud scratch org 만들기? → [[2GP Managed Package Scratch Org 워크플로]] → Agentforce·Data Cloud
- Active PBO 할당량 / --skipvalidation 한도? → [[2GP Managed Package Scratch Org 워크플로]] → Allocations
- ActiveScratchOrg vs ScratchOrgInfo 차이? → [[2GP Managed Package Scratch Org 워크플로]] → Dev Hub에서 관리
- managed 2GP 패키지를 처음 만드는 10단계 CLI 워크플로? → [[2GP Managed Package — Workflow]] → 전체 10단계
- sf package create 실행 후 sfdx-project.json 자동 업데이트 예시? → [[2GP Managed Package — Workflow]] → 1-1. 전체 10단계 (Step 6 이후)
- Manageability Rules 4속성 전수 (Can Be Updated / Subscriber Can Delete / IP Protection)? → [[2GP Managed Package — Workflow]] → Manageability Rules
- 패키지 promote 후 편집 가능 속성 3카테고리? → [[2GP Managed Package — Workflow]] → Editable Properties
- 2GP managed 패키지에 넣을 수 있는 컴포넌트 목록? → [[2GP Managed Package — Workflow]] → Supported Components
- Flow 컴포넌트의 2GP Manageability Rules (IP Protection·Subscriber Delete 가능 여부)? → [[2GP — Components: Automation]] → Flow
- Workflow 컴포넌트를 2GP 패키지에 넣을 수 있나? (Deprecation 경고 포함) → [[2GP — Components: Automation]] → Workflow Rule
- BatchCalcJobDefinition / BatchProcessJobDefinition 2GP 패키징 규칙? → [[2GP — Components: Automation]] → Batch Calc Job Definition
- Decision Matrix Definition / Expression Set Definition이 2GP에서 BETA인가? → [[2GP — Components: Automation]] → Decision Matrix Definition
- FlowCategory·FlowTest·InvocableActionExtension는 2GP-only? → [[2GP — Components: Automation]] → Flow Category
- BusinessProcessGroup 2GP에서 IP Protection 있나? → [[2GP — Components: Automation]] → Business Process Group
- PermissionSet을 2GP 패키지에 포함하는 규칙? → [[2GP — Components: Security & Access]] → Permission Set
- ConnectedApp 2GP 패키징 시 Push Upgrade OAuth 제한은? → [[2GP — Components: Security & Access]] → Connected App → Considerations When Packaging
- Certificate를 2GP 패키지에 포함할 수 있나? → [[2GP — Components: Security & Access]] → 2GP 미지원 컴포넌트 ("Certificates aren't packageable")
- CspTrustedSite를 패키지에 포함하면 안 되는 이유? → [[2GP — Components: Security & Access]] → CSP Trusted Site → Considerations When Packaging
- ExternalCredential 패키지 설치 후 Post Install Steps? → [[2GP — Components: Security & Access]] → External Credential → Post Install Steps
- Profile이 2GP 패키지에 포함되는 방식? → [[2GP — Components: Security & Access]] → 2GP 지원 컴포넌트 목록 (Profile 관련 주의) + Permission Set vs Profile Settings 비교
- SharingRules / Territory / ModerationRule / OauthCustomScope을 2GP에서 패키징 가능한가? → [[2GP — Components: Security & Access]] → 2GP 미지원 컴포넌트 목록
- FuelType / SustainabilityUom / SustnUomConversion 2GP Net Zero Cloud 패키징 규칙? → [[2GP — Components: Other]] → Sustainability / Net Zero Cloud
- Service Catalog 4종 컴포넌트 2GP 패키징 규칙? → [[2GP — Components: Other]] → Service Catalog
- Translation 2GP 패키징 (Language Extension Package Beta)? → [[2GP — Components: Other]] → Translation
- Letterhead / EmailTemplate (Classic·Lightning) 2GP/1GP 패키징 차이? → [[2GP — Components: Other]] → Email / Letterhead / Document
- SlackApp 2GP IP Protection + ViewDefinition 2GP Beta? → [[2GP — Components: Other]] → Slack 통합
- WebStoreTemplate / PricingActionParameters / PricingRecipe 2GP 패키징? → [[2GP — Components: Other]] → Commerce & Pricing
- FundraisingConfig 2GP 패키징? → [[2GP — Components: Other]] → Fundraising
- VirtualVisitConfig / LifeSciConfigCategory / LifeSciConfigRecord 2GP 패키징? → [[2GP — Components: Other]] → Healthcare / Life Sciences
- EnablementProgramDefinition / EnablementMeasureDefinition 2GP 패키징? → [[2GP — Components: Other]] → Enablement & Learning
- BenefitAction 2GP IP Protection (Loyalty Management)? → [[2GP — Components: Other]] → Benefit Action
- TransactionProcessingType 2GP 패키징·언인스톨 시 주의사항? → [[2GP — Components: Other]] → Transaction Processing Type
- ActivationPlatform 1GP 패키징 (Data Cloud)? → [[2GP — Components: Other]] → Activation Platform
- Agentforce Agent Template를 managed 2GP 패키지로 만들기? → [[2GP — Specific Metadata Behavior]] → 2. Develop and Package Agent Templates Using Scratch Orgs
- sf agent generate template 명령 사용법? → [[2GP — Specific Metadata Behavior]] → 2-4. Agentforce 패키지 개발 단계
- Data Cloud 메타데이터를 managed 패키지에 포함하는 요건? → [[2GP — Specific Metadata Behavior]] → 3. Package Data Cloud Metadata Components
- Data Cloud One Companion Org에 패키지 설치 가능한가? → [[2GP — Specific Metadata Behavior]] → 3-4. Data Cloud One Companion Connected Orgs 제약
- Protected Components란? 어떤 컴포넌트를 보호 가능? → [[2GP — Specific Metadata Behavior]] → 4. Protected Components in Managed Packages
- Platform Cache 3MB Provider Free 용량 할당 절차? → [[2GP — Specific Metadata Behavior]] → 5. Set Up a Platform Cache Partition with Provider Free Capacity
- Apex에서 메타데이터 접근 제약? Metadata namespace? → [[2GP — Specific Metadata Behavior]] → 6. Metadata Access in Apex Code
- Permission Set vs Profile Settings 패키지에서 차이? → [[2GP — Specific Metadata Behavior]] → 7. Permission Sets and Profile Settings in Packages
- Install for Admins Only / All Users / Specific Profiles CLI 명령? → [[2GP — Specific Metadata Behavior]] → 7-4. 2GP에서 Profile Settings 처리 방식
- 패키지에서 Apex 코드 IP 보호 방법? 난독화 예외? → [[2GP — Specific Metadata Behavior]] → 8. Protecting Your Intellectual Property
- 패키지에서 Salesforce URL 처리 방법? DomainCreator 사용? → [[2GP — Specific Metadata Behavior]] → 9. Call Salesforce URLs Within a Package
- getOrgMyDomainHostname / getVisualforceHostname / DomainParser? → [[2GP — Specific Metadata Behavior]] → 9. Call Salesforce URLs Within a Package
- @NamespaceAccessible annotation 사용 조건과 예외? → [[2GP — Specific Metadata Behavior]] → 10. Namespace-Based Visibility for Apex Classes
- 2GP 패키지에 Connected App 포함하는 절차? → [[2GP — Specific Metadata Behavior]] → 12. Package Connected Apps in Second-Generation Managed Packaging
- New Order Save Behavior 패키지 대응 (scratch org definition file)? → [[2GP — Specific Metadata Behavior]] → 13. Test and Respond to the New Order Save Behavior
- OrderSaveLogicEnabled / OrderSaveBehaviorBoth feature 설정? → [[2GP — Specific Metadata Behavior]] → 13-3. Order Save Behavior 설정 옵션
- 2GP managed 패키지 처음 생성하는 CLI 명령? → [[2GP — Develop]] → sf package create
- sf package version create 3가지 옵션(Default/Async/Skip) 비교? → [[2GP — Develop]] → Create Versions
- MAJOR.MINOR.PATCH.BUILD 버전 번호 체계? → [[2GP — Develop]] → Guidance for Package Version Numbering
- NEXT 키워드로 build number 자동 증가? → [[2GP — Develop]] → NEXT 키워드
- sfdx-project.json packageDirectories 파라미터 전수 (2GP용)? → [[2GP — Develop]] → Project Configuration File
- Package Ancestor 지정 방법 3가지 (HIGHEST/직접 지정/ancestorId)? → [[2GP — Develop]] → Specify a Package Ancestor
- beta 버전을 released로 promote하는 75% 커버리지 요건? → [[2GP — Develop]] → Get Ready to Promote
- sf package version promote 명령? → [[2GP — Develop]] → Promote 명령
- --skip-ancestor-check 플래그 언제 사용? → [[2GP — Develop]] → Override Linear Package Ancestry
- NONE 키워드 ancestor 미지정 시 upgrade path 영향? → [[2GP — Develop]] → NONE 키워드
- managed 2GP 패키지를 scratch org에 설치하는 CLI 명령? → [[2GP — Install · Uninstall]] → 섭션 2-1
- --publish-wait 와 --wait 파라미터 인터렉션? → [[2GP — Install · Uninstall]] → 2-2. 설치 타임아웃 제어
- Installation URL로 패키지 설치하는 방법? → [[2GP — Install · Uninstall]] → 섭션 3
- AppExchange 미승인 패키지 설치 알림은? → [[2GP — Install · Uninstall]] → 섭션 4
- managed 2GP 패키지 업그레이드 시 메타데이터 변경 동작? → [[2GP — Install · Uninstall]] → 섭션 5
- Apex 테스트 실패로 설치 실패 시 진단 방법? → [[2GP — Install · Uninstall]] → 섭션 6
- InstallHandler / InstallContext 인터페이스? → [[2GP — Install · Uninstall]] → 7-2 ~ 7-3
- System.Version compareTo / major / minor / patch 메서드? → [[2GP — Install · Uninstall]] → 7-4. System.Version 클래스 메서드
- Post Install Script 예시 코드 (PostInstallClass)? → [[2GP — Install · Uninstall]] → 7-5. Post Install Script 예시
- Test.testInstall 사용법? → [[2GP — Install · Uninstall]] → 7-5. Post Install Script 예시 (테스트 코드)
- sfdx-project.json에서 postInstallScript / uninstallScript 지정? → [[2GP — Install · Uninstall]] → 섭션 8
- 의존성 패키지 자동 설치 bash 스크립트? → [[2GP — Install · Uninstall]] → 섭션 9
- sf package uninstall 명령 / Setup UI 제거 절차? → [[2GP — Install · Uninstall]] → 섭션 10
- 2GP 패키지 제거 시 제약사항 전수 (커스텀 오브젝트 서브컴포넌트 삭제 등)? → [[2GP — Install · Uninstall]] → 10-3. 제거 시 제약사항
- 2GP 패키지를 AppExchange에 배포하기 전 단계 전체? → [[2GP — Prepare to Distribute]]
- beta 패키지 버전을 released로 promote하는 상세 절차? → [[2GP — Prepare to Distribute]] → 섹션 4
- 코드 커버리지 75% 계산 방법 (--code-coverage)? → [[2GP — Prepare to Distribute]] → 섹션 2
- Installation Key 설정·변경·bypass 명령 전수? → [[2GP — Prepare to Distribute]] → 섹션 3
- postInstallUrl / releaseNotesUrl sfdx-project.json 설정? → [[2GP — Prepare to Distribute]] → 섹션 5
- Dev Hub를 AppExchange 파트너 콘솔에 연결하는 방법? → [[2GP — Prepare to Distribute]] → 섹션 6
- Register Managed 2GP Package / License Management Org (LMO)? → [[2GP — Prepare to Distribute]] → 섹션 6
- 구독자에게 특정 버전 업그레이드 권장 (sf package update --recommended-version-id)? → [[2GP — Prepare to Distribute]] → 섹션 7
- 2GP Push Upgrade로 subscriber org에 강제 업그레이드하기? → [[2GP — Push Upgrade]]
- sf package push-upgrade schedule / list / report / abort 명령? → [[2GP — Push Upgrade]] → 섹션 2
- PackagePushRequest / PackagePushJob / PackagePushError 오브젝트 쿼리? → [[2GP — Push Upgrade]] → 섹션 2
- 고객이 Push Upgrade를 차단하게 하려면? → [[2GP — Push Upgrade]] → 섹션 4
- PushUpgradeCustomizationRepository 만료 기간 설정·변경? → [[2GP — Push Upgrade]] → 4-3
- Push Upgrade 후 신규 기능 접근 권한 자동 할당 스크립트? → [[2GP — Push Upgrade]] → 섹션 6
- Push Upgrade Best Practices (단계적 배포·고객 신뢰)? → [[2GP — Push Upgrade]] → 섹션 7
- sf package create 명령 상세? → [[Unlocked Package 생성과 설정]]
- sfdx-project.json 패키지 파라미터 전수? → [[Unlocked Package 생성과 설정]] → sfdx-project.json 패키지 설정 파라미터
- packageDirectories Keywords NEXT LATEST RELEASED HIGHEST NONE? → [[Unlocked Package 생성과 설정]] → Keywords
- Installation Key 설정? → [[Unlocked Package 생성과 설정]] → Installation Key
- 패키지 Namespace 생성·충돌 매트릭스? → [[Unlocked Package 생성과 설정]] → Namespace
- sf package version create Default/Async/Skip? → [[Unlocked Package 개발과 버전]] → Create New Versions
- 패키지 버전 번호 MAJOR.MINOR.PATCH.BUILD 가이드? → [[Unlocked Package 개발과 버전]] → Guidance for Package Version Numbering
- 코드 커버리지 75% 요건 확인? → [[Unlocked Package 개발과 버전]] → Code Coverage
- sf package version promote 릴리스? → [[Unlocked Package 개발과 버전]] → Release an Unlocked Package
- Hard-Delete되는 컴포넌트 목록? → [[Unlocked Package 개발과 버전]] → Hard-Deleted Components
- Push Upgrade 스케줄·추적·취소? → [[Unlocked Package 릴리스와 설치]] → Push Upgrade
- sf package install --publish-wait --wait 차이? → [[Unlocked Package 릴리스와 설치]] → Control Package Installation Timeouts
- 의존성 자동 순서 설치 스크립트? → [[Unlocked Package 릴리스와 설치]] → Sample Script
- 패키지를 다른 Dev Hub로 이전? → [[Unlocked Package 릴리스와 설치]] → Transfer
- DX 시작 방법 (샘플 레포 vs 신규 프로젝트 vs 마이그레이션)? → [[DX 도구 개요와 워크플로 전환]]
- dreamhouse-lwc 클론 후 완전한 DX 워크플로? → [[DX 도구 개요와 워크플로 전환]] → 시작 경로 1
- 메타데이터가 Scratch Org Source Tracking에서 지원되는지? → [[Metadata Coverage 보고서]]
- LLM + DX CLI 작업 자동화 (MCP)? → [[DX MCP Server (Beta)]]
- DX MCP Server toolset 목록 전수? → [[DX MCP Server (Beta)]] → MCP 도구 유형
- org login web/jwt 인증 오류 해결? → [[DX 트러블슈팅]]
- No default dev hub found 오류? → [[DX 트러블슈팅]] → Error: No default dev hub found
- consumer key already taken 오류? → [[DX 트러블슈팅]] → Error: The consumer key is already taken
- DX 알려진 제약사항 전수? → [[DX 제약사항]]
- RecordType data import 불가 우회 방법? → [[DX 제약사항]] → Salesforce CLI
- CircleCI 서버 키 암호화 설정? → [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] → CircleCI
- Jenkins Jenkinsfile 전체 코드 보기? → [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] → Sample Jenkinsfile
- Sample CI 레포 전체 목록? → [[CI 통합 전수 (CircleCI·Jenkins·Travis)]] → Sample CI Repos
- - Metadata API 전체 둘러보기? → [[MetadataAPI(메타데이터API)/index]]
- .zip 파일로 배포하기? → [[MetadataAPI(메타데이터API)/Metadata API File-Based 호출]]
- REST API로 배포? → [[MetadataAPI(메타데이터API)/Metadata API REST]]
- 단일 컴포넌트 생성/삭제(CRUD)? → [[MetadataAPI(메타데이터API)/Metadata API CRUD 호출]]
- 배포 오류 원인 파악? → [[MetadataAPI(메타데이터API)/Metadata API 에러 처리]]
- AI 코딩 도구에서 메타데이터 타입 조회? → [[MetadataAPI(메타데이터API)/Metadata API MCP Tool]]
- CustomObject/CustomField 메타데이터 필드 정의? → [[MetadataAPI(메타데이터API)/Metadata Types — Objects & Fields]]
- Flow/ApprovalProcess 메타데이터 필드 정의? → [[MetadataAPI(메타데이터API)/Metadata Types — Automation]]
- PermissionSet/Profile 메타데이터 필드 정의? → [[MetadataAPI(메타데이터API)/Metadata Types — Security & Access]]

---

## 관련 섹션

- [[Apex MOC]] — Apex 코드 개발
- [[LWC MOC]] — LWC 컴포넌트 개발
- [[Flow MOC]] — Flow 자동화
