---
tags: [devops, 2gp, managed-package, packaging, integration, platform, named-credential, remote-site, feature-parameter, embedded-service, event-relay, external-data-source, platform-cache]
source: pkg2_dev.pdf — Components Available in Second-Generation Managed Packages (p.25-313)
created: 2026-05-23
aliases: [2GP 통합 플랫폼 컴포넌트, Integration Platform 2GP, named credential 패키징, feature parameter 2GP, external data source 2GP, platform cache 2GP]
---

# 2GP — Components: Integration & Platform

> 2GP Managed Package에 포함 가능한 통합·플랫폼 도메인 컴포넌트의 Manageability Rules 4속성과 Editable Properties 3카테고리 전수.

---

## Manageability Rules — 4속성 의미

| 속성 | Yes 의미 | No 의미 |
|---|---|---|
| **Component Is Updated During Package Upgrade** | 업그레이드 시 구독자 org의 컴포넌트가 갱신됨 | 최초 설치만 되고 이후 업그레이드는 미반영 |
| **Subscriber Can Delete Component From Org** | 구독자(설치자)가 패키지 컴포넌트를 삭제 가능 | 구독자가 삭제 불가 |
| **Package Developer Can Remove Component From Package** | 패키지 개발자가 향후 버전에서 컴포넌트 제거 가능 | promoted 후 제거 불가 |
| **Component Has IP Protection** | 메타데이터(Apex 코드 등)가 구독자 org에서 숨겨짐 | 구독자 org에서 콘텐츠 가시 |

## Editable Properties — 3카테고리

- **Only Package Developer Can Edit**: 개발자만 편집. 구독자 org는 잠김. 업그레이드로 변경 반영.
- **Both Subscriber and Package Developer Can Edit**: 양쪽 편집 가능. 단, 개발자 변경은 신규 설치에만 적용 (구독자 수정 덮어쓰기 방지).
- **Neither Subscriber or Package Developer Can Edit**: promoted 후 완전 잠김 (API 이름 등).

---

## 컴포넌트별 Manageability Rules

### App Framework Template Bundle

Data Cloud 및 Tableau Next 애셋용 앱 프레임워크 템플릿 번들.

**Metadata Name:** `AppFrameworkTemplateBundle`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | Yes |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label, MaxAppCount |
| Both Can Edit | Description, TemplateBadgeIcon |
| Neither Can Edit | AssetVersion, TemplateType |

> 고려사항: Data Cloud·Tableau Next 애셋은 AppFrameworkTemplateBundle 템플릿을 통해 구독자 org에 설치됨. 시각화 애셋의 데이터 동기화·오케스트레이션 및 org별 커스터마이징을 지원.
> 라이선스 요건: Tableau Included App Manager permission set

---

### Care Benefit Verify Settings

Health Cloud 보험 혜택 검증 요청 구성 설정.

**Metadata Name:** `CareBenefitVerifySettings`
**1GP UI 이름:** Care Benefit Verification Settings

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | MasterLabel, ServiceApexClass, ServiceNamedCredential, UriPath, isDefault, GeneralPlanServiceTypeCode, ServiceTypeSourceSystem, OrganizationName, DefaultNpi, CodeSetType |
| Both Can Edit | None |
| Neither Can Edit | Name |

> 라이선스 요건: Industries Health Cloud
> 관련 컴포넌트: ApexClass 및 NamedCredential을 포함 가능.

---

### Care System Field Mapping

소스 시스템 필드 → Salesforce 타겟 엔티티·속성 매핑. Health Cloud Care Program Enrollment 또는 Remote Monitoring 기능용.

**Metadata Name:** `CareSystemFieldMapping`
**1GP UI 이름:** Care System Field Mapping

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | External ID Field, Is Active, Label, Source System, Target Object |
| Both Can Edit | None |
| Neither Can Edit | Name |

> 라이선스 요건: Industries Health Cloud

---

### Chatter Extension

Chatter publisher에 통합되는 Rich Publisher App 메타데이터. **1GP만 패키징 가능.**

**Metadata Name:** `ChatterExtension`

| 속성 | 값 |
|---|---|
| Packageable In | **1GP only** |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | **Yes** |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Header Text, Hover Text, Icon, Name |
| Both Can Edit | None |
| Neither Can Edit | Composition CMP, Render CMP, Type |

---

### Claim Financial Settings

