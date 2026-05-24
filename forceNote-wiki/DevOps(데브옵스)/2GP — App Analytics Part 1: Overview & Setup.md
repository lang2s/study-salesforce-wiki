---
tags: [2GP, AppExchange, AppAnalytics, PackageAnalytics, CustomInteractions, ISV, DevOps]
source: Salesforce Documents/pkg2_dev.pdf
created: 2026-05-24
aliases: [App Analytics Overview, AppExchange App Analytics 개요, 앱 애널리틱스 설정, Custom Interactions 커스텀 인터랙션, IsvPartners.AppAnalytics]
---

# 2GP — App Analytics Part 1: 개요·설정·Custom Interactions

> AppExchange App Analytics는 구독자가 관리 패키지 및 패키지 컴포넌트와 상호작용하는 방식에 대한 사용량 데이터를 제공한다. 이 데이터를 활용해 이탈 위험 식별, 기능 개발 결정, 사용자 경험 개선을 수행한다.

---

## AppExchange App Analytics 개요

AppExchange App Analytics는 구독자가 AppExchange 관리 패키지 및 패키지 컴포넌트와 어떻게 상호작용하는지에 대한 사용량 데이터를 제공한다. 이 세부 정보를 활용해 이탈 위험을 파악하고, 기능 개발 결정을 내리고, 사용자 경험을 개선할 수 있다.

**중요 제약:**
- AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다.
- Government Cloud 및 Government Cloud Plus org의 사용량 데이터는 App Analytics에서 사용 불가.
- App Analytics는 보안 심사를 통과하고 License Management App에 등록된 1세대 및 2세대(1GP, 2GP) 관리 패키지에서 사용 가능.
- 모든 사용량 데이터는 다운로드 가능한 CSV 파일로 제공된다. 대시보드나 시각화 형식으로 보려면 CRM Analytics 또는 서드파티 분석 도구를 사용한다.
- 24시간 기간 내에 최대 20GB의 AppExchange App Analytics 데이터를 다운로드할 수 있다.

**제공되는 데이터 유형:**
- Package Usage Logs (패키지 사용량 로그) — 일별
- Package Usage Summaries (패키지 사용량 요약) — 월별
- Subscriber Snapshots (구독자 스냅샷) — 일별

---

## App Analytics Use Cases (활용 사례)

### 파트너 사용자별 목표 및 App Analytics 활용 방법

| Partner User | Goal | How App Analytics Helps |
|---|---|---|
| Presales Engineer or Account Executive | 훌륭한 고객 체험 제공 및 거래 성사 | 샌드박스·트라이얼 org의 패키지 사용량 로그 제공. 몇 명이 패키지를 트라이얼하고 어떤 기능을 테스트하는지 파악. 구독 가능성 있는 고객에게 맞춤형 추천 제공 |
| Customer Success Representative | 기능 도입 촉진 및 구독자 이탈 최소화 | 3가지 데이터 타입(로그·요약·스냅샷) 제공. 구독자 org 전반의 사용량 파악. 여러 패키지에 걸친 사용자 활동 추적. LMA 라이선스 사용량 데이터와 결합해 제품 도입도 파악 |
| Product Manager | 제품 인사이트 획득 및 로드맵 우선순위 결정 | 전체 구독자 기반의 사용량 데이터 제공. 가장 많이 사용되는 기능 파악, 불완전한 사용자 여정 파악, 사용자 고통점 파악, 예상치 못한 사용 패턴 검증, 거의 사용되지 않는 기능 폐기 결정 |
| Software Engineer | 코드 최적화 | Apex 사용량 데이터 제공. 단독 또는 다른 데이터와 결합해 코드를 더 성능 좋고 안정적으로 최적화 |

**App Analytics에 적합하지 않은 경우:**
- `user_id_token` 기반의 고객 라이선스 사용량 감사는 권장하지 않는다. 패키지를 사용하도록 라이선스 받은 사용자, 간접적으로 상호작용하는 사용자, 자동화 프로세스를 위한 사용량 데이터만 제공.

### App Analytics 데이터를 제품 기능에 매핑

App Analytics 데이터는 `custom_entity` 개념을 중심으로 구성된다. `custom_entity`는 관리 패키지 내 컴포넌트의 개발자 명칭이다.

**예시:** 뉴스레터 구독 관리 기능을 위해 다음 컴포넌트를 추가한 경우:
- `Newsletter_Subscription` (커스텀 오브젝트)
- `SubscriptionPage` (Lightning Page)
- `SubscriptionComponent` (Lightning Component)
- `SubscriptionHandler` (Apex Class)

| Component | Package Usage Log (Daily) | Package Usage Summary (Monthly) | Subscriber Snapshot (Daily) |
|---|---|---|---|
| `Newsletter_Subscription` | Create Read Update Delete (CRUD) 이벤트 | CRUD 이벤트 | 레코드 수 |
| `SubscriptionPage` | Lightning 상호작용 | Lightning 상호작용 | — |
| `SubscriptionComponent` | Lightning 컴포넌트 상호작용 | Lightning 컴포넌트 상호작용 | — |
| `SubscriptionHandler` | Apex 실행 | Apex 실행 | — |

