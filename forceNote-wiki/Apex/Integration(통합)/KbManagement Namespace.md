---
tags: [apex, kbmanagement, knowledge, namespace, article, translation, publishing, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — KbManagement Namespace (p.2968~2979)
created: 2026-05-19
aliases: [KbManagement, PublishingService, Knowledge Article API, 지식 문서 관리, 아티클 게시, 아티클 번역, Knowledge Base Apex]
---

# KbManagement Namespace

> Salesforce Knowledge Base의 아티클 라이프사이클(게시·번역·보관·삭제)을 Apex에서 제어하는 네임스페이스. 유일한 클래스는 `KbManagement.PublishingService`.

---

## 개요

| 항목 | 내용 |
|---|---|
| 네임스페이스 | `KbManagement` |
| 핵심 클래스 | `KbManagement.PublishingService` |
| 전제 조건 | Salesforce Knowledge 활성화 필요 |
| 메서드 타입 | 모두 `static` |
| 날짜 기준 | GMT |

`PublishingService` 클래스는 다음 아티클 라이프사이클을 제어한다:

- **게시(Publishing)** — 초안 → 온라인, 예약 게시
- **업데이트(Updating)** — 온라인 아티클을 편집 초안으로 변환
- **버전 복원(Restore)** — 보관된 구버전 기반 초안 생성
- **삭제(Deleting)** — 초안/보관 아티클 삭제
- **번역(Translation)** — 번역 제출, 완료·미완료 상태 전환
- **보관(Archiving)** — 온라인 아티클 즉시/예약 보관

---

## 메서드 전체 목록

| 메서드 | 반환 | 설명 |
|---|---|---|
| `archiveOnlineArticle(articleId, scheduledDate)` | `Void` | 온라인 아티클 보관 (null이면 즉시) |
| `assignDraftArticleTask(articleId, assigneeId, instructions, dueDate, sendEmailNotification)` | `Void` | 초안 아티클 검토 태스크 할당 |
| `assignDraftTranslationTask(articleVersionId, assigneeId, instructions, dueDate, sendEmailNotification)` | `Void` | 초안 번역 검토 태스크 할당 |
| `cancelScheduledArchivingOfArticle(articleId)` | `Void` | 예약 보관 취소 |
| `cancelScheduledPublicationOfArticle(articleId)` | `Void` | 예약 게시 취소 |
| `completeTranslation(articleVersionId)` | `Void` | 번역을 게시 준비 완료 상태로 변경 |
| `deleteArchivedArticle(articleId)` | `Void` | 보관된 아티클 삭제 |
| `deleteArchivedArticleVersion(articleId, versionNumber)` | `Void` | 특정 보관 버전 삭제 |
| `deleteDraftArticle(articleId)` | `Void` | 초안 아티클 삭제 |
| `deleteDraftTranslation(articleVersionId)` | `Void` | 초안 번역 삭제 |
| `editArchivedArticle(articleId)` | `String` | 보관 버전 기반 초안 생성 → 새 초안 ID 반환 |
| `editOnlineArticle(articleId, unpublish)` | `String` | 온라인 버전 기반 초안 생성 (unpublish=true면 비게시) → 새 초안 ID 반환 |
| `editPublishedTranslation(articleId, language, unpublish)` | `String` | 게시된 번역 초안 생성 → 새 초안 ID 반환 |
| `publishArticle(articleId, flagAsNew)` | `Void` | 초안 게시 (flagAsNew=true면 메이저 버전) |
| `restoreOldVersion(articleId, versionNumber)` | `String` | 보관 버전 기반 새 초안 생성 → 아티클 버전 ID 반환 |
| `scheduleForPublication(articleId, scheduledDate)` | `Void` | 메이저 버전으로 게시 예약 (null이면 즉시) |
| `setTranslationToIncomplete(articleVersionId)` | `Void` | 완료 상태 번역을 "진행중"으로 되돌리기 |
| `submitForTranslation(articleId, language, assigneeId, dueDate)` | `String` | 번역 제출 → 초안 번역 ID 반환 |

---

## 아티클 라이프사이클 흐름

```
[초안 Draft]
    │
    ├─ publishArticle(articleId, true)          → [온라인 Online]
    │                                               │
    ├─ scheduleForPublication(articleId, date)  → [예약 게시 Scheduled]
    │                                               │
    └─────────────────────────────────────────→ [온라인 Online]
                                                    │
                                        ┌───────────┴───────────┐
                                        │                       │
                              archiveOnlineArticle        editOnlineArticle
                                        │                       │
                                 [보관 Archived]          [초안 Draft] (편집)
                                        │
                              deleteArchivedArticle → 완전 삭제
```

---

## 게시 / 예약 게시 코드 예제

```apex
// 즉시 게시 (메이저 버전)
String articleId = '0kmXX0000000001';
KbManagement.PublishingService.publishArticle(articleId, true);

// 예약 게시
Datetime scheduledDate = Datetime.newInstanceGmt(2026, 6, 1, 9, 0, 0);
KbManagement.PublishingService.scheduleForPublication(articleId, scheduledDate);

// 예약 게시 취소
KbManagement.PublishingService.cancelScheduledPublicationOfArticle(articleId);
```

---

## 보관(Archive) 코드 예제

```apex
// 즉시 보관
String articleId = '0kmXX0000000001';
KbManagement.PublishingService.archiveOnlineArticle(articleId, null);

// 예약 보관
Datetime archiveDate = Datetime.newInstanceGmt(2026, 12, 31, 0, 0, 0);
KbManagement.PublishingService.archiveOnlineArticle(articleId, archiveDate);

// 예약 보관 취소
KbManagement.PublishingService.cancelScheduledArchivingOfArticle(articleId);

// 보관 아티클 삭제
KbManagement.PublishingService.deleteArchivedArticle(articleId);

// 특정 보관 버전만 삭제
KbManagement.PublishingService.deleteArchivedArticleVersion(articleId, 2);
```

---

## 초안 삭제 코드 예제

```apex
// 초안 아티클 삭제
String articleId = '0kmXX0000000001';
KbManagement.PublishingService.deleteDraftArticle(articleId);
```

---

## 편집 / 버전 복원 코드 예제

```apex
// 온라인 아티클을 편집 초안으로 전환 (unpublish=false → 온라인 유지)
String articleId = '0kmXX0000000001';
String newDraftId = KbManagement.PublishingService.editOnlineArticle(articleId, false);

// 온라인 아티클을 편집 초안으로 전환하면서 비게시
String newDraftId2 = KbManagement.PublishingService.editOnlineArticle(articleId, true);

// 보관 버전 기반 초안 생성
String draftFromArchive = KbManagement.PublishingService.editArchivedArticle(articleId);

// 구버전(versionNumber=1) 기반으로 새 초안 생성
String restoredId = KbManagement.PublishingService.restoreOldVersion(articleId, 1);
```

---

## 번역(Translation) 코드 예제

```apex
// 프랑스어 번역 제출
String articleId = '0kmXX0000000001';
String assigneeId = '005XX0000000001';
Datetime dueDate = Datetime.newInstanceGmt(2026, 7, 1);
String translationId = KbManagement.PublishingService.submitForTranslation(
    articleId, 'fr', assigneeId, dueDate
);

// 번역 완료 처리
KbManagement.PublishingService.completeTranslation(translationId);

// 번역을 다시 "진행중"으로 되돌리기
KbManagement.PublishingService.setTranslationToIncomplete(translationId);

// 게시된 번역 편집 (비게시 없이)
String draftTranslationId = KbManagement.PublishingService.editPublishedTranslation(
    articleId, 'fr', false
);

// 초안 번역 삭제
KbManagement.PublishingService.deleteDraftTranslation(translationId);
```

---

## 검토 태스크 할당 코드 예제

```apex
// 초안 아티클 검토 태스크 할당
String articleId = '0kmXX0000000001';
String assigneeId = '005XX0000000001';
Datetime dueDate = Datetime.newInstanceGmt(2026, 6, 15);
KbManagement.PublishingService.assignDraftArticleTask(
    articleId, assigneeId, 'Please review this draft before publishing.', dueDate, true
);

// 초안 번역 검토 태스크 할당
String articleVersionId = '0kmXX0000000002';
KbManagement.PublishingService.assignDraftTranslationTask(
    articleVersionId, assigneeId, 'Please review the French translation.', dueDate, true
);
```

---

## 비교표 — 아티클 편집 메서드 선택

| 상황 | 메서드 |
|---|---|
| 온라인 아티클을 편집하되 게시 상태 유지 | `editOnlineArticle(id, false)` |
| 온라인 아티클을 편집하면서 즉시 비게시 | `editOnlineArticle(id, true)` |
| 보관된 아티클로 다시 편집 시작 | `editArchivedArticle(id)` |
| 특정 구버전으로 되돌리기 | `restoreOldVersion(id, versionNumber)` |
| 게시된 번역을 편집 | `editPublishedTranslation(id, lang, unpublish)` |

---

## 관련 노트

- [[ConnectApi Namespace 개요]] — Knowledge 관련 ConnectApi 클래스 포함
- [[Search Namespace]] — KnowledgeSuggestionFilter, Knowledge 아티클 SOSL 검색
- [[Apex 표준 클래스 레퍼런스]] — String / Datetime 메서드 참조
