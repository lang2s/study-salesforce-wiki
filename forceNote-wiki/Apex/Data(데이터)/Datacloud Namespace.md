---
tags: [apex, datacloud, duplicate-management, duplicate-rules, find-duplicates, match-record, deduplication]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.2741~2760)
created: 2026-05-20
aliases: [Datacloud Namespace, Datacloud.FindDuplicates, Datacloud.FindDuplicatesByIds, Datacloud.DuplicateResult, Datacloud.MatchRecord, Datacloud.MatchResult, 중복 레코드 탐지 Apex, 중복 관리 Apex, findDuplicates, FindDuplicatesResult]
---

# Datacloud Namespace

> Duplicate Management(중복 규칙)를 Apex에서 제어하는 API — 레코드 저장 전 중복 탐지, DML 에러에서 중복 결과 추출.

> [!warning] 이름에 주의 — Salesforce Data Cloud(CDP) 제품과 무관
> `Datacloud` 네임스페이스는 **Duplicate Management 기능**(중복 규칙)에 관한 API입니다. Salesforce Data Cloud(구 CDP) 제품과는 완전히 별개입니다. 이름만 보고 Data Cloud 관련 코드로 혼동하지 않도록 주의합니다.

---

## 개념

Salesforce의 Duplicate Management는 Setup > Duplicate Rules에서 활성화한 중복 규칙을 통해 레코드 저장 시 중복 여부를 감지하고 차단하거나 경고를 표시한다. `Datacloud` 네임스페이스는 이 중복 탐지 로직을 **Apex에서 직접 실행**하거나 **DML 에러에서 중복 결과를 추출**할 수 있게 해준다.

### 두 가지 사용 패턴

| 패턴 | 설명 | 클래스 |
|---|---|---|
| **DML 에러 추출** | insert/update 시 중복 에러 발생 → `Database.DuplicateError` → `DuplicateResult` → `MatchResult` → `MatchRecord` | DuplicateResult, MatchResult, MatchRecord |
| **사전 탐지** | DML 없이 중복 여부 먼저 확인 → 조건에 따라 DML 실행 여부 결정 | FindDuplicates, FindDuplicatesByIds, FindDuplicatesResult |

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `FindDuplicates` | sObject 배열로 중복 탐지 (static) |
| `FindDuplicatesByIds` | ID 배열로 중복 탐지 (static) |
| `FindDuplicatesResult` | FindDuplicates/FindDuplicatesByIds 결과 컨테이너 |
| `DuplicateResult` | 하나의 중복 규칙이 탐지한 결과 및 매치 정보 |
| `MatchResult` | 하나의 매칭 규칙 결과 — MatchRecord 목록 포함 |
| `MatchRecord` | 중복으로 탐지된 실제 레코드 |
| `FieldDiff` | 중복 레코드와 원본 레코드 간 필드 값 비교 |
| `AdditionalInformationMap` | 매칭 레코드의 추가 메타데이터 (name-value 쌍) |

---

## 패턴 1 — DML 에러에서 중복 결과 추출

레코드 저장 시 중복 규칙이 Block 액션이면 DML 에러가 발생한다. 이 에러에서 중복 정보를 꺼내는 패턴.

아래는 PDF p.2743-2745의 공식 예제 전체다. Visualforce 페이지와 Apex 컨트롤러로 구성된 Contact 중복 탐지 앱.

**Visualforce 페이지:**
```xml
<apex:page controller="ContactDedupeController">
    <apex:form >
        <apex:pageBlock title="Duplicate Records" rendered="{!hasDuplicateResult}">
            <apex:pageMessages />
            <apex:pageBlockTable value="{!duplicateRecords}" var="item">
                <apex:column >
                    <apex:facet name="header">Name</apex:facet>
                    <apex:outputLink value="/{!item['Id']}">{!item['Name']}</apex:outputLink>
                </apex:column>
                <apex:column >
                    <apex:facet name="header">Owner</apex:facet>
                    <apex:outputField value="{!item['OwnerId']}"/>
                </apex:column>
                <apex:column >
                    <apex:facet name="header">Last Modified Date</apex:facet>
                    <apex:outputField value="{!item['LastModifiedDate']}"/>
                </apex:column>
            </apex:pageBlockTable>
        </apex:pageBlock>

        <apex:pageBlock title="Contact" mode="edit">
            <apex:pageBlockButtons >
                <apex:commandButton value="Save" action="{!save}"/>
            </apex:pageBlockButtons>

            <apex:pageBlockSection >
                <apex:inputField value="{!Contact.FirstName}"/>
                <apex:inputField value="{!Contact.LastName}"/>
                <apex:inputField value="{!Contact.Email}"/>
                <apex:inputField value="{!Contact.Phone}"/>
                <apex:inputField value="{!Contact.AccountId}"/>
            </apex:pageBlockSection>
        </apex:pageBlock>
    </apex:form>
</apex:page>
```

