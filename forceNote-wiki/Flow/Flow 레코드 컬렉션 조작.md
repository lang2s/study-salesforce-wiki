---
tags: [flow, collection, invocable, pattern]
source: automation-components/src-collections
created: 2026-05-17
aliases: [Flow 컬렉션, AggregateRecordList, FilterRecords, DedupeRecordList, Flow에서 리스트 조작]
---

# Flow 레코드 컬렉션 조작

> Flow 내에서 레코드 컬렉션(List)을 다루는 Invocable Action 패턴 모음. SOQL 없이 Flow 안에서 필터·집계·정렬·변환을 처리한다.

---

## 개념 — SOQL 없이 Flow 안에서 리스트를 조작한다

Flow의 Get Records 요소는 데이터를 가져오지만, 가져온 컬렉션에서 집계·필터·정렬을 추가로 수행하려면 루프 + Decision 요소를 반복 조합해야 한다. 이는 Flow가 커질수록 유지보수하기 어렵다.

이 노트의 액션들은 Apex `@InvocableMethod`로 구현된 **Invocable Action** 집합으로, Flow 캔버스에서 단일 액션 요소 하나로 집계·필터·중복 제거·병합 등을 처리한다. SOQL WHERE절을 다시 작성하거나 Flow 루프를 중첩하지 않아도 된다.

---

## 언제 쓰나

| 상황 | 권장 접근 |
|---|---|
| 이미 가져온 컬렉션에서 일부만 추출 | FilterRecordsWithFieldValue |
| 두 Get Records 결과를 하나로 합쳐야 할 때 | JoinRecordLists |
| Amount 합계·평균을 Flow 변수에 저장 | AggregateRecordList (SUM / AVERAGE) |
| 같은 필드값이 중복되는 레코드 제거 | DedupeRecordList |
| 여러 필드를 일괄로 동일한 값으로 세팅 | UpdateRecordListWithMap |
| SOQL에서 정밀 필터가 가능한 경우 | Get Records + SOQL WHERE 사용 권장 |

---

> [!note] 공통 구조
> 모든 Collections 액션은 `bulkInvoke` / `invoke` 분리 구조를 따른다. 상세 → [[@InvocableMethod 패턴]]

---

## 액션 레퍼런스

### Aggregate — 집계 연산 (SUM / AVERAGE / MIN / MAX)

```apex
// 입력: collection(필수), fieldName(필수), operation(필수), defaultValueForNullFields
// 출력: decimalResult, stringResult

// operation 열거형: SUM, AVERAGE, MIN, MAX
aggregateOperation = Operation.valueOf(input.operation); // 잘못된 값이면 예외
Decimal.valueOf(String.valueOf(record.get(fieldName))); // 필드값 → Decimal 변환
```

**Flow 설정 예시:**
- collection: `{!Get_Opportunities}` (Opportunity 목록)
- fieldName: `Amount`
- operation: `SUM`
- 출력 `decimalResult` → 변수에 저장 후 활용

---

### Filter — 필드값 기준 필터링

```apex
// 입력: collection(필수), fieldName(필수), fieldValue(필수)
// 출력: collection, totalRecordCount, filteredRecordCount

String fieldValue = String.valueOf(record.get(fieldName));
if (fieldValue == targetFieldValue) {
    filteredCollection.add(record);
}
```

> [!warning] 문자열 비교만 지원
> `String.valueOf()`로 변환 후 비교하므로 숫자·날짜도 문자열로 비교된다.
> 정밀한 타입 비교가 필요하면 SOQL WHERE를 활용할 것.

---

### Dedupe — 중복 제거

```apex
// 입력: collection(필수), fieldName(필수)
// 출력: collection (중복 제거된 목록)

Map<String, SObject> uniqueMap = new Map<String, SObject>();
for (SObject record : collection) {
    uniqueMap.put(String.valueOf(record.get(fieldName)), record);
}
// 같은 필드값이 있으면 마지막 레코드가 남는다
```

