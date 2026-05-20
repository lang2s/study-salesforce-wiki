---
tags: [apex, ise_bots_apex, namespace, bot, dynamic-menu, einstein-bot, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — ise_bots_apex Namespace (doc p.2921~2924)
created: 2026-05-20
aliases: [ise_bots_apex Namespace, DynamicMenuItem, Einstein Bot 동적 메뉴, ise_bots_apex.DynamicMenuItem, 봇 동적 메뉴 Apex]
---

# ise_bots_apex Namespace

> Einstein Bot에서 동적 메뉴 항목을 Apex로 생성·관리하기 위한 네임스페이스. 사용자 입력·컨텍스트·오브젝트 데이터에 따라 적응하는 메뉴 항목을 정의한다.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `DynamicMenuItem` | 단일 동적 메뉴 항목의 식별자·라벨·요약·정렬 정보를 보유하는 데이터 클래스 |

---

## DynamicMenuItem 클래스

봇 대화 중 사용자에게 제시할 동적 메뉴 항목 하나를 표현한다. 설계 시점(design-time) 메타데이터 프로퍼티와 런타임 값 프로퍼티가 쌍으로 구성된다.

### 프로퍼티 전체

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `EntityId` | `String` | 관련 Salesforce 오브젝트의 ID 필드 API 이름 (설계 시점) |
| `EntityIdValue` | `String` | 런타임 ID 값 |
| `EntityName` | `String` | 오브젝트 API 이름 또는 라벨 (예: `Case`, `Contact`, `Service__c`) |
| `EntityNameValue` | `String` | 런타임 특정 오브젝트 인스턴스 이름 |
| `Label` | `String` | 봇 메뉴에서 항목 표시에 사용하는 라벨 (설계 시점) |
| `LabelValue` | `String` | 런타임 라벨 값 |
| `SummaryTextWithFormula` | `String` | 요약 텍스트 구조 정의 수식 또는 문자열 (설계 시점) |
| `SummaryTextWithFormulaValue` | `String` | 수식과 오브젝트 데이터를 기반으로 한 런타임 요약 문자열 |
| `sortByDate` | `Date` | 메뉴 항목 정렬 기준 Date/Datetime 필드 API 이름 (설계 시점) |
| `sortByDateValue` | `Date` | 런타임에 메뉴 항목을 시간순으로 정렬하는 Date 값 |

모든 프로퍼티는 `public <Type> <PropertyName> {get; set;}` 시그니처를 가진다.

### 코드 예시

```apex
// DynamicMenuItem 생성 — Case 목록 메뉴 항목
ise_bots_apex.DynamicMenuItem item = new ise_bots_apex.DynamicMenuItem();

// 설계 시점 메타데이터 (봇 플로우 설정)
item.EntityId   = 'Id';
item.EntityName = 'Case';
item.Label      = 'Case Number: {!CaseNumber}';
item.SummaryTextWithFormula = 'Subject: {!Subject} — Status: {!Status}';
item.sortByDate = Date.today();    // Date 타입 주의 (String 아님)

// 런타임 데이터 (SOQL 결과로 채움)
Case c = [SELECT Id, CaseNumber, Subject, Status FROM Case LIMIT 1];
item.EntityIdValue            = c.Id;
item.EntityNameValue          = c.CaseNumber;
item.LabelValue               = 'Case #' + c.CaseNumber;
item.SummaryTextWithFormulaValue = 'Subject: ' + c.Subject;
item.sortByDateValue          = Date.today();

// 여러 항목을 List로 반환 (Apex Action에서 봇 플로우로 전달)
List<ise_bots_apex.DynamicMenuItem> menuItems =
    new List<ise_bots_apex.DynamicMenuItem>{ item };
```

### 설계 시점 vs 런타임 프로퍼티 구조

| 설계 시점 프로퍼티 | 런타임 값 프로퍼티 | 의미 |
|---|---|---|
| `EntityId` | `EntityIdValue` | 오브젝트 ID 필드 이름 / 실제 ID 값 |
| `EntityName` | `EntityNameValue` | 오브젝트 API 이름 / 특정 인스턴스 이름 |
| `Label` | `LabelValue` | 라벨 템플릿 / 렌더링된 라벨 |
| `SummaryTextWithFormula` | `SummaryTextWithFormulaValue` | 요약 수식 / 계산된 요약 텍스트 |
| `sortByDate` | `sortByDateValue` | 정렬 필드 이름 / 실제 정렬 Date 값 |

---

## 관련 노트

- [[Invocable Namespace]] — Apex에서 Flow/Bot Action 동적 호출
- [[ConnectApi Namespace 개요]] — EinsteinLLM 그룹 AI 연동 클래스
