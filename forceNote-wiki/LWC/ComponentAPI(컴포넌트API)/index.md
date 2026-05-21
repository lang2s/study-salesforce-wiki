---
tags: [index, lwc, component-api]
created: 2026-05-17
---

# ComponentAPI(컴포넌트API) — 로컬 인덱스

> LWC 컴포넌트 인터페이스 — @api 속성/메서드, 컴포지션 패턴

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[@api 패턴]] | @api property/method, getter/setter, lwc:spread | #pattern |
| [[컴포지션 패턴]] | Container vs Presentational, for:each, lwc:if/elseif/else | #pattern |
| [[LWC API 버전 관리]] | .js-meta.xml apiVersion 규칙, 버전별 기능 변경, 동적 임포트 | #reference |

---

## 빠른 선택

- 부모 → 자식 데이터/메서드 전달? → [[@api 패턴]]
- 컴포넌트 목록 렌더링, 조건부 표시? → [[컴포지션 패턴]]
- 자식 → 부모 통신? → [[LWC/Events(이벤트)/index|Events(이벤트)]] → [[CustomEvent 패턴]]
