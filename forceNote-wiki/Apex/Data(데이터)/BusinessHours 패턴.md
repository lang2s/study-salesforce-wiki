---
tags: [apex, data, business-hours, sla, pattern]
source: automation-components/src-utilities/CalculateBusinessHours.cls
created: 2026-05-17
aliases: [BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 계산, 업무시간]
---

# BusinessHours 패턴

> `BusinessHours.diff()` — 두 DateTime 사이의 영업시간 기준 경과 시간을 밀리초로 반환. SLA 준수 여부 판단, 케이스 처리 시간 계산에 활용.

---

## 개념

### 왜 BusinessHours API가 필요한가

SLA(서비스 수준 계약)나 케이스 처리 시간을 계산할 때, 단순히 두 DateTime의 차이를 구하면 **주말, 공휴일, 업무 시간 외 시간**이 포함된다. 예를 들어 금요일 오후 5시에 접수된 케이스가 월요일 오전 9시에 처리되면, 실제 업무 처리 시간은 0이지만 단순 시간 차이는 약 64시간이다.

`BusinessHours`는 Salesforce Setup에서 정의한 영업시간(Business Hours) 레코드를 기준으로 이 계산을 수행한다. 영업시간 레코드에는 요일별 근무 시작·종료 시각과 타임존이 포함되어 있으며, 이를 기반으로 실제 영업일 기준 경과 시간만 집계한다.

### 언제 사용하는가

- **Service Cloud SLA 모니터링**: 케이스 접수 후 첫 응답까지의 영업시간을 추적
- **Entitlement 연동**: Salesforce Entitlement(계약 기반 서비스) 기능과 함께 SLA 위반 여부 판단
- **케이스 에스컬레이션 자동화**: 일정 영업시간 초과 시 Flow나 Process Builder로 에스컬레이션 트리거
- **사용자에게 대기 시간 표시**: 현재 영업시간인지(`isWithin`), 다음 응답 가능 시각이 언제인지(`nextStartDate`) 안내

### 제한사항 / 주의사항

- **Business Hours 레코드가 반드시 Setup에 존재해야 한다.** SOQL로 Id를 조회해 사용하며, 레코드가 없으면 쿼리 결과가 없어 런타임 오류로 이어진다
- **타임존 처리**: BusinessHours 레코드에 타임존이 설정되어 있으므로, 전달하는 `DateTime` 값의 타임존과 불일치 시 예상과 다른 결과가 나올 수 있다. Apex의 `DateTime`은 항상 UTC 기준이므로 주의
- **정수 나눗셈 정밀도 손실**: `durationMs / 3600000`은 Long 정수 나눗셈으로 소수 이하가 버림된다. 소수점 단위 시간이 필요하면 `Decimal`로 캐스팅 후 계산
- **테스트 환경**: 테스트에서 `BusinessHours` 레코드는 실제 org의 데이터를 조회한다. `@TestSetup`에서 별도로 생성할 필요는 없지만, Default Business Hours가 존재한다는 가정을 하는 테스트는 org 구성에 의존적이다

---

## 기본 사용법

```apex
// BusinessHoursId: Setup > Business Hours 에서 생성한 레코드 Id
Id businessHoursId = [SELECT Id FROM BusinessHours WHERE Name = 'Default' LIMIT 1].Id;

DateTime startTime = Datetime.now().addDays(-2);
DateTime endTime   = Datetime.now();

// 영업시간 기준 경과 밀리초 반환 (평일 09:00~18:00 기준 계산)
Long durationMs = BusinessHours.diff(businessHoursId, startTime, endTime);

// 단위 변환
Long durationSec   = durationMs / 1000;
Long durationMin   = durationMs / 60000;
Long durationHours = durationMs / 3600000;
Long durationDays  = durationMs / 86400000;
```

---

## 유효성 검사 — BusinessHours.isWithin()

```apex
// 현재 시각이 영업시간 내에 있는지 확인
Boolean isOpen = BusinessHours.isWithin(businessHoursId, Datetime.now());

// 특정 시각이 영업시간 내인지
Boolean isWithin = BusinessHours.isWithin(businessHoursId, targetDatetime);
```

---

## 다음 영업시간 시작 — BusinessHours.nextStartDate()

```apex
// 현재 영업시간 외라면 다음 영업 시작 시각 반환
Datetime nextOpen = BusinessHours.nextStartDate(businessHoursId, Datetime.now());
```

---

## 활용 패턴 — SLA 초과 여부 판단

```apex
public Boolean isSlaBreach(Id caseId) {
    Case c = [SELECT CreatedDate, SlaExitDate FROM Case WHERE Id = :caseId LIMIT 1];
    Id bhId = [SELECT Id FROM BusinessHours WHERE IsDefault = true LIMIT 1].Id;

    Long elapsed = BusinessHours.diff(bhId, c.CreatedDate, Datetime.now());
    Long slaLimitMs = 8 * 3600000; // SLA 8 영업시간

    return elapsed > slaLimitMs;
}
```

---

## Invocable Action으로 Flow 연동

```apex
// CalculateBusinessHours @InvocableMethod — Flow에서 직접 호출 가능
// 입력: businessHoursId, startDate, endDate
// 출력: durationMs, durationSec, durationMin, durationHours, durationDays

// Flow → Apex Action: "Calculates the duration in terms business hours between two dates"
// → [[Flow 유틸리티 액션 모음]] 참조
```

---

## 비교표

| 상황 | 방법 |
|---|---|
| 경과 영업시간 계산 | `BusinessHours.diff()` |
| 지금이 영업시간인지 | `BusinessHours.isWithin()` |
| 다음 영업 시작 시각 | `BusinessHours.nextStartDate()` |
| Flow에서 영업시간 계산 | [[Flow 유틸리티 액션 모음]] → CalculateBusinessHours |

---

## 주의 사항

> [!warning] BusinessHours 레코드 필수
> Setup에서 Business Hours 레코드가 설정되어 있어야 한다. `IsDefault = true` 인 레코드가 기본값.

> [!tip] 단위 변환 정밀도
> `durationMs / 3600000` 는 정수 나눗셈이므로 분 단위 이하는 버림. 소수 단위가 필요하면 `Decimal`로 캐스팅 후 계산.

---

## 관련 노트

- [[Scheduled Apex]] — 영업시간 외 스케줄 실행
- [[Flow 유틸리티 액션 모음]] — CalculateBusinessHours Invocable Action
- [[LxScheduler Namespace]] — Lightning Scheduler 약속 슬롯 계산이 BusinessHours를 기준으로 동작
