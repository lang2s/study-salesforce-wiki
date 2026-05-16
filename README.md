# Salesforce 개발자 위키

Salesforce 공식 오픈소스 프로젝트를 직접 분석해 추출한 검증된 패턴 모음.  
[Obsidian](https://obsidian.md)에서 열면 `[[wikilink]]` 연결과 그래프 뷰를 활용할 수 있습니다.

**연관 저장소:** [sf-team-framework](https://github.com/lang2s/sf-team-framework) — 위키 분석 결과가 반영되는 팀 스킬 라이브러리

---

## 작업 현황

### ✅ 완료

| 프로젝트 | 분석 대상 | wiki 결과 | 스킬 반영 |
|---|---|---|---|
| [apex-recipes](https://github.com/trailheadapps/apex-recipes) | Apex 클래스 74개 | `Apex/` 31개 노트 | `apex-write` |
| [lwc-recipes](https://github.com/trailheadapps/lwc-recipes) | LWC 컴포넌트 133개 | `LWC/` 18개 노트 | `lwc-write`, `role-code-reviewer`, `role-security` |
| [automation-components](https://github.com/trailheadapps/automation-components) | Flow Action Apex 30개 + Flow Screen LWC 5개 | `Flow/` 8개 노트 | `apex-write`, `lwc-write` |

### 🔲 미완료 — 공식 프로젝트 분석

| 프로젝트 | 핵심 패턴 | wiki 대상 | 스킬 반영 예상 |
|---|---|---|---|
| [dreamhouse-lwc](https://github.com/trailheadapps/dreamhouse-lwc) | LWC + Custom Object + Permission Set + Named Credential 실제 앱 조합 | `LWC/`, `Flow/` 보강 | `role-architect`, `role-security` |
| [agent-script-recipes](https://github.com/trailheadapps/agent-script-recipes) | Agentforce Agent Action, Prompt Template, Einstein AI | `Agentforce/` 섹션 신설 | 신규 스킬 후보 |
| [visualforce-to-lwc](https://github.com/trailheadapps/visualforce-to-lwc) | VF → LWC 마이그레이션 패턴 | `LWC/` 마이그레이션 섹션 | `lwc-write` |
| [ebikes-lwc](https://github.com/trailheadapps/ebikes-lwc) | 대규모 앱 구조, Experience Cloud LWR | `LWC/`, `아키텍처/` | `role-architect` |

### 🔲 미완료 — sf-team-framework 스킬

| 파일 | 작업 내용 |
|---|---|
| `package-config/SKILL.md` | `.prettierrc` 공식 표준(trailingComma/singleQuote/tabWidth), Husky + lint-staged 설정 |
| `ci-workflow/SKILL.md` | GitHub Actions 체인(auto-assign/ci-pr/codetour-watch), Salesforce Code Analyzer 단계 추가 |

### 🔲 미완료 — sf-team-framework 문서

| 파일 | 작업 내용 |
|---|---|
| `docs/planning/05_NAMING_CONVENTIONS.md` | `nx*` prefix 결정 매트릭스 추가 (공식 표준 vs Nexus 차이 명시) |
| `docs/planning/06_PROJECT_STRUCTURES.md` | Single vs Multi-package 구조 결정 매트릭스 (신규 생성) |
| `docs/planning/07_TOOLING_DEFAULTS.md` | `.prettierrc`, `package.json`, ESLint, Husky 기본값 레퍼런스 (신규 생성) |

### 🔲 미완료 — wiki 보강

| 항목 | 작업 내용 |
|---|---|
| `통합/` 섹션 확장 | Named Credential 1개뿐 — RestClient, Callout 패턴, External Service 추가 |
| `Flow/` vs `Apex/` 종합 매트릭스 | "언제 Flow, 언제 Apex, 언제 LWC" 한 장 의사결정 가이드 |
| `Agentforce/` 섹션 신설 | agent-script-recipes 분석 후 생성 |

### 🔲 릴리즈 노트 (상시 추가)

Salesforce 연 3회(Spring/Summer/Winter) 릴리즈마다 `Release/` 폴더에 추가.  
템플릿: `Release/_릴리즈 노트 템플릿.md`

| 릴리즈 | API 버전 | 상태 |
|---|---|---|
| Winter '26 | v64.0 | 🔲 미작성 |
| Summer '25 | v63.0 | 🔲 미작성 |
| Spring '25 | v62.0 | 🔲 미작성 |
| Winter '25 | v61.0 | 🔲 미작성 |
| Summer '24 | v60.0 | 🔲 미작성 |
| Spring '24 | v59.0 | 🔲 미작성 |

### 🔲 심화 단계 — 공식 문서 PDF 분석 (프로젝트 분석 완료 후)

`Salesforce Documents/` 폴더의 공식 레퍼런스 PDF를 기반으로 위키 보강.  
공식 프로젝트 분석으로 채울 수 없는 **스펙 레벨 지식** (한도, 예외 케이스, 옵션 목록 등) 추가.

| PDF | 보강 대상 wiki 섹션 |
|---|---|
| `salesforce_apex_developer_guide.pdf` | `Apex/` 전반 — 거버너 한도, 예외 처리 스펙 |
| `salesforce_apex_reference_guide.pdf` | `Apex/` 클래스별 메서드 옵션 보강 |
| `api_rest.pdf` | `통합/` — REST API 엔드포인트, 응답 구조 |
| `api_meta.pdf` | `Flow/`, `통합/` — Metadata API 배포 패턴 |
| `api_asynch.pdf` | `Apex/비동기/` — Bulk API 한도, Job 상태 |
| `lightning.pdf` | `LWC/` — 컴포넌트 라이프사이클 스펙, 이벤트 버블링 규칙 |
| `pkg2_dev.pdf` | `Flow/멀티 패키지 구조` — 패키지 버전 정책 상세 |
| `sfdx_dev.pdf` | sf-team-framework `ci-workflow` 스킬 보강 |
| `exp_cloud_lwr.pdf` | `LWC/` — Experience Cloud 전용 패턴 |
| `caf_dev.pdf` | `Agentforce/` — Agent Action 스펙 상세 |

---

## 노트 구조

```
Salesforce wiki/
├── 00 Home.md              ← 전체 진입점
├── Apex/                   ← 31개 노트
│   ├── 보안/               Safely, CanTheUser, WITH USER_MODE, StripInaccessible
│   ├── 비동기/             Future, Queueable, Batch, Scheduled, 선택 매트릭스
│   ├── 데이터/             SOQL, DML, Dynamic SOQL
│   ├── 통합/               RestClient, Custom REST Endpoint
│   ├── 테스트/             StubProvider, HttpCalloutMock, testVisible, SOSL
│   ├── 아키텍처/           서비스 레이어, TriggerHandler, CMDT 트리거
│   ├── 컬렉션/             Comparator, Iterable, CollectionUtils
│   ├── 실행컨텍스트/       QuiddityGuard, OrgShape
│   ├── 플랫폼이벤트/       Platform Event
│   └── 플랫폼캐시/         Platform Cache
├── LWC/                    ← 18개 노트
│   ├── Apex통합/           Wire vs Imperative, @wire, async/await
│   ├── 컴포넌트API/        @api, 컴포지션 패턴
│   ├── 이벤트/             CustomEvent, LMS, 상태 관리
│   ├── LDS/                Record Form, uiRecordApi, getRecord, reduceErrors
│   ├── 네비게이션/         NavigationMixin
│   ├── UI패턴/             Toast, 모달, 에러 패널, 공유 JS 모듈
│   └── 보안/               customPermission, CSP, DOM XSS
├── Flow/                   ← 8개 노트
│   ├── Flow 종류와 변수    processType, isInput/isOutput, $Flow 전역 변수
│   ├── Flow 요소 참조      recordLookups/Creates/decisions/actionCalls XML
│   ├── Screen Flow 설계    flowruntime:, LWC 삽입, faultConnector
│   ├── Autolaunched Flow   헤드리스, Apex/Agent에서 호출
│   ├── @InvocableMethod    bulkInvoke, Input/Output 파라미터, JSON 우회
│   ├── Flow Screen LWC     FlowAttributeChangeEvent, validate(), Property Editor
│   └── 멀티 패키지 구조    sfdx-project.json, 도메인별 독립 패키지
└── 통합/
    └── Named Credential    External Credential, callout: 접두어

Salesforce Documents/       ← 공식 레퍼런스 PDF 18개
```

---

## Obsidian에서 열기

1. Obsidian 실행 → **Open folder as vault**
2. 이 저장소의 루트 폴더 선택
3. `00 Home.md` 를 시작점으로 탐색
4. **Graph View** (Ctrl/Cmd + G) 에서 노트 연결망 확인

---

## 로컬 프로젝트 경로 (분석 소스)

```
/Users/a/Desktop/Salesforce/TrailheadApp/
├── apex-recipes-main/          ✅ 분석 완료
├── lwc-recipes-main/           ✅ 분석 완료
├── automation-components-main/ ✅ 분석 완료
├── dreamhouse-lwc-main/        🔲 미완료
├── agent-script-recipes-main/  🔲 미완료
├── visualforce-to-lwc-main/    🔲 미완료
└── ebikes-lwc-main/            🔲 미완료
```
