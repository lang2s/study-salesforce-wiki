---
tags: [apex, reference, standard-class, string, list, map, database, crypto, json]
source: TrailheadApp/apex-recipes-main + Release Notes (Winter '24 ~ Summer '26)
created: 2026-05-17
aliases: [Apex 표준 클래스, Apex Standard Class, String 메서드, List 메서드, Map 메서드, Database 메서드]
---

# Apex 표준 클래스 레퍼런스

> Apex 내장 클래스 전체 빠른 참조. 기본 타입부터 암호화·DataWeave까지.

> [!warning] 기본 메서드 목록은 외부 지식(Tier 3) 기반. 코드 예시 중 `apex-recipes-main` 발췌 부분은 Tier 1, 릴리즈 노트 관련 내용은 Tier 2.

---

## 목차

1. [String](#1-string)
2. [숫자 타입 (Integer / Long / Double / Decimal)](#2-숫자-타입)
3. [Date / Time / DateTime](#3-date--time--datetime)
4. [List](#4-list)
5. [Set](#5-set)
6. [Map](#6-map)
7. [Math](#7-math)
8. [JSON](#8-json)
9. [Blob & EncodingUtil](#9-blob--encodingutil)
10. [Database](#10-database)
11. [System & Limits](#11-system--limits)
12. [Schema](#12-schema)
13. [Crypto](#13-crypto)
14. [Type & ID](#14-type--id)
15. [UserInfo & URL](#15-userinfo--url)
16. [Exception](#16-exception)
17. [Test](#17-test)
18. [신규 클래스 (릴리즈별)](#18-신규-클래스-릴리즈별)

---

## 1. String

```apex
String s = 'Hello, World!';

// 검사
s.length()                          // 13
s.isEmpty()                         // false
s.isBlank()                         // false (공백만 있어도 true)
s.contains('World')                 // true
s.startsWith('Hello')               // true
s.endsWith('!')                     // true
s.equals('Hello, World!')           // true (대소문자 구분)
s.equalsIgnoreCase('hello, world!') // true

// 변환
s.toLowerCase()                     // 'hello, world!'
s.toUpperCase()                     // 'HELLO, WORLD!'
s.trim()                            // 앞뒤 공백 제거
s.replace('World', 'Salesforce')    // 'Hello, Salesforce!'
s.replaceAll('[^a-z]', '')          // 정규식 치환
s.substring(7, 12)                  // 'World'
s.split(',')                        // ['Hello', ' World!']
s.split(',', 2)                     // 최대 2개로 분리
s.join(List<String>)                // 구분자로 합치기 (String 인스턴스 메서드 X → String.join 사용)

// 유틸리티
String.join(new List<String>{'a','b'}, '-')  // 'a-b'
String.format('Hello {0}!', new List<Object>{'World'})  // 'Hello World!'
String.valueOf(123)                 // '123'
String.isBlank(null)                // true
String.isEmpty('')                  // true

// 변환
Integer.valueOf(s)                  // 문자열 → 정수
s.toCharArray()                     // 문자 배열

// 인코딩
EncodingUtil.urlEncode(s, 'UTF-8')
EncodingUtil.urlDecode(s, 'UTF-8')
EncodingUtil.base64Encode(Blob.valueOf(s))
```

### String.template() *(Summer '26 추가)*

```apex
// 문자열 보간 — String.format()의 현대적 대안
String name = 'Salesforce';
String result = String.template('Hello, ${name}!');  // 'Hello, Salesforce!'

// String.format() 비교
String old = String.format('Hello, {0}!', new List<Object>{name});
```

### 멀티라인 문자열 리터럴 *(Summer '26 추가)*

```apex
// 연결 연산자 없이 여러 줄 문자열 작성
String query =
    'SELECT Id, Name ' +
    'FROM Account ' +
    'WHERE IsActive = true';

// v67.0+ — 멀티라인 리터럴 (들여쓰기 공백 자동 제거)
String query2 = '''
    SELECT Id, Name
    FROM Account
    WHERE IsActive = true
    ''';
```

---

## 2. 숫자 타입

```apex
// Integer (32비트, 최대 약 21억)
Integer i = 100;
i.format()        // '100' (로케일 포맷)
Math.abs(i)
Math.max(i, 200)
Math.min(i, 50)

// Long (64비트, 정수 대용량)
Long l = 9999999999L;

// Double (부동소수점)
Double d = 3.14;
d.format()        // 로케일 포맷

// Decimal (고정소수점, 금액에 사용)
Decimal dec = 1234.567;
dec.setScale(2)           // 1234.57 (반올림)
dec.setScale(2, RoundingMode.DOWN)  // 1234.56
dec.round()               // 1235
dec.abs()
dec.format()              // '1,234.567'
dec.toPlainString()       // '1234.567'
Decimal.valueOf('1234.56')
```

---

## 3. Date / Time / DateTime

```apex
// Date
Date today = Date.today();
Date d = Date.newInstance(2026, 5, 17);
d.year()    // 2026
d.month()   // 5
d.day()     // 17
d.daysBetween(Date.today())
d.addDays(7)
d.addMonths(1)
d.addYears(1)
d.isSameDay(Date.today())
Date.isLeapYear(2024)        // true
Date.daysInMonth(2026, 2)    // 28

// Time
Time t = Time.newInstance(14, 30, 0, 0);  // 14:30:00.000
t.hour()   // 14
t.minute() // 30

// DateTime
DateTime dt = DateTime.now();
DateTime dt2 = DateTime.newInstance(2026, 5, 17, 14, 30, 0);
dt.date()              // Date 부분 추출
dt.time()              // Time 부분 추출
dt.addDays(1)
dt.addHours(2)
dt.format('yyyy-MM-dd HH:mm:ss')
dt.format('yyyy-MM-dd', 'Asia/Seoul')  // 타임존 포함
DateTime.valueOf('2026-05-17 14:30:00')
dt.getTime()           // 에포크 밀리초 (Long)
```

---

## 4. List

```apex
List<String> names = new List<String>{'Alice', 'Bob', 'Charlie'};

// 기본
names.size()           // 3
names.isEmpty()        // false
names.get(0)           // 'Alice'
names.set(0, 'Anna')   // 인덱스 0을 'Anna'로 교체
names.add('Dave')      // 끝에 추가
names.add(1, 'Beth')   // 인덱스 1에 삽입
names.remove(0)        // 인덱스 0 삭제
names.clear()
names.contains('Bob')
names.indexOf('Bob')   // 없으면 -1

// 정렬
names.sort();                           // 기본 오름차순
names.sort(new MyComparator());        // Comparator 주입 (Winter '24+)

// 변환
Set<String> nameSet = new Set<String>(names);
List<String> copy = names.clone();     // 얕은 복사
List<String> deep = names.deepClone(); // 깊은 복사 (SObject 전용)

// 반복
for (String name : names) { }
for (Integer i = 0; i < names.size(); i++) { names[i]; }
```

---

## 5. Set

```apex
Set<String> s = new Set<String>{'a', 'b', 'c'};

s.add('d')
s.remove('a')
s.contains('b')    // true
s.size()
s.isEmpty()
s.clear()

// 집합 연산
Set<String> other = new Set<String>{'b', 'c', 'e'};
s.addAll(other)           // 합집합 (s에 병합)
s.retainAll(other)        // 교집합 (s에 남김)
s.removeAll(other)        // 차집합 (other에 있는 것 제거)
s.containsAll(other)      // 포함 여부

// 변환
List<String> lst = new List<String>(s);
```

---

## 6. Map

```apex
Map<String, Integer> scores = new Map<String, Integer>{
    'Alice' => 95,
    'Bob'   => 87
};

// 기본
scores.put('Charlie', 92)
scores.get('Alice')             // 95
scores.getOrDefault('Dave', 0)  // 0 (키 없을 때 기본값)
scores.containsKey('Bob')       // true
scores.remove('Bob')
scores.size()
scores.isEmpty()
scores.clear()

// 키/값 순회
for (String key : scores.keySet()) { }
for (Integer val : scores.values()) { }
for (String key : scores.keySet()) {
    Integer val = scores.get(key);
}

// SObject ID → Record Map (자주 쓰는 패턴)
Map<Id, Account> accMap = new Map<Id, Account>(
    [SELECT Id, Name FROM Account]
);
```

---

## 7. Math

```apex
Math.abs(-5)              // 5
Math.max(3, 7)            // 7
Math.min(3, 7)            // 3
Math.round(3.6)           // 4 (Long 반환)
Math.floor(3.9)           // 3.0
Math.ceil(3.1)            // 4.0
Math.pow(2, 10)           // 1024.0
Math.sqrt(16.0)           // 4.0
Math.log(Math.E)          // 1.0
Math.random()             // 0.0 ~ 1.0 Double
Math.mod(10, 3)           // 1

// 상수
Math.PI                   // 3.14159...
```

---

## 8. JSON

```apex
// 직렬화
Account acc = new Account(Name = 'Test', Phone = '010-1234-5678');
String json = JSON.serialize(acc);
String pretty = JSON.serializePretty(acc);

// 역직렬화
Account restored = (Account) JSON.deserialize(json, Account.class);
Map<String, Object> map = (Map<String, Object>) JSON.deserializeUntyped(json);

// 검증
try {
    Object parsed = JSON.deserializeUntyped(json);
} catch (JSONException e) { }

// 복잡한 구조
public class MyWrapper {
    public String name;
    public Integer count;
    public List<String> items;
}
MyWrapper w = (MyWrapper) JSON.deserialize(json, MyWrapper.class);
```

---

## 9. Blob & EncodingUtil

```apex
// Blob 생성
Blob b = Blob.valueOf('Hello');
Blob fromB64 = EncodingUtil.base64Decode('SGVsbG8=');

// 변환
String s = b.toString();
String b64 = EncodingUtil.base64Encode(b);
String hex = EncodingUtil.convertToHex(b);
Blob fromHex = EncodingUtil.convertFromHex(hex);

// URL 인코딩
String encoded = EncodingUtil.urlEncode('hello world', 'UTF-8');  // 'hello+world'
String decoded = EncodingUtil.urlDecode(encoded, 'UTF-8');

// MD5 (해시 — 보안 목적엔 Crypto 사용)
Blob hash = Crypto.generateDigest('MD5', Blob.valueOf('data'));
```

---

## 10. Database

*(apex-recipes-main/DMLRecipes.cls 발췌 — Tier 1)*

```apex
// INSERT
Database.SaveResult[] results = Database.insert(records, false);  // allOrNothing=false
Database.SaveResult[] results2 = Database.insert(records, false, AccessLevel.USER_MODE);  // v67.0+

// 키워드 방식 (v67.0부터 USER_MODE 기본)
insert as user new Account(Name = 'Test');
insert as system new Account(Name = 'Test');

// UPDATE
Database.SaveResult[] r = Database.update(records, true);

// UPSERT
Database.UpsertResult[] r = Database.upsert(records, Account.My_External_Id__c, false);

// DELETE
Database.DeleteResult[] r = Database.delete(records, false);

// UNDELETE
Database.UndeleteResult[] r = Database.undelete(records, false);

// Merge
Database.MergeResult r = Database.merge(master, duplicate);

// 결과 처리
for (Database.SaveResult sr : results) {
    if (!sr.isSuccess()) {
        for (Database.Error err : sr.getErrors()) {
            System.debug(err.getMessage());
            System.debug(err.getStatusCode());
            System.debug(err.getFields());
        }
    }
}

// 동적 SOQL
List<Account> accs = Database.query('SELECT Id FROM Account', AccessLevel.USER_MODE);

// Savepoint (트랜잭션 롤백)
Savepoint sp = Database.setSavepoint();
try {
    insert new Account(Name = 'Test');
} catch (Exception e) {
    Database.rollback(sp);
}
// v60.0+ : callout 후 releaseSavepoint 가능
Database.releaseSavepoint(sp);

// Cursor (Summer '24 Beta)
Database.Cursor cursor = Database.getCursor(
    [SELECT Id, Name FROM Account ORDER BY Name]
);
Integer totalSize = cursor.getNumRecords();
List<Account> page = cursor.fetch(0, 200);  // offset, count
```

---

## 11. System & Limits

```apex
// System
System.debug('message');
System.debug(LoggingLevel.ERROR, 'error');
System.assert(condition, 'message');
System.assertEquals(expected, actual, 'message');
System.assertNotEquals(notExpected, actual);
System.currentTimeMillis()          // 에포크 밀리초
System.now()                        // DateTime
System.today()                      // Date
System.runAs(user) { }              // 다른 사용자로 실행 (테스트 전용)
System.enqueueJob(new MyQueueable())
System.scheduleBatch(new MyBatch(), 'JobName', cronExp, scopeSize)
System.maxQueueableDepth            // 최대 체이닝 깊이 (Winter '24+)
System.isBatch()
System.isFuture()
System.isQueueable()
System.isScheduled()

// Limits — 현재 거버너 한도 조회
Limits.getCpuTime()              // 현재 CPU 사용량 (ms)
Limits.getLimitCpuTime()         // 최대 허용 CPU (ms)
Limits.getQueries()              // 현재 SOQL 쿼리 수
Limits.getLimitQueries()         // 최대 허용 쿼리 수
Limits.getDmlStatements()        // 현재 DML 횟수
Limits.getLimitDmlStatements()   // 최대 허용 DML 횟수
Limits.getHeapSize()             // 현재 힙 크기 (bytes)
Limits.getLimitHeapSize()        // 최대 허용 힙 크기 (bytes)
Limits.getDmlRows()              // 현재 DML 처리 행 수
Limits.getLimitDmlRows()         // 최대 허용 DML 행 수 (10,000)
Limits.getQueryRows()            // 현재 쿼리 반환 행 수
Limits.getLimitQueryRows()       // 최대 허용 쿼리 행 수 (50,000)
Limits.getCallouts()             // 현재 callout 횟수
Limits.getLimitCallouts()        // 최대 허용 callout 횟수 (100)

// 자주 쓰는 패턴
if (Limits.getDmlStatements() < Limits.getLimitDmlStatements() - 5) {
    // 안전한 경우에만 DML
}
```

---

## 12. Schema

```apex
// 오브젝트 메타데이터
Schema.SObjectType accType = Schema.SObjectType.Account;
Schema.DescribeSObjectResult desc = Account.SObjectType.getDescribe();
String label = desc.getLabel();
String pluralLabel = desc.getLabelPlural();
String apiName = desc.getName();
Boolean isCustom = desc.isCustom();
Boolean isQueryable = desc.isQueryable();
Boolean isCreateable = desc.isCreateable();

// 필드 메타데이터
Map<String, Schema.SObjectField> fields = desc.fields.getMap();
Schema.DescribeFieldResult fieldDesc = Account.Name.getDescribe();
fieldDesc.getLabel()
fieldDesc.getType()        // Schema.DisplayType.STRING
fieldDesc.isUpdateable()
fieldDesc.isNillable()
fieldDesc.isRequired() // 계산값
fieldDesc.getLength()

// Picklist 값
List<Schema.PicklistEntry> entries = Account.Type.getDescribe().getPicklistValues();
for (Schema.PicklistEntry entry : entries) {
    entry.getValue()
    entry.getLabel()
    entry.isActive()
    entry.isDefaultValue()
}

// Record Type
List<Schema.RecordTypeInfo> rtInfos = desc.getRecordTypeInfos();
for (Schema.RecordTypeInfo rt : rtInfos) {
    rt.getRecordTypeId()
    rt.getName()
    rt.getDeveloperName()
    rt.isAvailable()
    rt.isMaster()
}

// 동적 SObject 생성
SObject newRecord = accType.newSObject();
newRecord.put('Name', 'Dynamic Account');
```

---

## 13. Crypto

*(apex-recipes-main/EncryptionRecipes.cls 발췌 — Tier 1)*

```apex
// AES 대칭 암호화 (키 공유 방식)
Blob key = Crypto.generateAESKey(256);  // 128 | 192 | 256

// IV 자동 관리 (권장)
Blob encrypted = Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('data'));
Blob decrypted = Crypto.decryptWithManagedIV('AES256', key, encrypted);

// IV 직접 관리
Blob iv = Crypto.generateAESKey(128);  // 16바이트 IV
Blob encrypted2 = Crypto.encrypt('AES256', key, iv, Blob.valueOf('data'));
Blob decrypted2 = Crypto.decrypt('AES256', key, iv, encrypted2);

// 해시 (단방향)
Blob hash = Crypto.generateDigest('SHA-512', Blob.valueOf('data'));
// 알고리즘: MD5 | SHA1 | SHA-256 | SHA-512

// HMAC (메시지 인증)
Blob hmacKey = Blob.valueOf('secret');
Blob hmac = Crypto.generateMac('HmacSHA512', Blob.valueOf('data'), hmacKey);
Boolean valid = Crypto.verifyHMAC('HmacSHA512', Blob.valueOf('data'), hmacKey, hmac);

// RSA 디지털 서명 (비대칭)
Blob privateKey = EncodingUtil.base64Decode('...PEM base64...');
Blob signature = Crypto.sign('RSA-SHA512', Blob.valueOf('data'), privateKey);
Blob pubKey = EncodingUtil.base64Decode('...PEM base64...');
Boolean verified = Crypto.verify('RSA-SHA512', Blob.valueOf('data'), signature, pubKey);
```

---

## 14. Type & ID

```apex
// Type — 동적 클래스 인스턴스화
Type t = Type.forName('MyClass');
Type t2 = Type.forName('my_namespace', 'MyClass');
Object instance = t.newInstance();

// ID 유효성
Boolean valid = ID.isValid('001000000000000');     // true
ID id = ID.valueOf('001000000000000AAA');

// ID에서 SObjectType 확인
Id accountId = '001000000000001AAA';
Schema.SObjectType sObjType = accountId.getSObjectType();  // Account
```

---

## 15. UserInfo & URL

```apex
// UserInfo — 현재 로그인 사용자 정보
UserInfo.getUserId()             // Id
UserInfo.getFirstName()
UserInfo.getLastName()
UserInfo.getName()               // 전체 이름
UserInfo.getEmail()
UserInfo.getUserName()
UserInfo.getProfileId()
UserInfo.getUserRoleId()
UserInfo.getOrganizationId()
UserInfo.getOrganizationName()
UserInfo.getDefaultCurrency()
UserInfo.getLanguage()
UserInfo.getLocale()
UserInfo.getTimeZone().getID()
UserInfo.isCurrentUserLicensed('Service Cloud')
UserInfo.getUiThemeDisplayed()   // 'Theme4d' (Lightning) / 'Theme3' (Classic)

// URL — 조직 도메인 URL
String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
String orgUrl = URL.getOrgDomainUrl().toExternalForm();

// PageReference
PageReference pr = new PageReference('/apex/MyPage');
pr.getParameters().put('id', recordId);
String url = pr.getUrl();
```

---

## 16. Exception

```apex
// 커스텀 예외 정의
public class MyException extends Exception {}
public class MyApplicationException extends Exception {
    public Integer errorCode;
    public MyApplicationException(String msg, Integer code) {
        this(msg);
        this.errorCode = code;
    }
}

// 예외 발생·처리
try {
    throw new MyException('에러 메시지');
} catch (MyException e) {
    e.getMessage()
    e.getTypeName()       // 'MyException'
    e.getStackTraceString()
    e.getCause()          // 원인 예외
    e.initCause(cause)    // 원인 설정
} catch (DmlException e) {
    e.getNumDml()
    e.getDmlId(0)
    e.getDmlMessage(0)
    e.getDmlType(0)       // StatusCode
    e.getDmlFieldNames(0) // 오류 필드 목록
} catch (Exception e) {
    // 모든 예외 잡기
} finally {
    // 항상 실행
}

// 주요 시스템 예외
// DmlException — DML 오류
// QueryException — SOQL 오류 (다중 행 반환, 0건 등)
// NullPointerException — null 참조
// LimitException — 거버너 한도 초과 (catch 불가)
// CalloutException — HTTP Callout 오류
// JSONException — JSON 파싱 오류
// MathException — 0으로 나누기 등
```

---

## 17. Test

```apex
@IsTest
public class MyTest {
    @TestSetup
    static void setup() {
        // 공유 데이터 준비 — 각 테스트 메서드 실행 전 롤백됨
        insert new Account(Name = 'Test');
    }

    @IsTest
    static void testMyMethod() {
        Test.startTest();
        // 비동기 실행 경계 — startTest/stopTest 사이에서 한도 리셋
        MyClass.doSomething();
        Test.stopTest();

        System.assertEquals(expected, actual, 'message');
        System.assertNotEquals(notExpected, actual);
        System.assert(condition, 'message');
    }
}

// 유틸리티 메서드
Test.isRunningTest()            // 테스트 컨텍스트 여부
Test.setMock(HttpCalloutMock.class, new MockClass())  // HTTP 모킹
Test.setMock(WebServiceMock.class, new MockClass())   // SOAP 모킹
Test.setCreatedDate(recordId, DateTime.newInstance(2020,1,1))  // 생성일 조작

// StubProvider (인터페이스 모킹)
Test.createStub(Type targetType, StubProvider stubProvider)
```

---

## 18. 신규 클래스 (릴리즈별)

### Comparator & Collator *(Winter '24 — v59.0)*

*(apex-recipes-main/ListSortingRecipes.cls 발췌 — Tier 1)*

```apex
// Comparator<T> — 커스텀 정렬
public class AccountComparator implements Comparator<Account> {
    public Integer compare(Account a, Account b) {
        return a.Name.compareTo(b.Name);
    }
}
accounts.sort(new AccountComparator());

// Collator — 로케일 인식 정렬
Collator col = Collator.getInstance();
col.setStrength(Collator.TERTIARY);  // PRIMARY | SECONDARY | TERTIARY | IDENTICAL
col.compare('apple', 'APPLE')        // 양수 (대소문자 구분)
names.sort(col);
```

### UUID *(Spring '24 — v60.0)*

```apex
// RFC 4122 UUID 생성
UUID id = UUID.randomUUID();
String uuidStr = id.toString();  // 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
UUID parsed = UUID.fromString(uuidStr);
Boolean equal = id.equals(parsed);
```

### Compression *(Spring '24 — v60.0)*

```apex
// ZIP 압축/해제
Compression.ZipWriter writer = Compression.ZipWriter.createZipWriter();
writer.addEntry('file1.txt', Blob.valueOf('Hello'));
writer.addEntry('file2.txt', Blob.valueOf('World'));
Blob zipBlob = writer.getArchive();

Compression.ZipReader reader = Compression.ZipReader.createZipReader(zipBlob);
List<String> entries = reader.getEntryNames();
Blob fileContent = reader.getEntry('file1.txt').getContent();
```

### DataWeave *(Winter '24 GA — v59.0)*

```apex
// DWL 스크립트를 Apex에서 실행 — JSON/XML/CSV 변환
DataWeave.Script script = DataWeave.Script.createScript(
    'output application/json\n' +
    '---\n' +
    'payload map (item) -> { id: item.Id, name: item.Name }'
);
String inputJson = '[{"Id":"001xx","Name":"Acme"}]';
DataWeave.Result result = script.execute(
    new Map<String, Object>{'payload' => inputJson}
);
String outputJson = result.getValueAsString();
```

### FormulaEval / FormulaBuilder *(Spring '24 v60 / Summer '25 v64)*

```apex
// 동적 수식 평가 (Spring '24)
FormulaEval.FormulaInstance fi = FormulaEval.formulaInstance(
    Account.getSObjectType(),
    'Name + \' — \' + TEXT(AnnualRevenue)',
    FormulaEval.FormulaReturnType.STRING
);
String result = (String) fi.evaluate(accountRecord);

// 템플릿 파싱 (Summer '25)
FormulaBuilder.FormulaTemplate template =
    FormulaBuilder.parseAsTemplate('Hello, {!Name}!');
String rendered = (String) template.buildWithContext(accountRecord);
```

### EventBus.publishWithAccessLevel() *(Summer '26 — v67.0)*

```apex
// Platform Events 발행 시 접근 레벨 명시 (Summer '26 신규)
My_Event__e evt = new My_Event__e(Payload__c = 'test');
EventBus.publish(evt);  // 기존 방식 (System mode)
EventBus.publishWithAccessLevel(
    new List<SObject>{evt},
    AccessLevel.USER_MODE   // 또는 SYSTEM_MODE
);
```

---

## 자주 쓰는 조합 패턴

```apex
// 1. ID Set → Record Map
Set<Id> ids = new Set<Id>{'001xx', '001yy'};
Map<Id, Account> accMap = new Map<Id, Account>([
    SELECT Id, Name FROM Account WHERE Id IN :ids WITH USER_MODE
]);

// 2. 안전한 List/Map 조회
String name = accMap.containsKey(someId) ? accMap.get(someId).Name : '없음';

// 3. JSON ↔ SObject
String json = JSON.serialize(account);
Account clone = (Account) JSON.deserialize(json, Account.class);

// 4. 거버너 한도 체크
if (Limits.getDmlStatements() + records.size() <= Limits.getLimitDmlStatements()) {
    Database.insert(records, false, AccessLevel.USER_MODE);
}

// 5. 동적 필드 읽기
Object val = record.get('CustomField__c');
String strVal = val != null ? String.valueOf(val) : '';
```

---

## 관련 노트

- [[SOQL 패턴]] — Database.query, WITH USER_MODE, Cursor
- [[DML 패턴]] — insert/update as user, Database.insert + AccessLevel
- [[Comparator 인터페이스]] — List.sort(Comparator) 상세
- [[Safely]] — StripInaccessible, CanTheUser
- [[Batch Apex]] — Database.executeBatch, getCursor
- [[Queueable]] — System.enqueueJob
- [[Summer '26]] — String.template, multiline, EventBus.publishWithAccessLevel
- [[Spring '24]] — UUID, Compression, FormulaEval
- [[Winter '24]] — DataWeave, Comparator, Collator
