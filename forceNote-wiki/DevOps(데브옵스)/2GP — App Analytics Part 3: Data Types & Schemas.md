---
tags: [2GP, AppExchange, AppAnalytics, PackageUsageLogs, PackageUsageSummaries, SubscriberSnapshots, Schema, ISV, DevOps]
source: Salesforce Documents/pkg2_dev.pdf
created: 2026-05-24
aliases: [Package Usage Logs Schema, Package Usage Summaries Schema, Subscriber Snapshots Schema, App Analytics 스키마, log_record_type, custom_entity_type, Test Custom Integrations, Simulation Mode]
---

# 2GP — App Analytics Part 3: Data Types & Schemas

> Package Usage Summaries(월별 집계), Package Usage Logs(일별 상세), Subscriber Snapshots(일별 스냅샷) 세 가지 데이터 타입의 스키마와 분석 방법을 다룬다.

---

## Package Usage Summaries

패키지 사용량 요약은 달력 월별로 고수준 메트릭을 제공한다. 패키지에 접근하는 사용자 수와 수행하는 작업을 파악한다.

**Note:** AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다.

AppExchange App Analytics는 UI, API 기반, Lightning 기반, Apex 작업을 추적하며 패키지의 컴포넌트 및 커스텀 오브젝트에 대한 각 CRUD 작업을 로그한다. 샌드박스, 스크래치 및 트라이얼 org의 이벤트는 패키지 사용량 요약에서 추적되지 않는다.

파트너와 구독자 모두 패키지 사용량 데이터에 접근할 수 있다. 사용량 요약은 다음 달 초에 사용 가능해진다. 예를 들어, 5월의 사용량 요약은 6월 초에 얻을 수 있다.

- AppExchange 파트너는 License Management Org(LMO)에서 SOAP API `AppAnalyticsQueryRequest`를 사용해 월별 사용량 요약을 요청할 수 있다.
- 구독자는 Setup에서 보안 심사를 통과한 설치된 패키지에 대한 사용량 요약을 다운로드할 수 있다.

### Package Usage Summary Schema

패키지 사용량 요약에는 관련 package usage logs에서 파생된 집계 데이터가 포함된다. ISV 파트너는 기본으로 패키지 사용량 요약에 접근할 수 있으며, 패키지 사용량 로그 및 구독자 스냅샷에 대한 접근을 활성화할 수 있다. 구독자는 패키지 사용량 요약에만 접근할 수 있다.

| Field | Description |
|---|---|
| `custom_entity` | 컴포넌트 또는 커스텀 오브젝트의 개발자 명칭 |
| `custom_entity_type` | 사용자가 조회하거나 조작한 컴포넌트 또는 커스텀 오브젝트 타입. 예: `AnalyticsDashboard`, `AnalyticsLens`, `ApexClass`, `ApexTrigger`, `CustomInteractionLabel`, `CustomInteractionFailure`, `CustomObject`, `ExternalObject`, `LightningPage`, `LightningComponent`, `VisualforcePage` |
| `managed_package_namespace` | 패키지의 네임스페이스 |
| `month` | 이 사용량 요약이 적용되는 월 (YYYY-MM 형식). 예: `2019-03` |
| `num_creates` | 패키지에서 생성된 새 레코드 수 |
| `num_deletes` | 패키지와 연관된 삭제된 레코드 수 |
| `num_events` | `custom_entity`와 연관된 로그 레코드 수 |
| `num_reads` | `custom_entity`와 연관된 읽은 레코드의 집계 수. **참고:** `num_reads` 정의는 Spring '23 릴리즈에서 변경됨. 2023년 2월 및 2023년 1월 이전의 모든 데이터는 이전 `num_reads` 정의 사용: 읽은 레코드 수 + SOSL 및 SOQL 쿼리 수 |
| `num_updates` | 패키지와 연관된 업데이트된 레코드 수 |
| `num_views` | 컴포넌트 또는 페이지가 조회된 횟수 |
| `organization_edition` | 구독자 org가 사용하는 Salesforce 에디션. 예: `Developer Edition`, `Enterprise Edition`, `Unlimited Edition` |
| `organization_id` | 구독자 org의 15자리 ID |
| `organization_name` | 구독자 org의 이름. 예: `Acme, Inc.` |
| `organization_status` | 구독자 org의 유료 상태. 예: `Active`, `Demo`, `Free`, `Trial` |
| `package_id` | 패키지의 ID |
| `user_id_token` | 패키지에 접근한 사용자의 ID를 나타내는 해시된 토큰. 사용자 세부 정보가 변경되어도 ID는 유지되며, 토큰은 사용자가 상호작용하는 모든 패키지에 걸쳐 유지됨. 사용자 ID 토큰은 접두사 005-로 시작. 개인정보 보호 규정에 따라 실제 사용자 ID에 접근 불가 |
| `user_type` | UI 또는 API를 통해 Salesforce 서비스에 접근하는 사용자의 라이선스 카테고리. 예: `Guest`, `Partner`, `Standard` |

