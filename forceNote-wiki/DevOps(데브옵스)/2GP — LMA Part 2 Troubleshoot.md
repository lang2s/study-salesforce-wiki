---
tags: [DevOps, Packaging, 2GP, ManagedPackage, LMA, LicenseManagement, Troubleshoot, SubscriberSupport, 트러블슈팅, 구독자지원]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.417-419
created: 2026-05-24
aliases: [LMA Troubleshoot, LMA Best Practices, Troubleshoot License Management App, LMA 트러블슈팅, Subscriber Support Console, Log In to Subscriber Orgs, Debug Subscriber Orgs, ISV Customer Debugger, LMA 이전, Move License Management App, Proxy User Deactivated, Request Login Access Subscribers, Multi-Factor Authentication Subscriber]
---

# 2GP — LMA Part 2: 트러블슈팅 · 구독자 지원 · Best Practices

> License Management App(LMA) 운영 중 발생하는 트러블슈팅, 구독자 Org에 로그인해 문제를 진단하는 절차, LMA를 다른 Salesforce org로 이전하는 방법, LMA 사용 모범 사례를 다룬다.

---

## 1. Troubleshoot the License Management App

### 1-1. Leads and Licenses Not Being Created in the LMA

구독자가 패키지를 설치했는데 LMA에 lead/license 레코드가 생성되지 않는 경우, 아래 항목을 순서대로 점검한다.

#### Did the customer complete the package installation?

구독자가 패키지 설치를 완료하지 않으면 lead/license 레코드가 생성되지 않는다. LMA 구성 문제라면 아래 항목을 확인한다.

#### Is State and Country picklist validation enabled?

state와 country picklist validation이 활성화된 경우, 두 가지 옵션이 있다.

**옵션 1 — Standard picklist integration values 사용:**

표준 picklist integration 값을 사용하면 state/country 이름과 국가 약어가 있는 경우 해당 picklist 통합 값이 LMA에 전달된다. standard picklist integration 옵션을 선택하는 것을 권장한다.

**옵션 2 — Duplicate state and country values 추가:**

AppExchange Feed를 사용하면 LMA가 subscriber org에서 state and country abbreviations를 가져온다. 예를 들어, 두 글자 state/country abbreviation을 표시하거나 다른 통합 값을 가진 state/country로 통합하려면 Duplicate state and country values를 picklist에 추가한다. Add duplicate state and country values and names to your picklist. The two-letter state or country abbreviation must match the full name, and the picklist must not contain duplicate values.

#### Is the lead manager a valid, active user?

lead manager가 아니면 Create leads와 licenses를 비활성화 → Lead Manager 유효성 확인 후 다시 활성화한다.

#### Does the lead or license have a workflow rule?

workflow rule이 있으면 lead/license 레코드 생성을 막을 수 있다. required custom field가 있는 경우도 마찬가지다. workflow rule을 제거한다.

#### Was the lead converted to an account?

When the LMA checks for existing leads and licenses, if an existing contact's email matches the customer's email, the lead is no longer returned. 기존 Contact 이메일과 같은 경우 lead 레코드가 반환되지 않는 상황.

#### Does a required field for duplicate leads lack a validation rule?

duplicate leads에 대한 required field validation rule이 없으면 LMA는 기존 leads와 licenses를 확인해 판단한다. 이 경우 LMA가 기존 연락처로 판단해 lead를 반환하지 않을 수 있다.

### 1-2. Proxy User Has Deactivated Message in the LMA

라이선스를 편집하고 있는데 "proxy user has deactivated" 메시지가 나타나면, subscriber org가 삭제·비활성화됐거나 구독자 org의 package 버전이 삭제된 것이다.  
subscriber에게 연락해 license 레코드를 삭제하도록 안내한다.

proxy user에 연락해 응답이 없으면 license 레코드를 직접 삭제한다.

---

## 2. Best Practices for the License Management App

LMA를 사용할 때 아래 모범 사례를 따른다:

