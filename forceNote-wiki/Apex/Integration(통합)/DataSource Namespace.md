---
tags: [apex, datasource, namespace, salesforce-connect, external-objects, custom-adapter, external-data-source]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [DataSource Namespace, DataSource.Connection, DataSource.Provider, Salesforce Connect, External Objects, 커스텀 어댑터, 외부 오브젝트]
---

# DataSource Namespace

> Apex Connector Framework — `DataSource.Provider`와 `DataSource.Connection`을 구현하여 Salesforce Connect용 커스텀 어댑터를 만들고, 외부 시스템의 데이터를 External Object로 연결한다.

---

## 아키텍처 개요

```
┌─────────────────────────────────────────┐
│           DataSource.Provider           │  ← 기능/인증 capability 선언
│  getCapabilities() / getAuthCapabilities()│
│  getConnection(params)                  │  ← Connection 인스턴스 반환
└─────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│          DataSource.Connection          │  ← 실제 데이터 처리
│  sync()          → Table 목록 반환      │  ← 스키마 동기화
│  query(ctx)      → TableResult          │  ← SOQL 처리
│  search(ctx)     → List<TableResult>    │  ← SOSL 처리
│  upsertRows(ctx) → List<UpsertResult>   │  ← 생성/수정
│  deleteRows(ctx) → List<DeleteResult>   │  ← 삭제
└─────────────────────────────────────────┘
```

---

## DataSource.Provider 구현

```apex
global class MyProvider extends DataSource.Provider {

    // 인증 방식 선언
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        return new List<DataSource.AuthenticationCapability>{
            DataSource.AuthenticationCapability.ANONYMOUS,
            DataSource.AuthenticationCapability.OAUTH
        };
    }

    // 기능 선언
    override global List<DataSource.Capability> getCapabilities() {
        return new List<DataSource.Capability>{
            DataSource.Capability.ROW_QUERY,    // SOQL 지원
            DataSource.Capability.SEARCH,        // SOSL 지원
            DataSource.Capability.ROW_CREATE,
            DataSource.Capability.ROW_UPDATE,
            DataSource.Capability.ROW_DELETE
        };
    }

    // Connection 인스턴스 반환
    override global DataSource.Connection getConnection(
            DataSource.ConnectionParams params) {
        return new MyConnection(params);
    }
}
```

### Capability Enum 주요 값

| 값 | 설명 |
|---|---|
| `ROW_QUERY` | SOQL 쿼리 지원 |
| `SEARCH` | SOSL / 전역 검색 지원 |
| `ROW_CREATE` | 외부 레코드 생성 |
| `ROW_UPDATE` | 외부 레코드 수정 |
| `ROW_DELETE` | 외부 레코드 삭제 |

### AuthenticationCapability Enum

| 값 | 설명 |
|---|---|
| `ANONYMOUS` | 인증 불필요 (Named Credential 사용 시 권장) |
| `OAUTH` | OAuth 인증 |
| `PASSWORD` | 사용자명/비밀번호 |
| `CERTIFICATE` | 인증서 기반 |

---

## DataSource.Connection 구현

