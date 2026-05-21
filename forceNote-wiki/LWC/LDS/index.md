---
tags: [index, lwc, lds]
created: 2026-05-17
---

# LDS — 로컬 인덱스

> Lightning Data Service — 레코드 폼, getRecord, uiRecordApi, 에러 정규화

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Record Form 선택]] | record-form vs edit-form vs view-form 결정 | #decision |
| [[getRecord 패턴]] | static import, dynamic string, getFieldValue, getRecords | #pattern |
| [[uiRecordApi]] | createRecord, updateRecord, deleteRecord, notifyRecordUpdateAvailable | #pattern |
| [[ldsUtils reduceErrors]] | 8가지 에러 타입 정규화 유틸리티 | #pattern |
| [[getPicklistValues 패턴]] | Record Type별 Picklist 옵션 로드, 종속 Picklist validFor 필터링 | #pattern |

---

## 빠른 선택

- 레코드 표시/편집 폼 컴포넌트 선택? → [[Record Form 선택]]
- 레코드 필드 값 읽기? → [[getRecord 패턴]]
- 레코드 생성/수정/삭제? → [[uiRecordApi]]
- LDS 에러 메시지 정규화? → [[ldsUtils reduceErrors]]

## LDS vs Apex

| 상황 | 선택 |
|---|---|
| 단순 레코드 CRUD | LDS (이 폴더) |
| 복잡한 비즈니스 로직 포함 | Apex → [[LWC/ApexIntegration(Apex통합)/index|ApexIntegration]] |