- **AppExchange 계정을 최대한 활용한다.** AppExchange를 통해 구독자에게 연락하고 technical issues를 해결하는 데 사용한다.
- **LMA의 `LicenseCurrentTermEndDate.License` 클래스를 사용한다.** ISV 구독자의 managed package에 대한 license 관련 이슈에 대해 Apex Reference Guide를 참조한다.
- **Automation으로 구독 갱신을 자동화한다.** 예를 들어, subscriber에게 알림을 보내 trial-to-paid 전환을 유도한다. 워크플로우, Apex triggers, 또는 validation rules를 사용해 custom fields와 license 레코드를 관리한다.

---

## 3. Troubleshoot Subscriber Issues

### 3-1. Subscriber Support Console 개요

구독자 지원 콘솔을 사용해 구독자 org의 정보에 접근하고, login access를 요청하도록 안내할 수 있다.

이 기능을 이용하면 기술 문제가 있는 구독자에게 연락해 org에 접근하고 문제를 해결할 수 있다.  
Subscriber org에 log in하려면 먼저 구독자에게 **login access를 허용**하도록 안내해야 한다.

### 3-2. Request Login Access from Subscribers

구독자 org에 로그인 접근을 요청하는 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. 구독자에게 Grant Account Login Access 사용 안내
   - Salesforce org의 경우: System Admin이 로그인 접근 허용
   - 회사가 패키지의 라이선스가 없는 경우: 로그인 접근 허용 불가
   - org가 installed the package인 경우: admin만 Manage Users 권한으로 접근 허용 가능
   - When the org has Administrators Can Log in as Any User disabled: 이 경우 admin이 limited amount of time for access 제공
```

> **Note:** Administrators Can Log in as Any User가 비활성화된 경우, 로그인 접근이 제한적인 시간 동안만 허용된다.

### 3-3. Log In to Subscriber Orgs

**Editions:** Available in Enterprise, Performance, and Unlimited Editions.

구독자 org에 로그인해 문제를 해결하는 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. LMA에서 Subscribers 탭으로 이동
2. subscriber org 검색 (subscriber name 또는 Org ID)
3. Org Details 페이지에서 Login 클릭 → subscriber org에 로그인
```

> **Note:** Government Cloud org에는 subscriber org에 로그인할 수 없다. Salesforce Platform org에도 로그인 불가. Platform org에서 고객 지원을 위해 IT 담당자 Customer Debugger Sessions 기능을 활용한다.

### 3-4. Multi-Factor Authentication Required to Log In to a Subscriber Org

Spring '22부터 LMA에서 subscriber org에 로그인할 때 **MFA(Multi-Factor Authentication)**가 요구된다. 이 요건은 LMO에서 MFA를 요구하는 것이다.

구독자 지원을 위해 subscriber org에 로그인하는 사용자의 MFA 설정 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. License Management App(LMA)에서 Subscribers 탭 클릭
2. subscriber 이름 또는 Org ID로 검색 → Search 클릭
3. Org Details 페이지에서 user 이름 클릭 → Login 클릭
4. MFA를 요구하는 경우:
   - Salesforce Authenticator 앱 또는 TOTP 앱을 이용해 MFA 인증