**Apex 컨트롤러 (ContactDedupeController):**
```apex
public class ContactDedupeController {

    // Initialize a variable to hold the contact record you're processing
    private final Contact contact;

    // Initialize a list to hold any duplicate records
    private List<sObject> duplicateRecords;

    // Define variable that's true if there are duplicate records
    public boolean hasDuplicateResult {get;set;}

    // Define the constructor
    public ContactDedupeController() {

        // Define the values for the contact you're processing based on its ID
        Id id = ApexPages.currentPage().getParameters().get('id');
        this.contact = (id == null) ? new Contact() :
            [SELECT Id, FirstName, LastName, Email, Phone, AccountId
             FROM Contact WHERE Id = :id];

        // Initialize empty list of potential duplicate records
        this.duplicateRecords = new List<sObject>();
        this.hasDuplicateResult = false;
    }

    // Return contact and its values to the Visualforce page for display
    public Contact getContact() {
        return this.contact;
    }

    // Return duplicate records to the Visualforce page for display
    public List<sObject> getDuplicateRecords() {
        return this.duplicateRecords;
    }

    // Process the saved record and handle any duplicates
    public PageReference save() {

        // Optionally, set DML options here, use "DML" instead of "false"
        //   in the insert()
        // Database.DMLOptions dml = new Database.DMLOptions();
        // dml.DuplicateRuleHeader.allowSave = true;
        // dml.DuplicateRuleHeader.runAsCurrentUser = true;
        Database.SaveResult saveResult = Database.insert(contact, false);

        if (!saveResult.isSuccess()) {
            for (Database.Error error : saveResult.getErrors()) {
                // If there are duplicates, an error occurs
                // Process only duplicates and not other errors
                //   (e.g., validation errors)
                if (error instanceof Database.DuplicateError) {
                    // Handle the duplicate error by first casting it as a
                    //   DuplicateError class
                    // This lets you use methods of that class
                    //   (e.g., getDuplicateResult())
                    Database.DuplicateError duplicateError =
                            (Database.DuplicateError)error;
                    Datacloud.DuplicateResult duplicateResult =
                            duplicateError.getDuplicateResult();

                    // Display duplicate error message as defined in the duplicate rule
                    ApexPages.Message errorMessage = new ApexPages.Message(
                            ApexPages.Severity.ERROR, 'Duplicate Error: ' +
                            duplicateResult.getErrorMessage());
                    ApexPages.addMessage(errorMessage);

                    // Get duplicate records
                    this.duplicateRecords = new List<sObject>();

                    // Return only match results of matching rules that
                    //   find duplicate records
                    Datacloud.MatchResult[] matchResults =
                            duplicateResult.getMatchResults();

                    // Just grab first match result (which contains the
                    //   duplicate record found and other match info)
                    Datacloud.MatchResult matchResult = matchResults[0];

                    Datacloud.MatchRecord[] matchRecords = matchResult.getMatchRecords();

                    // Add matched record to the duplicate records variable
                    for (Datacloud.MatchRecord matchRecord : matchRecords) {
                        System.debug('MatchRecord: ' + matchRecord.getRecord());
                        this.duplicateRecords.add(matchRecord.getRecord());
                    }
                    this.hasDuplicateResult = !this.duplicateRecords.isEmpty();
                }
            }

            //If there's a duplicate record, stay on the page
            return null;
        }

        //  After save, navigate to the view page:
        return (new ApexPages.StandardController(contact)).view();
    }
}

---

## 패턴 2 — 사전 중복 탐지 (FindDuplicates)

DML을 실행하기 전에 중복 여부를 먼저 확인한다. 중복이 없을 때만 삽입하는 패턴.

```apex
// sObject 배열로 탐지 — 같은 타입만, 최대 50개
Account acct = new Account();
acct.Name = 'Test Account 123';
acct.BillingStreet = '123 Test Street';
acct.BillingCity = 'San Francisco';
acct.BillingState = 'CA';
acct.BillingCountry = 'US';

List<Account> acctList = new List<Account>();
acctList.add(acct);

// findDuplicates — 입력 sObject 배열과 동일한 순서로 결과 반환
List<Datacloud.FindDuplicatesResult> results =
    Datacloud.FindDuplicates.findDuplicates(acctList);

// index 0: 첫 번째 Account에 대한 결과
Datacloud.FindDuplicatesResult acctResult = results[0];

