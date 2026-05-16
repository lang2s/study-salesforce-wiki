---
tags: [flow, moc, index]
created: 2026-05-17
aliases: [Flow MOC, Flow Index]
---

# Flow MOC

> Salesforce Flow 관련 패턴 인덱스. 개념 → 요소 참조 → 타입별 설계 순으로 읽기.

---

## 개념 & 기초

- [[Flow 종류와 변수]] — processType 결정, 변수 isInput/isOutput, $Flow 전역 변수, Apex에서 호출
- [[Flow 요소 참조]] — XML 요소 전체 참조 (recordLookups/Creates/Updates/decisions/assignments/actionCalls 등)

## 타입별 설계

- [[Screen Flow 설계]] — 다단계 마법사 UI, 내장 컴포넌트(flowruntime:address/lookup), LWC 삽입, 오류 화면
- [[Autolaunched Flow 패턴]] — 헤드리스 로직, 레코드 CRUD, Apex/Agent에서 호출

## Apex & LWC 연동

- [[@InvocableMethod 패턴]] — Flow Action Apex 표준 구조, bulkInvoke, JSON 우회, Queueable 연동
- [[Flow Screen LWC 패턴]] — FlowAttributeChangeEvent, @api validate(), Custom Property Editor
- [[멀티 패키지 구조]] — sfdx-project.json, 도메인별 독립 패키지

---

## 핵심 API 요약

| API / XML 요소 | 설명 |
|---|---|
| `processType: Flow` | Screen Flow |
| `processType: AutoLaunchedFlow` | 헤드리스 Flow |
| `isInput / isOutput` | 변수 입출력 방향 |
| `storeOutputAutomatically` | 요소 출력을 요소명으로 자동 저장 |
| `faultConnector` | DML/Action 오류 경로 |
| `actionType: apex` | @InvocableMethod 호출 |
| `FlowAttributeChangeEvent` | LWC → Flow 값 변경 통보 |
| `@api validate()` | Flow Next 클릭 시 LWC 검증 |
| `configuration_editor_input_value_changed` | Property Editor → Flow Builder |
| `Flow.Interview.createInterview()` | Apex에서 Flow 기동 |
| `Approval.isLocked / lock / unlock` | 레코드 잠금 |
| `$Flow.CurrentDate / FaultMessage` | 전역 변수 |
