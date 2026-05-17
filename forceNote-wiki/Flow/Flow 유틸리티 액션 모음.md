---
tags: [flow, invocable, utility, business-hours, chatter, string, pattern]
source: automation-components/src-utilities, src-strings, src-messaging, src-flows
created: 2026-05-17
aliases: [CalculateBusinessHours, GetRandomValue, FormatStringListAsCsv, ParseCsvAsStringList, PostRichChatter, GenerateFlowLink, LaunchAutolaunchedFlow, Flow 영업시간, Flow Chatter]
---

# Flow 유틸리티 액션 모음

> Flow에서 자주 필요한 잡다한 처리를 Invocable Action으로 해결하는 패턴. 영업시간 계산, 문자열 처리, Chatter 게시, Flow 제어까지 포함한다.

---

## CalculateBusinessHours — 영업시간 기준 기간 계산

SLA 마감 계산, 케이스 처리 시간 측정에 활용.

```apex
@InvocableMethod(label='Calculates the duration in terms business hours between two dates')

private static OutputParameters invoke(InputParameters input) {
    // BusinessHours.diff() — 영업시간 기준 밀리초 반환
    Long durationMs = BusinessHours.diff(
        input.businessHoursId,
        input.startDate,
        input.endDate
    );
    output.durationMs    = durationMs;
    output.durationSec   = durationMs / 1000;
    output.durationMin   = durationMs / 60000;
    output.durationHours = durationMs / 3600000;
    output.durationDays  = durationMs / 86400000;
}

// 입력: businessHoursId(Id), startDate(DateTime), endDate(DateTime)
// 출력: durationMs / durationSec / durationMin / durationHours / durationDays (Long)
```

**활용 예:**
- Case 생성 시각 → 지금까지 영업시간 기준 경과일 계산
- SLA 잔여 시간 = SLA 기한 − 현재 시각 (영업시간 기준)

---

## GetRandomValue — 난수 생성

```apex
// 입력: randomType('number' 또는 'boolean'), minNumber(Integer), maxNumber(Integer)
// 출력: randomNumber(Double), randomBoolean(Boolean)

// number 타입: min + Math.random() * (max - min)
// boolean 타입: Math.random() < 0.5
```

**활용 예:** A/B 테스트 Flow 분기, 랜덤 담당자 배정

---

## FormatStringListAsCsv — 문자열 목록 → CSV

```apex
// 입력: strings(String[], 필수), separator(String, 기본값 ',')
// 출력: csvString(String)

String.join(strings, separator);  // 핵심 구현

// 예: ['apple', 'banana', 'cherry'] + separator=', '
// → 'apple, banana, cherry'
```

---

## ParseCsvAsStringList — CSV 문자열 → 문자열 목록

```apex
// 입력: csvString(String, 필수), separator(정규식, 기본값 ','), trimValues(Boolean)
// 출력: strings(List<String>)

List<String> parts = csvString.split(separator);  // 정규식 분리
if (trimValues) {
    for (Integer i = 0; i < parts.size(); i++) {
        parts[i] = parts[i].trim();
    }
}

// 예: 'apple, banana , cherry' + trim=true → ['apple', 'banana', 'cherry']
```

> [!tip] ExtractStringsFromRecords와의 관계
> 레코드 필드값 → 문자열 목록: ExtractStringsFromRecords
> CSV 문자열 → 목록: ParseCsvAsStringList
> 목록 → CSV: FormatStringListAsCsv

---

## PostRichChatter — 리치 텍스트로 Chatter 게시

Flow 리치 텍스트 변수를 Chatter 피드로 변환 게시.

```apex
// 입력: body(String, 리치 텍스트 HTML), targetNameOrId(String), communityId(Id, 선택)
// 출력: feedItemId(Id)

// HTML 태그 정규식 변환 → ConnectApi 세그먼트로 파싱
// targetNameOrId: 사용자명, 그룹명, 또는 레코드 Id
// ConnectApiHelper.postFeedItemWithRichText() 호출

// 지원 태그: <span>, <a href>, <ol><li>(들여쓰기), <img src>
// 멘션: {MentionId} 형식
```

**활용 예:** 승인 완료 시 관련 그룹에 자동 공지

---

## GenerateFlowLink — Flow 시작 URL 생성

파라미터가 포함된 Flow 링크를 이메일·알림에 삽입할 때 활용.

```apex
// 입력: flowApiName(필수), namespace, param1~3Name/Value
// 출력: flowLink(String)

String flowLink = Url.getOrgDomainUrl().toExternalForm() + '/flow/';
if (!String.isBlank(input.namespace)) {
    flowLink += input.namespace + '/';
}
flowLink += input.flowApiName;

// PageReference로 파라미터 URL 인코딩
System.PageReference pageRef = new System.PageReference(flowLink);
pageRef.getParameters().putAll(flowParams);
flowLink = pageRef.getUrl();

// 결과 예: https://myorg.salesforce.com/flow/My_Flow?recordId=001xx...
```

---

## LaunchAutolaunchedFlow — Flow 안에서 다른 Flow 기동

Flow에서 Autolaunched Flow를 동적으로 호출할 때 사용.

```apex
// 입력: flowApiName(필수), namespace, param1~3Name/Value
// 출력: isSuccess(Boolean), errorMessage(String)

Map<String, String> flowParams = new Map<String, String>();
// 파라미터 이름/값 쌍 검증 후 Map에 추가

Flow.Interview newInterview = Flow.Interview.createInterview(
    input.namespace,
    input.flowApiName,
    flowParams
);
newInterview.start();  // 동기 실행 (현재 트랜잭션 내)
```

> [!warning] 파라미터 타입 제한
> `param1~3Value`가 모두 String 타입. 숫자·날짜 등 다른 타입은 Flow 변수 직접 연결 또는 별도 Apex로 처리.

> [!tip] LaunchAutolaunchedFlow vs SubFlow 요소
> Flow Builder의 SubFlow 요소로도 동일하게 처리 가능. 이 액션은 **동적으로 flowApiName을 결정해야 할 때** 차별화됨.

---

## 비교표

| 상황 | 액션 |
|---|---|
| 케이스 처리 SLA 경과 시간 | CalculateBusinessHours |
| A/B 테스트 랜덤 분기 | GetRandomValue |
| Id 목록을 이메일 텍스트로 | FormatStringListAsCsv |
| 입력 태그 목록 파싱 | ParseCsvAsStringList |
| Flow 완료 후 Chatter 공지 | PostRichChatter |
| 이메일에 Flow 시작 링크 삽입 | GenerateFlowLink |
| 동적 flowApiName으로 다른 Flow 기동 | LaunchAutolaunchedFlow |

---

## 관련 노트

- [[@InvocableMethod 패턴]] — Invocable Action 구조
- [[Autolaunched Flow 패턴]] — Autolaunched Flow 설계
- [[Flow 레코드 컬렉션 조작]] — 컬렉션 조작 액션
- [[Flow 데이터 & 보안 액션]] — 데이터 조회 및 보안 액션