---

## Package Usage Logs

패키지 사용량 로그를 기반으로 채택 및 사용자 행동을 분석하고 정보에 입각한 기능 개발 결정을 내린다. AppExchange App Analytics는 UI, API 기반, Lightning 기반, Apex 작업을 추적하며 패키지의 컴포넌트 및 커스텀 오브젝트에 대한 각 CRUD 작업을 로그한다. 샌드박스 및 트라이얼 org의 이벤트는 패키지 사용량 로그에서 추적된다. 스크래치 org의 이벤트는 추적되지 않는다.

**Note:** AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다. Government Cloud 및 Government Cloud Plus org의 사용량 데이터는 App Analytics에서 사용 불가.

### How to Read App Analytics Package Usage Log Data

App Analytics 패키지 사용량 로그는 구독자가 관리 패키지와 어떻게 상호작용하는지에 대한 데이터를 포함한다. 관리 패키지는 패키지된 컴포넌트를 포함하며, 각 패키지 사용량 로그 라인은 사용자가 패키지된 컴포넌트 중 하나와 상호작용한 것을 설명한다.

상호작용을 이해하려면 각 로그 라인(또는 레코드)을 분석하고 다음에 집중한다:
- 어떤 패키지된 컴포넌트에 접근했는지
- 어떤 패키지된 컴포넌트와 상호작용했는지
- 패키지된 컴포넌트 상호작용이 어떻게 발생했는지
- 마지막으로 특정 상호작용 데이터를 분석한다

### Determine What Packaged Component Was Accessed

App Analytics 패키지 사용량 로그에서 각 패키지된 컴포넌트의 이름은 `custom_entity` 필드로 표현되며, 해당 타입은 `custom_entity_type` 필드로 표현된다. 관리 패키지는 여러 패키지된 컴포넌트를 포함할 수 있다.

각 패키지된 컴포넌트를 고유하게 식별하려면 다음 필드들을 결합한다:
- `package_id`
- `package_version_id`
- `managed_package_namespace`
- `custom_entity`
- `custom_entity_type`

### Identify Who Interacted with Your Packaged Component

`organization_id`로 구독자 org를 식별한다. 일부 표준 필드는 항상 채워지며 구독자 org에 대한 정보를 제공한다. 일부 supplemental 필드는 채워질 때 추가 세부 정보를 제공한다.

**구독자 org 필드:**

| Standard Fields | Supplemental Fields |
|---|---|
| `organization_name` | `organization_country_code` |
| `organization_status` | `organization_language_locale` |
| `organization_edition` | `organization_time_zone` |
| `organization_type` | `organization_instance` |
|  | `cloned_from_organization_id` |

`user_id_token`을 사용해 상호작용과 연관된 사용자를 식별하고 설명한다. 이 해시된 토큰은 패키지에 접근한 사용자의 ID를 나타낸다. ID는 사용자 세부 정보가 변경되어도 유지되며, 사용자가 상호작용하는 모든 패키지에 걸쳐 유지된다.

**사용자 supplemental 필드:** `user_type`, `user_agent`, `user_country_code`, `user_time_zone`, `session_key`, `login_key`

**주의:** `user_id_token`은 많은 다양한 사용량 상황을 나타낼 수 있으므로 App Analytics를 고객 라이선스 사용량 감사에 사용하지 않는다.

### Identify How a User Interacted with Your Packaged Component

`log_record_type`으로 사용자가 패키지된 컴포넌트와 어떻게 상호작용했는지 식별한다. 각 상호작용과 연관된 다른 공통 필드: `request_id`, `timestamp_derived`

---

## Package Usage Logs Schema (전수 필드)

