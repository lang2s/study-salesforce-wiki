---
tags: [sobject-reference, change-event, cdc, change-data-capture, associated-objects, StandardObjectNameChangeEvent]
source: object_reference.pdf p.68-77 (v67.0 Summer '26)
created: 2026-05-22
aliases: [ChangeEvent Objects, CDC, Change Data Capture, StandardObjectNameChangeEvent, AccountChangeEvent, ChangeEventHeader, changeType, changedFields, replayId, schema, 변경 이벤트, 변경감지]
---

# ChangeEvent Objects (StandardObjectNameChangeEvent)

> Change Data Capture(CDC)를 지원하는 각 Object에 자동 생성되는 변경 이벤트 Object. 레코드 생성·수정·삭제·삭제 취소 변경 스트림을 구독해 수신한다.

---

## 핵심 제약

> [!important] ChangeEvent는 Salesforce Object가 아님 — CRUD 작업 및 쿼리 불가. CDC 스트림 구독 전용.

---

## 명명 규칙

```
표준 Object:  <Standard_Object_Name>ChangeEvent
커스텀 Object: <Custom_Object_Name>__ChangeEvent

예: Account      → AccountChangeEvent
    MyObject__c  → MyObject__ChangeEvent
```

---

## 지원 호출

```
describeSObjects()
```

---

## 특수 접근 규칙

- 일부 Object는 Org에서 특정 기능 설정·권한 활성화가 필요
- 각 Object별 특수 접근 규칙은 해당 Object 문서 참조 (예: `AccountChangeEvent` → Account 특수 접근 규칙)

---

## Change Event 지원 범위

- **모든 커스텀 Object:** Change Event 지원
- **표준 Object 일부:** 아래 "CDC 지원 오브젝트 목록" 참조
- **커스텀 Settings:** 부분 지원 — Apex Trigger 미지원, 다른 구독자 유형은 지원

---

## ChangeEvent 필드 구성

### 일반 필드

변경 이벤트가 포함하는 필드는 부모 Object의 필드와 대응된다. 단, 아래 필드는 **포함되지 않는다:**

| 제외 필드 | 이유 |
|---|---|
| `IsDeleted` 시스템 필드 | 변경 이벤트에 포함 안 됨 |
| `SystemModStamp` 시스템 필드 | 변경 이벤트에 포함 안 됨 |
| 레코드에 없고 다른 레코드나 수식에서 파생된 필드 | 예: 수식 필드, LastActivityDate, PhotoUrl. 단, Roll-up Summary 필드는 포함 |

### 이벤트 전용 필드

| 필드 | 설명 |
|---|---|
| `schema` | 이벤트 페이로드에 포함되는 이벤트 스키마 ID |
| `replayId` | 과거 이벤트 재조회(replay)에 사용되는 이벤트 고유 식별자 |

### ChangeEventHeader 필드

모든 변경 이벤트는 `ChangeEventHeader` 필드 안에 아래 헤더를 포함한다:

| 헤더 필드 | 타입 | 설명 |
|---|---|---|
| `entityName` | string | 변경된 Object의 API 이름 (예: `Account`) |
| `recordIds` | string[] | 변경된 레코드 ID 배열 |
| `changeType` | string | 변경 유형: `CREATE`, `UPDATE`, `DELETE`, `UNDELETE` |
| `changeOrigin` | string | 변경 출처. 예: `com/salesforce/api/soap/51.0;client=SfdcInternalAPI/` |
| `transactionKey` | string | 동일 트랜잭션 내 변경 이벤트 묶음 식별자 |
| `sequenceNumber` | int | 트랜잭션 내 이벤트 순서 번호 |
| `commitTimestamp` | long | 변경이 커밋된 시간 (Unix milliseconds) |
| `commitNumber` | long | 커밋 번호 |
| `commitUser` | string | 변경을 수행한 User ID |
| `changedFields` | string[] | UPDATE 이벤트 시 변경된 필드 이름 목록 |

---

## JSON 이벤트 메시지 예제

계정 레코드 생성 시 발생하는 이벤트 메시지 (JSON 형식):

```json
{
  "schema": "IeRuaY6cbI_HsV8Rv1Mc5g",
  "payload": {
    "ChangeEventHeader": {
      "entityName": "Account",
      "recordIds": [
        "<record_ID>"
      ],
      "changeType": "CREATE",
      "changeOrigin": "com/salesforce/api/soap/51.0;client=SfdcInternalAPI/",
      "transactionKey": "0002343d-9d90-e395-ed20-cf416ba652ad",
      "sequenceNumber": 1,
      "commitTimestamp": 1612912679000,
      "commitNumber": 10716283339728,
      "commitUser": "<User_ID>"
    },
    "Name": "Acme",
    "Description": "Everyone is talking about the cloud. But what does it mean?",
    "OwnerId": "<Owner_ID>",
    "CreatedDate": "2021-02-09T23:17:59Z",
    "CreatedById": "<User_ID>",
    "LastModifiedDate": "2021-02-09T23:17:59Z",
    "LastModifiedById": "<User_ID>"
  },
  "event": {
    "replayId": 6
  }
}
```

---

## API 버전과 스키마

- 구독 시 최신 API 버전을 사용하며 수신된 이벤트 메시지는 최신 필드 정의를 반영한다
- 자세한 내용: Change Data Capture Developer Guide의 "API Version and Event Schema"

---

## Apex CDC Trigger 예제

```apex
// Apex Trigger — AccountChangeEvent (after insert)
trigger AccountChangeEventTrigger on AccountChangeEvent (after insert) {
    List<AccountChangeEvent> events = Trigger.new;
    for (AccountChangeEvent event : events) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;

        System.debug('Change Type: ' + header.changeType);
        System.debug('Entity: ' + header.entityName);
        System.debug('Record IDs: ' + header.recordIds);

        if (header.changeType == 'UPDATE') {
            List<String> changedFields = header.changedFields;
            System.debug('Changed Fields: ' + changedFields);

            // 특정 필드 변경 감지
            if (changedFields.contains('AnnualRevenue')) {
                // AnnualRevenue 변경 처리 로직
            }
        }
    }
}
```

---

## CDC 지원 오브젝트 목록 (전수)

아래 Object들은 각각 연관된 ChangeEvent Object를 가진다 (v67.0 Summer '26 기준):

### A

- Account (Person Account 포함)
- AccountCleanInfo
- AccountContactRelation
- AccountContactRole
- ActionCadence
- ActionCadenceStep
- ActionCadenceStepTracker
- ActionCadenceTracker
- AdOrderLineAdTarget
- AdProductTargetCategory
- AdQuoteLineAdTarget
- AdTargetCategory
- AdTargetCategorySegment
- AgentWork
- AgentWorkSkill
- AppExtension
- Asset
- AssetWarranty
- AssetRelationship
- AssignedResource
- AssociatedLocation
- AuthorizationForm
- AuthorizationFormConsent
- AuthorizationFormDataUse
- AuthorizationFormText
- Automotive Cloud: 일부 Object 지원. Automotive Cloud Developer Guide의 StandardObjectNameChangeEvent 참조

### B

- BriefcaseAssignment
- BriefcaseDefinition
- BroadcastTopicNetwork
- BusinessBrand

### C

- CalendarView
- CallTemplate
- Campaign
- CampaignMember
- CampaignMemberStatus
- CartDeliveryGroup
- CartItem
- CartItemPriceAdjustment
- CartTax
- CartValidationOutput
- Case
- CaseRelatedIssue
- ChangeRequest
- ChangeRequestRelatedIssue
- ChangeRequestRelatedItem
- CollaborationGroupRecord
- CollabTemplateMetric
- CommerceEntitlementBuyerGroup
- CommerceEntitlementPolicy
- CommerceEntitlementProduct
- CommSubscription
- CommSubscriptionChannelType
- CommSubscriptionConsent
- CommSubscriptionTiming
- ConferenceNumber
- Consumer Goods Cloud: 일부 Object 지원. Consumer Goods Cloud Developer Guide의 StandardObjectNameChangeEvent 참조
- Contact
- ContactCleanInfo
- ContentDocument
- ContentDocumentLink
- ContentFolder
- ContactPointAddress
- ContactPointConsent
- ContactPointEmail
- ContactPointPhone
- ContactPointTypeConsent
- ContentVersion
- Contract
- ContractLineItem
- Conversation Reason objects: ConversationContextEntry, ConversationReason, ConversationReasonExcerpt, ConversationReasonGroup. Einstein Conversation Insights in Salesforce Help 참조
- Coupon
- CustomFieldDisplayValue

### D

- DataUseLegalBasis
- DataUsePurpose
- DigitalSignature
- DynamicDataCapture

### E

- EmailMessage
- EmailTemplate
- EngagementAttendee
- EngagementChannelType
- EngagementInteraction
- EngagementTopic
- Entitlement
- Event
- EventRelation
- Expense
- ExternalClientAppSettings
- ExternalEvent

### F

- FieldServiceMobileSettings
- Financial Services Cloud: 일부 Object 지원. Salesforce Health Cloud Developer Guide의 StandardObjectNameChangeEvent 참조
- FlowRecord
- FlowRecordElement
- FlowRecordVersion
- FlowOrchestration
- FlowOrchestrationVersion
- ForecastingOwnerAdjustment
- FulfillmentOrderItemTax

### H

- Health Cloud: 일부 Object 지원. Salesforce Health Cloud Developer Guide의 StandardObjectNameChangeEvent 참조

### I

- Incident Related Item
- Individual

### L

- LandingPage
- Lead
- LinkedArticle
- ListEmail
- LiveAgentSession
- LiveChatTranscript
- LiveChatTranscriptEvent
- LiveChatVisitor
- Location
- LocationGroup
- LocationGroupAssignment
- Loyalty Management: 일부 Object 지원. Loyalty Management Developer Guide의 StandardObjectNameChangeEvent 참조

### M

- Macro
- MacroInstruction
- MaintenanceAsset
- MaintenancePlan
- ManagedContent
- Manufacturing Cloud: 일부 Object 지원. Manufacturing Cloud Developer Guide의 StandardObjectNameChangeEvent 참조
- MarketingForm
- MarketingLink
- MarketSegmentActivation
- MerchantAccount
- MessagingEndUser
- MessagingSession
- Mortgage loan applicant and application objects. Financial Services Cloud Administrator Guide 참조

### N

- Net Zero Cloud: 일부 Object 지원. Net Zero Cloud Developer Guide의 StandardObjectNameChangeEvent 참조
- Nonprofit Cloud: 일부 Object 지원. Nonprofit Cloud Developer Guide의 StandardObjectNameChangeEvent 참조

### O

- ObjectDataImport
- ObjectRelatedUrl
- OperatingHours
- Opportunity
- OpportunityContactRole
- OpportunityLineItem
- OpportunitySplit
- Order
- OrderAdjustmentGroupSummary
- OrderDeliveryGroupSummary
- OrderDeliveryMethod
- OrderItem
- OrderItemSummary
- OrderItemSummaryChange
- OrderItemTaxLineItemSummary
- OrderPaymentSummary
- OrderSummary

### P

- PartyConsent
- PaymentPage
- PendingServiceRouting
- Pricebook2
- PricebookEntry
- ProblemIncident
- ProblemRelatedItem
- ProcessException
- ProcessInstance
- ProcessInstanceStep
- Product2
- ProductCategory
- ProductConsumed
- ProductFeaturedProduct
- ProductItem
- ProductMedia
- ProductRequest
- ProductRequestLineItem
- ProductTransfer
- ProductWarrantyTerm
- ProfileSkillEndorsement
- Public Sector Solutions: 일부 Object 지원. Public Sector Solutions Developer Guide의 StandardObjectNameChangeEvent 참조

### Q

- QuickText
- QuickTextUsage
- Quote
- QuoteLineItem

### R

- Recommendation
- RecordAggregationResult
- RecordSetFilterCriteria
- RecordSetFilterCriteriaRule
- ResourceAbsence
- ResourcePreference
- ReturnOrder
- ReturnOrderItemAdjustment
- ReturnOrderItemTax
- ReturnOrderLineItem

### S

- SalesChannel
- ServiceAppointment
- ServiceContract
- ServiceCrew
- ServiceCrewMember
- ServiceResource
- ServiceResourceCapacity
- ServiceResourceSkill
- ServiceReport
- ServiceReportLayout
- ServiceTerritory
- ServiceTerritoryLocation
- ServiceTerritoryMember
- Shift
- ShiftPattern
- ShiftPatternEntry
- Shipment
- SkillRequirement
- SocialPost
- Survey
- SurveyInvitation
- SurveyPage
- SurveyQuestion
- SurveyQuestionChoice
- SurveyQuestionResponse
- SurveyResponse
- SurveySubject
- SurveyVersion

### T

- Task
- TenantEntitlementTransaction
- TenantSecurityAlertRuleSelectedTenant
- TenantSecurityApiAnomaly
- TenantSecurityConnectedApp
- TenantSecurityCredentialStuffing
- TenantSecurityFeature
- TenantSecurityHealthCheckBaselineTrend
- TenantSecurityHealthCheckData
- TenantSecurityHealthCheckTrend
- TenantSecurityTenantInfo
- TenantSecurityLicense
- TenantSecurityLogin
- TenantSecurityLoginIpRangeTrend
- TenantSecurityMobilePolicyTrend
- TenantSecurityMonitorMetric
- TenantSecurityNotification
- TenantSecurityNotificationRule
- TenantSecurityPackage
- TenantSecurityPolicy
- TenantSecurityPolicyDeployment
- TenantSecurityPolicySelectedTenant
- TenantSecurityReportAnomaly
- TenantSecuritySessionHijacking
- TenantSecurityTransactionPolicyTrend
- TenantSecurityTrustedIpRangeTrend
- TenantSecurityUserAcitivity
- TenantSecurityUserPerm
- TenantUsageTypeMultiplier
- Territory2AlignmentLog
- Territory2Model
- TimeSheet
- TimeSheetEntry
- TimeSlot
- TodayGoal
- TaskRelation

### U

- User (partner user 포함)
- UserAppInfo
- UserEmailPreferredPerson
- UserServicePresence

### V

- VideoCall
- VideoCallParticipant
- VideoCallRecording
- VoiceCall
- VoiceCallRecording

### W

- WarrantyTerm
- WaveAutoInstallRequest
- WebCart
- WebCartAdjustmentBasis
- WebCartAdjustmentGroup
- WebStore
- WebStoreBuyerGroup
- WebStoreSearchProdSettings
- WorkAccess
- WorkBadge
- WorkBadgeDefinition
- WorkCapacityLimit
- WorkOrder
- WorkOrderLineItem
- WorkPlan
- WorkThanks
- WorkType

---

## 관련 노트

- [[3 Associated Objects]] — Feed·History·Share·OwnerSharingRule·ChangeEvent 패턴 개요
- [[ChangeEventHeader]] — ChangeEventHeader 클래스 상세 (Apex EventBus 네임스페이스)
- [[Platform Event 발행]] — EventBus 이벤트 버스 관련
- [[EventBus Namespace]] — EventBus Namespace 전체 API
- [[Feed Objects]] — 피드 연관 Object
- [[Share Objects]] — 공유 연관 Object
