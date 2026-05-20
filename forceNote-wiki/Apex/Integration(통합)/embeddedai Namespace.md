---
tags: [apex, embeddedai, namespace, ai, record-representation, apex-map, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — embeddedai Namespace (doc p.2859~2865)
created: 2026-05-20
aliases: [embeddedai Namespace, ApexMap, RecordApexRepresentation, embedded AI, AI 레코드 표현, embeddedai.ApexMap, embeddedai.RecordApexRepresentation]
---

# embeddedai Namespace

> Apex에서 구조화된 레코드 데이터를 Embedded AI 서비스에 전달하기 위한 직렬화 클래스 2개 제공 — `ApexMap`(키-값 쌍)과 `RecordApexRepresentation`(레코드 + 관련 레코드 계층 구조).

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `ApexMap` | 문자열 키-값 쌍 — 레코드 필드 데이터를 JSON으로 변환 |
| `RecordApexRepresentation` | 레코드 + 관련 레코드 계층 구조 — AI 서비스 통합용 직렬화 표현 |

---

## ApexMap

레코드의 개별 필드 값을 키-값 쌍으로 표현한다. `RecordApexRepresentation.recordData` 목록의 원소로 사용된다.

### 생성자

```apex
// 키와 값을 직접 지정
public ApexMap(String key, String value)

// 빈 인스턴스 — 이후 프로퍼티로 설정
public ApexMap()
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `key` | `String` | 필드명 또는 키 문자열 |
| `value` | `String` | 필드값 (문자열로 변환) |

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `toString()` | `String` | 객체의 문자열 표현 반환 |

### 코드 예시

```apex
// 생성자로 초기화
embeddedai.ApexMap field1 = new embeddedai.ApexMap('Subject', 'Server outage');
embeddedai.ApexMap field2 = new embeddedai.ApexMap('Status', 'Open');

// 빈 생성자 후 프로퍼티 설정
embeddedai.ApexMap field3 = new embeddedai.ApexMap();
field3.key   = 'Priority';
field3.value = 'High';
```

---

## RecordApexRepresentation

레코드 본체 + 관련 레코드(자기 참조 목록)를 계층적으로 표현한다. AI 서비스에 전달할 JSON 직렬화 구조체로 사용된다.

### 생성자

```apex
// 모든 필드를 한 번에 초기화
public RecordApexRepresentation(
    String objectType,
    List<embeddedai.ApexMap> recordData,
    List<embeddedai.RecordApexRepresentation> relatedRecordData
)

// 빈 인스턴스
public RecordApexRepresentation()
```

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `objectType` | `String` | SObject API 이름 (`Account`, `Case` 등) |
| `recordData` | `List<embeddedai.ApexMap>` | 레코드 필드 데이터 (키-값 쌍 목록) |
| `relatedRecordData` | `List<embeddedai.RecordApexRepresentation>` | 관련 레코드 목록 (재귀 구조) |

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `toRecordApexRep(String jsonString)` | `embeddedai.RecordApexRepresentation` | JSON 문자열을 파싱해 인스턴스 반환 (static) |
| `toString()` | `String` | 객체 및 중첩 관련 레코드를 JSON 문자열로 직렬화 |

---

## 실전 예제 — Case 레코드 + 관련 Contact를 AI 서비스에 전달

```apex
// 1. 관련 레코드(Contact) 구성
List<embeddedai.ApexMap> contactFields = new List<embeddedai.ApexMap>{
    new embeddedai.ApexMap('Name',  'Jane Doe'),
    new embeddedai.ApexMap('Email', 'jane@example.com')
};
embeddedai.RecordApexRepresentation contactRep =
    new embeddedai.RecordApexRepresentation('Contact', contactFields, null);

// 2. 본 레코드(Case) 구성 + 관련 레코드 첨부
List<embeddedai.ApexMap> caseFields = new List<embeddedai.ApexMap>{
    new embeddedai.ApexMap('Subject',  'Server outage'),
    new embeddedai.ApexMap('Status',   'Open'),
    new embeddedai.ApexMap('Priority', 'High')
};
List<embeddedai.RecordApexRepresentation> related =
    new List<embeddedai.RecordApexRepresentation>{ contactRep };

embeddedai.RecordApexRepresentation caseRep =
    new embeddedai.RecordApexRepresentation('Case', caseFields, related);

// 3. JSON 직렬화 → AI 서비스에 전달
String jsonPayload = caseRep.toString();

// 4. JSON 문자열에서 복원
embeddedai.RecordApexRepresentation restored =
    embeddedai.RecordApexRepresentation.toRecordApexRep(jsonPayload);
```

---

## 관련 노트

- [[ConnectApi Namespace 개요]] — EinsteinLLM 그룹: AI 서비스 연동 ConnectApi 클래스
- [[Context Namespace]] — Industries Cloud Context Service: 비즈니스 컨텍스트 데이터 공유
