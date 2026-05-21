---
title: Big Objects
tags: [salesforce, sobject, big-objects, archive, large-scale-data]
source: object_reference.pdf v67.0 — Ch1 pp.31–34 (물리 pp.73–76)
---

# Big Objects

## 개요

Big Object는 Salesforce 플랫폼에서 **수억~수십억 건**의 대용량 데이터를 저장·관리하는 오브젝트.

- 다른 오브젝트의 데이터를 아카이브하거나 외부 시스템의 대용량 데이터셋을 가져오는 용도
- 1백만 건이든 10억 건이든 **일관된 성능** 보장
- 표준 API 세트로 접근

---

## Big Object 타입

| 타입 | 설명 |
|---|---|
| **Standard Big Objects** | Salesforce 제공 내장 오브젝트. 예: `FieldHistoryArchive` (Field Audit Trail 제품의 데이터 저장). 커스터마이즈 불가. |
| **Custom Big Objects** | 조직 고유 정보를 저장하기 위해 직접 생성하는 오브젝트. Lightning Platform 기능 확장. |

---

## Custom Big Object 사용 케이스

- **360도 고객 뷰** — 로열티 프로그램, 피드, 클릭, 청구·프로비저닝 정보 등 확장 데이터 모델
- **감사 및 추적** — Salesforce 또는 제품 사용 현황을 장기간 추적 (분석·컴플라이언스)
- **히스토리 아카이브** — 핵심 CRM/Lightning Platform 성능 유지하면서 과거 데이터 장기 보관

---

## Big Object vs. sObject 비교

| 항목 | Big Objects | sObjects |
|---|---|---|
| DB 유형 | 수평 확장 분산 데이터베이스 | 관계형 데이터베이스 |
| 트랜잭션 | Non-transactional | Transactional |
| 레코드 규모 | 수억~수십억 건 | 수백만 건 |

---

## 동작 특성

- **권한**: 오브젝트/필드 권한만 지원. 일반 공유 규칙이나 표준 공유 규칙은 지원 안 함.
- **미지원 기능**: Trigger, Flow, Process, Salesforce 모바일 앱 지원 안 됨.
- **Idempotent 쓰기**: 동일한 인덱스 조합의 레코드를 여러 번 insert해도 단 하나의 레코드만 생성됨.
  - sObject는 같은 요청을 반복하면 여러 레코드가 생성되는 것과 다름.

---

## API 지원

Big Object에서 지원되는 API:

| API | 지원 여부 |
|---|---|
| SOQL | O |
| Bulk API | O |
| Chatter API | O |
| SOAP API | O |
| **REST API** | **X** |

---

## 네이밍 컨벤션

- API 이름: 두 언더스코어 + 소문자 `b` 접미사 `__b`
  - 예: `HistoricalInventoryLevels` → `HistoricalInventoryLevels__b`
- 이름은 표준·커스텀·외부·빅 오브젝트 모두 통틀어 고유해야 함.

---

## Custom Big Object 정의 및 배포 (Metadata API)

Metadata API로 XML 파일로 정의한다. 세 가지 파일 유형이 필요:

1. **object 파일** — 오브젝트 정의, 필드, 인덱스 포함
2. **permissionset/profile 파일** — 각 필드의 권한 지정 (없으면 접근 제한됨, 필수는 아님)
3. **package 파일** — Metadata API 마이그레이션 대상 지정 (패키징 기능과 무관)

> `CustomObject` 메타데이터 타입을 사용하지만, Big Object에만 해당하는 파라미터가 있고 일부 파라미터는 해당 없음.

---

## CustomObject 메타데이터 (Big Object 관련 필드)

| 필드명 | 타입 | 설명 |
|---|---|---|
| `deploymentStatus` | `DeploymentStatus` | 배포 상태 (모든 Big Object에서 `Deployed`) |
| `fields` | `CustomField[]` | 필드 정의 목록 |
| `fullName` | `string` | 고유 API 이름 |
| `indexes` | `Index[]` | 인덱스 정의 |
| `label` | `string` | UI 표시 이름 |
| `pluralLabel` | `string` | 복수형 UI 이름 |

---

## CustomField 메타데이터

| 필드명 | 타입 | 설명 |
|---|---|---|
| `fullName` | `string` | 고유 API 필드명 |
| `label` | `string` | UI 표시 이름 |
| `length` | `int` | 문자 길이 (Text·LongTextArea 전용). **인덱스 포함 모든 텍스트 필드 합산 100자 이내** |
| `pluralLabel` | `string` | 복수형 UI 이름 |
| `precision` | `int` | 숫자 자릿수 (number 전용) |
| `referenceTo` | `string` | Lookup 대상 오브젝트 (lookup 전용) |
| `relationshipName` | `string` | UI 관계 이름 (lookup 전용) |
| `required` | `boolean` | 필수 여부. **인덱스에 포함된 모든 필드는 필수여야 함** |
| `scale` | `int` | 소수점 이하 자릿수 (number 전용) |
| `type` | `FieldType` | 지원 타입: `DateTime`, `Email`, `Lookup`, `Number`, `Phone`, `Text`, `LongTextArea`, `URL` |

> `LongTextArea`와 `URL`은 인덱스에 포함할 수 없다.  
> 유니크(uniqueness) 설정은 커스텀 필드에서 지원되지 않는다.

**Email/Phone 길이 제한 (인덱스 100자 한도 계산 시 주의):**
- Email 필드: 80자
- Phone 필드: 40자

---

## Index 메타데이터

Big Object의 복합 기본키(composite primary key)를 정의한다.

| 필드명 | 타입 | 설명 |
|---|---|---|
| `fields` | `IndexField[]` | 인덱스 구성 필드 목록 |
| `label` | `string` | UI에서 사용할 이름. API v41.0 이상에서 사용. |

---

## IndexField 메타데이터

인덱스를 구성하는 각 필드의 순서와 정렬 방향을 정의한다.

- 정의 순서가 인덱스 내 필드 목록의 순서가 됨.
- 한 번 배포된 인덱스는 수정·삭제 불가. 변경하려면 새 Big Object를 생성해야 한다.

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[External Objects]] — 외부 시스템 데이터를 실시간으로 접근하는 다른 옵션
- [[Custom Objects]] — 일반 커스텀 오브젝트 설명 (Big Object와 비교)
- [[API Field Properties]] — `required`, `createable` 등 필드 속성 상세
