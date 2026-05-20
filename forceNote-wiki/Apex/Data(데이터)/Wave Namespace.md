---
tags: [apex, namespace, wave, crm-analytics, saql, data]
source: salesforce_apex_reference_guide.pdf p.4476-4492
created: 2026-05-20
aliases: [Wave, wave namespace, CRM Analytics SDK Apex, SAQL 빌더, QueryBuilder, QueryNode, ProjectionNode, Templates, TemplatesSearchOptions]
---

# Wave Namespace

> CRM Analytics Analytics SDK — Apex에서 SAQL 쿼리를 프로그래밍적으로 빌드·실행하고, CRM Analytics 템플릿을 조회하는 클래스 모음.

---

## 구성 클래스 요약

| 클래스 | 역할 |
|---|---|
| `QueryBuilder` | SAQL 쿼리 진입점 — 데이터셋 로드, 카운트, 투영, 유니온, 코그룹 (static 전용) |
| `QueryNode` | 쿼리 각 노드 정의 — foreach/group/order/cap/filter/execute |
| `ProjectionNode` | 집계 함수 체이닝 — sum/avg/min/max/count/unique/alias |
| `Templates` | CRM Analytics 템플릿 조회 (static 전용) |
| `TemplatesSearchOptions` | 템플릿 컬렉션 필터 옵션 (type/options/filterGroup) |

---

## QueryBuilder Class

SAQL 쿼리를 시작하는 진입점. 모든 메서드가 `static`이며 `QueryNode` 또는 `ProjectionNode`를 반환해 메서드 체이닝으로 쿼리를 조립한다.

### 메서드

```apex
public static wave.QueryNode      load(String datasetID, String datasetVersionID)
// 데이터셋에서 스트림 로드 — 모든 쿼리의 시작점

public static wave.ProjectionNode count()
// 조건에 맞는 행 수 계산

public static wave.ProjectionNode get(String proj)
// 특정 컬럼 선택 (투영)

global static Wave.QueryNode      union(List<Wave.QueryNode> unionNodes)
// 여러 결과 세트를 하나로 합산

global static Wave.QueryNode      cogroup(List<Wave.QueryNode> cogroupNodes,
                                          List<List<String>> groups)
// 두 스트림을 독립 그룹화 후 나란히 배치 — 양쪽에 존재하는 데이터만 결과에 포함
```

### 예제 — 기본 카운트 쿼리

```apex
Wave.ProjectionNode[] projs = new Wave.ProjectionNode[]{
    Wave.QueryBuilder.count().alias('c')
};
String query = Wave.QueryBuilder.load('datasetId', 'datasetVersionId')
    .group()
    .foreach(projs)
    .build('q');
// SAQL: q = load "datasetId/datasetVersionId";
//       q = group q by all;
//       q = foreach q generate count as c;
```

### 예제 — 복합 집계

```apex
public static void executeApexQuery(String name) {
    Wave.ProjectionNode[] projs = new Wave.ProjectionNode[]{
        Wave.QueryBuilder.get('State').alias('State'),
        Wave.QueryBuilder.get('City').alias('City'),
        Wave.QueryBuilder.get('Revenue').avg().alias('avg_Revenue'),
        Wave.QueryBuilder.get('Revenue').sum().alias('sum_Revenue'),
        Wave.QueryBuilder.count().alias('count')
    };
    ConnectApi.LiteralJson result = Wave.QueryBuilder
        .load('0FbD00000004DSzKAM', '0FcD00000004FEZKA2')
        .group(new String[]{'State', 'City'})
        .foreach(projs)
        .execute('q');
    String response = result.json;
}
```

### 예제 — Union

```apex
Wave.ProjectionNode[] projs = new Wave.ProjectionNode[]{
    Wave.QueryBuilder.get('Name'),
    Wave.QueryBuilder.get('AnnualRevenue').alias('Revenue')
};
Wave.QueryNode nodeOne = Wave.QueryBuilder.load('datasetOne', 'datasetVersionOne').foreach(projs);
Wave.QueryNode nodeTwo = Wave.QueryBuilder.load('datasetTwo', 'datasetVersionTwo').foreach(projs);
String query = Wave.QueryBuilder.union(new List<Wave.QueryNode>{nodeOne, nodeTwo}).build('q');
// SAQL: qa = load "datasetOne/datasetVersionOne"; qa = foreach q generate Name, AnnualRevenue as Revenue;
//       qb = load "datasetTwo/datasetVersionTwo"; qb = foreach q generate Name, AnnualRevenue as Revenue;
//       q = union qa, qb;
```

