---
tags: [lwc, lds, ui-api, rest, wire-adapter, getRecord, getObjectInfo, getPicklistValues, getRelatedListInfo, uiRecordApi, uiObjectInfoApi, uiListsApi, uiRelatedListApi]
aliases: [UI API, User Interface API, uiApi, LDS REST, lightning/uiRecordApi, lightning/uiObjectInfoApi]
source: api_ui.pdf (v67.0, Summer '26)
created: 2026-05-22
updated: 2026-05-22
---

# UI API 개요

> **User Interface API (UI API)** — Salesforce 레코드·레이아웃·메타데이터를 한 번의 요청으로 반환하는 REST API.  
> LWC의 `lightning/uiRecordApi`, `lightning/uiObjectInfoApi` 등 **wire 어댑터가 내부적으로 호출하는 엔드포인트**다.

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 1. 기본 사항

| 항목 | 내용 |
|---|---|
| 베이스 URL | `https://{MyDomain}.my.salesforce.com/services/data/v67.0/ui-api/` |
| 인증 | OAuth 2.0 (다른 Salesforce REST API와 동일) |
| 현재 버전 | 67.0 (Summer '26) |
| 날짜 포맷 | ISO 8601 |
| 정수 범위 | < 10¹⁸; ≥ 2³¹ 은 따옴표로 감싸야 함 |
| Rate Limit 초과 | HTTP 503 반환 |
| ETag 지원 | 레코드 응답에 `weakEtag` 포함 → 조건부 GET (`If-None-Match`) 가능 |
| 대소문자 | 대소문자 구별 가정 권장 |
| 지원 객체 | 모든 Custom Object + Supported Standard Object |

---

## 2. REST 리소스 목록

### 2-1. Records

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/records/{recordId}` | 레코드 단건 조회 |
| GET | `/ui-api/records/batch/{recordIds}` | 레코드 배치 조회 (콤마 구분) |
| POST | `/ui-api/records` | 레코드 생성 |
| POST | `/ui-api/records/batch` | 레코드 배치 생성 |
| PATCH | `/ui-api/records/{recordId}` | 레코드 수정 |
| POST | `/ui-api/records/batch` | 레코드 배치 수정 |
| DELETE | `/ui-api/records/{recordId}` | 레코드 삭제 |
| POST | `/ui-api/records/batch` | 레코드 배치 삭제 |
| GET | `/ui-api/record-ui/{recordIds}` | 레이아웃 + 메타데이터 + 데이터 (RecordUI) |
| GET | `/ui-api/records/{recordId}/child-relationships/{name}` | 자식 레코드 페이지네이션 |

> **멱등 쓰기:** POST/PATCH/DELETE 요청에 `Idempotency-Key: {UUID v4}` 헤더를 포함하면 30일간 캐시됨. 응답 최대 9 MB.

### 2-2. Object Info (메타데이터)

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/object-info/{objectApiName}` | 객체 메타데이터 (ObjectInfo) |
| GET | `/ui-api/object-info/batch/{objectApiNames}` | 객체 메타데이터 배치 |
| GET | `/ui-api/object-info/{objectApiName}/picklist-values/{recordTypeId}` | 레코드 타입의 전체 Picklist 값 |
| GET | `/ui-api/object-info/{objectApiName}/picklist-values/{recordTypeId}/{fieldApiName}` | 단일 Picklist 필드 값 |

### 2-3. Record Defaults (기본값)

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/record-defaults/create/{objectApiName}` | 레코드 생성 기본값 |
| GET | `/ui-api/record-defaults/clone/{recordId}` | 레코드 복제 기본값 |
| GET | `/ui-api/record-defaults/template/create/{objectApiName}` | 생성 템플릿 (optionalFields 지원) |
| GET | `/ui-api/record-defaults/template/clone/{recordId}` | 복제 템플릿 (optionalFields 지원) |

### 2-4. Layout

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/layout/{objectApiName}` | 객체 레이아웃 (RecordLayout) |

### 2-5. List Views

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/list-info/{objectApiName}/{listViewApiName}` | 리스트 뷰 메타데이터 |
| GET | `/ui-api/list-info/batch?ids=<id>` | 리스트 뷰 배치 메타데이터 |
| POST | `/ui-api/list-info/{objectApiName}` | 리스트 뷰 생성 |
| PATCH | `/ui-api/list-info/{objectApiName}/{listViewApiName}` | 리스트 뷰 메타데이터 수정 |
| GET | `/ui-api/list-records/{objectApiName}/{listViewApiName}` | 리스트 뷰 레코드 |
| GET | `/ui-api/list-preferences/{objectApiName}/{listViewApiName}` | 리스트 뷰 사용자 설정 |
| PATCH | `/ui-api/list-preferences/{objectApiName}/{listViewApiName}` | 리스트 뷰 사용자 설정 수정 |

### 2-6. Related Lists

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/related-list-info/{parentObjectApiName}/{relatedListId}` | 관련 리스트 메타데이터 |
| GET | `/ui-api/related-list-info/batch/{parentObjectApiName}/{relatedListNames}` | 관련 리스트 배치 메타데이터 |
| PATCH | `/ui-api/related-list-info/{parentObjectApiName}/{relatedListId}` | 관련 리스트 메타데이터 수정 |
| GET | `/ui-api/related-list-records/{parentRecordId}/{relatedListId}` | 관련 리스트 레코드 |
| POST | `/ui-api/related-list-records/{parentRecordId}/{relatedListId}` | 관련 리스트 레코드 생성 |
| GET | `/ui-api/related-list-records/batch/{parentRecordId}/{relatedListIds}` | 관련 리스트 레코드 배치 |
| POST | `/ui-api/related-list-records/batch/{parentRecordId}` | 관련 리스트 레코드 배치 생성 |
| GET | `/ui-api/related-list-count/{parentRecordId}/{relatedListId}` | 관련 리스트 건수 |
| GET | `/ui-api/related-list-count/batch/{parentRecordId}/{relatedListIds}` | 관련 리스트 건수 배치 |

### 2-7. Actions

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/actions/global` | 전역 액션 목록 |
| GET | `/ui-api/actions/record/{recordIds}` | 레코드 액션 |
| GET | `/ui-api/actions/record/{recordId}/record-edit` | 레코드 편집 Quick Action |
| GET | `/ui-api/actions/record/{recordIds}/related-list/{relatedListId}` | 관련 리스트 액션 |
| GET | `/ui-api/actions/flexipage/{flexipageNames}` | Flexipage 액션 |
| GET | `/ui-api/actions/lookup/{objectApiNames}` | Lookup 액션 |
| POST | `/ui-api/actions/perform-quick-action/{actionApiName}` | Quick Action 실행 |

### 2-8. Lookups & Duplicates

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| POST | `/ui-api/lookups/{objectApiName}/{fieldApiName}` | Lookup 검색 (searchType: Search, TypeAhead, Recent) |
| GET | `/ui-api/duplicates/{objectApiName}` | 중복 규칙 설정 조회 |
| POST | `/ui-api/duplicates/{objectApiName}` | 중복 검사 실행 |

### 2-9. Favorites / Apps / Nav

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| GET | `/ui-api/favorites` | 즐겨찾기 목록 |
| POST | `/ui-api/favorites` | 즐겨찾기 추가 |
| PATCH | `/ui-api/favorites/{favoriteId}` | 즐겨찾기 수정 |
| DELETE | `/ui-api/favorites/{favoriteId}` | 즐겨찾기 삭제 |
| GET | `/ui-api/apps` | 앱 목록 |
| GET | `/ui-api/apps/{appId}` | 앱 단건 |
| GET | `/ui-api/nav-items` | 네비게이션 아이템 |

### 2-10. Files

| HTTP | 엔드포인트 | 설명 |
|---|---|---|
| POST | `/ui-api/records/content-documents/content-versions` | 파일 업로드 (신규) |
| POST | `/ui-api/records/content-documents/{contentDocumentId}/content-versions` | 파일 업로드 (신버전) |

---

## 3. 주요 응답 바디 타입

| 타입 | 설명 | 주로 반환하는 엔드포인트 |
|---|---|---|
| **RecordUI** | 레이아웃 + 메타데이터(ObjectInfo) + 레코드 데이터를 한번에 | `/ui-api/record-ui/{recordIds}` |
| **Record** | 필드 데이터 + childRelationships + recordTypeInfo | `/ui-api/records/{recordId}` |
| **ObjectInfo** | 객체 메타데이터 (필드 목록, dataType, FLS, 레코드 타입, dependentFields 등) | `/ui-api/object-info/{objectApiName}` |
| **PicklistValues** | 단일 Picklist 필드의 values 배열 + controllerValues + validFor | `/ui-api/object-info/{obj}/picklist-values/{rtId}/{field}` |
| **PicklistValuesCollection** | 레코드 타입의 모든 Picklist 값 모음 | `/ui-api/object-info/{obj}/picklist-values/{rtId}` |
| **RecordDefaults** | 레코드 생성·복제 기본값 + ObjectInfo + RecordLayout | `/ui-api/record-defaults/create/{obj}` |
| **RecordLayout** | 레코드 레이아웃 정보 | `/ui-api/layout/{obj}` |
| **ListInfo** | 리스트 뷰 메타데이터 | `/ui-api/list-info/{obj}/{listApiName}` |
| **ListRecordCollection** | 리스트 뷰 레코드 컬렉션 | `/ui-api/list-records/{obj}/{listApiName}` |
| **RelatedListInfo** | 관련 리스트 메타데이터 | `/ui-api/related-list-info/{parentObj}/{relatedListId}` |
| **RelatedListRecordCollection** | 관련 리스트 레코드 컬렉션 | `/ui-api/related-list-records/{parentRecordId}/{relatedListId}` |
| **RelatedListRecordCount** | 관련 리스트 건수 | `/ui-api/related-list-count/{parentRecordId}/{relatedListId}` |
| **Action** | 레코드·전역 액션 목록 | `/ui-api/actions/*` |
| **Theme** | 테마 이미지·배너 | `/ui-api/theme` |

---

## 4. LWC Wire 어댑터 매핑

> **[외부 지식 — Tier 3]** 아래 wire 어댑터 정보는 `api_ui.pdf`에 포함되지 않은 LWC 프레임워크 모듈이다.

### `lightning/uiRecordApi`

| 어댑터 / 함수 | 내부 UI API 리소스 | 종류 |
|---|---|---|
| `getRecord` | GET `/ui-api/records/{recordId}` | wire |
| `getRecords` | GET `/ui-api/records/batch/{recordIds}` | wire |
| `getFieldValue(record, field)` | — (Record 응답 파싱 헬퍼) | 유틸 |
| `getFieldDisplayValue(record, field)` | — (Record 응답 파싱 헬퍼) | 유틸 |
| `createRecord(recordInput)` | POST `/ui-api/records` | 명령형 |
| `updateRecord(recordInput)` | PATCH `/ui-api/records/{recordId}` | 명령형 |
| `deleteRecord(recordId)` | DELETE `/ui-api/records/{recordId}` | 명령형 |
| `notifyRecordUpdateAvailable(recordInputs)` | 캐시 무효화 신호 | 명령형 |
| `getRecordCreateDefaults` | GET `/ui-api/record-defaults/create/{objectApiName}` | wire |
| `generateRecordInputForCreate(defaults)` | — (RecordDefaults 파싱 헬퍼) | 유틸 |
| `generateRecordInputForUpdate(record)` | — (Record 파싱 헬퍼) | 유틸 |
| `createRecordInputFilteredByEditedFields` | — (diff 필터 헬퍼) | 유틸 |

### `lightning/uiObjectInfoApi`

| 어댑터 | 내부 UI API 리소스 | 종류 |
|---|---|---|
| `getObjectInfo` | GET `/ui-api/object-info/{objectApiName}` | wire |
| `getObjectInfos` | GET `/ui-api/object-info/batch/{objectApiNames}` | wire |
| `getPicklistValues` | GET `/ui-api/object-info/{obj}/picklist-values/{rtId}/{field}` | wire |
| `getPicklistValuesByRecordType` | GET `/ui-api/object-info/{obj}/picklist-values/{rtId}` | wire |

### `lightning/uiListsApi`

| 어댑터 | 내부 UI API 리소스 | 종류 |
|---|---|---|
| `getListInfoByName` | GET `/ui-api/list-info/{obj}/{listApiName}` | wire |
| `getListUi` | GET `/ui-api/list-records/{obj}/{listApiName}` | wire |
| `getListRecords` | GET `/ui-api/list-records/{obj}/{listApiName}` | wire |

### `lightning/uiRelatedListApi`

| 어댑터 | 내부 UI API 리소스 | 종류 |
|---|---|---|
| `getRelatedListInfo` | GET `/ui-api/related-list-info/{parentObj}/{relatedListId}` | wire |
| `getRelatedListInfoBatch` | GET `/ui-api/related-list-info/batch/{parentObj}/{relatedListNames}` | wire |
| `getRelatedListRecords` | GET `/ui-api/related-list-records/{parentRecordId}/{relatedListId}` | wire |
| `getRelatedListRecordsBatch` | GET `/ui-api/related-list-records/batch/{parentRecordId}/{relatedListIds}` | wire |
| `getRelatedListCount` | GET `/ui-api/related-list-count/{parentRecordId}/{relatedListId}` | wire |
| `getRelatedListCountBatch` | GET `/ui-api/related-list-count/batch/{parentRecordId}/{relatedListIds}` | wire |
| `getRelatedListsInfo` | GET `/ui-api/related-list-info/{parentObj}` | wire |

---

## 5. Picklist 처리 흐름

종속 Picklist를 표시하려면 두 단계:

1. **ObjectInfo 조회** → 각 필드의 `dataType` (`Picklist` / `MultiPicklist`) 확인 + `controllingFields` 로 종속 여부 파악 + `dependentFields` 로 트리 구조 파악
2. **Picklist 값 조회** → `getPicklistValues` (단일 필드) 또는 `getPicklistValuesByRecordType` (레코드 타입 전체)
   - 독립 Picklist: `controllingFields` 가 비어있음 → `values[]` 그대로 사용
   - 종속 Picklist: `controllerValues` (controlling 필드 값 → 인덱스 맵) + `values[].validFor` (유효한 인덱스 배열) 로 필터링

```javascript
// 종속 Picklist 필터 패턴 (외부 지식)
const filtered = dependentValues.filter(opt =>
  opt.validFor.includes(controllerValues[selectedControllerValue])
);
```

자세한 예시 → [[getPicklistValues 패턴]]

---

## 6. 자식 레코드 처리

- `childRelationships` 쿼리 파라미터로 특정 관계만 요청: `Account.Contacts,Account.Opportunities`
- 응답은 페이지네이션(`pageSize` 기본 5): `nextPageUrl`, `previousPageUrl` 포함
- **1레벨만** 반환 (중첩 관계의 자식은 포함하지 않음)

---

## 7. HTTP 상태 코드 요약

| 코드 | 의미 |
|---|---|
| 200 | GET / PATCH / HEAD 성공 |
| 201 | POST 성공 (생성) |
| 204 | DELETE 성공 |
| 304 | Not Modified (ETag 일치) |
| 400 | 잘못된 ID 또는 파라미터 |
| 401 | 세션 만료 / 토큰 무효 |
| 403 | 권한 없음 |
| 404 | 리소스 없음 또는 삭제됨 |
| 410 | 폐기된 리소스 (retired API version) |
| 412 | 전제 조건 실패 (haltOnError 배치) |
| 500 | 플랫폼 내부 오류 |
| 503 | Rate limit 초과 |

---

## 관련 문서

- [[uiRecordApi]] — createRecord, updateRecord, deleteRecord LWC 패턴
- [[getRecord 패턴]] — @wire(getRecord), getFieldValue, static schema import
- [[getPicklistValues 패턴]] — Picklist + 종속 Picklist 처리 상세
- [[Record Form 선택]] — lightning-record-form vs edit-form vs view-form
- [[ldsUtils reduceErrors]] — UI API 에러 응답 정규화