패키지 사용량 로그 데이터를 기반으로 정보에 입각한 개발 결정을 내린다. 패키지 사용량 로그는 12:00 AM과 11:59 PM UTC 사이, 24시간 기간 동안의 활동을 나열한다.

| Field | Description |
|---|---|
| `api_type` | API 요청의 타입. 예: `BULK_API`, `E: SOAP Enterprise`, `P: SOAP Partner`, `REST` |
| `api_version` | 사용된 API 버전. 예: `45.0` |
| `app_name` | 사용자가 접근한 Lightning 애플리케이션 이름. 예: `one:one`, `FieldServiceApp`, `Chatter` |
| `bulk_batch_id` | Bulk API 작업의 배치 ID |
| `bulk_job_id` | Bulk API 작업의 ID |
| `bulk_operation` | Bulk API 작업의 작업. 예: `delete`, `hardDelete`, `insert`, `query`, `queryAll`, `update`, `upsert` |
| `class_name` | Apex 클래스 이름. 예: `Help_HomeController`, `ROAppController_v2`, `FSL` |
| `cloned_from_organization_id` | 이 구독자 org가 클론된 org의 ID (샌드박스 org에만 적용). 예: `00Dxx0000000000` |
| `custom_entity` | 컴포넌트 또는 커스텀 오브젝트의 개발자 명칭 |
| `custom_entity_type` | 사용자가 조회하거나 조작한 컴포넌트 또는 커스텀 오브젝트 타입. 예: `AnalyticsDashboard`, `AnalyticsLens`, `AnalyticsRecipe`, `ApexClass`, `ApexTrigger`, `CustomInteractionFailure`, `CustomInteractionLabel`, `CustomObject`, `ExternalObject`, `LightningComponent`, `LightningPage`, `VisualforcePage` |
| `entry_point` | 실행된 Apex 이벤트의 진입점. 예: `GeneralCloner.cloneAndInsertRecords`, `VF- /apex/CloneUser` |
| `event` | 플랫폼 이벤트의 이름 또는 ID. 예: `/event/011xx0000005akx`, `SomeCustomEvent` |
| `event_count` | 구독자가 소비한 플랫폼 이벤트 수. 예: `2` |
| `event_subscriber` | 플랫폼 이벤트 구독자의 ID. 예: `01qxx0000004Coy` |
| `http_method` | HTTP 요청 메서드 타입. 예: `GET` |
| `http_status_code` | HTTP 응답 상태 코드. 예: `404` |
| `interaction_id_token` | 커스텀 인터랙션 로그 시 제공된 상호작용 ID를 나타내는 해시된 토큰. 개인정보 보호 규정에 따라 Salesforce는 실제 사용자 상호작용 ID를 저장 불가 |
| `line_number` | Apex 파일의 라인 번호 |
| `login_key` | 특정 사용자 로그인 세션의 모든 이벤트를 묶는 해시된 문자열. 세션은 로그인 이벤트로 시작하고 로그아웃 이벤트 또는 세션 만료로 종료. 동일한 로그인 키가 있는 모든 로그 라인은 동일한 사용자 로그인 세션 중에 발생 |
| `log_record_type` | 로그 레코드 타입. 예: `AnalyticsAssetView`, `AnalyticsAssetRun`, `API`, `ApexExecution`, `ApexRestApi`, `ApexSoap`, `ApexUnexpectedException`, `BulkApiV1`, `BulkApiV2`, `CronJob`, `CustomInteraction`, `LightningInteraction`, `LightningPageView`, `PlatformEventConsumer`, `QueuedExec`, `RestApi`, `UnassociatedCRUD`, `URI`, `VFRemoting`, `VisualforceRequest` |
| `managed_package_namespace` | 패키지의 네임스페이스 |
| `method_name` | Apex 메서드 이름. 예: `getUserAccessLevelBean`, `getCurrentDocumentsRates`, `getAdditionalHelpTemplate` |
| `num_fields` | 이 트랜잭션에서 사용자가 접근한 필드 수 |
| `num_soql_queries` | 실행된 Apex 이벤트 중 완료된 SOQL 쿼리 수 |
| `operation_count` | `operation_type`에 따라 정의가 다름. INSERT, READ, UPDATE, DELETE인 경우: `custom_entity`에 영향을 받은 레코드 수. SOQL_QUERY인 경우: `custom_entity`와 연관된 SOQL 쿼리 수. SOSL_QUERY인 경우: `custom_entity`와 연관된 SOSL 쿼리 수 |
| `operation_type` | 수행된 작업. 예: `INSERT`, `READ`, `UPDATE`, `DELETE`, `SOQL_QUERY`, `SOSL_QUERY` |
| `organization_country_code` | 구독자 org의 국가 코드 (가입 시 주소 기반 ISO-3166 2자리). 예: `US`, `CA`, `FR` |
| `organization_edition` | 구독자 org가 사용하는 Salesforce 에디션. 예: `Developer Edition`, `Enterprise Edition`, `Unlimited Edition` |
| `organization_id` | 구독자 org의 15자리 ID |
| `organization_instance` | 구독자 org 인스턴스 이름. 예: `AP2`, `EU7`, `NA44` |
| `organization_language_locale` | 구독자 org의 언어 및 로케일 ISO-639 코드 (2~5자리). 예: `de-DE`, `en-US`, `fr-CA` |
| `organization_name` | 구독자 org 이름. 예: `Acme, Inc.` |
| `organization_status` | 구독자 org의 유료 상태. 예: `Active`, `Demo`, `Free`, `Trial` |
| `organization_time_zone` | 구독자 org의 기본 시간대. 예: `America/New_York`, `America/Los_Angeles`, `Europe/Paris` |
| `organization_type` | 구독자 org 환경 타입. 예: `Production`, `Sandbox` |
| `package_id` | 패키지 ID |
| `package_version_id` | 패키지 버전 ID |
| `page_app_name` | App Launcher에서 사용자가 접근한 Lightning 애플리케이션의 내부 이름. 예: `LightningSales`, `Chatter` |
| `page_context` | 이벤트가 발생한 Lightning 페이지의 컨텍스트. 예: `clients:cardContainer` |
| `page_entity_type` | 이벤트의 Lightning 엔티티 타입. 예: `Contact`, `Task` |
| `page_url` | 사용자가 접근한 최상위 Lightning Experience 또는 Salesforce 모바일 앱 페이지의 상대 URL. 예: `/sObject/0064100000JXITSAS/view` |
| `parent_ui_element` | 이벤트가 발생한 Lightning 페이지 요소의 부모 범위. 예: `ChatterFeed` |
| `prevpage_url` | 사용자가 이전에 열었던 Lightning Experience 또는 Salesforce 모바일 앱 페이지의 상대 URL. 예: `/sObject/0064100000` |
| `quiddity` | 실행된 Apex 이벤트와 연관된 외부 실행 타입. 예: `A`: QueryLocator Batch Apex, `B`: Bulk API and Bulk API 2.0, `BA`: Batch Apex, `C`: Scheduled Apex, `E`: Inbound Email Service, `F`: Future, `H`: Apex REST, `I`: Invocable Action, `K`: Quick Action, `L`: Lightning, `M`: Remote Action, `Q`: Queueable, `R`: Synchronous Uncategorized, `S`: Serial Batch Apex, `TA`: Tests Async, `TD`: Tests Deployment, `TS`: Tests Synchronous, `V`: Visualforce, `W`: SOAP Webservices, `X`: Execute Anonymous |
| `referrer_uri` | HTTP 요청의 참조 URI. URI는 다음과 같이 수정됨: 쿼리 문자열 제거, 사용자 ID는 해시된 토큰으로 표시, VisualForce 페이지와 같은 구독자가 생성한 URI는 제거 |
| `related_list` | 해당 레코드와 관련된 항목을 나열하는 레코드의 섹션 또는 기타 세부 페이지. 예: `Open Activities`, `Stage History` |
| `request_id` | 브라우저가 서버에 보낸 HTTP 요청의 ID. 같은 요청 ID를 가진 여러 로그 라인은 동일한 사용자 상호작용의 일부로 발생 |
| `request_size` | callout 요청 본문의 바이트 크기 |
| `request_status` | 패키지의 컴포넌트 또는 커스텀 오브젝트에 접근하는 페이지나 액션에 대한 HTTP 요청 상태. 예: `A` = Auth Error, `F` = Failure, `N` = 404 error, `R` = Redirect, `S` = Success, `U` = Undefined |
| `response_size` | callout 응답 바이트 크기 |
| `rows_processed` | 요청에서 처리된 행 수 |
| `session_key` | 패키지의 컴포넌트 또는 커스텀 오브젝트에 접근하기 위한 HTTP 요청의 HTTP 세션 ID. 세션 ID는 해시됨 |
| `stack_trace` | Apex 예외와 연관된 스택 트레이스 |
| `target_ui_element` | 이벤트가 발생한 Lightning 대상 페이지 요소. 예: `label body truncate`, `tabitem-link` |
| `timestamp_derived` | ISO8601 호환 형식의 패키지 컴포넌트 또는 커스텀 오브젝트 접근 시간 (YYYY-MM-DDTHH:MM:SS.sssZ). 예: `2018-07-27T11:32:59.555Z` |
| `ui_event_sequence_num` | 세션 시작 이후 현재 Lightning 이벤트의 자동 증분 시퀀스 번호 |
| `ui_event_source` | Lightning 레코드 또는 레코드들에 대한 사용자 액션. 예: `click`, `create`, `delete`, `hover`, `read`, `update` |
| `ui_event_type` | Lightning 이벤트 타입. 예: `crud`, `system`, `user` |
| `url` | 패키지의 컴포넌트 또는 커스텀 오브젝트에 접근하는 요청의 수정된 URL. URL은 다음과 같이 수정됨: 쿼리 문자열 제거, 사용자 ID는 해시된 토큰으로 표시, VisualForce 페이지와 같은 구독자가 생성한 URI는 제거. Lightning 기반 URL의 경우 `/aura`만 표시. VisualForce 기반 URL의 경우 관리 패키지 소유 페이지가 아닌 경우 `/apex` 또는 `/apexrest`가 표시 |
| `user_agent` | 요청에 사용된 디바이스의 브라우저 및 운영 체제. 예: `Mozilla/5.0 (iPhone; CPU iPhone // 12_0 like Mac OS X) AppleWebKit/605.1.15` |
| `user_country_code` | 사용자의 기본 ISO-3166 2자리 국가 코드. 예: `CA`, `FR`, `US` |
| `user_id_token` | 패키지에 접근한 사용자의 ID를 나타내는 해시된 토큰. ID는 사용자 세부 정보 변경 후에도 유지되며 모든 패키지에 걸쳐 유지. 사용자 ID 토큰은 접두사 005-로 시작. 개인정보 보호 규정에 따라 실제 사용자 ID 접근 불가 |
| `user_time_zone` | 사용자의 기본 시간대. 예: `America/New_York` |
| `user_type` | UI 또는 API를 통해 Salesforce 서비스에 접근하는 사용자의 라이선스 카테고리. 예: `Guest`, `Partner`, `Standard` |

