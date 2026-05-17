---
tags: [index, apex, testing]
created: 2026-05-17
---

# Testing(테스트) — 로컬 인덱스

> Apex 테스트 패턴 — 단위·통합·모킹·격리 전략

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[테스트 전략]] | @isTest, TestSetup, Given-When-Then 구조 | #decision |
| [[HttpCalloutMock]] | HTTP 외부 호출 모킹, Test.setMock | #pattern |
| [[StubProvider]] | System.StubProvider, Test.createStub 클래스 모킹 | #pattern |
| [[testVisible 회로차단기]] | @testVisible Boolean/Exception 회로 차단기 | #pattern |
| [[SOSL 테스트 패턴]] | Test.setFixedSearchResults, SOSL 고정 결과 | #pattern |

---

## 빠른 선택

- 테스트 구조를 처음 잡을 때? → [[테스트 전략]]
- HTTP callout 이 있는 메서드 테스트? → [[HttpCalloutMock]]
- 외부 클래스 의존성 격리? → [[StubProvider]]
- private 로직에 테스트 전용 플래그? → [[testVisible 회로차단기]]
- SOSL 검색 결과 고정? → [[SOSL 테스트 패턴]]
