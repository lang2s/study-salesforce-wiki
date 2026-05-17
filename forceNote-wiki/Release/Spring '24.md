---
tags: [release, spring_24]
api_version: v60.0
release_date: 2024-02
created: 2026-05-17
source: salesforce_spring24_release_notes.pdf
aliases: [Spring '24, 스프링 24]
---

# Spring '24 릴리즈 노트

> API v60.0 | 출시: 2024년 02월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **Einstein Copilot (GA)** — Salesforce CRM 내장 대화형 AI 어시스턴트. 레코드 요약, 이메일 초안 작성, 기회 분석 등을 자연어 명령으로 처리
- **Prompt Builder (GA)** — 생성형 AI 프롬프트 템플릿을 관리·배포하는 플랫폼. Enterprise/Performance/Unlimited 에디션 지원
- **Apex Null 병합 연산자 (??)** — null 체크를 간결하게 표현하는 연산자 신규 도입 (IdeaExchange 요청)
- **Dynamic Forms — 관련 오브젝트 필드 배치** — 관련 오브젝트의 필드를 Dynamic Forms 활성화 페이지에 직접 배치 가능
- **Dynamic Actions (모바일 표준 오브젝트 지원)** — 표준 오브젝트 모바일 페이지에서 Dynamic Actions 조건부 표시 지원
- **Revenue Lifecycle Management (GA)** — Product Catalog, Pricing, Configurator, Quote/Order Capture, Asset Lifecycle 통합 신규 출시 (2024-02-13)
- **Marketing Cloud Growth 에디션 (GA)** — Salesforce 플랫폼 기반 마케터용 캠페인 관리 솔루션 정식 출시

---

## Apex

### 신규

- **Null 병합 연산자 (`??`)** — 좌측 피연산자가 null이면 우측을 반환. SOQL 쿼리와도 함께 사용 가능

```apex
// 기존 방식
Integer result = (anInteger != null) ? anInteger : 100;

// null 병합 연산자 사용
Integer result = anInteger ?? 100;

// SOQL과 함께 사용 — 결과 없으면 defaultAccount 반환
Account defaultAccount = new Account(name = 'Acme');
Account a = [SELECT Id FROM Account WHERE Id = '001000000FAKEID'] ?? defaultAccount;

// 체이닝 — null safe navigation과 조합
String city = [SELECT BillingCity FROM Account WHERE Id = '001xx000000001oAAA']?.BillingCity;
System.debug('카운트: ' + (city?.countMatches('San Francisco') ?? 0));
```

- **UUID 클래스 신규** — 암호학적으로 안전한 난수 기반 UUID v4 생성 (IdeaExchange 요청)

```apex
UUID randomUuid = UUID.randomUUID();
System.debug(randomUuid); // 예: 550e8400-e29b-41d4-a716-446655440000
String uuidStr = randomUuid.toString();
UUID fromStr = UUID.fromString(uuidStr);
Assert.areEqual(randomUuid, fromStr);
```

- **`Database.releaseSavepoint()` 신규** — savepoint 명시적 해제 후 callout 허용 (IdeaExchange 요청)

```apex
Savepoint sp = Database.setSavepoint();
try {
    insert new Account(name='Foo');
    Integer bang = 1 / 0;
} catch (Exception ex) {
    Database.rollback(sp);
    Database.releaseSavepoint(sp); // savepoint 해제 후 callout 가능
    makeACallout();
}
// 주의: Database.rollback/setSavepoint는 DML 레코드 한도 미적용 (Spring '24부터)
// 단, DML 문 횟수 한도는 여전히 적용됨
```

- **Compression 네임스페이스 (Developer Preview)** — Zip 파일 생성·압축 해제 기능

```apex
// Zip 생성 — 이메일 첨부파일 압축
Compression.ZipWriter writer = new Compression.ZipWriter();
for (ContentVersion cv : [SELECT PathOnClient, VersionData FROM ContentVersion WHERE ContentDocumentId IN :ids]) {
    writer.addEntry(cv.PathOnClient, cv.VersionData);
}
Blob zipBlob = writer.getArchive();

// Zip 압축 해제
Compression.ZipReader reader = new Compression.ZipReader(translationZip);
ZipEntry entry = reader.getEntry('translations/fr.json');
Blob data = reader.extractEntry(entry);
```

- **FormulaEval 네임스페이스 (Developer Preview)** — Apex에서 동적 수식 평가

```apex
FormulaEval.FormulaInstance formula = FormulaEval.FormulaBuilder.builder()
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withType(MotorYacht.class)
    .withFormula('IF(lengthInYards < 100, "Not Super", "Super")')
    .build();
formula.evaluate(aBoat); //=> "Not Super"
```

- **`@InvocableMethod` `capabilityType` 수정자** — Prompt Builder 연동 Apex invocable action 생성 가능

### 변경

- **`Type.forName()` — 잘못된 네임스페이스 지정 시 null 반환** — 이전에는 불확정 결과 반환 (API v60.0 버전 변경)
- **외부 오브젝트 DML 검증 강화** — `Database.insertImmediate()`, `insertAsync()`에 외부/빅 오브젝트 외의 타입 사용 시 `TypeException` 발생. 이 DML은 더 이상 DML 문·레코드 한도에 미적용
- **Quiddity 기본값 변경** — 이벤트 미할당 시 기본값이 `R` (Synchronous Uncategorized)에서 `UD` (undefined)로 변경 (API v60.0)
- **FOR UPDATE 잠금 해제 시 디버그 로그 개선** — callout 발생 시 자동 해제되는 FOR UPDATE 잠금 정보가 디버그 로그에 기록됨
- **Apex REST API HTTP ACCEPT 헤더 기본값 변경** — 누락/잘못된 헤더 시 JSON 응답 기본 반환 (기존: 오류 반환)

### Release Update (Spring '24 강제)

- **`RestResponse.addHeader()` RFC 7230 검증 강제** — Spring '23 도입, Spring '24 강제. `/`와 같은 비허용 문자 포함 시 `InvalidHeaderException` 발생

```apex
// 위반 예: 슬래시 포함 헤더명
RestResponse.addHeader('my/header', 'value'); // InvalidHeaderException!
// 허용: 영문자, 숫자, 하이픈
RestResponse.addHeader('My-Header', 'value'); // OK
```

- **`@JsonAccess` 어노테이션 Visualforce Remoting API 검증 강제** — Winter '23 도입, Spring '24 강제. 관리 패키지 간 역직렬화에 어노테이션 필수

### Deprecated / Retired

- **Salesforce Functions** — 2025년 1월 31일 은퇴 예정. 현재 구독 기간까지는 사용 가능

---

## LWC

### 신규

- **`lightning-record-picker` 컴포넌트 (GA)** — 레코드 검색·선택 컴포넌트. 최대 100건 조회, GraphQL wire adapter 기반으로 오프라인 지원. 새 속성: `field-level-help`, `disabled`, `display-info.primaryField`

```html
<lightning-record-picker
  label="Select a record"
  placeholder="Search..."
  object-api-name="Contact"
  value={initialValue}
  onchange={handleChange}
></lightning-record-picker>
```

- **LWC Workspace API (`lightning/platformWorkspaceApi`) (GA)** — 콘솔 앱의 탭/서브탭 관리. Lightning Web Security 필수

```javascript
import { closeTab, openTab, getAllTabInfo } from 'lightning/platformWorkspaceApi';
// closeTab(), openTab(), focusTab(), getAllTabInfo(), getTabInfo() 등 지원
```

- **Custom Component Instrumentation API (`lightning/logger`) (GA)** — LWC 이벤트를 Event Monitoring에 기록

```javascript
import { log } from 'lightning/logger';
export default class MyComponent extends LightningElement {
    handleClick() {
        log({ type: 'click', action: 'Approve' });
    }
}
```

- **`wave-wave-dashboard-lwc` (Beta)** — CRM Analytics 대시보드를 Lightning 페이지에 임베드

### 변경

- **API v60.0: `this.childNodes` 동작 변경 (Light DOM)** — Web API 표준에 맞게 모든 자식 노드(텍스트, 주석 포함) 반환. 대신 `children`, `firstElementChild`, `lastElementChild` 사용 권장

```javascript
// v60.0 이전: this.childNodes[0]가 첫 슬롯 요소 반환
// v60.0 이후: this.childNodes[0]가 빈 텍스트 노드 반환
// 권장: lwc:ref 또는 this.querySelector 사용
```

- **API v60.0: 비-LightningElement 클래스에서 데코레이터 사용 시 SyntaxError**

```javascript
// 금지 — API v60.0부터 SyntaxError
class MyCustomClass {
    @track myName = { firstName: "", lastName: "" }; // 오류!
}
// 허용
export default class DecoratorExample extends LightningElement {
    @track fullName = { firstName: '', lastName: '' };
}
```

- **API v60.0: Object Rest/Spread Babel 트랜스파일 제거** — 네이티브 문법 사용으로 성능 향상. Babel의 count 버그와 다른 결과 가능
- **Mixed Shadow Mode (`shadowSupportMode = 'native'`) (Beta)** — 네이티브 shadow DOM 렌더링 지원
- **`shadowSupportMode = 'any'` Deprecated** — `'native'`로 교체
- **Lightning Web Security (LWS): 새 API distortion 추가** — `Selection.prototype.collapse` 등 신규 보호
- **LWS: Open shadow root를 자동으로 Closed로 변경** — 보안 강화
- **`lightning-input`: 내부 DOM 구조 변경** — 네이티브 shadow DOM 준비. 기존 테스트·스타일 점검 필요
- **`lightning-datatable`: `wrap-table-header` 속성 신규** — 헤더 텍스트 줄 바꿈 (최대 3줄)
- **`lightning-modal`: 포커스 규칙 변경** — 헤더 있으면 제목에, 없으면 첫 인터랙티브 요소에 포커스
- **`lightning-input-field`, `lightning-record-form`**: 다중 통화 지원 추가. 통화 필드에서 통화 기호 미표시 (소수 형식으로 표시)
- **`lightning/navigation`: `replace` 속성 동작 변경** — `replace=false`일 때 모달에서 새 레코드 저장 후 이전 페이지로 복귀

### Native Shadow 준비 대상 컴포넌트 (Spring '24)

`lightning-alert`, `lightning-badge`, `lightning-button-group`, `lightning-confirm`, `lightning-formatted-address/date-time/email/location/phone/rich-text/text/time/url`, `lightning-input-address/name/location/rich-text`, `lightning-layout`, `lightning-layout-item`, `lightning-menu-subheader`, `lightning-modal`, `lightning-modal-body/footer/header`, `lightning-prompt`

---

## Flow / Automation

### 신규

- **Template-Triggered Prompt Flow** — Flow Builder에서 Prompt Builder와 연동하는 새 플로우 유형. 동적 로직·데이터를 프롬프트 템플릿에 제공
- **Send Data to Data Cloud 액션** — Ingestion API를 통해 코드 없이 Data Cloud로 데이터 전송
- **Repeater 컴포넌트 (Beta)** — 화면 플로우에서 사용자가 필드 세트를 복제 추가 가능 (예: 보험 수익자 다수 입력)
- **Transform 요소 (Beta)** — 컬렉션 합계·카운트 집계 기능 추가 (이전 릴리즈에서 beta 기능 확장)
- **Wait Until Event 요소** — 세그먼트 트리거 플로우에서 이메일/SMS 참여 이벤트(열람, 링크 클릭 등) 기반 재개
- **HTTP Callout Schema 자동 감지** — `Connect for Schema` 옵션으로 API 엔드포인트에 실시간 연결하여 응답 구조 자동 설정
- **Flow Orchestration: 새 사용자 컨텍스트 제어** — API v60.0부터 백그라운드/MuleSoft 스텝의 기본 실행 사용자가 Automated Process User로 변경. 특정 사용자 또는 런타임 리소스 지정 가능
- **Flow Orchestration: 커스텀 보고서 유형** — Orchestration Runs/Stage Runs/Step Runs/Work Items/Run Logs Spring '24 보고서 유형 신규 제공
- **Flow Orchestration: 파우즈 한도 제거** — org당 일시중지·대기 플로우 인터뷰 한도 완전 폐지

### 변경

- **Display Text / Long Text 컴포넌트가 같은 화면 변경에 실시간 반응 (GA)** — 예: 도매가 입력 시 소매가 자동 계산·표시
- **Text Template이 같은 화면 컴포넌트 출력 참조 가능** — Name 컴포넌트 변경 시 텍스트 템플릿 실시간 업데이트
- **사용자 입력 유효성 검사 확장** — Name, Address, Data Table 컴포넌트까지 입력 검증 및 오류 메시지 지원
- **이벤트 트리거 플로우 실행 사용자 선택** — 플로우 트리거 사용자 또는 org 기본 워크플로우 사용자로 실행 선택 가능
- **Flow 빌드 중 저장 범위 확장** — Screen, Action 제외한 요소는 미완성 상태에서도 경고로 저장 가능
- **Flow 리소스 선택 UI 개선** — Delete Records, Get Records, Update Records 요소도 개선된 리소스 선택 경험 적용
- **Migrate to Flow 도구 확장** — 더 많은 프로세스를 플로우로 마이그레이션 지원
- **관리 패키지에서 워크플로우 룰 삭제** — 관리 패키지 내 워크플로우 룰 제거 가능
- **이메일 알림 포함 플로우 식별** — Flow Management에서 이메일 알림이 포함된 플로우를 별도 필터로 식별 가능
- **Flow Orchestration: 작업 항목 이메일 알림 비활성화** — 새 프로세스 자동화 설정으로 기본 이메일 알림 중단 가능
- **Flow Orchestration: 권한 세분화** — `Reassign Orchestration Work Items`, `Manage Orchestration Runs` 권한으로 기능별 접근 제어

### Flow Release Updates (Spring '24 이후 적용 예정)

아래 항목은 `Release Updates (필수 적용 항목)` 섹션 참조.

---

## Admin / Setup

### Lightning App Builder / Dynamic Forms

- **Dynamic Forms — 관련 오브젝트 필드 배치** — 관련 오브젝트 필드를 Dynamic Forms 활성화 레코드 페이지에 직접 드래그·배치 가능. 필드의 Object, API Name 속성 표시 추가
- **Dynamic Forms — 디바이스별 필드 가시성** — 데스크톱/모바일 조건으로 필드 표시/숨김 설정
- **Dynamic Actions (표준 오브젝트, 모바일)** — 표준 오브젝트 모바일 페이지에서 조건부 Dynamic Actions 지원 (IdeaExchange 요청)
- **Dynamic Forms on Mobile 신규 Org 기본 활성화** — Spring '24 이후 생성된 org에서 Dynamic Forms on Mobile 기본 활성화
- **Dynamic Forms on Pinned Region Pages** — 핀 고정 영역 페이지 템플릿에서도 Dynamic Forms 사용 가능
- **관련 목록 레이블 번역** — Dynamic Related List - Single 컴포넌트에서 사용자 정의 레이블로 번역 지원
- **모바일 액션 미리보기** — App Builder에서 Phone 미리보기로 모바일 액션 확인 가능
- **Omni Supervisor 커스텀 탭** — 새 Omni Supervisor Page 타입으로 커스텀 탭 생성 가능

### Permission / 접근 제어

- **Permission Set Groups 전 에디션 지원** — Contact Manager, Group, Essentials 포함 모든 에디션에서 Permission Set Groups 사용 가능
- **사용자에게 할당된 Permission Set 삭제 차단** — Permission Set Group을 통해 사용자에게 할당된 Permission Set 삭제 시 오류 표시
- **User Access Policies (Beta): 피클리스트·그룹·큐 참조 지원** — 사용자 기준 필터에 피클리스트 필드, 그룹, 큐 사용 가능

### Customization

- **Salesforce Connect Adapter for SQL (기존 Amazon Athena)** — Amazon Athena 어댑터를 범용 SQL 어댑터로 리네임. Snowflake, Amazon Athena 등 SQL 기반 외부 소스 지원
- **Snowflake 직접 연결** — Salesforce Connect SQL 어댑터로 Snowflake 데이터를 복사 없이 쿼리·DML 가능 (서비스/지원 에이전트의 Snowflake 인보이스·결제·배송 데이터 접근)
- **Organization-Wide Defaults 업데이트 속도 개선** — 대규모 부모 계정/포털 계정 org에서 OWD 변경이 더 빠르게 처리됨. Background Jobs 페이지에서 진행 상황 모니터링 가능
- **Multi-Select Picklist 선택 시 확인 메시지** — 사용자 정의 필드 생성 시 MSP 타입 선택 시 한계점 안내 (IdeaExchange 요청)
- **AppExchange Explore** — 비즈니스 요구·산업·제품 등 관심사별 AppExchange 솔루션 탐색 기능 신규 추가

### Globalization

- **ICU 로케일 형식 강제 적용 (Rolling 방식으로 Spring '24부터 시작)** — JDK 로케일 형식 은퇴. Spring '25까지 유예 가능. 날짜·시간·통화 형식 국제 표준(ICU)으로 전환
- **English (Italy) 및 Mayan 언어 3개 추가** — Chuj, Kaqchikel, Kiche 플랫폼 전용 언어로 커스텀 레이블·오브젝트 번역 지원

### Analytics (Reports & Dashboards)

- **Analytics 탭에서 폴더 공유 관리** — Reports·Dashboards 탭 공유 기능을 Analytics 탭 하나에서 통합 관리
- **대시보드 일괄 선택** — 여러 대시보드를 동시에 선택해 소유자 변경 등 일괄 처리
- **모바일 대시보드 뷰 저장** — iOS·Android 기기에서 대시보드 개인 뷰 저장 (기존에는 데스크톱만 가능)
- **번개 보고서 필터 필드 업데이트** — 보고서 필터에서 필드 업데이트 가능
- **대시보드 이미지·리치 텍스트·최대 5개 필터** — 모든 에디션에서 대시보드 이미지·리치 텍스트 추가 및 필터 5개까지 지원
- **Tableau Pulse Lightning 컴포넌트** — Tableau Pulse AI 인사이트를 Lightning 앱/홈/레코드 페이지에 임베드

### CRM Analytics

- **Amazon Athena 커넥터 (GA)** — Data Manager에서 Amazon Athena 원격 연결 생성
- **Databricks 커넥터 (GA)** — Databricks 데이터를 Data Manager로 동기화
- **이벤트 기반 레시피 스케줄** — 외부 연결 동기화 또는 CSV 업로드 완료 시 레시피 자동 실행
- **증분 업로드 (GA)** — External Data API로 CSV 파일 증분 로드로 업로드 시간 단축

### Deployment / DevOps

- **샌드박스 선택적 접근** — 퍼블릭 그룹으로 샌드박스 접근 사용자를 서브셋으로 제한 (보안 강화)
- **Scratch Org Snapshots (Beta)** — scratch org 설정 스냅샷 캡처 후 복제. CLI: `org create snapshot`, `org list snapshot`
- **Setup에서 모든 샌드박스 로그인** — 샌드박스 Setup 페이지에서 My Domain 로그인 URL 사용 (IdeaExchange 요청)
- **Metadata API SOAP/REST 배포 한도 증가** — 400 MB → 600 MB
- **Workbench 대체 권고** — Salesforce가 유지하지 않으므로 Code Builder, CLI, VS Code 확장으로 전환 권장
- **패키지 프로파일 설정 제어** — `sfdx-project.json`의 `scopeProfiles` 설정으로 패키징 포함 프로파일 제어
- **2GP 관리 패키지에서 Custom Metadata Type 레코드 제거** — 보호된·공개 레코드 제거 가능 (지원 케이스 필요)

---

## Sales Cloud

### Einstein for Sales

- **Einstein Sales Emails** — 영업 데이터 기반 개인화 이메일 AI 초안 작성. Gmail/Outlook 통합 지원. 커스텀 Prompt Builder 템플릿 사용 가능. 지원 언어: 영어, 프랑스어, 독일어, 이탈리아어, 일본어, 스페인어
- **Einstein Copilot 표준 액션** — Summarize Record (Sales Summaries), Create Close Plan, Find Similar Opportunities, Get Forecast Guidance, Draft or Revise Sales Email, Meeting Follow-Up Email
- **Call Explorer (Einstein Copilot)** — 통화 레코드에서 경쟁사 언급, 코칭 기회 등을 자연어로 질의
- **Einstein Conversation Insights** — Microsoft Teams·Google Meet 호환 추가. 모노 통화 화자 식별 개선

### Sales Fundamentals

- **Seller Home** — 메트릭·목표·제안·작업·활동 개요를 한 화면에서 확인
- **Salesforce Maps Lite** — 지도에서 고객 방문 계획 (대면·원격 혼합)
- **Account Intelligence View** — 계정 활동·기회 메트릭·케이스·활동 로그 통합 뷰

### Sales Engagement

- **Cadence Builder 2.0** — 응답형 케이던스를 더 빠르게·간단하게 구성
- **Quick Cadences에서 콜 스크립트·이메일 템플릿 생성**

### Pipeline Inspection

- **더 반응성 높은 UI**
- **필터 로직 추가** — 더 세밀한 거래 목록 필터
- **레코드 한도 증가** — 모든 메트릭·뷰·차트에서 2,000건

### Collaborative Forecasts

- **커스텀 피클리스트 기반 예측 그룹** — `ForecastingGroup`, `ForecastingGroupItem` 오브젝트 신규
- **조정 값을 분리된 열에 표시**
- **탭으로 빠른 뷰 전환**

### Sales Cloud Everywhere (Chrome Extension)

- **Embedded Side Panel** — 브라우저 내장 사이드 패널, 너비 조정 가능
- **Workspace 다중 레코드 업데이트** — 최대 20개 레코드에서 동일 필드 일괄 수정
- **Contextual Insights** — 방문 중인 웹사이트의 회사·사람을 Salesforce DB와 자동 매칭
- **Einstein Copilot in Everywhere** — Chrome 확장 사이드 패널에서 Copilot 사용

### Retirements

- **Salesforce for Outlook** — 은퇴일 June 2024 → December 2027로 연기
- **Inbox Mobile** — 2024년 2월 1일 은퇴
- **Meeting Studio** — Spring '24 은퇴
- **Social Accounts, Contacts, and Leads** — 은퇴 (Twitter/X, YouTube API 접근 종료)
- **Marketing 앱 리네임** — "Marketing" → "Marketing CRM Classic"

---

## Service Cloud

### Einstein for Service

- **Einstein Work Summaries (GA)** — 케이스 종료 시 대화 요약 자동 생성. 채팅·메시징 채널 다국어 지원 (영·불·독·이·일·서)
- **Einstein Search Answers (GA)** — Knowledge 기반 검색 답변 자동 제공
- **Knowledge Creation (GA)** — 생성형 AI로 Knowledge 기사 자동 작성 초안

### Messaging / Omni-Channel

- **Action Launcher** — 버튼·링크 기반 액션을 에이전트가 검색·클릭으로 즉시 실행. 커스텀 타이틀, 즉시 사용 가능한 배포 구성 추가
- **Omni Supervisor 커스텀 페이지** — 새 Omni Supervisor Page 타입으로 커스텀 슈퍼바이저 탭 생성
- **Messaging for Web — 대화 기록 저장** — 웹 메시징 대화 전문 다운로드 기능

### Email-to-Case

- **Lightning Editor for Email Composers (GA, Release Update)** — 이메일 컴포저가 Lightning Editor로 전환
- **새 이메일 스레딩 동작 (Release Update, Spring '25 강제 예정)** — Ref ID 스레딩 → 보안 토큰 기반 스레딩으로 전환

---

## Experience Cloud

- **Change History 패널** — Experience Builder에서 사이트 게시 변경 이력 확인
- **URL 구성 개선** — SEO 친화적 URL 설정 옵션 확대 (LWR 사이트)
- **Experience Delivery (Pilot)** — 새 LWR 사이트 인프라 (성능·확장성·보안·SEO 향상)
- **Expression-Based Component Variations (GA)** — 조건 기반 컴포넌트 변형 일반 제공
- **보안: 신규 Org 디지털 경험 활성화 후 레코드 접근 기본 보안화** — 2024년 2월 8일 이후 생성 org에서 Roles and Internal Subordinates 그룹과 공유된 레코드는 외부 사용자에게 자동 공유 안 됨
- **CSP 변경 준비** — Winter '25에 예정된 system-defined trusted URL 변경 대비 필요

---

## Data Cloud

- **Einstein Studio (GA)** — AI 모델 관리 허브. 예측 AI 모델 직접 구축, Databricks BYOM, OpenAI/Azure OpenAI 외부 LLM 연결
- **Data Graphs** — 선택된 DMO·관련 오브젝트·Calculated Insights를 JSON blob으로 직렬화하여 빠른 검색 제공 (24시간 주기 갱신)
- **Query Editor** — SQL 쿼리 직접 작성·실행 (mid-March 2024 출시)
- **Snowflake 공유 확장** — 모든 AWS 리전 및 Azure, GCP의 Snowflake 계정과 데이터 공유 가능
- **Google BigQuery 실시간 공유** — BYOL(Bring Your Own Lake) 데이터 공유로 제로카피 BigQuery 통합
- **새 데이터 타입** — email, URL, phone, percent, boolean 타입 지원 추가
- **Amazon Kinesis Connector (GA)** — 스트리밍 데이터 수집
- **Google Cloud Storage 커넥터 개선** — 버킷 이름 반복 입력 불필요
- **Amazon S3 커넥터 신규** — 일회성 인증으로 S3 버킷 연결
- **WhatsApp 데이터 번들** — Marketing Cloud의 WhatsApp 연락처·추적 데이터 수집
- **Data Cloud 2GP 지원** — Salesforce 파트너가 Data Cloud 앱을 second-generation managed packaging으로 개발 가능

---

## API

| 항목 | 내용 |
|---|---|
| API 버전 | v60.0 |
| **신규 사용자 프로필** | `Minimum Access - API Only Integrations` — Salesforce Integration 라이선스와 함께 최소 권한 원칙 적용. Spring '24 이후 신규 org에서 기존 `Salesforce API Only Systems Integration` 프로필 미제공 |
| **XML 역직렬화 제어** | `@JsonAccess` 어노테이션으로 관리 패키지의 Apex 클래스 XML 역직렬화 접근 제어 |
| **Metadata API 배포 한도** | SOAP retrieve / REST deploy: 400 MB → 600 MB |
| **REST API 신규 타입** | Composite 서브요청에서 DateTime 결과 타입 참조 가능 |
| **REST API MRU 헤더** | 레코드 생성·수정·조회 시 Recent Items 업데이트 여부 제어 |
| **GraphQL API** | 로컬라이즈드 레이블 반환, 오브젝트명 충돌 방지 (`_Record` 접미사), 집계 쿼리 참조 무결성, `pageResultCount` 필드, 폴리모픽 필드 displayable 값, 4,000건 초과 페이지네이션 (`upperBound`), 자식 관계 페이지네이션 |
| **Bulk API 2.0** | `isPkChunkingSupported` 필드 신규 (PK chunking 지원 여부 조회). 실패 배치 자동 분할 재시도 |
| **Streaming API v23.0-36.0** | Winter '25 은퇴 예정. v37.0 이상(Durable Streaming) 사용 권장 |
| **Platform API v21.0-30.0 은퇴** | Summer '23에서 Summer '25로 연기. 그 전에 현행 버전으로 업그레이드 필요 |
| **Platform Events** | 미처리 예외 발생 시 Event Log File에 기록 (ApexUnexpectedException 이벤트 타입) |
| **Pub/Sub API Managed Subscriptions (Beta)** | `ManagedSubscribe` RPC로 구독 재개·Replay ID 커밋 관리 |

---

## 거버너 한도 변경

| 항목 | 변경 내용 |
|---|---|
| `Database.rollback()`, `Database.setSavepoint()` | DML **레코드** 한도 미적용 (Spring '24~). 단, DML **문** 한도는 여전히 적용 |
| Metadata API 배포 최대 크기 | 400 MB → 600 MB |
| `lightning-record-picker` 조회 최대 건수 | 50건 → 100건 |
| Pipeline Inspection 레코드 한도 | 모든 메트릭·뷰·차트에서 2,000건 |
| Flow Orchestration 일시중지 한도 | 제한 없음 (기존 org당 사용량 기반 한도 폐지) |

---

## 보안 / 정책

### Identity & Access Management

- **OAuth 2.0 Token Exchange Flow** — 서드파티 ID 공급자의 토큰을 Salesforce 토큰으로 교환. 엔터프라이즈 마이크로서비스 환경에서 통합 패턴 간소화
- **Refresh Token Rotation** — OAuth 2.0 refresh token 로테이션 활성화 옵션
- **External Client App OAuth 2.0 지원** — JWT Bearer Flow, Client Credentials Flow, Device Flow 설정 지원
- **Headless Identity Flows 브랜딩 개선** — OTP 이메일 템플릿 허용 목록으로 여러 브랜드 템플릿 지원
- **SAML 단일 구성 프레임워크 제거 (Release Update)** — 단일 구성 → 다중 구성 SAML 프레임워크 강제 마이그레이션 (Summer '24 강제 예정)
- **PKCE 파라미터 자동 생성** — Proof Key for Code Exchange 파라미터 생성 지원
- **SCIM Users 응답 24시간 형식** — created/lastModified 날짜 24시간 형식으로 변경
- **비밀번호 재설정 내역 추적** — Login History에서 비밀번호 재설정 이력 확인 가능
- **MFA 자동 활성화 완료 (Release Update)** — Spring '24에서 나머지 모든 org에 자동 MFA 활성화

### Named Credentials

- **Basic 인증 프로토콜 지원** — Named Credentials에서 Basic 인증 사용 가능
- **2GP/Unlocked 패키지 배포·검색** — Named Credential 구성을 패키지로 관리 가능
- **Formula 함수 확장 지원** — 커스텀 헤더에서 수식 함수 사용 범위 확대

### Domains

- **레거시 Salesforce 도메인 리다이렉션 종료 준비** — Winter '25에 기존 도메인 리다이렉션 종료. 사전에 참조 업데이트 필요
- **파티션 도메인 확대** — Developer Edition, Scratch Org, Demo Org, Trailhead Playground 대상 파티션 도메인 기본 활성화

### Privacy Center

- **Right to Be Forgotten 자동 실행** — 큐에 있는 RtBF 정책 24시간마다 자동 실행
- **Policy Job 오류 상세 정보** — 실패한 정책 작업의 Related 탭에서 오류 원인 확인
- **샌드박스-프로덕션 간 정책 복사**
- **Preference Manager ↔ Data Cloud 동기화 (Beta)**

### Security Center

- **Guest User Anomaly 탐지** — Threat Detection 앱에서 비정상 게스트 사용자 활동 직접 확인
- **External Key Management** — 모든 상용 존(zone)에서 접근 가능

---

## Architecture

> 플랫폼 구조, 메타데이터 모델, 인프라, 패키징 관련 변경

- **Hyperforce 신규 리전 — South Korea·Sweden 추가 (GA)** — Salesforce Customer 360 앱 스위트(Sales Cloud, Service Cloud, B2B Commerce, Platform, Industries Cloud)를 한국·스웨덴에서 GA 제공. Switzerland·UAE는 요청 기반 제공. 이전 릴리즈 기준 Indonesia·Italy 포함 총 13개국 가용
- **Hyperforce 메이저 릴리즈 무중단 업그레이드 (Summer '24~)** — Summer '24부터 Hyperforce org의 메이저 릴리즈 업그레이드 시 서비스 다운타임 없음. 기존 5분 유지보수 창 폐지; 업그레이드 중 온라인 사용자는 보안 요건상 재로그인 요청
- **새 Setup 도메인 적용 시작** — Setup 페이지가 `*.salesforce-setup.com` 도메인으로 이전. Spring '24부터 샌드박스·비프로덕션 org에 롤링 적용 후 프로덕션 org 적용. 방화벽·허용 목록에 사전 추가 필요
- **Google Chrome Storage Partitioning 임시 옵트아웃** — Chrome 스토리지 파티셔닝이 Summer '24에 Salesforce 도메인에 활성화됨. 신규 설정으로 2024년 9월까지 파티셔닝 비활성화 가능. 공유 스토리지 의존 통합 코드 사전 점검 필요
- **파티션 도메인(Partitioned Domains) 확대** — Developer Edition, Scratch Org, Demo Org, Trailhead Playground에 파티션 도메인 기본 활성화. Salesforce Edge Network의 scratch org에도 적용
- **Metadata API 배포 크기 한도 증가 — 400 MB → 600 MB** — SOAP retrieve 및 REST deploy 최대 크기 상향. 대규모 메타데이터 배포 지원
- **Scratch Org Snapshots (Beta)** — scratch org 설정의 Point-in-time 스냅샷 캡처 후 동일 구성의 scratch org 복제 생성. CLI 명령어: `org create snapshot`, `org list snapshot`. Dev Hub org에서 Scratch Org Snapshots 활성화 필요
- **샌드박스 명의 도메인 로그인 URL 사용** — Sandboxes Setup 페이지에서 로그인 시 인스턴스 URL 대신 샌드박스의 My Domain 로그인 URL 사용. `https://test.salesforce.com` 허용 여부와 무관하게 Setup에서 로그인 가능
- **2GP 관리 패키지 — Custom Metadata Type 레코드 제거 가능** — 보호된·공개 레코드를 2GP 관리 패키지에서 제거 가능(지원 케이스 필요)
- **Data Cloud 2GP 관리 패키지 지원 (2024년 4월~)** — Salesforce 파트너·개발자가 Data Cloud 앱을 second-generation managed packaging으로 개발 가능. scratch org 개발, CLI로 data kit 메타데이터 retrieve, GitHub 공유, 패키지 버전 관리 및 의존성 관리 지원. Salesforce Partners 전용
- **Pub/Sub API Managed Subscriptions (Beta, Spring '24 이후)** — `ManagedSubscribe` RPC로 구독 재개·Replay ID 커밋 관리. 클라이언트 재연결 시 마지막 커밋된 Replay ID부터 구독 재개. Platform Events, Change Events, 커스텀 채널 지원
- **Experience Delivery (Pilot)** — LWR 사이트를 위한 새 호스팅 인프라. 서버 사이드 렌더링(SSR) + 전용 CDN으로 페이지 로드 최대 60% 가속. DDoS 보호·방화벽 규칙·속도 제한 규칙 포함. SEO 향상 및 고트래픽 확장성 제공

---

## Einstein / AI

### Einstein Copilot (GA — 2024년 4월 10일~)

- **대화형 AI 어시스턴트** — 데스크톱, Salesforce 모바일 앱(iOS/Android), Field Service 모바일, Sales Cloud Everywhere 지원
- **Standard Actions 라이브러리** — Answer Questions with Knowledge, Create Close Plan, Draft or Revise Sales Email, Forecast Guidance, Find Similar Opportunities, Identify Record Gaps, Meeting Follow-Up Email, Summarize Record, Query Records, Query Records with Aggregate
- **Custom Actions** — 기존 Flow, invocable Apex, Prompt Template 기반으로 커스텀 액션 생성
- **Copilot Builder** — 액션 관리·대화 미리보기·감사 내역 확인
- **Copilot Analytics 대시보드** — 사용자 참여·액션 성공률·도입 지표 모니터링
- **Welcome Screen** — 첫 접속 시 페이지 컨텍스트 기반 권장 액션 자동 표시
- **독성 언어 경고** — 유해·공격적 언어 생성 시 경고 표시 및 감사 내역 기록

```
필수 라이선스/권한:
- Einstein for Sales, Einstein for Service, 또는 Einstein Platform add-on
- Einstein Copilot for Salesforce User 권한 세트 그룹
```

### Prompt Builder (GA)

- **Enterprise/Performance/Unlimited 에디션 지원**
- **Prompt Template 유형** — Field Generation, Record Summary, Sales Email, Custom, Template-Triggered Prompt Flow 연동
- **Metadata 배포** — `GenAiPromptTemplate`, `GenAiPromptTemplateActv` 메타데이터 타입으로 org 간 배포 가능
- **ConnectApi.EinsteinLLM** — `generateMessagesForPromptTemplate()` 신규

### Einstein Bots

- **Cross-Lingual Intent Model (GA)** — 19개 언어 지원 (아랍어 beta 포함). 인텐트당 1개 발화로도 학습 가능
- **Messaging Components for Enhanced Bots (Beta)** — Authentication, Custom, Form, Payment 메시징 컴포넌트 지원 (Apple Messages for Business, In-App/Web)
- **Dynamic File 전송** — Apex/Flow로 생성된 동적 파일 전송 가능
- **Dialog 자동 번역 (Beta)** — 다국어 봇 대화 자동 번역

### Einstein Studio (Data Cloud)

- **직접 AI 모델 구축** — 클릭만으로 예측 AI 모델 생성 (회귀, 이진 분류)
- **Databricks BYOM** — Databricks 모델과 Data Cloud 데이터 연결
- **서드파티 LLM 연결** — OpenAI, Azure OpenAI 등 외부 LLM을 Foundation Model로 설정
- **Flow Builder 연동** — Einstein Studio 예측 결과를 Flow 액션에서 소비 가능

### Einstein Trust Layer

- **데이터 마스킹** — 민감 데이터를 LLM에 전달 전 자동 마스킹
- **Einstein 감사 데이터** — Data Cloud에 생성형 AI 상호작용 데이터 저장·활용

### 다국어 지원 확장

- 생성형 AI 응답 지원 언어: 영어, 프랑스어, 독일어, 이탈리아어, 일본어, 스페인어

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Spring '24에 강제 적용됨 (이미 적용됨)

| 항목 | 영향 | 조치 |
|---|---|---|
| **Faster Account Sharing Recalculation** (기회 암묵적 자식 공유 미저장) | 기회 공유 재계산 성능 향상. SOQL로 암묵적 공유 레코드 조회 시 결과 없음 | Apex 테스트에서 공유 레코드 조회 코드 점검 |
| **ICU Locale Formats (Rolling)** | JDK 로케일 → ICU 로케일로 전환. 날짜·통화 형식 변경 | 필터·코드·컴포넌트 테스트. Spring '25까지 유예 가능 |
| **JsonAccess Annotation Validation (Visualforce Remoting)** | 관리 패키지 간 비인가 직렬화 차단 | 패키지 호환성 확인 |
| **RFC 7230 Validation for Apex RestResponse Headers** | 비준수 헤더명 사용 시 `InvalidHeaderException` 발생 | Apex REST 클래스 헤더명 점검 |
| **MFA Auto-Enablement for All Remaining Orgs** | 자동 MFA 활성화 최종 단계 | 기존 설정 유지 또는 MFA 등록 지원 |

### Summer '24에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Allow Only Trusted Cross-Org Redirections** | Trusted URLs for Redirects에 신뢰하는 Salesforce org URL 추가 |
| **EmailSimple Invocable Action이 Org-Wide Profile 설정 준수** | 발신 주소 정책 영향 확인. Summer '23 도입, Spring '24에서 연기 |
| **Migrate to Multiple-Configuration SAML Framework** | 단일 구성 SAML 사용 org: 다중 구성으로 마이그레이션 (미적용 시 SSO 중단) |
| **Pass Conversation Intelligence Rule Name as Input to Flow** | 플로우에 `ruleDevName` 파라미터 수신 로직 대비 |
| **Run Flows in Bot User Context** | 봇 시작 플로우가 봇 사용자 권한으로 실행 (기존: 시스템 컨텍스트). 봇 권한 점검 필요 |

### Winter '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Disable Access to Session IDs in Flows** | 플로우에서 `$Api.Session_ID` 변수 사용 제거 |
| **Enable New Order Save Behavior** | 오더 제품 업데이트 시 부모 오더에 커스텀 로직 실행 (트리거·플로우·검증 규칙 영향 확인) |
| **Enable Partial Save for Invocable Actions** | 실패한 개별 invocable action이 전체 트랜잭션 롤백 방지. REST API Bulk invocable 호출 점검 |
| **Enforce Sharing Rules when Apex Launches a Flow** | `with sharing` Apex 클래스로 시작된 플로우가 공유 규칙 준수 |
| **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility** | 공개 목록 보기 가시성 편집 시 `View Roles and Role Hierarchy` 권한 필요 |
| **Make Flows Respect Access Modifiers for Legacy Apex Actions** | Public legacy Apex action 포함 플로우 실패. 패키지 개발자에게 Global로 변경 요청 또는 InvocableMethod로 전환 |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | Frequency/Frequency Type 필드 → Maintenance Work Rules로 마이그레이션 |
| **Prevent Guest User from Editing or Deleting Approval Requests** | 게스트 사용자가 승인 요청 편집·삭제·재할당 불가 |
| **Restrict User Access to Run Flows** | 올바른 프로파일·권한 세트가 없으면 플로우 실행 불가. FlowSites 라이선스 폐기 |
| **Run Flows in User Context via REST API** | REST API로 실행되는 플로우가 실행 사용자 컨텍스트 사용 (기존: 시스템 컨텍스트) |
| **Transition to Lightning Editor for Email Composers in Email-to-Case (GA)** | 기존 이메일 편집기 → Lightning Editor로 전환 |
| **Turn On Lightning Article Editor and Article Personalization for Knowledge** | 새 Knowledge 아티클 편집기·개인화 기능 활성화 |

### Spring '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Disable Ref ID and Transition to New Email Threading Behavior** | Email-to-Case 스레딩을 Ref ID에서 보안 토큰 방식으로 전환 |
| **Enable Secure Redirection for Flows** | 플로우 URL 파라미터 리다이렉션 엄격 검증. 비신뢰 URL 차단 |
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | REST API로 Apex action 실행 중 예외 발생 시 전체 트랜잭션 롤백 |

### Summer '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Evaluate Criteria Based on Original Record Values in Process Builder** | 다중 기준 + 레코드 업데이트 프로세스에서 원래 null 값 평가 수정 |
| **Salesforce Platform API v21.0–30.0 은퇴** | Bulk API, SOAP API, REST API v21.0–30.0 전체 비활성화. 현행 버전으로 업그레이드 필요 |

---

## 연관 패턴 노트 업데이트 필요

- [ ] Apex Null 병합 연산자 (`??`) — 새 연산자 패턴 노트 추가 필요
- [ ] `Database.releaseSavepoint()` — Callout 허용 패턴 업데이트 필요
- [ ] Compression Namespace — Zip 처리 패턴 노트 추가 검토
- [ ] LWC `childNodes` 변경 — Light DOM 관련 패턴 점검
- [ ] LWC 데코레이터 규칙 변경 — 비-LightningElement 클래스 데코레이터 사용 패턴 점검
- [ ] RFC 7230 — Apex REST 헤더 관련 패턴 업데이트
- [ ] ICU Locale 전환 — 날짜·통화 형식 코드 점검
- [ ] Einstein Copilot / Prompt Builder — 새 개발 패턴 노트 추가 검토
- [ ] Flow에서 `$Api.Session_ID` 제거 — 보안 패턴 업데이트
- [ ] SAML 단일→다중 구성 마이그레이션 — Security 패턴 업데이트

---

## 관련 노트

- [[Release MOC]]
- [[Winter '24]] — 이전 릴리즈
- [[Summer '24]] — 다음 릴리즈
