---
tags: [index, search, navigation, sobject-reference]
created: 2026-05-22
---

# SEARCH INDEX — sObject Reference (Object Reference v67.0)
> Salesforce Platform Object Reference — Field 타입·Object 그룹·Associated Objects·Custom Objects·Object Interfaces 전체 파일
> 루트 라우터: `00 SEARCH_INDEX.md` · 다른 샤드는 라우터에서 이동.

## Ch1 — Overview (Field 타입·Primitive 타입·Compound Fields)

| 키워드 | 파일 |
|---|---|
| Primitive Data Types, base64, boolean, byte, date, dateTime, double, int, long, string, time, SOAP 데이터 타입, API 데이터 타입 | `sObject/Primitive Data Types.md` |
| double precision scale, STRING_TOO_LONG, AllowFieldTruncationHeader, dateTime UTC, long 범위 | `sObject/Primitive Data Types.md` |
| Field Types, address, anyType, calculated, combobox, currency, email, encryptedstring, ID, JunctionIdList, location, multipicklist, percent, phone, picklist, reference, textarea, url, 필드 타입 | `sObject/Field Types.md` |
| 18자리 ID, 15자리 ID, case-safe ID, case-sensitive ID, ID Field Type, 대소문자 ID 변환 | `sObject/Field Types.md` |
| JunctionIdList 500 레코드 제한, WhoId WhatId polymorphic reference, picklist unrestricted | `sObject/Field Types.md` |
| API Field Properties, Aggregatable, Autonumber, Create, Defaulted on create, Filter, Group, idLookup, Namepointing, Nillable, Restricted picklist, Sort, Update, 필드 속성 | `sObject/API Field Properties.md` |
| Required Fields, create update 필수 규칙, nillable, defaulted on create, 필수 필드 판단 | `sObject/API Field Properties.md` |
| System Fields, CreatedDate, CreatedById, LastModifiedDate, SystemModstamp, IsDeleted, 시스템 필드, Audit Fields | `sObject/System Fields.md` |
| OwnerId, RecordTypeId, CurrencyIsoCode, 공통 포함되는 필드, 공통 필드, LastReferencedDate, LastViewedDate | `sObject/System Fields.md` |
| Audit Fields 설정 절차, Set Audit Fields upon Record Creation, 1970-01-01 4000-12-31 유효 날짜 범위 | `sObject/System Fields.md` |
| Compound Fields, Address Compound Field, BillingAddress, MailingAddress, ShippingAddress, GeocodeAccuracy, 복합 필드, 주소 복합 필드 | `sObject/Compound Fields.md` |
| Geolocation Compound Field, Location, latitude, longitude, __latitude__s, __longitude__s, DISTANCE, GEOLOCATION, 지리좌표계 | `sObject/Compound Fields.md` |
| Compound Field Limitations, 복합 필드 제한, 복합 필드 쿼리 제약, WHERE 절 제약, Custom Address Fields | `sObject/Compound Fields.md` |
| Custom Objects, __c suffix, Naming Conventions, 커스텀 Object, __r 관계 필드, 네이밍 규칙, __Share, __Tag | `sObject/Custom Objects.md` |
| Custom Objects Audit Fields, Set Audit Fields, REQUIRED_FIELD_MISSING, Managed Package namespace prefix | `sObject/Custom Objects.md` |
| Custom Fields, External ID, Uniqueness, caseSensitive, DUPLICATE_VALUE, Default Values formula | `sObject/Custom Fields.md` |
| Object Relationships, Master-Detail, Lookup, Many-to-many, Junction Object, cascadeDelete | `sObject/Object Relationships.md` |
| View All Records, Modify All Records, OLS FLS, referential integrity, Page Layout 비적용 | `sObject/Object Relationships.md` |
| External Objects, __x suffix, OData, 외부 Object, 외부 시스템 데이터, Salesforce Connect, Files Connect | `sObject/External Objects.md` |
| External Lookup, Indirect Lookup, Cross-org adapter, OData 2.0 OData 4.0, Apex Connector Framework | `sObject/External Objects.md` |
| Big Objects, __b suffix, FieldHistoryArchive, 빅오브젝트, 대용량 보관 데이터 저장소 | `sObject/Big Objects.md` |
| Big Object Metadata, CustomObject CustomField Index IndexField, idempotent insert, REST API 미지원 | `sObject/Big Objects.md` |
| Object Interfaces, API v55.0, 오브젝트 인터페이스 | `sObject/1 Overview.md` |

## Ch2 — Object Behavior (Object 그룹·타입·Data Cloud)

