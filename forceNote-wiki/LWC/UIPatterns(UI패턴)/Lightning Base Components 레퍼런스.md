---
tags: [lwc, base-component, reference, ui, lightning]
source: TrailheadApp/lwc-recipes-main + https://developer.salesforce.com/docs/component-library
created: 2026-05-17
aliases: [Lightning Base Components, 베이스 컴포넌트, lightning-input, lightning-card, LWC 컴포넌트 목록]
---

# Lightning Base Components 레퍼런스

> Salesforce LWC에서 사용 가능한 `lightning-*` 베이스 컴포넌트 전체 목록. 카테고리별로 분류.

> [!warning] 코드 예시는 로컬 `lwc-recipes-main` (Tier 1) 및 공식 Docs (Tier 2) 기반. 컴포넌트 **목록 전체**는 외부 지식 기반(Tier 3)으로 공식 소스와 전수 대조되지 않았습니다.  
> 최신 전체 목록: [Salesforce Component Library](https://developer.salesforce.com/docs/component-library/overview/components)

---

## 1. 입력 (Input)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-input` | 텍스트·숫자·날짜·이메일·파일 등 다목적 입력 필드 (`type` 속성으로 전환) |
| `lightning-textarea` | 여러 줄 텍스트 입력 |
| `lightning-combobox` | 단일 선택 드롭다운 (읽기 전용 입력 + 목록) |
| `lightning-select` | HTML `<select>` 기반 드롭다운 (모바일 친화) |
| `lightning-dual-listbox` | 두 목록 사이에서 항목 이동 (다중 선택) |
| `lightning-radio-group` | 단일 선택 라디오 버튼 그룹 |
| `lightning-checkbox-group` | 다중 선택 체크박스 그룹 |
| `lightning-slider` | 슬라이더 범위 입력 |
| `lightning-color-picker` | 색상 선택기 |
| `lightning-rich-text` | WYSIWYG 서식 있는 텍스트 에디터 |
| `lightning-search` | 검색 입력 필드 (자동완성 가능) |
| `lightning-input-address` | 주소 입력 (국가별 필드 구성 자동) |
| `lightning-input-location` | 위도·경도 입력 |
| `lightning-input-name` | 이름 입력 (First·Last·Salutation 등 분리) |
| `lightning-record-picker` | 레코드 검색 및 선택 — `onchange`에서 `event.detail.recordId` *(Spring '24 GA)* |

### lightning-input 주요 속성

```html
<lightning-input
    label="Account Name"
    type="text"           <!-- text | number | email | date | datetime | time | checkbox | toggle | file | color | search | tel | url | password -->
    value={val}
    required
    disabled
    readonly
    placeholder="Enter name"
    field-level-help="도움말 텍스트"
    min="0" max="100"     <!-- type=number -->
    minlength="2" maxlength="50"
    pattern="[A-Za-z]+"
    formatter="currency"  <!-- type=number -->
    message-when-value-missing="필수 항목입니다"
    onchange={handleChange}
    oncommit={handleCommit}>
</lightning-input>
```

**이벤트:**
- `change` — 값 변경 시 (`event.detail.value` / `event.detail.checked`)
- `commit` — Enter 또는 포커스 이탈 시

---

## 2. 버튼 (Button)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-button` | 표준 버튼 |
| `lightning-button-icon` | 아이콘만 있는 버튼 |
| `lightning-button-group` | 버튼 그룹 (border 공유) |
| `lightning-button-menu` | 드롭다운 메뉴 버튼 |
| `lightning-button-icon-stateful` | 토글 가능한 아이콘 버튼 (selected 상태) |
| `lightning-button-stateful` | 토글 가능한 레이블 버튼 |
| `lightning-menu-item` | `lightning-button-menu` 내부 항목 |
| `lightning-menu-divider` | `lightning-button-menu` 내부 구분선 |

### lightning-button 주요 속성

```html
<lightning-button
    label="저장"
    variant="brand"       <!-- base | neutral | brand | brand-outline | destructive | destructive-text | inverse | success -->
    type="button"         <!-- button | submit | reset -->
    icon-name="utility:save"
    icon-position="left"  <!-- left | right -->
    disabled
    onclick={handleClick}>
</lightning-button>
```

---

## 3. 레이아웃 (Layout)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-card` | 콘텐츠를 감싸는 카드 컨테이너 (헤더·바디·푸터·액션) |
| `lightning-layout` | 플렉스 기반 반응형 그리드 컨테이너 |
| `lightning-layout-item` | `lightning-layout` 내부 열 단위 |
| `lightning-accordion` | 접고 펼 수 있는 아코디언 컨테이너 |
| `lightning-accordion-section` | 아코디언 개별 섹션 |
| `lightning-tabset` | 탭 컨테이너 |
| `lightning-tab` | 개별 탭 패널 |
| `lightning-split-view` | 마스터-디테일 분할 뷰 |

### lightning-card 속성·슬롯

```html
<lightning-card title="Account Detail" icon-name="standard:account">
    <div slot="actions">
        <lightning-button label="수정" onclick={handleEdit}></lightning-button>
    </div>
    <!-- 기본 슬롯 = 바디 영역 -->
    <p class="slds-p-horizontal_small">내용</p>
    <div slot="footer">
        <lightning-button label="전체 보기" variant="base"></lightning-button>
    </div>
</lightning-card>
```

---

## 4. 데이터 표시 / 포맷팅 (Display & Formatting)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-formatted-text` | 텍스트 (URL 자동 링크 변환 가능) |
| `lightning-formatted-number` | 숫자·통화·퍼센트 포맷 |
| `lightning-formatted-date-time` | 날짜·시간 로케일 포맷 |
| `lightning-formatted-time` | 시간 전용 포맷 |
| `lightning-formatted-url` | 클릭 가능한 URL 링크 |
| `lightning-formatted-phone` | 클릭 가능한 전화번호 |
| `lightning-formatted-email` | 클릭 가능한 이메일 |
| `lightning-formatted-address` | 지도 링크 포함 주소 |
| `lightning-formatted-location` | 위도·경도 표시 |
| `lightning-formatted-name` | 이름 (Salutation·First·Last 합산) |
| `lightning-formatted-rich-text` | HTML 서식 있는 텍스트 렌더링 |
| `lightning-badge` | 레이블 배지 (상태 표시) |
| `lightning-avatar` | 프로필 이미지 또는 이니셜 |
| `lightning-highlight-text` | 텍스트 내 키워드 하이라이트 |
| `lightning-output-field` | Record View Form 내 필드 표시 |

```html
<lightning-formatted-number
    value={amount}
    format-style="currency"
    currency-code="KRW"
    maximum-fraction-digits="0">
</lightning-formatted-number>

<lightning-formatted-date-time
    value={createdDate}
    year="numeric" month="short" day="2-digit"
    hour="2-digit" minute="2-digit">
</lightning-formatted-date-time>
```

---

## 5. 데이터 테이블 (Data Table)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-datatable` | 정렬·선택·인라인 편집·무한 스크롤 지원 테이블 |
| `lightning-tree-grid` | 계층 구조 트리 테이블 |

### lightning-datatable 핵심 속성

```html
<lightning-datatable
    key-field="Id"
    data={tableData}
    columns={columns}
    selected-rows={selectedIds}
    max-row-selection="5"
    hide-checkbox-column
    enable-infinite-loading
    onrowselection={handleSelection}
    onsort={handleSort}
    onsave={handleSave}>
</lightning-datatable>
```

**columns 정의 주요 type:**
| type | 설명 |
|---|---|
| `text` | 텍스트 |
| `number` | 숫자 |
| `currency` | 통화 |
| `percent` | 퍼센트 |
| `date` | 날짜 |
| `date-local` | 타임존 없는 날짜 |
| `boolean` | 체크박스 |
| `url` | 링크 (`typeAttributes.label`) |
| `email` | 이메일 링크 |
| `phone` | 전화번호 링크 |
| `button` | 인라인 버튼 |
| `button-icon` | 인라인 아이콘 버튼 |
| `action` | 행 액션 메뉴 |
| `custom` | 커스텀 셀 렌더러 |

---

## 6. 레코드 (LDS Records)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-record-form` | 생성·조회·수정 통합 폼 (가장 간단) |
| `lightning-record-edit-form` | 편집 가능한 레코드 폼 (커스텀 레이아웃) |
| `lightning-record-view-form` | 읽기 전용 레코드 폼 |
| `lightning-input-field` | Record Edit Form 내 편집 필드 |
| `lightning-output-field` | Record View Form 내 읽기 필드 |
| `lightning-record-picker` | 레코드 검색·선택 위젯 *(Spring '24 GA)* |

```html
<!-- 가장 간단한 방법 -->
<lightning-record-form
    record-id={recordId}
    object-api-name="Account"
    fields={fields}
    mode="view">           <!-- view | edit | readonly -->
</lightning-record-form>

<!-- 커스텀 레이아웃 -->
<lightning-record-edit-form record-id={recordId} object-api-name="Account">
    <lightning-input-field field-name="Name"></lightning-input-field>
    <lightning-input-field field-name="Phone"></lightning-input-field>
    <lightning-button type="submit" label="저장" variant="brand"></lightning-button>
</lightning-record-edit-form>
```

→ 선택 기준: [[Record Form 선택]]

---

## 7. 아이콘 & 미디어 (Icon & Media)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-icon` | SLDS 아이콘 (utility·standard·custom·doctype·action) |
| `lightning-progress-bar` | 수평 진행률 바 |
| `lightning-progress-indicator` | 단계 진행 표시기 (base·path) |
| `lightning-progress-ring` | 원형 진행률 |
| `lightning-file-upload` | 파일 업로드 위젯 |
| `lightning-map` | 구글 맵 지도 표시 |

```html
<!-- 아이콘 카테고리 예시 -->
<lightning-icon icon-name="utility:edit" size="small" alternative-text="편집"></lightning-icon>
<lightning-icon icon-name="standard:account"></lightning-icon>
<lightning-icon icon-name="action:new_contact"></lightning-icon>
<lightning-icon icon-name="doctype:pdf"></lightning-icon>

<!-- 파일 업로드 -->
<lightning-file-upload
    label="파일 첨부"
    name="fileUploader"
    accept=".pdf,.docx"
    record-id={recordId}
    multiple
    onuploadfinished={handleUpload}>
</lightning-file-upload>
```

**icon-name 명명 규칙:** `{카테고리}:{이름}`
- `utility:` — 일반 UI 아이콘 (edit, save, delete, home 등)
- `standard:` — Salesforce 오브젝트 아이콘 (account, contact, opportunity 등)
- `action:` — 빠른 액션 아이콘 (new_contact, edit, delete 등)
- `doctype:` — 파일 타입 아이콘 (pdf, excel, word 등)
- `custom:` — 커스텀 아이콘 (custom1~custom113)

---

## 8. 네비게이션 (Navigation)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-breadcrumb` | 개별 빵 부스러기 경로 |
| `lightning-breadcrumbs` | 빵 부스러기 경로 컨테이너 |
| `lightning-vertical-navigation` | 사이드 수직 네비게이션 컨테이너 |
| `lightning-vertical-navigation-item` | 수직 네비게이션 개별 항목 |
| `lightning-vertical-navigation-item-badge` | 배지 포함 네비게이션 항목 |
| `lightning-vertical-navigation-item-icon` | 아이콘 포함 네비게이션 항목 |
| `lightning-vertical-navigation-section` | 수직 네비게이션 섹션 헤더 |
| `lightning-vertical-navigation-overflow` | 더보기 오버플로우 항목 |

---

## 9. 피드백 & 오버레이 (Feedback & Overlay)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-spinner` | 로딩 스피너 |
| `lightning-helptext` | 물음표 아이콘 + 툴팁 |
| `lightning-alert` | 알림 배너 (error·warning·info·offline) |
| `lightning-toast` | 토스트 메시지 *(Summer '26 GA — 이전에는 이벤트 방식)* |
| `lightning-modal` | 모달 다이얼로그 (base class 상속) |
| `lightning-modal-header` | 모달 헤더 슬롯 |
| `lightning-modal-body` | 모달 바디 슬롯 |
| `lightning-modal-footer` | 모달 푸터 슬롯 |
| `lightning-overlay` | 범용 오버레이 컨테이너 |
| `lightning-popup` | 팝오버/드롭다운 컨테이너 |
| `lightning-tooltip` | 호버 툴팁 |

### 모달 사용 패턴 *(lwc-recipes-main/myModal 발췌 — Tier 1)*

```html
<!-- myModal.html -->
<template>
    <lightning-modal-header label={header}></lightning-modal-header>
    <lightning-modal-body>Content: {content}</lightning-modal-body>
    <lightning-modal-footer>
        <lightning-button label="Close" onclick={handleClose}></lightning-button>
    </lightning-modal-footer>
</template>
```

```javascript
// myModal.js — LightningModal 상속 필수
import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api header;
    @api content;

    handleClose() {
        this.close('return value'); // close()에 반환값 전달 가능
    }
}
```

```javascript
// 호출하는 컴포넌트
import MyModal from 'c/myModal';
const result = await MyModal.open({
    size: 'medium',   // small | medium | large | full
    header: '제목',
    content: '내용'
});
```

→ 전체 패턴: [[Toast & 모달 패턴]]

### ShowToastEvent *(lwc-recipes-main/miscToastNotification 발췌 — Tier 1)*

```javascript
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

showNotification() {
    const evt = new ShowToastEvent({
        title: 'Sample Title',
        message: 'Sample Message',
        variant: 'success'  // success | error | warning | info
    });
    this.dispatchEvent(evt);
}
```

> **Summer '26 이후**: `lightning-toast` 컴포넌트(선언적)가 추가됨. `ShowToastEvent`는 여전히 유효한 방식.

---

## 10. 상태 & 선택 표시 (Status & Pill)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-pill` | 선택된 항목 태그 (삭제 가능) |
| `lightning-pill-container` | Pill 목록 컨테이너 |
| `lightning-chip` | 읽기 전용 태그 (삭제 불가) |
| `lightning-tile` | 아이콘 + 텍스트 타일 목록 항목 |

---

## 11. 트리 & 목록 (Tree & List)

| 컴포넌트 | 설명 |
|---|---|
| `lightning-tree` | 계층 트리 (항목 클릭 이벤트) |
| `lightning-list-view` | 표준 Salesforce 리스트 뷰 임베드 |

---

## 12. Flow 전용

| 컴포넌트 | 설명 |
|---|---|
| `lightning-flow` | Flow 실행 컨테이너 (LWC에서 Flow 실행) |

```html
<lightning-flow
    flow-api-name="My_Flow"
    flow-input-variables={inputVars}
    onstatuschange={handleStatusChange}>
</lightning-flow>
```

---

## 13. 유틸리티 모듈 (Utility Modules, `lightning/*`)

컴포넌트가 아닌 JS import 모듈:

| 모듈 | 설명 |
|---|---|
| `lightning/navigation` | NavigationMixin — 페이지 이동 |
| `lightning/uiRecordApi` | 레코드 CRUD (getRecord, createRecord 등) |
| `lightning/uiObjectInfoApi` | 오브젝트 메타데이터 |
| `lightning/uiListsApi` | 리스트 뷰 데이터 |
| `lightning/uiRelatedListApi` | 관련 목록 데이터 |
| `lightning/messageService` | Lightning Message Service (LMS) |
| `lightning/platformShowToastEvent` | 토스트 이벤트 *(Summer '26 이후 `lightning-toast` 컴포넌트 사용 권장)* |
| `lightning/currentPageReference` | 현재 페이지 참조 |
| `lightning/stateManager` | 상태 관리 *(Summer '26 GA)* |
| `lightning/logger` | 구조화된 로그 *(Winter '26 GA)* |
| `lightning/analyticsWaveApi` | CRM Analytics API |

---

## 빠른 선택 가이드

| 상황 | 컴포넌트 |
|---|---|
| 텍스트 입력 | `lightning-input type="text"` |
| 날짜 입력 | `lightning-input type="date"` |
| 드롭다운 단일 선택 | `lightning-combobox` |
| 드롭다운 다중 선택 | `lightning-dual-listbox` |
| 레코드 검색 선택 | `lightning-record-picker` |
| 버튼 클릭 | `lightning-button` |
| 아이콘 버튼 | `lightning-button-icon` |
| 드롭다운 메뉴 | `lightning-button-menu` + `lightning-menu-item` |
| 카드 레이아웃 | `lightning-card` |
| 테이블 | `lightning-datatable` |
| 레코드 폼 (간단) | `lightning-record-form` |
| 레코드 폼 (커스텀) | `lightning-record-edit-form` + `lightning-input-field` |
| 로딩 표시 | `lightning-spinner` |
| 토스트 알림 | `lightning-toast` (Summer '26+) / `ShowToastEvent` (이전) |
| 모달 | `lightning-modal` 상속 |
| 파일 업로드 | `lightning-file-upload` |
| 아이콘 | `lightning-icon` |
| 숫자·통화 포맷 | `lightning-formatted-number` |
| 날짜 포맷 | `lightning-formatted-date-time` |
| 지도 표시 | `lightning-map` |

---

## 관련 노트

- [[Record Form 선택]] — record-form vs record-edit-form vs record-view-form 선택 기준
- [[Toast & 모달 패턴]] — ShowToastEvent, LightningModal 전체 패턴
- [[uiRecordApi]] — 레코드 CRUD 유틸리티 모듈
- [[NavigationMixin 패턴]] — lightning/navigation 사용법
- [[Lightning Message Service]] — 컴포넌트 간 통신
- [[LWC MOC]] — LWC 전체 목차