if (!acctResult.isSuccess()) {
    List<Database.Error> errs = acctResult.getErrors();
    for (Database.Error err : errs) {
        System.debug(err.getMessage());
    }
} else {
    Boolean duplicatesFound = false;
    Boolean matchError = false;

    // 평가된 Duplicate Rule 목록 순회
    for (Datacloud.DuplicateResult dupResult : acctResult.getDuplicateResults()) {
        // 각 Duplicate Rule 내에서 Matching Rule 결과 순회
        for (Datacloud.MatchResult matchResult : dupResult.getMatchResults()) {
            // Matching Rule 실행 성공 여부 확인
            if (!matchResult.isSuccess()) {
                List<Database.Error> errs = matchResult.getErrors();
                for (Database.Error err : errs) {
                    System.debug(err.getMessage());
                }
                matchError = true;
            } else {
                // 중복 레코드가 발견된 경우
                if (!matchResult.getMatchRecords().isEmpty()) {
                    System.debug('Duplicate record(s) found with matching rule: ' +
                        matchResult.getRule());
                    duplicatesFound = true;
                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                        System.debug('Duplicate record: ' + matchRecord.getRecord());
                    }
                }
            }
        }
    }

    // 중복도 없고 에러도 없을 때만 삽입
    if (!duplicatesFound && !matchError) {
        insert acct;
        System.debug('Account inserted.');
    }
}
```

---

## 패턴 3 — ID 배열로 중복 탐지 (FindDuplicatesByIds)

기존 레코드 ID 목록으로 중복을 탐지한다. 각 ID가 대표하는 레코드 타입의 Duplicate Rule을 적용한다.

```apex
// 기존 레코드 ID 목록 — 모두 같은 sObject 타입이어야 함
List<Id> idList = new List<Id>();
idList.add('EXISTING_ID'); // 실제 18자리 ID로 교체

List<Datacloud.FindDuplicatesResult> results =
    Datacloud.FindDuplicatesByIds.findDuplicatesByIds(idList);

// index 0: 첫 번째 ID에 대한 결과
Datacloud.FindDuplicatesResult idResult = results[0];

if (!idResult.isSuccess()) {
    List<Database.Error> errs = idResult.getErrors();
    for (Database.Error err : errs) {
        System.debug(err.getMessage());
    }
} else {
    Boolean duplicatesFound = false;
    Boolean matchError = false;

    for (Datacloud.DuplicateResult dupResult : idResult.getDuplicateResults()) {
        for (Datacloud.MatchResult matchResult : dupResult.getMatchResults()) {
            if (!matchResult.isSuccess()) {
                List<Database.Error> errs = matchResult.getErrors();
                for (Database.Error err : errs) {
                    System.debug(err.getMessage());
                }
                matchError = true;
            } else {
                if (!matchResult.getMatchRecords().isEmpty()) {
                    System.debug('Duplicate record(s) found with matching rule: ' +
                        matchResult.getRule());
                    duplicatesFound = true;
                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                        System.debug('Duplicate record: ' + matchRecord.getRecord());
                    }
                }
            }
        }
    }

    if (!duplicatesFound && !matchError) {
        System.debug('No duplicates found for record ID: ' + idList[0]);
    }
}

---

## 클래스 메서드 레퍼런스

### FindDuplicates 클래스

```apex
public static List<Datacloud.FindDuplicatesResult>
    findDuplicates(List<SObject> sObjects)
```

### FindDuplicatesByIds 클래스

```apex
public static List<Datacloud.FindDuplicatesResult>
    findDuplicatesByIds(List<Id> ids)
```

### FindDuplicatesResult 클래스

`FindDuplicates` 또는 `FindDuplicatesByIds` 호출 결과 컨테이너. 입력 배열의 각 요소에 대응하는 결과 객체.

**Properties (직접 접근 가능):**

| 프로퍼티 | 타입 | Signature |
|---|---|---|
| `duplicateresults` | `List<Datacloud.DuplicateResult>` | `public List<Datacloud.DuplicateResult> duplicateresults` |
| `errors` | `List<Database.Error>` | `public List<Database.Error> errors {get; set;}` |
| `success` | `Boolean` | `public Boolean success {get; set;}` |

**Methods:**

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDuplicateResults()` | `List<Datacloud.DuplicateResult>` | FindDuplicates/FindDuplicatesByIds 호출로 탐지된 중복 규칙 결과 목록 반환 |
| `getErrors()` | `List<Database.Error>` | 호출 중 발생한 에러 반환 |
| `isSuccess()` | `Boolean` | 호출 성공 여부 반환 |

```apex
// getDuplicateResults() 코드 예제 (PDF p.2756)
Account acct = new Account(name='Salesforce');
List<Account> acctList = new List<Account>();
acctList.add(acct);

