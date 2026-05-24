---
tags: [devops, 2gp, managed-package, packaging, components, security, access, permission-set, connected-app, cors, csp, external-credential, sharing, identity-verification]
source: pkg2_dev.pdf — Second-Generation Managed Packages, Components Available in Second-Generation Managed Packages (p.42, 89–90, 95–97, 167–168, 174–175, 210, 226–227, 247–248)
created: 2026-05-23
aliases: [2GP Security Access 컴포넌트, 2GP PermissionSet 패키징, 2GP ConnectedApp 패키징, 2GP CorsWhitelistOrigin, 2GP CspTrustedSite, 2GP ExternalCredential, 2GP ExternalAuthIdentityProvider, 2GP IdentityVerificationProcDef, 2GP LiveChatSensitiveDataRule, 2GP PermissionSetGroup, AccountRelationshipShareRule 2GP, 2GP 보안 접근 컴포넌트]
---

# 2GP — Components: Security & Access

> 2GP Managed Package에 포함할 수 있는 보안·접근 제어 도메인 컴포넌트의 Manageability Rules 4속성과 Editable Properties 3카테고리 전수. PDF(pkg2_dev.pdf) Components Available 섹션(p.25–313) 기준.

---

## 개요: Manageability Rules 4속성

각 컴포넌트에는 아래 4가지 규칙이 적용된다. 상세 의미는 [[2GP Managed Package — Workflow]] 참조.

| 속성 | Yes 의미 | No 의미 |
|---|---|---|
| Component Is Updated During Package Upgrade | 패키지 업그레이드 시 컴포넌트 자동 업데이트 | 초기 설치 시에만 배포, 이후 업그레이드 미반영 |
| Subscriber Can Delete Component From Org | 구독자가 자기 org에서 삭제 가능 | 삭제 불가 |
| Package Developer Can Remove Component From Package | 개발자가 신버전에서 제거 가능 (deprecated → 구독자 삭제 가능) | 제거 불가 |
| Component Has IP Protection | 코드·설정 난독화, 구독자 org에서 숨김 | 구독자 org에서 노출 |

## Editable Properties 3카테고리

- **Only Package Developer Can Edit**: 개발자만 신버전에서 수정 가능, 구독자 org에서 잠김.
- **Both Package Developer and Subscriber Can Edit**: 양측 모두 수정 가능. 업그레이드 시 개발자 변경은 신규 설치에만 적용 (구독자 수정이 덮어쓰이지 않음).
- **Neither Package Developer or Subscriber Can Edit**: promote/release 후 잠금.

> 컴포넌트 제거(Remove)는 Salesforce 승인이 필요하다. 접근을 요청하려면 Salesforce Partner Community에 지원 케이스를 등록한다.

---

## 2GP 지원 컴포넌트 목록 (Security & Access 도메인)

| 컴포넌트 | Metadata Name | 2GP 지원 | IP Protection |
|---|---|---|---|
| Account Relationship Share Rule | `AccountRelationshipShareRule` | 2GP+1GP | No |
| Connected App | `ConnectedApp` | 2GP+1GP | No |
| CORS Allowlist | `CorsWhitelistOrigin` | 2GP+1GP | No |
| CSP Trusted Site | `CspTrustedSite` | 2GP+1GP | No |
| External Auth Identity Provider | `ExternalAuthIdentityProvider` | 2GP+1GP | No |
| External Credential | `ExternalCredential` | 2GP+1GP | No |
| Identity Verification Proc Def | `IdentityVerificationProcDef` | 2GP+1GP | No |
| Live Chat Sensitive Data Rule | `LiveChatSensitiveDataRule` | **1GP only** | No |
| Permission Set | `PermissionSet` | 2GP+1GP | No |
| Permission Set Groups | `PermissionSetGroup` | 2GP+1GP | No |

### 2GP에서 지원되지 않는 컴포넌트 (요청 목록 대조)

PDF(pkg2_dev.pdf) Components Available 목차(p.25–313)에 아래 컴포넌트는 등재되지 않아 2GP에서 패키징이 불가하다.