---

## App Analytics 활성화 (2GP 패키지)

### Enable App Analytics on 2GP Managed Package

```bash
# sf CLI: 패키지 업데이트로 App Analytics 활성화
sf package update \
  --package "Your Package Alias" \
  --enable-app-analytics
```

2GP 관리 패키지에서 App Analytics를 활성화하면 패키지 사용량 로그와 구독자 스냅샷에 접근할 수 있다. 패키지 사용량 요약은 기본으로 제공된다.

최신 버전의 Salesforce DX를 사용하고 있는지 확인하려면 `sf update`를 실행한다.

추가 패키지에 App Analytics를 원한다면 동일하게 `sf package update` 명령으로 활성화한다.

### 데이터 타입별 수집 org 종류

| Data Type | 수집 대상 org | 수집 제외 org |
|---|---|---|
| `PackageUsageLog` | Production, Sandbox, Trial orgs | Scratch orgs |
| `PackageUsageSummary` | Production orgs | Sandbox, scratch, trial orgs |
| `SubscriberSnapshot` | Production and trial orgs | Sandbox and scratch orgs |

### Package Usage Logs, Summaries, Subscriber Snapshots 다운로드

`AppAnalyticsQueryRequest` 오브젝트를 사용해 패키지 사용량 로그, 월별 패키지 사용량 요약, 구독자 스냅샷을 요청한다. 사용량 로그, 요약, 스냅샷은 다운로드 가능한 CSV 파일로 제공된다.

```bash
# sf CLI: AppAnalyticsQueryRequest 레코드 생성으로 데이터 요청
sf data create record \
  --sobjecttype AppAnalyticsQueryRequest \
  --values "DataType=PackageUsageLog \
FileType=csv \
FileCompression=gzip \
StartTime=2021-04-01T00:00:00Z \
EndTime=2021-04-02T00:00:00Z \
PackageIds=0336XXXXXXXXXX"
```

절차:
1. 패키지가 등록된 License Management Org(LMO)에 로그인한다.
2. LMO에서 `AppAnalyticsQueryRequest` 오브젝트의 필수 필드를 입력한다.
3. API 요청에서 생성된 App Analytics Query Request 오브젝트를 검색한다. 요청이 완료되면 `DownloadURL` 필드가 채워진다.
4. App Analytics Query Request 오브젝트의 `DownloadURL` 필드의 URL을 클릭하고 .csv 파일을 다운로드한다.

**주의:** 다운로드 URL은 60분 후에 만료된다.

---

## Considerations for Custom Interactions

### 개요

Apex enums과 `IsvPartners.AppAnalytics.logCustomInteraction` Apex 메서드를 사용해 관리 패키지에 커스텀 인터랙션을 쉽게 생성하고 로그할 수 있다. 구독자가 패키지와 상호작용하고 Apex 코드가 실행될 때, 정의한 커스텀 인터랙션이 로그된다. 커스텀 인터랙션은 패키지의 AppExchange App Analytics 사용량 로그 및 사용량 요약에서 검색한다.

**커스텀 인터랙션으로 파악 가능한 것:**
- 사용자가 어떤 앱 기능과 상호작용했는지
- 특정 사용자 여정을 어떻게 흘렀는지
- 사용자가 어떤 UI 컴포넌트와 상호작용했는지

**주요 제한:**
- 커스텀 인터랙션은 단일 사용자 요청에서 최대 50번 나타날 수 있다. 이 제한은 대규모 루프로 인한 로그 범람을 방지한다.
- 루프 내에서 `IsvPartners.AppAnalytics.logCustomInteraction`을 호출하지 않도록 권장한다.
- 실행 중인 Apex 테스트에서 `IsvPartners.AppAnalytics.logCustomInteraction` 메서드가 호출되면 패키지 사용량 로그나 패키지 사용량 요약 데이터가 생성되지 않는다.

### Log Custom Interactions — 구현 절차

1. 패키지된 Apex 코드에서 로그하려는 이벤트와 연결된 Apex enums을 포함한다.
2. Apex 코드에서 생성한 enums를 사용해 `IsvPartners.AppAnalytics.logCustomInteraction`을 호출한다.
3. 개발 환경에서 코드를 실행하고 디버그 로그 레벨이 `Apex Code`에 대해 `FINE`으로 설정되어 있는지 확인해 커스텀 인터랙션이 로그되는지 확인한다.
4. 구현이 완료되면 관리 패키지의 새 버전을 배포한다.
5. 구독자가 패키지를 설치한 후 패키지 사용량 로그와 사용량 요약을 검색한다. `custom_entity_type` 기준으로 `CustomInteractionLabel`, `log_record_type` 기준으로 `CustomInteraction`을 필터링하거나 `custom_entity_type` 기준으로 `CustomInteractionLabel`을 필터링해 패키지 사용량 요약 데이터를 필터링한다.
6. 커스텀 인터랙션 데이터를 분석한다.

### 완전한 커스텀 인터랙션 구현 예제 (LWC + Apex)

