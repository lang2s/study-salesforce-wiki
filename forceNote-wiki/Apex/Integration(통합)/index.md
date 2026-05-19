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
| [[ConnectApi Namespace 개요]] | Connect in Apex 전체 클래스 목록 — ChatterFeeds/EinsteinLLM/CdpQuery/CommerceCart/Communities, setTest* 패턴 | #reference |
| [[Dom Namespace]] | Dom.Document + Dom.XmlNode — XML 생성·파싱, HTTP 연동 | #reference |
| [[DataSource Namespace]] | Salesforce Connect 커스텀 어댑터 — Provider/Connection/sync/query/search/upsert | #reference |
| [[ExternalService Namespace]] | OpenAPI 스펙 기반 타입 안전 외부 서비스 호출 — ExternalService.<ServiceName> | #reference |
| [[Invocable Namespace]] | Apex에서 Flow Action 동적 호출 — createStandardAction, addInvocation, invoke, getDescribe | #reference |
| [[Process Namespace]] | 레거시 Flow 플러그인 — Process.Plugin 인터페이스 (deprecated, @InvocableMethod 권장) | #reference |
| [[QuickAction Namespace]] | Quick Action 실행·조회, Case Feed 이메일 기본값 커스터마이징 — performQuickAction, describeAvailableQuickActions | #reference |
| [[Metadata Namespace]] | CMT 레코드 Apex 배포·조회 — CustomMetadata, DeployContainer, Operations.enqueueDeployment, DeployCallback | #reference |
| [[Compression Namespace]] | Apex Zip 압축·해제 — ZipWriter.addEntry/getArchive, ZipReader.extract, Spring '25 GA | #reference |
| [[DataWeave Namespace]] | Apex에서 DataWeave 스크립트 실행 — Script.createScript, execute, Result.getValueAsString | #reference |
| [[KbManagement Namespace]] | Knowledge Article 라이프사이클 API — PublishingService, 게시·번역·보관·삭제 전체 메서드 | #reference |

---

## 빠른 선택

- Apex에서 외부 API 호출? → [[RestClient 패턴]]
- 외부 시스템이 Salesforce를 REST로 호출? → [[Custom REST Endpoint]]
- Chatter 피드에 게시(리치 텍스트, @멘션)? → [[ConnectApi Chatter 패턴]]
- ConnectApi 어떤 클래스 써야 할지? → [[ConnectApi Namespace 개요]]
- HTTP 요청/응답 본문을 XML로 처리? → [[Dom Namespace]]
- 외부 시스템 데이터를 External Object로 연결? → [[DataSource Namespace]]
- OpenAPI 스펙으로 타입 안전 외부 호출? → [[ExternalService Namespace]]
- Apex에서 Flow Action / 표준 액션 호출? → [[Invocable Namespace]]
- Quick Action 프로그래밍적 실행? → [[QuickAction Namespace]]
- Case Feed 이메일 기본값 커스터마이징? → [[QuickAction Namespace]] → QuickActionDefaultsHandler
- 레거시 Process.Plugin 마이그레이션? → [[Process Namespace]] (deprecated)
- Apex에서 CMT 레코드 만들거나 배포? → [[Metadata Namespace]]
- 파일 여러 개를 Zip으로 묶어야 할 때? → [[Compression Namespace]]
- JSON/XML/CSV 데이터 변환을 선언적으로? → [[DataWeave Namespace]]
- Knowledge 아티클 게시·번역·보관을 Apex로? → [[KbManagement Namespace]]

## 관련 폴더

Named Credential 설정 → [[Integration(통합)/Named Credential]] | 비동기 HTTP → [[Apex/Async(비동기)/index|Async(비동기)]] → [[Queueable]]
