# Wiki 작성 규칙

> 새 자료를 추가할 때마다 이 규칙을 따른다.

---

## 1. 폴더명 규칙

| 형식 | 예시 |
|---|---|
| 순수 한글 ❌ | `보안`, `비동기`, `데이터`, `통합`, `테스트`, `트리거` |
| **영어(한글) ✅** | `Security(보안)`, `Async(비동기)`, `Data(데이터)`, `Integration(통합)`, `Testing(테스트)`, `Trigger(트리거)` |
| 영어+한글 혼합 ❌ | `Apex통합`, `컴포넌트API`, `UI패턴`, `플랫폼이벤트` |
| **영어(영어+한글) ✅** | `ApexIntegration(Apex통합)`, `ComponentAPI(컴포넌트API)`, `UIPatterns(UI패턴)`, `PlatformEvents(플랫폼이벤트)` |

---

## 2. 파일 구조

모든 `.md` 파일은 이 구조를 따른다.

```markdown
---
tags: [카테고리, 키워드...]
source: 출처_파일.cls 또는 프로젝트명
created: YYYY-MM-DD
aliases: [영어키워드, 한국어키워드, ...]
---

# 제목

> 한 줄 요약

---

## 개념 설명

## 코드 예제 (실제 동작하는 코드)

## 비교표 (선택 기준이 있을 때)

## 관련 노트

- [[파일명]]
```

---

## 3. 새 파일 추가 시 체크리스트

```
□ 1. 파일 생성 — 위 구조 준수
□ 2. 00 SEARCH_INDEX.md 업데이트 — 키워드 행 추가
□ 3. 해당 섹션 MOC 업데이트 — 링크 추가
```

### SEARCH_INDEX 키워드 작성법

한 행에 **영어 API명 + 한국어 표현 + 자연어 질문** 을 모두 포함한다.

```
| deleteRecord, updateRecord, 레코드 삭제, 레코드 수정, LWC에서 DML | `LWC/LDS/uiRecordApi.md` |
```

---

## 4. 현재 섹션별 MOC 파일 위치

| 섹션 | MOC |
|---|---|
| Apex | `Apex/Apex MOC.md` |
| LWC | `LWC/LWC MOC.md` |
| Flow | `Flow/Flow MOC.md` |
| Integration | `Integration(통합)/통합 MOC.md` |
| 전체 검색 | `00 SEARCH_INDEX.md` |
