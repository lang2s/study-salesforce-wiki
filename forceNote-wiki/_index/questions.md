---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 자연어 질문
> "~하는 방법" 형태 자연어 질문 → 파일 (교차 도메인 라우팅 보조)
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## 자연어 질문 패턴 → 파일

| 질문 | 파일 |
|---|---|
| Apex에서 LWC로 데이터 보내는 방법 | `LWC/ApexIntegration(Apex통합)/Wire 패턴.md` |
| 자식 컴포넌트에서 부모로 데이터 전달 | `LWC/Events(이벤트)/CustomEvent 패턴.md` |
| 관계없는 컴포넌트끼리 통신 | `LWC/Events(이벤트)/Lightning Message Service.md` |
| 다른 LWC의 함수 호출 | `LWC/ComponentAPI(컴포넌트API)/@api 패턴.md` + `LWC/Events(이벤트)/Lightning Message Service.md` |
| 외부 API 호출하는 방법 | `Apex/Integration(통합)/RestClient 패턴.md` + `Integration(통합)/Named Credential.md` |
| 외부에서 Salesforce API 호출 | `Apex/Integration(통합)/Custom REST Endpoint.md` |
| Trigger에서 HTTP 호출 | `Integration(통합)/Queueable + Callout 패턴.md` |
| 레코드 저장/수정/삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 대용량 데이터 처리 | `Apex/Async(비동기)/Batch Apex.md` |
| 테스트에서 HTTP 호출 모킹 | `Apex/Testing(테스트)/HttpCalloutMock.md` |
| Flow에서 Apex 쓰는 방법 | `Flow/@InvocableMethod 패턴.md` |
| Apex에서 Flow 실행하는 방법 | `Flow/Flow Interview API.md` |
| Apex에서 이메일 보내는 방법 | `Apex/Messaging(메시징)/SingleEmailMessage.md` |
| 사용자에게 알림 보내는 방법 Apex | `Apex/Messaging(메시징)/CustomNotification.md` |
| 승인 프로세스 Apex로 제어 | `Architecture(아키텍처)/Approval Namespace.md` |
| CDC 트리거 변경 필드 확인 | `Apex/PlatformEvents(플랫폼이벤트)/ChangeEventHeader.md` |
| DML 결과 에러 처리 방법 | `Apex/Data(데이터)/Database Namespace 상세.md` |
| 리드 전환 Apex | `Apex/Data(데이터)/Database Namespace 상세.md` |
| SOSL 검색 결과 Apex에서 | `Apex/Data(데이터)/Search Namespace.md` |
| 오브젝트 메타데이터 필드 목록 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 레코드 타입 ID 코드에서 조회 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 피클리스트 값 Apex에서 가져오기 | `Architecture(아키텍처)/Schema Namespace 상세.md` |
| 시스템 간 이벤트 연동 | `Integration(통합)/Platform Event 통합 패턴.md` |
| 레코드 삭제 LWC에서 | `LWC/LDS/uiRecordApi.md` |
| 정렬 Apex에서 | `Apex/Collections(컬렉션)/Comparator 인터페이스.md` |
| 스케줄 자동 실행 Apex | `Apex/Async(비동기)/Scheduled Apex.md` |
| 로그 남기는 방법 | `Apex/Logging(로깅)/Log 싱글턴 패턴.md` |
| 캐시 사용하는 방법 | `Apex/PlatformCache(플랫폼캐시)/Platform Cache.md` |
| 공유 규칙 보안 적용 | `Apex/Security(보안)/Safely.md` |
| 데이터 조회 쿼리 | `Apex/Data(데이터)/SOQL 패턴.md` |
| 여러 오브젝트에서 키워드 검색 | `Apex/Data(데이터)/SOSL 패턴.md` |
| Aura 컴포넌트 만드는 방법 | `Aura(오라)/Aura 컴포넌트 구조.md` |
| Aura에서 LWC로 전환하는 방법 | `Aura(오라)/Aura vs LWC.md` |
| Salesforce 처음 사용법 | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Salesforce 로그인 MFA 설정 | `Admin(어드민)/Salesforce ID 인증.md` |
| 앱 런처 사용 방법 | `Admin(어드민)/Salesforce 네비게이션.md` |
| Apex에서 Custom Metadata 레코드 만들기 | `Apex/Integration(통합)/Metadata Namespace.md` |
| DX 프로젝트 시작하는 방법 | `DevOps(데브옵스)/Salesforce DX 개요.md` |
| Scratch Org 만드는 방법 | `DevOps(데브옵스)/Scratch Org 패턴.md` |
| Jenkins로 Salesforce CI 구성 | `DevOps(데브옵스)/CI CD 패턴.md` |
| 패키지 만들고 설치하는 방법 | `DevOps(데브옵스)/Unlocked Package 패턴.md` |
| Knowledge 아티클 Apex로 게시하는 방법 | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 번역 제출 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
| Knowledge 아티클 보관 스케줄 Apex | `Apex/Integration(통합)/KbManagement Namespace.md` |
