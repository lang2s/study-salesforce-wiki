---
tags: [devops, metadata-api, metadata-types, permission-set, profile, sharing-rules, connected-app, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [PermissionSet 메타데이터, Profile 메타데이터, SharingRules 메타데이터, ConnectedApp 메타데이터, 보안 접근 메타데이터 타입]
---

# Metadata Types — Security & Access

> PermissionSet, Profile, SharingRules, ConnectedApp, Certificate, Role, Territory 등 보안·접근 제어 관련 메타데이터 타입.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| AccountRelationshipShareRule | 계정 관계 기반 공유 규칙 |
| AuthProvider | OAuth 인증 공급자 |
| BlacklistedConsumer | 차단된 연결 앱 |
| Certificate | 디지털 서명용 인증서 |
| ConnectedApp | 연결된 앱 (OAuth/SAML/OpenID) |
| CorsWhitelistOrigin | CORS 허용 목록 원본 |
| CspTrustedSite | CSP 신뢰 URL |
| DelegateGroup | 동일 관리 권한 사용자 그룹 |
| ExternalAuthIdentityProvider | 외부 인증 ID 공급자 |
| ExternalClientApplication | 외부 클라이언트 앱 헤더 파일 |
| ExternalCredential | 외부 시스템 인증 세부 정보 |
| ExtlClntAppCanvasSettings | 외부 클라이언트 앱 Canvas 설정 |
| ExtlClntAppConfigurablePolicies | 외부 클라이언트 앱 플러그인 정책 |
| ExtlClntAppGlobalOauthSettings | 전역 OAuth 설정 (소스 관리 제외, 패키지 불가) |
| ExtlClntAppMobileConfigurablePolicies | 외부 클라이언트 앱 모바일 정책 |
| ExtlClntAppMobileSettings | 외부 클라이언트 앱 모바일 설정 |
| ExtlClntAppNotificationSettings | 외부 클라이언트 앱 알림 구독 |
| ExtlClntAppOauthConfigurablePolicies | OAuth 외부 클라이언트 앱 정책 |
| ExtlClntAppOauthSettings | OAuth 플러그인 설정 |
| ExtlClntAppPushConfigurablePolicies | 푸시 알림 정책 |
| ExtlClntAppPushSettings | 푸시 알림 설정 |
| ExtlClntAppSamlConfigurablePolicies | SAML SSO 정책 |
| FieldRestrictionRule | 필드 가시성 제한 규칙 |
| Group | 공개 그룹 |
| IdentityVerificationProcDef | 신원 확인 프로세스 정의 |
| IdentityVerificationProcDtl | 신원 확인 검색·최소 검증 설정 |
| IdentityVerificationProcFld | 신원 확인 검색·검증 필드 |
| InboundCertificate | 상호 인증 인증서 |
| IPAddressRange | IP 주소 범위 |
| LiveChatSensitiveDataRule | 민감 데이터 마스킹/삭제 규칙 |
| MobileSecurityAssignment | 모바일 보안 정책 ↔ 프로파일 배정 |
| MobileSecurityPolicy | Salesforce 모바일 앱 보안 정책 |
| MobSecurityCertPinConfig | 모바일 보안 인증서 핀 설정 |
| ModerationRule | Experience Cloud 사이트 모더레이션 규칙 |
| MutingPermissionSet | 비활성화된 권한 세트 |
| MyDomainDiscoverableLogin | My Domain 로그인 Discovery 설정 |
| OauthCustomScope | OAuth 커스텀 스코프 |
| OauthTokenExchangeHandler | OAuth 2.0 토큰 교환 핸들러 |
| PermissionSet | 권한 세트 |
| PermissionSetGroup | 권한 세트 그룹 |
| PermissionSetLicenseDefinition | 커스텀 권한 세트 라이선스 정의 (Developer Preview) |
| PersonAccountOwnerPowerUser | 대규모 포털 계정 소유 사용자 |
| PortalDelegablePermissionSet | 외부 사용자 위임 가능 권한 세트 |
| Profile | 사용자 프로파일 |
| ProfileActionOverride | 프로파일별 ActionOverride 재정의 |
| ProfilePasswordPolicy | 프로파일 암호 정책 |
| ProfileSessionSetting | 프로파일 세션 설정 |
| PublicKeyCertificate | 공개 키 인증서 |
| PublicKeyCertificateSet | 공개 키 인증서 세트 |
| RedirectWhitelistUrl | 리다이렉션 신뢰 URL |
| RestrictionRule | 제한 규칙 / 범위 규칙 |
| Role | 사용자 역할 |
| RoleOrTerritory | 역할 또는 영역 공통 기반 타입 |
| SamlSsoConfig | SAML SSO 설정 |
| SharedTo | 목록 뷰/폴더 공유 접근 정의 |
| SharingBaseRule | 공유 규칙 기본 설정 |
| SharingRules | 공유 규칙 컨테이너 |
| SharingSet | 포털/커뮤니티 사용자 공유 세트 |
| Territory | 영역 |
| Territory2 | Sales Territories 영역 |
| Territory2Model | Sales Territories 영역 모델 |
| Territory2Rule | Sales Territories 영역 배정 규칙 |
| Territory2Type | Sales Territories 영역 타입 |
| TransactionSecurityPolicy | 트랜잭션 보안 정책 |
| UserAccessPolicy | 사용자 접근 정책 |
| UserAuthCertificate | PEM 인코딩 사용자 인증서 |
| UserCriteria | Experience Cloud 모더레이션 멤버 기준 |
| UserProvisioningConfig | 사용자 프로비저닝 요청 플로우 정보 |

---

## PermissionSet

사용자에게 추가 접근 권한을 부여하는 권한 세트 (접근 거부 불가, 부여만 가능). `Metadata` 타입을 extends.

**파일 경로:** `permissionsets/PermissionSetName.permissionset`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `applicationVisibilities` | PermissionSetApplicationVisibility[] | - | 앱 가시성 목록 |
| `classAccesses` | PermissionSetApexClassAccess[] | - | Apex 클래스 접근 목록 |
| `customMetadataTypeAccesses` | PermissionSetCustomMetadataTypeAccess[] | - | 커스텀 메타데이터 타입 접근 |
| `customPermissions` | PermissionSetCustomPermissions[] | - | 커스텀 권한 목록 |
| `customSettingAccesses` | PermissionSetCustomSettingAccess[] | - | 커스텀 설정 접근 |
| `description` | string | - | 설명 |
| `externalDataSourceAccesses` | PermissionSetExternalDataSourceAccess[] | - | 외부 데이터 소스 접근 |
| `fieldPermissions` | PermissionSetFieldPermissions[] | - | 필드 권한 목록 |
| `fullName` | string | - | 권한 세트 API 이름 |
| `hasActivationRequired` | boolean | - | 세션 기반 권한 세트 여부 |
| `label` | string | - | 표시 레이블 |
| `license` | string | - | 연관된 라이선스 |
| `objectPermissions` | PermissionSetObjectPermissions[] | - | 오브젝트 권한 목록 |
| `pageAccesses` | PermissionSetApexPageAccess[] | - | Visualforce 페이지 접근 |
| `recordTypeVisibilities` | PermissionSetRecordTypeVisibility[] | - | 레코드 타입 가시성 |
| `tabSettings` | PermissionSetTabSetting[] | - | 탭 설정 |
| `userPermissions` | PermissionSetUserPermission[] | - | 사용자 권한 목록 |

---

## PermissionSetGroup

권한 세트 그룹. 직무·업무별 권한 세트 묶음.

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `description` | string | - | 설명 |
| `fullName` | string | - | 그룹 API 이름 |
| `label` | string | Required | 표시 레이블 |
| `mutingPermissionSets` | string[] | - | 적용할 MutingPermissionSet 목록 |
| `permissionSets` | string[] | - | 포함될 PermissionSet 목록 |
| `status` | string | - | 계산 상태 |

---

## Profile

사용자 프로파일. 사용자의 기능별 권한을 정의. `Metadata` 타입을 extends.

**파일 경로:** `profiles/ProfileName.profile`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `applicationVisibilities` | ProfileApplicationVisibility[] | - | 앱 가시성 |
| `classAccesses` | ProfileApexClassAccess[] | - | Apex 클래스 접근 |
| `custom` | boolean | - | 커스텀 프로파일 여부 |
| `customPermissions` | ProfileCustomPermissions[] | - | 커스텀 권한 |
| `description` | string | - | 설명 |
| `fieldLevelSecurities` | ProfileFieldLevelSecurity[] | - | 필드 수준 보안 (v23.0 이하, 이후 `fieldPermissions` 사용) |
| `fieldPermissions` | ProfileFieldPermissions[] | - | 필드 권한 (v23.0+) |
| `fullName` | string | - | 프로파일 API 이름 |
| `layoutAssignments` | ProfileLayoutAssignment[] | - | 레이아웃 배정 |
| `loginHours` | ProfileLoginHours | - | 로그인 허용 시간 |
| `loginIpRanges` | ProfileLoginIpRange[] | - | 로그인 허용 IP 범위 |
| `objectPermissions` | ProfileObjectPermissions[] | - | 오브젝트 권한 |
| `pageAccesses` | ProfileApexPageAccess[] | - | VF 페이지 접근 |
| `profileActionOverrides` | ProfileActionOverride[] | - | 액션 재정의 (v39.0~44.0에서 CustomApplication 포함, v45.0+는 CustomApplication으로만 접근) |
| `recordTypeVisibilities` | ProfileRecordTypeVisibility[] | - | 레코드 타입 가시성 |
| `tabVisibilities` | ProfileTabVisibility[] | - | 탭 가시성 |
| `userLicense` | string | - | 사용자 라이선스 |
| `userPermissions` | ProfileUserPermission[] | - | 사용자 권한 |

---

## ConnectedApp

연결된 앱 구성. OAuth, SAML, OpenID Connect 기반 외부 애플리케이션 통합.

**파일 경로:** `connectedApps/ConnectedAppName.connectedApp`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `attributes` | ConnectedAppAttribute[] | - | SAML/OpenID 속성 목록 |
| `canvasConfig` | ConnectedAppCanvasConfig | - | Canvas 앱 설정 |
| `contactEmail` | string | Required | 앱 소유자 연락 이메일 |
| `contactPhone` | string | - | 연락 전화번호 |
| `description` | string | - | 앱 설명 |
| `fullName` | string | - | 앱 고유 이름 |
| `iconUrl` | string | - | 앱 아이콘 URL |
| `infoUrl` | string | - | 앱 정보 URL |
| `ipRanges` | ConnectedAppIpRange[] | - | IP 범위 제한 |
| `label` | string | Required | 표시 레이블 |
| `logoUrl` | string | - | 앱 로고 URL |
| `mobileAppConfig` | ConnectedAppMobileDetailConfig | - | 모바일 앱 설정 |
| `mobileStartUrl` | string | - | 모바일 시작 URL |
| `oauthConfig` | ConnectedAppOauthConfig | - | OAuth 설정 |
| `permissionSetName` | string[] | - | 접근 권한 세트 목록 |
| `profileName` | string[] | - | 접근 프로파일 목록 |
| `samlConfig` | ConnectedAppSamlConfig | - | SAML 설정 |
| `startUrl` | string | - | 시작 URL |

---

## SharingRules

공유 규칙 컨테이너. 기준 기반, 소유권 기반, 영역 기반, 게스트 액세스 공유 규칙 포함.

**파일 경로:** `sharingRules/ObjectName.sharingRules`

### 주요 Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `criteriaBasedRules` | SharingCriteriaRule[] | - | 기준 기반 공유 규칙 |
| `guestUserRules` | SharingGuestRule[] | - | 게스트 사용자 공유 규칙 |
| `ownerRules` | SharingOwnerRule[] | - | 소유권 기반 공유 규칙 |
| `territoryRules` | SharingTerritoryRule[] | - | 영역 기반 공유 규칙 |

---

## CspTrustedSite

CSP 신뢰 URL. Lightning 컴포넌트, 서드파티 API, WebSocket 연결에 필요.

**API v58.0 이하:** CSP 지시문만 포함. **v59.0+:** 권한 정책 지시문도 추가됨. 이전에는 "CSP Trusted Sites"로 지칭.

---

## CorsWhitelistOrigin

CORS 허용 목록 원본. Salesforce REST API 크로스-오리진 요청 허용.

---

## Certificate

디지털 서명 또는 SSO/ID 공급자용 인증서. `MetadataWithContent` 타입을 extends.

---

## AuthProvider

OAuth 인증 공급자. Facebook, Google, GitHub 등 외부 서비스를 통한 Salesforce 로그인. `Metadata` 타입을 extends.

---

## SamlSsoConfig

SAML Single Sign-On 설정. `Metadata` 타입을 extends. 서드파티 앱이 Salesforce를 ID 공급자로 사용하거나, Salesforce가 서드파티 IdP를 신뢰하도록 설정.

---

## RestrictionRule

제한 규칙(Restriction Rule) / 범위 규칙(Scoping Rule). `Metadata` 타입을 extends.

| 타입 | `enforcementType` 값 | 동작 |
|---|---|---|
| 제한 규칙 | `Restrict` | 지정된 사용자의 레코드 접근을 제어 |
| 범위 규칙 | `Scoping` | 사용자가 기본으로 보는 레코드를 제어 (접근 제한은 아님) |

---

## TransactionSecurityPolicy

트랜잭션 보안 정책. org 이벤트를 분석하고 특정 조건 조합 시 액션 실행.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata Types — Objects & Fields]] — CustomObject, CustomField
- [[Metadata Types — Integration & Platform]] — NamedCredential, RemoteSiteSetting
- [[Metadata API File-Based 호출]] — Profile, PermissionSet 배포 시 package.xml
- [[2GP — Components: Security & Access]] — 2GP 패키징 관점: ConnectedApp·CorsWhitelistOrigin·CspTrustedSite·ExternalCredential·PermissionSet 등 Manageability Rules 전수

