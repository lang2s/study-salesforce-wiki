---
tags: [index, flow]
created: 2026-05-17
---

# Flow — 로컬 인덱스

> Salesforce Flow 자동화 패턴 — 개념, 타입별 설계, Apex·LWC 연동

**상위:** [[Flow MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Flow 종류와 변수]] | processType 결정, isInput/isOutput 변수, $Flow 전역 변수 | #concept |
| [[Flow 요소 참조]] | XML 요소 전체 참조 — recordLookups/decisions/assignments/actionCalls | #reference |
| [[Flow 네이밍 컨벤션]] | Flow 타입별·요소별 API 이름 패턴 — Get_, SUB_, SC01_, BI/BU/AI/AU/BD | #convention |
| [[Flow 설계 베스트 프랙티스]] | Fast Field Update, 바이패스, 하드코딩 ID 금지, 거버너, Subflow 전략 | #best-practice |
| [[Flow 에러 처리]] | faultConnector 전략, {!$Flow.FaultMessage}, 타입별 에러 처리 방법 | #pattern |
| [[Screen Flow 설계]] | 다단계 마법사 UI, flowruntime 내장 컴포넌트, LWC 삽입, faultConnector | #pattern |
| [[Autolaunched Flow 패턴]] | 헤드리스 로직, 레코드 CRUD, Apex/Agent에서 호출 | #pattern |
| [[@InvocableMethod 패턴]] | Flow Action 표준 구조, bulkInvoke, JSON 우회, Queueable 연동 | #pattern |
| [[Flow Screen LWC 패턴]] | FlowAttributeChangeEvent, @api validate(), Custom Property Editor | #pattern |
| [[멀티 패키지 구조]] | sfdx-project.json, 도메인별 독립 Unlocked Package 구성 | #pattern |
| [[Flow 레코드 컬렉션 조작]] | Aggregate/Filter/Dedupe/Join 등 컬렉션 11개 Invocable Action | #pattern |
| [[Flow 데이터 & 보안 액션]] | ExecuteSOQLQuery, SaveRecordsAsync, 레코드 잠금/해제 | #pattern |
| [[quickChoice Screen Component]] | render() 멀티 템플릿, picklist/list 소스, Custom Property Editor | #pattern |
| [[Flow 유틸리티 액션 모음]] | 영업시간 계산, CSV 처리, Chatter 게시, Flow 링크·기동 | #pattern |
| [[Flow Interview API]] | Flow.Interview — Apex에서 Autolaunched Flow 실행, createInterview, getVariableValue | #reference |

---

## 빠른 선택

- Flow 종류를 처음 파악할 때? → [[Flow 종류와 변수]]
- XML 요소 이름이 기억 안 날 때? → [[Flow 요소 참조]]
- Flow 이름 짓는 규칙? → [[Flow 네이밍 컨벤션]]
- 설계·성능·유지보수 원칙? → [[Flow 설계 베스트 프랙티스]]
- 오류 처리 방법? → [[Flow 에러 처리]]
- 사용자 화면 있는 다단계 Flow? → [[Screen Flow 설계]]
- 레코드 처리·백그라운드 자동화? → [[Autolaunched Flow 패턴]]
- Flow에서 Apex 로직 호출? → [[@InvocableMethod 패턴]]
- Flow 화면 안에 LWC 삽입? → [[Flow Screen LWC 패턴]]
- Flow 화면 선택 UI (카드/드롭다운/라디오)? → [[quickChoice Screen Component]]
- Flow 안에서 리스트 필터/집계/정렬? → [[Flow 레코드 컬렉션 조작]]
- Flow에서 동적 SOQL 실행? → [[Flow 데이터 & 보안 액션]]
- 레코드 잠금/영업시간/Chatter? → [[Flow 유틸리티 액션 모음]]
- 멀티 패키지 프로젝트 구성? → [[멀티 패키지 구조]]
- Apex 코드에서 Flow를 직접 실행? → [[Flow Interview API]]

---

## 읽기 순서 (처음 공부할 때)

```
Flow 종류와 변수 → Flow 요소 참조 → Screen Flow 설계 or Autolaunched Flow 패턴 → @InvocableMethod 패턴
```
