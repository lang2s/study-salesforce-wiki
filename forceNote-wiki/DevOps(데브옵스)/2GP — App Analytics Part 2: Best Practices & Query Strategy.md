---
tags: [2GP, AppExchange, AppAnalytics, BestPractices, QueryStrategy, CatchUpQueries, ISV, DevOps]
source: Salesforce Documents/pkg2_dev.pdf
created: 2026-05-24
aliases: [App Analytics Best Practices, App Analytics Query Strategy, Catch-Up Queries, AvailableSince, AppAnalyticsQueryRequest, 앱 애널리틱스 쿼리 전략]
---

# 2GP — App Analytics Part 2: Best Practices & Query Strategy

> AppExchange App Analytics 쿼리 전략을 계획·최대화하려면 데이터 결과 파일 크기를 줄이는 파일 압축을 사용하고, 정기 쿼리를 예약·자동화하고, catch-up 쿼리로 정기 쿼리 데이터를 보완한다.

---

## AppExchange App Analytics Best Practices 개요

Best Practices는 세 가지 핵심 전략으로 구성된다:
1. **파일 압축** — 결과 파일 크기를 줄여 데이터 결과 파일 크기를 줄인다.
2. **정기 쿼리 예약·자동화** — 정기 App Analytics 쿼리를 예약하고 자동화한다.
3. **Catch-Up 쿼리** — 정기 쿼리 데이터를 보완하기 위해 catch-up 쿼리를 계획·예약·자동화한다.

---

## How Does AppExchange App Analytics Data Flow?

고객이 관리 패키지를 사용하면서 데이터를 생성한다. 사용량 데이터는 매일 각 Salesforce 인스턴스에서 데이터 레이크로 수집된다. 하루 종일 데이터가 도착하며, 데이터 도착 지연이 발생할 수 있다. 데이터 빌드 및 타임스탬프는 데이터 타입에 따라 다르다.

Salesforce 인스턴스와 구독자는 전 세계에 위치하므로, 데이터 수집 시간은 지역에 따라 다르다:
- EU(EMEA) 데이터가 먼저 도착
- North America(NA) 데이터 다음 도착
- Asia Pacific(AP) 데이터 마지막 도착

App Analytics 작업은 비피크 시간 로컬 인스턴스 시간에 실행된다. 쿼리 시간과 고객 위치에 따라 한 번에 100%의 데이터를 얻거나, 전부 검색하려면 더 많은 쿼리를 발행해야 할 수 있다.

데이터 레이크 도착 및 도착은 인스턴스 상태, 기술 의존성 등 특정 인스턴스에 영향을 줄 수 있는 요소에도 의존한다. 일반적으로 모든 org 데이터는 23:00 UTC(협정 세계시)까지 데이터 레이크에 도착할 것으로 예상할 수 있다. 그러나 가끔 지연이 발생할 수 있다.

### 각 데이터 타입별 빌드 정보

| Data Type | Build Information | Example |
|---|---|---|
| Subscriber Snapshots | 스냅샷은 ~01:00 인스턴스 로컬 시간에 수집된 데이터를 사용. 스냅샷은 매일 밤 ~03:00 인스턴스 로컬 시간에 생성. 모든 타임스탬프는 해당 날의 00:00 UTC로 정규화 | 2021-03-01 스냅샷: 모든 레코드에 `2021-03-01T00:00:00Z` 타임스탬프. 데이터는 2021-03-02 23:00 UTC까지 정상 도착 |
| Package Usage Summaries | 요약은 전체 월의 데이터를 사용. 월별로 빌드. 타임스탬프는 해당 달 마지막 날 00:00 UTC로 정규화 | 2021-04-01에 제공되는 2021-03월 요약: 모든 레코드에 `2021-03-31T00:00:00Z` 타임스탬프. 데이터는 2021-04-01 23:00 UTC까지 도착. 2021-04-03 이후에 요약 데이터를 쿼리 권장 (2일 쿼리 지연) |
| Package Usage Logs | 이전 날의 데이터를 사용. 매일 밤 ~05:00 인스턴스 로컬 시간에 생성 | 2021-03-01 로그 파일: 모든 레코드에 해당 로그 이벤트 발생 시점의 정확한 타임스탬프. 데이터는 2021-03-02 23:00 UTC까지 정상 도착 |