Datacloud.FindDuplicatesResult[] results =
    Datacloud.FindDuplicates.findDuplicates(acctList);

for (Datacloud.FindDuplicatesResult findDupeResult : results) {
    for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {
        for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {
            for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                System.debug('Duplicate Record: ' + matchRecord.getRecord());
            }
        }
    }
}
```

### DuplicateResult 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDuplicateRule()` | `String` | 트리거된 Duplicate Rule의 developer name |
| `getErrorMessage()` | `String` | 관리자가 설정한 중복 경고 메시지 |
| `getMatchResults()` | `List<MatchResult>` | 매칭 규칙별 결과 목록 |
| `isAllowSave()` | `Boolean` | 규칙이 저장을 허용하는지 여부 |

### MatchResult 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getEntityType()` | `String` | 탐지된 중복 레코드의 sObject 타입 |
| `getErrors()` | `List<Database.Error>` | 실행 중 에러 목록 |
| `getMatchEngine()` | `String` | 이 결과를 생성한 Match Engine 이름 |
| `getMatchRecords()` | `List<Datacloud.MatchRecord>` | 중복으로 탐지된 레코드 배열 |
| `getRule()` | `String` | 이 결과를 생성한 Matching Rule 이름 |
| `getSize()` | `Integer` | 매칭 규칙이 탐지한 중복 레코드 수 |
| `isSuccess()` | `Boolean` | 매칭 규칙 실행 성공 여부 (`false` = 에러 발생) |

### MatchRecord 클래스

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAdditionalInformation()` | `List<Datacloud.AdditionalInformationMap>` | 매칭 레코드의 추가 메타데이터 (D&B 필드의 matchGrade 등) |
| `getFieldDiffs()` | `List<Datacloud.FieldDiff>` | 원본과 중복 레코드 간 필드 비교 목록 |
| `getMatchConfidence()` | `Double` | 매칭 유사도 점수 (미사용 시 `-1`, Duplicate Rule의 minMatchConfidence 이상이어야 중복 탐지) |
| `getRecord()` | `SObject` | 중복으로 탐지된 실제 레코드 |

### AdditionalInformationMap 클래스

매칭된 레코드의 추가 메타데이터를 담는 name-value 쌍 컨테이너. D&B 필드의 `matchGrade` 등이 이 객체로 반환된다.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getName()` | `String` | 요소의 이름 반환 |
| `getValue()` | `String` | 요소의 값 반환 |

```apex
// Signatures
public String getName()
public String getValue()
```

### FieldDiff 클래스

매칭 규칙 필드의 이름과 중복 레코드-원본 레코드 간 필드 값 비교 결과를 나타낸다.

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getDifference()` | `String` | 필드 값 비교 결과: `SAME` / `DIFFERENT` / `NULL` |
| `getName()` | `String` | 중복을 탐지한 Matching Rule의 필드 이름 |

```apex
// Signatures
public String getDifference()   // SAME: 정확히 일치 / DIFFERENT: 불일치 / NULL: 둘 다 blank
public String getName()
```

---

## 주의사항

### 1. Datacloud ≠ Salesforce Data Cloud

Apex Reference Guide p.2741 명시: **"The Datacloud namespace isn't related to the Salesforce Data Cloud product."** 이름이 매우 유사하지만 완전히 별개의 기능이다.

### 2. 입력 배열 최대 50개

`FindDuplicates.findDuplicates()` 와 `FindDuplicatesByIds.findDuplicatesByIds()` 모두 **입력 배열 크기가 50개를 초과하면 예외** 발생:
```
Configuration error: The number of records to check is greater than the permitted batch size.
```

### 3. 활성화된 Duplicate Rule 필요

대상 오브젝트 타입에 활성화된 Duplicate Rule이 없으면 `System.HandledException` 발생:
```
No active duplicate rules are defined for the {ObjectName} object type.
```

### 4. 커스텀 필드는 기본 미포함

`findDuplicates()`는 기본적으로 커스텀 필드를 반환하지 않는다. 커스텀 필드를 매칭 기준에 포함하려면 커스텀 Matching Rule을 구성하고 Duplicate Rule에 연결해야 한다.

### 5. DuplicateResult는 Database.DuplicateError 내부에 포함

DML 경로에서는 `SaveResult.getErrors()` → `instanceof Database.DuplicateError` → `getDuplicateResult()` 순서로 접근한다. `DuplicateResult`를 직접 생성하거나 외부에서 얻을 수 없다.

---

## 관련 노트

- [[DML 패턴]] — Database.insert(allOrNone), partial success 처리, DuplicateError 포함
- [[Database Namespace 상세]] — SaveResult, Database.Error, DMLOptions 전체 레퍼런스