| 컴포넌트 | Metadata Name | 비고 |
|---|---|---|
| Authentication Provider | `AuthProvider` | 2GP 미지원 (1GP에서도 일부 제한) |
| Certificate | `Certificate` | **패키징 불가** — NamedCredential 고려사항 참고: "Certificates aren't packageable" |
| Delegate Group | `DelegateGroup` | 2GP 미지원 |
| Field Restriction Rule | `FieldRestrictionRule` | 2GP 미지원 |
| Group | `Group` | 2GP 미지원 |
| IP Address Range | `IPAddressRange` | 2GP 미지원 |
| Mobile Security Assignment | `MobileSecurityAssignment` | 2GP 미지원 |
| Mobile Security Policy | `MobileSecurityPolicy` | 2GP 미지원 |
| Moderation Rule | `ModerationRule` | 2GP 미지원 |
| Muting Permission Set | `MutingPermissionSet` | 2GP 미지원 |
| Oauth Custom Scope | `OauthCustomScope` | 2GP 미지원 |
| Oauth Token Exchange Handler | `OauthTokenExchangeHandler` | 2GP 미지원 |
| Profile | `Profile` | 2GP에서는 **Profile Settings** 방식으로만 포함 |
| Sharing Rules | `SharingRules` | 2GP 미지원 |
| Sharing Set | `SharingSet` | 2GP 미지원 |
| Territory | `Territory` | 2GP 미지원 |
| Territory2 | `Territory2` | 2GP 미지원 |
| User Criteria | `UserCriteria` | 2GP 미지원 |

> **Profile 관련 주의**: 2GP에서 Profile 자체는 패키징되지 않는다. 대신 PermissionSet 또는 Profile Settings 방식을 사용한다. 패키지 버전 생성 시 DX 프로젝트 내 모든 프로파일을 검사하되, 패키지 내 메타데이터와 직접 연관된 설정만 유지하고 나머지는 삭제한다. 상세는 [[2GP Managed Package — Workflow]] → Permission Sets and Profile Settings 참조.

---

## Account Relationship Share Rule

> Determines which object records are shared, how they're shared, the account relationship type that shares the records, and the level of access granted to the records.

**Metadata Name:** `AccountRelationshipShareRule`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Name, Developer Name, Description, Account Relationship Type, Access Level, Object Type, Account to Criteria Field |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### More Information

- **Use Case**: To share data between external accounts.
- **License Requirements**: Orgs with Digital Experiences enabled can use this package.
- **Documentation**: Salesforce Help: Account Relationships and Account Relationship Data Sharing Rules

---

## Connected App

> Represents a connected app configuration. A connected app enables an external application to integrate with Salesforce using APIs and standard protocols, such as SAML, OAuth, and OpenID Connect.

**Metadata Name:** `ConnectedApp`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (1GP packages only) |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Access Method, Canvas App URL, Callback URL, Connected App Name, Contact Email, Contact Phone, Description, Icon URL, Info URL, Trusted IP Range, Locations, Logo Image URL, OAuth Scopes |
| Both Package Developer and Subscriber Can Edit | ACS URL, Entity ID, IP Relaxation, Mobile Start URL, Permitted Users, Refresh Token Policy, SAML Attributes, Service Provider Certificate, Start URL, Subject Type |
| Neither Package Developer or Subscriber Can Edit | API Name, Created Date/By, Consumer Key, Consumer Secret, Installed By, Installed Date, Last Modified Date/By, Version |

### Considerations When Packaging

- 구독자나 설치자는 Connected App을 단독으로 삭제할 수 없으며, 오직 패키지 언인스톨로만 제거된다. 개발자가 패키지에서 Connected App을 삭제하면, 업그레이드 시 구독자 org에서도 삭제된다.
- Connected App의 업데이트를 배포하려면 일반적으로 새 패키지 버전을 Push Upgrade한다. 단, **PIN Protect 설정 변경**은 패키지 업그레이드 없이 구독자 org에 자동 배포된다.
- 다음 설정은 managed package 패치(patch)로 업데이트할 수 없으며, 새 버전을 배포해야 한다: Mobile App settings, Push messaging (Apple/Android/Windows), Canvas App settings, SAML settings.
- OAuth scope 또는 IP ranges가 이전 버전에서 변경된 Connected App을 포함한 패키지를 **Push Upgrade**하면 실패한다. 이는 무단 접근 차단을 위한 보안 기능이다. 구독자가 직접 수행하는 Pull Upgrade는 허용된다.
- Summer '13 이전에 생성된 Connected App: 기존 설치 URL은 새 버전 패키지 업로드 전까지 유효. 새 버전 업로드 후에는 설치 URL이 더 이상 동작하지 않는다.

