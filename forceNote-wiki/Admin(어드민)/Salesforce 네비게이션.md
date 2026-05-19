---
tags: [admin, navigation, app-launcher, lightning-experience, list-view, record-page]
source: basics.pdf
created: 2026-05-19
aliases: [App Launcher, 앱 런처, Salesforce 네비게이션, 전역 검색, 리스트뷰, 레코드 페이지]
---

# Salesforce 네비게이션

> Lightning Experience의 화면 구조와 주요 탐색 방법 — App Launcher, 탐색바, 전역 검색, 리스트뷰, 레코드 페이지.

---

## 개발자가 네비게이션 구조를 알아야 하는 이유

Lightning Experience의 화면 구조는 단순한 UI 이상이다. 개발자에게 중요한 세 가지 이유가 있다.

1. **LWC 컴포넌트 배치 결정** — 레코드 페이지 탭(Related/Details/Activity)별로 LWC를 어디에 배치할지는 App Builder에서 결정하며, 컴포넌트의 `targets` 설정(`lightning__RecordPage`, `lightning__AppPage` 등)과 직접 연결된다.
2. **네비게이션 서비스 사용** — LWC에서 `NavigationMixin`으로 레코드 페이지·리스트뷰·앱 페이지를 이동할 때 `pageReference` 타입(`standard__recordPage`, `standard__objectPage` 등)이 이 화면 구조에서 유래한다.
3. **커스텀 앱 설계** — App Builder에서 탭 구성·홈 페이지·유틸리티바를 설정하면 실제 배포 결과가 달라지므로, 화면 계층을 이해하지 못하면 설계 오류가 생긴다.

**커스터마이징 시 주의사항:**

- 탭 순서와 가시성은 앱(App)별로 다르다. 프로필/권한 세트에 따라 탭 접근이 차단될 수 있으므로, 테스트 시 여러 프로필로 확인한다.
- 레코드 페이지 레이아웃(App Builder)과 필드 레이아웃(Page Layout)은 별도로 관리된다. Page Layout에 없는 필드는 레코드 페이지에 표시되지 않는다.
- 리스트뷰 필터는 SOQL로 처리되므로, 필터 조건이 많은 커스텀 리스트뷰는 거버너 한도에 영향을 줄 수 있다.

---

## Lightning Experience 화면 구조

```
// 구조 예시 — 실제 동작 코드 아님
┌─────────────────────────────────────────────────────┐
│ [≡ App Launcher]  [App Name]  [Tab1][Tab2]..  [검색] [사용자 메뉴] │  ← 헤더(네비게이션바)
├─────────────────────────────────────────────────────┤
│                                                     │
│              메인 컨텐츠 영역                         │
│  (홈 / 리스트뷰 / 레코드 페이지 / 보고서 등)           │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## App Launcher (앱 런처)

- 헤더 왼쪽 **9점 격자 아이콘**으로 접근
- 설치된 모든 앱과 오브젝트 탭을 검색·전환
- 자주 쓰는 앱을 상단에 고정(Pin) 가능

```
// 구조 예시 — 실제 동작 코드 아님
App Launcher
├── 최근 항목 (Pinned 앱)
├── 내 앱 목록
│   ├── Sales (Sales Cloud)
│   ├── Service Console
│   ├── Marketing
│   └── 커스텀 앱들...
└── 검색창 (앱 이름/오브젝트 검색)
```

---

## 전역 검색 (Global Search)

- 헤더 검색창에서 레코드·지식 문서·파일 등 통합 검색
- 입력 시 최근 항목 자동 완성
- `Enter` 클릭 시 전체 검색 결과 페이지로 이동

| 검색 팁 | 설명 |
|---|---|
| `"정확한 문구"` | 정확한 구문 검색 |
| `Account: Acme` | 특정 오브젝트 범위로 제한 |
| 와일드카드 `*` | 예: `Acme*` → Acme로 시작하는 모든 레코드 |

---

## 탐색바 (Navigation Bar)와 탭

- 현재 앱의 주요 오브젝트/기능이 탭으로 표시
- 탭을 클릭하면 해당 오브젝트의 리스트뷰로 이동
- **최근 항목** 드롭다운으로 마지막으로 열람한 레코드 빠른 접근

---

## 리스트뷰 (List View)

- 특정 오브젝트의 레코드 목록을 필터 조건으로 표시
- 표준 리스트뷰: All Accounts, My Accounts, Recently Viewed 등
- 커스텀 리스트뷰: 원하는 필드·조건으로 직접 생성 가능

| 기능 | 설명 |
|---|---|
| 칸반 뷰 | 레코드를 상태별 열로 시각화 |
| 인라인 편집 | 리스트에서 직접 필드값 수정 |
| 대량 업데이트 | 여러 레코드 선택 후 일괄 수정/삭제 |
| SOSL 활용 | 리스트뷰 필터는 내부적으로 SOQL 사용 |

---

## 레코드 페이지 구조

```
// 구조 예시 — 실제 동작 코드 아님
레코드 페이지
├── 헤더: 레코드 이름 + 주요 필드 (Highlights Panel)
├── 액션바: New, Edit, Delete, 커스텀 버튼
├── 관련 탭 (Related): 관련 오브젝트 리스트 (Related Lists)
├── 상세 탭 (Details): 모든 필드 표시
└── 활동 탭 (Activity): 태스크, 이메일, 메모 타임라인
```

---

## 홈 페이지

- 로그인 후 첫 화면. 앱마다 다른 홈 페이지 설정 가능
- 일반 구성: 오늘의 할 일, 최근 레코드, 보고서 차트, 뉴스 피드

---

## 관련 노트

- [[Salesforce 플랫폼 개요]] — Org/Object/Record 핵심 개념
- [[Admin(어드민)/Salesforce ID 인증]] — 로그인 보안 설정
