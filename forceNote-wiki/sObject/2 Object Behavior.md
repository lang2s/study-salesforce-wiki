---
tags: [sobject-reference, object-behavior, object-groups, data-cloud, big-objects, external-objects, object-types]
source: object_reference.pdf p.40-54 (v67.0 Summer '26)
created: 2026-05-22
aliases: [2 Object Behavior, Object 그룹, Data Cloud Object, Object Types, Object Cheatsheet, DLO DMO CIO DG]
---

# 2 Object Behavior — Salesforce Object 그룹·타입·치트시트

> Object의 데이터 저장 위치·트랜잭션 타입·라이센스 요건에 따른 분류와 선택 기준

---

## 개요: Object 선택 기준

저장할 데이터의 특성으로 Object 타입을 결정한다.

| 기준 | 질문 |
|---|---|
| 구조 | 계층형·표 형식·비정형? |
| 볼륨 | 대용량(수억 건)인가? |
| 크기 | 레코드 최대 크기는? |
| 보존 기간 | 단기·장기 보관? |
| 트랜잭션 | ACID·OLAP·OLTP? |
| 작업 | Create·Read·Update·Delete? |
| 레이턴시 | 얼마나 자주 업데이트? |

---

## Object 그룹

| 그룹 | 설명 | 라이센스 |
|---|---|---|
| **Salesforce Common Objects** | 모든 Org에서 사용 가능한 표준·커스텀 Object | 기본 포함 |
| **Salesforce Cloud Objects** | 특정 Cloud에서만 사용 가능 | Cloud별 라이센스 |
| **Salesforce High-Scale Objects** | 대용량 트랜잭션·장기 보관용 | 추가 구매 필요 |
| **Salesforce External Data Objects** | Salesforce 외부 저장 데이터 접근 | 별도 설정 |

---

## Salesforce Common Objects

### Original Platform Objects (Hero/Legacy Objects)

| 항목 | 내용 |
|---|---|
| 최적화 | ACID 트랜잭션 |
| 대표 Object | Account, Contact, Lead, Opportunity |
| 커스터마이징 | 가능 |
| Cloud | 모든 Cloud에서 사용 가능 |

### Base Platform Objects (BPO)

대부분의 Org에 공통인 Object (데이터 저장용).
- 예: `SocialPersona`

### Setup Platform Objects (SPO)

Setup 설정 정보를 저장하는 Object.
- 예: `CompactLayout`, `CustomField`

### Custom Objects

사용자 정의 테이블. API Name 접미사 `__c`.

---

## Salesforce High-Scale Objects

### Big Objects

| 항목 | 내용 |
|---|---|
| 용도 | Auditing·추적·피드·히스토리 아카이브 |
| 트랜잭션 | OLTP (non-transactional 분산 DB) |
| API Name 접미사 | `__b` |
| 레코드 수 | 수억~수십억 건 |
| 패키징 | deploy()/retrieve()로 .zip 배포. AppExchange 패키지 불가 |
| 예시 | `FieldHistoryArchive` |

### High-Scale Order Objects

- OLTP 최적화
- 예: `PendingOrderSummary`
- 문서: Order Management Implementation Guide

---

## Data Cloud Objects

Data Cloud에서 대규모 데이터를 저장·처리하는 Object 타입들.

### Data Cloud Object 생성 흐름

```
외부 시스템 → DLO (Data Lake Object, native schema 보존)
          → DMO (Data Model Object, C360 데이터 모델로 매핑)
          → Identity Resolution → Unified DMO
          → CIO (Calculated Insight Object) — DMO 집계/계산
          → DG (Data Graph) — near real-time 처리를 위한 JSON blob
          → Search Index → Chunk Content DMO + Vector Embedding DMO
```

### Data Cloud Object 타입

| 타입 | API 접미사 | 설명 |
|---|---|---|
| **DLO** (Data Lake Object) | `__dlo` | 수집된 원본 데이터 저장 |
| **DMO** (Data Model Object) | `__dlm` (필드명: `__c`) | C360 모델 기반 데이터 표현. 데이터 자체 저장 아님 |
| **Unified DMO** | — | Identity Resolution으로 병합된 골든 레코드 |
| **CIO** (Calculated Insight Object) | — | DMO 집계·계산 결과 |
| **DG** (Data Graph) | — | 여러 DMO 결합한 JSON blob (near real-time) |
| **UDLO** (Unstructured DLO) | `__dlo` | 비정형 데이터 (blob store) |
| **UDMO** (Unstructured DMO) | `__dlm` | 비정형 데이터 모델 (RAG/GenAI용) |

### Data Cloud SOQL 예시

```apex
// DMO 쿼리 (Unified Account DMO)
List<UnifiedAccount__dlm> accounts = [
    SELECT Id__c, Name__c, Email__c
    FROM UnifiedAccount__dlm
    LIMIT 100
];
```

---

## Salesforce External Data Objects

### External Objects

OData 어댑터 등을 통해 외부 시스템 데이터를 Salesforce에서 접근.
- API Name 접미사: `__x`
- ACID 보장 없음

### Zero Copy Objects

Snowflake·AWS 등 외부 데이터 소스를 Data Cloud와 Deep Integration.
- 데이터 동기화·수집 없이 직접 접근
- 별도 metadata 설정 필요

---

## Object Types 표 (API 접미사 → 타입)

| 접미사 | Object 타입 | 그룹 |
|---|---|---|
| `__b` | Big Object | High-Scale |
| `__c` | Custom Object | Common |
| `__ChangeEvent` | Custom Object Change Event | Common |
| `__chn` | PlatformEventChannel | Common |
| `__cio` | Calculated Insight Object | High-Scale |
| `__dg` | Data Graph | High-Scale |
| `__DataCategorySelection` | Knowledge 카테고리 선택 | Common |
| `__dlm` | Data Model Object | High-Scale |
| `__dlo` | Data Lake Object | High-Scale |
| `__dmo` | Data Model Object (쿼리용) | High-Scale |
| `__dso` | Data Source Object | High-Scale |
| `__e` | Platform Event | Common |
| `__Feed` | 커스텀 Object Feed | Common |
| `__hd` | Historical Data | Common |
| `__History` / `_hst` | Field History Tracking | Common |
| `__ka` | Knowledge Article | Common |
| `__kav` | Knowledge Article Version | Common |
| `__latitude__s` | Geolocation 위도 | Common |
| `__longitude__s` | Geolocation 경도 | Common |
| `__mdt` | Custom Metadata Type | Common |
| `__pc` | Custom Person Account Field | Common |
| `__pr` | Person Account Relationship | Common |
| `__r` | SOQL 관계 탐색 접미사 | Common |
| `__Share` | Custom Object 공유 | Common |
| `__Tag` | Salesforce Tag | Common |
| `__x` | External Object | Common |
| `__xo` | S2S Spoke/Proxy Object | Common |
| `ChangeEvent` | Standard Object Change Event | Common |
| `Feed` | Standard Object Feed | Common |

---

## Object Cheatsheet

| Object 타입 | 그룹 | 커스터마이징 | 패키징 | CRUD |
|---|---|---|---|---|
| Base Platform Objects | Common | 가능 | 모든 형태 | 전체 |
| Big Objects (`__b`) | High-Scale | 가능 | deploy/retrieve .zip | Insert·Query |
| Calculated Insight Objects | High-Scale | 가능 | Data Kit | Query |
| Custom Objects (`__c`) | Common | N/A (직접 정의) | Object에 따라 다름 | 전체 |
| Data Graphs | High-Scale | 가능 | Data Kit | Query |
| Data Lake Objects (`__dlo`) | High-Scale | 가능 | Data Kit | Insert·Query |
| Data Model Objects (`__dlm`) | High-Scale | 가능 | Data Kit | Query |
| External Objects (`__x`) | External | N/A | N/A | 제한적 |
| High-Scale Order Objects | High-Scale | N/A | Order Mgmt | 제한적 |
| Setup Platform Objects | Common | 가능 | Cloud별 다름 | 제한적 |
| Unified Objects | High-Scale | 가능 | Data Kit | Query |

---

## 관련 노트

- [[1 Overview]] — Field 타입·Primitive 타입 기초
- [[3 Associated Objects]] — Feed·History·Share 연관 Object 패턴
- [[4 Custom Objects]] — __mdt·__c·__Feed 표준 필드
- [[6 Standard Objects]] — 표준 Object 도메인별 카탈로그
- [[SOQL WITH DATA CATEGORY]] — DataCategoryGroupReference 필드 활용