**See Also:** Package Connected Apps in Second-Generation Managed Packaging

---

## CORS Allowlist (CorsWhitelistOrigin)

> Represents an origin in the CORS allowlist. Salesforce REST API 크로스-오리진 요청을 허용하는 URL 패턴.

**Metadata Name:** `CorsWhitelistOrigin`
**Component Type in 1GP Package Manager UI:** CORS Allowed Origin List
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (both 1GP and 2GP) |
| Component Has IP Protection | **No** |

> 개발자가 패키지에서 이 컴포넌트를 제거하면 업그레이드 후에도 구독자 org에 남아 있다. 구독자 org 관리자가 이후 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Url pattern |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

### More Information

- **Use Case**: 고객이 HTTPS 프로토콜과 도메인명을 포함한 URL 패턴을 추가할 수 있다. 포트 번호 포함 선택적. 와일드카드(`*`)는 second-level domain에만 지원 (예: `https://*.example.com`).
- **Documentation**: Salesforce Help: Enable CORS for OAuth Endpoints, Configure Salesforce CORS Allowlist

---

## CSP Trusted Site (CspTrustedSite)

> Represents a trusted URL. For each CspTrustedSite component, you can specify Content Security Policy (CSP) directives and permissions policy directives.

**Metadata Name:** `CspTrustedSite`
**Component Type in 1GP Package Manager UI:** CspTrustedSite
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | context, description, endpointUrl, isActive, isApplicableToConnectSrc, isApplicableToFontSrc, isApplicableToFrameSrc, isApplicableToImgSrc, isApplicableToMediaSrc, isApplicableToStyleSrc |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- CspTrustedSite를 패키지에 포함하면 서드파티 API 및 WebSocket 연결 권한이 org 전체 사이트·페이지에 적용된다. 보안 수정이 가능하므로 **패키지에 포함하지 않을 것을 권장**한다.
- 대신, 패키지 활성화 과정에서 고객이 **CSP Trusted Sites Setup 페이지** 또는 `CSPTrustedSites` Metadata API 타입으로 URL을 직접 허용목록에 추가하도록 안내하는 방법을 권장한다.
- 포함을 선택한다면 패키지 문서에 보안 수정 사항을 명확히 고지해야 한다.
- **JavaScript 리소스 제한**: 서드파티 사이트가 CSP Trusted Site로 등록되어 있어도 해당 사이트에서 직접 JavaScript를 로드할 수 없다. JavaScript 라이브러리는 Static Resource에 추가해 사용한다.
- CSP는 모든 브라우저에서 강제되지 않는다. 지원 브라우저 목록은 caniuse.com 참조.

**Usage Limits:**
- API version 39.0 이상에서 사용 가능.
- Experience Builder 사이트에서 HTTP 헤더 크기가 8 KB를 초과하면 지시문이 CSP 헤더에서 `<meta>` 태그로 이동한다. 인프라 한도 오류를 방지하려면 컨텍스트당 헤더 크기를 3 KB 이하로 유지한다.

**Relationship to Other Components:** Aura 또는 LWR(Lightning Web Runtime) Experience Cloud 사이트 페이지, Lightning Page, Visualforce 페이지와 함께만 사용 가능.

---

## External Auth Identity Provider

> Represents the external auth identity provider that obtains OAuth tokens for callouts that use named credentials.

**Metadata Name:** `ExternalAuthIdentityProvider`
**Component Type in 1GP Package Manager UI:** External Auth Identity Provider
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (2GP packages only) |
| Component Has IP Protection | **No** |

> 개발자가 패키지에서 이 컴포넌트를 제거하면 업그레이드 후에도 구독자 org에 남아 있다. 구독자 org 관리자가 이후 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

