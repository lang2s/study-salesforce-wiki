---
tags: [devops, 2gp, managed-package, packaging, components, custom-object, custom-field, metadata-types, objects-fields]
source: pkg2_dev.pdf — Second-Generation Managed Packages, Components Available (p.25–313)
created: 2026-05-23
aliases: [2GP Objects Fields 컴포넌트, 2GP 오브젝트 필드 패키징, AssessmentQuestion 2GP, CustomObject 2GP, CustomField 2GP, GlobalValueSet 2GP, 2GP 오브젝트 메타데이터]
---

# 2GP — Components: Objects & Fields

> 2GP Managed Package에 포함할 수 있는 오브젝트·필드 도메인 컴포넌트의 Manageability Rules 4속성과 Editable Properties 3카테고리 전수.

---

## 개요: Manageability Rules 4속성

각 컴포넌트에는 아래 4가지 규칙이 적용된다. 상세 의미는 [[2GP Managed Package — Workflow]] 참조.

| 속성 | Yes 의미 | No 의미 |
|---|---|---|
| Component Is Updated During Package Upgrade | 패키지 업그레이드 시 컴포넌트 업데이트됨 | 초기 설치 시에만 배포, 이후 업그레이드 미반영 |
| Subscriber Can Delete Component From Org | Subscriber/설치자가 컴포넌트 삭제 가능 | 삭제 불가 |
| Package Developer Can Remove Component From Package | 패키지 개발자가 미래 버전에서 제거 가능 (deprecated → subscriber가 삭제 가능) | 제거 불가 |
| Component Has IP Protection | 소스 코드·레코드 정보 등 숨김 처리 | Subscriber org에서 노출 |

## Editable Properties 3카테고리

- **Only Package Developer Can Edit**: 패키지 개발자만 편집 가능, subscriber org에서 잠김. 업그레이드 시 developer 변경사항 반영.
- **Both Subscriber and Package Developer Can Edit**: 양쪽 모두 편집 가능. Developer 변경사항은 신규 설치에만 적용 (subscriber 수정이 업그레이드로 덮어쓰이지 않음).
- **Neither Subscriber or Package Developer Can Edit**: promote/release 후 잠금. API 이름 등.

---

## AssessmentQuestion

Health Cloud 평가 질문을 저장하는 컨테이너 오브젝트.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (제거 시 subscriber org에 잔존, 관리자가 삭제 가능) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All except DeveloperName |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | DeveloperName |

**More Information**
- Metadata Name: `AssessmentQuestion`
- Documentation: Industries Common Resources Developer Guide: AssessmentQuestion

---

## AssessmentQuestionSet

Health Cloud 평가 질문들의 컨테이너 오브젝트.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (제거 시 subscriber org에 잔존, 관리자가 삭제 가능) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All except DeveloperName |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | DeveloperName |

**More Information**
- Metadata Name: `AssessmentQuestionSet`
- Documentation: Industries Common Resources Developer Guide: AssessmentQuestionSet

---

## BriefcaseDefinition

Salesforce Field Service 모바일 앱(iOS/Android)에서 오프라인 사용자가 볼 레코드를 정의하는 Briefcase 정의.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Entire briefcase |
| Both Package Developer and Subscriber Can Edit | Active |
| Neither Package Developer or Subscriber Can Edit | Full Name |

**More Information**
- Metadata Name: `BriefcaseDefinition`
- Component Type in 1GP Package Manager UI: Briefcase Definition
- Considerations When Packaging: IsActive=false로 패키징 권장. IsActive=true로 패키징 시 한도 초과 오류로 설치 실패 가능.
- Usage Limits: 모든 Briefcase Builder 한도가 패키지에 적용됨.
- Relationship to Other Components: 설치 후 Briefcase를 해당 애플리케이션에 수동으로 할당.
- Documentation: Salesforce Help: Briefcase Builder

---

## CareLimitType

Health Cloud의 혜택 제공 한도 특성을 정의.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | LimitType, MetricType, MasterLabel |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