```

MFA 설정 절차 (Log In to a Subscriber Org):

```
// 구조 예시 — 실제 동작 코드 아님
1. LMA에서 Subscribers 탭 클릭
2. subscriber 이름 또는 Org ID를 검색 → Search
3. subscriber 이름 클릭
4. 패키지의 user 이름 클릭 → Login 클릭
5. MFA 인증 완료
```

### 3-5. Best Practices for Logging In

구독자 org에 로그인할 때의 모범 사례:

- **각 subscriber org 로그인 시 audit trail을 생성**한다. subscriber org가 로그아웃 되거나 LMA에서 로그인 이벤트가 발생하면 감사 기록을 생성할 수 있다.
- 구독자 org에 로그인할 때는 **Trusted In Subscriber Org**에서 로그인이 되지 않도록 한다. 이 기능을 사용하면 구독자의 보안 정책을 우회할 수 있기 때문이다.
- 구독자가 **read-only access**로 로그인하도록 한다. 구독자의 데이터에 대한 접근 권한 제어를 신경 쓴다.
- LMA의 **Subscriber Org**에서 로그인 접근 허용 여부를 항상 사전 확인한다.

### 3-6. Debug Subscriber Orgs

구독자 org에서 ISV Customer Debugger 세션을 생성해 debug log를 가져올 수 있다.

- 구독자가 ISV Customer Debugger를 통해 Apex code execution에 대한 가시성을 제공한다.
- 각 License Management Org는 한 번에 **ISV Customer Debugger 세션 하나만** 실행 가능하다.
- ISV Customer Debugger는 Salesforce DX의 일부다. VS Code에서 사용할 수 있다.
- 관련 문서: Salesforce Extensions for VS Code documentation

debug log를 가져오는 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. 구독자 Packages 탭에서 subscriber org 이름을 찾기 → Quick Find box → Debug Logs 검색
2. Developer Console 열기 → debug log 분석
3. Apex code execution의 debug 정보 확인 후 Close
```

Namespaced Org의 Debug Logs 활성화 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. LMA subscriber 탭 → subscriber 이름 검색 → Packaging & Licensing 섹션 → Enable 클릭
```

> **중요:** 복수의 패키지가 동일한 namespace를 공유하는 2GP의 경우, subscriber org에서 debug logs를 활성화하면 해당 namespace를 포함한 모든 managed packages에서 Apex code execution이 subscriber org에 표시된다. debug logs를 활성화할 때는 Package A가 포함되는 namespace에 있다면, Package B와 C도 같은 namespace에 있으면 함께 노출된다는 점을 인지한다.

### 3-7. Troubleshoot with the ISV Customer Debugger

ISV Customer Debugger는 한 번에 하나의 ISV Customer Debugger 세션만 실행 가능하다. ISV Customer Debugger는 Salesforce DX (Developer Experience)의 일부다.

상세 설명은 Salesforce Extensions for VS Code 문서 참조.

---

## 4. Move the License Management App to Another Salesforce Org

LMA를 다른 org로 이전해야 할 경우, license record와 package record가 자동으로 따라오지 않는다. 직접 패키지를 언인스톨하고 새 org에 설치·연결·라이선스를 새로 고침해야 한다.

**이전 절차:**

```
// 구조 예시 — 실제 동작 코드 아님
1. LMA와 연결된 현재 org의 연결 해제 (파트너 콘솔에서 case 등록)
2. 새 Salesforce org에 LMA 설치 (AppExchange에서 무료 설치)
3. 새 org와 패키지 연결 (파트너 콘솔 → Solutions 탭 → 해당 패키지 → Register Package → 새 org로 연결)
4. 패키지 라이선스 새로 고침 (새 org에서 Packages 탭 → Refresh Licenses)
```

> **Note:** Unlocked Package 또는 Org-Dependent Unlocked Package는 LMA 이전 절차가 다르다. Salesforce DLRS(Cumulative License Record System) 또는 CLRS 참조.

**이전 시 고려사항:**

- 이전 org에 installed된 Cumulative Lookup Rollup Summary(CLRS) 설정이 있다면 new org에도 설치 필요
- 이전 전에 모든 license record를 백업(내보내기) 권장
- 이전 후에 파트너 콘솔에서 새 org에 Dev Hub를 연결해야 새 버전이 LMA에 표시됨

---

## 관련 노트

- [[2GP — LMA Part 1 Get Started]] — LMA 설치·연결·권한 설정·라이선스 레코드 관리
- [[2GP — Best Practices]] — 2GP 개발·배포 모범 사례
- [[2GP — Feature Management App]] — Feature Parameters 설정·운영 (LMO 기반)
- [[2GP — Prepare to Distribute]] — AppExchange 등록, LMO 연결, Package 등록 절차
- [[DX 인증 방식]] — JWT Flow, org login jwt, ISV Customer Debugger 연관 인증
- [[2GP — App Analytics Part 2: Best Practices & Query Strategy]] — App Analytics 쿼리 전략·Catch-Up Queries·파트너 규모별 권장 사항
