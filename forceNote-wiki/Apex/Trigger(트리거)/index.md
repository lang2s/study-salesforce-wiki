---
tags: [index, apex, trigger]
created: 2026-05-17
---

# Trigger(트리거) — 로컬 인덱스

> Trigger 구조화 — 핸들러 패턴, 메타데이터 기반 동적 제어

**상위:** [[Apex MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[TriggerHandler 패턴]] | abstract class, beforeInsert/afterInsert, bypass, 루프 방지 | #pattern |
| [[CMDT 메타데이터 트리거]] | 배포 없이 핸들러 등록·비활성화, MetadataTriggerHandler | #pattern |

---

## 빠른 선택

- Trigger 코드 구조를 잡을 때? → [[TriggerHandler 패턴]]
- Trigger를 배포 없이 on/off 제어? → [[CMDT 메타데이터 트리거]]

## 관련 폴더

비즈니스 로직 분리 → [[서비스 레이어 패턴]] | 비동기 처리 분기 → [[Apex/Async(비동기)/index|Async(비동기)]]