---

## How Should I Plan My App Analytics Query Strategy?

모든 파트너는 다음 쿼리 전략들을 활용할 수 있다:
- `FileType` 값을 선택하고 그에 맞는 `FileCompression`을 선택한다. 이 전략으로 csv 파일에는 gzip 압축을, parquet 파일에는 snappy 컬럼 압축을 선택할 수 있다.
- 정기적으로 예약된 자동화된 쿼리를 생성한다.
- 늦게 도착하는 데이터를 수집하려면 `AvailableSince` 필드를 사용해 catch-up 쿼리를 생성한다.

---

## Compress Your Results Files (파일 압축)

App Analytics 쿼리 계획은 결과 파일 타입과 파일 압축으로 시작된다. 데이터는 시간과 공간을 많이 차지할 수 있으므로, 다운로드하는 파일의 타입을 지정해 더 많은 작업을 수행한다. 결과 파일이 압축되는 방식을 지정해 데이터 다운로드 시간을 줄인다.

파일 타입 또는 파일 압축을 지정하지 않으면, 결과는 이전 버전과의 호환성을 위해 압축 없이 기본 csv로 설정된다. parquet 파일 타입을 선택하면 결과 파일에 각 열의 데이터 타입 정보가 포함된다.

항상 결과 파일을 압축하는 것을 권장한다. 다음 SOAP API `AppAnalyticsQueryRequest` `FileType` 및 `FileCompression` 값 조합 중에서 선택한다:

| FileType | FileCompression |
|---|---|
| csv (기본값) | none (csv일 때 기본값), gzip |
| parquet | snappy (parquet일 때 기본값), gzip, none |

**Note:** csv FileType과 gzip FileCompression으로 쿼리할 때 HTTP 응답에는 Content-Type 헤더(txt/csv)와 Content-Encoding 헤더(gzip 인코딩)가 포함된다. 현대 브라우저는 종종 gzip 인코딩 파일을 자동으로 디코딩하여 압축 해제된 .csv 파일로 저장한다. 파일이 자동으로 디코딩되더라도 파일명 확장자는 .csv이다.

---

## Schedule and Automate Your Queries (쿼리 예약 자동화)

자동화 옵션:
- REST 또는 SOAP API 호출을 사용하는 커스텀 API 통합
- CLI를 사용한 Salesforce DX 자동화
- Salesforce Flow
- Apex 트리거

예를 들어, Apex 트리거를 사용해 패키지 사용량 요약 검색을 자동화한다. 패키지 사용량 로그 데이터 검색도 자동화하려면, 로그에 포함된 데이터 볼륨에 확장되는 다른 스토리지 솔루션을 사용한다.

---

## Create Catch-Up Queries (Catch-Up 쿼리 생성)

Catch-up 쿼리는 데이터 레이크에 새로 추가된 데이터를 쓸어오는 방빗자루와 같다. Catch-up 쿼리는 정기 쿼리가 이미 준비되어 있어야 한다.

**예시:** 2021년 3월 1일 데이터를 조회하기 위해 2021년 3월 2일 18:00 UTC에 정기 쿼리를 실행한다:

```bash
# 정기 쿼리 (Regular Query)
sf data create record \
  --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-01T00:00:00Z \
EndTime=2021-03-02T00:00:00Z \
DataType=PackageUsageLog \
FileType=csv \
FileCompression=gzip"
```

2021년 3월 3일 18:00 UTC에 정확히 같은 쿼리를 실행하되 `AvailableSince` 필드를 원래 쿼리를 실행한 날짜와 시간(`2021-03-02T18:00:00Z`)으로 설정한다. 이 쿼리가 ad hoc catch-up 쿼리이며, 마지막 정기 쿼리 이후 데이터 레이크에 새로 추가된 2021년 3월 2일 데이터를 검색한다:

```bash
# Catch-Up 쿼리
sf data create record \
  --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-01T00:00:00Z \
EndTime=2021-03-02T00:00:00Z \
DataType=PackageUsageLog \
FileType=csv \
FileCompression=gzip \
AvailableSince=2021-03-02T18:00:00Z"
```

