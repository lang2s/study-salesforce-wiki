---
tags: [apex, data, business-hours, sla, pattern]
source: automation-components/src-utilities/CalculateBusinessHours.cls
created: 2026-05-17
aliases: [BusinessHours, BusinessHours.diff, 영업시간 계산, SLA 계산, 업무시간]
---

# BusinessHours 패턴

> `BusinessHours.diff()` — 두 DateTime 사이의 영업시간 기준 경과 시간을 밀리초로 반환. SLA 준수 여부 판단, 케이스 처리 시간 계산에 활용.

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