---

## Declarative Metadata 예시

### PermissionSet XML 예시

```xml
<!-- permissionsets/MyPermSet.permissionset -->
<?xml version="1.0" encoding="UTF-8"?>
<PermissionSet xmlns="http://soap.sforce.com/2006/04/metadata">
    <description>Custom permission set for sales reps</description>
    <label>Sales Rep Permissions</label>
    <objectPermissions>
        <allowCreate>true</allowCreate>
        <allowDelete>false</allowDelete>
        <allowEdit>true</allowEdit>
        <allowRead>true</allowRead>
        <modifyAllRecords>false</modifyAllRecords>
        <object>Opportunity</object>
        <viewAllRecords>false</viewAllRecords>
    </objectPermissions>
    <userPermissions>
        <enabled>true</enabled>
        <name>ViewSetup</name>
    </userPermissions>
</PermissionSet>
```

### SharingRules XML 예시

```xml
<!-- sharingRules/Account.sharingRules -->
<?xml version="1.0" encoding="UTF-8"?>
<SharingRules xmlns="http://soap.sforce.com/2006/04/metadata">
    <criteriaBasedRules>
        <accessLevel>Read</accessLevel>
        <accountSettings>
            <caseAccessLevel>None</caseAccessLevel>
            <contactAccessLevel>None</contactAccessLevel>
            <opportunityAccessLevel>None</opportunityAccessLevel>
        </accountSettings>
        <criteriaItems>
            <field>Industry</field>
            <operation>equals</operation>
            <value>Technology</value>
        </criteriaItems>
        <fullName>Account.techAccounts</fullName>
        <label>Technology Accounts</label>
        <sharedTo>
            <role>SalesRep</role>
        </sharedTo>
    </criteriaBasedRules>
</SharingRules>
```

### package.xml 에서 Profile 배포

```xml
<!-- package.xml -->
<types>
    <members>Custom: Sales Profile</members>
    <name>Profile</name>
</types>
<types>
    <members>MySalesRepPS</members>
    <name>PermissionSet</name>
</types>
```