**Catch-Up 쿼리 생성 시 고려사항:**
- `StartTime`이 지정된 경우, `AvailableSince` 날짜는 나중이어야 한다.
- `EndTime`이 지정된 경우, `AvailableSince` 날짜는 나중이어야 한다.
- 모든 쿼리는 `StartTime` 또는 `AvailableSince` 중 하나 또는 모두를 포함해야 한다.
- `AvailableSince`는 지금보다 이전이어야 한다.

**Tip:** ad hoc catch-up 쿼리를 생성하고 싶지만 원래 쿼리를 실행했을 때를 잊었다면, Salesforce CLI를 사용해 org의 sObjectID로 `QuerySubmittedTime`을 조회한다: `sf data get record --sobjecttype AppAnalyticsQueryRequest --sobjectid 0XIXXXXXXXXXXXXXXX`. ad hoc catch-up 쿼리의 `AvailableSince` 값을 `QuerySubmittedTime`과 동일하게 설정한다.

---

## Recommendations (파트너 규모별 권장사항)

쿼리 전략은 비즈니스 규모와 범위에 따라 다르며, 비즈니스 성장에 따라 적응해야 한다. 최신 데이터를 유지하려면 소규모, 중간 규모, 대규모 파트너에 대한 App Analytics 쿼리 권장 사항을 따른다.

**Note:** 데이터 지연이 발생하는 드문 경우, 최대 30일 이전 로그 이벤트 데이터를 재생성한다. 가장 완전한 데이터를 지속적으로 검색하기 위해, 30일 이전 데이터를 조회하는 catch-up 쿼리를 예약한다.

### Small-Sized Partners (소규모 파트너)

소규모 파트너는 관리 가능한 구독자 기반과 1~2개의 관리 패키지를 보유한다. 소규모 파트너의 하루 총 사용량 데이터는 모든 관리 패키지에 걸쳐 5GB 이하이다. 소규모 파트너의 쿼리는 15분 처리 시간 한도보다 훨씬 낮게 완료된다.

데이터가 관리 가능하므로, 정기 쿼리를 한 번 실행한 후 매일 catch-up 쿼리를 메인 쿼리로 실행하는 것을 권장한다. 모든 관리 패키지의 모든 데이터를 수집한다.

| Data Type | How to Get Started | How to Schedule Catch-Up Queries |
|---|---|---|
| Subscriber Snapshots | App Analytics가 관리 패키지에서 활성화된 시점부터 데이터를 검색하는 초기 쿼리 | 매일 1회 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리가 실행된 날짜·시간으로 설정. `StartTime`을 30일 전으로 설정. `EndTime` 생략. 매일 `StartTime`과 `AvailableSince`를 1일씩 앞당김 |
| Package Usage Summaries | App Analytics가 관리 패키지에서 활성화된 시점부터 데이터를 검색하는 초기 쿼리 | 매일 1회 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리가 실행된 날짜·시간으로 설정. `StartTime`을 이전 달의 1일로 설정. `EndTime` 생략. 매일 `AvailableSince`를 1일씩 앞당김. 매달 `StartTime`을 이전 달의 1일로 앞당김 |
| Package Usage Logs | App Analytics가 관리 패키지에서 활성화된 시점부터 데이터를 검색하는 초기 쿼리 | 매일 1회 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리가 실행된 날짜·시간으로 설정. `StartTime`을 30일 전으로 설정. `EndTime` 생략. 매일 `StartTime`과 `AvailableSince`를 1일씩 앞당김 |

**예시:** NA 또는 EU 인스턴스에서 패키지를 사용하는 대부분의 고객이 있고, AP 인스턴스에 일부 고객이 있다. 18:00 UTC에 쿼리를 실행한다.

2020년 3월 30일 날짜 데이터 — 3월 31일 18:00 UTC 정기 쿼리:

```bash
# Subscriber Snapshot
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=SubscriberSnapshot FileType=csv FileCompression=gzip \
StartTime=2020-03-30T00:00:00Z EndTime=2020-03-31T00:00:00Z"

# Package Usage Summary
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=PackageUsageSummary FileType=csv FileCompression=gzip \
StartTime=2020-02-01T00:00:00Z EndTime=2020-03-01T00:00:00Z"

# Package Usage Log
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=PackageUsageLog FileType=csv FileCompression=gzip \
StartTime=2020-03-30T00:00:00Z EndTime=2020-03-31T00:00:00Z"
```