Insurance Claim Financial Services 구성 설정.

**Metadata Name:** `ClaimFinancialSettings`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label |
| Both Can Edit | Claim Coverage Pending Authority Status, Claim Coverage Payment Detail Pending Authority Status, Claim Pending Authority Status |
| Neither Can Edit | None |

---

### Context Definition

Context Service 컨텍스트 정의. 노드·속성 간 관계를 정의. **1GP만 패키징 가능.**

**Metadata Name:** `ContextDefinition`
**1GP UI 이름:** Context Definition

| 속성 | 값 |
|---|---|
| Packageable In | **1GP only** |
| Component Is Updated During Package Upgrade | Yes. 단, 활성 컨텍스트 정의가 없는 경우에만. |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | None |
| Neither Can Edit | Standard Context Definitions |

---

### Conversation Vendor Info

Service Cloud Voice 파트너 벤더 시스템 연결. Service Cloud 기능에 파트너 벤더 시스템을 연결하는 setup object.

**Metadata Name:** `ConversationVendorInfo`
**1GP UI 이름:** ConversationVendorInfo

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | **Yes** |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | None |
| Neither Can Edit | None |

> 라이선스 요건: Service Cloud Voice 활성화 필요.
> 관련 컴포넌트: ConversationChannelDefinition과 연결됨.

---

### Embedded Service Config

Embedded Service for Web 배포 setup node. **1GP만 패키징 가능.**

**Metadata Name:** `EmbeddedServiceConfig`

| 속성 | 값 |
|---|---|
| Packageable In | **1GP only** |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | None |
| Neither Can Edit | None |

---

### Event Relay (EventRelayConfig)

Salesforce → Amazon EventBridge로 플랫폼 이벤트·CDC 이벤트를 릴레이하는 이벤트 릴레이 설정.

**Metadata Name:** `EventRelayConfig`
**1GP UI 이름:** Event Relay

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | Label, RelayOption, State |
| Neither Can Edit | DestinationResourceName, EventChannel, UsageType |

---

### External Data Source

외부 데이터 소스. Salesforce 외부에 저장된 데이터·콘텐츠에 대한 연결 정보를 관리.

**Metadata Name:** `ExternalDataSource`
**1GP UI 이름:** External Data Source

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Type |
| Both Can Edit | Auth Provider, Certificate, Custom Configuration, Endpoint, Identity Type, OAuth Scope, Password, Protocol, Username |
| Neither Can Edit | Name |

> 고려사항:
> - 패키지에서 외부 데이터 소스 설치 후, 구독자는 외부 시스템에 재인증 필요.
>   - Password 인증: 구독자가 external data source 정의에서 암호 재입력.
>   - OAuth: 인증 공급자의 client configuration에서 callback URL 업데이트 후 재인증.
> - 인증서는 패키징 불가. 외부 데이터 소스가 인증서를 지정하는 경우, 구독자 org에 동일한 이름의 유효한 인증서가 있어야 함.

---

### External Services (ExternalServiceRegistration)

외부 서비스 설정. OpenAPI 스펙 등록으로 외부 REST API를 Flow·Apex에서 호출 가능하게 함.

**Metadata Name:** `ExternalServiceRegistration`
**1GP UI 이름:** ExternalServiceRegistration

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | Yes (External Services 등록과 해당 액션에 Flow 등 다른 기능의 의존성이 없는 경우) |
| Package Developer Can Remove Component From Package | Yes. 1GP, 2GP 모두 지원. |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Label, Schema, Schema URL |
| Both Can Edit | Named Credential |
| Neither Can Edit | None |

> 고려사항:
> - 패키지 개발자는 External Services registration 패키지에 named credential 컴포넌트를 함께 추가해야 함.
> - 구독자도 Salesforce에서 named credential을 생성할 수 있으나, External Services registration에 지정된 named credential과 동일한 이름을 사용해야 함.
> - 구독자 org가 named credential을 설치하면, External Services registration이 생성하는 Apex callout을 사용 가능.

---

### Feature Parameter Boolean

Feature Management App (FMA)의 Boolean 기능 파라미터. 구독자 org에서 앱 동작 제어 및 활성화 지표 추적.

**Metadata Name:** `FeatureParameterBoolean`
**1GP UI 이름:** Feature Parameter Boolean

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | No. 주의사항 참조. |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

