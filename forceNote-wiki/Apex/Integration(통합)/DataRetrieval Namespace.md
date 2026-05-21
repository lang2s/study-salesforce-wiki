---
tags: [apex, integration, service-cloud, contact-center, engagement, transcript, namespace, stub]
source: salesforce_apex_reference_guide.pdf (doc p.2761, class inventory only — Apex Reference Guide v67.0)
created: 2026-05-22
aliases: [DataRetrieval, Engagement Transcript, RecordTranscripts, EngagementRecordDetails, 상담원 고객 대화 트랜스크립트]
---

# DataRetrieval Namespace

> Service Cloud Contact Center — 상담원-고객 인게이지먼트(대화 세션) 상세 정보 및 대화 트랜스크립트를 Apex에서 조회·기록한다.

> [!warning] 이 노트는 Apex Reference Guide v67.0 doc p.2761의 클래스 인벤토리 목록을 기반으로 작성되었습니다. 메서드 레벨 API 시그니처는 Apex Reference Guide PDF에 수록되지 않았으며, 상세 문서는 Salesforce Service Cloud / Contact Center 개발자 가이드를 참조해야 합니다.

**상위:** [[Integration(통합) index]] → [[00 Home]]

---

## 개요

`DataRetrieval` 네임스페이스는 상담원(agent)과 고객 간의 인게이지먼트(engagement) 세션 상세 정보와 대화 트랜스크립트를 Apex에서 다루기 위한 클래스와 메서드를 제공한다.

- **Engagement** — 상담원-고객 대화 세션 단건 표현 (채널 무관: 전화·채팅·메시징 등)
- **Transcript** — 해당 세션의 대화 내용 전체
- **RecordDetails** 계열 — 인게이지먼트에 연결된 레코드(Case, Contact 등)의 필드·객체 상세

주요 사용처:
- Einstein Conversation Mining (대화 데이터 분석)
- Service Cloud Voice (전화 통화 트랜스크립트 처리)
- Omnichannel 인게이지먼트 기록 저장 및 조회

---

## 클래스 인벤토리 (10개)

| 클래스 | 유형 | 역할 (클래스명 기반 추정) |
|---|---|---|
| `Engagement` | Class | 상담원-고객 인게이지먼트 세션 단건 |
| `Engagements` | Class | 인게이지먼트 목록 / 컬렉션 |
| `EngagementRecordDetails` | Class | 인게이지먼트에 연결된 레코드 상세 단건 |
| `EngagementRecordDetailsList` | Class | 연결 레코드 상세 목록 |
| `FieldDetailsRepresentation` | Class | 필드 값 상세 표현 (레코드 내 개별 필드) |
| `ObjectDetailsRepresentation` | Class | 객체(sObject) 상세 표현 |
| `RecordDetailsRepresentation` | Class | 레코드 상세 표현 (ObjectDetails + FieldDetails 통합) |
| `RecordTranscripts` | Class | 특정 레코드에 연결된 트랜스크립트 조회 |
| `RecordTranscriptsList` | Class | 트랜스크립트 목록 |
| `Transcript` | Class | 개별 대화 트랜스크립트 |

> **참고:** `Representation` 접미사 클래스는 Salesforce ConnectApi 패턴과 유사한 읽기 전용 응답 객체(Output Class)로 추정.

---

## 사용 맥락

### Service Cloud Voice 연동

Service Cloud Voice를 사용하는 org에서 통화(call) 완료 후 트랜스크립트가 자동 생성된다. `DataRetrieval` 네임스페이스를 통해 해당 트랜스크립트를 Apex에서 조회하고, Case나 Contact 레코드에 연결된 내용을 파싱할 수 있다.

### Einstein Conversation Mining

Einstein Conversation Mining은 대화 데이터를 분석해 인텐트(Intent)·엔티티(Entity)를 추출한다. `RecordTranscripts` 클래스를 통해 대상 레코드의 트랜스크립트 데이터를 가져온다.

### Omnichannel Engagement

채팅·메시징·이메일 채널의 인게이지먼트 세션을 `Engagement` / `Engagements` 클래스로 조회·기록할 수 있다.

---

## 예상 사용 패턴 (Tier 3 — 외부 지식)

> **[외부 지식 — Tier 3]** 아래 메서드 시그니처는 Apex Reference PDF에 수록되지 않은 외부 지식 기반 추정이다.

```apex
// 레코드에 연결된 트랜스크립트 목록 조회
DataRetrieval.RecordTranscriptsList transcriptsList =
    DataRetrieval.RecordTranscripts.getTranscripts(caseId);

// 개별 트랜스크립트 접근
for (DataRetrieval.Transcript t : transcriptsList.getTranscripts()) {
    String content = t.getContent();
    // ...
}

// 인게이지먼트 레코드 상세 조회
DataRetrieval.EngagementRecordDetailsList details =
    DataRetrieval.Engagements.getEngagementRecordDetails(engagementId);
```

---

## 관련 Namespace

| 네임스페이스 | 관계 |
|---|---|
| [[RichMessaging Namespace]] | Messaging for In-App & Web 채널 제어 |
| [[Support Namespace]] | Case 마일스톤·이메일 템플릿 |
| [[ise_bots_apex Namespace]] | Einstein Bot 커스텀 대화 처리 |
| [[ConnectApi Namespace 개요]] | Chatter 피드·메시지 API (채널 오버랩) |

---

## 참고 문서

- Salesforce Help: Service Cloud Voice Developer Guide
- Salesforce Help: Einstein Conversation Mining Setup Guide
- Salesforce Help: Omnichannel for Developers
