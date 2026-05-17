---
tags: [release, summer_26]
api_version: v67.0
release_date: 2026-06
created: 2026-05-17
source: salesforce_release_notes_5-17-2026.pdf
aliases: [Summer '26, 서머 26]
---

# Summer '26 릴리즈 노트

> API v67.0 | 출시: 2026년 06월  
> 공식 문서: [Release Notes](https://help.salesforce.com/s/articleView?id=release-notes.salesforce_release_notes.htm)

---

## ⭐ 주요 신기능

- **[파괴적 변경]** API v67.0부터 Apex SOQL/DML이 기본 USER_MODE로 동작 — 모든 FLS·공유 룰 자동 적용
- **[파괴적 변경]** 공유 선언 없는 Apex 클래스가 v67.0부터 `with sharing` 기본값으로 변경
- **[파괴적 변경]** `WITH SECURITY_ENFORCED`가 v67.0에서 컴파일 오류 — `WITH USER_MODE`로 전환 필수

---

## Apex

### 신규

- **멀티라인 문자열 리터럴** — 연결 연산자 없이 여러 줄 문자열 작성 가능
- **`String.template()`** — 문자열 보간 메서드 도입 (`String.format()` 대체)
- **Elastic Limits for Async Jobs (Beta)** — Queueable/future가 라이선스 일일 한도의 최대 2배까지 큐잉 가능 (한도 초과 시 스로틀링, 갑작스러운 실패 방지)
- **`InvocableActionExtension` 메타데이터** — Flow Builder에서 Apex 액션 입력 파라미터에 피클리스트·커스텀 프로퍼티 에디터 정의
- **`EventBus.publishWithAccessLevel()`** — Platform Events 발행 시 접근 레벨 지정 신규 메서드
- **Invocable Action 파라미터 클래스에 no-arg 생성자 필수** — public(비패키지) 또는 global(패키지) 무인자 생성자 선언 요구

### 변경

- **Database Operations 기본 모드 → USER_MODE** — SOQL, DML, Database 메서드가 v67.0부터 USER_MODE 기본 적용

```apex
// v67.0 이후 — USER_MODE 명시 (이전과 동일한 동작 보장)
Account acc = [SELECT Id FROM Account WHERE Name = 'Singha' WITH USER_MODE LIMIT 1];

// DML에서 USER_MODE 명시
Account a = new Account(Name = 'Test');
insert as user a;

// Database 메서드에서 USER_MODE 명시
List<Account> results = Database.query('SELECT Id FROM Account', AccessLevel.USER_MODE);
```

- **공유 선언 없는 클래스 → `with sharing` 기본값** — v67.0 이상 API로 컴파일된 클래스에만 적용; v66.0 이하는 이전 동작 유지

```apex
// v67.0: 아래 클래스는 with sharing과 동일하게 동작
public class MyClass {
    public void doSomething() { /* 공유 룰 적용됨 */ }
}

// 시스템 모드가 필요한 경우 명시
public without sharing class MySystemClass {
    public void doSomething() { /* 공유 룰 미적용 */ }
}
```

- **Apex 트리거는 모든 API 버전에서 항상 System Mode** — 트리거에 sharing 선언 불가; 핸들러 클래스로 공유 제어 위임

### Deprecated

- **`WITH SECURITY_ENFORCED`** — v67.0에서 컴파일 오류 발생; `WITH USER_MODE`로 교체 필요
  - USER_MODE는 다형성 필드 처리, 모든 절 검사, FLS 오류 전체 탐지 등 기능 우위
- **Block Apex Anonymous Code from Managed Packages (Release Update)** — 관리 패키지에서 `UserInfo.getSessionId()`를 활용한 익명 Apex 실행 차단
- **OAuth 2.0 Username-Password Flow** — Connected App 에서 폐기 예정 (Release Update)
- **Triple DES for SAML SSO** — 더 이상 지원 안 함
- **Salesforce-Managed X(Twitter) Authentication Provider** — 폐기 예정 (Release Update)
- **Salesforce Platform API v31.0–40.0** — 폐기 진행 중
- **SOAP API `login()` call (v31.0–64.0)** — 폐기 예정 (Release Update); JWT 기반 액세스 토큰 사용 권장

---

## LWC

### 신규

- **State Managers for LWC (GA)** — `lightning/stateManager*` 모듈로 데이터 로직과 컴포넌트 표현 분리 (Experience Cloud 미지원)
- **Single Component Live Preview (GA)** — 이전 명칭 "Local Dev for single components"
- **Live Preview VS Code Extension (GA)** — 이전 명칭 "Lightning Preview"
- **`<details>` 요소 `name` 속성** — 그루핑 지원 (이전에는 컴파일러 경고 발생)

### 변경

- **Hot Module Reloading 성능 개선** — v67.0에서 향상
- **HTMLAnchorElement `data:` URI 차단** — Lightning Web Security에서 `data:` 스킴 차단; `blob:` 스킴 사용 권장

### Deprecated

- (해당 없음)

---

## Flow / Automation

### 신규

- **Scheduled Flow 커스텀 배치 크기** — Start 요소 → Advanced Options에서 1–200 설정
- **날짜 연산자 추가 (Decision 요소)** — Is Today, Is Anniversary of Today, Last Number of Days
- **Show Toast Message 액션** — Flow에서 토스트 메시지 표시 신규 액션
- **Open a Page 액션** — Flow에서 레코드 또는 외부 URL 열기
- **커스텀 프로퍼티 에디터 (Flow Extensions)** — 개별 입력 파라미터 단위 프로퍼티 에디터 지정
- **Flow Orchestration 표준화** — 별도 애드온 없이 기본 기능으로 제공
- **Compare Flow Versions** — Flow Builder에서 버전 비교 도구 추가

### 변경

- **Send Email 액션 v3.0.1** — 이메일 템플릿을 ID가 아닌 이름으로 저장 → 배포 후에도 참조 유지
- **Fault Path 접기** — 자동 레이아웃 뷰에서 Fault Path 접기 가능
- **Update Screen Flows with Natural Language Prompts (Beta)** — Agentforce for Flow가 GA에서 Beta로 복귀

### Deprecated

- (해당 없음)

---

## Admin / Setup

- **필드 접근 권한 검토** — Profile, Permission Set, Permission Set Group 전체에서 필드 접근 권한 일괄 확인 UI
- **Permission 의존성 추적** — 권한 간 의존 관계 시각화
- **Profile Filtering (Release Update)** — 프로필 필터링 기능
- **27개 추가 표준 시간대 지원** — IANA 표준 기반 확장
- **External Services Enum 지원** — Customization 영역에서 열거형 타입 지원

---

## Slack

- **Salesforce 채널 기본 제공** — 신규 Enterprise/Unlimited 조직에서 Salesforce 채널 기본 활성화
- **레코드 페이지 Slack 패널** — Salesforce 레코드 페이지에 Slack 패널 신규 추가

---

## API

| 항목 | 내용 |
|---|---|
| API 버전 | v67.0 |
| 신규 메서드 | `EventBus.publishWithAccessLevel()` |
| MCP Servers (GA) | AI 에이전트와 Salesforce 안전하게 연결 |
| JWT 기반 토큰 | SOAP API와 함께 사용 가능 |
| 폐기 예정 | Platform API v31.0–40.0, SOAP `login()` v31.0–64.0 |

---

## 거버너 한도 변경

| 한도 항목 | 이전 | 이후 |
|---|---|---|
| Queueable/future 일일 한도 (Elastic, Beta) | 라이선스 기준 한도 | 최대 2배 (한도 초과분 스로틀링) |

---

## 보안 / 정책

- OAuth 2.0 Username-Password Flow 폐기 예정 (Release Update)
- Triple DES for SAML SSO 지원 종료
- Salesforce-Managed X(Twitter) Authentication Provider 폐기 예정 (Release Update)
- Salesforce Edge Network 도입 권장 (도메인 마이그레이션)

---

## Agentforce / Einstein

- **MCP Servers (GA)** — Hosted MCP Server로 AI 에이전트가 Salesforce에 안전하게 연결
- **Agentforce Policies** — 외부 API·MCP Server 연결을 보호하는 정책 설정
- **Orchestrate Other Agents (Beta)** — 에이전트가 다른 에이전트를 오케스트레이션
- **Write Integration Tests for Agentforce in Apex (Developer Preview)** — 실제 Agentforce 서비스 callout 포함한 end-to-end Apex 테스트 작성
- **Agentforce for Flow (Beta)** — GA에서 Beta로 복귀 (정확도 문제로)
- **AuraEnabled Controller를 Agent Action으로 노출 (Beta)** — 기존 Aura 컨트롤러를 Agent Action으로 재사용

---

## Release Updates (필수 적용 항목)

> [!warning] Setup → Release Updates 페이지에서 기한 전 반드시 적용·테스트

### Summer '26에 강제 적용됨 (지금 적용 필수)

| 항목 | 영향 | 조치 |
|---|---|---|
| **SAML 단일구성 → 다중구성 마이그레이션** | SSO 설정이 중단됨 | 다중구성 SAML 프레임워크로 마이그레이션 |
| **X(Twitter) Auth Provider 폐기** | Twitter SSO 중단 | 커스텀 X 앱 생성 후 SSO 재구성 |
| **Sort Apex Batch Action Results by Request Order** | Batch 결과 순서 변경 | 결과 순서 의존 코드 확인 |
| **Apex Blob.toPdf() → Visualforce PDF 렌더링 서비스** | PDF 렌더링 변경 | PDF 출력 확인 |
| **접근성 개선: Date Pickers / Popovers / Utility Bars** | UI 동작 변경 | 고배율(200%+) 테스트 |

### Winter '27에 강제 적용 예정

| 항목 | 준비 사항 |
|---|---|
| **Profile Filtering** | View All Profiles 권한 필요 사용자에게 미리 권한 부여 |
| **Authorized Email Domains** | 이메일 변경 인증 예외 설정을 Authorized Email Domains로 마이그레이션 |

---

## 연관 패턴 노트 업데이트 필요

> 이 릴리즈로 인해 수정이 필요한 기존 노트

- [ ] [[WITH USER_MODE]] — `WITH SECURITY_ENFORCED` 폐기, v67.0 기본 USER_MODE 변경 내용 추가
- [ ] [[SOQL 패턴]] — 기본 모드 변경(USER_MODE) 및 `WITH SECURITY_ENFORCED` 제거 내용 반영
- [ ] [[DML 패턴]] — `insert as user`, `AccessLevel.USER_MODE` 기본 적용 설명 추가
- [ ] [[Safely]] — 공유 선언 기본값 변경(v67.0 with sharing) 업데이트
- [ ] [[StripInaccessible]] — USER_MODE 기본 적용으로 인한 대안 패턴 재검토
- [ ] [[Queueable]] — Elastic Limits (Beta) 내용 추가
- [ ] [[@InvocableMethod 패턴]] — no-arg 생성자 필수 요건, `InvocableActionExtension` 메타데이터 추가

---

## 관련 노트

- [[Release MOC]]
- [[Spring '26]] — 이전 릴리즈
- [[Winter '26]] — 이전이전 릴리즈
