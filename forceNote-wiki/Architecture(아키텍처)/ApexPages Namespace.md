---
tags: [apex, visualforce, apexpages, controller, namespace, reference]
source: salesforce_apex_reference_guide.pdf (v67.0, Summer '26) p.10-42
created: 2026-05-20
aliases: [ApexPages, ApexPages 네임스페이스, Visualforce 컨트롤러, StandardController, StandardSetController, VF 컨트롤러]
---

# ApexPages Namespace

> Visualforce 컨트롤러에서 사용하는 클래스들의 집합. StandardController·Message·Action 등 VF 페이지 개발의 핵심 빌딩 블록을 제공한다.

---

## 개요

`ApexPages` 네임스페이스는 Visualforce 페이지 컨트롤러·컨트롤러 확장 개발에 특화된 클래스들을 포함한다.

| 클래스 | 설명 |
|---|---|
| `Action` | 컨트롤러 확장에서 사용할 액션 메서드 객체 |
| `Component` | 동적 Visualforce 컴포넌트 표현 |
| `IdeaStandardController` | StandardController 확장 — Ideas 특화 기능 (제한 릴리즈) |
| `IdeaStandardSetController` | StandardSetController 확장 — Ideas 목록 특화 (제한 릴리즈) |
| `KnowledgeArticleVersionStandardController` | StandardController 확장 — Knowledge 문서 특화 |
| `Message` | 표준 컨트롤러 저장 시 발생한 유효성 검사 오류 보관 |
| `StandardController` | 표준 컨트롤러 확장 정의 시 사용하는 단일 레코드 컨트롤러 |
| `StandardSetController` | Visualforce 목록 컨트롤러 확장 — 페이지네이션·다중 선택 |

> **주의:** ApexPages 네임스페이스는 **Visualforce 전용**이다. LWC·Aura에서는 사용하지 않는다.

---

## Action Class

Visualforce 커스텀 컨트롤러 또는 컨트롤러 확장에서 사용할 액션 메서드 객체를 생성한다.

**Namespace:** ApexPages

### Instantiation

```apex
ApexPages.Action saveAction = new ApexPages.Action('{!save}');
```

### Constructors

| 시그니처 | 설명 |
|---|---|
| `public Action(String action)` | 지정한 액션 표현식으로 Action 인스턴스 생성 |

**파라미터**
- `action` — Type: String. 액션 표현식 (예: `'{!save}'`)

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getExpression()` | `public String getExpression()` | String | 액션 호출 시 평가되는 표현식 반환 |
| `invoke()` | `public System.PageReference invoke()` | System.PageReference | 액션 호출 |

---

## Component Class

Apex에서 동적 Visualforce 컴포넌트를 표현한다.

**Namespace:** ApexPages

### Dynamic Component Properties

| 속성 | 시그니처 | 타입 | 설명 |
|---|---|---|---|
| `childComponents` | `public List<ApexPages.Component> childComponents {get; set;}` | List\<ApexPages.Component\> | 자식 컴포넌트 참조 |
| `expressions` | `public String expressions {get; set;}` | String | 표현식 언어 표기법으로 속성 설정 (`expressions.name_of_attribute`) |
| `facets` | `public String facets {get; set;}` | String | 동적 컴포넌트의 facet 설정 (`facet.name_of_facet`) |

> **Note:** `facets` 속성은 facets를 지원하는 컴포넌트에서만 접근 가능하다.

### 예제 — childComponents

```apex
Component.Apex.PageBlock pageBlk = new Component.Apex.PageBlock();

Component.Apex.PageBlockSection pageBlkSection =
    new Component.Apex.PageBlockSection(title='dummy header');

pageBlk.childComponents.add(pageBlkSection);
```

### 예제 — expressions

```apex
Component.Apex.InputField inpFld = new Component.Apex.InputField();
inpFld.expressions.value = '{!Account.Name}';
inpFld.expressions.id = '{!$User.FirstName}';
```

### 예제 — facets

```apex
Component.Apex.DataTable myDT = new Component.Apex.DataTable();
Component.Apex.OutputText footer =
    new Component.Apex.OutputText(value='Footer Copyright');
myDT.facets.footer = footer;
```

---

## IdeaStandardController Class

Ideas 특화 기능을 추가로 제공하는 StandardController 확장 클래스.

**Namespace:** ApexPages

### Usage

- **제한 릴리즈 프로그램**을 통해서만 사용 가능. 활성화하려면 Salesforce 담당자에게 문의.
- StandardController의 모든 메서드를 상속한다.
- 직접 인스턴스화 불가. 표준 아이디어 컨트롤러를 사용하는 커스텀 확장 클래스 생성자를 통해 획득.

### 예제

```apex
public class MyIdeaExtension {
    private final ApexPages.IdeaStandardController ideaController;

    public MyIdeaExtension(ApexPages.IdeaStandardController controller) {
        ideaController = (ApexPages.IdeaStandardController)controller;
    }

    public List<IdeaComment> getModifiedComments() {
        IdeaComment[] comments = ideaController.getCommentList();
        // modify comments here
        return comments;
    }
}
```

VF 페이지 (페이지 이름은 반드시 `detailPage`):

```xml
<!-- page named detailPage -->
<apex:page standardController="Idea" extensions="MyIdeaExtension">
    <apex:pageBlock title="Idea Section">
        <ideas:detailOutputLink page="detailPage" ideaId="{!idea.id}">{!idea.title}</ideas:detailOutputLink>
        <br/><br/>
        <apex:outputText >{!idea.body}</apex:outputText>
    </apex:pageBlock>
    <apex:pageBlock title="Comments Section">
        <apex:dataList var="a" value="{!modifiedComments}" id="list">
            {!a.commentBody}
        </apex:dataList>
        <ideas:detailOutputLink page="detailPage" ideaId="{!idea.id}" pageOffset="-1">Prev</ideas:detailOutputLink>
        |
        <ideas:detailOutputLink page="detailPage" ideaId="{!idea.id}" pageOffset="1">Next</ideas:detailOutputLink>
    </apex:pageBlock>
</apex:page>
```

### Methods

#### getCommentList()

현재 페이지의 읽기 전용 댓글 목록 반환.

```apex
public IdeaComment[] getCommentList()
```

**Return Value:** IdeaComment[]

반환 속성: `id`, `commentBody`, `createdDate`, `createdBy.Id`, `createdBy.communityNickname`

---

## IdeaStandardSetController Class

Ideas 목록 특화 기능을 추가로 제공하는 StandardSetController 확장 클래스.

**Namespace:** ApexPages

### Usage

- **제한 릴리즈 프로그램**을 통해서만 사용 가능.
- StandardSetController의 모든 메서드를 상속한다.
- **주의:** 상속된 StandardSetController 메서드는 `getIdeaList()`가 반환하는 아이디어 목록에 영향을 줄 수 없다.
- 직접 인스턴스화 불가. 아이디어 표준 목록 컨트롤러를 사용하는 커스텀 확장 클래스 생성자를 통해 획득.

### 예제 — 프로필 페이지 표시

```apex
public class MyIdeaProfileExtension {
    private final ApexPages.IdeaStandardSetController ideaSetController;

    public MyIdeaProfileExtension(ApexPages.IdeaStandardSetController controller) {
        ideaSetController = (ApexPages.IdeaStandardSetController)controller;
    }

    public List<Idea> getModifiedIdeas() {
        Idea[] ideas = ideaSetController.getIdeaList();
        // modify ideas here
        return ideas;
    }
}
```

프로필 페이지 (페이지 이름은 반드시 `profilePage`):

```xml
<!-- page named profilePage -->
<apex:page standardController="Idea" extensions="MyIdeaProfileExtension" recordSetVar="ideaSetVar">
    <apex:pageBlock >
        <ideas:profileListOutputLink sort="recentReplies" page="profilePage">Recent Replies</ideas:profileListOutputLink>
        |
        <ideas:profileListOutputLink sort="ideas" page="profilePage">Ideas Submitted</ideas:profileListOutputLink>
        |
        <ideas:profileListOutputLink sort="votes" page="profilePage">Ideas Voted</ideas:profileListOutputLink>
    </apex:pageBlock>
    <apex:pageBlock >
        <apex:dataList value="{!modifiedIdeas}" var="ideadata">
            <ideas:detailoutputlink ideaId="{!ideadata.id}" page="viewPage">
                {!ideadata.title}
            </ideas:detailoutputlink>
        </apex:dataList>
    </apex:pageBlock>
</apex:page>
```

### Methods

#### getIdeaList()

현재 페이지 세트의 읽기 전용 아이디어 목록 반환.

```apex
public Idea[] getIdeaList()
```

**Return Value:** Idea[]

반환 속성:
- `Body`, `Categories`, `Category`
- `CreatedBy.CommunityNickname`, `CreatedBy.Id`, `CreatedDate`
- `Id`, `LastCommentDate`
- `LastComment.Id`, `LastComment.CommentBody`
- `LastComment.CreatedBy.CommunityNickname`, `LastComment.CreatedBy.Id`
- `NumComments`, `Status`, `Title`, `VoteTotal`

---

## KnowledgeArticleVersionStandardController Class

Knowledge 문서 특화 기능을 추가로 제공하는 StandardController 확장 클래스.

**Namespace:** ApexPages

### Usage

- StandardController의 모든 메서드를 상속한다.
- **주의:** `edit`, `delete`, `save` 메서드는 이 클래스에서 동작하지 않는다.

### 예제

Knowledge 문서 작성 페이지에서 Case 정보를 미리 채우는 커스텀 확장 컨트롤러:

```apex
public class AgentContributionArticleController {
    public AgentContributionArticleController(
            ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();
        String sourceId = ctl.getSourceId();
        Case c = [SELECT Subject, Description FROM Case WHERE Id=:sourceId];
        article.put('title', 'From Case: '+c.subject);
        article.put('details__c', c.description);
        ctl.selectDataCategory('Geography', 'USA');
        ctl.selectDataCategory('Topics', 'Maintenance');
    }
}
```

테스트 클래스:

```apex
@isTest
private class AgentContributionArticleControllerTest {
    static testMethod void testAgentContributionArticleController() {
        String caseSubject = 'my test';
        String caseDesc = 'my test description';
        Case c = new Case();
        c.subject= caseSubject;
        c.description = caseDesc;
        insert c;
        String caseId = c.id;
        System.debug('Created Case: ' + caseId);
        ApexPages.currentPage().getParameters().put('sourceId', caseId);
        ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        ApexPages.KnowledgeArticleVersionStandardController ctl =
            new ApexPages.KnowledgeArticleVersionStandardController(new FAQ__kav());
        new AgentContributionArticleController(ctl);
        System.assertEquals(caseId, ctl.getSourceId());
        System.assertEquals('From Case: '+caseSubject, ctl.getRecord().get('title'));
        System.assertEquals(caseDesc, ctl.getRecord().get('details__c'));
    }
}
```

### Constructors

| 시그니처 | 설명 |
|---|---|
| `public KnowledgeArticleVersionStandardController(SObject article)` | 지정한 Knowledge 문서로 인스턴스 생성 |

**파라미터**
- `article` — Type: SObject. Knowledge 문서 (예: `FAQ__kav`)

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getSourceId()` | `public String getSourceId()` | String | 문서 생성의 소스 객체 레코드 ID 반환 |
| `setDataCategory(categoryGroup, category)` | `public Void setDataCategory(String categoryGroup, String category)` | Void | 새 문서 작성 시 기본 데이터 카테고리 지정 |

---

## Message Class

표준 컨트롤러 저장 시 발생하는 유효성 검사 오류를 보관하는 클래스.

**Namespace:** ApexPages

### Usage

- 표준 컨트롤러 사용 시 — 유효성 검사 오류가 자동으로 페이지 오류 컬렉션에 추가된다.
- 커스텀 컨트롤러/확장 사용 시 — 직접 `Message` 클래스로 오류를 수집해야 한다.

### ApexPages.Severity Enum

```
CONFIRM | ERROR | FATAL | INFO | WARNING
```

### Constructors

| 시그니처 | 설명 |
|---|---|
| `public Message(ApexPages.Severity severity, String summary)` | severity + summary로 생성 |
| `public Message(ApexPages.Severity severity, String summary, String detail)` | severity + summary + detail로 생성 |
| `public Message(ApexPages.Severity severity, String summary, String detail, String id)` | severity + summary + detail + 컴포넌트 ID로 생성 |

**파라미터**
- `severity` — Type: ApexPages.Severity. 메시지 심각도
- `summary` — Type: String. 요약 메시지
- `detail` — Type: String. 상세 메시지
- `id` — Type: String. 연결할 VF 컴포넌트 ID (예: form 필드)

### Instantiation

```apex
// 2-argument
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'my error msg');

// 3-argument
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Save failed', 'Field X is required');

// 4-argument (컴포넌트 ID 연결)
ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'summary', 'detail', 'inputFieldId');
```

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `getComponentLabel()` | `public String getComponentLabel()` | String | 연결된 inputField 컴포넌트의 레이블 반환. 없으면 null |
| `getDetail()` | `public String getDetail()` | String | detail 파라미터 값 반환. 없으면 null |
| `getSeverity()` | `public ApexPages.Severity getSeverity()` | ApexPages.Severity | 메시지 생성 시 사용한 severity enum 반환 |
| `getSummary()` | `public String getSummary()` | String | 메시지 생성 시 사용한 summary 문자열 반환 |

---

## StandardController Class

표준 컨트롤러 확장 클래스 정의 시 사용하는 단일 레코드 컨트롤러.

**Namespace:** ApexPages

### Usage

- Salesforce가 제공하는 pre-built VF 컨트롤러를 참조한다.
- 표준 컨트롤러 확장 클래스 생성자의 단일 인자 타입으로 사용한다.

### Instantiation

```apex
ApexPages.StandardController sc = new ApexPages.StandardController(sObject);
```

### 예제

```apex
public class myControllerExtension {
    private final Account acct;

    public myControllerExtension(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
    }

    public String getGreeting() {
        return 'Hello ' + acct.name + ' (' + acct.id + ')';
    }
}
```

VF 페이지:

```xml
<apex:page standardController="Account" extensions="myControllerExtension">
    {!greeting} <p/>
    <apex:form>
        <apex:inputField value="{!account.name}"/> <p/>
        <apex:commandButton value="Save" action="{!save}"/>
    </apex:form>
</apex:page>
```

### Constructors

| 시그니처 | 설명 |
|---|---|
| `public StandardController(SObject controllerSObject)` | 지정한 표준/커스텀 객체로 StandardController 생성 |

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `addFields(fieldNames)` | `public Void addFields(List<String> fieldNames)` | Void | 컨트롤러가 명시적으로 접근할 필드 추가. 생성자에서 호출해야 함. 생성자 외부에서 호출 시 `reset()` 먼저 필요. dynamicVisualforce 바인딩 전용 |
| `cancel()` | `public System.PageReference cancel()` | System.PageReference | 취소 페이지의 PageReference 반환 |
| `delete()` | `public System.PageReference delete()` | System.PageReference | 레코드 삭제 후 삭제 페이지 PageReference 반환 |
| `edit()` | `public System.PageReference edit()` | System.PageReference | 표준 편집 페이지의 PageReference 반환 |
| `getId()` | `public String getId()` | String | VF 페이지 URL의 `id` 파라미터 기반 현재 레코드 ID 반환 |
| `getRecord()` | `public SObject getRecord()` | sObject | 현재 컨텍스트 레코드 반환. VF 마크업에서 참조된 필드만 사용 가능. 추가 필드 접근 시 `addFields()` 또는 숨겨진 컴포넌트 사용 |
| `reset()` | `public Void reset()` | Void | 새로 참조된 필드 접근 재취득. 호출 전 레코드 변경 사항 모두 삭제됨. dynamicVisualforce 전용 |
| `save()` | `public System.PageReference save()` | System.PageReference | 변경 사항 저장 후 업데이트된 PageReference 반환 |
| `view()` | `public System.PageReference view()` | System.PageReference | 표준 상세 페이지의 PageReference 반환 |

**getRecord() 추가 필드 접근 팁 — 숨겨진 컴포넌트:**

```xml
<apex:outputText
    value="{!account.billingcity}
{!account.contacts}"
    rendered="false"/>
```

---

## StandardSetController Class

Visualforce 표준 목록 컨트롤러와 유사하거나 확장하는 목록 컨트롤러 생성.

**Namespace:** ApexPages

### Usage

- prototype object: 대량 업데이트를 위한 단일 sObject 포함
- **최대 레코드 한도: 10,000건**
  - QueryLocator로 10,000건 초과 반환 시 → `LimitException` 발생
  - List로 10,000건 초과 전달 시 → 초과분 잘림 (예외 없음)

### Instantiation

```apex
// List로 생성
List<Account> accountList = [SELECT Name FROM Account LIMIT 20];
ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(accountList);

// QueryLocator로 생성
ApexPages.StandardSetController ssc =
    new ApexPages.StandardSetController(
        Database.getQueryLocator([SELECT Name, CloseDate FROM Opportunity]));
```

### 예제

```apex
public class opportunityList2Con {
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(
                    Database.getQueryLocator([SELECT Name, CloseDate FROM Opportunity]));
            }
            return setCon;
        }
        set;
    }

    public List<Opportunity> getOpportunities() {
        return (List<Opportunity>) setCon.getRecords();
    }
}
```

VF 페이지:

```xml
<apex:page controller="opportunityList2Con">
    <apex:pageBlock>
        <apex:pageBlockTable value="{!opportunities}" var="o">
            <apex:column value="{!o.Name}"/>
            <apex:column value="{!o.CloseDate}"/>
        </apex:pageBlockTable>
    </apex:pageBlock>
</apex:page>
```

### Constructors

| 시그니처 | 설명 |
|---|---|
| `public StandardSetController(Database.QueryLocator queryLocator)` | QueryLocator 반환 객체 목록으로 생성 |
| `public StandardSetController(List<sObject> controllerSObjects)` | 지정한 표준/커스텀 객체 목록으로 생성 |

### Methods

| 메서드 | 시그니처 | 반환 | 설명 |
|---|---|---|---|
| `cancel()` | `public System.PageReference cancel()` | System.PageReference | 원래 페이지(알 수 없으면 홈 페이지) PageReference 반환 |
| `first()` | `public Void first()` | Void | 첫 번째 페이지로 이동 |
| `getCompleteResult()` | `public Boolean getCompleteResult()` | Boolean | 결과가 최대 한도(10,000) 이내인지 여부. false면 표시 불가 레코드 있음 |
| `getFilterId()` | `public String getFilterId()` | String | 현재 컨텍스트 필터 ID 반환. 필터 ID 없는 목록 뷰(Recently Viewed 등)는 지원 안 함 |
| `getHasNext()` | `public Boolean getHasNext()` | Boolean | 현재 페이지 이후 레코드 존재 여부 |
| `getHasPrevious()` | `public Boolean getHasPrevious()` | Boolean | 현재 페이지 이전 레코드 존재 여부 |
| `getListViewOptions()` | `public System.SelectOption getListViewOptions()` | System.SelectOption[] | 현재 사용자가 사용 가능한 목록 뷰 반환 |
| `getPageNumber()` | `public Integer getPageNumber()` | Integer | 현재 페이지 번호 반환 (첫 페이지 = 1) |
| `getPageSize()` | `public Integer getPageSize()` | Integer | 페이지당 레코드 수 반환 |
| `getRecord()` | `public sObject getRecord()` | sObject | 선택된 레코드 변경 내용을 나타내는 prototype object 반환. 대량 업데이트에 사용 |
| `getRecords()` | `public sObject[] getRecords()` | sObject[] | 현재 페이지 세트의 sObject 목록 반환 (불변, `clear()` 호출 불가) |
| `getResultSize()` | `public Integer getResultSize()` | Integer | 전체 결과 레코드 수 반환 |
| `getSelected()` | `public sObject[] getSelected()` | sObject[] | 선택된 sObject 목록 반환 |
| `last()` | `public Void last()` | Void | 마지막 페이지로 이동 |
| `next()` | `public Void next()` | Void | 다음 페이지로 이동 |
| `previous()` | `public Void previous()` | Void | 이전 페이지로 이동 |
| `save()` | `public System.PageReference save()` | System.PageReference | 새 레코드 삽입 또는 변경된 레코드 업데이트. 원래 페이지 PageReference 반환 |
| `setFilterID(filterId)` | `public Void setFilterID(String filterId)` | Void | 컨트롤러의 필터 ID 설정 |
| `setpageNumber(pageNumber)` | `public Void setpageNumber(Integer pageNumber)` | Void | 페이지 번호 설정 |
| `setPageSize(pageSize)` | `public Void setPageSize(Integer pageSize)` | Void | 페이지당 레코드 수 설정 |
| `setSelected(selectedRecords)` | `public Void setSelected(sObject[] selectedRecords)` | Void | 선택된 레코드 지정. 기존 선택 항목 덮어씀 |

### setSelected 예제

```xml
<!-- AccountNamePage.page -->
<apex:page standardController="Account" recordSetVar="accounts"
    extensions="MyControllerExtension">
    <apex:pageBlock>
        <apex:pageBlockTable value="{!accounts}" var="acc">
            <apex:column value="{!acc.name}"/>
        </apex:pageBlockTable>
    </apex:pageBlock>
</apex:page>
```

---

## 관련 노트

- [[System Namespace]] — ApexPages.StandardController 반환 타입인 System.PageReference 포함
- [[Site Namespace]] — VF/Community 페이지 URL 재작성
- [[Schema Namespace 상세]] — 동적 컴포넌트에서 사용하는 필드/오브젝트 Describe
