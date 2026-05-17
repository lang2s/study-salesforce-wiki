---
tags: [release, summer_24]
api_version: v61.0
release_date: 2024-06
created: 2026-05-17
source: salesforce_summer24_release_notes.pdf
aliases: [Summer '24, 서머 24]
---

# Summer '24 릴리즈 노트

> API v61.0 | 출시: 2024년 06월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **Apex Cursors (Beta)** — 대용량 SOQL 결과(최대 5천만 행)를 힙 한도 초과 없이 커서 방식으로 처리. Batch Apex 대안
- **Einstein이 Flow 초안 자동 생성 (Beta)** — 자연어 설명으로 Screen/Record-Triggered/Schedule/Autolaunched Flow 생성
- **SOQL 부모-자식 관계 쿼리 5단계로 확장** — 기존 4단계 제한 상향
- **Transform 요소 GA** — Flow Builder에서 컬렉션 데이터 변환 정식 출시
- **Scratch Org Snapshots GA** — 스크래치 오그 구성 스냅샷으로 복제 가능 (90일 유효)
- **External Client App Manager** — OAuth 앱 관리 UI가 Setup에 정식 제공
- **Data Cloud SOQL (Apex)** — Apex에서 Data Cloud DMO 대상 Static SOQL 지원
- **Einstein Copilot 주제 확장** — Handle More Use Cases with Copilot Topics, 새 표준 주제 추가

---

## Apex

### 신규

- **Cursors for Expanded SOQL Query Result Support (Beta)** — 대용량 결과 셋을 커서로 순회. 힙 한도 우회 가능. Queueable 체인에서도 사용 가능

```apex
// Apex Cursor 사용 예시 (Beta) — Database.Cursor
public class QueryChunkingQueuable implements Queueable {
    private Database.Cursor locator;
    private Integer position;

    public QueryChunkingQueuable() {
        locator = Database.getCursor(
            'SELECT Id FROM Contact WHERE LastActivityDate = LAST_N_DAYS:400'
        );
        position = 0;
    }

    public void execute(QueueableContext ctx) {
        List<Contact> scope = locator.fetch(position, 200);
        position += scope.size();
        // 배치 처리 로직
        if (position < locator.getNumRecords()) {
            System.enqueueJob(this);
        }
    }
}
```

Apex Cursor 주요 한도:
- 커서당 최대 행: 5천만 (동기·비동기 모두)
- 트랜잭션당 fetch 호출: 최대 10회
- 일일 최대 커서 수: 10,000개
- 일일 총 행 수: 1억 행 (집계 한도)

- **Evaluate Dynamic Formulas in Apex (Beta)** — SObject를 컨텍스트로 동적 수식 평가. `Formula.builder()`, `FormulaBuilder`, `getReferencedFields()` 신규 추가

```apex
// 동적 수식 평가 예시 (Beta)
FormulaEval.FormulaInstance likelyBuyer = Formula.builder()
    .withType(Account.SObjectType)
    .withReturnType(FormulaEval.FormulaReturnType.BOOLEAN)
    .withFormula('AnnualRevenue > 10000 AND ISPICKVAL(Industry, "Biomechanical")');
```

- **Use SOQL in Apex with Data Cloud Objects** — Data Cloud DMO 대상 Static SOQL 지원. API v61.0부터 `Database.QueryLocator` 및 FOR 루프 사용 가능. Batch Apex는 QueryLocator에서 불가, Iterable은 가능

```apex
// Data Cloud Static SOQL 예시
List<UnifiedIndividual__dlm> unifiedIndividuals = [
    SELECT Id, ssot__FirstName__c, ssot__LastName__c,
           ssot__Email__c, ssot__SkyMilesBalance__c
    FROM UnifiedIndividual__dlm
    WHERE ssot__CompanyId__c = :companyId
];
```

- **Mock SOQL Tests for Data Cloud Objects** — `@isTest` 컨텍스트에서 `SoqlStubProvider` 클래스를 사용해 DMO SOQL 결과 모킹. `Test.createStubQueryRow()`, `Test.createStubQueryRows()`, `Test.createSoqlStub()` 신규 메서드

- **Support for Five-Level Parent-to-Child Relationship SOQL** — Apex에서 5단계 부모-자식 관계 쿼리 지원 (API v61.0+). 각 서브쿼리는 집계 쿼리 카운트에 포함됨. 집계 쿼리 상한은 300

```apex
// 5단계 부모-자식 관계 쿼리 예시
List<Account> accts = [
    SELECT Name,
        (SELECT LastName,
            (SELECT AssetLevel,
                (SELECT Description,
                    (SELECT LineItemNumber FROM WorkOrderLineItems)
                FROM WorkOrders)
            FROM Assets)
        FROM Contacts)
    FROM Account
];
```

- **New InvocableVariable Modifiers** — `@InvocableVariable`에 `defaultValue`, `placeholderText` 수식자 추가. Flow Builder Action 요소에서 사용자 친화적 입력 구성 가능

- **Monitor Apex Scheduled Jobs More Efficiently** — All Scheduled Jobs 페이지에서 스케줄 잡 사용 비율(%) 조회, Cron 표현식 잡 관리, CronTrigger ID 표시 가능

### 변경

- **Private Method Override 방지 (v61.0)** — API v61.0+에서 서브클래스의 인스턴스 메서드가 슈퍼클래스의 `private` 메서드를 더 이상 오버라이드하지 않음. 버전 제어됨
- **ApexTestResult for @testSetup** — `@testSetup` 메서드에 대해 `ApexTestResult` 행 생성. `IsTestSetup` 컬럼, `TestSetupTime` 컬럼 신규 추가
- **View CronTrigger and Batch Job IDs in Error Messages** — 클래스 삭제 시 오류 메시지에 CronTrigger ID, AsyncApexJob ID 표시 (최대 5개)
- **Secure Compilation of Apex Classes** — Setup의 Compile all classes 기능이 이제 일관된 컴파일 결과 생성
- **FOR UPDATE Locks Released Logging** — savepoint 롤백 시 FOR UPDATE 잠금 해제가 디버그 로그에 기록됨
- **Apex Exception Emails 개선** — 미처리 예외 이메일에 Org 이름, My Domain 이름 포함
- **Custom Exceptions equals/hashcode (v61.0)** — `equals()`, `hashCode()` 오버라이드가 Set/Map에서 올바르게 동작
- **getRelationshipOrder for Standard Fields** — 표준 필드에서 primary면 0, secondary면 1 반환 (이전: null)
- **SOQL: Negative Currency Values** — `WHERE Balance__c < USD-500` 같은 음수 통화 값 쿼리 지원
- **SOQL Error Messages 개선** — `MALFORMED_QUERY` 신규 오류 코드, 오류 메시지 문구 개선

### Deprecated / 폐기 예정

- **Data Cloud에서 DMO 접근 시 FLS/레코드 레벨 보안 미지원** — Apex system mode로 접근되며 FLS, record sharing 미지원. `WITH USER_MODE`, `WITH SECURITY_ENFORCED`는 object-level만 체크

---

## LWC

### 신규

- **Navigate to a URL-Addressable LWC** — `lightning__UrlAddressable` 타겟으로 LWC를 URL 경유 접근 가능. Aura 래퍼 불필요

```xml
<!-- myComponent.js-meta.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>61.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__UrlAddressable</target>
    </targets>
</LightningComponentBundle>
```

```js
// 탐색 예시
this[NavigationMixin.Navigate]({
    type: 'standard__component',
    attributes: { componentName: 'c__myComponent' },
    state: { c__propertyValue: '2000' }
});
```

- **Control Utilities Within the Utility Bar** — `lightning/platformUtilityBarApi` 모듈로 LWC에서 Utility Bar API 메서드 사용 가능 (`enableModal`, `open`, `minimize`, `updatePanel` 등)

- **Use Third-Party Web Components in LWC (Beta)** — Open mode에서 `shadowRoot` 객체 접근 허용 (계속 베타)

### 변경

- **LWC API v61.0** — LWC OSS v6.0.0 대응. Light DOM `<slot>` 요소에서 shadow DOM으로 슬롯 포워딩 시 `slot` 속성 명시 필수
- **Light DOM Slot Forwarding 변경** — API v61.0+에서 light DOM 컴포넌트를 named slot에 전달하면 `slot` 속성이 DOM에서 제거됨. Jest 스냅샷 영향
- **Class and Style 속성에 추가 공백 렌더링** — 정적 노드 최적화로 인해 class/style 속성에 여분의 공백 발생 가능
- **Lightning Web Security Enablement Rollout 연기** — 자동 활성화 무기한 연기. 샌드박스에서 수동 테스트 권장
- **API Distortion Changes in LWS** — 웹 API 보안 왜곡 추가 및 일부 변경. ESLint 규칙 업데이트
- **Base Lightning Component Internal DOM 변경** — Native Shadow DOM 지원 준비로 내부 DOM 구조 변경. 테스트가 내부 구조에 의존하지 않도록 검토 필요
- **SLDS Customization 주의** — Salesforce 내부 컴포넌트 SLDS 구현 변경. 비공개 CSS 셀렉터나 SLDS 클래스에 의존하는 커스터마이징은 시각적 회귀 발생 가능
- **`lightning/platformWorkspaceApi`** — Lightning Locker + LWS 모두 지원. 이전에는 LWS 활성화 필요
- **Focus State 대비 개선** — SLDS 포커스 상태 스타일 업데이트 (WCAG 비텍스트 대비 기준 충족). 자동 적용, 비활성화 불가

### 신규 모듈

- `lightning/platformUtilityBarApi` — Utility Bar 제어 (LWC 전용)
- `experience/mobilePublisherConfigApi` (Beta) — Mobile Publisher 네비게이션 설정 접근

### Deprecated

- Visualforce Section Header 이스케이프 기본값 변경 — `escape` 속성 미설정 시 구독 org 설정에 따라 동작. ISV는 명시적 설정 권장

---

## Flow / Automation

### 신규

- **Let Einstein Build a Draft Flow for You (Beta)** — 자연어로 Flow 초안 자동 생성 (Screen, Record-Triggered, Schedule-Triggered, Autolaunched). 최대 6개 요소, 커스텀 오브젝트 포함. Einstein 1 에디션 또는 Einstein for Sales/Service/Platform 애드온 필요. 2024년 7월 16일부터 사용 가능
- **Transform Element (GA)** — 컬렉션 데이터 변환 정식 출시. 저장 전 매핑 오류 사전 검사, 키보드·스크린 리더 접근성 개선
- **Check for Duplicates Before Creating Records** — Create Records 요소에서 중복 레코드 사전 체크 후 건너뛰기 또는 업데이트 선택 가능
- **Repeater Component (GA)** — Screen Flow에서 동일 유형 필드 집합을 여러 건 입력 수집 가능. 커스텀 컴포넌트 포함, 컬렉션 출력으로 레코드 생성 가능
- **Address Component 개선** — Google Maps 기반 주소 검색 필드 추가. Required 필드 지원. ISO 코드 저장 지원
- **Reactive Collection Choice Sets** — Collection Choice Set를 다른 화면 컴포넌트 변경에 반응하여 실시간 업데이트
- **Action Button Component (Beta)** — 화면에서 Autolaunched Flow를 즉시 실행하고 결과 반환
- **Is Blank / Is Empty Operators** — 조건 설정에서 `Is Blank`(텍스트/null 체크), `Is Empty`(컬렉션 체크) 연산자 추가
- **Lock and Unlock Records with an Action** — Flow 액션으로 레코드 잠금/잠금 해제 가능
- **Unlimited Paused and Waiting Flows** — 일시정지·대기 Flow 인터뷰 수 제한 없음
- **Automation Lightning App 전체 공개** — Manage Flows 퍼미션 없이도 일부 요소 접근 허용하는 세분화된 권한 지원
- **Flow Category/Subcategory 분류** — Flow를 카테고리·서브카테고리로 구분 관리
- **Use Threading Tokens in Emails** — 이메일 답장이 올바른 레코드와 연결되도록 스레딩 토큰 사용
- **Flow Orchestration 개선** — 오케스트레이션 수동 Suspend/Resume, 실패 오케스트레이션 재개, Work Item 우선순위 선택, Omni-Channel 라우팅 지원

### 변경

- **Flow and Process Run-Time Changes in API v61.0** — v61.0 런타임의 버전 업데이트 적용
- **Let Einstein Build Flows (Beta)** — Setup에서 Einstein for Flow(Beta) 활성화 필요

### Deprecated

- **Cadence Builder Classic 폐기** — Cadence Builder 2.0으로 전환 필요

---

## Admin / Setup

### 권한 및 사용자 관리

- **User Access Policy (GA)** — 사용자 액세스 자동화 및 마이그레이션 정식 출시 (IdeaExchange 요청)
- **Permission Set/Group Summary (GA)** — 퍼미션 셋 및 그룹에서 활성화된 항목 요약 조회 (IdeaExchange)
- **User Permission Summary** — 특정 사용자의 모든 권한과 접근 권한 요약 조회
- **Public Group 사용처 조회** — 특정 Public Group이 사용되는 위치 확인
- **Freeze Users / Monitor Login History 권한 세분화** — Manage Users 퍼미션 없이 사용자 동결·로그인 히스토리 모니터링 가능

### Lightning App Builder / 레코드 페이지

- **Blank Spaces in Dynamic Forms (IdeaExchange)** — Dynamic Forms 페이지에서 필드 정렬용 빈 공간 추가 가능
- **Tab별 조건부 가시성 (IdeaExchange)** — Lightning App Builder에서 개별 탭에 가시성 규칙 설정 가능
- **Rich Text Headings** — Lightning App Builder에서 서식 있는 텍스트 헤딩 생성
- **Dynamic Forms Custom Fields 페이지 정보** — 커스텀 필드의 Dynamic Forms 활성 레코드 페이지 정보 표시
- **Compact Density 필드 미리보기** — 레코드 페이지 구성 시 Compact Density로 필드 확인

### 일반 Setup

- **Einstein for Formulas** — 수식 구문 오류 자동 수정 제안 (기존 설명 기능에 수정 기능 추가)
- **Add Custom Fields to Dynamic Forms-Enabled Pages** — Dynamic Forms 활성 페이지에 커스텀 필드 직접 추가
- **Register More API Specifications with YAML Support** — External Services에서 YAML 형식 API 스펙 등록 지원
- **List View 성능 개선** — 성능 향상 (Summer '24 중 샌드박스에서만 가용)
- **List View URLs 업데이트** — 리스트 뷰 URL 형식 변경
- **Required Fields Indicator** — Aura 기반 페이지 뷰에서 필수 필드를 한눈에 확인
- **System Informational Banners 색상 변경** — 파란색 → 회색으로 표준화
- **New Setup Domain (*.salesforce-setup.com)** — Setup 페이지가 새 도메인에서 호스팅. 방화벽/허용 목록 업데이트 필요
- **Google Chrome Storage Partitioning** — Summer '24에 Salesforce 도메인에 적용. 임시 비활성화 설정 제공 (Chrome 111–126, 2024년 9월까지)
- **MFA 기본 활성화** — 신규 프로덕션 Org 생성 시 MFA 기본 ON (2024년 4월 8일부터). 30일 유예 기간
- **MFA 비활성화 시 Admin 경고** — MFA 비활성화 시 모든 Admin에게 주기적 In-App 경고 표시

### Search Manager (GA)

- **Search Manager** — 글로벌 검색 채널 구성, 필터 규칙, 항상 검색 오브젝트 선택 정식 출시
- **Search Index 관리** — 오브젝트에서 인덱스 필드 추가/제거 가능
- **FLS in Search** — 민감한 커스텀 필드에 Field-Level Security 적용 (오브젝트당 최대 100개 커스텀 필드 보호)
- **Search Analytics (Pilot)** — 검색 데이터 분석 대시보드 (Data Cloud 라이선스 필요)

### 기타

- **Your Account 인터페이스 개선** — 가로 네비게이션 메뉴, 제품 카탈로그 통합
- **Digital Wallet** — Data Cloud 소비 기반 제품 사용량 실시간 모니터링
- **Better Error Handling for Outdated Pages** — 페이지 버전 불일치 시 강제 새로고침 대신 경고 후 처리 시도

---

## Sales Cloud

- **Einstein Copilot for Sales** — 새 Sales Copilot Topics 추가: Close Deals, Communicate with Customers, Conversation Explorer, Forecast Sales Revenue, Manage Deals
- **Generative Conversation Insights** — 영상 통화에서 고객 감정, 딜 조건 등 커스텀 인사이트 생성
- **Buyer Relationship Map** — 주요 연락처를 구매자 관계 맵으로 시각화
- **Account/Contact 자동 보강** — 이메일·캘린더 인터랙션에서 연락처 자동 생성 및 정보 보강
- **Intelligence Views 액션** — Account, Contact, Lead Intelligence View에서 표준·커스텀 리스트 뷰 액션 사용 가능
- **Collaborative Forecasts 개선** — 예측 그룹화 방식 커스터마이징 가능; Copilot Forecast Guidance 추가 설정
- **Pipeline Inspection 개선** — 추가 액션 지원, 잠재적 위험 연락처 식별
- **Sales Engagement — Cadence Builder 2.0** — Screen Flow를 Cadence 단계로 사용, 이메일 템플릿 포함 Cadence 생성, Cadence 정리 기능
- **Enablement 개선** — Einstein Generative AI 기반 코칭 피드백, 마일스톤 옵션, 프로그램 테스트·배포 간소화
- **Sales Territories** — Enterprise Territory Management가 Sales Territories로 명칭 변경, 유효 커버리지 기간 기반 보상 지원
- **Revenue Intelligence** — Revenue Insights 대시보드 탐색 개선, 커스텀 Fiscal Forecasts 지원
- **Salesforce Maps** — 고용량 데이터 플로팅 성능 향상
- **Salesforce Inbox 폐기** — Inbox Mobile 이미 폐기됨
- **Salesforce for Outlook 폐기 예정** — 2027년 12월 폐기 예정
- **Personal Labels (To Do List)** — 레코드에 개인 레이블 부착으로 구성 및 검색 지원

---

## Service Cloud

- **Einstein Work Summaries for Email (GA)** — 이메일에 대한 작업 요약 정식 출시. 5개 추가 언어 지원
- **Mid-Conversation Summaries** — Voice 및 Messaging에서 대화 중간 요약 (5개 언어 추가)
- **Knowledge 통합 (GA)** — 다양한 출처의 Knowledge를 Salesforce에서 통합 조회
- **Einstein for Service Catalog (Beta)** — AI 기반 케이스 해결 지원
- **Service Catalog** — Service Console에서 Contact용 카탈로그 항목 실행, Lightning Out으로 외부 사이트 노출, 게스트 사용자 접근, Knowledge 통합
- **My Service Journey (Beta)** — Service Cloud 기능 탐색 가이드
- **Messaging — Unified WhatsApp** — Enhanced WhatsApp에서 Unified Messaging으로 마이그레이션 지원
- **Bring Your Own Channel (GA)** — Partner Messaging에서 명칭 변경 후 정식 출시
- **Email-to-Case — Lightning Editor (GA)** — 이메일 에디터가 Lightning Editor로 전환 (Release Update)
- **Omni-Channel for Mobile (Beta)** — 모바일에서 Omni-Channel 지원
- **Routing 개선** — Flow Orchestration Work Item 라우팅, Status-Based Capacity (Beta)
- **Chat (Legacy) 폐기** — Legacy Chat 서비스 종료 예정
- **Social Customer Service Starter Pack 폐기** — 종료 예정
- **Knowledge Article Editor (Release Update)** — Lightning Article Editor + Article Personalization 활성화 Release Update

---

## Experience Cloud

- **Data Cloud 통합 (GA)** — Enhanced LWR 사이트와 Data Cloud 통합으로 방문자 인터랙션 인사이트 수집
- **LWR 사이트 스타일링** — Form/Button 새 스타일링 옵션, 레이아웃·여백 제어 강화
- **Search Manager 검색 결과 레이아웃 (GA)** — 커스텀 검색 결과 레이아웃 구성
- **Headless Identity Framework** — 비헤드리스 로그인 및 게스트 사용자 Identity 흐름을 위한 신규 통합 프레임워크
- **LWR 사이트 Dependent Picklist** — 편집 시 Dependent Picklist 실시간 업데이트
- **Mobile Publisher 업데이트** — 보안 기능 강화, 알림 및 OS 요구사항 대응
- **SEO 개선 (Beta)** — Account/Contact URL 커스터마이징으로 SEO 향상
- **Custom Domain 관리 권한** — 커스텀 도메인 관리에 새롭고 세분화된 사용자 권한 부여
- **Experience Delivery (Pilot)** — LWR 사이트 성능 및 확장성 향상

---

## Slack

> 이 릴리즈의 Slack 업데이트는 별도 Salesforce for Slack Integrations Release Notes에서 관리됨.

- CRM Analytics 대시보드/렌즈 스냅샷을 Slack 채널에 직접 게시 가능
- Salesforce와 Slack을 연동한 고객 연결, 진행 추적, 협업 기능 통합 제공

---

## Data Cloud

- **AI in Data Cloud** — Einstein Studio에서 Anthropic Claude 3 Haiku, Google Gemini Pro 모델 지원. Prompt Builder에서 사용 가능
- **Waterfall Segments (GA)** — 우선순위 기반 세그먼트 중복 제거 정식 출시
- **Sandbox Data Cloud (Beta)** — 샌드박스에서 Data Cloud 메타데이터·구성 복제 및 테스트 가능 (2024년 7월~)
- **Deploy Data Cloud Changes from Sandbox (Beta)** — Data Kit + 체인지 셋으로 Sandbox → Production 배포
- **BYOL Data Federation** — Amazon Redshift, Databricks 데이터 접근 지원
- **Data Graph** — 수정 가능, API로 메타데이터·데이터 쿼리 가능
- **Hybrid Search (Beta)** — 벡터 검색 + 키워드 검색 결합으로 검색 정확도 향상
- **Segment 개선** — 더 적은 클릭으로 세그먼트 생성, Approximate Segment Population으로 빠른 카운트
- **Batch Data Transform 개선** — 커스텀 시간 간격 실행, 행 보안 강화, 다운타임 없는 실행
- **Unstructured Data 지원** — 음성·영상 파일 트랜스크립트 및 인덱싱 (Beta)
- **RAG (Retrieval Augmented Generation)** — Data Cloud에서 RAG 지원으로 생성형 AI 응답 품질 향상
- **Adobe Marketo Engage 커넥터** — Marketo 데이터를 Data Cloud로 가져오기
- **Omnichannel Inventory 커넥터** — 재고 데이터 수집 지원
- **Data Cloud Einstein Lookalikes in Segmentation 폐기 예정** — 세그멘테이션의 Lookalike 기능 폐기 예정

---

## API

| 항목 | 내용 |
|---|---|
| API 버전 | v61.0 |
| REST API — updateOnly 파라미터 | External ID로 레코드 업데이트 전용 (upsert 없이). v61.0+ |
| REST API — OpenAPI Spec sObjects (Beta) | 상세 페이지 및 오류 정보 포함 응답 개선. v61.0+ |
| Connect REST API 레이트 리밋 변경 | Summer '24 이후 신규 Org는 per-org 24시간 Platform API 한도로 통합 (Chatter 전용만 per-user/hour 유지) |
| My Domain Login URL | Instanced URL 사용 API 호출을 My Domain URL로 전환 필수 (2024년 10월 12일부터 미전환 URL 차단) |
| API Only Systems Integrations 프로필 | 구식 표준 프로필을 커스텀으로 변환하여 삭제 가능화. Minimum Access - API Only Integrations로 대체 권장 |
| Change Sets 자동 마이그레이션 | Org 마이그레이션 시 체인지 셋 자동 이관 |
| Platform API v21.0–30.0 폐기 예정 | Summer '25에 폐기. Bulk/SOAP/REST 포함. 현재 사용 시 최신 버전으로 업그레이드 필수 |
| Standard-Volume Platform Events 폐기 | Summer '25에 폐기. High-Volume Platform Events로 마이그레이션 필요 |
| Streaming API v23.0–36.0 폐기 | Winter '25에 폐기. v37.0 이상 또는 Durable Streaming으로 업그레이드 필요 |
| Salesforce Functions 폐기 | 2025년 1월 31일 폐기. 대안 솔루션으로 마이그레이션 필요 |

### Pub/Sub API 개선 (Event Bus)

- **Managed Subscriptions (Beta)** — 소비 이벤트 추적, 재연결 시 마지막 Replay ID부터 재개
- **Publishing Stream Timeout 연장** — 60초 → 30분으로 연장
- **x-client-trace-id 헤더** — Non-Pub/Sub API 오류 트러블슈팅용 클라이언트 추적 ID
- **Real-Time Event Monitoring → Amazon EventBridge** — Event Relay로 실시간 이벤트 모니터링 이벤트 전송
- **Custom Platform Event Channel** — 여러 실시간 이벤트 모니터링 유형을 하나의 스트림으로 구독 (채널당 최대 10개)

---

## 거버너 한도 변경

| 한도 항목 | 이전 | 이후 |
|---|---|---|
| SOQL 부모-자식 관계 쿼리 최대 깊이 | 4단계 | 5단계 |
| Apex Cursor 커서당 최대 행 수 | (신규) | 5,000만 행 |
| Apex Cursor 트랜잭션당 fetch 호출 | (신규) | 10회 |
| Apex Cursor 일일 최대 커서 수 | (신규) | 10,000개 |
| Apex Cursor 일일 총 행 수 (집계) | (신규) | 1억 행 |
| SOQL 집계 쿼리 상한 | 변경 없음 | 300 (5단계 쿼리 포함) |
| 일시정지·대기 Flow 인터뷰 수 | 제한 있음 | 무제한 |

---

## 보안 / 정책

### Identity and Access Management

- **External Client App Manager (Setup)** — OAuth 앱(외부 클라이언트 앱) 관리 UI가 Setup에 정식 제공
- **OAuth 2.0 Token Exchange Handlers** — Setup에서 토큰 교환 핸들러 정의·활성화 가능
- **External Client App OAuth 신규 플로우** — Authorization Code and Credentials Flow, Asset Token Flow, JWT-based Access Token 등 지원
- **Single-Access UI Bridge API** — Salesforce와 커스텀 인터페이스 간 끊김 없는 사용자 경험 생성
- **Custom Domain 관리 권한 세분화** — 새로운 사용자 권한으로 커스텀 도메인 관리 권한 부여
- **MFA 기본 활성화** — 신규 프로덕션 Org에 MFA 기본 ON
- **SAML Framework 마이그레이션 (Release Update)** — 단일 구성 SAML 프레임워크 지원 종료, 다중 구성으로 마이그레이션. 샌드박스는 Summer '24에 강제 적용, 프로덕션은 Spring '25
- **Android Firebase 정보 필수** — Android 모바일 앱 푸시 알림용 Admin SDK 개인 키 및 프로젝트 ID 필수 제공
- **Forced Login 영구 비활성화** — Winter '25에 완전 비활성화
- **Device Flow 매번 승인** — OAuth 2.0 Device Flow 실행 시 매번 사용자 승인 필요
- **Refresh Token Rotation 수정** — Salesforce 자체 인프라 인스턴스에서 Refresh Token Rotation 정상 동작

### Salesforce Backup

- **커스텀 백업 스케줄** — 백업 시간 직접 설정 가능
- **Read-Only Objects 백업** — 읽기 전용 오브젝트 백업 정책에 추가 가능

### Salesforce Shield / Event Monitoring

- **Event Log File Browser (GA)** — Setup에서 이벤트 로그 파일 직접 접근·다운로드 가능
- **Event Log Objects (Beta)** — 실시간 이벤트 데이터를 표준 오브젝트에 캡처, API로 직접 쿼리 가능
- **이벤트 로그 파일 최대 1년 다운로드**
- **Security Center Encryption Policy Metric** — Data Cloud 암호화 정책 상태 조회
- **Data Detect** — Einstein Data Detect가 Data Detect로 명칭 변경
- **FLS 적용 암호화 확장** — Nonprofit Cloud, Net Zero Cloud 데이터 암호화 지원

### 도메인

- **Salesforce Edge Network Scratch Org** — 파티셔닝된 도메인 사용
- **이전 Salesforce 도메인 참조 업데이트** — Winter '25에 리다이렉션 종료 전 참조 업데이트 필요
- **Instanced My Domain 호스트명 리다이렉션 식별** — 인스턴스 기반 URL 리다이렉션 감지

### 쿠키 / 브라우저

- **Salesforce 쿠키 사용 제한 준비** — My Domain에서 `Require first-party use of Salesforce cookies` 설정으로 서드파티 쿠키 제한 테스트 가능
- **Google Chrome Storage Partitioning** — 2024년 9월 3일 이후 Chrome 127+에서 항상 활성화

---

## DevOps / CLI

### 개발 환경

- **Scratch Org Snapshots (GA)** — 스크래치 Org 구성 스냅샷 생성·복제 정식 출시. 90일 유효, Salesforce Platform/Limited Access 라이선스 지원, 언어 변경 가능. CLI 명령: `org create snapshot`, `org list snapshot`
- **Inactive User Freezing** — Developer/Developer Pro 샌드박스에서 60일 미로그인 사용자 자동 동결 (비활성화 불가)
- **New User Permission: Manage Dev Sandboxes** — Developer/Developer Pro 샌드박스만 관리하는 세분화된 권한
- **Selective Sandbox Access 확장** — 60개 이상 Public Group이 있는 Org도 Public Group으로 샌드박스 접근 제어 가능
- **Test Data Cloud in Sandbox (Beta)** — 샌드박스에서 Data Cloud 기능 테스트 가능 (2024년 7월~)

### Data Mask

- **Job Scheduler** — Data Mask 실행 주기 (일/주/월) 자동화
- **Jobs 탭** — Run Logs 탭이 Jobs 탭으로 변경, 마스크별 상세 정보 조회
- **성능 최적화** — 레코드 로딩·변환 최적화, 자동화 바이패스 방식으로 변경

### Salesforce CLI / 도구

- **Salesforce Extensions for VS Code** — 새 문서 사이트로 빠른 시작
- **Code Builder** — 새 문서 사이트
- **Einstein for Developers (Beta)** — AI 기반 코드 어시스턴트
- **Scale Center** — 대규모 앱 배포를 위한 Scale Center, Scale Test 지원

### 패키징

- **2GP for Data Cloud Apps** — 2세대 관리 패키지로 Data Cloud 앱 빠른 구축
- **Async Validation** — 패키지 개발 반복 속도 향상
- **External Client Apps in 2GP** — 2세대 관리 패키지에 External Client App 포함 가능

### Deployment

- **Change Sets 자동 마이그레이션** — Org 마이그레이션 시 체인지 셋 자동 이관. 수동 목록 관리 불필요

---

## Einstein / AI

### Einstein Copilot

- **Copilot Topics 확장** — 더 많은 사용 케이스를 일관되게 처리하는 주제 기반 추론 엔진 개선. 새 표준 주제: Sales(Close Deals, Communicate with Customers, Conversation Explorer, Forecast Sales Revenue, Manage Deals) 등
- **PII 마스킹 설정 제거** — Mask PII 설정이 제거됨
- **Copilot 응답 피드백** — 사용자가 Copilot 응답에 직접 피드백 제공 가능
- **다양한 오브젝트 레코드 표시** — Copilot 응답에 여러 오브젝트의 레코드 포함
- **Copilot Feed 히스토리 초기화**

### Prompt Builder

- **Flex Prompt Templates** — 자유 텍스트 입력으로 유연한 프롬프트 구성
- **다국어 응답** — 더 많은 언어로 프롬프트 응답 수신
- **RAG (Retrieval Augmented Generation)** — Data Cloud 기반 자동 그라운딩. 벡터 검색 + 하이브리드 검색 지원
- **Harmful Content 알림** — 응답에서 유해 콘텐츠 감지 시 알림 표시
- **민감 데이터 마스킹 표시** — 프롬프트에서 마스킹된 데이터 가시화
- **대형 프롬프트 지원** — 더 큰 프롬프트 처리 가능
- **하나의 Apex/Flow로 여러 템플릿 재사용** — 단일 Apex 클래스 또는 Flow를 여러 Prompt Template에서 사용

### Einstein 플랫폼

- **Anthropic Models (Claude 3 Haiku)** — Einstein Studio에서 Anthropic LLM 사용 가능
- **Google Gemini Pro** — Einstein Studio에서 Google Gemini Pro LLM 사용 가능
- **Einstein Data Library (GA)** — 생성형 AI 응답 그라운딩에 사용
- **Models API (Beta)** — 앱에서 LLM 직접 연결
- **Einstein Data Prism** — 최적화된 Einstein 응답 제공
- **Geo-Aware LLM Request Routing** — 지역 기반 LLM 요청 라우팅
- **Supported Models 페이지** — 지원 모델 목록 관리
- **OpenAI GPT 3.5 Turbo 16k 서비스 종료** — 종료 날짜 임박

### Einstein for Developers (Beta)

- 새 문서 사이트로 빠른 시작 제공

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Summer '24에 강제 적용됨 (이미 적용됨)

| 항목 | 영향 | 조치 |
|---|---|---|
| **Allow Only Trusted Cross-Org Redirections** | Salesforce Org 간 리다이렉션 제한 | Trusted URLs for Redirects 허용 목록에 신뢰 Org URL 추가 |
| **Enable EmailSimple Invocable Action to Respect Org-Wide Profile Settings** | EmailSimple 액션이 조직 전체 이메일 주소 프로필 설정 준수 | 이메일 주소 설정 검토 |
| **Enable ICU Locale Formats** | JDK 로케일 형식 → ICU 국제 표준으로 전환 | 날짜·시간·통화 형식 의존 코드 검토 |
| **Grant Access to the Label Object In Custom Profiles** | 커스텀 프로필에서 Label 오브젝트 접근 권한 필요 | 커스텀 프로필에 Label 오브젝트 접근 권한 추가 |
| **SAML Framework Migration (샌드박스)** | 단일 구성 SAML 프레임워크 지원 종료 | 다중 구성 SAML로 마이그레이션. 프로덕션은 Spring '25 |

### Winter '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Create and Verify Default No-Reply OWA** | Organization-Wide Email Address에 Default No-reply 주소 생성·검증 |
| **Disable Access to Session IDs in Flows** | Flow에서 `$Api.Session_ID` 변수 사용 코드 검토 및 제거 |
| **Enable Partial Save for Invocable Actions** | Bulk 외부 REST API 호출에서 Invocable Action 동작 확인 |
| **Enforce Sharing Rules when Apex Launches a Flow** | `with sharing` Apex로 호출되는 Flow의 공유 규칙 적용 검토 |
| **Make Flows Respect Access Modifiers for Legacy Apex Actions** | Public legacy Apex 액션이 포함된 Flow 수정 |
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | Maintenance Plan Frequency/Frequency Type 필드 데이터를 Maintenance Work Rules로 마이그레이션 |
| **Pass the Conversation Intelligence Rule Name as Input to a Flow** | `ruleDevName` 입력 파라미터 처리 로직 추가 |
| **Prevent Guest User from Editing or Deleting Approval Requests** | 게스트 사용자의 Approval Request 편집·삭제 코드 검토 |
| **Restrict User Access to Run Flows** | 프로필·퍼미션 셋으로 Flow 실행 권한 설정. `FlowSites` 권한 폐기 |
| **Run Flows in User Context via REST API** | REST API로 Flow 실행 시 사용자 컨텍스트 적용 확인 |
| **Run Flows in Bot User Context** | Bot 실행 Flow에서 데이터 접근 권한 검토 |
| **Turn On Lightning Article Editor and Article Personalization for Knowledge** | Knowledge 편집기 전환 준비 |
| **Use REST API for External Client App OAuth Consumer Credentials** | Metadata API → Connect REST API로 자격증명 접근 방식 전환 |
| **Streaming API v23.0–36.0 폐기** | Winter '25에 폐기. v37.0+ 또는 Durable Streaming으로 업그레이드 |

### Spring '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Adopt Updated Content Security Policy (CSP) Directives** | Trusted URLs 검토, 외부 폰트·이미지·iframe 영향 확인 |
| **Disable Ref ID and Transition to New Email Threading Behavior** | Email-to-Case 이메일 스레딩 동작 검토 |
| **Enable LWC Stacked Modals** | Lookup에서 레코드 생성 시 Save & New 버튼 제거, post-save 네비게이션 변경 확인 |
| **Enable New Order Save Behavior** | Order Product 업데이트 시 상위 Order 커스텀 로직 실행 |
| **Enable Secure Redirection for Flows** | Flow URL 리다이렉션 파라미터 검토, Trusted URLs 목록 업데이트 |
| **Enforce Permission Requirements Defined on Built-In Apex Classes Used as Inputs** | 파일 기반 Apex 클래스가 입력으로 사용되는 Apex 액션 검토 |
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | REST API Apex 액션 예외 시 롤백 동작 확인 |
| **Enforce View Roles and Role Hierarchy Permission When Editing Public List View Visibility** | Public List View 가시성 편집 권한 검토 |
| **Sort Apex Batch Action Results by Request Order** | Batch 액션 결과 정렬 변경 (오류 우선 → 요청 순서) |
| **Transition to Lightning Editor for Email Composers in Email-to-Case** | Email-to-Case 이메일 에디터 전환 |
| **Use Apex-Defined Variable for All Intelligence Signal Types** | `intelligenceSignals` 입력 파라미터 처리 로직 추가 |
| **Migrate to Multiple-Configuration SAML Framework (프로덕션)** | 단일 구성 SAML → 다중 구성 SAML 마이그레이션. 미적용 시 SSO 중단 |

### Summer '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Evaluate Criteria Based on Original Record Values in Process Builder** | Process Builder 다중 기준 + 레코드 업데이트 평가 로직 검토 |
| **Salesforce Platform API Versions 21.0–30.0 Retirement** | 해당 버전 사용 앱 모두 최신 API 버전으로 업그레이드 필수 |

---

## 연관 패턴 노트 업데이트 필요

- [ ] SOQL 패턴 — 5단계 부모-자식 쿼리 예시 및 Apex Cursor 패턴 추가
- [ ] Batch Apex — Apex Cursor와 Batch Apex 대용량 처리 비교 내용 추가 (Cursor = Batch 대안)
- [ ] @InvocableMethod 패턴 — `@InvocableVariable`에 `defaultValue`, `placeholderText` 수식자 사용법 추가
- [ ] Queueable — Apex Cursor와 Queueable 체이닝 패턴 추가
- [ ] Einstein / Prompt Builder — RAG, Flex Template, Anthropic/Gemini 모델 지원 내용 추가
- [ ] Flow 패턴 — Transform 요소 GA, Einstein 초안 생성, Repeater 컴포넌트 GA, Action Button 추가
- [ ] LWC 패턴 — URL-Addressable LWC, Utility Bar API, Light DOM Slot Forwarding 변경 사항 추가
- [ ] Security 패턴 — External Client App Manager, OAuth 2.0 Token Exchange, MFA 기본값 변경 내용 추가
- [ ] DevOps / Sandbox — Scratch Org Snapshots GA, Inactive User Freezing, Data Cloud Sandbox 추가
- [ ] Data Cloud — Sandbox 지원, SOQL Apex 통합, RAG, Waterfall Segments GA 추가

---

## 관련 노트

- [[Release MOC]]
- [[Spring '24]] — 이전 릴리즈
- [[Winter '25]] — 다음 릴리즈 (미작성)
