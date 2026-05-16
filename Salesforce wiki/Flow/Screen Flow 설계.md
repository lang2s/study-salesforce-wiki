---
tags: [flow, screen, lwc, component, design]
source: dreamhouse-lwc/Create_property, lwc-recipes/SimpleGreetingFlow
created: 2026-05-17
aliases: [Screen Flow, Flow Screen 설계, flowruntime, Flow 화면]
---

# Screen Flow 설계

> `processType: Flow`. 사용자가 단계별로 입력하는 마법사형 UI. LWC 컴포넌트 삽입 가능.

---

## Screen 기본 구조

```xml
<screens>
    <name>new_property</name>
    <label>New Property</label>
    <locationX>666</locationX>
    <locationY>158</locationY>

    <!-- 화면 이동 버튼 설정 -->
    <allowBack>true</allowBack>
    <allowFinish>true</allowFinish>
    <allowPause>true</allowPause>

    <showHeader>true</showHeader>
    <showFooter>true</showFooter>

    <connector>
        <targetReference>next_screen_or_element</targetReference>
    </connector>

    <fields><!-- 화면 구성 요소들 --></fields>
</screens>
```

---

## Screen Field 타입

### InputField — 사용자 입력

```xml
<fields>
    <name>property_name</name>
    <dataType>String</dataType>      <!-- String, Number, Currency, Date 등 -->
    <fieldText>Property Name</fieldText>
    <fieldType>InputField</fieldType>
    <isRequired>true</isRequired>
    <defaultValue>
        <stringValue>기본값</stringValue>
        <!-- 또는 <elementReference>변수명</elementReference> -->
    </defaultValue>
    <scale>0</scale>                 <!-- Number 타입: 소수점 자리수 -->
</fields>
```

### DisplayText — 읽기 전용 텍스트 (HTML 지원)

```xml
<fields>
    <name>Welcome_Message</name>
    <fieldText>&lt;p&gt;&lt;b&gt;환영합니다&lt;/b&gt;&lt;/p&gt;</fieldText>
    <fieldType>DisplayText</fieldType>
</fields>
```

> HTML 태그는 XML escape 필요: `<` → `&lt;`, `>` → `&gt;`, `&` → `&amp;`
> 수식 변수도 참조 가능: `{!User_Name_Display}`

---

## 표준 내장 컴포넌트 (flowruntime:)

```xml
<!-- 주소 입력 -->
<fields>
    <name>property_address</name>
    <extensionName>flowruntime:address</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <!-- 결과: property_address.street, .city, .province, .postalCode, .country -->
</fields>

<!-- 레코드 검색 (Lookup) -->
<fields>
    <name>property_broker</name>
    <extensionName>flowruntime:lookup</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>objectApiName</name>
        <value><stringValue>Property__c</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>fieldApiName</name>
        <value><stringValue>Broker__c</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>label</name>
        <value><stringValue>Broker</stringValue></value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <!-- 결과: property_broker.recordId, .displayValue -->
</fields>

<!-- 파일 업로드 -->
<fields>
    <name>property_picture</name>
    <extensionName>forceContent:fileUpload</extensionName>
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>label</name>
        <value><stringValue>Upload Picture</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>accept</name>
        <value><stringValue>.jpg,.png,.gif</stringValue></value>
    </inputParameters>
    <inputParameters>
        <name>recordId</name>
        <value><elementReference>create_property</elementReference></value>
    </inputParameters>
    <inputParameters>
        <name>multiple</name>
        <value><booleanValue>true</booleanValue></value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
</fields>
```

---

## 커스텀 LWC 컴포넌트 삽입

```xml
<fields>
    <name>navigate_to_record_lwc</name>
    <extensionName>c:navigateToRecord</extensionName>  <!-- c:컴포넌트명 -->
    <fieldType>ComponentInstance</fieldType>
    <inputParameters>
        <name>recordId</name>
        <value>
            <elementReference>create_property</elementReference>
        </value>
    </inputParameters>
    <isRequired>true</isRequired>
    <storeOutputAutomatically>true</storeOutputAutomatically>
    <inputsOnNextNavToAssocScrn>UseStoredValues</inputsOnNextNavToAssocScrn>
</fields>
```

LWC에서 Flow에 값 전달:
```javascript
// LWC → Flow 값 변경
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
this.dispatchEvent(new FlowAttributeChangeEvent('value', newValue));
```

`inputsOnNextNavToAssocScrn` 옵션:
- `UseStoredValues`: 뒤로 가서 다시 Next 시 이전 값 유지
- `ResetValues`: 뒤로 가서 다시 Next 시 초기화

---

## LWC에서 Flow 기동

```javascript
// NavigationMixin으로 Screen Flow 열기
import { NavigationMixin } from 'lightning/navigation';

this[NavigationMixin.Navigate]({
    type: 'standard__flow',
    attributes: {
        flowApiName: 'SimpleGreetingFlow'
    },
    state: {
        userName: this.currentUser.Name  // isInput=true 변수에 값 전달
    }
});
```

---

## 다단계 Screen Flow 설계 패턴

```
[화면1: 기본 정보]
    ↓
[Apex Action: 주소 지오코딩]
    ↓ (성공)         ↓ (faultConnector: 오류 화면)
[화면2: 상세 정보]
    ↓
[Create Records]
    ↓ (성공)         ↓ (faultConnector: 오류 화면)
[화면3: 사진 업로드]
    ↓
[Get Records: 업로드된 파일 조회]
    ↓
[Decision: 파일 있음?]
    ↓ Yes                     ↓ No (default)
[Update Records: 썸네일 설정]
    ↓
[화면4: 완료]
```

**오류 화면 설계:**
- 각 DML/Action 요소에 `faultConnector` → 오류 화면 연결
- `allowBack: false` + `allowFinish: true` (닫기만 가능)
- `{!$Flow.FaultMessage}` 로 실제 오류 메시지 표시 가능

---

## 관련 노트

- [[Flow 종류와 변수]]
- [[Flow 요소 참조]]
- [[Flow Screen LWC 패턴]]
- [[NavigationMixin 패턴]]
