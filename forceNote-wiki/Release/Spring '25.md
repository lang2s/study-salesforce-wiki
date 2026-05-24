---
tags: [release, spring25, v63, apex, lwc, flow, agentforce, slds, orchestration, mulesoft, devops, cli]
source: salesforce_release_notes_5-17-20264.pdf — Salesforce Spring '25 Release Notes
created: 2026-05-18
aliases: [Spring '25, Spring25, v63.0, API 63, 스프링 25]
---

# Spring '25 Release Notes

> API 버전 63.0 | 2025년 2월 릴리즈

---

## Apex

### Compression Namespace GA
Zip 파일 압축·압축 해제를 Apex 네이티브 라이브러리로 처리. (Summer '24 Beta → GA)

```apex
// 여러 첨부 파일을 Zip으로 압축
Compression.ZipWriter writer = new Compression.ZipWriter();
for (ContentVersion cv : [SELECT PathOnClient, VersionData FROM ContentVersion
                           WHERE ContentDocumentId IN :ids]) {
    writer.addEntry(cv.PathOnClient, cv.VersionData);
}
Blob zipBlob = writer.getArchive();

// Zip에서 특정 항목 추출
Compression.ZipReader reader = new Compression.ZipReader(zipBlob);
ZipEntry entry = reader.getEntry('translations/fr.json');
Blob data = reader.extractEntry(entry);
```

### FormulaEval GA
`FormulaEval` 네임스페이스로 SObject 및 Apex 객체에 동적 수식 평가. 다형성 관계 필드, 표준/커스텀 Lookup 지원. (Summer '24 Beta → GA)

```apex
FormulaEval.FormulaInstance ff = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('name & " (" & website & ")"')
    .build();
String fieldNameList = String.join(ff.getReferencedFields(), ',');
Account a = Database.query('SELECT ' + fieldNameList + ' FROM Account LIMIT 1');
System.debug(ff.evaluate(a));
```

### Scheduled Jobs Pause/Resume
`System` 클래스에 새 메서드로 프로그래밍적으로 스케줄 잡 일시정지·재개.

```apex
// pauseJobByName(), pauseJobById(), resumeJobByName(), resumeJobById()
Id apexClassId = '01p4u000000dVf7AAE';
List<AsyncApexJob> jobs = [SELECT CronTriggerId FROM AsyncApexJob
                            WHERE ApexClassId = :apexClassId];
for (AsyncApexJob j : jobs) {
    System.pauseJobById(j.CronTriggerId);
}
```

### 동시 장기 Apex 요청 한도 — 라이선스 기반 확장
| 라이선스 수 | 동시 Apex 요청 한도 |
|---|---|
| 1,000개 이하 | 10 (기본 최소값) |
| 1,000–5,000개 | 100개당 1 (최대 50) |
| 5,000개 이상 | 50 (최대값) |

### 기타 Apex 변경사항
- **마스터-디테일 리패런팅 제한 강화** (API v63.0+): 리패런팅 미허용 시 `System.DmlException` 발생
- **예외 타입 JSON 직렬화 금지** (API v63.0+): 커스텀/내장 예외 타입 `JSON.serialize()` 시 오류
- **JavaScript Remoting 예외 커버리지 확대**: `@RemoteAction` 트랜잭션 예외를 이벤트 로그에 기록

---

## LWC — API v63.0

### 주요 변경사항

| 변경 | 설명 |
|---|---|
| `apiVersion` 필수화 | 모든 커스텀 컴포넌트의 `.js-meta.xml`에 `apiVersion` 필수. 없으면 자동 추가 |
| Base Components DOM 구조 변경 | Native Shadow DOM 전환 준비 — 내부 DOM 구조 의존 테스트 수정 필요 |
| Wire Adapter 타입 체크 강화 | TypeScript에서 `@wire` 설정값 타입 검사 개선. `$reactiveProp` 반응형 props 타입 해석 |
| JS 셀렉터 공백 처리 변경 | `querySelector` 등 셀렉터에서 불필요한 공백 제거 동작 변경 |
| LWC Stacked Modals (Release Update) | Aura → LWC 모달 마이그레이션. Dynamic Forms 지원 확대 |

### Local Dev GA
Lightning 앱에서 Local Dev(로컬 개발 서버) 정식 출시. 실시간 브라우저 미리보기.

---

## Flow

### Einstein for Flow GA
자연어로 Flow 자동 생성. 정확도 및 속도 개선. 피드백 버튼으로 모델 개선 참여.

### Transform Element — 컬렉션 Join
외부 시스템 컬렉션과 Salesforce 컬렉션을 하나로 결합. 데이터 테이블에 통합 표시.

### Send Email with Attachments in Flow Builder
Send Email 액션에 파일 ID 제공으로 이메일 첨부 파일 지원. 최대 35MB.

### Get Records 레코드 수 제한 옵션
`Get Records` 요소에 상한선 설정(`All records, up to a specified limit`) → 성능 개선, 거버너 한도 리스크 감소.

### Screen Flow 개선

| 기능 | 설명 |
|---|---|
| 자동 트리거 Screen Actions (Beta) | 입력값 변경 시 Autolaunched Flow 자동 실행 (버튼 클릭 불필요) |
| 실시간 유효성 검사 | 포커스 이탈 시 즉시 오류 표시 |
| Built-In Progress Indicator | 단계 표시기 내장 (simple/path 스타일). 코드 없이 진행 상태 표시 |
| 스테이지 할당 간소화 | 화면 속성 에디터에서 직접 스테이지 할당 (별도 Assignment 요소 불필요) |

### Flow URL 파라미터로 특정 요소 포커스
URL 파라미터로 특정 Flow 요소에 바로 이동하는 링크 생성 가능.

### Data Cloud 연동 확장
Data Cloud에서 Email/URL/Phone/Percent/Boolean/Currency 데이터 타입 지원 추가.

---

## Agentforce & Einstein

- **Einstein for Flow GA** — 자연어 Flow 생성
- **Einstein Flow Formula Builder GA** — 자연어로 Flow 수식 작성
- **Einstein Flow Description 생성** — 기존 Flow 요약 자동 생성 (입력/출력 변수, 변경 오브젝트, Subflow 포함)
- **Agentforce 패키징 지원** — Agent Action, Agent Topic, Prompt Template을 1GP/2GP에 패키징 가능

---

## API 변경

### API v21.0–30.0 폐기 일정 변경
Summer '23 → Summer '25로 연기. Summer '25부터 v21.0–30.0 비활성화. **지금 바로 업그레이드 필요.**

### Metadata API 서비스 보호 강화 (Winter '25 이상 신규 org)
`readMetadata()` / `retrieve()` 과부하 시 오류 반환 가능.

### Instance URL → My Domain URL 전환 필수
API 요청의 인스턴스 URL(예: `na44.salesforce.com`) → My Domain URL로 전환.
- 샌드박스: Winter '26(2025년 8월~) 서비스 종료
- 프로덕션: Spring '26(2026년 1월~) 서비스 종료

### Bulk API V2 쿼리 Platform Event (Beta)
`BulkApi2JobEvent`로 Bulk API V2 쿼리 작업 완료/진행 알림 수신. 폴링 불필요.

---

## 개발 환경

### Source Tracking — 특정 Developer Sandbox 활성화 가능
Developer / Developer Pro 샌드박스에서 Source Tracking을 개별적으로 활성화.

### Agentforce 포함 Developer Edition org 제공
신규 Developer Edition에서 Agentforce + Data Cloud 사용 가능.

---

## Release Updates (강제 적용 예정)

| Release Update | 강제 적용 시기 | 설명 |
|---|---|---|
| LWC Stacked Modals | Spring '25 | Aura → LWC 모달 전환 |
| Salesforce 쿠키 first-party 사용 | 미정 | 서드파티 쿠키 차단 대응 |
| 발신자 이메일 주소 인증 | Spring '25 이후 | My Email Settings 이메일 주소 인증 필수 |
| Platform API v21.0–30.0 폐기 | Summer '25 | 레거시 API 버전 요청 차단 |

---


## LWC — 추가 변경사항

### SLDS 2 (Beta) 지원
Spring '25부터 베이스 컴포넌트가 Salesforce Lightning Design System 2 (SLDS 2, Beta)를 지원. 고급 테마/브랜딩 기능 제공. `--slds-c-*` 컴포넌트별 스타일 훅은 SLDS 2에서 미지원이므로 주의.

```xml
<!-- .js-meta.xml — apiVersion 63.0 예시 -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>63.0</apiVersion>
    <isExposed>true</isExposed>
</LightningComponentBundle>
```

### Lightning Web Security — API Distortion 추가
LWS에 신규 보안 distortion 추가. ESLint 규칙도 함께 제공.

신규 distortion 대상:
- `Document.prototype.requestStorageAccess`
- `Element.prototype.setHTMLUnsafe`
- `HTMLIFrameElement.prototype.sandbox` (getter/setter)

변경된 distortion 대상:
- `HTMLIFrameElement.prototype.src` (setter)
- `Window.open`
- `Window: securitypolicyviolation` event

### Native Shadow DOM 전환 — Spring '25 추가 컴포넌트
Spring '25에서 추가로 Native Shadow DOM 준비 완료된 컴포넌트:

| 컴포넌트 | Aura 대응 |
|---|---|
| `lightning-carousel`, `lightning-carousel-image` | `lightning:carouselImage` |
| `lightning-click-to-dial` | `lightning:clickToDial` |
| `lightning-datatable` | `lightning:datatable` |
| `lightning-file-upload` | `lightning:fileUpload` |
| `lightning-input-field`, `lightning-output-field` | `lightning:inputField`, `lightning:outputField` |
| `lightning-record-form`, `lightning-record-edit-form`, `lightning-record-view-form` | `lightning:recordForm` |
| `lightning-tree` | `lightning:tree` |

> 테스트가 내부 DOM 구조에 의존하면 즉시 수정 필요.

---

## Flow — 추가 변경사항

### Flow Builder UX 개선

| 기능 | 설명 |
|---|---|
| 텍스트 템플릿·수식 리소스 선택 개선 | New Resource 생성 시 그룹핑·레이블 개선, 브레드크럼 경로 표시 |
| Collection Filter 자식 리소스 탐색 | Apply Filter Conditions 필드에서 자식 리소스 직접 검색·선택 |
| Undo/Redo/Save As 키보드 단축키 | Ctrl+Z / Cmd+Z (Undo), Ctrl+Y / Cmd+Y (Redo), Shift+Ctrl+S / Shift+Cmd+S (Save As) |

### Prompt Flow 내 Autolaunched Flow Subflow 참조
Prompt Flow에서 활성화된 Autolaunched Flow를 Subflow로 참조 가능 (Wait 요소 포함 Flow는 미지원). 기존에는 Prompt Flow만 참조 가능했음.

### Flow Runtime 버전 변경사항 (API v63.0 이상)

| 변경 | 설명 |
|---|---|
| Data Table 반응성 수정 | Screen Action 출력 컬렉션이 미설정이면 Data Table 내용 자동 초기화 |
| 동명 변수 상속 금지 | 부모 Flow와 참조 Flow에 동일 API명 변수 존재 시 참조 Flow 변수 독립 유지 (부모 값 상속 안 함) |

### Flow Management 개선

**Data Cloud 트리거드 플로우 → 샌드박스에서 프로덕션 배포**
Change Set을 통해 Data Cloud 트리거드 플로우 변경사항을 프로덕션으로 배포 가능.

**Automation Lightning App — Monitor 탭**
신규 Monitor 탭에서 실패·일시정지된 Flow 인터뷰 전체를 한 곳에서 조회. 실패 원인 확인 및 재개 가능.

### Flow Extensions — 커스텀 컴포넌트 유효성 검사 API
LWC 기반 Flow Screen 컴포넌트에서 에러 메시지를 직접 제어할 수 있는 신규 API:

```javascript
// @api 인터페이스로 구현
// 1) validate() — 기존 동작 유지 (다음 화면 이동 전 호출)
// 2) setCustomValidity(externalErrorMessage: string) — Flow의 입력 유효성 에러 메시지를 컴포넌트가 저장
// 3) reportValidity() — 에러 렌더링 시점을 컴포넌트가 제어
import { LightningElement, api } from 'lwc';
export default class MyScreenComponent extends LightningElement {
    _externalError = '';

    @api validate() { /* 기존 유효성 로직 */ return { isValid: true }; }
    @api setCustomValidity(externalErrorMessage) {
        this._externalError = externalErrorMessage;
    }
    @api reportValidity() {
        // 에러 표시 로직
        this.template.querySelector('.error-msg').textContent = this._externalError;
    }
}
```

---

## Flow Orchestration

Spring '25에서 Flow Orchestration에 세 가지 주요 개선이 추가되었다.

### 인터랙티브 스텝 — 커스텀 이메일 알림
각 Interactive Step에서 배정 시 전송할 커스텀 이메일(제목·본문)을 직접 설정 가능. 기존에는 Background Step을 별도로 만들어야 했음.

```
설정 경로: Interactive Step Properties 패널 → Customize notification email 선택 → 제목·본문 입력
```

### 오케스트레이션 오류 처리 — Fault Path
각 Stage에 Fault Path를 추가하여 해당 Stage 또는 그 내부 Step에서 오류 발생 시 실행할 요소를 정의. 오케스트레이션이 오류로 종료될 위험 감소.

```
설정 경로: 오케스트레이션 캔버스에서 Stage 선택 → Add Fault Path 클릭
(2025년 3월 17일 이후 사용 가능)
```

### 개선된 Orchestration Run Details
Automation Lightning App에서 오케스트레이션 실행 상세 정보 레이아웃 개선:
- **Run Details 탭**: 모든 Stage·Step 완료 시간 및 배정자 정보
- **Work Items 탭**: 생성된 Work Item 전체 조회, 재배정 가능
- 실행 중 오케스트레이션 취소·디버그·일시정지 가능

---

## Flow Approval Processes

Flow Orchestration 기반의 신규 승인 워크플로우. 클래식 Approval Processes보다 유연하고 동적 라우팅 지원.

### 주요 기능

| 기능 | 설명 |
|---|---|
| 그룹·Queue 배정 | 승인 스텝을 특정인 대신 Queue 또는 공개 그룹에 배정. 최초 처리자가 완료 시 나머지 접근 불가 |
| 승인 사용자 알림 이메일 | 제출자 및 승인자·대리인에게 커스텀 이메일 알림 전송 |
| 이메일 회신으로 승인/반려 | 승인자가 알림 이메일에 회신하여 Work Item 승인 또는 반려 가능 |

---

## MuleSoft for Flow: Integration GA

Flow Builder에서 서드파티 커넥터를 통해 외부 시스템과 노코드로 연동.

### 핵심 기능

| 기능 | 설명 |
|---|---|
| 서드파티 커넥터 GA | 40개 이상 커넥터를 Flow 트리거 또는 액션으로 사용 (NetSuite, Jira, Slack, Google Gemini, OpenAI 등) |
| Connections 탭 | Automation Lightning App의 Connections 탭에서 모든 외부 연결 통합 관리 |
| External System Change-Triggered Flow | 외부 시스템 변경 감지 시 자동 트리거되는 신규 Flow 타입 |
| In-line Field Mapping | 커넥터 액션 내에서 Transform 기능으로 필드 매핑 |

```
라이선스: MuleSoft for Flow: Integration 애드온 라이선스 필요
권한: Manage Integration Connections 권한 필요
```

GA 커넥터 예시: Anthropic, Asana, DHL Tracking, Discord, Freshdesk, Google Gemini, HubSpot, Jira, Microsoft Entra ID / Excel / Outlook / Power BI, NetSuite, OpenAI, PayPal, QuickBooks Online, Twilio, Zendesk 등 40여 개.

---

## 개발 도구 추가

### Agentforce DX (Beta)
Salesforce CLI와 VS Code로 Agent를 프로코드로 생성·테스트. `@salesforce/plugin-agent` 플러그인으로 제공.

```bash
# 플러그인 설치
sf plugins install agent

# Agent YAML 스펙 생성
sf agent generate agent-spec \
    --type customer \
    --role "Field customer complaints and manage employee schedules." \
    --output-file specs/resortManagerAgent.yaml

# Agent 생성
sf agent create \
    --agent-name "Resort Manager" \
    --spec specs/resortManagerAgent.yaml
```

### Salesforce CLI 주요 개선 (v2.53.6+)
- **data 명령어 확장**: `data export|import|update resume bulk`, `data bulk results`, `data search` (SOSL), `--output-file` 플래그 추가
- **api request**: `sf api request rest` / `sf api request graphql` — REST·GraphQL API를 CLI에서 직접 실행 (Beta)
- **Windows ARM64 지원**: `sf-arm64.exe` 인스톨러 제공
- **Apex 테스트 커버리지**: `sf apex get test --detailed-coverage` 플래그
- **Sandbox 생성 옵션 확장**: `activationUserGroupName` / `activationUserGroupId` 지원

### DevOps Testing GA
DevOps Center에서 AI 기반 테스트·QA 기능 정식 출시. 여러 테스트 제공업체의 테스트 자산을 단일 소스로 관리.

### Data Mask 개선
- **Einstein 커스텀 라이브러리 생성**: Einstein이 Data Mask 커스텀 라이브러리 자동 생성
- **Run on Refresh**: 샌드박스 리프레시 시 마스킹 설정 자동 실행 (다운타임 없음)
- **FedRAMP High 인증**: Salesforce Government Cloud Plus에서 사용 가능

### Database Access Debug Log 카테고리
Developer Console 디버그 로그에 신규 `Database Access` 카테고리 추가. UI에서 접근하는 객체의 규칙·정책 정보 로깅.

---

## API 추가

### OpenAPI Document for sObjects REST API (Beta)
최신 OpenAPI Specification으로 sObjects REST API에 대한 OpenAPI 문서 생성 지원. 주요 개선:
- `/sobjects/{sObject}/updated`, `/query`, `/query/queryLocator` 리소스 포함
- 6시간 요청 큐 제한 제거
- 더 짧은 Base URI 사용

---

## Flow Release Updates (강제 적용 예정)

| Release Update | 강제 적용 시기 | 설명 |
|---|---|---|
| Restrict User Access to Run Flows | Winter '26 | 프로필·권한 세트 없는 사용자의 Flow 실행 차단. FlowSites org 권한 폐기 |
| Enforce Permission Req. for Built-In Apex Class Inputs | Summer '26 | Flow 내 Apex 액션에서 내장 Apex 클래스 입력 시 권한 요구 사항 강제 |
| Enhance Flexibility in Prompt Flows | Spring '25 (강제) | Flex Prompt Template 타입을 Template-Triggered Prompt Flow에서 제거. Manual Input으로 전환 필요 |
| Enforce Rollbacks for Apex Action Exceptions in REST API | 미정 (권고만) | REST API Apex 액션 예외 시 트랜잭션 롤백. Spring '25부터 강제 적용 안 함, 자발적 활성화 권고 |

---

## 관련 노트

- [[Summer '25]] — 다음 릴리즈
- [[Winter '25]] — 이전 릴리즈
- [[FormulaEval Namespace]] — GA된 동적 수식 평가
- [[Scheduled Apex]] — pauseJobById/resumeJobById
- [[Compression Namespace]] — Spring '25에 GA된 gzip/zip 압축 API
