---
tags: [DevOps, Packaging, 2GP, ManagedPackage, LMA, LicenseManagement, AppExchange, ISV, 라이선스관리]
source: pkg2_dev.pdf (Second-Generation Managed Packaging Developer Guide, Version 67.0 Summer '26) — p.408-416
created: 2026-05-24
aliases: [LMA Get Started, License Management App, LMA 설치, LMA 설정, 라이선스 관리 앱, License Management Org LMO, Lead and License Records, Modify License Record, Package Object Fields, License Object Fields]
---

# 2GP — LMA Part 1: License Management App 시작하기

> License Management App(LMA)을 설치·구성하고, 패키지와 연결해 Lead·License 레코드를 관리하는 전 과정을 다룬다. LMA는 AppExchange에 등록된 managed 패키지의 구독자 라이선스를 추적하는 managed package다.

**Editions:** Available in both Salesforce Classic and Lightning Experience. Available in Enterprise, Performance, and Unlimited Editions.

---

## 1. About the License Management App

### 1-1. LMA 개요

**License Management App(LMA)**는 Salesforce가 제공하는 managed package로, ISV 파트너가 자신의 AppExchange 패키지에 대한 라이선스와 라이선스를 관리하는 데 사용한다.

LMA를 LMO(License Management Org)에 설치하면:
- 구독자의 **패키지 설치**마다 라이선스 레코드 자동 생성
- **Lead 레코드** 자동 생성 (구독자 회사·담당자 정보)
- 라이선스 만료일·좌석 수·상태 수정 가능
- 구독자 Org에 로그인해 문제 진단 가능

LMA에 포함된 Custom Objects:
- **License** — 구독자 org당 하나. 구독자의 패키지 접근 권한 정보
- **Package** — 각 1GP 또는 2GP 패키지 정보
- **Package Version** — AppExchange에 등록된 각 패키지 버전 정보

> 참고: LMA는 **영어 전용**이다.

---

## 2. Get Started with the License Management App

### 2-1. 설치 및 구성 단계 요약

| 단계 | 작업 |
|---|---|
| 1 | LMA 설치 (Install the LMA) |
| 2 | LMA를 사용해 lead/license 레코드 로드 |
| 3 | lead/license 레코드 수정 |
| 4 | 라이선스 새로 고침 |
| 5 | LMA 사용자 정의 (Customize) |
| 6 | LMA 문제 해결 (Troubleshoot) |
| 7 | 구독자 지원 (Troubleshoot Subscriber Issues) |
| 8 | LMA를 다른 Salesforce org로 이전 |

---

## 3. Install the License Management App

### 3-1. LMA 설치 요건

- LMA는 **파트너 비즈니스 org(production org)**에만 설치 가능.  
  Developer Edition, Sandbox, Scratch Org에는 설치 불가.
- **Commercial use of LMA는 Developer Edition org에서 금지**.  
  Developer Edition / Unlimited(Enterprise / Professional) org에서는 상업용 사용 불가.
- Salesforce에서 LMA를 무료로 제공하지만, **Unlimited Edition** 또는 상업용 org에 설치하는 것이 권장 사항.

### 3-2. LMA 설치 절차

1. LMA를 **자신의 org가 아닌 파트너 비즈니스 org**에 설치하고, 그 org의 Admin을 통해 설치.
   (자신의 org에 직접 설치하면 안 됨)
2. **Partner Community**에 접속해 설치 URL로 설치.
3. 어떤 사용자가 LMA에 접근할 수 있는지 선택(**Install**).

### 3-3. LMA와 패키지 연결 확인

- 설치 성공 시 **License Management App**이 앱 런처에 표시된다.
- Beta 패키지 버전은 LMA에 표시되지 않는다.

---

## 4. Associate a Package with the License Management App

### 4-1. 패키지 연결 절차 (Partner Console)

```
// 구조 예시 — 실제 동작 코드 아님
1. Partner Console(파트너 콘솔)에 로그인 (Publishing 탭)
2. 등록할 패키지 버전의 Register Package 클릭
3. Package versions created after the link are displayed in the LMA
4. Package versions에서 해당 패키지 버전 선택
5. Register Package 클릭
6. 자신의 LMO에 로그인
7. 라이선스 기본값 설정(trial 기간, 좌석 수 등) 후 Save
```

> **Note:** Beta 패키지 버전은 LMA에 표시되지 않는다. managed-released 버전 및 Unlocked Package(2GP)만 LMA에 표시된다.

**SEE ALSO:** Salesforce Help: Reset Your Security Token

---

## 5. Configure Permissions for the License Management App

### 5-1. 권한 설정 원칙

LMA에 접근하는 사용자에 대한 권한을 Permission Set 또는 Profile로 설정한다.

사전 조건:
- LMA를 설치했을 것
- 자신의 packaging org (1GP 또는 2GP Dev Hub org)를 AppExchange 파트너 콘솔에 연결했을 것
- 패키지를 LMA와 연결했을 것

### 5-2. Custom Object Permissions (Object-Level)

**Step 1:** Object permissions 설정

| Custom Object | Object Permissions |
|---|---|
| License | To view license records<br>Assign READ permissions<br>To modify license records<br>Assign READ and EDIT permissions |
| Package | To view package records<br>Assign READ permissions<br>To modify package records<br>Assign READ and EDIT permissions |
| Package Version | To view package version records<br>Assign READ permissions<br>We recommend leaving all package version records as read-only |

### 5-3. Field-Level Permissions

| Custom Object | Field-Level Permissions |
|---|---|
| License | Make all fields read-only |
| Package | Make all fields read-only |
| Package Version | Make all fields read-only |

### 5-4. Page Layout 설정

Related Lists에 Licenses 관련 목록 추가:

| To enable... | Add the Licenses related list to the... |
|---|---|
| License managers to view the licenses associated with a particular lead | Lead page layout |
| LMA users to view the licenses associated with a particular account | Account page layout |
| LMA users to view the licenses associated with a particular contact | Contact page layout |

### 5-5. Assign Permissions to the Subscriber Support Console

구독자 지원을 위한 Permission Set 설정 절차:

```
// 구조 예시 — 실제 동작 코드 아님
1. Setup의 Quick Find에서 Permission Sets를 입력 → Permission Sets 선택
2. New 클릭 → 권한 세트 정보 입력
3. Permission Set Overview 페이지에서 Apps → System Permissions 클릭 → Edit
   a. sfLma.LoginToPartnerBT와 sfLma.SubscriberSupport를 Enabled Visualforce pages 목록에 추가 → Save
4. System section에서 Log In to Subscriber Organization을 선택 → System Permissions 클릭 → Edit
   a. Log In to Subscriber Organization 체크 → Save
5. Quick Find에서 Profiles 선택
   a. Click Edit
   b. Under Custom App Settings → License Management App: Default On
   c. Under Custom Tab Settings → LMA 관련 탭: Default On
   d. Click Save
```

---

## 6. Lead and License Records in the License Management App

### 6-1. 핵심 오브젝트

| 오브젝트 | 역할 |
|---|---|
| **Package** | 각 패키지 정보 (LMA의 Package Object) |
| **Lead** | 구독자 회사·담당자 정보 (Salesforce 표준 Lead Object) |
| **License** | 구독자의 패키지 접근 권한 (LMA의 License Object) |

### 6-2. 레코드 자동 생성 타이밍

| 동작 | Who Takes This Step |
|---|---|
| 패키지를 신규 구독자가 설치 | Customer or prospect |
| Lead 레코드 생성 (구독자 이름·회사·이메일로) | LMA |
| License 레코드 생성 (패키지 등록 시 지정한 값으로) | LMA |
| License 레코드 연결 (optional) | ISV (you/partner) |
| Account 및 Contact는 License 레코드에 연결됨 | LMA |

> **Note:** Lead assignment rules는 LMA가 생성한 Lead에는 적용되지 않는다.

---

## 7. Modify a License Record

### 7-1. 수정 가능한 라이선스 필드

LMA로 구독자의 오퍼링을 수정할 수 있다. 예를 들어, 라이선스에 포함된 좌석 수를 늘리거나 만료일을 변경할 수 있다.

| Field | Description |
|---|---|
| **Expiration** | Enter the last day that the customer can access your package, or select **Does not expire** |
| **Status** | Select a value from the dropdown |
| **Seats** | Enter a number for the offering. Up to 90 days. |

**Status 필드 값:**

| Status 값 | 설명 |
|---|---|
| **Active** | Lets the customer use an active license. It can return to a trial state |
| **Trial** | Setting this option makes your offering available to subscribers for up to 90 days for a full trial license. After the trial license expires, it returns to a trial state |
| **Suspended** — Prohibits customers from using your offering | |
| (없음) | When your offering is uninstalled, status is set to Uninstalled, and the license can no longer be active |

### 7-2. 라이선스 레코드 수정 절차

```
// 구조 예시 — 실제 동작 코드 아님
1. LMA에서 Packages 탭 선택
2. 패키지 레코드 열기
3. Refresh Licenses 클릭 (Lightning Experience: Refresh Licenses는 드롭다운 메뉴에 위치)
```

### 7-3. Refresh Licenses for a Managed Package

패키지의 모든 구독자 설치에 대한 라이선스를 동기화한다. 라이선스 새로 고침은 LMA와 다른 LMO로 이전하는 경우의 불일치도 해결한다.

> **Note:** 각 패키지에 대해 라이선스 새로 고침은 **주 1회**만 가능하다.

---

## 8. Extending the License Management App

**Editions:** Available in both Salesforce Classic and Lightning Experience. Available in Enterprise, Performance, and Unlimited Editions.

### 8-1. Custom Fields 추가

LMA에 Custom Field를 자유롭게 추가할 수 있다. (기본 Custom Permission 오브젝트에 의해 보호되지 않는 한)

추가 가능 Custom Objects:
- License
- Package
- Package Version

### 8-2. Adding Custom Automation to License Management App Objects

LMA를 활용해 비즈니스를 성장시키고 고객을 유지하는 자동화 예시:

**Alert Sales Reps When a License Expires (라이선스 만료 전 알림):**

여러 패키지의 라이선스를 관리하는 경우, 라이선스 만료가 임박하면 고객을 잃을 수도 있다. 고객에게 적시에 연락해 갱신을 유도하는 자동화를 설정한다.

```
// 구조 예시 — 실제 동작 코드 아님
1. 담당 영업 사원에게 알림을 보내는 email template 생성
2. License Status 필드가 Uninstalled로 설정되면 email을 발송하는 workflow rule 지정
3. workflow rule에 workflow action을 추가해 Salesforce admin에게 email 발송
```

**Notify Notification Specialists (고객 지원 전문가 알림):**

고객이 기술적인 문제가 있는 경우, Salesforce 관계를 복원하거나 오퍼링에 대한 피드백을 받을 기회가 있다.

```
// 구조 예시 — 실제 동작 코드 아님
1. 지원 케이스를 위해 고객에게 email을 발송하는 email template 생성
2. License Status 필드가 Uninstalled로 설정되면 email을 발송하는 workflow rule 지정
3. workflow rule에 workflow action을 추가해 Salesforce admin에게 email 발송
```

---

## 9. Package and Package Version Object Fields

### 9-1. Package Custom Object Fields

| Field Name | Description |
|---|---|
| Developer Name | The name of the package developer. For 1GP, the org is the packaging org. For 2GP, it's the Dev Hub packaging org |
| Developer Org ID | The 18-character ID of the org that owns the package. For 1GP, the org ID is the packaging org; For 2GP, it's the Dev Hub org |
| Last License Refresh | The date when the License Refresh task was last run |
| Latest Version | The most recent package version installed at the subscriber |
| Lead Manager | The owner of the lead records that the LMA creates when a customer installs your package |
| Next Available Refresh | The date when you can run License Refresh again |
| Owner | (LMA standard field) |
| Package ID | The 18-character ID that identifies the package. This ID starts with 033 |
| Package Name | The name you specified when you created the package |

### 9-2. Package Version Object Fields

| Field Name | Description |
|---|---|
| Package | The package name and links to the package record's detail page |
| Package Version Name | The name you specified when you created the package version |
| Release Date | The date you created this package version |
| Version Number | The version number in this major.minor.patch format. For example, 3.1.0 |
| Version ID | The 18-character ID of this package version |

---

## 10. License Custom Object Fields

LMA는 구독자 라이선스를 관리하기 위한 License Custom Object 필드를 전수 포함한다.

### 10-1. License Custom Object Fields 전수 표

| Field | Description |
|---|---|
| **Account** | A lookup field to the account record for a converted lead |
| **Contact** | The contact field for a converted lead |
| **Created By** | License records are created by the LMA |
| **Expiration Date** | Displays the expiration date or Does not expire (default) |
| **Instance** | The Salesforce instance where the subscriber's org resides |
| **Lead** | The lead record that the LMA created when the package was installed. It represents the user who owns the license.<br>If you convert the lead into an opportunity, the lead name is retained but the lead record no longer exists |
| **License Name** | An auto-generated number that identifies an instance of a license. License names are in the format `sf-{nnnnn}`, and each new license is incremented by 1 |
| **Licensed Seats** | Displays the number of licensed seats (default). When a package is installed in a sandbox org, the license file includes the sandbox license text |
| **License Status** | The type of license: Active, Suspended, Trial, or Uninstalled |
| **License Type** | This is a legacy field and can be ignored |
| **Org Expiration Date** | Applies only for trial orgs: indicates the date when your package expires in the trial org. The date is related to the package license expiration |
| **Org Status** | The status of the subscriber's org: Active, Free, or Trial |
| **Package Version** | A lookup field to the subscriber's package version |
| **Sandbox** | Indicates whether a license is associated with a package installed in a sandbox org |
| **Subscriber Org ID** | The 15-character ID representing the subscriber's org |
| **Used Licenses** | Displays the number of users who have a license to the package. This field is blank if:<br>- A customer uninstalled the package<br>- Under Custom App Settings, select the Modified App, uncheck the license field |

### 10-2. Field-Level Permissions 설정 시 고려사항

```
// 구조 예시 — 실제 동작 코드 아님
Field-Level Security → User Profiles or Permission Sets
- License Object: 모든 필드를 읽기 전용으로 설정 권장
- Package Object: 모든 필드를 읽기 전용으로 설정 권장
- Package Version Object: 모든 필드를 읽기 전용으로 설정 권장
```

---

## 관련 노트

- [[2GP — LMA Part 2 Troubleshoot]] — LMA 트러블슈팅, 구독자 지원, LMA 이전, Best Practices
- [[2GP — Prepare to Distribute]] — AppExchange 등록, LMO 연결, Package 등록 절차
- [[2GP — Feature Management App]] — Feature Parameters 설정·운영 (LMO 기반)
- [[2GP — Push Upgrade]] — 구독자 org 강제 업그레이드 관리
- [[2GP — Best Practices]] — 2GP 개발·배포 모범 사례 전수
- [[2GP Managed Package 개념과 1GP 비교]] — managed 2GP 개념·LMO·Partner Business Org
- [[2GP — App Analytics Part 1: Overview & Setup]] — AppExchange App Analytics 개요·활성화·CustomInteractions (LMO 기반 사용량 데이터)
