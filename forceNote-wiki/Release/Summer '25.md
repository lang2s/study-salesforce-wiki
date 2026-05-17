---
tags: [release, summer_25]
api_version: v64.0
release_date: 2025-06
created: 2026-05-17
source: salesforce_release_notes_5-17-2026 (3).pdf
aliases: [Summer '25, 서머 25]
---

# Summer '25 릴리즈 노트

> API v64.0 | 출시: 2025년 06월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **Agentforce 3** — 하이브리드 인력을 관리·확장하는 최초의 AI 에이전트 플랫폼. Agent API를 Apex 클래스 또는 Flow에서 직접 호출 가능
- **Agentforce Employee Agent** — 사내 워크플로우 자동화용 에이전트. Salesforce Developer Edition에서도 사용 가능
- **Claude Sonnet 4 / GPT 5 / Gemini 2.5 모델 지원** — Einstein Platform에서 최신 외부 AI 모델 선택 사용 가능
- **동적 수식 Template Mode 평가** — `parseAsTemplate()` 메서드로 DML 없이 머지 필드 인터폴레이션 수식 평가
- **Salesforce Platform API v21.0–30.0 폐기 강제 적용** — Summer '25에 실제 차단 시작, 구버전 API 사용 코드 즉시 업그레이드 필요
- **Flow Approval Process GA** — 코드 없이 승인 프로세스를 Flow Builder에서 생성·실행·회수
- **Dynamic Related Lists 모바일 지원 (Beta)** — 데스크탑과 동일한 Dynamic Related List 경험을 모바일에서도 제공
- **ICU 로케일 형식 자동 활성화** — API v45+ 사용 조직에 Summer '25에서 자동 적용
- **Salesforce Channels (Slack 통합)** — Salesforce 레코드 페이지 내에서 Slack 채널로 협업 직접 가능
- **Shield Database Encryption Beta** — Sandbox에서 데이터베이스 암호화 베타 시작

---

## Apex

### 신규

- **동적 수식 Template Mode 평가** — `FormulaBuilder.parseAsTemplate(true)`로 머지 필드 인터폴레이션 방식 수식 평가. 기존 문자열 연결보다 가독성 높음

```apex
// Template Mode로 동적 수식 평가 (DML 없이 실행)
// 출처: salesforce_release_notes_5-17-2026 (3).pdf — Apex 섹션
FormulaEval.FormulaInstance ff = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('{!name} ({!website})')
    .parseAsTemplate(true)
    .build();
// 결과: Account의 name 필드와 website 필드를 인터폴레이션한 문자열
```

- **메타데이터 배포 중 Debug Log 전체 조직 활성화** — Setup → Apex Settings → "Metadata Deployments can generate Debug Logs" 옵션 추가. `DebuggingHeader`에서 설정 시 이 설정보다 우선함

- **`flowtesting` 네임스페이스** — Flow Builder에서 생성된 Flow 테스트를 위해 동적으로 생성되는 Apex 클래스 제공. `sf flow run test` CLI 명령으로 실행

- **`embeddedai` 네임스페이스 신규 클래스**
  - `ApexMap` — AI 처리를 위한 키-값 쌍 저장
  - `RecordApexRepresentation` — SObject 레코드와 자식 레코드를 계층 구조로 모델링 (AI 요약 프롬프트 입력 목적)

- **`ComplianceMgmt` 네임스페이스** — 컴플라이언스 제어를 위한 규칙 프로세서 구현 클래스 제공
  - `ComplianceEvaluation` 인터페이스, `ControlEvaluationInput`, `ControlInput`, `ComplianceEvaluationResponse`, `EvaluationResult`, `ComplianceControlLog`

- **`CommerceBuyGrp` 네임스페이스** — 사용자를 동적으로 Buyer Group에 할당하는 커스텀 비즈니스 로직 실행
  - `BuyerGroupEvaluationService`, `BuyerGroupRequest`, `BuyerGroupResponse`

- **`Auth` 네임스페이스 신규 클래스**
  - `JsonValueOutput` — SSO 중 Identity Provider에서 반환된 특정 속성 저장
  - `GeneratedUserData` — 사용자 레코드 생성을 위한 플레이스홀더 데이터 저장
  - `AuthProviderTokenResponse` — ID 토큰 저장을 위한 신규 생성자 및 `idToken` 프로퍼티 추가

- **`FormulaEval` 네임스페이스 변경** — `FormulaBuilder.parseAsTemplate(Boolean templateMode)` 메서드 추가

- **Platform Event 트리거 Batch Size·User UI 노출** — Setup → Platform Events에서 Batch Size와 User 컬럼을 직접 확인 가능 (이전에는 Tooling API/Metadata API로만 확인 가능)

### 변경

- **Outbound Message 타임아웃 60초 → 20초** — 리소스 효율성 향상, 큐에서 오래된 메시지 처리 개선
- **Outbound Message 큐 헤더명 변경** — "Oldest failures in queue" → "Oldest messages in queue"
- **Streaming API v64.0** — 클라이언트가 `/meta/disconnect` 채널을 구독하여 연결 해제 메시지 수신 후 재연결 필요 (Hyperforce 인스턴스에서 더 자주 발생)
- **`lightning/platformResourceLoader` 동적 import 금지** — 정적 import 선언만 허용. 동적 `import()` 사용 시 오류 발생
- **Shift_JIS → Windows-31J 문자 매핑 제거** — Apex EncodingUtil, Visualforce CSV, External Services에 영향
- **Salesforce Functions 퇴직** — 더 이상 구매/갱신 불가. 기존 구독 기간까지만 사용 가능

### Deprecated / 폐기

- **Salesforce Platform API v21.0–30.0** (Summer '25 강제 차단) — SOAP API, REST API, Bulk API 모두 해당
- **Chimera DAST 스캐너** (2025-06-16 이후 사용 불가) — AppExchange 보안 리뷰용 DAST 스캐너를 자유롭게 선택하여 제출 필요
- **`DeliveryMethodId` 필드 on `CartDeliveryGroup`** — API v64.0에서 deprecated, API v66.0에서 제거 예정. 대신 `CartDeliveryGroupMethod`의 `DeliveryMethodId` 사용
- **Activity 360 Reporting 관련 Objects** — Summer '26에 `UnifiedEmail`, `UnifiedEmailParticipant`, `UnifiedMeeting`, `UnifiedMeetingParticipant`, `UnifiedTask`, `UnifiedTaskParticipant` 폐기 예정

---

## LWC

### 신규

- **`lightning__AgentforceInput` 타겟** — 에이전트 액션에서 사용자 입력 데이터를 수락하는 LWC에 사용
- **`lightning__AgentforceOutput` 타겟** — 에이전트 액션의 출력 데이터를 표시하는 LWC에 사용

```javascript
// XML 설정 파일 예시 — 에이전트 액션용 LWC 타겟
// 구조 예시 — 실제 동작 코드 아님
<targets>
    <target>lightning__AgentforceInput</target>
    <target>lightning__AgentforceOutput</target>
</targets>
```

- **`lightning-datatable` 신규 메서드** — `focus()`, `scrollToTop()` 추가. 컬럼 프로퍼티 `imgSrc` 추가 (커스텀 아이콘 URI)
- **`lightning-tree-grid` 신규 기능** — 커스텀 데이터 타입 지원, `column-widths-mode` 속성, `sortable` 컬럼 프로퍼티, `sort` 커스텀 이벤트
- **`lightning-input` 에러 아이콘** — 유효하지 않은 상태의 필드에 오류 아이콘 표시. `date` 타입 필드에 날짜 형식 대신 샘플 날짜 표시
- **`lightning-input-address` 신규 속성** — `hide-province` (지역 필드 숨기기), `country-lookup-filter` (최대 5개 국가 코드 필터)
- **`lightning-menu-item` 신규 속성** — `icon-type` (`standard` | `color`) 아이콘 배경색 지정
- **`lightning/mediaUtils` 모듈 GA** — 베타에서 정식 출시

### 변경

- **`lightning-avatar`, `lightning-carousel-image`** — `src` 속성에서 `data:` prefix URL은 보안상 `javascript:void(0)`으로 교체
- **`lightning-accordion`** — 섹션이 1개인 경우, `allow-multiple-sections-open`이 없거나 false일 때 해당 섹션을 닫을 수 있음 (이전에는 항상 열려 있었음)
- **`lightning-datatable` (Aura)** — `focus()`, `scrollToTop()` 메서드 및 `imgSrc` 컬럼 프로퍼티 추가

### Deprecated

- **Local Development Server** — 퇴직 예정 (정확한 날짜는 이후 공지)
- **`lightning/platformResourceLoader` 동적 import** — v64.0부터 동적 `import()` 차단

---

## Flow / Automation

### 신규

#### Flow Builder 개선

- **Flow Approval Process GA** — Flow Builder에서 승인 프로세스 생성·실행·회수 경로 추가 가능
  - `Create a Flow Approval Process from the Approvals App`
  - `Run a Flow Approval Process from a Flow`
  - `Add a Recall Path to a Flow Approval Process`

```javascript
// 구조 예시 — 실제 동작 코드 아님
// Flow Action: createFlowApprovalProcess / requestApproval
// FlowActionCall subtype의 actionType 필드에 신규 값으로 추가됨
```

- **Related Records 조회 가속 (Beta)** — `Get Related Records Faster` 신규 기능
- **리소스 검색 확장 (Beta)** — `Find More Resources with Expanded Search`
- **Einstein Panel** — Flow Builder 내에서 Einstein 패널로 AI 기능 활용
- **Flow 에러 처리 테스트** — `Test Flows for Error Handling` 지원
- **비동기 경로 쉬운 추가** — Record-Triggered Flow에서 비동기 경로 발견 및 추가 간소화
- **기존 Flow를 템플릿으로 저장** — `Saving an Existing Flow as a Template`
- **Data Graph 데이터 변환** — Flow에서 Data Graph 데이터를 변환 가능
- **Activation-Triggered Flow (Pilot)** — Data Cloud 세그먼트를 API 기반 대상으로 활성화

#### Screen Flow 개선

- **자동 트리거 Screen Actions GA** — 사용자를 하나의 Flow 화면에 유지
- **File Upload Enhanced Component (Beta)** — 파일 업로드 개선된 Screen 컴포넌트
- **선택 항목에 아이콘 추가** — Choice 리소스에 아이콘 추가 가능
- **Visual Picker 컴포넌트** — 타일 형태로 선택지 표시

#### Flow Management

- **통합 테스트로 Flow 빠르게 테스트** — `Test Flows Faster with Integrated Tests`
  - Flowtesting Apex 네임스페이스 사용
- **Flow 데이터 Data Cloud 로깅 강화** — `Log More Flow Data to Data Cloud`
- **Output Resources 뷰어** — Flow Builder에서 출력 리소스를 확인하며 디버그

#### Flow Orchestration

- **Fault Path로 오케스트레이션 오류 처리 제어** — `Control Orchestration Error Handling by Using Fault Paths`
- **FlowOrchestrationLog에 `RunRecallPath` 값 추가** — 승인 제출 회수 시 마일스톤 기록
- **FlowOrchestrationInstance에 `TriggeringRecordType` 필드 추가** — 오케스트레이션을 트리거한 레코드 객체 지정

#### MuleSoft for Flow: Integration

- **서드파티 커넥터 추가** — 새로운 서드파티 커넥터로 데이터 교환 강화
- **통합 탭 신규** — 외부 시스템과의 커넥터 및 연결 탐색
- **Salesforce/NetSuite 커넥터 Get Records Actions** — 구성 가능한 레코드 조회 액션
- **Heroku API 노출** — MuleSoft API Catalog에서 Heroku API 확인 가능
- **Apex API 노출 (Beta)** — MuleSoft API Catalog에서 Apex API 확인 가능 (Beta)

### 변경

- **Restrict User Access to Run Flows (Release Update)** — Winter '26에 강제 적용. FlowSites org permission 폐기됨 → 사용자에게 올바른 프로파일/권한 세트 명시적 부여 필요
- **Enforce Rollbacks for Apex Action Exceptions in REST API (Release Update)** — REST API에서 Apex Action 예외 발생 시 롤백 강제 적용

### Deprecated

- **MuleSoft RPA에서 Salesforce로 직접 퍼블리싱** — 퇴직 예정

---

## Admin / Setup

### 권한 관리 개선 (Customization)

- **Object Manager에서 오브젝트 권한 일괄 수정** — 모든 커스텀 Permission Set·Profile에 대한 오브젝트 권한을 Object Manager에서 한 번에 수정 가능
- **Permission Set Summary에서 권한 빠르게 수정** — Summary View에서 직접 사용자·오브젝트·필드·커스텀 권한 업데이트
- **Permission Set Group Summary에서 포함 Permission Set 관리** — Summary를 떠나지 않고 그룹에 포함된 Permission Set 편집
- **Access Summary에서 탭 설정 확인** — 사용자, Permission Set, Permission Set Group에서 접근 가능한 탭 확인
- **User Access Summary 강화** — 사용자의 Permission Set·Group·Queue 추가/제거, 검색·정렬·새로고침 가능

### List Views 개선

- **Dynamic Related List 모바일 지원 (Beta)** — `Dynamic Related List - Single` 컴포넌트가 데스크탑·모바일 모두 지원
  - Setup → Salesforce Mobile App → `Enable Dynamic Related Lists for Mobile (Beta)` 활성화 필요
- **Record Type 빠른 필터 Picklist** — Record Type 필드 관련 quick filter를 텍스트 입력 대신 Picklist에서 선택
- **List Views Dropdown Menu LWC 전환** — 전체 객체의 List Views 드롭다운이 Aura에서 LWC로 마이그레이션
  - 표시 최대 100개 목록, 검색 기능 포함
  - 키보드 포커스가 현재 핀된 목록 대신 목록 상단에서 시작 (DOM 구조 변경 주의)
- **List Views 성능 향상** — 커스텀·표준 오브젝트의 List Views가 Aura에서 LWC로 전환

### Salesforce Connect

- **Prompt Builder에서 External Data 접근** — 프롬프트 템플릿에서 외부 오브젝트 필드를 표준/커스텀 오브젝트와 동일하게 사용
- **Salesforce Connect 한도 제거 (Hyperforce)** — OData 2.0/4.0/4.01, Custom, GraphQL, Amazon DynamoDB, Amazon Athena, Snowflake 어댑터의 신규 행·콜아웃 한도 제거

### 글로벌라이제이션

- **ICU 로케일 형식 자동 활성화** — Apex Classes, Apex Triggers, Visualforce Pages가 API v45 이상인 조직에서 JDK 로케일 형식을 ICU로 자동 교체 (Summer '25)
- **State/Country Picklist 매핑 초기화** — 복구 불가 상태의 picklist 매핑 데이터를 초기화하는 기능 추가
- **표준 레이블 번역 업데이트** — 32개 언어의 표준 오브젝트·탭·필드명 번역 업데이트

### 기타 Admin

- **Salesforce Go** — 기능 발견 및 설정 간소화 (Sales Cloud Go에서 이름 변경)
- **Digital Wallet** — Flex Credit 소비 모니터링, Mobile App Message Credit 모니터링
- **DX Inspector (Sandbox/Scratch Org)** — 메타데이터 추적 및 시각화 관리 도구
- **Heroku Apps in Salesforce Setup GA** — Heroku 앱을 External Services로 퍼블리시하여 Flow Builder, Apex, Data Cloud, Agentforce에서 사용

---

## Slack

- **Slack 섹션 Setup 재구성** — Salesforce Setup에서 Slack 관련 페이지 구성이 더 직관적으로 변경 (2025-06-12 적용)
- **Guided Slack Setup** — 워크스페이스 생성, Salesforce 채널 설정, 사용자 초대를 단계별 가이드로 설정 (2025-06-12 적용)
- **Salesforce Channels** — Salesforce 레코드 페이지에 Slack 컴포넌트를 추가하여 실시간 팀 협업 가능 (2025-06-12 적용)
  - Salesforce와 Slack 양쪽에서 대화에 접근 가능
- **Salesforce Channels 읽지 않은 메시지 표시** — 마지막으로 읽은 메시지 위치에서 시작, 새 메시지 표시기 제공 (2025-08-19 적용)
- **Salesforce Channels에서 Agentforce 에이전트 사용** — 채널에서 에이전트를 멘션하면 Slack과 동일하게 응답 (2025-08-19 적용)

---

## API

| 항목 | 내용 |
|---|---|
| **API 버전** | v64.0 |
| **API v21.0–30.0 폐기** | Summer '25에 강제 차단 (SOAP API, REST API, Bulk API 모두 해당) |
| **Composite API EventLogFile** | `CompositeApi`, `CompositeApiSubrequest` 이벤트 타입 추가 — 복합 API 요청 상세 조회 가능 |
| **sObjects REST API OpenAPI (Beta)** | `/async/specifications/oas3` 리소스로 전체 유효 리소스 목록 조회 가능, URI에 와일드카드 `*` 사용 가능 |
| **Metadata API** | `rootTypesWithDependencies` 파라미터로 메타데이터 타입 의존성 포함 조회 |
| **Connect REST API 속도 제한 변경** | 사용자·앱·시간당 제한 → 조직·24시간당 Salesforce Platform API 속도 제한으로 마이그레이션 |
| **Streaming API v64.0** | `/meta/disconnect` 채널 구독으로 연결 해제 메시지 수신 후 재연결 필요 |
| **Pub/Sub API** | 모든 Hyperforce 리전에서 글로벌 엔드포인트 사용 가능 (2025년 4월부터) |
| **Change Data Capture** | `PaymentPage` 등 추가 오브젝트에서 변경 이벤트 알림 수신 가능 |
| **LoginAnomalyEvent** | 잠재적으로 악의적인 로그인 시도 관련 실시간 알림 구독 가능 |

---

## 거버너 한도 변경

- **Connect REST API 속도 제한** — 사용자·앱·시간당 제한에서 조직·24시간당 Salesforce Platform API 속도 제한으로 마이그레이션 (Summer '24 이후 생성 조직은 이미 적용. Chatter 요청은 기존 사용자별 제한 유지)
- **Salesforce Connect 외부 데이터 한도 제거 (Hyperforce)** — OData, Custom, GraphQL, DynamoDB, Athena, Snowflake 어댑터의 신규 행·콜아웃 한도 제거
- **Outbound Message 타임아웃** — 60초 → 20초로 단축

---

## 보안 / 정책

### Identity & Access Management

- **External Client App 생성** — App Manager에서 External Client App 생성 가능, External Client App Settings에서 Connected App 생성
- **SAML on External Client Apps** — External Client App에 SAML 2.0 SSO 설정 가능
- **SSO 등록 핸들러를 Flow Builder로 구성** — 코드 없이 SSO 등록 핸들러 설정 (`IdentityUserRegistrationFlow` 값이 `ProcessType` 필드에 추가)
- **JWT 기반 액세스 토큰 제어** — 앱 개발자가 JWT 기반 액세스 토큰 활성화 여부 제어 가능
- **Device Activation 강제화** — 일부 Production/Sandbox 조직 사용자에게 Device Activation 필수
- **Triple DES for SAML SSO** — Winter '26에 지원 종료 예정

### Salesforce Shield

- **Database Encryption Beta** — Sandbox에서 데이터베이스 암호화 베타
- **External Key Management for Data Cloud** — Data Cloud용 외부 키 관리 사용 가능
- **신규 결정론적 암호화 테넌트 시크릿 워크플로**
- **AES-GCM Mode & P1363 서명** — Crypto 클래스에서 새 암호화 모드 지원
- **Login Anomaly Event** — 의심스러운 로그인 활동 탐지, `LoginAnomalyEventStore`에 저장
- **새 Event Log Objects** — `LightningErrorEventLog`, `DatabaseSaveEventLog`, `GroupMembershipEventLog`, `UiTelemetryNavTmEventLog`, `UiTelemetryRsrcTmEventLog`, `InvocableActionEventLog`

### Security Center

- **Government Cloud Plus 다중 조직 지원** — 중앙화된 Security Center 대시보드에서 모든 Government Cloud Plus 조직의 보안 설정 모니터링

### Agentforce for Security

- **Security agent actions** — AI와 대화하며 보안 상태 쿼리, 위험 평가, 조치 계획 수립
- **Policy Center 관리 정책 유형 확장** — Data Cloud 정책 포함 더 많은 정책 유형 관리 가능

### 기타

- **Salesforce Classic 하이퍼링크 차단 리디렉션 추적** — URL·Long Text Area 필드의 하이퍼링크에서 발생한 차단 리디렉션 모니터링
- **CSP 위반 상세 보고 강화** — Trusted URL and Browser Policy Violations 목록에서 더 많은 CSP 위반 표시

---

## DevOps / CLI

### Salesforce CLI

- **Salesforce CLI 지속 업데이트** — 주간 릴리즈 노트 참조
- **Salesforce Extensions for VS Code** — 지속 업데이트
- **Code Builder** — 지속 업데이트
- **Agentforce for Developers** — CodeGen 및 xGen-Code 모델 기반. Enterprise, Performance, Unlimited, Partner Developer, Developer Edition에서 기본 활성화

### DevOps Testing

- **Scale Test 통합** — DevOps Testing에 Scale Test 프로바이더 추가 (Full Sandbox 필요, 최대 50,000 RPS)
- **Agentforce Testing Center와 DevOps Testing 통합** — AI 에이전트 테스트를 DevOps 파이프라인에 통합

### 성능 도구

- **Scale Center 개선** — Apex 조사 기능 향상, 앱 내 피드백, 검색 인사이트
- **ApexGuru** — SOQL in loops 탐지, 비효율 쿼리 필터·연산 식별, 비용 큰 문자열 연산·debug 문 감소 권장. Setup → Scale Center → Scale Insights → ApexGuru Insights

### 패키징

- **2GP 패키지 마이그레이션 GA** — Convert and Migrate Packages to 2GP
- **에이전트 템플릿 패키지화** — 1GP·2GP Managed Package에 에이전트 템플릿 포함 가능
- **CLI로 패키지 업그레이드 푸시** — Unlocked·2GP Managed Package 업그레이드를 CLI로 배포
- **메타데이터 사용량 확인** — Unlocked·2GP Managed Package의 패키지 메타데이터 사용량 확인

### 샌드박스

- **Data Mask Beta** — 특정 Data Mask 작업 정보 접근, Job Scheduler로 Data Mask 프로세스 자동화
- **Sandbox Deployment Status 배너** — Synchronous Compile on Deploy 설정 활성화 시 배너 표시

---

## Architecture

> 플랫폼 구조, 메타데이터 모델, 인프라, 패키징 관련 변경

- **Hyperforce 신규 리전 — 인도 하이데라바드** — 2025년 4월 Hyperforce가 인도 하이데라바드에 신규 오픈. 총 17개국에서 Hyperforce 사용 가능. Tableau·Data Cloud도 추가 리전에서 사용 가능하여 글로벌 데이터 레지던시 옵션 확대
- **Pub/Sub API 글로벌 엔드포인트** — Pub/Sub API가 모든 Hyperforce 리전에서 글로벌 엔드포인트 사용 가능 (2025년 4월부터). 리전별 별도 엔드포인트 불필요
- **CDN 단일 도메인 인증서 전환 (Release Update)** — 공유 도메인 인증서를 단일 도메인 인증서로 전환 필요. 미전환 시 Spring '26 강제 적용 시 사이트 non-HTTPS로 변경됨. 전환 시 다운타임 없음
- **Update Instanced URLs in API Traffic (Release Update)** — Instanced URL 사용 API 트래픽을 My Domain 로그인 URL로 전환. Sandbox는 Winter '26, Production은 Spring '26 강제 적용
- **DX Inspector — Scratch Org 메타데이터 빠른 접근** — Scratch org 상단에 DX Inspector 패널 제공. 현재 org 확인 및 Changes 탭에서 메타데이터 변경 내역 조회 가능. `Customize Application` 권한 필요
- **2GP 패키지 마이그레이션 GA (Package Migrations)** — 기존 1GP 패키지를 2GP로 변환하고 구독자 org를 1GP에서 2GP로 마이그레이션하는 기능 정식 출시. 패키지 메타데이터·구독자 데이터 변경 없음. Asia Pacific 인스턴스는 향후 릴리즈에 적용 예정
- **에이전트 템플릿 패키지화** — 1GP·2GP 관리 패키지에 에이전트 템플릿 포함 가능. Agentforce DX로 scratch org에서 개발·테스트
- **CLI로 패키지 업그레이드 푸시** — Unlocked·2GP 관리 패키지 push upgrade를 4개 신규 CLI 명령(`schedule`, `abort`, 상세 조회, 목록 조회)으로 관리. 구독자가 직접 설치하지 않아도 업그레이드 배포 가능
- **패키지 메타데이터 사용량 확인** — `sf package version report` 명령으로 패키지의 메타데이터 파일 크기·수량 한도 대비 현황 확인 가능
- **FlowActionCall — `createFlowApprovalProcess` / `requestApproval`** — Flow 메타데이터 타입의 FlowActionCall subtype에 Flow Approval Process 관련 신규 `actionType` 값 추가 (Flow Approval Process GA와 연계)
- **`IdentityUserRegistrationFlow` ProcessType** — SSO 등록 핸들러를 Flow Builder로 구성하는 신규 ProcessType 값. Apex 코드 없이 등록 핸들러 설정 가능
- **Salesforce Functions 퇴직** — 더 이상 구매·갱신 불가. 기존 구독 기간까지만 사용 가능
- **Salesforce Connect Hyperforce 한도 제거** — OData 2.0/4.0/4.01, Custom, GraphQL, DynamoDB, Athena, Snowflake 어댑터의 신규 행·콜아웃 한도 Hyperforce에서 제거

---

## Agentforce / Einstein

### Agentforce 3 플랫폼

- **Agentforce 3 출시** — 하이브리드 인력 관리·확장을 위한 최초의 AI 에이전트 플랫폼
- **Agent API를 Apex 또는 Flow에서 호출** — `Call the Agent API from an Apex Class or Flow`
- **Agentforce Employee Agent** — 사내 워크플로우 자동화, Developer Edition에서도 사용 가능
- **새 Agentforce 에디션 (Unmetered User-Based AI)** — 무제한 사용자 기반 AI 에디션 출시
- **Flex Credits** — Agentforce 크레딧 소비 간소화
- **16개 추가 언어 지원 (Beta)** — 에이전트와 16개 언어로 채팅 가능

### Agentforce 기능

- **Agentforce Service Agent GA** — 이메일로 고객 응대 자율 처리
- **향상된 에스컬레이션 경험** — 더 많은 문의를 해결하는 향상된 에스컬레이션 플로우
- **Agentforce 세션 추적** — `Gain Visibility Into Agent Behavior With Agentforce Session Tracing`
- **지식 검색 품질 가시성** — RAG 검색 품질 모니터링
- **Agentforce Analytics (Beta)** — Tableau Next 기반 에이전트 분석 대시보드
- **Agentforce Optimization (Beta)** — 에이전트 효과 인사이트 및 최적화 지원
- **Agent 버전 관리 개선** — 에이전트 버전 테스트·커스터마이징 개선
- **Agentforce Testing Center 강화** — 커스텀 평가 기준, 대화 이력 포함, 실제 컨텍스트 변수로 테스트

### Prompt Builder

- **단계별 비주얼로 프롬프트 개발 최적화**
- **웹 사이트 기반 지식 그라운딩** — 프롬프트를 웹 사이트의 관련 지식으로 보강
- **Structured Outputs** — 렌더링된 모델 응답에 구조화된 출력 사용
- **Citations 지원** — AI 응답의 출처 검증
- **PDF 파일 입력 분석** — 프롬프트 템플릿으로 PDF 파일 입력 분석
- **Instruction-Only Flex Prompt Templates** — 0~5개 선택적 입력을 지원하는 Flex 템플릿

### Einstein Trust Layer

- **Citations** — AI 응답의 신뢰성을 높이는 인용 출처 표시

### 지원 모델 (Summer '25 신규)

| 모델 | 비고 |
|---|---|
| **Claude Sonnet 4** | Anthropic — Einstein Platform에서 사용 가능 |
| **GPT 5** | OpenAI — Einstein Platform에서 사용 가능 |
| **GPT 4.1 / GPT 4.1 Mini** | OpenAI — Einstein Platform에서 사용 가능 |
| **Gemini 2.5 / Gemini 2.5 Flash Lite** | Google — Einstein Platform에서 사용 가능 |
| **Amazon Nova 모델** | AWS — Einstein Platform에서 사용 가능 |
| GPT 4 Turbo 리라우팅 연장 | 기존 이용 기간 연장 |
| GPT 4 32k / GPT 4 리라우팅 | 리라우팅 날짜 임박 |
| GPT 3.5 Turbo 리라우팅 | 리라우팅 날짜 임박 |

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Summer '25에 강제 적용됨 (지금 즉시 확인 필수)

| 항목 | 영향 | 조치 |
|---|---|---|
| **Salesforce Platform API v21.0–30.0 Retirement** | SOAP/REST/Bulk API v21~30 호출이 즉시 차단됨. 통합 앱 중단 위험 | v31+ 버전으로 즉시 업그레이드 |
| **Verify SAML Integrations** | SAML SSO/SLO 통합에 영향 가능 | Summer '25 Sandbox에서 SAML 통합 테스트 |
| **Enable Secure Roles Behavior (Sandboxes)** | Sandbox에서 "Roles and Subordinates" → "Roles and Internal Subordinates"로 변경 | 해당 그룹명을 참조하는 코드·커스터마이제이션 업데이트 |
| **Review and Update Settings to Capture Leads from LinkedIn** | LinkedIn Lead Form 동기화 중단 위험 | LinkedIn 계정 재연결 및 신규 설정 활성화 |
| **Enable a Modernized Record Experience in Aura Sites** | Create Record Form, Record Banner, Record Detail 컴포넌트가 LWC 기반으로 업그레이드 | 접근성·성능 개선 확인 |
| **Enable ICU Locale Formats** | Apex v45+ 사용 조직에서 날짜·시간·통화 형식 변경 | 로케일 형식 의존 코드 테스트 |

### Winter '26에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Restrict User Access to Run Flows** | FlowSites org permission 폐기. 사용자에게 Flow 실행 권한을 프로파일/Permission Set으로 명시 부여 필요 |
| **Enable Secure Roles Behavior (Production)** | "Roles and Subordinates" 참조 코드 업데이트. Summer '25 시작 후 Release Update 활성화 가능 |
| **Confirm Verified Email Addresses (2016년 이전 생성 사용자)** | 2016-11-01 이전 생성 사용자 계정의 이메일 검증 여부 확인 |
| **Update Permissions for Agentforce Service Assistant Users** | Service Planner User PSL로 접근 권한 전환. Salesforce 라이선스에서 권한 제거됨 |
| **Update Instanced URLs in API Traffic (Sandbox)** | My Domain 로그인 URL로 API 트래픽 전환 |

### Spring '26에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Update References to Legacy Host Names** | 레거시 호스트명 참조를 모두 My Domain URL로 업데이트 |
| **Migrate to a Multiple-Configuration SAML Framework** | 단일 구성 SAML 프레임워크 사용 조직: 다중 구성 SAML로 마이그레이션 필요 (SSO 구성 중단 방지) |
| **Switch to a Single Domain Certificate for CDN** | 공유 도메인 인증서를 단일 도메인 인증서로 전환 (다운타임 없음) |
| **Upgrade to Enhanced LWR Sites** | 기존 LWR 사이트를 Enhanced LWR로 업그레이드 |
| **Update Instanced URLs in API Traffic (Production)** | My Domain URL로 API 트래픽 전환 |

### Summer '26에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Enforcing No-Argument Constructor on Apex Classes Used for Invocable Action Parameters** | Invocable Action 파라미터로 사용되는 클래스의 no-argument 생성자 가시성 확인 |

### 취소된 업데이트

| 항목 | 비고 |
|---|---|
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | 취소됨. Frequency 필드 계속 사용 가능 |
| **Update Your Trusted URLs for the Latest CSP Directives** | 취소됨. CSP 지시어 직접 설정 권장 |
| **Use Your Org's My Domain Login URL in API Calls** | 취소됨. "Update Instanced URLs in API Traffic"으로 대체 |

---

## 연관 패턴 노트 업데이트 필요

- [ ] `Apex/Data(데이터)/` — `FormulaBuilder.parseAsTemplate()` 신규 메서드 패턴 추가 검토
- [ ] `Apex/PlatformEvents(플랫폼이벤트)/` — Platform Event Trigger Batch Size UI 노출, Outbound Message 타임아웃 변경 주석 추가
- [ ] `Apex/Testing(테스트)/` — `flowtesting` 네임스페이스 및 Flow 통합 테스트 패턴 추가
- [ ] `LWC/ComponentAPI(컴포넌트API)/` — `lightning-datatable` 신규 메서드, `lightning-tree-grid` 신규 기능 업데이트
- [ ] `LWC/Security(보안)/` — `data:` URL 보안 처리, `platformResourceLoader` 동적 import 차단 주의사항 추가
- [ ] `Flow/index.md` — Flow Approval Process GA, Orchestration Fault Path 신규 기능 반영
- [ ] `Apex/Security(보안)/` — API v21~30 폐기 강제 적용, SAML 프레임워크 마이그레이션 주의사항
- [ ] `Integration(통합)/통합 MOC.md` — MuleSoft for Flow 신규 커넥터, Heroku AppLink GA 반영

---

## 관련 노트

- [[Release MOC]]
- [[Spring '25]] — 이전 릴리즈
- [[Winter '26]] — 다음 릴리즈