4월 1일 18:00 UTC에 세 가지 catch-up 쿼리를 실행:

```bash
# Subscriber Snapshot Catch-Up Query
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=SubscriberSnapshot FileType=csv FileCompression=gzip \
StartTime=2020-03-02T00:00:00Z AvailableSince=2020-03-31T18:00:00Z"

# Package Usage Summary Catch-Up Query
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=PackageUsageSummary FileType=csv FileCompression=gzip \
StartTime=2020-03-01T00:00:00Z AvailableSince=2020-03-31T18:00:00Z"

# Package Usage Log Catch-Up Query
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=PackageUsageLog FileType=csv FileCompression=gzip \
StartTime=2020-03-02T00:00:00Z AvailableSince=2020-03-31T18:00:00Z"
```

4월 2일: 구독자 스냅샷 및 패키지 사용량 로그 `AvailableSince`와 `StartTime` 날짜를 1일씩 앞당겨 동일한 catch-up 쿼리를 실행한다.

### Medium-Sized Partners (중간 규모 파트너)

중간 규모 파트너는 더 큰 구독자 기반과 약 6개의 관리 패키지를 보유한다. 총 일별 사용량 데이터는 모든 관리 패키지에 걸쳐 20GB 이상이다. 이 파트너의 쿼리는 15분 처리 시간 한도에 도달하거나 접근한다.

정기 쿼리를 한 번 실행한 후 매일 catch-up 쿼리를 메인 쿼리로 구독자 스냅샷과 패키지 사용량 요약에 사용한다. 패키지 사용량 로그에는 패키지당 하나의 정기 일별 쿼리와 catch-up 쿼리의 조합을 사용한다.

| Data Type | How to Get Started | How to Schedule Catch-Up Queries |
|---|---|---|
| Subscriber Snapshots | App Analytics가 활성화된 시점부터 초기 쿼리 | 매일 1회 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리 날짜·시간으로 설정. `StartTime`을 30일 전으로 설정. `EndTime` 생략. 매일 `StartTime`과 `AvailableSince`를 1일씩 앞당김 |
| Package Usage Summaries | App Analytics가 활성화된 시점부터 초기 쿼리 | 매일 1회 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리 날짜·시간으로 설정. `StartTime`을 이전 달의 1일로 설정. `EndTime` 생략. 매일 `AvailableSince`를 1일씩 앞당김. 매달 `StartTime`을 이전 달의 1일로 앞당김 |
| Package Usage Logs | 패키지당 1회 정기 일별 쿼리 | 패키지당 1회 일별 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리 날짜·시간으로 설정. `StartTime`을 30일 전으로 설정. `EndTime`을 정기 쿼리의 `StartTime`과 동일하게 설정. 매일 `StartTime`, `EndTime`, `AvailableSince`를 1일씩 앞당김 |

**예시 (Package 2개, medium-sized):** NA 또는 EU 인스턴스 고객이 18:00 UTC에 쿼리 실행, AP 인스턴스 고객도 있어 catch-up 쿼리로 데이터 캡처.

3월 31일 18:00 UTC — 정기 쿼리:

```bash
# Package 1 Regular Query
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-30T00:00:00Z EndTime=2021-03-31T00:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=csv FileCompression=gzip"

# Package 2 Regular Query
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-30T00:00:00Z EndTime=2021-03-31T00:00:00Z \
DataType=PackageUsageLog PackageIds=0337XXXXXXXXXX FileType=csv FileCompression=gzip"
```

4월 1일 18:00 UTC — Catch-Up 쿼리:

```bash
# Package 1 Catch-Up
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-02T00:00:00Z EndTime=2021-03-31T00:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=csv FileCompression=gzip \
AvailableSince=2021-03-31T18:00:00Z"

# Package 2 Catch-Up
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2020-03-02T00:00:00Z EndTime=2021-04-01T00:00:00Z \
DataType=PackageUsageLog PackageIds=0337XXXXXXXXXX FileType=csv FileCompression=gzip \
AvailableSince=2021-04-01T18:00:00Z"
```