---

## QueryNode Class

쿼리의 각 단계(노드)를 정의하고 체이닝으로 조립하는 클래스. 마지막에 `build()` 또는 `execute()`로 종료한다.

### 메서드

```apex
public String              build(String streamName)
// SAQL 쿼리 문자열 반환 — streamName 예: 'q'
// 반환: String

public wave.QueryNode      foreach(List<wave.ProjectionNode> projections)
// 각 행에 표현식 집합 적용 (투영)

public wave.QueryNode      group(List<String> groups)
// 특정 데이터셋 속성으로 그룹화

public wave.QueryNode      group()
// group by all — 전체 그룹화

public wave.QueryNode      order(List<List<String>> orders)
// 오름차순·내림차순 정렬 — orders 예: {{'Name','asc'}, {'Revenue','desc'}}
// * PDF 시그니처에 group 표기 오류 있음; 파라미터 설명 기준으로 List<List<String>> 타입

global Wave.QueryNode      cap(Integer cap)
// 반환 행 수 제한

public wave.QueryNode      filter(String filterCondition)
// 단일 필터 조건 (predicate) — 예: filter('Name != \'My Name\'')

public wave.QueryNode      filter(List<String> filterCondition)
// 복수 필터 조건

global ConnectApi.LiteralJson execute(String streamName)
// 쿼리 실행 후 JSON 반환 — result.json으로 SAQL 실행 결과 접근
```

### 예제 — group(groups) + build

```apex
Wave.ProjectionNode[] projs = new Wave.ProjectionNode[]{
    Wave.QueryBuilder.get('Name'),
    Wave.QueryBuilder.get('Revenue').sum().alias('REVENUE_SUM')
};
ConnectApi.LiteralJson result = Wave.QueryBuilder.load('datasetId', 'datasetVersionId')
    .group(new String[]{'Name'})
    .foreach(projs)
    .build('q');
```

### 예제 — group() + execute

```apex
String query = Wave.QueryBuilder.load('datasetId', 'datasetVersionId')
    .group()
    .foreach(projs)
    .execute('q');
```

---

## ProjectionNode Class

집계 함수를 체이닝하거나 출력 컬럼명(alias)을 정의한다. `QueryBuilder.get()` 또는 `QueryBuilder.count()`로 시작한다.

### 메서드 (모두 `public wave.ProjectionNode` 반환)

```apex
public wave.ProjectionNode sum()     // 숫자 필드 합계
public wave.ProjectionNode avg()     // 숫자 필드 평균
public wave.ProjectionNode min()     // 최솟값
public wave.ProjectionNode max()     // 최댓값
public wave.ProjectionNode count()   // 조건 일치 행 수
public wave.ProjectionNode unique()  // 고유값 수
public wave.ProjectionNode alias(String name)  // 출력 컬럼명 지정
```

### 예제

```apex
// 별칭만 지정
Wave.ProjectionNode nameProj = Wave.QueryBuilder.get('State').alias('State');

// 집계 후 별칭
Wave.ProjectionNode revSum  = Wave.QueryBuilder.get('Revenue').sum().alias('sum_Revenue');
Wave.ProjectionNode revAvg  = Wave.QueryBuilder.get('Revenue').avg().alias('avg_Revenue');

// count alias 정의
Wave.ProjectionNode[] projs = new Wave.ProjectionNode[]{
    Wave.QueryBuilder.count().alias('c')
};
```

---

## Templates Class

CRM Analytics 템플릿 컬렉션·개별 템플릿·템플릿 설정을 조회하는 static 전용 클래스. `@AuraEnabled`와 함께 LWC wire 어댑터로도 사용 가능하다.

### 메서드

