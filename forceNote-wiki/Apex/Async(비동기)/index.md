---
tags: [index, apex, async]
created: 2026-05-17
---

# Async(비동기) — 로컬 인덱스

> 비동기 실행 방식 선택 및 구현 패턴

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[비동기 컨텍스트 선택]] | @future / Queueable / Batch 결정 매트릭스 | #decision |
| [[Future 메서드]] | fire-and-forget, callout=true | #pattern |
| [[Queueable]] | SObject 파라미터, AllowsCallouts | #pattern |
| [[Queueable 체이닝]] | execute당 1개 enqueue 규칙 | #pattern |
| [[Batch Apex]] | 대용량 처리, Database.Stateful, start/execute/finish | #pattern |
| [[Scheduled Apex]] | thin execute, System.scheduleBatch, cron 표현식 | #pattern |

---

## 빠른 선택

- 어떤 걸 써야 할지 모름? → [[비동기 컨텍스트 선택]]
- 단순 HTTP 한 번, 반환값 불필요? → [[Future 메서드]]
- SObject 파라미터 전달 필요? → [[Queueable]]
- 완료 후 다음 잡 연속 실행? → [[Queueable 체이닝]]
- 수만 건 이상 대용량 처리? → [[Batch Apex]]
- 매일/매주 정기 자동 실행? → [[Scheduled Apex]]
