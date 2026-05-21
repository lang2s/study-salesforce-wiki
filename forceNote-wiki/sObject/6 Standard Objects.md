---
tags: [sobject-reference, standard-objects, object-catalog, account, contact, case, opportunity]
source: object_reference.pdf p.105+ (v67.0 Summer '26)
created: 2026-05-22
aliases: [6 Standard Objects, 표준 Object 카탈로그, Standard Object 목록, Account, Contact, Case, Opportunity, Lead]
---

# 6 Standard Objects — 도메인별 카탈로그

> Object Reference v67.0의 표준 Object를 도메인별로 그룹화 — 주요 Object 선별 (전체 목록은 원본 PDF Ch6 참조)

---

## 도메인 목록

- [Core CRM (Sales Cloud)](#core-crm-sales-cloud)
- [Service Cloud](#service-cloud)
- [Marketing](#marketing)
- [Platform / Admin / Security](#platform--admin--security)
- [Apex / Dev / Metadata](#apex--dev--metadata)
- [Files / Content](#files--content)
- [Einstein / AI](#einstein--ai)
- [B2B Commerce](#b2b-commerce)
- [Field Service (FSL)](#field-service-fsl)
- [Analytics / Reports](#analytics--reports)
- [Experience Cloud / Communities](#experience-cloud--communities)
- [Collaboration / Chatter](#collaboration--chatter)

---

## Core CRM (Sales Cloud)

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Account` | 회사·조직 레코드. CRM의 핵심 Object | CRUD + 검색 |
| `AccountBrand` | 계정 브랜드 정보 | CRUD |
| `AccountContactRelation` | Account-Contact 다대다 관계 | CRUD |
| `AccountContactRole` | Account의 Contact 역할 | CRUD |
| `AccountPartner` | Account 간 파트너 관계 | CRUD |
| `AccountPlan` | 계정 플랜 (Account Plan) | CRUD |
| `AccountShare` | Account 공유 항목 | CRUD |
| `AccountTeamMember` | 계정 팀 구성원 | CRUD |
| `AccountTerritoryAssignmentRule` | 영역 배정 규칙 | CRUD |
| `Contact` | 개인 연락처 | CRUD + 검색 |
| `ContactCleanInfo` | Data.com 정리 정보 | R |
| `Lead` | 잠재 고객 | CRUD + 검색 |
| `Opportunity` | 영업 기회 | CRUD + 검색 |
| `OpportunityContactRole` | Opportunity의 Contact 역할 | CRUD |
| `OpportunityHistory` | Opportunity Stage 변경 이력 | R |
| `OpportunityShare` | Opportunity 공유 | CRUD |
| `OpportunityTeamMember` | 영업 팀 구성원 | CRUD |
| `Contract` | 계약서 | CRUD |
| `Order` | 주문 | CRUD |
| `OrderItem` | 주문 라인 아이템 | CRUD |
| `Pricebook2` | 가격표 | CRUD |
| `PricebookEntry` | 가격표 항목 | CRUD |
| `Product2` | 제품 카탈로그 | CRUD |
| `Quote` | 견적서 | CRUD |
| `QuoteLineItem` | 견적 라인 아이템 | CRUD |
| `Task` | 활동 (To-Do) | CRUD |
| `Event` | 일정·미팅 | CRUD |
| `ActivityHistory` | 완료된 활동 이력 | R |
| `OpenActivity` | 미완료 활동 | R |
| `UserTerritory` | 사용자-영역 매핑 | CRUD |
| `Territory2` | 영역 관리 (Enterprise Territory Management) | CRUD |
| `Forecast` (ForecastingAdjustment 등) | 예측 매출 | CRUD |
| `ActionCadence` | Sales Engagement 카덴스 | CRUD |
| `ActionCadenceStep` | 카덴스 단계 | CRUD |
| `ActionCadenceTracker` | 카덴스 추적 | CRUD |

---

## Service Cloud

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Case` | 고객 지원 케이스 | CRUD + 검색 |
| `CaseArticle` | 케이스 관련 Knowledge 아티클 | CRUD |
| `CaseComment` | 케이스 댓글 | CRUD |
| `CaseContactRole` | 케이스의 Contact 역할 | CRUD |
| `CaseMilestone` | 케이스 마일스톤 (Entitlement) | R |
| `CaseShare` | 케이스 공유 | CRUD |
| `CaseSolution` | 케이스 솔루션 | CRUD |
| `CaseTeamMember` | 케이스 팀 구성원 | CRUD |
| `Entitlement` | 지원 권한 정의 | CRUD |
| `EntitlementContact` | 지원 권한 Contact 연결 | CRUD |
| `EntitlementTemplate` | 지원 권한 템플릿 | CRUD |
| `ServiceContract` | 서비스 계약 | CRUD |
| `ContractLineItem` | 서비스 계약 라인 | CRUD |
| `Knowledge__kav` | Knowledge 아티클 버전 | CRUD |
| `Solution` | 솔루션 (구형) | CRUD |
| `Survey` | 설문 | CRUD |
| `SurveyInvitation` | 설문 초대 | CRUD |
| `AgentWork` | Omni-Channel 에이전트 업무 | R |
| `ServicePresenceStatus` | 에이전트 상태 | CRUD |
| `VoiceCall` | Voice 통화 기록 | CRUD |
| `BusinessHours` | 비즈니스 시간 설정 | CRUD |
| `SlaProcess` | SLA 프로세스 | CRUD |
| `LiveChatTranscript` | Live Chat 기록 | CRUD |
| `MessagingSession` | Messaging 세션 | CRUD |

---

## Marketing

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Campaign` | 마케팅 캠페인 | CRUD + 검색 |
| `CampaignInfluence` | 캠페인 영향 (Attribution) | CRUD |
| `CampaignInfluenceModel` | Attribution 모델 | CRUD |
| `CampaignMember` | 캠페인 멤버 | CRUD |
| `CampaignMemberStatus` | 캠페인 멤버 상태 값 | CRUD |
| `CampaignShare` | 캠페인 공유 | CRUD |
| `Email` (Messaging Namespace) | 이메일 발송 | — |
| `AttribModel` | Attribution 모델 | CRUD |
| `AttribModelStage` | Attribution 단계 | CRUD |

---

## Platform / Admin / Security

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `User` | Salesforce 사용자 | CRUD |
| `UserRole` | 역할 계층 | CRUD |
| `Group` | Public Group / Queue | CRUD |
| `GroupMember` | Group 멤버 | CRUD |
| `Organization` | Org 설정 정보 | R |
| `Profile` | 프로필 | R |
| `PermissionSet` | 권한 집합 | CRUD |
| `PermissionSetAssignment` | 권한 집합 배정 | CRUD |
| `PermissionSetGroup` | 권한 집합 그룹 | CRUD |
| `OrgWideEmailAddress` | Org 전체 이메일 주소 | CRUD |
| `AuthConfig` | 인증 설정 | CRUD |
| `AuthConfigProviders` | 인증 공급자 설정 | CRUD |
| `AuthProvider` | 소셜 인증 공급자 | CRUD |
| `AuthSession` | 현재 세션 정보 | R |
| `LoginHistory` | 로그인 이력 | R |
| `SetupEntityAccess` | 권한 기반 Setup 엔티티 접근 | R |
| `BusinessProcess` | 비즈니스 프로세스 (Stage 값 서브셋) | CRUD |
| `RecordType` | 레코드 타입 | R |
| `AssignmentRule` | 케이스/Lead 배정 규칙 | CRUD |
| `WorkflowRule` | 워크플로우 규칙 | R |
| `ActiveFeatureLicenseMetric` | 기능 라이센스 사용 현황 | R |
| `ActivePermSetLicenseMetric` | 권한 집합 라이센스 사용 현황 | R |
| `ActiveProfileMetric` | 프로필 사용 현황 | R |

---

## Apex / Dev / Metadata

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `ApexClass` | Apex 클래스 메타데이터 | CRUD |
| `ApexTrigger` | Apex 트리거 메타데이터 | CRUD |
| `ApexPage` | Visualforce 페이지 | CRUD |
| `ApexComponent` | Visualforce 컴포넌트 | CRUD |
| `ApexLog` | Apex 디버그 로그 | R |
| `ApexTestQueueItem` | Apex 테스트 큐 아이템 | CRUD |
| `ApexTestResult` | Apex 테스트 결과 | R |
| `ApexTestResultLimits` | 테스트 결과 거버너 한도 | R |
| `ApexTestRunResult` | 테스트 실행 결과 | R |
| `ApexTestSuite` | 테스트 스위트 | CRUD |
| `ApexTypeImplementor` | Apex 인터페이스 구현체 목록 | R |
| `AsyncApexJob` | 비동기 Apex 작업 | R |
| `BatchApexErrorEvent` | Batch 오류 이벤트 | — (Platform Event) |
| `StaticResource` | 정적 리소스 | CRUD |
| `AuraDefinition` | Aura 컴포넌트 정의 | CRUD |
| `AuraDefinitionBundle` | Aura 컴포넌트 번들 | CRUD |
| `AuraDefinitionBundleInfo` | 번들 정보 | R |
| `FlexiPage` | Lightning 페이지 | CRUD |
| `NetworkMember` | Experience Cloud 멤버 | CRUD |
| `ActiveScratchOrg` | 활성 Scratch Org | CRUD |

### Apex EventLog Objects (이벤트 로그)

| Object | 설명 |
|---|---|
| `ApexCalloutEventLog` | Apex Callout 이벤트 |
| `ApexExecutionEventLog` | Apex 실행 이벤트 |
| `ApexTriggerEventLog` | Apex 트리거 실행 이벤트 |
| `ApexUnexpectedExcpEventLog` | Apex 예외 이벤트 |
| `BulkApi2EventLog` | Bulk API v2 이벤트 |
| `BulkApiEventLog` | Bulk API 이벤트 |
| `SoapApiEventLog` | SOAP API 이벤트 |

---

## Files / Content

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Attachment` | 구형 파일 첨부 (Note 포함) | CRUD |
| `ContentDocument` | 파일 문서 | CRUD |
| `ContentDocumentLink` | 레코드-파일 연결 | CRUD |
| `ContentVersion` | 파일 버전 | CRUD |
| `ContentNote` | 풍부한 텍스트 노트 | CRUD |
| `Document` | 폴더 기반 문서 | CRUD |
| `AttachedContentDocument` | 레코드에 첨부된 ContentDocument | R |
| `AttachedContentNote` | 레코드에 첨부된 ContentNote | R |

---

## Einstein / AI

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `AIApplication` | AI 앱 설정 | CRUD |
| `AIApplicationConfig` | AI 앱 설정 상세 | CRUD |
| `AIInsightAction` | AI 인사이트 실행 | CRUD |
| `AIInsightFeedback` | AI 인사이트 피드백 | CRUD |
| `AIInsightReason` | AI 인사이트 근거 | R |
| `AIInsightValue` | AI 인사이트 값 | R |
| `AIRecordInsight` | 레코드 기반 AI 인사이트 | R |
| `AIResearchPromptResult` | AI 리서치 프롬프트 결과 | R |
| `AiGenActionItem` | AI 생성 액션 아이템 | R |
| `AiJobRun` | AI 작업 실행 | R |

---

## B2B Commerce

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `BuyerAccount` | 구매자 계정 | CRUD |
| `BuyerCriteria` | 구매자 기준 | CRUD |
| `BuyerGroup` | 구매자 그룹 | CRUD |
| `BuyerGroupMember` | 구매자 그룹 멤버 | CRUD |
| `BuyerGroupPricebook` | 그룹별 가격표 | CRUD |
| `CartCheckoutSession` | 카트 체크아웃 세션 | CRUD |
| `CartDeliveryGroup` | 배송 그룹 | CRUD |
| `CartDeliveryGroupMethod` | 배송 방법 | CRUD |
| `CartItem` | 카트 항목 | CRUD |
| `CartItemPriceAdjustment` | 카트 항목 가격 조정 | CRUD |
| `CartTax` | 카트 세금 | CRUD |
| `CartValidationOutput` | 카트 유효성 검사 결과 | R |
| `WebCart` | 전자상거래 카트 (SalesTransaction 구현) | CRUD |
| `WebCartAdjustmentGroup` | 카트 전체 가격 조정 그룹 (PriceAdjustmentGroup 구현) | CRUD |

---

## Field Service (FSL)

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `WorkOrder` | 작업 지시서 | CRUD |
| `WorkOrderLineItem` | 작업 지시서 라인 | CRUD |
| `ServiceAppointment` | 서비스 예약 | CRUD |
| `ServiceResource` | 서비스 리소스 (직원·장비) | CRUD |
| `ServiceTerritory` | 서비스 영역 | CRUD |
| `ServiceTerritoryMember` | 영역 멤버 | CRUD |
| `AssignedResource` | 예약에 배정된 리소스 | CRUD |
| `ResourceAbsence` | 리소스 부재 | CRUD |
| `Skill` | 기술/역량 | CRUD |
| `SkillRequirement` | 기술 요구사항 | CRUD |
| `FSL__Time_Dependency__c` | SA 간 의존성 (관리 패키지) | CRUD |
| `AppointmentSchedulingPolicy` | 스케줄링 정책 | CRUD |

---

## Analytics / Reports

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Report` | 보고서 | CRUD |
| `Dashboard` | 대시보드 | CRUD |
| `DashboardComponent` | 대시보드 컴포넌트 | CRUD |
| `AnalyticsDashboard` | Einstein Analytics 대시보드 | CRUD |
| `AnalyticsDashboardWidget` | Analytics 위젯 | CRUD |
| `AnalyticsWorkspace` | Analytics 워크스페이스 | CRUD |
| `AnalyticsWorkspaceAsset` | Analytics 에셋 | CRUD |

---

## Experience Cloud / Communities

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `Network` | Experience Cloud 사이트 설정 | CRUD |
| `NetworkMember` | 사이트 멤버 | CRUD |
| `NetworkSelfRegistration` | 자가 등록 설정 | CRUD |
| `Audience` | 대상 고객 세그먼트 | CRUD |
| `BriefcaseDefinition` | 브리프케이스 정의 (Mobile Offline) | CRUD |

---

## Collaboration / Chatter

| Object | 설명 | 주요 지원 호출 |
|---|---|---|
| `FeedItem` | Chatter 피드 아이템 | CRUD |
| `FeedComment` | Chatter 댓글 | CRUD |
| `FeedLike` | 좋아요 | CRUD |
| `CollaborationGroup` | Chatter 그룹 | CRUD |
| `CollaborationGroupMember` | Chatter 그룹 멤버 | CRUD |
| `Announcement` | 그룹 공지 | CRUD |
| `Bookmark` | 북마크 | CRUD |

---

## SOQL 패턴 — 자주 사용하는 Standard Object 쿼리

```apex
// Account + Contact 관계 쿼리
List<Account> accounts = [
    SELECT Id, Name, Industry, AnnualRevenue,
           (SELECT Id, FirstName, LastName, Email FROM Contacts)
    FROM Account
    WHERE Industry = 'Technology'
    AND AnnualRevenue > 1000000
    ORDER BY Name
    WITH USER_MODE
];

// Case + 첨부 아티클 조회
List<Case> cases = [
    SELECT Id, CaseNumber, Subject, Status, Priority,
           Account.Name, Contact.Name,
           (SELECT ArticleNumber, Title FROM CaseArticles)
    FROM Case
    WHERE Status != 'Closed'
    AND Priority = 'High'
    ORDER BY CreatedDate DESC
    LIMIT 200
    WITH USER_MODE
];

// ContentDocument 파일 조회 (특정 레코드 첨부)
List<ContentDocumentLink> links = [
    SELECT ContentDocument.Title, ContentDocument.FileType,
           ContentDocument.FileExtension, ContentDocument.ContentSize,
           ContentDocument.LatestPublishedVersion.VersionData
    FROM ContentDocumentLink
    WHERE LinkedEntityId = :recordId
    ORDER BY ContentDocument.CreatedDate DESC
];
```

---

## 관련 노트

- [[1 Overview]] — Field 타입·ID 타입·Compound Fields
- [[2 Object Behavior]] — Object 그룹·타입 분류
- [[3 Associated Objects]] — Feed·History·Share 패턴
- [[4 Custom Objects]] — __mdt·__c·__Feed 표준 필드
- [[5 Object Interfaces]] — PriceAdjustmentGroup·SalesTransaction
- [[SOQL 문법 레퍼런스]] — SOQL 전체 문법
- [[SOQL 패턴]] — WITH USER_MODE·SOQL for loop
- [[DML 패턴]] — insert·update·upsert
