---
tags: [release, winter_24]
api_version: v59.0
release_date: 2023-10
created: 2026-05-17
source: salesforce_winter24_release_notes.pdf
aliases: [Winter '24, 윈터 24]
---

# Winter '24 릴리즈 노트

> API v59.0 | 출시: 2023년 10월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **DataWeave in Apex (GA)** — JSON/XML/CSV 데이터 변환을 DataWeave 스크립트로 처리, Apex 런타임에 MuleSoft DataWeave 라이브러리 통합
- **Screen Flow Reactive Components (GA)** — 페이지 이동 없이 동일 화면 내 컴포넌트 간 실시간 반응 (단일 페이지 앱 경험)
- **HTTP Callout in Flow (GA)** — POST/PUT/PATCH/DELETE 지원, Apex 없이 외부 API 호출 가능
- **Code Builder (GA)** — 브라우저 기반 웹 IDE (VS Code + Salesforce Extensions + CLI 통합)
- **Einstein Work Summaries with Generative AI (GA)** — Service Cloud 케이스 요약 자동 생성, 6개 언어 지원
- **Enhanced Domains 강제 적용** — Winter '24부터 모든 org에 강제 적용, 브라우저 서드파티 쿠키 차단 대응
- **MFA 자동 활성화 3단계** — 3번째 그룹 org 대상 MFA 자동 활성화, Summer '24부터 전체 강제 적용 예정
- **Dynamic Forms on LWC-Enabled Standard Objects (GA)** — 300개 이상 표준 오브젝트로 Dynamic Forms 확대

---

## Apex

### 신규

- **Permission Sets for User Mode DB Operations (Developer Preview)** — `AccessLevel.withPermissionSetId()` 메서드로 퍼미션 셋에 지정된 권한으로 DML/SOSL 실행; FLS와 오브젝트 권한을 퍼미션 셋 기준으로 추가 적용

```apex
// 퍼미션 셋 ID로 사용자 모드 DML 실행 (Developer Preview)
// 스크래치 org에서 ApexUserModeWithPermset 피처 활성화 필요
Id permSetId = [SELECT Id FROM PermissionSet WHERE Name='MyPermSet'].Id;
AccessLevel al = AccessLevel.withPermissionSetId(permSetId);
Database.insert(records, al);
```

- **Queueable 최대 체이닝 깊이 설정 (GA)** — `System.maxQueueableDepth`로 체이닝 상한 명시 설정; Developer/Trial 에디션 기본값 5에서 초과 가능

```apex
// Queueable 체이닝 깊이 제어 예시
public class MyQueueable implements Queueable {
    private Integer depth;
    public MyQueueable(Integer depth) { this.depth = depth; }

    public void execute(QueueableContext ctx) {
        System.debug('현재 깊이: ' + depth);
        if (depth < System.maxQueueableDepth) {
            System.enqueueJob(new MyQueueable(depth + 1));
        }
    }
}
```

- **중복 Queueable 잡 방지** — 동일 시그니처 Queueable이 큐에 2번 이상 추가될 때 두 번째부터 exception 발생; 경쟁 상태(race condition) 방지

- **DataWeave in Apex (GA)** — DWL 스크립트를 메타데이터로 생성, Apex에서 직접 호출; 힙/CPU 한도 동일 적용

```apex
// DataWeave in Apex: JSON 변환 예시
DataWeave.Script dwScript = DataWeave.Script.createScript(
    'output application/json\n' +
    '---\n' +
    'payload map (item) -> {\n' +
    '    id: item.Id,\n' +
    '    name: item.Name\n' +
    '}'
);
String inputJson = '[{"Id":"001xx","Name":"Acme"}]';
DataWeave.Result result = dwScript.execute(new Map<String, Object>{'payload' => inputJson});
String outputJson = result.getValueAsString();
```

- **DataWeave 스크립트 Setup UI 열람** — Setup에서 배포된 DataWeave 리소스 리스트뷰 생성 가능 (ID, Name, Namespace, API Version 확인)

- **Comparator 인터페이스 + Collator 클래스** — `List.sort(Comparator)` 커스텀 정렬; `Collator.getInstance()`로 로케일 인식 문자열 정렬

```apex
// Comparator 인터페이스 구현 예시
public class AccountNameComparator implements Comparator<Account> {
    public Integer compare(Account a, Account b) {
        return a.Name.compareTo(b.Name);
    }
}
List<Account> accounts = [SELECT Id, Name FROM Account LIMIT 10];
accounts.sort(new AccountNameComparator());

// Collator 로케일 인식 정렬 (트리거/예상 순서 코드에서 사용 주의)
Collator c = Collator.getInstance();
Integer result = c.compare('apple', 'banana');
```

- **`Iterable` 인터페이스 in For 루프** — 커스텀 Iterable 클래스를 for-each 루프에서 직접 사용 가능

```apex
// Iterable 변수 for 루프 사용 예시
for (MyObject obj : myIterableCollection) {
    // obj 처리
}
```

- **Async Apex 잡 한도 모니터링** — Apex Jobs 페이지에서 24시간 org 비동기 Apex 사용량(%) 실시간 확인

### 변경

- **`getSalesforceBaseUrl()` Deprecated** — API v59.0 이상에서 사용 시 컴파일 에러; `getOrgDomainUrl()` (org URL) 또는 `getCurrentRequestUrl()` (현재 요청 URL) 사용
- **Apex Jobs 리스트뷰 10,000 레코드 상한** — 페이지네이션 오류 방지를 위해 Apex Jobs 리스트뷰에 10,000 레코드 한도 강제 적용
- **직렬화 API 버전 일관성** — 역직렬화 시 직렬화에 사용된 Apex 클래스 API 버전 동일 사용

### Deprecated

- **`getSalesforceBaseUrl()` 메서드** — API v59.0+에서 컴파일 에러 발생; `getOrgDomainUrl()` / `getCurrentRequestUrl()` 으로 대체
- **Developer Console 전체 Apex 자동완성 은퇴 예정** — 리소스 집약적 이슈로 은퇴; 커스텀 Apex 클래스·SObject 자동완성은 유지; VS Code Extensions 또는 Code Builder 사용 권장

---

## LWC

### 신규

- **동적 컴포넌트 가져오기 및 인스턴스화** — 런타임에 알 수 없는 컴포넌트 생성자를 사용해 LWC 동적 로드; Lightning Web Security 활성화 + apiVersion 55.0 이상 필요

```javascript
// 동적 LWC 임포트 예시 (LWS 활성화 필요)
// 정적 분석 가능한 형식만 LWR Sites에서 지원
const { default: ctor } = await import('c/myDynamicComponent');
const el = this.template.createComponent(ctor);
```

- **컴포넌트 수준 API 버전 지정** — `.js-meta.xml`에 `apiVersion` 추가, LWC 프레임워크가 해당 릴리즈 동작 유지; 58.0 이하는 58.0으로 처리

```xml
<!-- .js-meta.xml 예시 -->
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>59.0</apiVersion>
    <isExposed>true</isExposed>
</LightningComponentBundle>
```

- **Toast 알림 생성·관리 (GA)** — `lightning/toast`로 토스트 목록 생성, `lightning/toastContainer`로 LWR 사이트에서 관리

- **Workspace API for Console Apps (Beta)** — `lightning/platformWorkspaceApi` 모듈로 콘솔 앱 워크스페이스 탭/서브탭 제어

- **Custom Component Instrumentation API (Beta)** — LWC 이벤트를 Event Monitoring에서 직접 추적; Aura 컴포넌트 미지원

- **Third-Party Web Components in LWC (Beta)** — 웹 표준 커스텀 엘리먼트를 LWC에서 직접 사용 가능

- **Custom Elements with LWS (Beta)** — LWS 활성화 시 LWC에서 커스텀 엘리먼트 생성 가능 (Web Components 표준 키 기능)

### 변경

- **HTTP 캐싱 TTL 최대 10분** — Aura/LWC 코드 변경 시 UI 반영까지 최대 10분 소요 (Cache-Control 헤더); 디버그 모드 또는 강제 새로고침으로 우회
- **CSS Scope 토큰 난독화** — API v59.0+에서 `cmpName_cmpName` → `lwc-hashstring` 형식으로 변경 (성능 최적화)
- **HTML 유효성 검사 강화** — API v59.0+에서 잘못된 HTML(`</template>` 이중 닫기 태그 등)이 있으면 컴포넌트 로드 에러 발생
- **Base Lightning 컴포넌트 내부 DOM 구조 변경** — 네이티브 Shadow DOM 지원 준비; 내부 DOM 구조에 의존하는 테스트 코드 수정 필요 (`lightning-input` 포함)
- **색상 대비 개선 (WCAG 준수)** — 버튼, 체크박스, 링크, 편집 아이콘 등 전체 Lightning Experience 색상 대비 업데이트; 글로벌 색상 스타일링 훅(`--slds-g-*`) 사용 권장
- **IE11 지원 완전 종료** — Winter '24 이후 Internet Explorer 11에서 Lightning Experience 접근 불가
- **LWR Sites에서 Static Resources에 LWS 적용** — Experience Cloud LWR 사이트의 정적 리소스 코드가 Lightning Web Security 하에서 실행
- **서드파티 사이트의 Lightning 앱에 세션 토큰 사용** — 서드파티 쿠키 차단 브라우저 대응; Session Settings에서 세션 토큰 사용 설정 가능
- **RefreshView API + Lightning Locker 지원** — LWS 없이도 RefreshView API 사용 가능

### Deprecated

- (해당 없음)

---

## Flow / Automation

### 신규

- **Screen Flow Reactive Components (GA)** — 화면 이동 없이 동일 화면의 다른 컴포넌트 입력에 실시간 반응; API v59.0에서 자동 적용, v57.0-58.0은 Process Automation Settings에서 수동 활성화; 글로벌 변수·커스텀 레이블을 반응형 포뮬라에서 사용 가능

- **HTTP Callout (GA)** — GET에 이어 POST/PUT/PATCH/DELETE 방법 지원; 외부 서비스 등록 UI 개선, JSON 샘플 검증 고속화; Apex 없이 Flow에서 외부 서버로 Salesforce 데이터 전송

- **Transform 요소 (Beta)** — Flow 리소스 간 컬렉션 데이터 변환; Loop + Assignment 요소 조합을 단일 Transform 요소로 대체; 화면 Flow·자동 실행 Flow·레코드 트리거 Flow 지원

- **Record-Triggered Flow 커스텀 에러 메시지** — `Custom Error Message` 요소로 레코드 페이지에 팝업 또는 필드 인라인 에러 표시; before-save·after-save Flow 모두 지원, 관련 레코드 변경 롤백

- **Data Cloud 트리거 Flow** — 데이터 모델 오브젝트 또는 계산된 인사이트 오브젝트의 데이터 변경 기반으로 자동 실행 Flow 트리거

- **Flow 저장 중 요소 미완성 허용** — 레코드 트리거 Flow의 Start 요소, 모든 Flow의 Create Records 요소를 완전히 구성하지 않아도 저장 가능; 이전에 저장을 막던 에러가 경고로 변경

- **Wait 요소 사용 가능 Flow 유형 확대** — Wait for Amount of Time / Wait Until Date 요소를 스케줄 트리거 Flow, 자동 실행 Flow, Orchestration에서도 사용 가능 (기존: 저니만 지원)

- **Advanced Pause → Wait for Conditions 이름 변경** — 기능 변경 없이 명칭 통일

- **Flow Orchestration 요구사항 제어 강화** — 평가 Flow 대신 최대 3개 요구사항으로 오케스트레이션 Stage/Step 실행 제어; Flow Orchestration 오브젝트에 커스텀 필드·관계 추가 가능

- **Workflow Rules to Flow 마이그레이션 확대** — 대기 중인 시간 기반 액션이 포함된 워크플로우 규칙, 커스텀 메타데이터 포뮬라가 있는 Process Builder를 Flow로 마이그레이션 지원; Flow 한도 증가로 더 많은 규칙 마이그레이션 가능

### 변경

- **Screen Flow 컴포넌트 상태 변경 시 값 유지** — API v59.0+에서 플로우 일시 중지 재개, 입력 유효성 오류, 이전 화면으로 이동 시에도 사용자 입력값 보존 (Name, Address, Data Table, Email 등)

- **화면 간 값 새로고침 지원 컴포넌트 확대** — choice, Date, Date & Time, Number, Currency, Text, Long Text Area 컴포넌트에서 이전 화면 이동 후 복귀 시 값 갱신 가능

- **Data Cloud 레코드 Flow Builder에서 별도 섹션 분리** — Salesforce 오브젝트와 Data Cloud 오브젝트가 별도 섹션으로 분리 표시

- **Flow Trigger Explorer 필터 추가** — 레코드 트리거 Flow를 빠르게 찾기 위한 필터 기능 추가

- **Slack 액션 호출 방식 변경** — Flow에서 Slack 액션 호출은 이제 Action 요소를 통해서만 가능

### Deprecated

- (해당 없음)

---

## Admin / Setup

### 퍼미션 관리

- **커스텀 퍼미션 셋·그룹 할당 보고 (IdeaExchange)** — 커스텀 퍼미션 셋 및 퍼미션 셋 그룹 할당을 보고서로 확인 가능
- **퍼미션 셋 활성화 항목 쉽게 확인 (Beta)** — 퍼미션 셋에서 활성화된 항목을 더 직관적으로 확인
- **필드 퍼미션 설정 시 전체 필드 선택 (IdeaExchange)** — 필드 퍼미션 구성 시 한 번에 전체 선택 가능
- **퍼미션 셋 그룹 오류 트러블슈팅** — 퍼미션 셋 그룹의 오류 원인 파악 지원
- **오브젝트·필드 퍼미션 API 이름 표시** — 퍼미션 셋에서 오브젝트 및 필드 퍼미션의 API 이름 확인 가능
- **User Access Policy 필터 개선 (Beta)** — 사용자 접근 정책 필터 강화로 자동화 및 마이그레이션 지원
- **Manage Named Credentials 퍼미션 신규 추가** — 사용자가 Named Credentials 및 External Credentials를 수정할 수 있는 권한 별도 부여 가능

### Lightning App Builder / Dynamic Forms

- **Dynamic Forms on LWC-Enabled Standard Objects (IdeaExchange)** — 300개 이상 LWC 지원 표준 오브젝트에서 Dynamic Forms 사용 가능
- **모바일 사용자를 위한 Dynamic Forms (GA)** — 모바일 앱에서도 Dynamic Forms 경험 제공

### 공유 및 보안

- **Account 수동 공유·Account Teams 공유 보고서 (IdeaExchange)** — 누가 Account에 접근 가능한지 보고서로 확인
- **공개 그룹 구성원 보고서 및 그룹 멤버십 변경 Event Monitoring** — 공개 그룹 멤버 조회 및 변경 사항 감사 가능
- **Insufficient Access 오류 Event Monitoring (IdeaExchange)** — 접근 권한 부족 오류를 Event Monitoring으로 추적

### 일반 Setup / UI

- **Related List에 Mass Quick Actions (GA)** — 관련 목록에서 여러 레코드에 대해 Quick Action 일괄 적용
- **List View 접근성 개선** — 리스트 뷰 접근성 향상
- **키보드 단축키 비활성화** — 스크린 리더 등 보조 도구와의 충돌 방지를 위해 Lightning Experience 전체 키보드 단축키 비활성화 옵션
- **레코드 홈 페이지 성능 개선** — 300개 이상 오브젝트 LWC 활성화로 레코드 홈 페이지 성능·접근성 향상
- **파일 공개 링크에 비밀번호·만료일 설정** — 공개 파일 링크에 만료일(기본 30일) 및 비밀번호 보호 추가 가능
- **News, 자동화 Account 필드, Account 로고 은퇴** — 2023년 10월 13일부로 모든 org에서 News 컴포넌트 및 Account 자동화 기능 비활성화

### External Services

- **HTTP Callout에 POST/PUT/PATCH/DELETE 편집 지원** — External Services에서 데이터 쓰기 메서드 편집 가능

### 글로벌화

- **Croatia·Sierra Leone 로케일 업데이트** — 최신 로케일 적용
- **번역 파일 내보내기 언어 필터** — 언어 필터로 번역 파일 내보내기 가속화

---

## Sales Cloud

- **Opportunity Splits 및 팀 감사 이력 (IdeaExchange)** — Opportunity 분할, 제품 분할, 팀 변경 이력 상세 추적; 정확한 판매 보상 보장
- **Pipeline Inspection 개선** — 딜에 관여하는 올바른 인원 확인 기능; Revamped Pipeline Inspection 페이지; 인라인 필드 편집 확대; Collaborative Forecasts와 연동
- **Einstein Conversation Insights — AI 통화 요약 (GA)** — 클릭 한 번으로 음성/화상 통화 요약 생성; 다음 단계·고객 피드백 포함
- **Buyer Assistant (GA)** — 영업 사이클 가속화를 위한 구매자 어시스턴트
- **Revenue Intelligence 강화** — 영업 엔진 건강도 모니터링, Commit 계산기, 제품 세그먼트별 분석
- **Collaborative Forecasts 개선 (IdeaExchange)** — Manager Judgments로 예측 정확도 향상; Forecast 페이지 UI 새단장; 예측 금액 반올림 지원
- **Sales Cloud Einstein — 개인화 영업 이메일 (Pilot)** — Prompt Builder로 컨택 또는 리드에게 맞춤형 이메일 초안 생성; 제품 정보·관련 레코드 포함
- **Cadence 대기 단계 은퇴 예고** — Cadence Wait Steps 은퇴 예정

---

## Service Cloud

### Einstein for Service

- **Einstein Work Summaries with Generative AI (GA)** — AI로 케이스 요약 자동 생성; 영어·프랑스어·독일어·이탈리아어·일본어·스페인어 지원
- **Mid-Conversation Summaries** — 케이스 처리 중 현재까지의 대화 요약 제공
- **Einstein Service Replies (GA)** — 채팅·이메일용 AI 응답 추천; Knowledge 문서 기반 Grounded 응답; 6개 언어 지원
- **Einstein for Service Grounding (GA)** — 케이스·Knowledge 데이터를 기반으로 AI 응답 생성
- **Article Answers AI for Bots (GA)** — 지식 기사 기반 FAQ 자동 답변
- **Cross-Lingual Intent Model (GA)** — 적은 발화문으로 다국어 의도 모델 구축

### 채널

- **Enhanced Apple Messages for Business (GA)** — Apple 메시지 비즈니스 채널 강화 지원
- **Enhanced WhatsApp** — 표준 채널 또는 외부 공급자에서 Enhanced WhatsApp으로 업그레이드
- **Messaging for In-App and Web 강화** — 멀티언어 키워드·응답, 보안 양식, 이용 약관 표시, LWC 기반 Pre-Chat 폼 커스터마이즈

### Knowledge

- **Lightning Article Editor 및 Article Personalization 활성화** — 더 풍부한 기사 편집 경험; 비즈니스 필요에 맞춘 콘텐츠 개인화

### 라우팅

- **Enhanced Omni-Channel (GA)** — 개선된 에이전트 경험 및 Omni Supervisor 경험
- **Interruptible Capacity** — 다중 채널 에이전트 효율성 개선
- **Queue 구성원 변경 감사** — Event Monitoring으로 Queue 멤버십 변경 추적

### Service Intelligence

- **케이스 대시보드·Omni-Channel 대시보드** — 서비스 운영 비용 절감 및 에이전트 성과 모니터링

---

## Experience Cloud

- **Enhanced LWR Sites 기본화** — 새로 생성하는 모든 LWR 사이트가 Enhanced 모드로 생성
- **CMS 워크스페이스 콘텐츠를 Enhanced LWR 사이트에 게시** — CMS 워크스페이스 채널에 Enhanced LWR 사이트 추가 가능
- **Experience Builder에서 컴포넌트에 커스텀 CSS 적용** — Enhanced LWR 사이트의 컴포넌트별 Style 탭에서 CSS 적용
- **표현식 기반 가시성 규칙에 커스텀 로직 사용** — Expression-based Visibility 규칙에 유연한 커스텀 로직 적용
- **Dynamic Redirect Rules (GA)** — LWR 사이트에서 동적 리다이렉트 규칙 지원
- **Actions Bar 컴포넌트 (GA)** — LWR 사이트에서 Actions Bar 컴포넌트 지원
- **Record Detail 컴포넌트 더 많은 레코드 표시·편집 (GA)** — LWR 사이트 Record Detail 컴포넌트 기능 확장
- **JWT 기반 액세스 토큰 (GA)** — Headless Identity 구현에서 JSON Web Token 기반 인증 지원
- **LWR Sites CDN 비활성화 샌드박스 테스트** — 샌드박스에서 CDN 비활성화 영향 사전 테스트 가능
- **컴포넌트 변형 생성 (Beta)** — Enhanced LWR 사이트에서 컴포넌트 변형 생성

---

## Data Cloud

- **Data Cloud 퍼미션 셋 마이그레이션** — 새로운 Data Cloud 퍼미션 셋으로 마이그레이션
- **Data Spaces Feature Permissions** — 데이터 공간 기능 퍼미션으로 접근 세분화
- **Feature Manager** — AI·Beta 기능 활성화/비활성화 관리
- **Google Cloud Vertex AI 모델 연동** — Data Cloud에서 Vertex AI 모델로 개인화 드라이브
- **Snowflake와 준실시간 데이터 공유** — Data Cloud와 Snowflake 간 Near Real-Time 데이터 공유
- **Batch Data Transform** — 데이터 모델 오브젝트 기반 배치 변환 자동화; 여러 출력 노드 지원
- **Data Graphs** — Near Real-Time으로 Customer 360 조회
- **Data Cloud 기반 Account 360도 뷰** — Account에 Data Cloud 데이터 연동
- **Contact·Lead 표준/커스텀 필드에 Data Cloud 인사이트 활성화** — Data Cloud 데이터로 필드 인리치
- **Calculated Insight에 더 많은 메트릭 추가**
- **Waterfall Segments (Pilot)** — 캠페인 우선순위 지정을 위한 폭포수 세그먼트
- **Segment 쿼리·생성 Connect REST API** — Data Space 내 세그먼트 생성·조회 API 지원

---

## Einstein / AI

### Einstein Generative AI (기반 플랫폼)

- **Einstein Trust Layer** — 생성형 AI 기능 전반에 데이터 보안 및 유해 콘텐츠 방지 레이어 적용; LLM 호출 시 데이터 마스킹, 감사 로그
- **Prompt Builder (Pilot)** — 재사용 가능한 프롬프트 템플릿 생성; Sales Email 타입 및 Field Generation 타입 지원; 머지 필드·Flow·Apex로 CRM 데이터 포함

### 클라우드별 생성형 AI 기능

| 클라우드 | 기능 | 상태 |
|---|---|---|
| Sales | 맞춤형 영업 이메일 생성 (Prompt Builder) | Pilot |
| Sales | Einstein AI 통화 요약 생성 | GA |
| Service | Mid-Conversation 요약 | GA |
| Service | Service Replies for Email | GA |
| Service | Einstein for Service Grounding | GA |
| Service | Einstein Work Summaries | GA |
| Commerce | 제품 필드 Einstein 강화 | GA |
| Development | Develop Platform Apps with Ease | GA |

### 일반 Einstein

- **Einstein Search for Knowledge 기본 활성화** — Knowledge 검색 결과에 AI 기반 추천 기본 제공
- **Einstein Search Answers (Pilot)** — 검색 결과에서 Knowledge 기사의 직접 답변 제공
- **Einstein Vision and Language 은퇴 예고** — 2024년 5월 은퇴 예정; OCR 문서는 Salesforce Developer Docs로 이전

---

## Slack

- **Salesforce for Slack Integrations** — Slack과 Salesforce 연동으로 고객 연결, 진행 상황 추적, 협업 강화; PRM for Slack Unified Setup 지원 (파트너 관계 관리); 서비스 케이스의 브로드캐스트 Slack 메시지 업데이트

> 상세 릴리즈 노트는 Salesforce for Slack Integrations Release Notes 참조

---

## API

| 항목 | 내용 |
|---|---|
| 현재 API 버전 | v59.0 |
| JWT 기반 액세스 토큰 (GA) | REST API 호출에 JWT 토큰 인증 사용 가능; Connected App 설정 필요 |
| API v21.0–30.0 은퇴 연기 | Summer '23 예정이었으나 **Summer '25**로 연기; 해당 버전 사용하는 앱은 현재 버전으로 마이그레이션 필요 |
| Streaming API v23.0–36.0 은퇴 예고 | 은퇴 계획 발표 |
| Connect REST API 신규 | 데이터 카테고리 그룹 조회, OAuth 사용량 조회·삭제, Data Cloud 세그먼트 API, Scheduler Waitlist API 등 신규 추가 |
| CRM Analytics REST API | DMO→Dataset 변환, 테이블 위젯 페이지네이션, Grid Layout 위젯 파라미터 오버라이드 지원 |
| Commerce REST API | 카트 아이템·쿠폰·프로모션 관련 응답 바디 확장 |
| Named Credentials REST API | 네임드 크리덴셜의 `calloutStatus`, `createdByNamespace` 속성 신규 추가 |

### 새 REST API 리소스 (주요)

```
GET  /connect/data-category/category-group         → 활성 데이터 카테고리 그룹 조회
GET  /apps/oauth/usage                             → OAuth 앱 사용량 조회
DELETE /apps/oauth/usage/tokens/{tokenId}          → 리프레시 토큰 삭제
POST /wave/data-conversions                        → DMO → Dataset 변환
POST /connect/scheduling/waitlist-checkin          → Scheduler 대기자 체크인
```

---

## 거버너 한도 변경

| 한도 항목 | 이전 | 이후 | 비고 |
|---|---|---|---|
| Queueable 최대 체이닝 깊이 | 고정 5 (Dev/Trial) | `System.maxQueueableDepth`로 설정 가능 | GA |
| Apex Jobs 리스트뷰 레코드 상한 | 무제한 | 10,000 | 페이지네이션 오류 방지 |
| Migrate to Flow 한도 | 기존 | 증가 | 더 많은 워크플로우 규칙 마이그레이션 가능 |

---

## 보안 / 정책

### 도메인

- **Enhanced Domains 강제 적용 (Winter '24 적용 필수)** — 회사별 My Domain 이름이 모든 Salesforce URL에 포함; 서드파티 쿠키 차단 브라우저 지원; 모든 org에 Winter '24부터 강제 적용
- **My Domain 리다이렉션 관련 변경** — 일부 Force.com 사이트 URL 리다이렉션 종료 예고; 사용자에게 새 URL 안내 필요

### MFA

- **MFA 자동 활성화 3단계** — Winter '24에서 3번째 그룹 org 대상 MFA 자동 활성화; Spring '24에서 미활성화 org 전체 완료; **Summer '24부터 강제 적용(Enforcement) 시작**
- **U2F 보안 키 → WebAuthn 마이그레이션** — U2F 보안 키를 WebAuthn 인증으로 업데이트 필요

### Headless Identity

- **Headless 앱 로그인 경험 간소화** — Headless Identity 구현에서 패스워드리스 로그인, 게스트 사용자 ID 지원
- **reCAPTCHA Enterprise 지원** — Headless 등록 보안 강화
- **Headless 등록 핸들러 템플릿 제공** — 빠른 구현을 위한 사전 구성 템플릿

### Named Credentials

- **OAuth 2.0 클라이언트 자격증명 Flow 지원** — Named Credentials에서 클라이언트 자격증명으로 서버 간 인증
- **JWT 인증 프로토콜 지원** — Named Credentials에서 JWT 프로토콜 사용
- **게스트 사용자 Named Credentials 콜아웃** — 게스트 사용자가 Named Credentials를 사용해 콜아웃 가능; 인증 없는 공개 정보 접근 지원

### Privacy & Shield

- **Privacy Center 앱 (신규)** — 기존 관리형 패키지에서 새 Privacy Center 앱으로 전환; Right to Be Forgotten 정책, Privacy Hold(삭제 보류) 지원
- **Salesforce Backup (이름 변경)** — 'Backup and Restore'에서 'Salesforce Backup'으로 재명명; 공유 오브젝트 데이터 백업, 포뮬라 필드 값 백업, 데이터 내보내기 기능 추가
- **Shield Platform Encryption 확장** — 외부 키 관리(External Key Management) 지원; Consent, Gift Entry, Healthcare Provider, Flow Orchestration, Grantmaking 데이터 암호화
- **Event Monitoring 신규 이벤트 타입** — Group Membership Event(그룹 멤버십 변경), Insufficient Access Event(접근 권한 부족)
- **Security Center 강화** — 로그인 IP 범위 모니터링, 테넌트 라이선스 사용량 메트릭, 테넌트 인스턴스 이름 조회

### 기타 보안

- **CSRF 토큰 강화 (Winter '24 강제 적용)** — Lightning 앱마다 다른 CSRF 토큰 생성; 무효·만료 토큰 처리 개선
- **Cross-Org 리다이렉션 제한** — 신뢰할 수 있는 org URL만 Trusted URLs for Redirects 허용 목록에 추가해야 리다이렉션 가능 (Summer '24 강제 적용 예정)
- **카메라·마이크 접근 보호** — 사용자 디바이스 카메라·마이크 접근 제한 설정

---

## DevOps / CLI

### DevOps Center

- **Salesforce CLI 배포 (Beta)** — `sf project deploy pipeline` 명령으로 DevOps Center 파이프라인 스테이지에 배포 또는 Validate-only 배포 실행; DevOps Center 외부에서도 자동화 가능
- **공유 컴포넌트를 가진 Work Item 병합으로 충돌 방지** — 동일 메타데이터 컴포넌트를 공유하는 Work Item 감지 및 결합하여 프로모션 충돌 방지
- **Bundling 단계에서 Validate-Only 배포** — 번들링 스테이지에서 Validate-only·Quick 배포 실행 가능; DevOps Center UI 또는 Salesforce CLI에서 실행

### 개발 환경

- **샌드박스 라이선스 컴플라이언스 변경** — 초과 샌드박스는 잠금 처리(LRU 순서); 60일 이상 잠긴 샌드박스 삭제 및 복구 불가; 알림 이메일 발송
- **샌드박스 접근 사용자 선택 (Selective Sandbox Access)** — 공개 그룹으로 샌드박스 접근 가능 사용자 제한; 그룹 내 사용자만 이메일 주소 원본 형식 유지

### Platform Development Tools

- **Code Builder (GA)** — 브라우저 기반 웹 IDE; VS Code + Salesforce Extensions + Salesforce CLI 통합; Professional 이상 에디션에서 활성화 가능
- **Scale Center** — Unlimited Edition 및 Signature Success 고객용; 앱 확장성 분석·성능 진단 도구; Deep Dive 조사 주당 15회
- **Scale Testing Service (Pilot)** — 프로덕션 피크 부하 재현 테스트; 성능 테스트 서비스

### Salesforce CLI

- Salesforce CLI는 주간 릴리즈; DevOps Center CLI 플러그인 v6.0 이상 패키지 호환

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Winter '24에 강제 적용됨 (지금 이미 적용됨)

| 항목 | 영향 | 조치 |
|---|---|---|
| **Deploy Enhanced Domains** | 모든 org URL 변경; Experience Cloud, Visualforce, Sites URL 포함 | 이미 배포하지 않았다면 즉시 배포 |
| **Disable Access to Session IDs in Flows** | Flow에서 `$Api.Session_ID` 변수 실행 시 해석 불가 | Flow에서 세션 ID 사용 코드 제거 |
| **Enable Faster Account Sharing Recalculation (Case/Contact)** | Account 공유 재계산 방식 변경; Case·Contact 암묵적 공유 레코드 미저장 | 공유 관련 커스터마이즈 검토 |
| **Make Paused Flow Interviews Resume in the Same Context** | 일시 중지된 Flow가 동일 컨텍스트에서 재개; v57.0+ API Flow는 사용자 실행 권한 검증 | Process Builder → Flow 실행 Flow 검토 |
| **Prepare for the Japanese Katakana Style Change** | 일본어 가타카나 번역 스타일 변경 (JIS → 1991 내각 고시 방식) | 일본어 사용 org 검토 |
| **Require an Email Address to Send Chatter Email Notifications** | Chatter 이메일 알림에 검증된 이메일 주소 필수 | Admin에서 이메일 주소 확인 |
| **Salesforce Object ID: 3자리 서버 ID** | 오브젝트 ID 4~6번째 자리가 서버 ID (기존 4~5번째 2자리) | ID 구조에 의존하는 테스트 코드 수정 |
| **Security Enhancements for CSRF Tokens for Lightning Apps** | Lightning 앱마다 개별 CSRF 토큰 생성; 무효·만료 토큰 처리 변경 | Lightning 앱 테스트 실행 |

### Spring '24에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Enable Faster Account Sharing Recalculation (Opportunity)** | Account 자식 Opportunity 암묵적 공유 레코드 미저장; 공유 관련 커스터마이즈 검토 |
| **Enable ICU Locale Formats** | Oracle JDK 로케일 형식 → ICU 국제 표준 로케일 형식; 날짜·통화·숫자 형식 변경; 롤링 방식으로 Spring '24부터 적용 |
| **Enable JsonAccess Annotation Validation for Visualforce Remoting API** | Apex 클래스 `@JsonAccess` 어노테이션 검증; 패키징 네임스페이스 간 직렬화 제어 |
| **Enforce RFC 7230 Validation for Apex RestResponse Headers** | `RestResponse.addHeader()` 헤더명 RFC 7230 기준 검증 |
| **Prevent Guest User from Editing or Deleting Approval Requests** | 게스트 사용자가 승인 요청 편집·재지정·삭제 불가 (승인·거절만 가능) |
| **Turn On Lightning Article Editor and Article Personalization** | Knowledge 기사 에디터 전환 |

### Summer '24에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Allow Only Trusted Cross-Org Redirections** | 신뢰할 수 있는 org URL만 Trusted URLs for Redirects에 추가해야 리다이렉션 허용 |
| **Enable EmailSimple Invocable Action to Respect Organization-Wide Profile Settings** | EmailSimple 액션이 org-wide 이메일 주소 프로필 설정 준수 |
| **Enable New Order Save Behavior** | 주문 제품 업데이트 시 상위 주문에 커스텀 앱 로직 실행 |
| **Run Flows in Bot User Context** | 봇이 실행하는 Flow가 봇 사용자 프로필·퍼미션 셋 기준으로 동작 |
| **Transition to Lightning Editor for Email Composers in Email-to-Case (Beta)** | Email-to-Case 이메일 에디터 Lightning Editor로 전환 |
| **MFA 강제 적용 (Enforcement) 시작** | 모든 직접 로그인 org에 MFA 영구 적용 |

### Winter '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Migrate from Maintenance Plan Frequency Fields to Maintenance Work Rules** | Maintenance Plan의 Frequency·Frequency Type 필드 은퇴 예정; Maintenance Work Rules로 마이그레이션 |
| **Restrict User Access to Run Flows** | 올바른 프로파일 또는 퍼미션 셋이 없으면 Flow 실행 불가; FlowSites 라이선스 Deprecated |

### Spring '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Enforce Rollbacks for Apex Action Exceptions in REST API** | REST API에서 Apex 액션 실행 중 예외 발생 시 트랜잭션 롤백 |

### Summer '25에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Evaluate Criteria Based on Original Record Values in Process Builder** | Process Builder 다중 기준 + 레코드 업데이트 시 원본 필드값 평가 버그 수정 |
| **Salesforce Platform API v21.0–30.0 은퇴** | Bulk/SOAP/REST API v21.0–30.0 완전 비활성화; Summer '25 이전 현재 버전으로 마이그레이션 필수 |

---

## 연관 패턴 노트 업데이트 필요

- [ ] [[Queueable]] — `System.maxQueueableDepth` 설정 방법 및 중복 방지 패턴 추가
- [ ] [[DataWeave in Apex]] — GA 내용, DataWeave 스크립트 메타데이터 방식, Setup UI 열람 방법 추가
- [ ] [[Comparator 인터페이스]] — `List.sort(Comparator)` 및 `Collator.getInstance()` 사용법 정리
- [ ] [[Flow 설계 베스트 프랙티스]] — Reactive Components GA, HTTP Callout GA, Transform(Beta) 도입; Wait 요소 확대 반영
- [ ] [[Flow 에러 처리]] — Record-Triggered Flow Custom Error Message 요소 패턴 추가
- [ ] [[Named Credentials]] — OAuth 2.0 클라이언트 자격증명, JWT 인증 프로토콜 추가
- [ ] [[Enhanced Domains]] — Winter '24 강제 적용 완료 상태 반영
- [ ] [[MFA]] — 자동 활성화 3단계 및 Summer '24 강제 적용 로드맵 업데이트
- [ ] [[LWC API 버전 관리]] — 컴포넌트 수준 `apiVersion` 지정 패턴 추가
- [ ] [[DevOps Center]] — CLI 배포 Beta, Validate-only 배포, 공유 컴포넌트 병합 내용 추가

---

## 관련 노트

- [[Release MOC]]
- [[Spring '24]] — 다음 릴리즈