> 참고: Description, ParameterName, ParameterType, ParameterValue, SequenceNumber 속성은 포함된 ExternalAuthIdentityProviderParameters와 동일한 편집 가능성을 가진다.

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | AuthenticationFlow, AuthenticationProtocol, Description, Label |
| Both Package Developer and Subscriber Can Edit | ExternalAuthIdentityProviderParameter: AuthorizeUrl, ClientAuthentication, Description, IdentityProviderOptions, ParameterName, ParameterType, ParameterValue, RefreshRequestBodyParameter, RefreshRequestHttpHeader, RefreshRequestQueryParameter, SequenceNumber, StandardExternalIdentityProvider, TokenRequestBodyParameter, TokenRequestHttpHeader, TokenRequestQueryParameter, TokenUrl, UserInfoUrl |
| Neither Package Developer or Subscriber Can Edit | FullName |

### Considerations When Packaging

- Named Credentials와 External Credentials는 메타데이터로 표현되지만 표준 Metadata API는 토큰 같은 민감 정보를 평문으로 완전히 노출하거나 렌더링하지 못한다. 클라이언트 시크릿 같은 민감 값은 패키지에 포함되지 않는다.
- **Package upgrade 시 삭제 주의**: 구독자가 설치 후 추가한 커스텀 요청 파라미터는 패키지 업그레이드 시 삭제된다. 구독자에게 파라미터를 재생성해야 한다고 안내한다.
- 패키지 개발자는 파라미터를 생성하거나 기존 파라미터를 삭제할 수만 있다. 설치 후 구독자는 패키지 업그레이드에서 업데이트된 파라미터 값을 받지 못한다.

**Relationship to Other Components:** 외부 시스템으로의 callout은 Named Credential을 참조하고, Named Credential은 External Credential에 링크된다. OAuth 2.0 인증을 사용하는 External Credential의 경우 External Auth Identity Provider가 아웃바운드 callout에 필요한 OAuth 토큰을 가져온다.

---

## External Credential

> Represents the details of how Salesforce authenticates to the external system.

**Metadata Name:** `ExternalCredential`
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (2GP packages only) |
| Component Has IP Protection | **No** |

> 개발자가 패키지에서 이 컴포넌트를 제거하면 업그레이드 후에도 구독자 org에 남아 있다. 구독자 org 관리자가 이후 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

> 참고: Description, ParameterGroup, ParameterName, ParameterValue, SequenceNumber 속성은 포함된 ExternalCredentialParameters와 동일한 편집 가능성을 가진다.

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label, AuthenticationProtocol, ExternalCredentialParameters: AuthProtocolVariant |
| Both Package Developer and Subscriber Can Edit | Description, ExternalCredentialParameters: AuthHeader, AuthProvider (2GP에서 구독자만 편집 가능), AuthProviderUrl, AuthProviderUrlQueryParameter, AuthParameter, AwsStsPrincipal (AWS Signature v4 + STS 사용 시에만), JwtBodyClaim, JwtHeaderClaim, NamedPrincipal, PerUserPrincipal, SequenceNumber, SigningCertificate (2GP에서 구독자만 편집 가능) |
| Neither Package Developer or Subscriber Can Edit | FullName |

### Considerations When Packaging

- Named/External Credentials는 Metadata API로 완전히 정의를 노출하거나 토큰 같은 민감 정보를 평문으로 렌더링하지 못한다. 패키지된 Named Credentials에는 인증된 callout에 필요한 access token이나 인증서가 포함되지 않는다. Connect API 또는 UI를 통해 External Credential의 principal을 생성하거나 토큰·인증서를 채울 수 있다.
- **1GP에서 OAuth 2.0 사용 시**: External Credential이 OAuth 2.0 인증 프로토콜을 사용한다면 인증 공급자(AuthProvider)를 참조해야 한다. AuthProvider를 참조하면 해당 AuthProvider가 패키지에 자동으로 추가된다.
- **2GP에서 OAuth 2.0 사용 시**: External Credential이 AuthProvider를 참조해도 패키지에 해당 참조를 포함할 수 없다. 구독자 org에서 AuthProvider를 재생성하고 External Credential에 추가해야 한다.

**Post Install Steps:**
1. UI 또는 Connect API를 통해 External Credential의 principal을 생성하거나 토큰·인증서를 채운다.
2. External Credential의 principal에 Permission Set 및 Profile 접근을 부여한다 (Enable External Credential Principals 참조).
3. 외부 시스템에 재인증한다.
   - Named Principal: Setup > Named Credential > External Credential에서 관리자 인증.
   - Per User Principal: My Personal Information > External Credential에서 사용자별 인증.