> 주의사항: Data Flow Direction이 LMO-to-Subscriber이면 LMO(License Management Org)에서 업데이트 가능. Subscriber-to-LMO이면 구독자 org에서 Apex로 업데이트 가능. 두 경우 모두 패키지 업그레이드 불필요.

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Master Label, Value (Data Flow Direction = LMO to Subscriber) |
| Both Can Edit | Value (Data Flow Direction = Subscriber to LMO) |
| Neither Can Edit | Full Name, Data Type, Data Flow Direction |

> 고려사항:
> - Feature Parameter는 LMA(License Management App)의 확장. beta 패키지 버전은 LMA에 등록 불가이므로, beta에서는 LMO-to-Subscriber 기본값 테스트만 가능.
> - Subscriber-to-LMO feature parameter 값은 beta managed package version에서 테스트 불가.
> - 패키지당 최대 200개 Feature Parameter.

---

### Feature Parameter Date

Feature Management App (FMA)의 Date 기능 파라미터.

**Metadata Name:** `FeatureParameterDate`
**1GP UI 이름:** Feature Parameter Date

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | No. 주의사항 참조. |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Master Label, Value (Data Flow Direction = LMO to Subscriber) |
| Both Can Edit | Value (Data Flow Direction = Subscriber to LMO) |
| Neither Can Edit | Full Name, Data Type, Data Flow Direction |

> FeatureParameterBoolean과 동일한 LMA 제약·beta 제한·200개 한도 적용.

---

### Feature Parameter Integer

Feature Management App (FMA)의 Integer 기능 파라미터.

**Metadata Name:** `FeatureParameterInteger`
**1GP UI 이름:** Feature Parameter Integer

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | No. 주의사항 참조. |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Master Label, Value (Data Flow Direction = LMO to Subscriber) |
| Both Can Edit | Value (Data Flow Direction = Subscriber to LMO) |
| Neither Can Edit | Full Name, Data Type, Data Flow Direction |

> FeatureParameterBoolean과 동일한 LMA 제약·beta 제한·200개 한도 적용.

---

### Gateway Provider Payment Method Type

결제 게이트웨이 통합자·공급자가 능동적 결제를 선택하게 하는 엔티티. Salesforce Order Management 기본 결제 방법 대신 사용.

**Metadata Name:** `GatewayProviderPaymentMethodType`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | None |
| Neither Can Edit | All fields |

> 라이선스 요건: Salesforce Order Management, B2B Commerce, B2C Commerce (B2B2C Commerce) 라이선스. Payment Platform org permission 필요.

---

### Inbound Network Connection

서드파티 데이터 서비스 → Salesforce org 간 프라이빗 인바운드 연결.

**Metadata Name:** `InboundNetworkConnection`
**1GP UI 이름:** Inbound Network Connection

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes |
| Component Has IP Protection | No |

> 주의사항: 미프로비저닝(unprovisioned) 상태의 연결만 삭제 가능.

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | AWS VPC Endpoint ID, Connection Type, Developer Name, Description, Link ID, Master Label, Region, Source IP Ranges |
| Both Can Edit | Status |
| Neither Can Edit | None |

> 고려사항:
> - 패키징된 연결은 unprovisioned로 설치됨. 패키지 설치 후 프로비저닝 방법을 구독자에게 안내 필요.
> - 패키지 개발자가 구독자가 이미 프로비저닝한 연결의 Region을 변경하면 업그레이드 실패. Region 변경 전 구독자에게 연결 해제 안내 필요.
> - 라이선스 요건: Private Connect license.

---

### IndustriesEinsteinFeatureSettings

Industries Einstein 기능 활성화 설정. **2GP만 패키징 가능.**

**Metadata Name:** `IndustriesEinsteinFeatureSettings`

| 속성 | 값 |
|---|---|
| Packageable In | **2GP only** |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All |
| Both Can Edit | None |
| Neither Can Edit | None |

> 관련 기능: Intelligent Document Reader, Intelligent Form Reader.

---

### IntegrationProviderDef

서비스 프로세스에 연결된 통합 정의. Industries: Send Apex Async Request 및 Industries: Send External Async Request invocable action 데이터 저장. **1GP만 패키징 가능.**

**Metadata Name:** `IntegrationProviderDef`
**1GP UI 이름:** IntegrationProviderDef