### Custom Object and External Object Interactions

`custom_entity_type`이 `CustomObject` 또는 `ExternalObject`인 로그 레코드는 사용자가 오브젝트에 대한 create, read, update, delete (CRUD) 상호작용을 수행한 것을 의미한다.

CRUD 양과 유형을 확인하려면 `operation_type`과 `operation_count`에 집중한다.

#### CRUD from Apex REST API Requests

`log_record_type`이 `ApexRestApi`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `url`, `api_version`, `http_method`, `http_status_code` | `request_status`, `referrer_uri`, `api_type`, `rows_processed`, `request_size`, `response_size`, `num_fields` |

#### CRUD from Apex SOAP API Requests

`log_record_type`이 `ApexSoap`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `api_version`, `class_name`, `method_name` | `url`, `request_status`, `referrer_uri` |

#### CRUD from REST API Requests

`log_record_type`이 `RestApi`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `url`, `api_version`, `http_method`, `http_status_code` | `request_status`, `referrer_uri`, `api_type`, `rows_processed`, `request_size`, `response_size`, `num_fields` |

#### CRUD from SOAP API Requests

`log_record_type`이 `API`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `api_type`, `api_version`, `request_size`, `response_size`, `method_name` | `url`, `request_status`, `referrer_uri`, `rows_processed`, `num_fields` |

