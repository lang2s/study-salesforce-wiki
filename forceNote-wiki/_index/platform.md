---
tags: [index, search, navigation]
created: 2026-05-21
---

# SEARCH INDEX — 플랫폼 (Architecture / Admin / DevOps / Integration)
> VF·Site·Canvas·AppLauncher·VisualEditor·Admin·DX·외부연동 키워드 → 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## Architecture — Site Namespace

| 키워드 | 파일 |
|---|---|
| Site Namespace, Site.UrlRewriter, UrlRewriter, Sites URL 재작성, Force.com Sites, URL rewriting, generateUrlFor, mapRequestUrl, SEO 친화적 URL, Salesforce Sites URL | `Architecture(아키텍처)/Site Namespace.md` |
| Site.ExternalUserCreateException, 외부 사용자 생성 예외, getDisplayMessages, 커뮤니티 사용자 생성 실패 | `Architecture(아키텍처)/Site Namespace.md` |
| Site namespace와 Experience Cloud 차이, UrlRewriter 등록 방법, Sites URL rewrite setup | `Architecture(아키텍처)/Site Namespace.md` |
| Context Namespace, Context.IndustriesContext, IndustriesContext, Context Service Apex, Industries Context, 컨텍스트 서비스, Financial Services Cloud Context, Health Cloud Context, 비즈니스 컨텍스트 공유 | `Architecture(아키텍처)/Context Namespace.md` |

## Architecture — ApexPages Namespace

| 키워드 | 파일 |
|---|---|
| ApexPages Namespace, ApexPages 네임스페이스, Visualforce 컨트롤러, VF 컨트롤러, StandardController, StandardSetController, ApexPages.Action, ApexPages.Message, ApexPages.Component | `Architecture(아키텍처)/ApexPages Namespace.md` |
| StandardController 확장, 표준 컨트롤러 확장, getRecord, addFields, getId, save cancel delete edit view, 컨트롤러 확장 클래스, VF 표준 컨트롤러 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| StandardSetController, 목록 컨트롤러, 페이지네이션, getRecords, getHasNext, getHasPrevious, setPageSize, getSelected, setSelected, getCompleteResult, 10000 레코드 한도 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| ApexPages.Message, Severity enum, CONFIRM ERROR FATAL INFO WARNING, VF 유효성 검사 오류, 커스텀 컨트롤러 오류 처리 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| IdeaStandardController, IdeaStandardSetController, getCommentList, getIdeaList, Idea 컨트롤러 | `Architecture(아키텍처)/ApexPages Namespace.md` |
| KnowledgeArticleVersionStandardController, Knowledge 문서 컨트롤러, getSourceId, setDataCategory | `Architecture(아키텍처)/ApexPages Namespace.md` |
| ApexPages.Component, childComponents, expressions, facets, 동적 Visualforce 컴포넌트, 동적 VF | `Architecture(아키텍처)/ApexPages Namespace.md` |

## Architecture — AppLauncher Namespace

| 키워드 | 파일 |
|---|---|
| AppLauncher Namespace, AppLauncher 네임스페이스, AppMenu, App Launcher Apex, 앱 런처 제어, 앱 가시성 설정, 앱 정렬 순서 | `Architecture(아키텍처)/AppLauncher Namespace.md` |
| setAppVisibility, 앱 숨기기, 앱 표시, AppMenuItem ApplicationId, App Launcher 앱 숨김 | `Architecture(아키텍처)/AppLauncher Namespace.md` |
| setOrgSortOrder, setUserSortOrder, 조직 정렬 순서, 사용자 정렬 순서, UserAppMenuItem AppMenuItemId | `Architecture(아키텍처)/AppLauncher Namespace.md` |

## Architecture — VisualEditor Namespace

| 키워드 | 파일 |
|---|---|
| VisualEditor Namespace, VisualEditor 네임스페이스, DynamicPickList, 동적 피클리스트, App Builder 피클리스트, Lightning App Builder 커스텀 피클리스트 | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DataRow, VisualEditor.DataRow, 피클리스트 행, label value selected, getLabel getValue isSelected, compareTo | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DesignTimePageContext, entityName pageType, HomePage AppPage RecordPage, 페이지 컨텍스트 Apex | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| DynamicPickListRows, containsAllRows, addRow addAllRows getDataRows sort, 타입-어헤드 200개 한도 | `Architecture(아키텍처)/VisualEditor Namespace.md` |
| datasource="apex://", Aura design attribute datasource, DynamicPickList 상속, 앱 빌더 속성 드롭다운 | `Architecture(아키텍처)/VisualEditor Namespace.md` |

## DevOps — Salesforce DX

| 키워드 | 파일 |
|---|---|
| Salesforce DX, sfdx-project.json, sf CLI, sf project deploy, sf project retrieve, source format, .forceignore, sourceApiVersion, packageDirectories, DevOps | `DevOps(데브옵스)/Salesforce DX 개요.md` |
| Scratch Org, org create scratch, project-scratch-def.json, Dev Hub, Scratch Org 생성, Org Shape, Snapshot, org create snapshot, source tracking | `DevOps(데브옵스)/Scratch Org 패턴.md` |
| Unlocked Package, sf package create, sf package version create, sf package install, 2GP, packageAliases, org-dependent, 패키지 버전, 내부 앱 패키징 | `DevOps(데브옵스)/Unlocked Package 패턴.md` |
| CI/CD, Jenkins, Jenkinsfile, CircleCI, JWT 인증 자동화, org login jwt, 자동화 파이프라인, 지속적 통합, 패키지 CI 빌드, Connected App JWT | `DevOps(데브옵스)/CI CD 패턴.md` |

## Admin(어드민) — 일반 사용자 / 관리자

| 키워드 | 파일 |
|---|---|
| Salesforce 기초, Org, Object, Record, Field, App, Tab, Cloud, 플랫폼 개요, Sales Cloud, Service Cloud, Agentforce, 환경 종류, Sandbox, Scratch Org, Developer Edition | `Architecture(아키텍처)/Salesforce 플랫폼 개요.md` |
| Salesforce 네비게이션, App Launcher, 앱 런처, 전역 검색, Global Search, 탐색바, 리스트뷰, 레코드 페이지, Lightning Experience, 홈 페이지 | `Admin(어드민)/Salesforce 네비게이션.md` |
| MFA, Multi-Factor Authentication, 다중 인증, Salesforce Authenticator, TOTP, 보안 키, FIDO2, Trusted IP Ranges, 신원 확인, 이중 인증, MFA 의무화 | `Admin(어드민)/Salesforce ID 인증.md` |

---

## Integration(통합) — 외부 시스템 연동

| 키워드 | 파일 |
|---|---|
| Named Credential, callout:, 네임드 크레덴셜, 외부 URL 인증 | `Integration(통합)/Named Credential.md` |
| CSP Trusted Site, Remote Site, 외부 이미지 로드, 외부 API 브라우저 | `Integration(통합)/CSP와 RemoteSite.md` |
| Queueable Callout, 비동기 외부 호출, DML+Callout 조합 | `Integration(통합)/Queueable + Callout 패턴.md` |
| Platform Event 통합, 이벤트 기반 통합, 시스템 간 느슨한 결합, LWC empApi | `Integration(통합)/Platform Event 통합 패턴.md` |

---