```apex
global class MyConnection extends DataSource.Connection {

    global MyConnection(DataSource.ConnectionParams params) { }

    // 스키마 동기화 — Validate and Sync 버튼 클릭 시 호출
    override global List<DataSource.Table> sync() {
        List<DataSource.Column> columns = new List<DataSource.Column>{
            DataSource.Column.text('Name', 255),
            DataSource.Column.text('ExternalId', 255),  // 필수 — External ID 컬럼
            DataSource.Column.url('DisplayUrl')          // 필수 — 레코드 링크
        };
        return new List<DataSource.Table>{
            DataSource.Table.get('Products', 'Name', columns)
        };
    }

    // SOQL 처리
    override global DataSource.TableResult query(DataSource.QueryContext ctx) {
        List<Map<String, Object>> rows = fetchRowsFromExternalSystem();
        // QueryUtils.process: 필터/정렬/LIMIT-OFFSET 로컬 처리 (개발·테스트용)
        return DataSource.TableResult.get(ctx, DataSource.QueryUtils.process(ctx, rows));
    }

    // SOSL / 전역 검색 처리
    override global List<DataSource.TableResult> search(DataSource.SearchContext ctx) {
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();
        for (DataSource.TableSelection ts : ctx.tableSelections) {
            results.add(DataSource.TableResult.get(ts, fetchRowsFromExternalSystem()));
        }
        return results;
    }

    // Upsert (생성/수정)
    override global List<DataSource.UpsertResult> upsertRows(DataSource.UpsertContext ctx) {
        List<DataSource.UpsertResult> results = new List<DataSource.UpsertResult>();
        for (Map<String, Object> row : ctx.rows) {
            String extId = (String) row.get('ExternalId');
            try {
                String id = saveToExternalSystem(row, extId == null);
                results.add(DataSource.UpsertResult.success(id));
            } catch (Exception e) {
                results.add(DataSource.UpsertResult.failure(extId, e.getMessage()));
            }
        }
        return results;
    }

    // 삭제
    override global List<DataSource.DeleteResult> deleteRows(DataSource.DeleteContext ctx) {
        List<DataSource.DeleteResult> results = new List<DataSource.DeleteResult>();
        for (String extId : ctx.externalIds) {
            try {
                deleteFromExternalSystem(extId);
                results.add(DataSource.DeleteResult.success(extId));
            } catch (Exception e) {
                results.add(DataSource.DeleteResult.failure(extId, e.getMessage()));
            }
        }
        return results;
    }

    private List<Map<String, Object>> fetchRowsFromExternalSystem() {
        // HTTP callout → JSON parse → rows
        return new List<Map<String, Object>>();
    }
    private String saveToExternalSystem(Map<String, Object> row, Boolean isInsert) { return null; }
    private void deleteFromExternalSystem(String id) { }
}
```

---

## Context 클래스 주요 속성

| 클래스 | 핵심 속성 |
|---|---|
| `QueryContext` | `tableSelection` (TableSelection), SOQL WHERE/ORDER/LIMIT/OFFSET 분해됨 |
| `SearchContext` | `tableSelections` (List\<TableSelection\>) |
| `UpsertContext` | `tableSelected` (String), `rows` (List\<Map\<String,Object\>\>) |
| `DeleteContext` | `tableSelected` (String), `externalIds` (List\<String\>) |

## Result 클래스 생성 패턴

```apex
// UpsertResult
DataSource.UpsertResult.success(externalId)
DataSource.UpsertResult.failure(externalId, errorMessage)

// DeleteResult
DataSource.DeleteResult.success(externalId)
DataSource.DeleteResult.failure(externalId, errorMessage)

// TableResult
DataSource.TableResult.get(queryContext, rows)
DataSource.TableResult.get(tableSelection, rows)
```

---

## 비동기 콜백 — AsyncDeleteCallback / AsyncSaveCallback

외부 시스템이 비동기 처리를 할 때 `Database.deleteAsync()` / `Database.insertAsync()` / `Database.updateAsync()`와 함께 사용한다.

```apex
global class MyDeleteCallback extends DataSource.AsyncDeleteCallback {
    global override void processDelete(Database.DeleteResult result) {
        if (result.isSuccess()) {
            // 보정 트랜잭션 — 예: 로컬 레코드 상태 업데이트
        }
    }
}

global class MySaveCallback extends DataSource.AsyncSaveCallback {
    global override void processSave(Database.SaveResult result) {
        if (!result.isSuccess()) {
            // 실패 처리
        }
    }
}
```

---

## 필수 컬럼 규칙

| 컬럼 | 이유 |
|---|---|
| `ExternalId` (text) | Salesforce가 레코드를 외부 시스템과 매핑하는 키 |
| `DisplayUrl` (url) | 레코드 상세 페이지의 외부 링크 |

---

## 관련 노트

- [[RestClient 패턴]] — Connection 내 HTTP callout 구현에 사용
- [[Named Credential]] — callout 인증 관리
- [[Dom Namespace]] — XML 응답 파싱
- [[SOQL 패턴]] — 내부 데이터 쿼리와 구분