**Relationship to Other Components:** ExternalCredential은 NamedCredential 없이 패키지에 추가할 수 있지만, NamedCredential은 반드시 ExternalCredential과 함께 패키징해야 한다.

---

## Identity Verification Proc Def

> Represents the definition of the identity verification process.

**Metadata Name:** `IdentityVerificationProcDef`
**Component Type in 1GP Package Manager UI:** Identity Verification Process Definition
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | MasterLabel, SearchLayoutType |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### More Information

- **Use Case**: Identity Verification 설정을 Flow에 연결한다.
- **License Requirements**: Industries Health Cloud, Industries Sales Excellence, Industries Service Excellence 라이선스 필요. Actionable Segmentation Engagement, Industries Sales Excellence, Industry Service Excellence, 또는 Health Cloud Platform Permission Set 라이선스도 필요.
- **Relationship to Other Components**: Identity Verification Process Field 레코드는 Identity Verification Process Details 레코드를 참조하고, 이는 Identity Verification Process Definition 레코드를 참조한다.
- **Documentation**: Health Cloud Developer Guide: IdentityVerificationProcDef

---

## Live Chat Sensitive Data Rule

> Represents a rule for masking or deleting data of a specified pattern. Written as a regular expression (regex). Use this object to mask or delete data of specified patterns, such as credit card, social security, or phone and account numbers.

**Metadata Name:** `LiveChatSensitiveDataRule`
**Component Type in 1GP Package Manager UI:** Sensitive Data Rules
**Packageable In:** **1GP only** (2GP에서 지원되지 않음)

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **No** |
| Subscriber Can Delete Component From Org | **Yes** |
| Package Developer Can Remove Component From Package | **Yes** (1GP only) |
| Component Has IP Protection | **No** |

> 개발자가 패키지에서 이 컴포넌트를 제거하면 업그레이드 후에도 구독자 org에 남아 있다. 구독자 org 관리자가 이후 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

---

## Permission Set

> Represents a set of permissions that's used to grant more access to one or more users without changing their profile or reassigning profiles. You can use permission sets to grant access but not to deny access.

**Metadata Name:** `PermissionSet`
**Component Type in 1GP Package Manager UI:** Permission Set
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **Yes** (both 1GP and 2GP) |
| Component Has IP Protection | **No** |

> 개발자가 패키지에서 이 컴포넌트를 제거하면 업그레이드 후에도 구독자 org에 남아 있다. 구독자 org 관리자가 이후 삭제할 수 있다.

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Label, Custom object permissions, Custom field permissions, Apex class access settings, Visualforce page access settings |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

### Permission Set vs Profile Settings 비교

| 항목 | Permission Sets | Profile Settings |
|---|---|---|
| 포함 내용 | 커스텀 앱/오브젝트/필드 권한, Apex 클래스, VF 페이지, External Data Source, Custom Permission 등 | 커스텀 앱, 탭 설정, 페이지 레이아웃 배정, 레코드 타입 배정, 커스텀 필드 권한 등 |
| 업그레이드 가능? | Yes | 신규 컴포넌트 관련 설정만 적용 |
| 구독자 편집? | No | Yes |
| 표준 오브젝트 권한 포함? | No | No |
| 사용자 권한 포함? | No | No |
| 설치 위저드에 포함? | No (설치 후 수동 배정) | Yes (설치 시 기존 프로파일에 적용) |
| 라이선스 요건 | org에 매칭 라이선스 보유 시에만 설치 | 없음 |

**Best Practices:**
- 표준 탭 가시성, 페이지 레이아웃, 레코드 타입 접근이 필요하면 Permission Set만으로 권한 부여 모델을 구성하지 않는다.
- 커스텀 컴포넌트 접근을 부여하는 패키지된 Permission Set를 만들되, 표준 Salesforce 컴포넌트는 포함하지 않는다.
- Permission Set에 커스텀 앱이 배정된 경우, 구독자가 앱을 삭제하면 해당 배정은 나중에 업그레이드 시 Permission Set에서 제거된다.

---

## Permission Set Groups

> Represents a group of permission sets and the permissions within them. Use permission set groups to organize permissions based on job functions or tasks. Then, you can package the groups as needed.

**Metadata Name:** `PermissionSetGroup`
**Component Type in 1GP Package Manager UI:** Permission Set Group
**Packageable In:** 2GP, 1GP

### Manageability Rules