#### CRUD from Bulk API Requests

`log_record_type`이 `BulkApiV1` 또는 `BulkApiV2`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `api_version`, `bulk_job_id`, `bulk_batch_id`, `bulk_operation` | `api_type`, `rows_processed` |

#### CRUD from Scheduled Job Executions

`log_record_type`이 `CronJob`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | none |

#### CRUD from Platform Events

`log_record_type`이 `PlatformEventConsumer`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | `event`, `event_subscriber`, `event_count` |

#### CRUD from Queueable Apex Executions

`log_record_type`이 `QueuedExec`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | none |

#### CRUD from Standard User Interface Requests

`log_record_type`이 `URI`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `url` | `request_status`, `referrer_uri` |

#### CRUD from Visualforce Remoting Requests

`log_record_type`이 `VFRemoting`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `class_name`, `method_name` | `url`, `request_status`, `referrer_uri`, `request_size`, `response_size` |

#### CRUD from Visualforce Requests

`log_record_type`이 `VisualforceRequest`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `url` | `request_status`, `referrer_uri`, `request_size`, `response_size` |

#### CRUD from All Other User Actions

`log_record_type`이 `UnassociatedCRUD`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | none |

`UnassociatedCRUD`의 `log_record_type` 값은 알 수 없는 로그 레코드 타입과 연관되거나 App Analytics가 캡처하지 않는 커스텀 오브젝트에 대한 create, read, update, delete (CRUD) 이벤트가 발생할 때 할당된다.

