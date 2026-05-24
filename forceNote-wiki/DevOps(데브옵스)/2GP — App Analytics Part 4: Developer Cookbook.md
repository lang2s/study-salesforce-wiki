---
tags: [2GP, AppExchange, AppAnalytics, CRMAnalytics, SAQL, DeveloperCookbook, KPI, ISV, DevOps]
source: Salesforce Documents/pkg2_dev.pdf
created: 2026-05-24
aliases: [App Analytics Developer Cookbook, CRM Analytics Recipes, App Analytics Recipes, SAQL, DailyAggregation, LMAJoin, CustomerSuccess Recipes, Custom Object Usage Recipes, Daily Unique Users]
---

# 2GP — App Analytics Part 4: Developer Cookbook

> AppExchange App Analytics 관리 패키지 사용량 데이터를 분석하기 위한 KPI(핵심 성과 지표)를 생성하는 CRM Analytics 레시피와 App Analytics 레시피를 단계별로 구현한다.

---

## AppExchange App Analytics Developer Cookbook 개요

AppExchange App Analytics Developer Cookbook은 CRM Analytics 레시피와 App Analytics 레시피를 구축해 관리 패키지 사용량 데이터를 심층 분석하기 위한 KPI를 생성하는 방법을 설명한다.

**두 가지 레시피 유형:**
- **CRM Analytics Recipes** — App Analytics 레시피 환경을 설정하는 기반 작업. CRM Analytics 레시피는 여러 소스의 데이터를 결합하는 데 유용한 dataflows와 단일 데이터셋에 대한 변환을 수행하는 CRM Analytics 레시피로 구성된다. 이 CRM Analytics 레시피들은 App Analytics 레시피를 생성하기 전에 완료해야 한다.
- **App Analytics Recipes** — CRM Analytics 레시피 분석 환경 위에 구축되어 KPI를 생성하는 CRM Analytics 렌즈 공식. CRM Analytics 대시보드를 사용해 KPI를 시각화하고 더 깊은 인사이트를 얻는다.

**Note:** AppExchange App Analytics는 AppExchange Program Policies에 설명된 특정 사용량 제한이 적용된다. App Analytics 레시피를 사용하려면 보안 심사를 통과한 관리 패키지에서 App Analytics를 활성화해야 한다.

---

## Before You Begin (사전 준비)

App Analytics 레시피를 생성하기 전에 다음 필수 조건을 완료한다:

1. **License Management Org(LMO)** — LMO가 있어야 한다. 모든 Salesforce 구독자를 추적하는 LMA가 관리 패키지와 연결된 LMO가 있어야 한다.

2. **CRM Analytics 앱 설치** — Analytics Studio에서 두 개의 CRM Analytics 앱을 생성한다: LMAJoin과 DailyAggregation 레시피를 포함하는 LMO 앱, App Analytics 레시피를 포함하는 PartnerIntelligence 앱.

3. **CRM Analytics 레시피 환경 설정** — App Analytics 레시피를 생성하기 전에 CRM Analytics 레시피 환경을 설정한다. 먼저 country-codes 데이터셋을 생성하고, LMA 데이터와의 SFDC_Local 연결을 만들고, LMAJoin CRM Analytics 레시피를 생성한다.

4. **App Analytics 데이터셋 생성** — `RawPackageLogFile.csv` 파일을 사용해 App Analytics 데이터셋을 생성한다.

5. **DailyAggregation CRM Analytics 레시피 생성** — 원시 패키지 로그 파일 데이터를 LMA 데이터와 결합해 App Analytics 레시피에 사용할 DailyAggregation이라는 데이터셋을 생성한다.

**도움이 필요한 경우:** 솔루션 설정에 도움이 필요하면 Salesforce 파트너 커뮤니티에서 Platform Expert와의 상담을 요청할 수 있다.

---

## CRM Analytics Recipes

App Analytics 레시피 환경을 설정하기 위해 CRM Analytics 레시피를 구축한다.

### 1. Create the Country-Codes Dataset (국가 코드 데이터셋 생성)