**More Information**
- Metadata Name: `CareLimitType`
- Component Type in 1GP Package Manager UI: Care Limit Type
- Use Case: Health Cloud에서 혜택 제공 한도 특성 제공.
- License Requirements: Industries Health Cloud Add On 또는 Health Cloud Financial Data Platform license
- Documentation: Health Cloud Developer Guide: CareLimitType

---

## CareRequestConfiguration

Health Cloud에서 서비스 요청·약물 요청·입원 요청 등 레코드 타입별 케어 요청 상세 정보. 하나 이상의 레코드 타입이 케어 요청과 연결 가능.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | MasterLabel, CareRequestType, CareRequestRecordType, CareRequestRecords, IsDefaultRecordType |
| Both Package Developer and Subscriber Can Edit | IsActive |
| Neither Package Developer or Subscriber Can Edit | Name |

**More Information**
- Metadata Name: `CareRequestConfiguration`
- Component Type in 1GP Package Manager UI: Care Request Configuration
- Use Case: Health Cloud에서 서비스 요청·약물 요청·입원 요청 레코드 타입 상세 제공.
- License Requirements: Industries Health Cloud Add On 또는 Health Cloud Utilization Mgmt Platform license
- Relationship to Other Components: CareRequestConfiguration의 Case Record Type으로 지정된 레코드 타입이 subscriber org에 있어야 함. 없으면 패키지에 포함해야 함.
- Documentation: Health Cloud Developer Guide: CareRequestConfiguration

---

## CustomField (Custom Field on Standard or Custom Object)