| 속성 | 값 |
|---|---|
| Component Is Updated During Package Upgrade | **Yes** |
| Subscriber Can Delete Component From Org | **No** |
| Package Developer Can Remove Component From Package | **No** |
| Component Has IP Protection | **No** |

### Editable Properties After Package Promotion or Installation

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | Permission Set Group Components (개발자는 추가·제거 가능, 구독자는 추가만 가능) |
| Neither Package Developer or Subscriber Can Edit | None |

### Considerations When Packaging

- 구독자의 Permission Set Group이 개발자가 지정한 것과 동일하다고 가정하지 않는다. 개발자가 그룹과 포함될 Permission Set를 정의할 수 있지만, 구독자는 추가적인 Permission Set를 추가하거나 권한을 mute할 수 있다.
- 스탠다드 오브젝트 오브젝트 권한은 Managed Package에 포함할 수 없다. 설치 중 스탠다드 오브젝트의 모든 오브젝트 권한은 무시되어 org에 설치되지 않는다.
- Permission Set License에 의해 제한된 Permission Set는 Managed 또는 Unmanaged Package에 추가할 수 없다.
- 패키지에 포함된 메타데이터에 대한 권한만 패키징할 수 있다.

**Relationship to Other Components:** Permission Sets와 함께만 사용 가능.

---

## 코드 예시 — Permission Set XML (PermissionSet 패키징)

```xml
<!-- 구조 예시 — 실제 동작 코드 아님 -->
<!-- permissionsets/MyPackagePS.permissionset -->
<?xml version="1.0" encoding="UTF-8"?>
<PermissionSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <description>Package permission set for custom components</description>
    <label>My Package PS</label>
    <classAccesses>
        <apexClass>MyNamespace__MyController</apexClass>
        <enabled>true</enabled>
    </classAccesses>
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>false</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>false</modifyAllRecords>
        <object>MyNamespace__MyCustomObject__c</object>
        <viewAllRecords>false</viewAllRecords>
    </objectPermissions>
</PermissionSet>
```

---

## 패키징 고려사항 요약

```
// 구조 예시 — 실제 동작 설정 아님
2GP Security & Access 패키징 체크리스트:

1. Certificate   → 패키징 불가. 구독자 org에 직접 업로드 후 Named Credential에서 참조.
2. AuthProvider  → 1GP에서는 ExternalCredential과 함께 자동 포함. 2GP에서는 포함 불가, 구독자가 재생성해야 함.
3. ConnectedApp  → Push Upgrade 시 OAuth scope/IP range 변경 있으면 실패 (보안 기능). Pull Upgrade는 허용.
4. CspTrustedSite → 포함보다 고객 직접 설정 권장. 포함 시 문서에 명시.
5. ExternalCredential → 설치 후 구독자가 Post Install Steps (principal 생성, 재인증) 반드시 실행.
6. PermissionSet  → Profile보다 PermissionSet 우선 사용. 표준 컴포넌트 접근은 포함하지 않는다.
7. Profile       → 2GP에서는 패키지에 포함되지 않음. Profile Settings 방식(패키지 메타데이터 관련 설정만)으로만 동작.
```

---

## 관련 노트

- [[Metadata Types — Security & Access]] — PermissionSet, Profile, SharingRules, ConnectedApp 메타데이터 타입 전수
- [[2GP Managed Package — Workflow]] — Manageability Rules 4속성·Editable Properties 3카테고리 개요·Supported Components 전수 목록
- [[2GP — Components: Apex & Code]] — ApexClass, LWC, StaticResource 2GP 패키징 규칙
- [[2GP — Components: Automation]] — Flow, Workflow 2GP 패키징 규칙
- [[2GP — Components: Einstein & Analytics]] — GenAiPlugin, AIApplication 2GP 패키징 규칙
- [[2GP — Components: Integration & Platform]] — ExternalDataSource, NamedCredential, FeatureParameter 2GP 패키징 규칙
- [[2GP — Components: Objects & Fields]] — CustomObject, CustomField 2GP 패키징 규칙
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Specific Metadata Behavior]] — Permission Set vs Profile Settings 비교 전수·Profile Settings 2GP 처리 방식(scopeProfiles)·Install for Admins Only/All Users/Specific Profiles·Protected Components 목록·IP 보호 규칙
