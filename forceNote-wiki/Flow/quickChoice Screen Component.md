---
tags: [flow, lwc, screen-component, picklist, render, property-editor, pattern]
source: automation-components/src-ui/quickChoice, quickChoicePropertyEditor
created: 2026-05-17
aliases: [quickChoice, Flow Screen 선택기, render() 멀티 템플릿, Custom Property Editor, Flow Screen LWC 다중 템플릿]
---

# quickChoice Screen Component

> Flow Screen에서 카드·드롭다운·라디오 세 가지 UI로 선택지를 제공하는 LWC 패턴. `render()`로 템플릿을 동적 교체하고, Picklist 또는 직접 입력 목록 두 소스를 지원한다.

---

## 핵심 패턴 1 — render()로 템플릿 동적 교체

HTML 파일 3개를 각각 import 후 `displayMode`에 따라 반환.

```javascript
import templateCards    from './quickChoiceCards.html';
import templatePicklist from './quickChoicePicklist.html';
import templateRadio    from './quickChoiceRadio.html';

render() {
    switch (this.displayMode.toLowerCase()) {
        case 'cards':    return templateCards;
        case 'picklist': return templatePicklist;
        case 'radio':    return templateRadio;
        default: throw new Error(`Unsupported display mode: ${this.displayMode}`);
    }
}
```

> [!tip] render() vs lwc:if
> 조건부 렌더링(`lwc:if`)은 같은 템플릿 안에서 분기. `render()`는 완전히 다른 HTML 파일로 전환 — UI 구조가 크게 다를 때 사용.

---

## 핵심 패턴 2 — inputSource에 따라 옵션 소스 분기

`connectedCallback()`에서 `inputSource` 값으로 분기.

```javascript
connectedCallback() {
    switch (this.inputSource.toLowerCase()) {
        case 'list':
            // 직접 입력한 choiceValues/choiceLabels 배열로 options 구성
            this.options = this.choiceValues.map((value, index) => ({
                value,
                label: this.choiceLabels ? this.choiceLabels[index] : value,
                iconName: this.choiceIcons?.[index]
            }));
            break;

        case 'picklist':
            // getPicklistValues wire 어댑터 활성화를 위해 _recordTypeId 세팅
            this._recordTypeId = this.recordTypeId ?? '012000000000000AAA'; // Master Record Type
            break;
    }
}

// picklist 소스: wire로 자동 로드
@wire(getPicklistValues, {
    recordTypeId: '$_recordTypeId',
    fieldApiName: '$qualifiedPicklistFieldName'  // 형식: 'Account.Type'
})
loadPicklistValues({ error, data }) {
    if (data) {
        this.options = data.values.map((option, index) => ({
            value: option.value,
            label: option.label,
            iconName: this.choiceIcons?.[index]
        }));
        // required=false면 '-- None --' 옵션을 맨 앞에 추가
        if (!this.required) {
            this.options.unshift({ label: '-- None --', value: '' });
        }
    }
}
```

---

## 핵심 패턴 3 — FlowAttributeChangeEvent로 값 전달

```javascript
handleChange(event) {
    const selectedValue = this.isCards()
        ? event.target.value      // 카드: 직접 value 읽기
        : event.detail.value;     // 드롭다운/라디오: detail에서 읽기

    // Flow에 값 변경 알림
    this.dispatchEvent(
        new FlowAttributeChangeEvent('value', selectedValue)
    );
}
```

---

## 핵심 패턴 4 — validate() Flow Next 클릭 시 검증

```javascript
@api
validate() {
    if (this.required && !this.value) {
        return {
            isValid: false,
            errorMessage: `Make a selection in '${this.label}' to continue`
        };
    }
    return { isValid: true };
}
```

---

## 핵심 패턴 5 — 모바일 반응형 컬럼 처리

```javascript
import FORM_FACTOR from '@salesforce/client/formFactor';

get columnClass() {
    // 모바일에서는 무조건 1컬럼 강제
    const isDualColumns = FORM_FACTOR === 'Small' ? false : this.numberOfColumns === 2;
    return isDualColumns
        ? 'slds-col slds-size_1-of-2 slds-var-m-bottom_x-small'
        : 'slds-col slds-size_1-of-1 slds-var-m-bottom_x-small';
}
```

---

## @api 속성 전체 목록

| 속성 | 타입 | 용도 |
|---|---|---|
| `value` | String | 선택된 값 (Flow 출력) |
| `label` | String | 컴포넌트 레이블 |
| `displayMode` | String | `cards` / `picklist` / `radio` |
| `inputSource` | String | `list` / `picklist` |
| `choiceValues` | String[] | list 소스일 때 값 목록 |
| `choiceLabels` | String[] | list 소스일 때 레이블 목록 |
| `choiceIcons` | String[] | 아이콘 이름 목록 (SLDS) |
| `required` | Boolean | 필수 선택 여부 |
| `recordTypeId` | Id | picklist 소스일 때 Record Type |
| `qualifiedPicklistFieldName` | String | picklist 소스일 때 필드 API명 (`Account.Type`) |
| `numberOfColumns` | Integer | 카드 컬럼 수 (1 또는 2) |

---

## Custom Property Editor 패턴 (quickChoicePropertyEditor)

Flow Builder에서 컴포넌트 속성을 편집하는 전용 UI.

```javascript
// 입력: builderContext(Flow 변수 목록), inputVariables(현재 설정값)
@api builderContext;
@api inputVariables;

// 값 변경 시 Flow Builder에 알리는 이벤트
handleValueChange(event) {
    const valueChangedEvent = new CustomEvent(
        'configuration_editor_input_value_changed',
        {
            bubbles: true,
            cancelable: false,
            detail: {
                name: event.target.name,   // 속성명
                newValue: event.target.value,
                newValueDataType: 'String'
            }
        }
    );
    this.dispatchEvent(valueChangedEvent);
}

// js-meta.xml에서 연결
// <configurationEditor>c-quick-choice-property-editor</configurationEditor>
```

---

## 비교표 — Screen Component 선택

| 상황 | 패턴 |
|---|---|
| 2~5개 선택지, 카드 UI | quickChoice (displayMode=cards) |
| 긴 목록, 드롭다운 | quickChoice (displayMode=picklist) |
| 라디오 버튼 | quickChoice (displayMode=radio) |
| Picklist 필드 값 그대로 표시 | quickChoice (inputSource=picklist) |
| Flow Builder에서 속성 커스텀 편집 | Custom Property Editor 패턴 |

---

## 관련 노트

- [[Flow Screen LWC 패턴]] — FlowAttributeChangeEvent, validate() 기본 패턴
- [[getPicklistValues 패턴]] — getPicklistValues wire 어댑터
- [[모바일 기능 패턴]] — FORM_FACTOR 활용