---

### UpdateRecordListWithMap — JSON 맵으로 일괄 필드 업데이트

```apex
// 입력: collection(필수), keyValuePairs(필수, JSON 문자열)
// 출력: collection

// Flow에서 keyValuePairs 값 예시:
// {"Rating":"Hot","NumberOfEmployees":1000,"Industry":"Technology"}

Map<String, Object> keyValuePairs =
    (Map<String, Object>) JSON.deserializeUntyped(input.keyValuePairs);

for (SObject record : collection) {
    for (String field : keyValuePairs.keySet()) {
        record.put(field, keyValuePairs.get(field));  // 동적 필드 업데이트
    }
}
```

> [!tip] DML 없이 메모리 상 업데이트
> 이 액션 자체는 DML을 하지 않는다. 이후 Update Records 요소로 저장해야 한다.

---

### ExtractStrings — 특정 필드값 추출 → 문자열 목록/조인

```apex
// 입력: collection(필수), fieldName(필수), removeDuplicates(Boolean), joinDelimiter(String, 기본값 ',')
// 출력: values(List<String>), joinedValues(String)

// 활용 예: Id 목록을 쉼표로 조인해 이메일 수신자 목록 생성
// joinedValues → "user1@corp.com,user2@corp.com"
```

---

### AddOrInsertRecord — 특정 위치에 레코드 삽입

```apex
// 입력: collection(필수), record(필수), index(선택 — null이면 맨 뒤)
// 출력: collection

if (input.index == null) {
    clonedCollection.add(record);
} else {
    clonedCollection.add(input.index, record);
}
```

---

### 나머지 액션 요약

| 액션 | 입력 | 출력 | 핵심 |
|---|---|---|---|
| CloneRecordList | collection | collection | `List.clone()` 얕은 복사 |
| GetRecordAtIndex | collection, index | record | `collection[index]` 직접 접근 |
| JoinRecordLists | collection1, collection2 | collection | `List.addAll()` 순차 병합 |
| RemoveRecord | collection, index | collection | `List.remove(index)` |

---

## 비교표 — 언제 어떤 액션을

| 상황 | 액션 |
|---|---|
| 금액/수량 합계 | AggregateRecordList (SUM) |
| 특정 상태 레코드만 추출 | FilterRecordsWithFieldValue |
| 동일 고객 중복 제거 | DedupeRecordList |
| 여러 필드 일괄 세팅 | UpdateRecordListWithMap |
| ID 목록을 쉼표 문자열로 | ExtractStringsFromRecords |
| 두 쿼리 결과 합치기 | JoinRecordLists |

---

## 주의사항

- **문자열 비교 전용 필터**: FilterRecordsWithFieldValue는 모든 필드값을 `String.valueOf()`로 변환 후 비교한다. 숫자·날짜 타입의 정밀 비교(예: `Amount > 10000`)가 필요하면 SOQL WHERE를 써야 한다.
- **Dedupe 마지막 레코드 유지**: 동일 필드값이 여러 개 있으면 **마지막**으로 처리된 레코드만 남는다. 정렬 순서에 따라 결과가 달라질 수 있다.
- **UpdateRecordListWithMap은 DML 아님**: 메모리 상 업데이트만 수행한다. 변경 내용을 실제 저장하려면 후속 Update Records 요소가 반드시 필요하다.
- **Bulk 호환성**: 모든 액션은 `bulkInvoke` / `invoke` 분리 구조를 사용하므로 대량 레코드 처리 시에도 동작하지만, 매우 큰 컬렉션(수천 건)은 Flow CPU 시간 제한에 걸릴 수 있다.

---

## 관련 노트

- [[@InvocableMethod 패턴]] — Invocable Action 구조 설계
- [[Flow 데이터 & 보안 액션]] — ExecuteSOQLQuery, SaveRecordsAsync
- [[Flow 종류와 변수]] — Flow 변수 설정 (isInput/isOutput)