### Lightning Interactions

`custom_entity_type`이 `LightningComponent` 또는 `LightningPage`인 로그 레코드는 패키지된 Lightning 컴포넌트 또는 페이지와의 상호작용을 나타낸다.

**Note:** Lightning 상호작용 데이터는 이벤트 기반으로 캡처된다. 어떤 상호작용을 캡처할지 결정하려면 App Analytics 패키지 usage log에 패키지된 컴포넌트를 비교한다.

#### Lightning User Interaction

`log_record_type`이 `LightningInteraction`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `app_name`, `ui_event_source`, `ui_event_type`, `target_ui_element`, `parent_ui_element` | `page_app_name`, `page_context`, `related_list`, `page_url` |

#### Lightning Page View

`log_record_type`이 `LightningPageView`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `app_name`, `page_app_name`, `page_context`, `page_url` | `page_entity_type`, `prevpage_url`, `related_list` |

### Apex Interactions

`custom_entity_type`이 `ApexClass` 또는 `ApexTrigger`인 로그 레코드는 패키지된 Apex 클래스 또는 트리거와의 상호작용을 나타낸다.

#### Apex Execution

`log_record_type`이 `ApexExecution`인 경우 — 사용자 액션으로 인한 Apex 코드 실행과 연관:

| Standard Data | Supplemental Data |
|---|---|
| `entry_point`, `quiddity` | `num_soql_queries` |

#### Apex Unexpected Exception

`log_record_type`이 `ApexUnexpectedException`인 경우 — Apex 클래스 또는 트리거가 처리되지 않은 예외를 던진 경우:

| Standard Data | Supplemental Data |
|---|---|
| `stack_trace` | none |

### Visualforce Interactions

`custom_entity_type`이 `VisualforcePage`인 로그 레코드는 패키지된 Visualforce 페이지와의 상호작용을 나타낸다.

#### Visualforce Requests

`log_record_type`이 `VisualforceRequest`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| `url` | `request_status`, `referrer_uri`, `request_size`, `response_size` |

### CRM Analytics Asset Interactions

`custom_entity_type`이 `AnalyticsDashboard`, `AnalyticsLens`, 또는 `AnalyticsRecipe`인 로그 레코드는 패키지된 CRM Analytics 에셋과의 상호작용을 나타낸다.

#### Analytics Asset Runs

`log_record_type`이 `AnalyticsAssetRun`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | none |

#### Analytics Asset Views

`log_record_type`이 `AnalyticsAssetView`인 경우:

| Standard Data | Supplemental Data |
|---|---|
| none | none |

### Custom Interactions (in Package Usage Logs)

`log_record_type`이 `CustomInteraction`이고 `custom_entity_type`이 `CustomInteractionLabel`인 경우 — `IsvPartners.AppAnalytics.logCustomInteraction` Apex 메서드를 사용해 생성한 커스텀 인터랙션:

| Standard Data | Supplemental Data |
|---|---|
| `class_name`, `method_name`, `line_number`, `interaction_id_token` | `api_version` |

#### Successful Custom Interactions

