---
tags: [index, apex, integration, http]
created: 2026-05-17
---

# Integration(통합) — 로컬 인덱스

> Apex HTTP 연동 — 외부 호출 추상화, 인바운드 REST 엔드포인트

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[RestClient 패턴]] | virtual class, Named Credential callout:, PATCH 우회 | #pattern |
| [[Custom REST Endpoint]] | @RestResource, global inherited sharing, RestContext | #pattern |
| [[ConnectApi Chatter 패턴]] | postFeedItemWithRichText, @멘션, Flow 리치 텍스트 변환 | #pattern |
| [[Dom Namespace]] | Dom.Document + Dom.XmlNode — XML 생성·파싱, HTTP 연동 | #reference |
| [[DataSource Namespace]] | Salesforce Connect 커스텀 어댑터 — Provider/Connection/sync/query/search/upsert | #reference |
| [[ExternalService Namespace]] | OpenAPI 스펙 기반 타입 안전 외부 서비스 호출 — ExternalService.<ServiceName> | #reference |
| [[Invocable Namespace]] | Apex에서 Flow Action 동적 호출 — createStandardAction, addInvocation, invoke, getDescribe | #reference |

---

## 빠른 선택

- Apex에서 외부 API 호출? → [[RestClient 패턴]]
- 외부 시스템이 Salesforce를 REST로 호출? → [[Custom REST Endpoint]]
- Chatter 피드에 게시(리치 텍스트, @멘션)? → [[ConnectApi Chatter 패턴]]
- HTTP 요청/응답 본문을 XML로 처리? → [[Dom Namespace]]
- 외부 시스템 데이터를 External Object로 연결? → [[DataSource Namespace]]
- OpenAPI 스펙으로 타입 안전 외부 호출? → [[ExternalService Namespace]]
- Apex에서 Flow Action / 표준 액션 호출? → [[Invocable Namespace]]

## 관련 폴더

Named Credential 설정 → [[Integration(통합)/Named Credential]] | 비동기 HTTP → [[Apex/Async(비동기)/index|Async(비동기)]] → [[Queueable]]
