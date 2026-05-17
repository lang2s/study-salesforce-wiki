---
tags: [apex, formula, formulaeval, dynamic-formula, expression-evaluation]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [FormulaEval, Formula.builder, 수식 평가, 동적 수식, formula evaluation Apex]
---

# FormulaEval Namespace

> SObject·Apex 객체에 대해 동적 수식을 Apex에서 직접 평가. 불필요한 DML 없이 포뮬러 필드 재계산 가능.

---

## 기본 사용 패턴 — SObject 수식 평가

```apex
// 1. FormulaInstance 빌드
FormulaEval.FormulaInstance ff = Formula.builder()
    .withType(Schema.Account.class)                          // SObject 컨텍스트
    .withReturnType(FormulaEval.FormulaReturnType.STRING)    // 반환 타입
    .withFormula('Name & " (" & Website & ")"')             // 수식 표현식
    .build();

// 2. 수식에서 참조하는 필드 이름 조회 → 동적 SOQL 생성에 활용
Set<String> fieldNames = ff.getReferencedFields();
String queryStr = 'SELECT ' + String.join(fieldNames, ', ') + ' FROM Account LIMIT 10';
List<Account> accounts = Database.query(queryStr);

// 3. 평가
for (Account acc : accounts) {
    String result = (String) ff.evaluate(acc);
    System.debug(result);  // => "Acme (https://acme.com)"
}
```

---

## Apex 클래스 컨텍스트

```apex
// 컨텍스트 클래스는 반드시 global + 참조 필드도 global
global class Vessel {
    global Integer lengthFt;
    global String  name;
}

FormulaEval.FormulaInstance isLarge = Formula.builder()
    .withType(Vessel.class)
    .withReturnType(FormulaEval.FormulaReturnType.BOOLEAN)
    .withFormula('lengthFt >= 100')
    .build();

Vessel v = new Vessel();
v.lengthFt = 120;
Boolean result = (Boolean) isLarge.evaluate(v);  // => true
```

---

## 템플릿 모드

```apex
// parseAsTemplate(true) → {!field} 병합 구문 사용
// withReturnType는 반드시 STRING
FormulaEval.FormulaInstance tpl = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('{!Name} ({!Website})')
    .parseAsTemplate(true)
    .build();

Account acc = [SELECT Name, Website FROM Account LIMIT 1];
String output = (String) tpl.evaluate(acc);
// => "Acme Corp (https://acme.com)"  —  & 연산자 없이 동일 결과
```

---

## 글로벌 변수 포함

```apex
// $Label, $User, $Organization 등 전역 변수 참조 시 withGlobalVariables() 필요
FormulaEval.FormulaInstance label = Formula.builder()
    .withType(Schema.Account.class)
    .withReturnType(FormulaEval.FormulaReturnType.STRING)
    .withFormula('$Label.MyCustomLabel')
    .withGlobalVariables(new List<FormulaEval.FormulaGlobal>{
        FormulaEval.FormulaGlobal.LABEL
    })
    .build();
```

---

## 수치 null → 0 처리

```apex
FormulaEval.FormulaInstance calc = Formula.builder()
    .withType(Schema.Opportunity.class)
    .withReturnType(FormulaEval.FormulaReturnType.DECIMAL)
    .withFormula('Amount + Discount__c')
    .treatNumericNullAsZero(true)   // null 필드를 0으로 계산
    .build();
```

---

## FormulaBuilder 메서드 요약

| 메서드 | 필수 | 설명 |
|---|:---:|---|
| `withType(Schema.SObjectType)` | 선택 | SObject 컨텍스트 |
| `withType(System.Type)` | 선택 | Apex 클래스 컨텍스트 |
| `withReturnType(FormulaReturnType)` | **필수** | 반환 타입 지정 |
| `withFormula(String)` | **필수** | 수식 표현식 |
| `parseAsTemplate(Boolean)` | 선택 | `{!field}` 병합 구문 모드 |
| `treatNumericNullAsZero(Boolean)` | 선택 | 수치 null → 0 |
| `withGlobalVariables(List<FormulaGlobal>)` | 선택 | `$Label`, `$User` 등 전역 변수 |
| `build()` | **필수** | 검증 후 FormulaInstance 반환 |

---

## FormulaReturnType 열거값

| 값 | Apex 타입 |
|---|---|
| `BOOLEAN` | Boolean |
| `DATE` | Date |
| `DATETIME` | DateTime |
| `DECIMAL` | Decimal |
| `DOUBLE` | Double |
| `ID` | Id |
| `INTEGER` | Integer |
| `LONG` | Long |
| `STRING` | String |
| `TIME` | Time |

---

## FormulaGlobal 열거값

| 값 | 참조 대상 |
|---|---|
| `CUSTOMMETADATA` | 커스텀 메타데이터 레코드 |
| `LABEL` | `$Label` — 커스텀 레이블 |
| `ORGANIZATION` | `$Organization` — 조직 정보 |
| `PERMISSION` | `$Permission` — 커스텀 퍼미션 |
| `PROFILE` | `$Profile` — 현재 사용자 프로파일 |
| `SETUP` | `$Setup` — 계층형 커스텀 설정 |
| `SYSTEM` | `$System` — 날짜/시간 기준값 |
| `USER` | `$User` — 현재 사용자 정보 |
| `USERROLE` | `$UserRole` — 현재 사용자 롤 |

---

## 관련 노트

- [[SOQL 패턴]] — getReferencedFields() 결과로 동적 SOQL 작성
- [[Dynamic SOQL]] — queryWithBinds와 함께 안전한 동적 쿼리
- [[Schema Namespace 상세]] — SObjectType·FieldDescribe API