| 속성 | 값 |
|---|---|
| Packageable In | **1GP only** |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All other fields |
| Both Can Edit | StringValue, IntegerValue, DateTimeValue, DateValue, PercentageValue, DoubleValue, IsTrueOrFalseValue |
| Neither Can Edit | FullName |

---

### Named Credential

외부 엔드포인트 URL과 인증 파라미터를 단일 정의로 통합. callout 설정을 간소화.

**Metadata Name:** `NamedCredential`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes. 2GP만 지원. |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Label, NamedCredentialType, (deprecated) Endpoint |
| Both Can Edit | CalloutOptions (AllowMergeFieldsInBody, AllowMergeFieldsInHeader, GenerateAuthorizationHeader), NamedCredentialParameters (AllowedManagedPackageNamespaces[구독자만], Authentication, ClientCertificate[2GP에서 구독자만], HttpHeader, OutboundNetworkConnection, Url), (deprecated) AuthProvider, AuthTokenEndpointUrl, Certificate, OauthRefreshToken, OauthScope, OutboundNetworkConnectionId, Password, PrincipalType, Protocol, Username |
| Neither Can Edit | FullName |

> 고려사항:
> - 인증서는 패키징 불가. 인증서가 필요하면 구독자 org에 동일 이름의 유효한 인증서를 업로드해야 함.
> - NamedCredential은 ExternalCredential 컴포넌트와 함께 패키징 필수. Named Credential은 callout 엔드포인트와 HTTP 전송 프로토콜을 정의하고, External Credential은 외부 시스템 인증 방식을 나타냄. 각 Named Credential은 최소 하나의 External Credential에 매핑되어야 함.
> - **Legacy Named Credentials는 deprecated.** Winter '23에서 도입된 개선된 named credential 사용 권장.
> - 패키지 설치 후, 구독자는 외부 시스템에 재인증 필요 (Password: 암호 재입력, OAuth: callback URL 업데이트 후 재인증).

---

### Platform Cache (PlatformCachePartition)

Platform Cache 파티션. Org 및 Session 캐시 타입을 지원.

**Metadata Name:** `PlatformCachePartition`
**1GP UI 이름:** Platform Cache Partition

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | No |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Master Label, Description, Default Partition |
| Both Can Edit | Organization Capacity, Trial Capacity |
| Neither Can Edit | Developer Name |

---

### Remote Site Setting

원격 사이트 설정. Apex callout, XHR, Visualforce에서 외부 사이트 호출 전 등록 필요.

**Metadata Name:** `RemoteSiteSettings`

| 속성 | 값 |
|---|---|
| Packageable In | 2GP, 1GP |
| Component Is Updated During Package Upgrade | No |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | Yes. 2GP만 지원. |
| Component Has IP Protection | No |

**Editable Properties After Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Can Edit | All attributes except Remote Site Name |
| Neither Can Edit | Remote Site Name |

---

## PDF에 없거나 2GP 미지원 컴포넌트

아래 컴포넌트는 이 PDF(pkg2_dev.pdf) 내 별도 섹션이 없거나 2GP 미지원으로 확인됨:

| 컴포넌트 | 상태 |
|---|---|
| CallCenter | PDF 내 해당 섹션 없음 |
| EmbeddedServiceFlowConfig | PDF 내 해당 섹션 없음 |
| EmbeddedServiceLiveAgent | PDF 내 해당 섹션 없음 |
| EventDelivery | PDF 내 해당 섹션 없음 (v46.0에서 삭제됨 — Metadata Types 개요에서 확인) |
| EventSubscription | PDF 내 해당 섹션 없음 (v46.0에서 삭제됨) |
| NetworkConnection | PDF 내 별도 섹션 없음 (InboundNetworkConnection/OutboundNetworkConnection으로 분리) |

---

## 코드 예제 — Feature Parameter를 Apex에서 읽는 패턴

```apex
// 구조 예시 — 실제 동작 코드 아님
// Feature Parameter를 Apex FeatureManagement 클래스로 읽기
Boolean isFeatureEnabled = FeatureManagement.checkPermission('My_Feature_Permission');
Integer featureLimit = (Integer) FeatureManagement.checkPackageIntegerValue('FeatureParameterName');
Date featureDate = (Date) FeatureManagement.checkPackageDateValue('FeatureParameterName');
Boolean featureBool = (Boolean) FeatureManagement.checkPackageBooleanValue('FeatureParameterName');

// Subscriber-to-LMO 방향: 구독자 org에서 Apex로 값 업데이트
FeatureManagement.setPackageIntegerValue('FeatureParameterName', 42);
```

