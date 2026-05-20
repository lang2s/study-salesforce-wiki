---
tags: [apex, applauncher, appmenu, namespace, reference]
source: salesforce_apex_reference_guide.pdf (v67.0, Summer '26) p.43-47
created: 2026-05-20
aliases: [AppLauncher, AppLauncher 네임스페이스, AppMenu, 앱 런처 Apex, App Launcher 정렬]
---

# AppLauncher Namespace

> App Launcher에서 앱의 가시성·정렬 순서를 관리하는 메서드를 제공하는 네임스페이스. 공개 API는 `AppMenu` 클래스 하나뿐이며 나머지 클래스는 모두 내부 전용이다.

---

## 개요

| 클래스 | 공개 여부 | 설명 |
|---|---|---|
| `AppMenu` | ✅ 공개 | App Launcher 앱 가시성·정렬 제어 |
| `ChangePasswordController` | 🔒 내부 전용 | — |
| `CommunityLogoController` | 🔒 내부 전용 | — |
| `EmployeeLoginLinkController` | 🔒 내부 전용 | — |
| `ForgotPasswordController` | 🔒 내부 전용 | — |
| `IdentityHeaderController` | 🔒 내부 전용 | — |
| `LoginFormController` | 🔒 내부 전용 | — |
| `SelfRegisterController` | 🔒 내부 전용 | — |
| `SocialLoginController` | 🔒 내부 전용 | — |

> `ChangePasswordController` ~ `SocialLoginController`는 Experience Cloud 로그인 페이지에서 Salesforce 내부적으로 사용하는 클래스로, 개발자가 직접 사용하거나 확장할 수 없다.

---

## AppMenu Class

App Launcher에서 앱의 표시 여부와 정렬 순서를 설정하는 static 메서드 모음.

**Namespace:** AppLauncher

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `setAppVisibility(appMenuItemId, isVisible)` | `public static void setAppVisibility(Id appMenuItemId, Boolean isVisible)` | void | 특정 앱을 App Launcher에 표시하거나 숨긴다 |
| `setOrgSortOrder(appIds)` | `public static void setOrgSortOrder(List<Id> appIds)` | void | 조직 전체 기본 앱 정렬 순서 설정 |
| `setUserSortOrder(appIds)` | `public static void setUserSortOrder(List<Id> appIds)` | void | 개별 사용자 기본 앱 정렬 순서 설정 |

---

### setAppVisibility(appMenuItemId, isVisible)

App Launcher에서 특정 앱을 표시하거나 숨긴다.

```apex
public static void setAppVisibility(Id appMenuItemId, Boolean isVisible)
```

**파라미터**
- `appMenuItemId` — Type: Id. 앱의 15자 애플리케이션 ID. `AppMenuItem` 오브젝트의 `ApplicationId` 필드 또는 `UserAppMenuItem` 오브젝트의 `AppMenuItemId` 필드에서 확인
- `isVisible` — Type: Boolean. `true`면 앱을 표시, `false`면 숨김

**Return Value:** void

---

### setOrgSortOrder(appIds)

App Launcher의 조직 전체 기본 정렬 순서를 지정한 앱 ID 목록 순서대로 설정한다.

```apex
public static void setOrgSortOrder(List<Id> appIds)
```

**파라미터**
- `appIds` — Type: List\<Id\>. 원하는 순서로 정렬된 앱 ID 값 목록. `AppMenuItem` 오브젝트의 `ApplicationId` 필드 참조

**Return Value:** void

---

### setUserSortOrder(appIds)

개별 사용자의 App Launcher 기본 정렬 순서를 지정한 앱 ID 목록 순서대로 설정한다.

```apex
public static void setUserSortOrder(List<Id> appIds)
```

**파라미터**
- `appIds` — Type: List\<Id\>. 원하는 순서로 정렬된 앱 ID 값 목록. `UserAppMenuItem` 오브젝트의 `AppMenuItemId` 필드 참조

**Return Value:** void

---

## 사용 예제

```apex
// 특정 앱 숨기기
Id appId = [SELECT ApplicationId FROM AppMenuItem WHERE Name = 'Sales' LIMIT 1].ApplicationId;
AppLauncher.AppMenu.setAppVisibility(appId, false);

// 조직 전체 앱 정렬 순서 설정
List<Id> orderedIds = new List<Id>{appId1, appId2, appId3};
AppLauncher.AppMenu.setOrgSortOrder(orderedIds);

// 현재 사용자의 앱 정렬 순서 설정
AppLauncher.AppMenu.setUserSortOrder(orderedIds);
```

> **조직 vs 사용자 정렬**: `setOrgSortOrder`는 모든 사용자의 기본 순서를 변경하고, `setUserSortOrder`는 현재 실행 컨텍스트 사용자의 개인 순서만 변경한다.

---

## 관련 노트

- [[ApexPages Namespace]] — 같은 Visualforce/UI 계층의 네임스페이스
- [[System Namespace]] — App Launcher 관련 URL 조회 (`URL.getOrgDomainUrl` 등)
