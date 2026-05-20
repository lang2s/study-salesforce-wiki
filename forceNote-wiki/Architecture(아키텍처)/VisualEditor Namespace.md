---
tags: [apex, namespace, visualeditor, lightning-app-builder, dynamic-picklist, architecture]
source: salesforce_apex_reference_guide.pdf p.4462-4475
created: 2026-05-20
aliases: [VisualEditor, DynamicPickList, DynamicPickListRows, DataRow, DesignTimePageContext, 동적 피클리스트, 앱 빌더 피클리스트]
---

# VisualEditor Namespace

> Lightning App Builder 컴포넌트 속성에 동적 피클리스트를 제공하는 Apex 네임스페이스 — `VisualEditor.DynamicPickList`를 상속한 클래스를 Aura design 파일에 연결하면 App Builder에서 커스텀 옵션 목록을 표시한다.

---

## 구성 클래스 요약

| 클래스 | 역할 |
|---|---|
| `DataRow` | 피클리스트 한 행: label(표시명) + value(실제값) + selected(기본 선택 여부) |
| `DesignTimePageContext` | 컴포넌트가 배치된 페이지 컨텍스트 정보 (entityName, pageType) |
| `DynamicPickList` | **abstract** — 상속 후 `getDefaultValue()` + `getValues()` 구현 |
| `DynamicPickListRows` | DataRow 목록 래퍼 + `containsAllRows` 플래그 |

---

## DataRow Class

피클리스트 한 행을 나타내는 클래스. `label`은 App Builder UI에 표시되고, `value`는 컴포넌트 속성에 실제 저장되는 값이다.

### 생성자

```apex
public DataRow(String label, Object value, Boolean selected)
public DataRow(String label, Object value)           // selected = false 기본값
```

### 메서드

```apex
public Object  clone()
public Integer compareTo(VisualEditor.DataRow o)     // 0 / 양수 / 음수
public String  getLabel()
public Object  getValue()
public Boolean isSelected()
```

### 예제

```apex
VisualEditor.DataRow row1 = new VisualEditor.DataRow('빨강', 'RED');          // 미선택
VisualEditor.DataRow row2 = new VisualEditor.DataRow('파랑', 'BLUE', true);   // 기본 선택
```

---

## DesignTimePageContext Class

컴포넌트가 배치된 Lightning 페이지의 컨텍스트 정보를 보유한다. `DynamicPickList` 상속 클래스 생성자에서 파라미터로 받아 저장하면, `getValues()` 안에서 페이지 유형이나 오브젝트에 따라 피클리스트 옵션을 필터링할 수 있다.

### 속성

```apex
public String entityName {get; set;}  // 오브젝트 페이지의 sObject API명 (ex. 'Account')
                                      // Record Page가 아니면 null
public String pageType {get; set;}    // 'HomePage' | 'AppPage' | 'RecordPage'
```

### 메서드

```apex
public Object clone()
```

---

## DynamicPickList Class (abstract)

App Builder 컴포넌트 속성의 동적 피클리스트 소스. 이 클래스를 **상속**하여 `getDefaultValue()`와 `getValues()`를 재정의하고, Aura design 파일에서 `datasource="apex://ClassName"` 으로 참조한다.

### 메서드

```apex
public Object                         clone()
public VisualEditor.DataRow           getDefaultValue()            // 기본 선택 행
public String                         getLabel(Object attributeValue)
public VisualEditor.DynamicPickListRows getValues()                // 전체 옵션 목록
public Boolean                        isValid(Object attributeValue)
```

### Aura design 파일 연결

```xml
<!-- MyComponent.design -->
<design:component>
    <design:attribute name="colorChoice" datasource="apex://MyCustomPickList"/>
</design:component>
```

---

## DynamicPickListRows Class

`DataRow` 목록의 래퍼 클래스. `containsAllRows` 플래그로 타입-어헤드 검색 동작을 제어한다.

**`containsAllRows`:**
- `true` → 전체 값을 App Builder에 넘겨 클라이언트 측에서 필터
- `false`(기본) → 처음 200개만 표시

### 생성자

```apex
public DynamicPickListRows(List<VisualEditor.DataRow> rows, Boolean containsAllRows)
public DynamicPickListRows(List<VisualEditor.DataRow> rows)   // containsAllRows = false
public DynamicPickListRows()                                   // 빈 목록, addRow로 추가
```

### 메서드

```apex
public void                      addAllRows(List<VisualEditor.DataRow> rows)
public void                      addRow(VisualEditor.DataRow row)
public Object                    clone()
public Boolean                   containsAllRows()
public VisualEditor.DataRow      get(Integer i)
public List<VisualEditor.DataRow> getDataRows()
public void                      setContainsAllRows(Boolean containsAllRows)
public Integer                   size()
public void                      sort()                        // DataRow.compareTo 기준 정렬
```

---

## 통합 사용 예제

`DesignTimePageContext`를 활용해 페이지 유형별로 옵션을 달리 제공하는 패턴.

```apex
global class MyCustomPickList extends VisualEditor.DynamicPickList {

    VisualEditor.DesignTimePageContext context;

    global MyCustomPickList(VisualEditor.DesignTimePageContext context) {
        this.context = context;
    }

    global override VisualEditor.DataRow getDefaultValue() {
        return new VisualEditor.DataRow('red', 'RED');
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DataRow value1 = new VisualEditor.DataRow('red',    'RED');
        VisualEditor.DataRow value2 = new VisualEditor.DataRow('yellow', 'YELLOW');

        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();
        myValues.addRow(value1);
        myValues.addRow(value2);

        if (context.pageType == 'HomePage') {
            myValues.addRow(new VisualEditor.DataRow('purple', 'PURPLE'));
        }
        return myValues;
    }
}
```

**연결 단계:**
1. 위 클래스를 Apex로 배포
2. Aura 컴포넌트 `.design` 파일에서 `datasource="apex://MyCustomPickList"` 지정
3. Lightning App Builder에서 컴포넌트 속성 편집 시 커스텀 피클리스트 표시

---

## 관련 노트

- [[ApexPages Namespace]] — Visualforce 컨트롤러 레퍼런스
- [[AppLauncher Namespace]] — App Launcher 가시성·정렬 제어
- [[Schema Namespace 상세]] — DescribeSObjectResult/DescribeFieldResult
- [[Apex MOC]]