LMA 국가 코드 데이터를 CRM Analytics 국가 코드 형식으로 정규화해 지도 형식의 국가 기반 데이터 시각화를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. `country-codes.csv`를 클릭해 표준화된 국가 코드 데이터를 다운로드한다.
2. Raw를 마우스 오른쪽 클릭하고 **Save Link As**를 클릭한다.
3. 파일명을 `country-codes.txt`로 지정하고 데스크톱에 저장한다.
4. Analytics Studio in CRM Analytics에서 **Create**를 클릭한다.
5. **Dataset**을 클릭한다.
6. **CSV File**을 클릭한다.
7. `country-codes.txt` 파일을 선택한다.
8. **Next**를 클릭한다.
9. 데이터셋 이름을 `country-codes`로 지정한다.
10. **PartnerIntelligence** 앱을 선택한다.
11. **Next**를 클릭한다.
12. **Upload File**을 클릭한다.

### 2. Connect to Your License Management App Data (LMA 데이터 연결)

LMA(License Management App) 데이터에 대한 SFDC_Local 연결을 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Connect**를 클릭한다.
3. **Connect to Data**를 클릭한다.
4. **SFDC_LOCAL**을 클릭한다.
5. **Account**를 클릭한다.
6. **Continue**를 클릭한다.
7. 모든 필드를 선택한다.
8. **Continue**를 클릭한다.
9. **Save**를 클릭한다.
10. 다음 오브젝트에 연결하기 위해 2~8단계를 반복한다: **Lead**, **sfLma__License__c**, **sfLma__Package__c**, **sfLma__Package_Version__c**
11. Account 옆에서 아래 화살표를 클릭한다.
12. **Run Data Sync**를 클릭한다.
13. Connect 창에서 이 오브젝트들에 대해 11단계를 반복한다: **Lead**, **sfLma__License__c**, **sfLma__Package__c**, **sfLma__Package_Version__c**

### 3. Create the LMAJoin CRM Analytics Recipe (LMAJoin 레시피 생성)

LMA(License Management App) 데이터가 포함된 CRM Analytics 레시피를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. Recipes 탭의 **Dataflows & Recipes**에서 **Create Recipe**를 클릭한다.
3. **Add Input Data**를 클릭한다.
4. **sfLma__License__c**를 선택하고 모든 열을 선택한다.
5. `License`로 명명된 변환을 다음 사양으로 생성한다:
   - Custom Formula: `string(Id)`
   - Output Type: **Text**
   - Length: `255`
   - Default Value: `blank`
   - Show Results In: **New Column (and Keep Original)**
   - Column Label: `LicenseRecordId`
6. Lead에 대한 조인을 다음 사양으로 추가한다:
   - Select Input Data to Join: **Lead**
   - Columns to Select: **Company, First Name, Id, Last Name**
   - Join Type: **Lookup**
   - Join Keys: **License: Record ID = Lead ID**
   - API Name Prefix for Right Columns: `Lead`
7. Account에 대한 조인을 다음 사양으로 추가한다:
   - Select Input Data to Join: **Account**
   - Columns to Select: **Name**
   - Join Type: **Lookup**
   - Join Keys: **Account Name = Account Name**
   - API Name Prefix for Right Columns: `Account`
8. **sfLma__Package__c**에 대한 조인을 다음 사양으로 추가한다:
   - Select Input Data to Join: **sfLma__Package__c**
   - Columns to Select: **All fields**
   - Join Type: **Lookup**
   - Join Keys: **Package = Record ID**
   - API Name Prefix for Right Columns: `Package`
9. 조인과 **sfLma__Package__c** 사이에 변환을 생성한다:
   - Custom Formula: `substr(sfLma__Package_ID__c, 1, 15)`
   - Output Type: **Text**
   - Length: `255`
   - Default Value: none
   - Show Results In: **New Column (and Keep Original)**
   - Column Label: `PackageID15`
10. 다음 사양으로 또 다른 조인을 생성한다:
    - Select Input Data to Join: **sfLma__Package_Verzion__c**
    - Columns to Select: **All fields**
    - Join Type: **Lookup**
    - Join Keys: **Package Version = Record ID**
    - API Name Prefix for Right Columns: `PackageVersion`
11. 다음 사양으로 출력을 생성한다:
    - Write To: **Dataset**
    - Dataset Display Label: `LMAJoin`
    - App Location: **PartnerIntelligence**
    - Sharing Source: default
    - Security Predicate: **Apply row-level security to the target dataset by adding a predicate filter condition**