| 키워드 | 파일 |
|---|---|
| Object Groups, Salesforce Common Objects, Cloud Objects, High-Scale Objects, External Data Objects, Object 그룹, 오브젝트 그룹, Object 선택 기준 | `sObject/Object Groups.md` |
| Original Platform Objects, Account Contact Lead Opportunity, 핵심 CRM Object, ACID 트랜잭션, Hero Objects, Legacy Objects | `sObject/Object Groups.md` |
| Base Platform Objects, BPO, 플랫폼 오브젝트, SocialPersona | `sObject/Object Groups.md` |
| Setup Platform Objects, SPO, CompactLayout, CustomField, 설정 오브젝트 | `sObject/Object Groups.md` |
| Objects by Data Flow, Objects by Data Domain, Objects by Transaction Type, ACID OLTP OLAP 분류 | `sObject/Object Groups.md` |
| Data Cloud Objects, DLO, DMO, CIO, DG, UDLO, UDMO, Unified Objects, Data Lake Object, Data Model Object, Calculated Insight Object, Data Graph, __dlo, __dlm, __cio, __dg, 데이터클라우드 오브젝트 | `sObject/Data Cloud Objects.md` |
| DMO Object Creation, DMO 생성 흐름, DLO to DMO, Identity Resolution, C360 Data Model, 데이터 모델 오브젝트 생성 | `sObject/Data Cloud Objects.md` |
| UDMO Object Creation, UDMO 생성 흐름, Unstructured Data Lake Object, RAG GenAI, 비정형 데이터 모델 | `sObject/Data Cloud Objects.md` |
| Zero Copy Objects, Snowflake, AWS, 제로 복제, 외부 데이터 연동, Zero Copy 생성 흐름 | `sObject/Data Cloud Objects.md` |
| Object Types, Object Suffix, __b __c __ChangeEvent __chn __cio __dg __dlm __dlo __dmo __dso __e __Feed __hd __History _hst __ka __kav __mdt __pc __pr __r __Share __Tag __ViewStat __VoteStat __x __xo, 오브젝트 타입, 오브젝트 접미어, suffix 표 | `sObject/Object Types Reference.md` |
| Object Cheatsheet, CRUD 지원, 오브젝트 비교, Object 비교 Packaging Documentation Reference | `sObject/Object Types Reference.md` |
| Identifying Object Type, Accessing Object, Object Manager, 오브젝트 타입 식별 | `sObject/Object Types Reference.md` |
| 2 Object Behavior, Object Behavior 개요, Object 선택 프레임워크 | `sObject/2 Object Behavior.md` |

## Ch3 — Associated Objects (Feed·History·Share·OwnerSharingRule·ChangeEvent)

| 키워드 | 파일 |
|---|---|
| StandardObjectName Feed, AccountFeed, CaseFeed, OpportunityFeed, FeedItem, 피드 Object, Chatter 피드 | `sObject/Feed Objects.md` |
| Feed Type, TextPost, ContentPost, LinkPost, TrackedChange, ActivityEvent, QuestionPost, AdvancedTextPost, CanvasPost, PollPost, ReplyPost, RypplePost, 피드 타입, 피드 아이템 타입 | `sObject/Feed Objects.md` |
| IsRichText, Feed Rich Text, 피드 rich text, Body HTML, BestCommentId, CommentCount, ConnectionId, ContentData, ContentFileName, ContentSize, ContentType, FeedPostId, InsertedById, LikeCount, LinkUrl, NetworkScope, ParentId, RelatedRecordId, Visibility, CaseFeed 전용 타입 | `sObject/Feed Objects.md` |
| StandardObjectName History, AccountHistory, CaseHistory, FieldHistory, 필드 변경 이력, History Object | `sObject/History Objects.md` |
| OldValue NewValue, DataType, Field History Tracking, 이전 값과 새 값, 히스토리 추적, StandardObjectNameId, delete Field History v42.0 | `sObject/History Objects.md` |
| StandardObjectName OwnerSharingRule, AccountOwnerSharingRule, 소유자 공유 규칙, Owner Sharing Rule, GroupId, DeveloperName, 공유 규칙 생성 | `sObject/Share Objects.md` |
| StandardObjectName Share, AccountShare, CaseShare, RowCause, AccessLevel, Manual, 공유 오브젝트, 수동 공유, UserOrGroupId, ParentId, RowCause Manual 전용 쓰기 | `sObject/Share Objects.md` |
| ChangeEvent, CDC, Change Data Capture, AccountChangeEvent, changeType CREATE UPDATE DELETE UNDELETE, ChangeEventHeader, changedFields, 변경감지, replayId, schema, entityName, recordIds, transactionKey, sequenceNumber, commitTimestamp, commitUser, CDC 지원 오브젝트 목록 | `sObject/ChangeEvent Objects.md` |

## Ch4 — Custom Objects (__mdt·__c·__Feed)