표준 또는 커스텀 오브젝트의 커스텀 필드 정의. 생성·수정·삭제에 사용.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (2GP, 1GP 모두 지원, 제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Auto-Number Display Format, Decimal Places, Description, Default Value, Field Label, Formula, Length, Lookup Filter, Related List Label, Required, Roll-Up Summary Filter Criteria |
| Both Package Developer and Subscriber Can Edit | Chatter Feed Tracking, Help Text, Mask Type, Mask Character, Sharing Setting, Sort Picklist Values, Track Field History |
| Neither Package Developer or Subscriber Can Edit | Child Relationship Name, Data Type, External ID, Field Name, Roll-Up Summary Field, Roll-Up Summary Object, Roll-Up Summary Type, Unique |

**패키징 고려사항**
- Default Value가 있는 필수(required) 및 유니버설 필수 커스텀 필드만 managed package에 추가 가능.
- Auto-number 타입 필드 및 required 필드는 오브젝트가 Managed - Released 패키지에 포함된 이후 추가 불가.
- Subscriber org는 detail 필드가 protected로 설정된 roll-up summary 필드를 설치할 수 없음.

**More Information**
- Metadata Name: `CustomField` (CustomObject의 하위 타입)
- Component Type in 1GP Package Manager UI: Custom Field

---

## CustomField (Custom Field on Custom Metadata Type)

커스텀 메타데이터 타입의 커스텀 필드.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | No |

---

## CustomIndex

쿼리 속도를 높이기 위한 인덱스. 조회 속도 향상을 위해 사용.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | No |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No (연결된 커스텀 필드가 제거될 때만 제거 가능) |
| Component Has IP Protection | No |

**More Information**
- Metadata Name: `CustomIndex`
- Component Type in 1GP Package Manager UI: Custom Index
- Considerations When Packaging: Subscriber는 Metadata API를 통해서만 커스텀 인덱스 제거 가능.
- Documentation: Best Practices for Deployments with Large Data Volumes: Indexes

---

## CustomLabels (Custom Label)

여러 언어·국가·통화에 맞게 현지화 가능한 커스텀 레이블.

**Packageable In:** 2GP만 지원 (1GP는 미지원)

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (2GP 전용, 제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Category, Short Description, Value |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | Name |

**More Information**
- Metadata Name: `CustomLabels`
- Considerations When Packaging: 번역된 레이블이 있으면 해당 언어를 패키지에 명시적으로 포함해야 번역도 포함됨. Subscriber는 기본 번역을 재정의 가능. Protected 컴포넌트로 마킹 가능.
- Documentation: Metadata API Developer Guide: CustomLabels

---

## CustomMetadata (Custom Metadata Type Records)

커스텀 메타데이터 타입의 레코드.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (1GP는 protected인 경우, 2GP는 protected 여부 무관하게 지원) |
| Component Has IP Protection | Yes |

**패키징 고려사항**
- Deprecated 커스텀 메타데이터 타입 레코드도 subscriber org 한도에 계산됨. Subscriber가 deprecated 레코드를 삭제하도록 권장.
- Subscriber org가 커스텀 메타데이터 타입 레코드 org 한도에 도달하면, 새 레코드가 포함된 패키지 업그레이드 실패.

**More Information**
- Metadata Name: `CustomObject` (커스텀 메타데이터 타입 레코드는 CustomObject로 접근)
- Protected 컴포넌트로 마킹 가능.
- Documentation: Salesforce Help: Package Custom Metadata Types and Records

---

## CustomMetadata (Custom Metadata Type)

커스텀 메타데이터 타입 자체 정의.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | No |
| Component Has IP Protection | Yes |

**More Information**
- 2GP에서 CustomMetadataType은 필드와 레코드를 함께 포함. 버전 promote 후 기존 패키지에 필드 직접 추가 불가.
- 같은 namespace를 공유하는 여러 패키지에서 레이아웃과 레코드를 별도 패키지로 분리 가능. 단 커스텀 메타데이터 타입의 커스텀 필드는 같은 패키지에 있어야 함.
- 기존 패키지에 CustomMetadataType 필드를 추가하려면 extension 패키지를 발행하고 entity relationship field를 생성한 후 매핑. (Add Custom Metadata Type Fields to Existing Packages 참조)
- Protected 컴포넌트로 마킹 가능.

---

## CustomObject

커스텀 오브젝트 (org 고유 데이터 저장) 또는 org 외부 데이터에 매핑되는 외부 오브젝트.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (2GP, 1GP 모두 지원, 제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Label, Plural Label, Record Name, Record Name Display Format, Starts with a Vowel Sound |
| Both Package Developer and Subscriber Can Edit | Allow Activities, Allow Reports, Available for Customer Portal, Context-Sensitive Help Setting, Default Sharing Model, Development Status, Enable Divisions, Enhanced Lookup, Grant Access Using Hierarchy, Search Layouts, Track Field History |
| Neither Package Developer or Subscriber Can Edit | Object Name, Record Name Data Type |

**패키징 고려사항**
- Allow Reports 또는 Allow Activities를 패키지된 커스텀 오브젝트에 활성화하면 subscriber org에서도 활성화됨. Managed - Released 패키지에서 활성화 후에는 개발자와 subscriber 모두 비활성화 불가.
- 표준 버튼 및 링크 재정의(standard button and link overrides)도 패키징 가능.
- 베이스 패키지의 커스텀 오브젝트 이력 정보에 extension 패키지에서 접근하려면 베이스 패키지 소유자와 협력해 베이스 패키지에서 이력 추적을 활성화하고 새 버전을 생성해야 함.
- Protected 컴포넌트로 마킹 가능 (Hide Custom Objects and Custom Permissions 참조).

**More Information**
- Metadata Name: `CustomObject`
- Component Type in 1GP Package Manager UI: Custom Object
- Documentation: Metadata API Developer Guide: CustomObject

---

## CustomPermission

커스텀 기능에 대한 접근 권한을 부여하는 퍼미션.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (2GP 전용, 제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Connected App, Description, Label, Name |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

**More Information**
- Metadata Name: `CustomPermission`
- Component Type in 1GP Package Manager UI: Custom Permission
- Considerations When Packaging: Connected App가 포함된 커스텀 퍼미션 변경 세트 배포 시 해당 Connected App가 대상 org에 미리 설치되어 있어야 함. Protected 컴포넌트로 마킹 가능.
- Documentation: Metadata API Developer Guide: CustomPermission

---

## Document

Document 오브젝트. 모든 문서는 `sampleFolder/TestDocument` 같은 문서 폴더에 있어야 함.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | No |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | Yes (2GP, 1GP 모두 지원) |
| Component Has IP Protection | No |

**More Information**
- Metadata Name: `Document`
- Component Type in 1GP Package Manager UI: Document
- Documentation: Metadata API Developer Guide: Document

---

## FieldMappingConfig

소스 오브젝트와 하나 이상의 대상 오브젝트·필드 간 매핑 설정. API version 63.0 이상에서 사용 가능.

> 주의: 이 컴포넌트는 PDF의 "Supported Components" 목록에는 등재되어 있으나, 별도의 Manageability Rules 섹션이 없음. 대신 sObject 필드 정의로 제공됨.

**Special Access Rules:** Fundraising Access 라이선스와 Fundraising User 시스템 퍼미션이 있어야 사용 가능.

**Supported Calls:** `create()`, `delete()`, `describeSObjects()`, `query()`, `retrieve()`, `update()`, `upsert()`

**Fields**

| Field | Type | Properties | Description |
|---|---|---|---|
| `Description` | textarea | Create, Defaulted on create, Filter, Group, Nillable, Sort, Update | 필드 매핑 설정 설명 |
| `DeveloperName` | string | Create, Filter, Group, Sort, Update | FieldMappingConfig 고유 이름 |
| `Language` | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | FieldMappingConfig 언어 (da/de/en_US/es/es_MX/fi/fr/it/ja/ko/nl_NL/no/pt_BR/ru/sv/th/zh_CN/zh_TW) |
| `MasterLabel` | string | Create, Filter, Group, Sort, Update | FieldMappingConfig 레이블 |
| `NamespacePrefix` | string | Filter, Group, Nillable, Sort | 네임스페이스 프리픽스 (최대 15자) |
| `ProcessType` | picklist | Create, Defaulted on create, Filter, Group, Nillable, Restricted picklist, Sort, Update | 필드 매핑 설정이 지원하는 프로세스 타입. 값: ChangeRequest, GiftEntry, Incident, Problem (기본값: GiftEntry) |
| `SourceObjectId` | picklist | Create, Filter, Group, Restricted picklist, Sort, Update | 매핑의 소스 오브젝트 ID. 값: GiftEntry |

---

## FieldSet (Field Set)

필드 그룹. 사용자 이름·중간 이름·성·직함 등 관련 필드를 하나의 세트로 그룹화.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (2GP, 1GP 모두 지원) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | Description, Label, Available fields |
| Both Package Developer and Subscriber Can Edit | Selected fields (subscriber만 편집 가능) |
| Neither Package Developer or Subscriber Can Edit | Name |

**패키징 고려사항 — 업그레이드 시 병합 동작**

| 패키지 개발자 변경 | 업그레이드 결과 |
|---|---|
| Unavailable → Available for Field Set (또는 In the Field Set) | 수정된 필드가 추가된 열의 끝에 배치됨 |
| 새 필드 추가 | 새 필드가 추가된 열의 끝에 배치됨 |
| Available for Field Set (또는 In the Field Set) → Unavailable | 업그레이드된 필드 세트에서 필드 제거됨 |
| In the Field Set → Available for Field Set (또는 반대) | 변경사항이 업그레이드된 필드 세트에 반영되지 않음 |

- Subscriber에게 필드 세트 변경 사항 알림 없음. 릴리즈 노트나 문서로 공지 필요.
- 설치 후 subscriber는 모든 필드를 추가·제거 가능.

**More Information**
- Metadata Name: `FieldSet`
- Component Type in 1GP Package Manager UI: Field Set
- Documentation: Metadata API Developer Guide: FieldSet

---

## FieldSourceTargetRelationship (Field Source Target Relationship)

Data Model Object(DMO)와 그 필드 간의 관계를 저장. 예: Individual.Id 필드와 ContactPointEmail.PartyId 필드의 1:M 관계.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | CreationType, DeveloperName, MasterLabel, RelationshipCardinality, SourceField, TargetField |
| Both Package Developer and Subscriber Can Edit | LastDataChangeStatusDateTime, LastDataChangeStatusErrorCode, Status |
| Neither Package Developer or Subscriber Can Edit | None |

**More Information**
- Metadata Name: `FieldSrcTrgtRelationship`
- Component Type in 1GP Package Manager UI: Field Source Target Relationship
- License Requirements: Data Cloud가 프로비저닝되어 있어야 함.
- Documentation: Metadata API Developer Guide: FieldSrcTrgtRelationship

---

## Folder

폴더. 5가지 폴더 메타데이터 타입을 패키징 가능.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | No |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | Yes (1GP 전용) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | None |
| Both Package Developer and Subscriber Can Edit | All attributes except Folder Unique Name |
| Neither Package Developer or Subscriber Can Edit | Folder Unique Name |

**패키징 가능한 Folder 메타데이터 타입**
- `DashboardFolder`
- `DocumentFolder`
- `EmailFolder` (Salesforce Classic 이메일 템플릿만)
- `EmailTemplateFolder`
- `ReportFolder`

**패키징 고려사항**
- Personal 폴더 및 Unfiled 폴더에 저장된 문서·리포트 등은 패키지에 추가 불가. 공개 접근 가능한 폴더에 배치 필요.
- 설치 시 publisher의 폴더 이름을 사용해 설치자 org에 새 폴더가 생성됨. 패키지 일부임을 알 수 있는 이름 권장.
- 업그레이드 중 컴포넌트가 포함된 폴더가 subscriber에 의해 삭제된 경우 폴더가 재생성됨. 이전에 삭제된 컴포넌트는 복원 안 됨.
- 폴더에 포함된 컴포넌트 이름은 동일 타입의 모든 폴더(개인 폴더 제외)에서 고유해야 함.

**More Information**
- Metadata Name: `Folder` (Metadata API Developer Guide: Folder)

---

## GlobalPicklist (Global Picklist / Global Value Set)

여러 커스텀 피클리스트 필드가 공유하는 글로벌 피클리스트 값 세트. Global Value Set 자체는 필드가 아님. 이를 기반으로 하는 커스텀 피클리스트 필드는 ValueSet 타입.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | Yes |
| Package Developer Can Remove Component From Package | Yes (1GP 전용) |
| Component Has IP Protection | No |

**패키징 고려사항**
- 코드에서 피클리스트 값을 명시적으로 참조할 때 주의: 값은 subscriber가 이름 변경·추가·편집·삭제 가능.
- 커스텀 필드 피클리스트 값은 개발자 org에서 추가·삭제 가능. 단 표준 피클리스트 변경은 패키징·배포 불가, 개발자가 삭제한 값도 subscriber org에서 여전히 사용 가능.
- Unlocked package에서는 피클리스트 값 업데이트 미지원. Subscriber org에서 수동으로 추가·수정 필요.
- 패키지 업그레이드 시 dependent 피클리스트 값은 managed 커스텀 필드에 저장된 경우 유지됨.
- Global Value Set의 패키지 업그레이드 동작:
  - 필드 값의 Label·API 이름은 subscriber org에서 변경 안 됨.
  - 새 필드 값은 subscriber org에 추가 안 됨.
  - Subscriber org의 활성/비활성 설정은 변경 안 됨.
  - Subscriber org의 기본값 변경 안 됨.
  - Global Value Set 레이블 이름은 패키지 업그레이드에 레이블 이름 변경이 포함된 경우 변경됨.

**More Information**
- Metadata Name: `Global Value Set`
- Component Type in 1GP Package Manager UI: Global Value Set
- Documentation: Salesforce Help: Create a Global Picklist Value Set / Make Your Custom Picklist Field Values Global

---

## GlobalValueSet

GlobalPicklist와 동일한 컴포넌트. Metadata API에서 `GlobalValueSet` 타입으로 접근.

> GlobalPicklist와 GlobalValueSet은 동일한 컴포넌트를 나타냄. Manageability Rules는 Global Picklist 섹션 참조.

---

## RelationshipGraphDefinition

조직의 오브젝트 계층과 레코드 상세를 순회할 그래프를 구성하는 정의.

**Packageable In:** 2GP, 1GP

| Manageability Rule | 값 |
|---|---|
| Component Is Updated During Package Upgrade | Yes |
| Subscriber Can Delete Component From Org | No |
| Package Developer Can Remove Component From Package | Yes (제거 시 subscriber org에 잔존) |
| Component Has IP Protection | No |

**Editable Properties After Package Promotion or Installation**

| 카테고리 | 속성 |
|---|---|
| Only Package Developer Can Edit | All properties |
| Both Package Developer and Subscriber Can Edit | None |
| Neither Package Developer or Subscriber Can Edit | None |

**More Information**
- Metadata Name: `RelationshipGraphDefinition`
- Component Type in 1GP Package Manager UI: RelationshipGraphDefinition
- Documentation: Metadata API Developer Guide: RelationshipGraphDefinition

---

## PDF에서 목록에는 있으나 세부 섹션 미존재 컴포넌트

아래 컴포넌트들은 PDF의 "Supported Components" 목록(p.25-43)에 등재되어 있으나, 별도의 Manageability Rules 상세 섹션이 PDF에 없음. Metadata Types — Objects & Fields 노트에서 필드 정의 확인 가능.

| 컴포넌트 | Metadata Name | 비고 |
|---|---|---|
| ContentAsset | `ContentAsset` | Asset 파일 메타데이터. 목록 등재만 |
| DataCategoryGroup | `DataCategoryGroup` | 데이터 카테고리 그룹. 목록 등재만 |
| CustomSetting | `CustomObject` (CustomSettingsType 속성) | CustomObject 하위 타입으로 패키징 |
| ParticipantRole | `ParticipantRole` | 참가자 역할. 목록 등재만 |
| RecordAggregationDefinition | `RecordAggregationDefinition` | 레코드 집계 정의. 목록 등재만 |
| RecordAlertCategory | `RecordAlertCategory` | 레코드 알림 카테고리. 목록 등재만 |
| StandardValueSet | `StandardValueSet` | 표준 피클리스트 값 세트. Seed metadata로 활용 가능 |

---

## 코드 예시 — CustomObject XML 패키징

```xml
<!-- // 구조 예시 — Salesforce pkg2_dev.pdf + Metadata API 공식 XML 형식 기반 -->
<!-- objects/MyCustomObject__c.object (2GP 패키지 내 커스텀 오브젝트 예시) -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <description>Custom object for 2GP managed package</description>
    <enableActivities>true</enableActivities>
    <enableBulkApi>true</enableBulkApi>
    <enableHistory>true</enableHistory>
    <enableReports>true</enableReports>
    <enableSearch>true</enableSearch>
    <enableSharing>true</enableSharing>
    <enableStreamingApi>true</enableStreamingApi>
    <label>My Custom Object</label>
    <nameField>
        <label>My Custom Object Name</label>
        <type>Text</type>
    </nameField>
    <pluralLabel>My Custom Objects</pluralLabel>
    <sharingModel>ReadWrite</sharingModel>
    <fields>
        <fullName>Status__c</fullName>
        <label>Status</label>
        <type>Picklist</type>
        <valueSet>
            <!-- GlobalValueSet 참조 시 -->
            <valueSetName>MyGlobalValueSet</valueSetName>
        </valueSet>
    </fields>
</CustomObject>
```

```xml
<!-- // 구조 예시 — sfdx-project.json 패키지 디렉토리 (CustomIndex, FieldSet 포함) -->
{
    "packageDirectories": [
        {
            "path": "force-app",
            "default": true,
            "package": "My Managed Package",
            "versionName": "ver 1.0",
            "versionNumber": "1.0.0.NEXT"
        }
    ],
    "namespace": "mypkg",
    "sfdcLoginUrl": "https://login.salesforce.com",
    "sourceApiVersion": "63.0",
    "packageAliases": {
        "My Managed Package": "0Hoxxx"
    }
}
```

---

## 컴포넌트별 Manageability Rules 요약표

| 컴포넌트 | Metadata Name | Packageable In | Updated on Upgrade | Subscriber Can Delete | Dev Can Remove | IP Protection |
|---|---|---|---|---|---|---|
| AssessmentQuestion | AssessmentQuestion | 2GP, 1GP | Yes | No | Yes | No |
| AssessmentQuestionSet | AssessmentQuestionSet | 2GP, 1GP | Yes | No | Yes | No |
| BriefcaseDefinition | BriefcaseDefinition | 2GP, 1GP | Yes | No | No | No |
| CareLimitType | CareLimitType | 2GP, 1GP | Yes | No | No | No |
| CareRequestConfiguration | CareRequestConfiguration | 2GP, 1GP | Yes | No | No | No |
| Custom Field (Standard/Custom Obj) | CustomField | 2GP, 1GP | Yes | No | Yes (2GP+1GP) | No |
| Custom Field (Custom Metadata Type) | CustomField | 2GP, 1GP | Yes | No | No | No |
| CustomIndex | CustomIndex | 2GP, 1GP | No | No | No | No |
| CustomLabels | CustomLabels | 2GP만 | Yes | No | Yes (2GP만) | No |
| Custom Metadata Type Records | CustomObject | 2GP, 1GP | Yes | No | Yes (1GP: protected만, 2GP: 무관) | Yes |
| Custom Metadata Type | CustomObject | 2GP, 1GP | Yes | No | No | Yes |
| CustomObject | CustomObject | 2GP, 1GP | Yes | No | Yes (2GP+1GP) | No |
| CustomPermission | CustomPermission | 2GP, 1GP | Yes | No | Yes (2GP만) | No |
| Document | Document | 2GP, 1GP | No | Yes | Yes (2GP+1GP) | No |
| FieldMappingConfig | FieldMappingConfig | 목록만 | - | - | - | - |
| FieldSet | FieldSet | 2GP, 1GP | Yes | No | Yes (2GP+1GP) | No |
| FieldSourceTargetRelationship | FieldSrcTrgtRelationship | 2GP, 1GP | Yes | No | Yes | No |
| Folder | Folder | 2GP, 1GP | No | Yes | Yes (1GP만) | No |
| GlobalPicklist / GlobalValueSet | Global Value Set | 2GP, 1GP | Yes | Yes | Yes (1GP만) | No |
| RelationshipGraphDefinition | RelationshipGraphDefinition | 2GP, 1GP | Yes | No | Yes | No |

---

## 관련 노트

- [[Metadata Types — Objects & Fields]] — Metadata API 관점 오브젝트·필드 타입 상세 필드 정의
- [[2GP Managed Package — Workflow]] — Manageability Rules 4속성·Editable Properties 3카테고리 개요 + CLI 워크플로
- [[2GP — Components: Apex & Code]] — Apex Class·Trigger·LWC·Aura·Static Resource·Visualforce 도메인
- [[2GP — Components: Automation]] — Flow·Workflow·Decision Table·Expression Set·Batch 도메인
- [[2GP — Components: Einstein & Analytics]] — AI·CRM Analytics·Agentforce·GenAi 도메인
- [[2GP — Components: Integration & Platform]] — Named Credential·Feature Parameter·External Services·Platform Cache 도메인
- [[2GP — Components: Security & Access]] — AccountRelationshipShareRule·ConnectedApp·CorsWhitelistOrigin·ExternalAuthIdentityProvider·ExternalCredential·PermissionSet·PermissionSetGroup 등 보안·접근 제어 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: UI & Layout]] — ActionLinkGroupTemplate·BrandingSet·CommunityTemplateDefinition·CommunityThemeDefinition·CustomApplication·CustomTab·DigitalExperienceBundle·FlexiPage·LightningMessageChannel·LightningBolt·LightningTypeBundle·ManagedContentType·PathAssistant·QuickAction·Layout·Prompt 등 UI 레이아웃 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
- [[2GP — Components: Other]] — FuelType·EmailTemplate·Letterhead·Translation·ServiceCatalog·SlackApp·WebStoreTemplate·SustainabilityUom 등 기타 도메인 컴포넌트 Manageability Rules 전수 (형제 시리즈)