12. **Apply**를 클릭한다.
13. **Save**를 클릭한다.
14. 레시피를 `LMAJoin`으로 저장한다.
15. **Save and Run**을 클릭한다.
16. 작업 상태를 모니터링하려면 **Go to Data Monitor**를 클릭한다.

#### Monitor the LMAJoin CRM Analytics Recipe

CRM Analytics 레시피는 완료하는 데 시간이 걸릴 수 있다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Monitor**를 클릭한다.
3. Jobs 탭에서 LMAJoin 작업을 찾는다.
4. 작업이 Successful이면 **Data**를 클릭해 완료된 LMAJoin 데이터셋을 본다.

#### Run the LMAJoin CRM Analytics Recipe

재사용 가능한 데이터셋을 생성하려면 LMAJoin CRM Analytics 레시피를 정기적으로 실행하도록 예약한다. 매일 자정에 실행하는 것을 권장한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Dataflows & Recipes**를 클릭한다.
3. **Recipes** 탭을 클릭한다.
4. LMAJoin CRM Analytics 레시피 옆에서 화살표를 클릭한다.
5. **Schedule**을 클릭하고 일정을 설정한다.

### 4. Create Your App Analytics Dataset (App Analytics 데이터셋 생성)

`RawPackageLogFile.csv` 파일을 사용해 App Analytics 데이터셋을 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Create**를 클릭하고 **Dataset**을 선택한다.
2. **CSV File**을 선택하고 `RawPackageLogFile.csv` 파일을 선택한다.
3. **Next**를 클릭한다.
4. 데이터셋 이름을 `RawpackageLogFile`로 지정하고 **PartnerIntelligence** 앱을 선택한다.
5. **Next**를 클릭한다.
6. `event_count`, `num_fields`, `num_soql_queries`, `operation_count`, `rows_processed` 필드의 경우 필드 타입을 **Dimension**에서 **Measure**로 변경하고 다음 사양을 추가한다:
   - Default value: `0`
   - Scale: `0`
   - Precision: `18`
7. `timestamp_derived`를 검색하고 필드 타입이 **Date**인지 확인한다.
8. **Upload File**을 클릭한다.

### 5. Create Your DailyAggregation CRM Analytics Recipe (DailyAggregation 레시피 생성)

원시 패키지 로그 파일 데이터를 LMA(License Management App) 데이터와 결합해 DailyAggregation이라는 데이터셋을 생성하는 CRM Analytics 레시피. 이 데이터셋을 사용해 App Analytics 레시피를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Dataflows & Recipes**를 클릭한다.
3. Recipes 탭에서 **Create Recipe**를 클릭한다.
4. **Add Input Data**를 클릭한다.
5. **RawPackageLogFile**을 선택한다.
6. 모든 열을 선택한다.
7. 다음 사양으로 집계를 생성한다:

| Field | Aggregate By |
|---|---|
| `event_count` | Sum |
| `login_key` | Unique |
| `num_fields` | Sum |
| `num_soql_queries` | Sum |
| `operation_count` | Sum |
| `rows_processed` | Sum |
| `session_key` | Unique |

8. 집계의 Group Rows에서 **+**를 클릭하고 `timestamp_derived`를 선택한다:
   a. **Year**, **Month**, **Day**를 선택한다.
   b. **Add**를 클릭한다.
9. 집계의 Group Rows에서 다음 각 필드에 대한 그룹을 생성한다:
   - `api_type`, `api_version`, `app_name`, `class_name`, `cloned_from_organization`, `custom_entity`, `custom_entity_type`, `entry_point`, `event`, `event_subscriber`, `http_method`, `http_status_code`, `log_record_type`, `managed_package_namespace`, `method_name`, `operation_type`, `organization_country_code`
10. `Create DMY Field`라는 이름의 변환을 다음 공식으로 생성한다:
    ```
    to_date(concat(timestamp_derived_DAY,"/",timestamp_derived_MONTH,"/",timestamp_derived_YEAR),"dd/MM/yyyy")
    ```