---

## 도메인별 요약 비교

| 컴포넌트 | Metadata Name | Packageable In | Updated | Sub Can Delete | Dev Can Remove | IP Protection |
|---|---|---|---|---|---|---|
| App Framework Template Bundle | AppFrameworkTemplateBundle | 2GP, 1GP | Yes | Yes | Yes | No |
| Care Benefit Verify Settings | CareBenefitVerifySettings | 2GP, 1GP | Yes | No | No | No |
| Care System Field Mapping | CareSystemFieldMapping | 2GP, 1GP | Yes | No | No | No |
| Chatter Extension | ChatterExtension | **1GP only** | Yes | No | No | **Yes** |
| Claim Financial Settings | ClaimFinancialSettings | 2GP, 1GP | Yes | No | No | No |
| Context Definition | ContextDefinition | **1GP only** | Yes* | No | No | No |
| Conversation Vendor Info | ConversationVendorInfo | 2GP, 1GP | Yes | No | No | **Yes** |
| Embedded Service Config | EmbeddedServiceConfig | **1GP only** | Yes | No | No | No |
| Event Relay | EventRelayConfig | 2GP, 1GP | Yes | No | Yes | No |
| External Data Source | ExternalDataSource | 2GP, 1GP | Yes | No | No | No |
| External Services | ExternalServiceRegistration | 2GP, 1GP | Yes | Yes† | Yes | No |
| Feature Parameter Boolean | FeatureParameterBoolean | 2GP, 1GP | No‡ | No | No | No |
| Feature Parameter Date | FeatureParameterDate | 2GP, 1GP | No‡ | No | No | No |
| Feature Parameter Integer | FeatureParameterInteger | 2GP, 1GP | No‡ | No | No | No |
| Gateway Provider Payment Method Type | GatewayProviderPaymentMethodType | 2GP, 1GP | Yes | No | No | No |
| Inbound Network Connection | InboundNetworkConnection | 2GP, 1GP | Yes | No | Yes | No |
| Industries Einstein Feature Settings | IndustriesEinsteinFeatureSettings | **2GP only** | Yes | Yes | No | No |
| Integration Provider Def | IntegrationProviderDef | **1GP only** | Yes | No | No | No |
| Named Credential | NamedCredential | 2GP, 1GP | Yes | No | Yes (2GP) | No |
| Platform Cache | PlatformCachePartition | 2GP, 1GP | No | No | No | No |
| Remote Site Setting | RemoteSiteSettings | 2GP, 1GP | No | Yes | Yes (2GP) | No |

> *Context Definition: 활성 컨텍스트 정의가 없는 경우에만 업데이트 가능.
> †External Services: 의존성이 없는 경우에만 삭제 가능.
> ‡Feature Parameters: LMO 또는 구독자 Apex를 통해 패키지 업그레이드 없이 업데이트 가능 (Data Flow Direction에 따라).

---

## 관련 노트

- [[Metadata Types — Integration & Platform]] — Metadata API 관점의 NamedCredential, RemoteSiteSetting, PlatformCachePartition 필드 정의
- [[2GP — Components: Apex & Code]] — Apex Class, LWC, Aura 등 코드 컴포넌트 Manageability Rules
- [[2GP — Components: Automation]] — Flow, Workflow, Decision Table 등 자동화 컴포넌트
- [[2GP — Components: Einstein & Analytics]] — AIApplication, GenAiFunction, BotTemplate 등 AI·Analytics 컴포넌트
- [[2GP Managed Package — Workflow]] — Manageability Rules 4속성·Editable Properties 3카테고리 개념 설명 + 전체 Supported Components 목록
- [[2GP — Components: Objects & Fields]] — AssessmentQuestion·BriefcaseDefinition·CustomObject·CustomField·CustomLabels·GlobalValueSet·Folder·FieldSet 등 오브젝트·필드 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Security & Access]] — AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·ExternalAuthIdentityProvider·ExternalCredential·PermissionSet·PermissionSetGroup 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Feature Management App]] — FeatureParameterBoolean/Date/Integer 상세 운영·XML 예제·System.FeatureManagement API·LMO-Subscriber 연동