### Large-Sized Partners (대규모 파트너)

대규모 파트너는 대규모 구독자 기반과 많은 관리 패키지를 보유한다. 총 일별 사용량 데이터는 20GB를 초과한다. 하나의 관리 패키지에서만의 데이터가 20GB 일별 한도를 초과하는 경우도 있다. 또한 대규모 파트너는 종종 하루 24시간에 걸쳐 분산된 12, 6, 1시간 단위로 패키지당 쿼리를 생성해야 한다.

모든 데이터 타입에 대해 쿼리와 여러 catch-up 쿼리의 조합을 사용한다.

| Data Type | How to Get Started | How to Schedule Catch-Up Queries |
|---|---|---|
| Subscriber Snapshots | 패키지당 1회 일별 쿼리 | 패키지당 1회 일별 쿼리. `AvailableSince`를 마지막 정기 쿼리 날짜·시간으로 설정. `StartTime`을 30일 전으로 설정. `EndTime` 생략. 매일 `StartTime`과 `AvailableSince`를 1일씩 앞당김 |
| Package Usage Summaries | 패키지당 1회 일별 쿼리 | 패키지당 1회 일별 catch-up 쿼리. `AvailableSince`를 마지막 정기 쿼리 날짜·시간으로 설정. `StartTime`을 이전 달의 1일로 설정. `EndTime` 생략. 매일 `AvailableSince`를 1일씩 앞당김. 매달 `StartTime`을 이전 달의 1일로 앞당김 |
| Package Usage Logs | 하루 24시간에 걸쳐 분산된 여러 세그먼트화된 일별 자동화 쿼리 생성. 관리 패키지별, 시간 단위로 요청 분할 | 하루 2단계 catch-up 쿼리 생성. 2일 전 데이터를 수집하는 패키지당 1회 catch-up 쿼리. 3~30일 전 데이터를 수집하는 두 번째 catch-up 쿼리 |

**예시 (수십 개 관리 패키지, large-sized):** 전 세계 모든 Salesforce 인스턴스에서 패키지 사용. 동시에 쿼리를 실행해 12시간 기간을 커버하고 레이어드 catch-up 쿼리 계획으로 전 세계 모든 인스턴스의 데이터를 캡처.

3월 31일 18:00 UTC — 정기 쿼리 (parquet + snappy):

```bash
# Package 1 — 상반기 (0:00-12:00)
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-04-01T00:00:00Z EndTime=2021-04-01T12:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=parquet FileCompression=snappy"

# Package 1 — 하반기 (12:00-00:00)
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-04-01T12:00:00Z EndTime=2021-04-02T00:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=parquet FileCompression=snappy"
```

4월 1일 A — 2일 전 Catch-Up 쿼리:

```bash
# Package 1 — 2 Days Ago Catch-Up
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-31T00:00:00Z EndTime=2021-04-01T00:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=parquet FileCompression=snappy \
AvailableSince=2020-04-01T18:00:00Z"
```

4월 1일 B — 3~30일 전 Catch-Up 쿼리:

```bash
# Package 1 — 3 to 30 Days Ago Catch-Up
sf data create record --sobjecttype AppAnalyticsQueryRequest \
  --values "StartTime=2021-03-02T00:00:00Z EndTime=2021-03-31T00:00:00Z \
DataType=PackageUsageLog PackageIds=0336XXXXXXXXXX FileType=parquet FileCompression=snappy \
AvailableSince=2020-04-01T18:00:00Z"
```

---

## Where Do I Go for More Information?

질문이 있을 때:
- 할당된 AppExchange 파트너 Account Manager(PAM) 또는 AppExchange Technical Evangelist(TE)에게 연락한다.
- 그렇지 않으면 Partner Community에 게시해 ISV TE Experts - Partner Intelligence Chatter 그룹에 질문한다.

---

## 관련 노트
- [[2GP — App Analytics Part 1: Overview & Setup]]
- [[2GP — App Analytics Part 3: Data Types & Schemas]]
- [[2GP — App Analytics Part 4: Developer Cookbook]]
- [[2GP — LMA Part 1 Get Started]]
- [[2GP — Best Practices]]