11. RawPackageLogFile 데이터셋을 LMAData 데이터셋에 다음 정보로 조인한다:
    - Select Input Data to Join: **LMAData**
    - Columns to Select: **All fields**
    - Join Type: **Lookup**
    - Join Keys: **organization_id = Subscriber Org ID** and **package_id = PackageID15**
    - API Name Prefix for Right Columns: `LMAData`
12. country-codes 데이터셋을 LMAData 데이터셋에 다음 정보로 조인한다:
    - Select Input Data to Join: **country-codes**
    - Columns to Select: **All fields**
    - Join Type: **Lookup**
    - Join Keys: **user_country_code = ISO3166-1-Alpha-2**
    - API Name Prefix for Right Columns: `UserCountry`
13. `Feature Name`이라는 변환을 생성한다:
    a. Inventory, Orders 등 기능마다 CRM Analytics 버킷을 생성하고, 기타 catch-all 버킷도 생성한다.
    b. **Note:** CRM Analytics 버킷은 데이터를 그룹화하는 카테고리이다. 각 기능에 대한 CRM Analytics 버킷을 생성하고 해당 기능과 관련된 커스텀 오브젝트, 페이지, Lightning 컴포넌트, Apex 클래스를 해당 버킷에 추가한다.
    커스텀 엔티티를 적절한 버킷에 추가한다.
14. 다음 사양으로 **Output**을 선택한다:
    - Write To: **Dataset**
    - Dataset Display Label: `DailyAggregation`
    - App Location: **PartnerIntelligence**
    - Sharing Source: default
    - Security Predicate: **Apply row-level security to the target dataset by adding a predicate filter condition**
    - Name: `Create Daily Aggregation Dataset`
15. **Apply**를 클릭한다.
16. **Save**를 클릭한다.
17. 레시피를 `DailyAggregation`으로 명명한다.
18. **Save and Run**을 클릭한다.

#### Monitor the DailyAggregation CRM Analytics Recipe

CRM Analytics 레시피는 완료하는 데 시간이 걸릴 수 있다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Monitor**를 클릭한다.
3. Jobs 탭에서 DailyAggregation 작업을 찾는다.
4. 작업이 Successful이면 **Data**를 클릭해 완료된 DailyAggregation 데이터셋을 본다.

#### Run the DailyAggregation CRM Analytics Recipe

재사용 가능한 데이터셋을 생성하려면 DailyAggregation CRM Analytics 레시피를 정기적으로 실행하도록 예약한다. 매일 자정에 실행하는 것을 권장한다.

org의 Analytics Studio in CRM Analytics에서:
1. **Data Manager**를 클릭한다.
2. **Dataflows & Recipes**를 클릭한다.
3. **Recipes** 탭을 클릭한다.
4. DailyAggregation CRM Analytics 레시피 옆에서 화살표를 클릭한다.
5. **Schedule**을 클릭하고 일정을 설정한다.

---

## App Analytics Recipes

고객이 관리 패키지 및 컴포넌트를 어떻게 사용하는지 이해하기 위해 App Analytics 레시피를 생성한다. 각 App Analytics 레시피는 CRM Analytics 렌즈를 생성하며 KPI의 핵심이다. CRM Analytics 대시보드를 사용해 KPI를 시각화하고 더 깊은 인사이트를 얻는다.

**Note:** App Analytics 레시피를 사용하려면 보안 심사를 통과한 관리 패키지에서 App Analytics를 활성화해야 한다. 패키지 사용량 로그 및 구독자 스냅샷을 요청하고 검색하기 위해 Salesforce 파트너 커뮤니티에서 지원 케이스를 로깅해 App Analytics를 활성화한다. 제품에 **Partner Programs & Benefits**를 지정한다. 주제에 **ISV Technology Request**를 지정한다. 활성화 없이 패키지 사용량 요약에 접근할 수 있다.

**예시:** 일별 및 월별 활성 사용자 메트릭을 구축하려면, Daily 및 Monthly Active User App Analytics 레시피를 구축한다.

---

## Customer Success Recipes (고객 성공 레시피)

고객 성공은 관리 패키지를 사용하는 동안 고객이 원하는 결과를 달성하도록 보장하는 관계 중심 방법이다.

측정할 수 있는 메트릭: Overall managed package usage, Depth of managed package usage, Growth, Length of time as a customer, Number of renewals, Number of upsells, Overall relationship