구독자의 연락처 목록을 각 Account 레코드에 대해 표시하는 LWC가 있고, 이것이 Apex 클래스와 연결되어 있다고 가정한다. 테이블 레이아웃과 카드 레이아웃을 전환하는 기능을 추적하려면 커스텀 인터랙션을 로그한다.

**LWC HTML 코드:**

```html
<template>
    <div class="slds-var-m-top_medium slds-var-m-bottom_x-large slds-box slds-theme_default">
        <h2 class="slds-text-heading_medium slds-var-m-bottom_medium">Change data view</h2>
        <!-- Button group: simple buttons -->
        <lightning-button-group class="slds-var-m-bottom_medium">
            <lightning-button label="Table" variant={tableVariant} onclick={handleClick}>
            </lightning-button>
            <lightning-button label="Card" variant={cardVariant} onclick={handleClick}>
            </lightning-button>
        </lightning-button-group>
        <template lwc:if={displayTable}>
            <lightning-datatable key-field="id" data={records} columns={columns}>
            </lightning-datatable>
        </template>
        <template lwc:if={displayCard}>
            <div class="slds-grid slds-wrap slds-grid_pull-padded-small">
                <template for:each={records} for:item="contact">
                    <div class="slds-col slds-small-size_1-of-1 slds-large-size_1-of-2 slds-var-p_small"
                         key={contact.id}>
                        <lightning-card variant="Narrow" title={contact.name} icon-name="standard:contact">
                            <div class="slds-var-p-horizontal_small">
                                <p>{contact.name}</p>
                                <p>{contact.title}</p>
                                <p>
                                    <lightning-formatted-phone value={contact.phone}></lightning-formatted-phone>
                                </p>
                                <p>
                                    <lightning-formatted-email value={contact.email}></lightning-formatted-email>
                                </p>
                            </div>
                        </lightning-card>
                    </div>
                </template>
            </div>
        </template>
    </div>
</template>
```

**LWC JavaScript 코드:**

```javascript
import { LightningElement, wire, api } from "lwc";
import { getRelatedListRecords } from "lightning/uiRelatedListApi";
import logInteraction from "@salesforce/apex/LogContactListInteraction.log";

export default class ContactList extends LightningElement {
    @api recordId;
    error;
    records;
    displayTable = true;
    displayCard = false;
    columns = [
        { label: "Name", fieldName: "name" },
        { label: "Title", fieldName: "title" },
        { label: "Email", fieldName: "email", type: "email" },
        { label: "Phone", fieldName: "phone", type: "phone" }
    ];

    @wire(getRelatedListRecords, {
        parentRecordId: "$recordId",
        relatedListId: "Contacts",
        fields: ["Contact.Name", "Contact.Id", "Contact.Phone", "Contact.Email", "Contact.Title"],
        sortBy: ["Contact.Name"]
    })
    contactList({ error, data }) {
        if (data) {
            this.records = data.records.map((item) => {
                return {
                    name: item.fields.Name.value,
                    id: item.fields.Id.value,
                    title: item.fields.Title.value,
                    email: item.fields.Email.value,
                    phone: item.fields.Phone.value
                };
            });
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.records = undefined;
        }
    }

    handleClick(event) {
        if (event.target.label.toLowerCase() === "table") {
            this.displayTable = true;
            this.displayCard = false;
            logInteraction({ type: "table" });
        } else if (event.target.label.toLowerCase() === "card") {
            this.displayTable = false;
            this.displayCard = true;
            logInteraction({ type: "card" });
        }
    }

    get cardVariant() {
        return this.displayCard === true ? "brand" : "";
    }

    get tableVariant() {
        return this.displayTable === true ? "brand" : "";
    }
}
```

**Apex 클래스:**

```apex
public class LogContactListInteraction {
    public Enum ContactListLayouts { TABLE, CARD }

    @AuraEnabled
    public static void log(String type) {
        try {
            IsvPartners.AppAnalytics.logCustomInteraction(getInteractionLabel(type));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    private static ContactListLayouts getInteractionLabel(String type) {
        if (type.toLowerCase() == 'table') {
            return ContactListLayouts.TABLE;
        } else if (type.toLowerCase() == 'card') {
            return ContactListLayouts.CARD;
        }
        return null;
    }
}
```

코드를 테스트할 때, Apex 코드 디버그 로그 레벨을 `FINE`으로 설정하면 커스텀 인터랙션이 `APP_ANALYTICS_FINE`, `APP_ANALYTICS_WARN`, 또는 `APP_ANALYTICS_ERROR`라는 이벤트를 찾아 로그됨을 확인할 수 있다.

```
APP_ANALYTICS_FINE [External]IsvPartners.AppAnalytics.logCustomInteraction was called,
 but not from an installed managed package.
This means that the code is ready to be packaged.
```

---

## 관련 노트
- [[2GP — App Analytics Part 2: Best Practices & Query Strategy]]
- [[2GP — App Analytics Part 3: Data Types & Schemas]]
- [[2GP — App Analytics Part 4: Developer Cookbook]]
- [[2GP — LMA Part 1 Get Started]]
- [[2GP — LMA Part 2 Troubleshoot]]
- [[2GP — Feature Management App]]
- [[2GP Managed Package 개념과 1GP 비교]]
