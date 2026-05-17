---
tags: [index, lwc, ui-patterns]
created: 2026-05-17
---

# UIPatterns(UI패턴) — 로컬 인덱스

> LWC UI 공통 패턴 — Toast, 모달, 에러 표시, 공유 JS, Static Resource, 파일 처리

**상위:** [[LWC MOC]] → [[00 Home]]

---

## 파일 목록

| 파일 | 한 줄 요약 | 태그 |
|---|---|---|
| [[Lightning Base Components 레퍼런스]] | lightning-* 전체 컴포넌트 목록, 속성·이벤트 빠른 참조 | #reference |
| [[Toast & 모달 패턴]] | ShowToastEvent variant, LightningModal open/close | #pattern |
| [[에러 패널 패턴]] | errorPanel, reduceErrors, 에러 타입별 표시 | #pattern |
| [[공유 JS 모듈]] | named export, isExposed: false, c/ 네임스페이스 공유 함수 | #pattern |
| [[Static Resource 로딩]] | loadScript/loadStyle, renderedCallback 3-state | #pattern |
| [[파일 업로드와 이미지 처리]] | processImage, FileReader→base64, ContentVersion URL | #pattern |

---

## 빠른 선택

- 어떤 컴포넌트 쓸지 모를 때? → [[Lightning Base Components 레퍼런스]]
- 성공/실패 알림 메시지? → [[Toast & 모달 패턴]]
- 확인 다이얼로그, 모달 창? → [[Toast & 모달 패턴]]
- Apex/LDS 에러 표시 컴포넌트? → [[에러 패널 패턴]]
- 여러 컴포넌트 공통 JS 로직? → [[공유 JS 모듈]]
- 서드파티 라이브러리 (Chart.js 등)? → [[Static Resource 로딩]]
- 이미지 업로드, 파일 처리? → [[파일 업로드와 이미지 처리]]