사용자 행동을 분석하기 위해 사용자 관련 및 CRUD App Analytics 데이터 필드를 사용해 메트릭을 계산한다. 모든 사용자 행동 계산은 고유 사용자 정의 방식에 의존한다:
- 관리 패키지와 그 컴포넌트를 사용한 개인
- 하루, 한 달, 1년과 같은 특정 기간 동안 측정됨

활성 사용자는 다음으로 정의할 수 있다: CRUD 활동, 페이지 뷰, Lightning 상호작용과 같은 특정 기간 동안 어떤 유형의 패키지 사용량을 로그한 사용자. 일, 월, 분기와 같은 기간별로 고유 및 활성 사용자를 세분화한다.

### Create a Daily Unique Users Recipe (일별 고유 사용자 레시피)

이 레시피는 일별 고유 사용자 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. Datasets 탭의 모든 항목에서 DailyAggregation 데이터셋을 선택한다.
2. Bar Length에서 **Count of Rows**를 클릭한다.
3. **Unique**를 클릭한다.
4. **user_id_token**을 선택한다.
5. **Charts**를 선택한다.
6. **Column**을 클릭한다.
7. Bars에서 **+**를 클릭하고 `timestamp_DMY`를 검색한다.
8. **Year-Month-Day**를 선택한다.
9. **Save**를 클릭한다.
10. 렌즈를 `Daily Unique Users`로 명명한다.
11. **PartnerIntelligence** 앱을 선택한다.
12. **Save**를 클릭한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Month', 'timestamp_derived_DAY_formula_Day');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Month' + "~~~" + 'timestamp_derived_DAY_formula_Day'
as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day',
 unique('user_id_token') as 'unique_user_id_token';
q = order q by
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day'
 asc;
q = limit q 2000;
```

### Create a Weekly Unique Users Recipe (주별 고유 사용자 레시피)

이 레시피는 주별 고유 사용자 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. Datasets 탭의 모든 항목에서 DailyAggregation 데이터셋을 선택한다.
2. Bar Length에서 **Count of Rows**를 클릭한다.
3. **Unique**를 클릭한다.
4. **user_id_token**을 선택한다.
5. **Charts**를 선택한다.
6. **Column**을 클릭한다.
7. Bars에서 **+**를 클릭하고 `timestamp_DMY`를 검색한다.
8. **Year-Week**를 선택한다.
9. **Save**를 클릭한다.
10. 렌즈를 `Weekly Unique Users`로 명명한다.
11. **PartnerIntelligence** 앱을 선택한다.
12. **Save**를 클릭한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Week');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Week' as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Week',
unique('user_id_token') as 'unique_user_id_token';
q = order q by 'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Week'
 asc;
q = limit q 2000;
```

### Create a Monthly Unique Users Recipe (월별 고유 사용자 레시피)

이 레시피는 월별 고유 사용자 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. Datasets 탭의 모든 항목에서 DailyAggregation 데이터셋을 선택한다.
2. Bar Length에서 **Count of Rows**를 클릭한다.
3. **Unique**를 클릭한다.
4. **user_id_token**을 선택한다.
5. **Charts**를 선택한다.
6. **Column**을 클릭한다.
7. Bars에서 **+**를 클릭하고 `timestamp_DMY`를 검색한다.
8. **Year-Month**를 선택한다.
9. **Save**를 클릭한다.
10. 렌즈를 `Monthly Unique Users`로 명명한다.
11. **PartnerIntelligence** 앱을 선택한다.
12. **Save**를 클릭한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Month');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Month' as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month',
unique('user_id_token') as 'unique_user_id_token';
q = order q by 'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month'
 asc;
