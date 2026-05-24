---
tags: [devops, metadata-api, metadata-types, custom-object, custom-field, record-type, validation-rule, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [CustomObject 메타데이터, CustomField 메타데이터, RecordType 메타데이터, ValidationRule 메타데이터, 오브젝트 필드 메타데이터 타입]
---

# Metadata Types — Objects & Fields

> 커스텀/표준 오브젝트, 필드, 레코드 타입, 유효성 검사 규칙 등 오브젝트 구조 관련 메타데이터 타입 상세 필드 정의.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 | API 버전 |
|---|---|---|
| ArticleType | Knowledge 기사 타입 | - |
| AssessmentQuestion | 평가 질문 컨테이너 | - |
| AssessmentQuestionSet | 평가 질문 세트 | - |
| BriefcaseDefinition | Field Service 오프라인 브리프케이스 정의 | - |
| CareProviderSearchConfig | 케어 공급자 검색 필드 설정 | - |
| CareRequestConfiguration | 케어 요청 구성 (레코드 타입별) | - |
| CareLimitType | 혜택 한도 특성 | - |
| CaseSubjectParticle | 소셜 케이스 제목 형식 | - |
| ClauseCatgConfiguration | 조항 카테고리 구성 | - |
| ContentAsset | Asset 파일 메타데이터 | - |
| Custom Metadata Types | 커스텀 메타데이터 타입 (CustomObject로 접근) | - |
| CustomFieldDisplay | 제품 속성 커스텀 필드 뷰 타입 | - |
| CustomIndex | 쿼리 인덱스 | - |
| CustomLabels | 다국어 커스텀 레이블 | - |
| CustomObject | 커스텀/표준/외부 오브젝트 | v10.0+ |
| CustomObjectTranslation | 커스텀 오브젝트 번역 | - |
| CustomValue | 글로벌 값 세트 / 로컬 피클리스트 값 | - |
| DataCategoryGroup | 데이터 카테고리 그룹 | - |
| DisclosureDefinition | 공개 타입 정보 | - |
| DisclosureDefinitionVersion | 공개 정의 버전 | - |
| DisclosureType | 공개 타입 | - |
| Document | Document 오브젝트 | - |
| DocumentCategory | 문서 카테고리 | - |
| DocumentCategoryDocumentType | DocumentCategory-DocumentType 연결 | - |
| DocumentChecklistSettings | DocumentChecklistItem org 설정 | - |
| DocumentType | 문서 타입 | - |
| FieldMappingConfig | 소스→대상 필드 매핑 설정 | v63.0+ |
| Folder | 폴더 | - |
| GlobalPicklist | 글로벌 피클리스트 | - |
| GlobalPicklistValue | 글로벌 피클리스트 값 | - |
| GlobalValueSet | 글로벌 값 세트 | - |
| GlobalValueSetTranslation | 글로벌 값 세트 번역 | - |
| OnboardingDataObjectGroup | 온보딩 데이터 오브젝트 그룹 | - |
| ParticipantRole | 참가자 역할 | - |
| ProductAttributeSet | 제품 속성 세트 | - |
| RecordAggregationDefinition | 레코드 집계 정의 | - |
| RecordAlertCategory | 레코드 알림 카테고리 | - |
| RelationshipGraphDefinition | 오브젝트 계층 그래프 정의 | - |
| RetrievalSummaryDefinition | 데이터 검색 패턴 설정 | - |
| StandardValueSet | 표준 피클리스트 값 세트 | - |
| StandardValueSetTranslation | 표준 피클리스트 번역 | - |
| TimelineObjectDefinition | Timeline 구성 컨테이너 | - |
| TopicsForObjects | 오브젝트 주제 배정 | - |
| Translations | 다국어 번역 (Translation Workbench) | - |

---

## CustomObject

커스텀/표준/외부 오브젝트를 나타낸다. `Metadata` 타입을 extends.

**주의:** 오브젝트 생성·업데이트 시 관련 모든 필드를 지정해야 한다. 단일 필드만 업데이트 불가.

**fullName 규칙:**
- 커스텀 오브젝트: `MyCustomObject__c`
- 표준 오브젝트: `Account`
- 외부 오브젝트: `MyExternalObject__x`

**파일 경로:** `objects/ObjectName.object`

**주의:** 이 타입 검색 시 Profile 및 PermissionSet 컴포넌트에도 해당 오브젝트가 나타난다.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `actionOverrides` | ActionOverride[] | - | 오브젝트 액션 재정의 목록 (v18.0+) |
| `allowInChatterGroups` | boolean | - | Chatter 그룹에 레코드 추가 허용 여부 (v34.0+) |
| `businessProcesses` | BusinessProcess[] | - | 오브젝트 관련 비즈니스 프로세스 목록 (v17.0+) |
| `compactLayoutAssignment` | string | - | 지정된 콤팩트 레이아웃 (v29.0+) |
| `compactLayouts` | CompactLayout[] | - | 콤팩트 레이아웃 목록 (v29.0+) |
| `customHelp` | string | - | 커스텀 도움말 콘텐츠 s-control (v14.0+) |
| `customHelpPage` | string | - | 커스텀 도움말 Visualforce 페이지 (v16.0+) |
| `customSettingsType` | CustomSettingsType (enum) | - | 커스텀 설정 타입. `List` / `Hierarchy` (v17.0+) |
| `customSettingsVisibility` | CustomSettingsVisibility (enum) | - | 커스텀 설정 가시성 `Public` / `Protected` (v17.0~33.0, v34.0+ `visibility` 필드 사용) |
| `deploymentStatus` | DeploymentStatus (enum) | - | 오브젝트 배포 상태 |
| `deprecated` | boolean | - | Reserved for future use |
| `description` | string | - | 오브젝트 설명 (최대 1000자) |
| `enableActivities` | boolean | - | 활동(Activities) 활성화 여부 (외부 오브젝트 미적용) |
| `enableBulkApi` | boolean | - | Enterprise Application 분류 여부 (v31.0+). `enableSharing`, `enableStreamingApi`도 함께 활성화 필요 |
| `enableDivisions` | boolean | - | Division 활성화 여부 |
| `enableEnhancedLookup` | boolean | - | 고급 조회 활성화 여부. `enableSearch`가 true여야 함 (v28.0+에서 Account/Contact/User도 지원) |
| `enableFeeds` | boolean | - | Feed 추적 활성화 여부 (v18.0+) |
| `enableHistory` | boolean | - | 이력 추적 활성화 여부. 표준 오브젝트는 v29.0+에서 가능 |
| `enableLicensing` | boolean | - | 라이선스 필요 오브젝트 여부 (v45.0+) |
| `enableReports` | boolean | - | 리포트 활성화 여부. 외부 오브젝트는 v38.0+ |
| `enableSearch` | boolean | - | SOSL 및 Salesforce 검색에서 레코드 조회 가능 여부 (v35.0+). 120일 미검색 시 자동 비활성화 가능 |
| `enableSharing` | boolean | - | Enterprise Application 분류 (v31.0+) |
| `enableStreamingApi` | boolean | - | Enterprise Application 분류 (v31.0+) |
| `eventType` | PlatformEventType (enum) | - | 플랫폼 이벤트 타입. `HighVolume` / `StandardVolume`(Deprecated) (v41.0+) |
| `externalDataSource` | string | Required (외부 오브젝트) | 외부 데이터 소스 이름 (v32.0+) |
| `externalName` | string | Required (외부 오브젝트) | 외부 데이터 소스의 테이블 이름 (v32.0+) |
| `externalRepository` | string | - | Salesforce Connect 외부 오브젝트 Display URL 참조 필드 (v32.0+) |
| `externalSharingModel` | SharingModel (enum) | - | 외부 사용자 대상 org-wide 기본값 (v31.0+) |
| `fields` | CustomField[] | - | 오브젝트의 필드 목록 |
| `fieldSets` | FieldSet | - | 오브젝트의 필드 세트 |
| `fullName` | string | - | 오브젝트 이름. Metadata에서 상속. null 불가 |
| `gender` | Gender | - | 언어별 명사 성별 |
| `historyRetentionPolicy` | HistoryRetentionPolicy | - | Reserved for future use |
| `household` | boolean | - | Salesforce for Wealth Management 관계 그룹 지원 |
| `indexes` | Index[] | - | 커스텀 빅 오브젝트 인덱스 |
| `label` | string | - | UI에 표시되는 오브젝트 레이블 (org 내 고유 권장) |
| `listViews` | ListView[] | - | 오브젝트 관련 목록 뷰 |
| `namedFilter` | NamedFilter[] | - | 조회 필터 메타데이터 (v17.0~29.0만. v30.0+는 CustomField의 lookupFilter 사용) |
| `nameField` | CustomField | Required (커스텀 오브젝트) | 이름 필드. 외부 오브젝트는 CustomField의 `isNameField=true`로 대체 가능 |
| `pluralLabel` | string | - | 복수형 레이블 (커스텀 오브젝트 필수, 현지화 지원) |
| `profileSearchLayouts` | ProfileSearchLayouts | - | 프로파일별 검색 결과 레이아웃 (v47.0+) |
| `publishBehavior` | PlatformEventPublishBehavior (enum) | - | 플랫폼 이벤트 발행 시점. `PublishAfterCommit` / `PublishImmediately` (기본값) (v46.0+) |
| `recordTypes` | RecordType[] | - | 오브젝트 레코드 타입 배열 |
| `recordTypeTrackFeedHistory` | boolean | - | 레코드 타입 Feed 추적 여부 (enableFeeds=true 필요, v19.0+) |
| `recordTypeTrackHistory` | boolean | - | 레코드 타입 이력 추적 여부 (enableHistory=true 필요, v19.0+) |
| `searchLayouts` | SearchLayouts | - | 검색 레이아웃 관련 정보 |
| `sharingModel` | SharingModel (enum) | - | org-wide 기본 공유 설정 |
| `sharingReasons` | SharingReason[] | - | 공유 사유 |
| `sharingRecalculations` | SharingRecalculation[] | - | 커스텀 공유 재계산 목록 |
| `startsWith` | StartsWith (enum) | - | 언어별 첫 글자 처리 (모음/자음/특수문자). v29.0 이하는 읽기 전용, v30.0+는 내부 사용자에게 설정 가능 |
| `validationRules` | ValidationRule[] | - | 오브젝트 유효성 검사 규칙 배열 |
| `visibility` | SetupObjectVisibility (enum) | - | 오브젝트/커스텀 설정/커스텀 메타데이터 타입 가시성. `Public` / `Protected` / `PackageProtected`(커스텀 메타데이터 타입만, v47.0+) (v34.0+) |
| `webLinks` | WebLink[] | - | 오브젝트 웹링크 배열 |

---

## CustomLabels

다국어 커스텀 레이블. 다양한 언어, 국가, 통화에 맞게 현지화 가능.

### CustomLabel 서브타입 주요 필드

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `fullName` | string | Required | 레이블 API 이름 |
| `categories` | string | - | 레이블 카테고리 (콤마 구분) |
| `language` | string | Required | 기본 언어 |
| `protected` | boolean | Required | 패키지 보호 여부 |
| `shortDescription` | string | Required | 레이블 설명 |
| `value` | string | Required | 레이블 값 |

---

## GlobalValueSet / GlobalPicklist

글로벌 값 세트(피클리스트): 여러 커스텀 피클리스트 필드가 공유하는 값 집합. `Metadata` 타입을 extends.

### 주요 필드

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `customValue` | CustomValue[] | - | 값 목록 |
| `description` | string | - | 설명 |
| `masterLabel` | string | Required | 마스터 레이블 |
| `sorted` | boolean | Required | 값 정렬 여부 |

---

## StandardValueSet

표준 피클리스트 필드의 값 세트. `Metadata` 타입을 extends.

---

## Translations / CustomObjectTranslation

Translation Workbench를 통한 다국어 번역 메타데이터.

---

## Folder

폴더 메타데이터. `Metadata` 타입을 extends.

---

## ContentAsset

Asset 파일 메타데이터. Salesforce 파일을 org 설정·구성에 사용할 수 있도록 변환. `MetadataWithContent` 타입을 extends.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록
- [[Metadata Types — Automation]] — ValidationRule, WorkflowRule 등 자동화
- [[Metadata Types — Security & Access]] — Profile, PermissionSet
- [[Metadata Types — UI & Layout]] — Layout, FlexiPage
- [[Metadata API CRUD 호출]] — createMetadata()로 CustomObject 생성 예시
- [[2GP — Components: Objects & Fields]] — 동일 오브젝트·필드 컴포넌트의 2GP Managed Package Manageability Rules 전수

---

## Declarative Metadata 예시

### CustomObject XML 예시

```xml
<!-- objects/Project__c.object -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomObject xmlns="http://soap.sforce.com/2006/04/metadata">
    <deploymentStatus>Deployed</deploymentStatus>
    <description>Custom object to track projects</description>
    <enableActivities>true</enableActivities>
    <enableBulkApi>true</enableBulkApi>
    <enableHistory>true</enableHistory>
    <enableReports>true</enableReports>
    <enableSearch>true</enableSearch>
    <enableSharing>true</enableSharing>
    <enableStreamingApi>true</enableStreamingApi>
    <label>Project</label>
    <nameField>
        <label>Project Name</label>
        <type>Text</type>
    </nameField>
    <pluralLabel>Projects</pluralLabel>
    <sharingModel>ReadWrite</sharingModel>
</CustomObject>
```

### CustomLabels XML 예시

```xml
<!-- labels/CustomLabels.labels -->
<?xml version="1.0" encoding="UTF-8"?>
<CustomLabels xmlns="http://soap.sforce.com/2006/04/metadata">
    <labels>
        <fullName>WelcomeMessage</fullName>
        <categories>General</categories>
        <language>en_US</language>
        <protected>true</protected>
        <shortDescription>Welcome message</shortDescription>
        <value>Welcome to our application!</value>
    </labels>
</CustomLabels>
```

### package.xml 에서 CustomObject 검색

```xml
<!-- package.xml -->
<types>
    <members>Project__c</members>
    <name>CustomObject</name>
</types>
```
