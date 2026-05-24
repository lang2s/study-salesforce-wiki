---
tags: [apex, industriesnlpsvc, namespace, nlp, ai, einstein, industries, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — industriesNlpSvc Namespace (doc p.2926~2927)
created: 2026-05-20
aliases: [industriesNlpSvc Namespace, NlpResponse, NlpSummarizationResult, Industries NLP Apex, Einstein NLP 요약 Apex, 자연어처리 Apex, transformNlpActionResult 출력]
---

# industriesNlpSvc Namespace

> Industries Einstein 자연어 처리(NLP) 서비스 Apex 객체 네임스페이스. `transformNlpActionResult` Invocable Action의 출력 클래스를 포함한다.

---

## 클래스 목록

| 클래스 | 설명 |
|---|---|
| `NlpResponse` | NLP 작업(SurveyLongSummarization·SurveyShortSummarization) 수행 결과 저장 |
| `NlpSummarizationResult` | NLP 작업으로 얻어진 요약 텍스트 제공 |

---

## NlpResponse 클래스

NLP 작업 수행 결과를 저장한다. `SurveyLongSummarization`, `SurveyShortSummarization` 두 가지 NLP 작업 유형을 지원한다.

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `summarizationResult` | `industriesNlpSvc.NlpSummarizationResult` | NLP 요약 작업 결과 객체 |
| `errors` | `List<String>` | NLP 작업 중 발생한 오류 목록 |

```apex
public industriesNlpSvc.NlpSummarizationResult summarizationResult {get; set;}
public List<String> errors {get; set;}
```

---

## NlpSummarizationResult 클래스

NLP 작업 결과로 얻어진 요약 텍스트를 제공한다.

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `summary` | `String` | NLP 작업 결과 요약 텍스트 |

```apex
public String summary {get; set;}
```

---

## 코드 예시

```apex
// transformNlpActionResult Invocable Action 결과 처리 패턴
// (Action 자체는 Flow 또는 Invocable Namespace를 통해 호출)
industriesNlpSvc.NlpResponse nlpResult = new industriesNlpSvc.NlpResponse();

// 오류 확인
if (nlpResult.errors != null && !nlpResult.errors.isEmpty()) {
    for (String err : nlpResult.errors) {
        System.debug('NLP 오류: ' + err);
    }
}

// 요약 결과 접근
if (nlpResult.summarizationResult != null) {
    String summaryText = nlpResult.summarizationResult.summary;
    System.debug('NLP 요약 결과: ' + summaryText);
}
```

---

## 관련 노트

- [[Invocable Namespace]] — `transformNlpActionResult` Invocable Action 호출 패턴
- [[ConnectApi Namespace 개요]] — EinsteinLLM 그룹 AI 연동 클래스
- [[fsccashflow Namespace]] — Financial Services Cloud 도메인 자매 네임스페이스 (Industries Cloud 계열)