`log_record_type`이 `CustomInteraction`이고 `custom_entity_type`이 `CustomInteractionLabel`인 로그 레코드 분석 시 `custom_entity`에 생성하고 로그된 커스텀 인터랙션 레이블이 포함된다.

**Note:** `interaction_id_token`은 연관된 `IsvPartners.AppAnalytics.logCustomInteraction` 호출에 `interaction_id`가 제공된 경우에만 포함된다. `interaction_id_token`은 제공된 원시 상호작용 ID의 해시된 토큰화된 버전이다.

#### Unsuccessful Custom Interactions

`custom_entity_type`이 `CustomInteractionFailure`인 경우 커스텀 인터랙션 로그 실패. `custom_entity` 값으로 제공된 이유 코드를 확인한다:

| custom_entity | Message |
|---|---|
| `LABEL_NO_NAMESPACE` | App Analytics로 커스텀 인터랙션을 로그할 수 없습니다. `IsvPartners.AppAnalytics.logCustomInteraction`에 제공된 인터랙션 레이블에는 네임스페이스가 있어야 합니다 |
| `LABEL_NOT_ENUM` | App Analytics로 커스텀 인터랙션을 로그할 수 없습니다. `IsvPartners.AppAnalytics.logCustomInteraction`에 제공된 인터랙션 레이블은 Apex enum이어야 합니다 |
| `LABEL_WRONG_NAMESPACE` | App Analytics로 커스텀 인터랙션을 로그할 수 없습니다. `IsvPartners.AppAnalytics.logCustomInteraction`에 제공된 인터랙션 레이블은 메서드를 호출한 패키지와 동일한 네임스페이스를 가져야 합니다 |
| `OVER_CALL_LIMIT` | `IsvPartners.AppAnalytics.logCustomInteraction`이 이 사용자 요청에 대해 너무 많이 호출되었습니다. 이 사용자 요청에 대한 후속 커스텀 인터랙션은 App Analytics에 로그되지 않습니다 |

---

## Subscriber Snapshots

구독자 스냅샷은 구독자 활동의 특정 시점 요약을 제공한다. 구독자 스냅샷을 사용해 org 및 패키지별 사용량 추세를 파악한다.

**Note:** AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다.

AppExchange App Analytics는 매일 org, 패키지, 커스텀 엔티티 데이터의 스냅샷을 찍는다. 스냅샷은 매일 00:00 UTC에 캡처되고 즉시 다운로드 가능하다. 날짜 및 시간, 또는 날짜 및 시간의 범위를 요청하면, 유효한 날짜 및 시간별로 하나의 스냅샷을 받는다.

예를 들어 2023년 4월 7일에 `StartTime=2023-04-04T00:00:00Z EndTime=2020-04-07T00:00:00Z`의 날짜 및 시간 범위를 요청하면 완료된 각 날에 대해 하나씩, 세 개의 스냅샷을 받는다.

### Subscriber Snapshots Schema

| Field | Description |
|---|---|
| `attribute_name` | 커스텀 엔티티, 관리 패키지, 패키지 버전, 또는 org의 특성을 나타냄. 예: `UsersWithMFA` |
| `attribute_value` | `attribute_name`의 특성 또는 측정값을 나타내는 문자열. 예: `0.570`, `1.000`, `Acme, Inc.`, `Active`, `Deprecated` |
| `count` | 지정된 스냅샷 날짜에 해당 org의 커스텀 엔티티 총 레코드 수 |
| `custom_entity` | 컴포넌트 또는 커스텀 오브젝트의 개발자 명칭. 예: `Amount`, `Travel_Expense` |
| `date` | 요청된 구독자 스냅샷 날짜 (YYYY-MM-DDT00:00:00Z 형식). 각 특정 시점 스냅샷은 지정된 날짜의 00:00 UTC에 캡처됨. 예: `2023-04-04T00:00:00Z` |
| `managed_package_namespace` | 패키지의 네임스페이스. 예: `sfdx_isv_pkg001` |
| `organization_edition` | 구독자 org가 사용하는 Salesforce 에디션. 예: `Developer Edition`, `Enterprise Edition`, `Unlimited Edition` |
| `organization_id` | 구독자 org의 15자리 ID. 예: `00D4m000000Td8Y` |
| `organization_name` | 구독자 org 이름. 예: `My_Org` |
| `organization_status` | 구독자 org의 유료 상태. 예: `ACTIVE`, `DEMO`, `FREE`, `TRIAL` |
| `package_id` | 관리 패키지 ID. 예: `033xx00000000CI` |
| `package_version_id` | 관리 패키지 버전 ID. 예: `04t6A0000004eytQAA` |