| 키워드 | 파일 |
|---|---|
| Custom Metadata Type, __mdt, DeveloperName, MasterLabel, isProtected, QualifiedApiName, 커스텀 메타데이터, 메타데이터 타입 | `sObject/4 Custom Objects.md` |
| __mdt 쿼리 제약, describeSObjects query retrieve, Custom Metadata 제한, SOQL 커스텀 메타데이터 | `sObject/4 Custom Objects.md` |
| Custom Object __c 공통 필드, ConnectionReceivedId, ConnectionSentId, LastReferencedDate, LastViewedDate, 커스텀 Object 시스템 필드 | `sObject/4 Custom Objects.md` |
| Custom Object __Feed 공통 필드, 커스텀 Object 피드, Chatter 피드 커스텀 Object | `sObject/4 Custom Objects.md` |
| FSL__Time_Dependency__c, Field Service, 서비스 예약 종속성, FSL 종속성, Service Appointment 종속성 | `sObject/4 Custom Objects.md` |

## Ch5 — Object Interfaces (PriceAdjustmentGroup·PriceAdjustmentItem·SalesTransaction)

| 키워드 | 파일 |
|---|---|
| PriceAdjustmentGroup, 가격 조정 그룹, 그룹 가격 조정, B2B Commerce 가격, Subscription Management 가격, WebCartAdjustmentGroup | `sObject/5 Object Interfaces.md` |
| PriceAdjustmentItem, 라인 아이템 가격 조정, AdjustmentAmountScope, Total Unit 조정 범위, CartItemPriceAdjustment | `sObject/5 Object Interfaces.md` |
| AdjustmentSource, Discretionary, Promotion, System, 조정 출처 | `sObject/5 Object Interfaces.md` |
| AdjustmentType, AdjustmentAmount, AdjustmentPercentage, OverrideAmount, 조정 방식 | `sObject/5 Object Interfaces.md` |
| Priority, PriceAdjustment 적용 우선순위, 가격 조정 순서, null priority | `sObject/5 Object Interfaces.md` |
| SalesTransaction, Order WebCart, TotalAmount, TotalListAmount, TotalProductAmount, TotalAdjustmentAmount, 판매 트랜잭션 인터페이스 | `sObject/5 Object Interfaces.md` |

## Ch6 — Standard Objects (도메인별 이동 목록)

| 키워드 | 파일 |
|---|---|
| Account, AccountBrand, AccountContactRelation, AccountContactRole, AccountPartner, AccountPlan, AccountShare, AccountTeamMember, 거래처 | `sObject/6 Standard Objects.md` |
| Contact, Lead, Opportunity, OpportunityContactRole, OpportunityHistory, Contract, Order, Pricebook2, Product2, Quote, 영업 기회, 가격표, 제품 | `sObject/6 Standard Objects.md` |
| Task, Event, ActivityHistory, OpenActivity, ActionCadence, ActionCadenceStep, 활동, 일정, 태스크 | `sObject/6 Standard Objects.md` |
| Case, CaseArticle, CaseComment, CaseMilestone, Entitlement, ServiceContract, Knowledge, Survey, AgentWork, 케이스, 서비스클라우드 | `sObject/6 Standard Objects.md` |
| Campaign, CampaignMember, CampaignInfluence, AttribModel, 캠페인, 마케팅 | `sObject/6 Standard Objects.md` |
| User, UserRole, Group, GroupMember, Organization, Profile, PermissionSet, AuthSession, LoginHistory, 사용자, 권한, 보안 | `sObject/6 Standard Objects.md` |
| ApexClass, ApexTrigger, ApexPage, ApexLog, AsyncApexJob, ApexTestResult, StaticResource, AuraDefinition, 메타데이터 Object, 개발자 Object | `sObject/6 Standard Objects.md` |
| ContentDocument, ContentDocumentLink, ContentVersion, Attachment, Document, ContentNote, 파일, 첨부, 파일관리 | `sObject/6 Standard Objects.md` |
| AIApplication, AIInsightAction, AIRecordInsight, Einstein AI Object, AI 오브젝트 | `sObject/6 Standard Objects.md` |
| BuyerAccount, BuyerGroup, CartItem, CartCheckoutSession, WebCart, B2B Commerce Object, 구매자관리 | `sObject/6 Standard Objects.md` |
| WorkOrder, ServiceAppointment, ServiceResource, ServiceTerritory, Skill, Field Service Object, FSL Object | `sObject/6 Standard Objects.md` |
| Report, Dashboard, AnalyticsDashboard, AnalyticsWorkspace, 보고서, 대시보드 | `sObject/6 Standard Objects.md` |
| Network, NetworkMember, Audience, Experience Cloud Object, 익스피리언스 Object | `sObject/6 Standard Objects.md` |
| FeedItem, FeedComment, CollaborationGroup, CollaborationGroupMember, Chatter Object, 협업 | `sObject/6 Standard Objects.md` |
| 표준 Object 목록, Standard Object 이동 목록, Salesforce Object 카탈로그, Object API 이름 | `sObject/6 Standard Objects.md` |
