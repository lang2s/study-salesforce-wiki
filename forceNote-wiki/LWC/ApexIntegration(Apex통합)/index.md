---
tags: [index, lwc, apex-integration]
created: 2026-05-17
---

# ApexIntegration(Apex통합) — 로컬 인덱스

> LWC에서 Apex 호출 — Wire 어댑터, Imperative 호출, 방식 선택 기준

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Wire vs Imperative 선택]] | @wire vs async/await 결정 매트릭스 | #decision |
| [[Wire 패턴]] | property/function 바인딩, reactive $변수 | #pattern |
| [[Imperative 호출 패턴]] | async/await, try/catch/finally, isLoading | #pattern |

---

## 빠른 선택

- 어떤 방식을 써야 할지 모름? → [[Wire vs Imperative 선택]]
- 페이지 로드 시 자동 데이터 로드? → [[Wire 패턴]]
- 버튼 클릭 등 사용자 액션 시 호출? → [[Imperative 호출 패턴]]
- @wire 에러 처리가 필요? → [[Wire 패턴]] → function 바인딩 방식

## 관련 폴더

에러 처리 → [[LWC/UIPatterns(UI패턴)/index|UIPatterns(UI패턴)]] → [[에러 패널 패턴]]