**특수 attribute_name — UsersWithMFA:**

`attribute_name`이 `UsersWithMFA`인 경우, `attribute_value`는 다음 메서드 중 하나를 사용해 MFA를 활성화한 고유한 표준 사용자의 비율을 나타낸다: 사용자 권한 세트, 프로필 권한 세트, 높은 보증 세션 보안 수준. `attribute_value`는 항상 0과 1 사이이며, 0은 0%, 1은 100%를 나타낸다.

`attribute_name` 및 `attribute_value` 필드는 key-value 쌍이다. 일부 쌍은 org 수준 메타데이터를 제공하고, 다른 쌍은 커스텀 엔티티, 관리 패키지, 패키지 버전 메타데이터를 제공한다.

**Note:** Spring '25부터 트라이얼 org는 구독자 스냅샷 MFA 데이터에 포함되지 않는다.

---

## Test Custom Integrations (Simulation Mode)

비프로덕션 환경에서 커스텀 통합을 테스트하려면 AppExchange App Analytics Simulation Mode를 사용한다. App Analytics 쿼리 요청을 제출하고 샘플 사용량 데이터를 받는다.

**Note:** AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다.

**필요 권한:** Simulation Mode 활성화를 위해 `ModifyMetadata` 권한

### Simulation Mode 사용 절차

1. Metadata API `AppAnalyticsSettings` `enableSimulationMode` org 기본 설정을 사용해 테스트 org에서 시뮬레이션 모드를 활성화한다.
2. 패키지 사용량 로그, 사용량 요약, 또는 구독자 스냅샷 다운로드를 시뮬레이션하려면, SOAP API `AppAnalyticsQueryRequest`에 필요한 필드를 입력한다. `DataType`을 포함하고 `OrganizationIds`는 비워 두어라. `PackageIds`에는 테스트 중인 시나리오에 맞는 시뮬레이션 모드 패키지 ID를 최소 하나 이상 포함한다.

### 시뮬레이션 모드 패키지 데이터셋

| Package Dataset | Simulation Mode Package ID | Description |
|---|---|---|
| Small Dataset | `033xx00SIMsmall` | 소량의 데이터. 모든 쿼리 유형에 사용. 모든 쿼리 허용 시간 범위의 데이터를 다운로드하는 데 이 패키지 ID를 사용 |
| Large Dataset | `033xx00SIMLarge` | 두 개의 org ID (`00Dxx00000SIMooo` 및 `00Dxx0000M0baa1`)에 대한 상당한 양의 데이터. Package Usage Log 쿼리에만 사용 |
| Empty Dataset | `033xx0SIMEmpty` 접두사로 시작하는 모든 15자리 패키지 ID (`033xx0SIMEmpty`, `033xx0SIMHt4444` 등) | 데이터 없음. 모든 쿼리 유형에 사용. 빈 데이터셋을 반환하는 데 이 패키지 ID 중 하나를 사용 |

3. 쿼리를 제출한다.
4. API 요청을 확인한다:
   a. 성공하면 App Analytics Query Request 오브젝트를 검색한다. `DownloadURL` 필드는 요청이 완료되면 채워진다.
   b. 오류가 발생하면 쿼리를 검토한다. 14일과 같은 더 작은 시간 창을 사용하거나 하나의 org ID를 지정한다. 쿼리를 재제출한다.
5. App Analytics Query Request 오브젝트의 `DownloadURL` 필드에서 샘플 사용량 데이터가 포함된 CSV 파일을 다운로드한다.

**중요:** 시뮬레이션 모드가 활성화된 경우 샘플 사용량 데이터에만 접근 가능하다. 프로덕션 데이터에 접근하려면 시뮬레이션 모드를 비활성화한다.

---

## 관련 노트
- [[2GP — App Analytics Part 1: Overview & Setup]]
- [[2GP — App Analytics Part 2: Best Practices & Query Strategy]]
- [[2GP — App Analytics Part 4: Developer Cookbook]]
- [[2GP — LMA Part 1 Get Started]]
- [[2GP Managed Package 개념과 1GP 비교]]
