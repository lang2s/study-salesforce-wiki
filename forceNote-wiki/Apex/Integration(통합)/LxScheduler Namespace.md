---
tags: [apex, lxscheduler, scheduler, namespace, reference, field-service]
source: salesforce_apex_reference_guide.pdf (v67.0, Summer '26) p.2980-3022
created: 2026-05-20
aliases: [LxScheduler, LxScheduler 네임스페이스, Salesforce Scheduler Apex, 스케줄러 네임스페이스, 서비스 리소스 스케줄, 예약 후보 리소스]
---

# LxScheduler Namespace

> Salesforce Scheduler와 외부 캘린더를 연동하는 인터페이스와 클래스를 제공하는 네임스페이스. 서비스 리소스의 예약 가능 후보/슬롯 조회와, 외부 시스템의 예약 불가 시간을 반영하는 두 가지 흐름을 담당한다.

---

## 개요

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `GetAppointmentCandidatesInput` | 후보 리소스 조회 요청 데이터 (Builder 경유 생성) |
| `GetAppointmentCandidatesInputBuilder` | `GetAppointmentCandidatesInput` 빌더 (13개 set* 메서드) |
| `GetAppointmentSlotsInput` | 타임슬롯 조회 요청 데이터 (Builder 경유 생성) |
| `GetAppointmentSlotsInputBuilder` | `GetAppointmentSlotsInput` 빌더 (13개 set* 메서드) |
| `SchedulerResources` | 리소스 가용성 비즈니스 로직 진입점 — static 메서드 4개 |
| `SkillRequirement` | 작업 완료에 필요한 스킬 데이터 (Builder 경유 생성) |
| `SkillRequirementBuilder` | `SkillRequirement` 빌더 |
| `WorkType` | 수행할 작업 유형 데이터 (Builder 경유 생성) |
| `WorkTypeBuilder` | `WorkType` 빌더 (8개 set* 메서드) |
| `ServiceResourceScheduleHandler` | 외부 캘린더 예약 불가 슬롯 조회 **인터페이스** |
| `ServiceAppointmentRequestInfo` | `ServiceResourceScheduleHandler`에 전달되는 요청 파라미터 |
| `ServiceResourceInfo` | 서비스 리소스 정보 데이터 클래스 |
| `ServiceResourceSchedule` | 핸들러 구현 결과 반환 클래스 |
| `UnavailableTimeslot` | 예약 불가 시간대 데이터 (timeMin / timeMax) |

> **두 가지 흐름**: ① `getAppointmentCandidates` — 어떤 리소스가 가능한가? (후보 리소스 목록) ② `getAppointmentSlots` — 특정 리소스가 언제 가능한가? (타임슬롯 목록)

---

## GetAppointmentCandidatesInput Class

서비스 영역과 작업 유형 그룹 기반으로 예약 후보 리소스를 조회하는 입력 데이터 클래스. **직접 인스턴스화 불가** — `GetAppointmentCandidatesInputBuilder.build()`로 생성.

**Namespace:** LxScheduler

> **가용성 결정 요소**
> - Resource Availability: 서비스 영역 멤버, 작업 유형, 계정 운영시간 필드
> - Resource Unavailability: 결석, 기존 예약(Closed/Canceled/Completed 외 상태)
> - Appointment Start Time Interval: Scheduling Policy 설정 (5/10/15/20/30/60분, 기본 15분)
> - Work Type Duration: 종료시간 = 시작시간 + duration

---

## GetAppointmentCandidatesInputBuilder Class

`lxscheduler.GetAppointmentCandidatesInput` 인스턴스를 생성하는 빌더.

**Namespace:** LxScheduler

### Methods

| 메서드 | 파라미터 타입 | 반환 | 비고 |
|---|---|---|---|
| `build()` | — | `lxscheduler.GetAppointmentCandidatesInput` | |
| `setAccountId(accountId)` | String | Builder | |
| `setAllowConcurrent(allowConcurrent)` | Boolean | Builder | v47.0+ ; 기본 false |
| `setApiVersion(apiVersion)` | Double | Builder | v45.0+ ; 생략 시 최신 버전 |
| `setCorrelationId(correlationId)` | String | Builder | v53.0+ ; 생략 시 무작위 ID |
| `setEndTime(endTime)` | String | Builder | 포맷: `"yyyy-MM-dd'T'HH:mm:ssZ"` ; 기본 31일 후 |
| `setEngagementChannelTypeIds(engagementChannelTypeIds)` | List\<String\> | Builder | v56.0+ ; shifts 전용 |
| `setFilterByResources(filterByResources)` | List\<String\> | Builder | v51.0+ ; 리소스 ID 순서 반영 |
| `setResourceLimitApptDistribution(resourceLimitApptDistribution)` | Integer | Builder | v53.0+ |
| `setSchedulingPolicyId(schedulingPolicyId)` | String | Builder | 생략 시 기본 설정 |
| `setStartTime(startTime)` | String | Builder | 포맷: `"yyyy-MM-dd'T'HH:mm:ssZ"` |
| `setTerritoryIds(territoryIds)` | List\<String\> | Builder | **required** |
| `setWorkType(workType)` | lxscheduler.WorkType | Builder | workTypeGroupId 없을 때 required |
| `setWorkTypeGroupId(workTypeGroupId)` | String | Builder | workType 없을 때 required |

> **중요**: shifts 사용 시 `workTypeGroupId` 또는 workType의 `id`가 필수. operating hours 사용 시 `durationInMinutes`와 나머지 빌더 파라미터로 구성.

---

## GetAppointmentSlotsInput Class

특정 리소스의 예약 가능 타임슬롯을 조회하는 입력 데이터 클래스. **직접 인스턴스화 불가** — `GetAppointmentSlotsInputBuilder.build()`로 생성.

**Namespace:** LxScheduler

> 타임존이 다른 운영시간은 처리 후 항상 UTC로 반환. 시작일로부터 31일 이내 슬롯만 반환.

---

## GetAppointmentSlotsInputBuilder Class

`lxscheduler.GetAppointmentSlotsInput` 인스턴스를 생성하는 빌더.

**Namespace:** LxScheduler

### Methods

| 메서드 | 파라미터 타입 | 반환 | 비고 |
|---|---|---|---|
| `build()` | — | `lxscheduler.GetAppointmentSlotsInput` | |
| `setAccountId(accountId)` | String | Builder | |
| `setAllowConcurrentScheduling(allowConcurrentScheduling)` | Boolean | Builder | v47.0+ ; 기본 false |
| `setApiVersion(apiVersion)` | Double | Builder | v45.0+ |
| `setCorrelationId(correlationId)` | String | Builder | v53.0+ |
| `setEndTime(endTime)` | String | Builder | 포맷: `"yyyy-MM-dd'T'HH:mm:ssZ"` ; 기본 31일 후 |
| `setEngagementChannelTypeIds(engagementChannelTypeIds)` | List\<String\> | Builder | v56.0+ ; shifts 전용 |
| `setPrimaryResourceId(primaryResourceId)` | String | Builder | v48.0+ ; 멀티 리소스 스케줄링 시 required |
| `setRequiredResourceIds(requiredResourceIds)` | List\<String\> | Builder | **required** |
| `setSchedulingPolicyId(schedulingPolicyId)` | String | Builder | 생략 시 기본 설정 |
| `setStartTime(startTime)` | String | Builder | 포맷: `"yyyy-MM-dd'T'HH:mm:ssZ"` ; 생략 시 현재 시각 |
| `setTerritoryIds(territoryIds)` | List\<String\> | Builder | **required** |
| `setWorkType(workType)` | lxscheduler.WorkType | Builder | workTypeGroupId 없을 때 required |
| `setWorkTypeGroupId(workTypeGroupId)` | String | Builder | |

---

## SchedulerResources Class

리소스 가용성 비즈니스 로직 진입점. 모든 메서드는 static.

**Namespace:** LxScheduler

> Apex Governor Limits 적용 대상. 트랜잭션 시간을 줄이려면 시간 범위를 좁히거나 리소스/영역 수를 제한한다.

### Methods

```apex
// 후보 리소스 목록 조회 — JSON 문자열 반환
public static String getAppointmentCandidates(
    lxscheduler.GetAppointmentCandidatesInput getAppointmentCandidatesInput)

// 예약 가능 타임슬롯 목록 조회 — JSON 문자열 반환
public static String getAppointmentSlots(
    lxscheduler.GetAppointmentSlotsInput getAppointmentSlotsInput)

// 테스트 전용 — 테스트 컨텍스트 외 호출 시 예외
public static void setAppointmentCandidatesMock(String expectedResponse)
public static void setAppointmentSlotsMock(String expectedResponse)
```

> 두 조회 메서드는 모두 JSON 문자열을 반환한다. `System.JSON.deserialize()`로 커스텀 클래스에 파싱해서 사용.

---

## SkillRequirement Class

작업 유형 완료에 필요한 스킬 정보. **직접 인스턴스화 불가** — `SkillRequirementBuilder.build()`로 생성.

**Namespace:** LxScheduler

### SkillRequirementBuilder Methods

```apex
public lxscheduler.SkillRequirement build()
public lxscheduler.SkillRequirementBuilder setSkillId(String skillId)        // required
public lxscheduler.SkillRequirementBuilder setSkillLevel(Double skillLevel)  // 0~99.99 (경력 연수, 자격증 레벨 등)
```

---

## WorkType Class

수행할 작업 유형 정보. **직접 인스턴스화 불가** — `WorkTypeBuilder.build()`로 생성.

**Namespace:** LxScheduler

### WorkTypeBuilder Methods

| 메서드 | 파라미터 타입 | 비고 |
|---|---|---|
| `build()` | — | → `lxscheduler.WorkType` |
| `setId(id)` | String | shifts 사용 시, 또는 `durationInMinutes` 없을 때 required |
| `setDurationInMinutes(durationInMinutes)` | Integer | `id` 없을 때 required |
| `setBlockTimeAfterAppointmentInMinutes(blockTimeAfterAppointmentInMinutes)` | Integer | 예약 후 예약 불가 기간 |
| `setBlockTimeBeforeAppointmentInMinutes(blockTimeBeforeAppointmentInMinutes)` | Integer | 예약 전 예약 불가 기간 |
| `setOperatingHoursId(operatingHoursId)` | String | 운영시간 겹침 설정 |
| `setSkillRequirements(skillRequirements)` | List\<lxscheduler.SkillRequirement\> | |
| `setTimeFrameEndInMinutes(timeFrameEndInMinutes)` | Integer | 타임프레임 종료 |
| `setTimeFrameStartInMinutes(timeFrameStartInMinutes)` | Integer | 타임프레임 시작 |

---

## ServiceResourceScheduleHandler Interface

외부 캘린더에서 이미 예약된 시간대를 확인하는 커스텀 Apex 구현체 인터페이스. Salesforce Scheduler API가 이 인터페이스를 호출한다.

**Namespace:** LxScheduler

```apex
// 인터페이스 메서드 (global 또는 public으로 구현)
public List<lxscheduler.ServiceResourceSchedule> getUnavailableTimeslots(
    lxscheduler.ServiceAppointmentRequestInfo var1)
```

---

## ServiceAppointmentRequestInfo Class

`ServiceResourceScheduleHandler` 인터페이스에 전달되는 요청 파라미터. Apex가 내부적으로 구현.

**Namespace:** LxScheduler

### Constructor

```apex
public ServiceAppointmentRequestInfo(
    Datetime startDate,
    Datetime endDate,
    List<lxscheduler.ServiceResourceInfo> ServiceResources,
    String SchedulingPolicyId,
    String workTypeGroupId,
    String accountId,
    String primaryResourceId,
    String workTypeId,
    String correlationId
)
```

### Methods

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getAccountId()` | String | 고객 계정 ID |
| `getCorrelationId()` | String | 요청 고유 식별자 |
| `getEndDate()` | Datetime | 예약 불가 조회 종료 일시 |
| `getPrimaryResourceId()` | String | 주 서비스 리소스 ID |
| `getSchedulingPolicyId()` | String | 스케줄링 정책 ID |
| `getServiceResources()` | List\<lxscheduler.ServiceResourceInfo\> | 요청된 서비스 리소스 목록 |
| `getStartDate()` | Datetime | 예약 불가 조회 시작 일시 |
| `getWorkTypeGroupId()` | String | 작업 유형 그룹 ID |
| `getWorkTypeId()` | String | 작업 유형 ID |

---

## ServiceResourceInfo Class

서비스 리소스 정보 데이터 클래스.

**Namespace:** LxScheduler

### Constructor

```apex
public ServiceResourceInfo(
    String userId,
    String userName,
    String email,
    String serviceResourceId,
    List<String> territoryIds,
    String resourceType
)
```

### Methods

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getEmail()` | String | 서비스 리소스의 이메일 ID |
| `getResourceType()` | String | 리소스 유형 (Technician, Asset 등) |
| `getServiceResourceId()` | String | 서비스 리소스 레코드 ID |
| `getTerritoryIds()` | List\<String\> | 요청된 서비스 영역 목록 |
| `getUserId()` | String | 서비스 리소스의 사용자 ID |
| `getUserName()` | String | 서비스 리소스의 사용자 이름 |

---

## ServiceResourceSchedule Class

핸들러 구현 결과를 `ServiceResourceScheduleHandler` 인터페이스 메서드에 전달하는 클래스.

**Namespace:** LxScheduler

### Constructor

```apex
public ServiceResourceSchedule(
    String serviceResourceId,
    Set<lxscheduler.UnavailableTimeslot> unavailableTimeslots
)
```

### Properties

```apex
public String serviceResourceId {get; set;}                                    // 서비스 리소스 레코드 ID
public Set<lxscheduler.UnavailableTimeslot> unavailableTimeslots {get; set;}   // 예약 불가 시간대 Set
```

---

## UnavailableTimeslot Class

예약 불가 시간대를 `ServiceResourceSchedule`에 전달하는 클래스. 타임존이 다른 운영시간도 처리하며 결과는 항상 UTC로 반환.

**Namespace:** LxScheduler

### Constructor

```apex
public UnavailableTimeslot(Datetime timeMin, Datetime timeMax)
// timeMin — 예약 불가 시작 시간
// timeMax — 예약 불가 종료 시간
```

### Properties

```apex
public Datetime timeMax {get; set;}  // 예약 불가 종료 시간
public Datetime timeMin {get; set;}  // 예약 불가 시작 시간
```

---

## 사용 예제

### 예약 후보 리소스 조회 (workTypeGroupId 기반)

```apex
lxscheduler.GetAppointmentCandidatesInput input =
    new lxscheduler.GetAppointmentCandidatesInputBuilder()
        .setWorkTypeGroupId('0VSRM0000000ABc4AM')
        .setTerritoryIds(new List<String>{'0HhRM0000000FXd0AM'})
        .setStartTime(System.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'America/New_York'))
        .setEndTime(System.now().addDays(5).format('yyyy-MM-dd\'T\'HH:mm:ssZ', 'America/New_York'))
        .setAccountId('001RM0000053iQgYAI')
        .setSchedulingPolicyId('0VrRM00000000Bx')
        .setApiVersion(Double.valueOf('50.0'))
        .build();

String response = lxscheduler.SchedulerResources.getAppointmentCandidates(input);
// JSON 응답 예시:
// [{"startTime":"2021-02-16T16:15:00.000+0000","endTime":"2021-02-16T16:16:00.000+0000",
//   "resources":["0Hnxx0000004C9BCAU"],"territoryId":"0Hhxx0000004C92CAE"}, ...]
```

### 예약 가능 타임슬롯 조회 (workTypeGroupId 기반)

```apex
lxscheduler.GetAppointmentSlotsInput input =
    new lxscheduler.GetAppointmentSlotsInputBuilder()
        .setWorkTypeGroupId('0VSxx0000004C92GAE')
        .setTerritoryIds(new List<String>{'0Hhxx0000004C92CAE'})
        .setStartTime(System.now().format('yyyy-MM-dd\'T\'HH:mm:ssZ'))
        .setEndTime(System.now().addDays(1).format('yyyy-MM-dd\'T\'HH:mm:ssZ'))
        .setAccountId('001xx000003GYK0AAO')
        .setRequiredResourceIds(new List<String>{'0Hnxx0000004C92CAE'})
        .setSchedulingPolicyId('0Vrxx0000004CAe')
        .setApiVersion(Double.valueOf('48.0'))
        .build();

String response = lxscheduler.SchedulerResources.getAppointmentSlots(input);
// JSON 응답 예시:
// [{"territoryId":"0Hhxx0000004C92CAE","startTime":"2021-02-10T16:00:00.000+0000",
//   "endTime":"2021-02-10T16:15:00.000+0000","remainingAppointments":1}, ...]
```

### WorkType + SkillRequirement 조합 (durationInMinutes 기반)

```apex
lxscheduler.SkillRequirement skillReq = new lxscheduler.SkillRequirementBuilder()
    .setSkillId('0C5RM0000004EZS0A2')
    .setSkillLevel(90)
    .build();

lxscheduler.WorkType workType = new lxscheduler.WorkTypeBuilder()
    .setDurationInMinutes(15)
    .setBlockTimeBeforeAppointmentInMinutes(5)
    .setBlockTimeAfterAppointmentInMinutes(5)
    .setTimeFrameStartInMinutes(10080)
    .setTimeFrameEndInMinutes(40320)
    .setOperatingHoursId('00HRM0000000FmG4AU')
    .setSkillRequirements(new List<lxscheduler.SkillRequirement>{skillReq})
    .build();

lxscheduler.GetAppointmentCandidatesInput input =
    new lxscheduler.GetAppointmentCandidatesInputBuilder()
        .setWorkType(workType)
        .setTerritoryIds(new List<String>{'0HhRM0000000FXd0AM'})
        .setSchedulingPolicyId('0VrRM00000000Bx')
        .setApiVersion(Double.valueOf('50.0'))
        .build();
```

### ServiceResourceScheduleHandler 구현 (외부 캘린더 연동)

```apex
public class ServiceResourceScheduleHandlerImpl
    implements LxScheduler.ServiceResourceScheduleHandler {

    public static List<LxScheduler.ServiceResourceSchedule> getUnavailableTimeslots(
        LxScheduler.ServiceAppointmentRequestInfo requestInfo
    ) {
        List<LxScheduler.ServiceResourceInfo> serviceResources =
            requestInfo.getServiceResources();
        DateTime startDate = requestInfo.getStartDate();

        List<LxScheduler.ServiceResourceSchedule> resourceUnavailability =
            new List<LxScheduler.ServiceResourceSchedule>();

        for (LxScheduler.ServiceResourceInfo resource : serviceResources) {
            Set<LxScheduler.UnavailableTimeslot> unavailabilityIntervals =
                new Set<LxScheduler.UnavailableTimeslot>();

            // 외부 시스템에서 예약 불가 시간대 조회 — 여기서는 더미 데이터
            for (Integer i = 0; i < 5; i++) {
                unavailabilityIntervals.add(new LxScheduler.UnavailableTimeslot(
                    startDate.addMinutes(15 * i),
                    startDate.addMinutes(15 * (i + 1))
                ));
            }
            resourceUnavailability.add(new LxScheduler.ServiceResourceSchedule(
                resource.getServiceResourceId(), unavailabilityIntervals
            ));
        }
        return resourceUnavailability;
    }
}
```

### 테스트 Mock 설정

```apex
@IsTest
private class GetAppointmentCandidatesTest {
    static testMethod void getAppCandidatesTest() {
        String expectedResponse = '[' +
            '{"startTime": "2021-03-18T16:00:00.000+0000",' +
            '"endTime": "2021-03-18T17:00:00.000+0000",' +
            '"resources": ["0HnRM0000000Fxv0AE"],' +
            '"territoryId": "0HhRM0000000G8W0AU"}' +
            ']';
        lxscheduler.SchedulerResources.setAppointmentCandidatesMock(expectedResponse);
        Test.startTest();
        // 비즈니스 로직 테스트
        Test.stopTest();
    }
}
```

---

## 관련 노트

- [[ExternalService Namespace]] — OpenAPI 스펙 기반 타입 안전 외부 서비스 호출
- [[ConnectApi Namespace 개요]] — Connect in Apex 전체 클래스 목록
- [[BusinessHours 패턴]] — BusinessHours.diff(), SLA 경과 시간 계산 (운영시간 연동)
- [[DataSource Namespace]] — Salesforce Connect 커스텀 어댑터 (외부 데이터 연동)