```apex
public static Map<String,Object> getTemplate(String templateIdOrApiName)
// 단일 템플릿 조회 — 반환: 템플릿 JSON 속성 Map
// 예: String name = (String) Wave.Templates.getTemplate(templateId).get('name');

public static Map<String,Object> getTemplateConfig(String templateIdOrApiName)
// 템플릿 설정 조회 — 반환: 템플릿 설정 JSON 속성 Map
// 예: Map<String,Object> vars = (Map<String,Object>) Wave.Templates.getTemplateConfig(templateId).get('variables');

public static Map<String,Object> getTemplates(Wave.TemplatesSearchOptions options)
// 필터 옵션으로 템플릿 컬렉션 조회

public static Map<String,Object> getTemplates()
// 전체 CRM Analytics 템플릿 조회
```

### 예제 — Apex에서 템플릿 이름 목록 반환

```apex
@AuraEnabled(cacheable=true)
public static List<String> getTemplateNames() {
    Map<String, Object> o = Wave.Templates.getTemplates(new Wave.TemplatesSearchOptions());
    List<Object> templates = (List<Object>) o.get('templates');
    List<String> names = new List<String>();
    for (Object templateObj : templates) {
        names.add((String) ((Map<String, Object>) templateObj).get('name'));
    }
    return names;
}
```

### 예제 — LWC wire 어댑터

```javascript
// lwc.js
import getTemplates from '@salesforce/apex/Wave.Templates.getTemplates';
export default class Templates extends LightningElement {
    @wire(getTemplates, {
        options: {
            type: 'app'  // TemplatesSearchOptions 값 전달
        }
    })
    onTemplates({ data, error }) {
        if (data) {
            console.log('template names=' + data.templates.map(l => l.name).join(', '));
        }
    }
}
```

---

## TemplatesSearchOptions Class

`Wave.Templates.getTemplates()` 호출 시 필터 옵션을 지정하는 클래스.

### 속성

```apex
public String filterGroup {get; set;}
// Connect API 필터 그룹 — ConnectFilterGroupEnum 값 사용
// 예: tsOptions.filterGroup = 'small';

public String options {get; set;}
// 템플릿 가시성 필터 — ConnectWaveTemplateVisibilityOptionsEnum 값
// 유효값: 'CreateApp' | 'ViewOnly' | 'ManageableOnly'
// 예: tsOptions.options = 'ViewOnly';

public String type {get; set;}
// 템플릿 유형 필터 — ConnectWaveTemplateTypeEnum 값
// 유효값: 'app' | 'dashboard' | 'embedded' | 'lens'
// 예: tsOptions.type = 'app';
```

### 예제 — 앱 유형 템플릿 필터

```apex
public static List<String> getAppTemplates() {
    Wave.TemplatesSearchOptions tsOptions = new Wave.TemplatesSearchOptions();
    tsOptions.type = 'app';
    Map<String, Object> o = Wave.Templates.getTemplates(tsOptions);
    List<Object> appTemplates = (List<Object>) o.get('templates');
    List<String> names = new List<String>();
    for (Object templateObj : appTemplates) {
        names.add((String) ((Map<String, Object>) templateObj).get('name'));
    }
    return names;
}
```

---

## 쿼리 조립 패턴 요약

```
QueryBuilder.load()         → QueryNode (스트림 시작)
  .group() / .group(cols)   → QueryNode (그룹화)
  .foreach(projections)     → QueryNode (투영 적용)
  .filter(condition)        → QueryNode (필터)
  .cap(n)                   → QueryNode (결과 수 제한)
  .build(streamName)        → String   (SAQL 문자열)
  .execute(streamName)      → ConnectApi.LiteralJson (실행)

QueryBuilder.count()        → ProjectionNode
QueryBuilder.get('col')     → ProjectionNode
  .sum() / .avg() / .min() / .max() / .count() / .unique()
  .alias('name')            → ProjectionNode (최종 컬럼명)

QueryBuilder.union(nodes)   → QueryNode (여러 스트림 합산)
QueryBuilder.cogroup(nodes, groups) → QueryNode (코그룹)
```

---

## 관련 노트

- [[Reports Namespace]] — ReportManager.runReport/runAsyncReport — 표준 보고서 실행
- [[ConnectApi Namespace 개요]] — ConnectApi.LiteralJson 반환 타입 참조
- [[Datacloud Namespace]] — Duplicate Management API
- [[Apex MOC]]
