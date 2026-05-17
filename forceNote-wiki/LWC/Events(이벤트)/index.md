---
tags: [index, lwc, events]
created: 2026-05-17
---

# Events(이벤트) — 로컬 인덱스

> LWC 컴포넌트 통신 — CustomEvent, LMS, 공유 상태 관리

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[CustomEvent 패턴]] | 자식→부모, dispatchEvent, bubbles/composed, 이벤트 위임 | #pattern |
| [[Lightning Message Service]] | 크로스 컴포넌트 publish/subscribe, MessageContext | #pattern |
| [[상태 관리]] | @lwc/state, atom, computed, 공유 상태, fromContext | #pattern |

---

## 빠른 선택

- 자식 → 부모 데이터 전달? → [[CustomEvent 패턴]]
- 트리 관계 없는 컴포넌트 간 통신? → [[Lightning Message Service]]
- 여러 컴포넌트가 상태를 공유? → [[상태 관리]]

## 통신 방식 요약

```
부모 → 자식    @api (ComponentAPI)
자식 → 부모    CustomEvent
관계 무관      Lightning Message Service
전역 상태      @lwc/state
```