q = limit q 2000;
```

---

## Custom Object Usage Recipes (커스텀 오브젝트 사용량 레시피)

고객이 커스텀 오브젝트를 어떻게 사용하는지 이해하는 것은 관리 패키지와 커스텀 오브젝트의 수명주기를 관리하는 데 중요하다. create, read, update, delete(CRUD) 작업으로 커스텀 오브젝트 사용량을 측정한다.

### Create a Custom Object Creates Per Day Recipe (일별 커스텀 오브젝트 생성 레시피)

이 레시피는 일별로 커스텀 오브젝트가 생성된 횟수의 고유 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서:
1. Datasets 탭의 모든 항목에서 DailyAggregation 데이터셋을 선택한다.
2. **Charts**를 선택한다.
3. **Column**을 클릭하고 Bar Length를 **Count of Rows**로 남긴다.
4. Bars에서 **+**를 클릭하고 `timestamp_DMY`를 검색한다.
5. **Year-Month-Day**를 선택한다.
6. **Filters**를 클릭한다.
7. **+**를 클릭한다.
8. **custom_entity_type**이 **CustomObject**인 것을 선택한다.
9. **Apply**를 클릭한다.
10. **+**를 클릭한다.
11. **operation_type**이 **INSERT**인 것을 선택한다.
12. **Apply**를 클릭한다.
13. **Data** 탭을 클릭한다.
14. Trellis에서 **+**를 클릭한다.
15. **custom_entity**를 선택한다.
16. **Save**를 클릭한다.
17. 렌즈를 `Custom Object Creates Per Day`로 명명한다.
18. **PartnerIntelligence** 앱을 선택한다.
19. **Save**를 클릭한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = filter q by 'custom_entity_type' == "CustomObject";
q = filter q by 'operation_type' == "INSERT";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Month', 'timestamp_derived_DAY_formula_Day',
'custom_entity');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Month' + "~~~" + 'timestamp_derived_DAY_formula_Day'
as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day',
 'custom_entity' as 'custom_entity', count() as 'count';
q = order q by
('timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day'
 asc, 'custom_entity' asc);
q = limit q 2000;
```

### Create a Custom Object Updates Per Day Recipe (일별 커스텀 오브젝트 업데이트 레시피)

이 레시피는 일별로 커스텀 오브젝트가 업데이트된 횟수의 고유 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서 (Custom Object Creates Per Day와 동일한 단계이지만 11단계에서):
- **operation_type**이 **UPDATE**인 것을 선택한다.
- 렌즈를 `Custom Object Updates Per Day`로 명명한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = filter q by 'custom_entity_type' == "CustomObject";
q = filter q by 'operation_type' == "UPDATE";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Month', 'timestamp_derived_DAY_formula_Day',
'custom_entity');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Month' + "~~~" + 'timestamp_derived_DAY_formula_Day'
as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day',
 'custom_entity' as 'custom_entity', count() as 'count';
q = order q by
('timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day'
 asc, 'custom_entity' asc);
q = limit q 2000;
```

### Create a Custom Object Reads Per Day Recipe (일별 커스텀 오브젝트 읽기 레시피)

이 레시피는 일별로 커스텀 오브젝트가 읽힌 횟수의 고유 수를 생성한다.

org의 Analytics Studio in CRM Analytics에서 (Custom Object Creates Per Day와 동일한 단계이지만 11단계에서):
- **operation_type**이 **READ**인 것을 선택한다.
- 렌즈를 `Custom Object Reads Per Day`로 명명한다.

**SAQL:**

```saql
q = load "DailyAggregation";
q = filter q by 'custom_entity_type' == "CustomObject";
q = filter q by 'operation_type' == "READ";
q = group q by ('timestamp_derived_DAY_formula_Year',
'timestamp_derived_DAY_formula_Month', 'timestamp_derived_DAY_formula_Day',
'custom_entity');
q = foreach q generate 'timestamp_derived_DAY_formula_Year' + "~~~" +
'timestamp_derived_DAY_formula_Month' + "~~~" + 'timestamp_derived_DAY_formula_Day'
as
'timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day',
 'custom_entity' as 'custom_entity', count() as 'count';
q = order q by
('timestamp_derived_DAY_formula_Year~~~timestamp_derived_DAY_formula_Month~~~timestamp_derived_DAY_formula_Day'
 asc, 'custom_entity' asc);
q = limit q 2000;
```

---

## 관련 노트
- [[2GP — App Analytics Part 1: Overview & Setup]]
- [[2GP — App Analytics Part 2: Best Practices & Query Strategy]]
- [[2GP — App Analytics Part 3: Data Types & Schemas]]
- [[2GP — LMA Part 1 Get Started]]
- [[2GP — LMA Part 2 Troubleshoot]]
