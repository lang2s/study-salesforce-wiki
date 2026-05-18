---
tags: [apex, dataweave, namespace, json, xml, csv, transformation, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — DataWeave Namespace (p.2841~2844)
created: 2026-05-18
aliases: [DataWeave Namespace, DataWeave in Apex, DataWeave.Script, DataWeave.Result, createScript, execute, dwl, 데이터위브, JSON 변환 Apex, XML 변환 Apex]
---

# DataWeave Namespace

> Apex에서 DataWeave 2.0 스크립트를 실행해 JSON·XML·CSV를 변환하는 네임스페이스. Winter '24에 GA.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `DataWeave.Script` | `.dwl` 스크립트 로드 및 실행 |
| `DataWeave.Result` | 스크립트 실행 결과 반환 |

---

## 기본 패턴

### 1. DataWeave 스크립트 배포 (`.dwl` 파일)

```dwl
%dw 2.0
input records application/java
output application/json
---
{
    users: records map(record) -> {
        firstName: record.FirstName,
        lastName: record.LastName
    }
}
```

> org에 `ContactsToJson.dwl`로 배포 후 Apex에서 호출한다.

### 2. Apex에서 스크립트 실행

```apex
// SOQL로 데이터 조회
List<Contact> data = [SELECT FirstName, LastName FROM Contact
                      WHERE LastName != null LIMIT 5];

// 입력 파라미터 맵 구성 (키 = dwl input 지시어 이름)
Map<String, Object> args = new Map<String, Object>{ 'records' => data };

// 스크립트 로드 → 실행 → 결과 추출
DataWeave.Script script = DataWeave.Script.createScript('ContactsToJson');
DataWeave.Result result = script.execute(args);
String jsonOutput = result.getValueAsString();
```

---

## Script 클래스

### Script 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `createScript(String scriptName)` | `DataWeave.Script` | org 기본 네임스페이스에서 `.dwl` 로드 |
| `createScript(String namespace, String scriptName)` | `DataWeave.Script` | 지정 네임스페이스에서 `.dwl` 로드 |
| `execute(Map<String,Object> parameters)` | `DataWeave.Result` | 스크립트 실행 (parameters = input 매핑) |
| `toString()` | `String` | 스크립트 이름 반환 |

#### createScript 파라미터 상세

```apex
// 기본: org 네임스페이스에서 로드
DataWeave.Script s = DataWeave.Script.createScript('MyTransform');

// 네임스페이스 지정:
// namespace = null → 호출 클래스의 네임스페이스 사용
// namespace = "" (빈 문자열) → org 네임스페이스 사용
DataWeave.Script s2 = DataWeave.Script.createScript('myPackageNS', 'MyTransform');
```

---

## Result 클래스

### Result 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getValue()` | `Object` | 변환 결과를 Object로 반환 (캐스트 필요) |
| `getValueAsString()` | `String` | 변환 결과를 String으로 반환 |

```apex
DataWeave.Result result = script.execute(args);

// JSON/XML/CSV 등 문자열 출력
String textOutput = result.getValueAsString();

// Map, List 등 구조화 출력
Map<String, Object> mapOutput = (Map<String, Object>) result.getValue();
```

---

## 실전 패턴 — XML 변환

```dwl
%dw 2.0
input payload application/java
output application/xml
---
{
    accounts: {
        (payload map (acct) -> {
            account @(id: acct.Id): {
                name: acct.Name,
                industry: acct.Industry
            }
        })
    }
}
```

```apex
List<Account> accounts = [SELECT Id, Name, Industry FROM Account LIMIT 10];
Map<String, Object> args = new Map<String, Object>{ 'payload' => accounts };
DataWeave.Script script = DataWeave.Script.createScript('AccountsToXml');
String xmlOutput = script.execute(args).getValueAsString();
```

---

## 제약사항

- `.dwl` 파일은 Apex 호출 전에 org에 Metadata로 배포되어 있어야 한다
- DataWeave 스크립트는 `DataWeave Scripts` Metadata 타입으로 패키징
- Apex 거버너 한도(힙 메모리, CPU 시간)가 스크립트 실행에 적용됨

---

## 관련 노트

- [[Dom Namespace]] — XML 파싱·생성 (DataWeave 없이 직접 처리)
- [[Winter '24]] — DataWeave in Apex GA 릴리즈
- [[RestClient 패턴]] — 외부 API 응답을 DataWeave로 변환하는 패턴
