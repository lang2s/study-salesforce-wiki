---
tags: [release, winter_26]
api_version: v65.0
release_date: 2025-10
created: 2026-05-17
source: salesforce_release_notes_5-17-2026 (2).pdf
aliases: [Winter '26, 윈터 26]
---

# Winter '26 릴리즈 노트

> API v65.0 | 출시: 2025년 10월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **Test Discovery/Runner API 도입** — Apex 테스트를 REST API로 탐색·실행 가능 (CI/CD 파이프라인 통합)
- **Flow 내 Transform 인라인 처리** — 별도 Transform 요소 없이 액션 설정 안에서 데이터 변환 가능
- **LWC Local Actions for Screen Flow** — LWC로 Flow 로컬 액션 제작 가능
- **New Agentforce Builder (Beta)** — 서비스·직원 에이전트 통합 빌더. Agent Script로 결정론적 로직 + LLM 결합
- **SLDS 2 (GA)** — CSS Styling Hook 기반 새 디자인 시스템 정식 출시
- **Database Encryption (GA)** — Hyperforce 전체 org 암호화 정식 출시
- **DevOps Center MCP Tools** — LLM으로 머지 충돌 분석·해결. Apex/Flow 테스트를 DevOps Testing에 통합
- **4개 항목 Winter '26 강제 적용** — 이메일 인증, Secure Roles, Flow 실행 권한 제한, Agentforce Service Assistant 라이선스

---

## Apex

### 신규

- **Test Discovery API** — `GET /services/data/v65.0/tooling/tests/` 로 테스트 메서드 목록 조회

```apex
// REST로 테스트 탐색 (외부 CI에서 호출)
// GET /services/data/v65.0/tooling/tests/
// 응답: 테스트 클래스 및 메서드 목록 JSON

// 비동기 실행
// POST /services/data/v65.0/tooling/runTestsAsynchronous/
// Body: {"classNames": "MyApexTest", "testLevel": "RunSpecifiedTests"}
```

- **ApexDoc 주석 형식 표준화** — Apex 문서화를 위한 공식 주석 포맷 지원
- **추상/오버라이드 메서드에 접근 제어자 사용** — `abstract`·`override` 메서드에 `public`/`protected` 등 접근 제어자 지정 가능
- **대용량 External Service Callout 처리** — 힙 한도 초과 없이 대용량 외부 서비스 응답 처리
- **AuraEnabled 컨트롤러 메서드를 Agent Action으로 노출 (Beta)** — 기존 AuraEnabled 메서드를 에이전트 액션으로 재사용

### 변경

- (해당 없음)

### Deprecated

- (해당 없음)

---

## LWC

### 신규

- (해당 없음)

### 변경

- **API v65.0** — 이번 릴리즈에서 커스텀 컴포넌트 대상 버전별 변경 없음
- **Local Dev 미리보기 개선** — 개발 환경 안정성 향상

### Deprecated

- (해당 없음)

---

## Flow / Automation

### 신규

- **액션 설정 내 Transform 인라인 처리** — 별도 Transform 요소 추가 없이 액션 입력값 변환
- **Generative AI 기반 복잡한 의사결정 자동화** — Flow Builder에서 생성형 AI 활용
- **리소스 메뉴 개선** — 리소스 검색 속도 및 UI 향상
- **신규 레코드 즉시 Flow에 추가** — 생성 직후 레코드를 Flow 컨텍스트에 포함
- **중첩 루프로 관련 레코드 다단계 조회 (Beta)** — 여러 수준의 관련 레코드를 중첩 루프로 처리
- **Screen Flow — Apex-Defined Collection을 Data Table에 표시** — 복잡한 데이터 컬렉션 화면 표시
- **Screen Flow — LWC Local Actions** — LWC로 Flow 로컬 액션 구현 가능

```javascript
// LWC Local Action 기본 구조 (screenFlowLocalAction.js)
import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent, FlowNavigationNextEvent } from 'lightning/flowSupport';

export default class ScreenFlowLocalAction extends LightningElement {
    @api inputValue;
    @api outputValue;

    handleChange(event) {
        this.outputValue = event.target.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('outputValue', this.outputValue));
    }

    handleNext() {
        this.dispatchEvent(new FlowNavigationNextEvent());
    }
}
```

- **Flow 디버깅 개선** — 오류 진단 및 수정 효율화
- **Screen Flow 업데이트 디버거** — 화면 플로우 테스트·문제 해결 UI 개선
- **Flow 버전 비교** — 버전 간 차이 확인 도구

### 변경

- **Persistent Logging** — 더 많은 Flow 유형에서 Flow 데이터 영속 로그 지원
- **패키지 하위 Flow 설치 간소화** — 패키지 내 Subflow 설치 과정 단순화
- **Flow의 트랜잭션 필요 여부 자체 결정** — Flow가 트랜잭션 필요 유무를 동적 판단
- **Invocable Apex Action Extension 메타데이터 강화** — 액션 설정 커스터마이징 확장

### Deprecated

- (해당 없음)

---

## API

| 항목 | 내용 |
|---|---|
| API 버전 | v65.0 |
| Test Discovery | `GET /services/data/v65.0/tooling/tests/` |
| Test Runner | `POST /services/data/v65.0/tooling/runTestsAsynchronous/` |
| Flow API 변경 | Flow and Process Run-Time Changes in API v65.0 적용 |

---

## 거버너 한도 변경

변경 없음

---

## Agentforce / Einstein

### GA(정식 출시)된 기능

- **Agent Analytics (GA)** — 에이전트 성능·품질 지표 추적. Agentforce Studio에서 확인 가능
- **Agentforce Optimization (GA)** — 에이전트 효과 분석 및 최적화 인사이트 제공
- **SLDS 2 (Lightning Design System 2, GA)** — CSS Styling Hook 기반의 새 디자인 시스템. 다크 모드(Beta), 밀도 인식 styling hook 지원

### 신규 (Beta)

- **New Agentforce Builder (Beta)** — 서비스·직원 에이전트를 모두 지원하는 새 빌더 UI. Canvas View에서 스크립트 기능 통합
- **Agent Script (Beta)** — 결정론적 로직 + LLM 추론을 결합하는 에이전트 스크립트 언어. if-else 조건, 변수, 토픽 전환 제어 가능
- **Agentforce Testing Center (Beta)** — 멀티턴 테스트 케이스, 테스트 히스토리, 테스트 스위트 클론, 인라인 편집, 커스텀 평가 기준 지원
- **Agentforce Grid (Beta)** — 스프레드시트형 AI 실험 환경. CRM/Data 360 실데이터로 AI 워크플로우 반복 테스트
- **In-Depth Agent Previews (Beta)** — 에이전트 예상 동작 상세 확인 + 변수 추적 + 이유 설명
- **Agentforce Analytics Powered by Tableau Next (Beta)** — Tableau Next 기반 동적 인사이트
- **Ensemble Retrievers in Agentforce Data Library** — 에이전트에 여러 데이터 타입 연결

### 주요 변경

- **모델 옵션 변경** — Claude Sonnet/Haiku 4.5, O3/O4 Mini, GPT 5.x, Gemini 3 Flash/Pro 등 신규 모델 추가·변경
- **Agentforce 24개 추가 언어 지원 (GA)** — 총 24개 언어로 에이전트 대화 가능
- **AI Credit 소비 방식 변경** — 번역 등 Flex Credits 신규 과금 유형 추가
- **Agentforce SDR → Lead Nurturing 명칭 변경**
- **Agentforce IT Service (GA)** — IT 서비스 에이전트 정식 출시
- **Trusted URL Allowlisting** — 에이전트 보안을 위한 신뢰 URL 허용 목록

### Security Center Agentforce 메트릭

- Agentforce 관련 보안 지표 추가: 프롬프트 인젝션 공격 수 모니터링, AI 게이트웨이 사용 이벤트, 에이전트 버전 추적

---

## Admin / Setup

### 리스트 뷰

- **다중 컬럼 정렬 (GA)** — 리스트 뷰를 최대 5개 컬럼 기준으로 정렬 가능
- **타입어헤드 검색** — 리스트 뷰 편집 시 첫 글자 입력으로 필드 빠르게 탐색
- **Dynamic Related List 모바일 아바타 제거** — 모바일에서 Dynamic Related List 아이템 아바타 미표시로 정렬 일관성 확보

### 권한 및 공유

- **Permission Set License 자동 회수** — Permission Set/Permission Set Group 제거 시 관련 PSL 자동 해제 (단, 50개 이상 일괄 제거 시 예외)
- **Secure Roles Behavior 프로덕션 적용 (강제)** — "Roles and Subordinates" → "Roles and Internal Subordinates"로 변경 (Winter '26 강제 적용)
- **공유 재계산 비동기 처리** — 대규모 역할/그룹 변경 후 공유 재계산이 성능 최적화를 위해 비동기로 실행될 수 있음. Setup Audit Trail에서 모니터링 가능

### External Services

- **한도 증가** — 활성 오브젝트 1,250 → 3,000, 활성 오퍼레이션 1,250 → 3,000, 등록 수 150 → 700
- **Binary File 지원** — PUT/GET 오퍼레이션으로 이미지·PDF 등 바이너리 파일을 외부 시스템에 업로드/다운로드 (ContentDocument 활용)

### Setup 홈 페이지 개편

- **새 Setup Home 페이지** — 최근 사용 항목 외 권장 작업 타일, 기능 탐색 타일 추가. Create 버튼은 제거됨

### 필드 및 오브젝트

- **활동 Custom Field 한도 증가** — 활동 7억 개 미만 시 커스텀 필드 최대 300개 (기존 400만 건 기준에서 변경)
- **Field History Tracking UI 개선** — 데이터 분류 세부 정보 포함, 감사/컴플라이언스 프로세스 간소화
- **User Field History Tracking (Beta)** — User 오브젝트에서 최대 20개 필드 변경 이력 추적

### Lightning App Builder

- **Salesforce Flow 기본 레코드 페이지 설정** — Lightning App Builder에서 Flow 오브젝트 기본 레코드 페이지를 모든 앱에 적용 가능
- **Orchestration Run Details 컴포넌트** — Orchestration Run 레코드 페이지에서 단계별 실시간 현황 확인

### Globalization

- **불가리아 통화 변경** — 2026년 1월 1일부터 BGN(레프) → EUR(유로) 전환. Salesforce 내 통화 설정 업데이트 필요

---

## 보안 / 정책

### Identity & Access Management

- **External Client App 자격증명 스테이징·로테이션** — API 엔드포인트를 통해 Consumer Key/Secret 주기적 교체 가능
- **External Client App 모바일 기능 설정** — External Client App 프레임워크에서 모바일 앱 플러그인, 푸시 알림 플러그인 설정
- **JWT 기반 액세스 토큰 타임아웃 연장** — 최대 12시간까지 설정 가능 (기존 30분 한도). 프로파일/org 세션 설정 적용 가능
- **이메일 주소로 비밀번호 재설정** — 사용자명 없이도 이메일만으로 비밀번호 재설정 가능
- **보안 질문 최소 5자 요건** — Winter '26 이후 설정하는 보안 질문 답변은 최소 5자
- **신규 Org 인증 방법 전체 표시** — 새 Org에서 사용자가 인증 방법 등록 시 모든 옵션 기본 표시
- **SAML 오류 메시지 개선** — InResponseTo 속성 만료 시 타임스탬프 명시
- **단일 SAML 프레임워크 제거 (Spring '26 적용 예정)** — 다중 구성 SAML 프레임워크로 마이그레이션 필요

### 도메인 변경

- **레거시 호스트명 리다이렉션 종료 (Winter '26 자동 활성화, Spring '26 강제)** — 기존 레거시 URL 리다이렉션이 프로덕션에서 종료
- **Instanced URL API 트래픽 교체** — My Domain 로그인 URL로 교체 필요 (Summer '26에 종료)
- **일본 전용 Salesforce Edge Network 라우팅** — 일본 인스턴스 대상 지역 내 라우팅 옵션 추가
- **사용자명에 Zero-Width Space 문자 금지** — 보이지 않는 유니코드 문자 포함 시 오류 반환

### Salesforce Shield

- **Database Encryption (GA)** — Hyperforce 전체 org 암호화 정식 출시
- **Platform Encryption for Data Cloud — Tableau Next 지원** — Tableau Personal Org 암호화 가능
- **Data Detect 확장** — 100개 오브젝트, 200개 필드 스캔. 커스텀 민감 데이터 타입 정의 가능
- **Field Audit Trail — 보존 정책 선언적 정의** — 코드 없이 보존 정책 설정 가능
- **Real-Time Events — 에이전트 데이터 접근 모니터링** — 에이전트의 데이터 접근 활동을 Real-Time Event로 추적
- **Platform Tracing** — 에이전트 활동 End-to-End 가시성. Data Cloud에 데이터 저장

### AWS Secrets Manager 연동

- **managed external secrets** — AWS Secrets Manager로 OAuth 자격증명을 노출 없이 관리·자동 로테이션

---

## DevOps / CLI

### DevOps Center

- **DevOps Center MCP Tools** — Salesforce DX MCP Server에서 머지 충돌을 LLM으로 분석·해결
- **Apex Unit Testing 통합 (DevOps Testing)** — Apex 유닛 테스트를 DevOps Testing 테스트 프로바이더로 등록. 품질 게이트, 테스트 실행, 결과 분석 통합
- **Flow Testing 통합 (DevOps Testing)** — Flow 테스트를 DevOps Testing에서 직접 관리. 품질 게이트, 결과 분석 가능
- **DX Inspector — 소스 저장소 직접 커밋** — Change Management 페이지에서 DevOps Center로 전환 없이 바로 커밋
- **DX Inspector 옵트인 필수** — Terms and Conditions 동의 후 Change Management 페이지 접근 가능

### Salesforce DX / CLI

- **Salesforce DX MCP Server (Beta)** — 자연어로 Salesforce DX 작업 수행 (org 조회, 배포, 패키지 등)
- **LWC MCP Tools (Beta)** — IDE에서 자연어 프롬프트로 LWC 개발, 테스트, 최적화, Aura→LWC 마이그레이션 지원
- **`sf package version retrieve` 명령어 추가** — 특정 패키지 버전의 메타데이터를 로컬로 다운로드
- **2GP 완전 전환 지원** — 1GP에서 2GP로 패키지 개발 완전 이전 가능 ("Move to 2GP" 버튼)
- **1GP 관리 패키지 버전 Beta 되돌리기** — Released 버전을 Beta로 되돌리는 기능 추가

### 샌드박스

- **Full Sandbox Quick Create (Hyperforce)** — Hyperforce 인스턴스에서 Full Sandbox 생성·갱신 속도 2~3배 향상
- **Quick Clone — 전체 샌드박스 타입 지원** — Developer, Developer Pro, Partial, Full 모두 지원으로 확장

### 기타

- **Salesforce Functions 서비스 종료** — 신규 구매·갱신 불가. 기존 계약 기간 내 사용 후 대체 솔루션으로 마이그레이션 필요
- **Change Data Capture — 커스텀 Formula 필드 포함** — 변경 이벤트에 커스텀 수식 필드 값 포함
- **Data Export 다운로드 속도 제한** — 파일 1개씩, 다운로드 간 60초 대기 (Summer '25부터 적용)

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Winter '26에 강제 적용됨 (즉시 확인 필요)

| 항목 | 영향 | 조치 |
|---|---|---|
| **Confirm Verified Email Addresses for Users Created in 2016 and Earlier** | 2016년 11월 1일 이전 생성 사용자의 이메일 미인증 시 Salesforce에서 이메일 발송 불가 | 해당 사용자 이메일 인증 |
| **Enable Secure Roles Behavior (Production)** | "Roles and Subordinates" 공유 그룹이 "Roles and Internal Subordinates"로 변경. Experience Cloud 사용 시 외부 사용자 레코드 접근 차단 | 코드·커스터마이징에서 그룹명 참조 업데이트 |
| **Restrict User Access to Run Flows** | 올바른 Profile/Permission Set 없는 사용자는 Flow 실행 불가. FlowSites org 권한 deprecated | 사용자에게 Flow 실행 권한 부여 확인 |
| **Update Licenses for Agentforce Service Assistant Users** | Salesforce 라이선스에서 Service Assistant 권한 제거. Service Planner User PSL 필요 | 해당 사용자에게 Service Planner User PSL 할당 |

### Winter '26에 자동 활성화됨 (Spring '26에 강제)

| 항목 | 준비 사항 |
|---|---|
| **Update References to Legacy Host Names** | 프로덕션·데모 Org에서 레거시 호스트명 리다이렉션 자동 비활성화. Spring '26 강제. My Domain에서 옵트아웃 가능 |

### Spring '26에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Migrate to a Multiple-Configuration SAML Framework** | 단일 구성 SAML 프레임워크 제거. SSO 중단 방지를 위해 다중 구성 SAML로 마이그레이션 |
| **Escape the Label Attribute of `<apex:inputField>` (XSS 방지)** | Visualforce 페이지의 `<apex:inputField>` label 속성 자동 이스케이프 처리 |
| **Calculate Tax-Only and Product-Only Price Adjustments** | 세금·제품 전용 가격 조정이 세율 계산에 포함됨 |

### Summer '26에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Enforcing No-Argument Constructor on Apex Classes for Invocable Action Parameters** | Invocable Action 파라미터로 사용하는 Apex 클래스에 no-argument 생성자 필수 (Summer '24부터 예고, 시행 연기됨) |
| **Sort Apex Batch Action Results by Request Order** | Apex 배치 액션 결과가 요청 순서대로 정렬 (현재 오류 우선 정렬에서 변경) |
| **Update Instanced URLs in API Traffic** | Instanced URL → My Domain 로그인 URL로 교체 (Spring '26에서 Summer '26으로 연기됨) |
| **Enable Accessibility Enhancements for Page Headers and Modal Windows (200% 줌)** | WCAG 2.2 Resize/Reflow 준수를 위한 페이지 헤더·모달 동작 변경 |
| **Enable Accessibility Enhancements for Date Pickers, Popovers, Bottom Utility Bars** | 위 페이지 헤더 업데이트 선행 적용 필수 |

### Summer '27에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **SOAP API login() Call (v31.0–64.0) 은퇴** | SOAP API 로그인 호출을 OAuth 등 대체 인증으로 전환 |

---

## 연관 패턴 노트 업데이트 필요

- [ ] [[@InvocableMethod 패턴]] — `InvocableActionExtension` 메타데이터로 액션 설정 강화 내용 추가
- [ ] [[Flow 설계 베스트 프랙티스]] — 인라인 Transform 처리, 중첩 루프, LWC Local Action 패턴 추가
- [ ] [[Flow 에러 처리]] — Persistent Logging 및 디버거 개선 내용 반영
- [ ] [[Batch Apex]] — Test Discovery/Runner API를 이용한 CI 자동화 패턴 참조 추가
- [ ] [[Permission Set 관리]] — Permission Set License 자동 회수, Secure Roles Behavior 강제 적용 내용 추가
- [ ] [[External Services]] — Binary File 지원, 한도 증가(3,000 오브젝트/오퍼레이션, 700 등록) 반영
- [ ] [[Platform Encryption]] — Database Encryption GA, Field Audit Trail 선언적 보존 정책 내용 추가
- [ ] [[Salesforce CLI / DevOps]] — MCP Tools (DevOps Center, LWC), `sf package version retrieve`, Quick Create/Clone 내용 추가
- [ ] [[SLDS / LWC 디자인 시스템]] — SLDS 2 GA, 다크 모드, 밀도 인식 Styling Hook 내용 추가

---

## 관련 노트

- [[Release MOC]]
- [[Summer '25]] — 이전 릴리즈
- [[Summer '26]] — 다음 릴리즈
