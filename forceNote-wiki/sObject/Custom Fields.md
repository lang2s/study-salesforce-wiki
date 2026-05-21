---
title: Custom Fields
tags: [salesforce, sobject, custom-fields, api, metadata]
source: object_reference.pdf v67.0 — Ch1 pp.24–25 (물리 pp.66–67)
---

# Custom Fields

## 개요

Salesforce 관리자가 UI를 통해 표준 또는 커스텀 오브젝트에 추가하는 필드.  
`describeSObjects()` 반환값의 `custom` Boolean 필드가 `true`이면 커스텀 필드다.

> 모든 숫자형 커스텀 필드는 `double` 타입으로 처리된다.

---

## 커스텀 필드를 지원하는 표준 오브젝트

Account, Campaign, Case, Contact, Contract, Event, Lead, Opportunity, Product2, Solution, Task, User — 모두 커스텀 필드 지원.

---

## 네이밍 컨벤션

- API 이름: 두 언더스코어 + 소문자 `c` 접미사 `__c`
  - UI 레이블 `Hire Date` → API 이름 `Hire_Date__c`
  - UI 레이블 `Issue` (커스텀 오브젝트) → WSDL에서 `Issue__c`
- 같은 오브젝트 내에서 고유해야 한다.
- 클라이언트 앱은 보통 필드가 표준인지 커스텀인지 구분할 필요가 없다.

---

## External ID

UI에서 커스텀 필드 하나를 **External ID 필드**로 지정 가능하다.

- 지원 타입: `text`, `number`, `email` 필드만 허용
- 외부 시스템의 레코드 ID를 저장
- import / integration / `upsert()` 시 매칭 키로 활용

---

## 유니크 설정 (Uniqueness)

커스텀 오브젝트의 커스텀 필드에 유니크 제약 가능.

| 속성 | 의미 |
|---|---|
| `unique = true` | 해당 오브젝트 타입의 모든 레코드에서 값 고유 |
| `unique = false` | 다른 레코드에 동일 값 허용 |
| `caseSensitive = true` | 대소문자 구분 ("ABC" ≠ "abc") |
| `caseSensitive = false` | 대소문자 무시 ("ABC" = "abc") |

> `unique`와 `caseSensitive` 값은 API로 설정하거나 수정할 수 없다.  
> 유니크 필드에 중복 값 삽입 시 → `DUPLICATE_VALUE` 예외 코드 반환.

---

## 기본값 (Default Values)

커스텀 필드에 formula field로 기본값 설정 가능.

**조건:**
- 로그인 사용자에게 "Customize Application" 권한 필요
- 지원 타입: `currency`, `date`, `datetime`, `int`, `double`, `percent`, `string`, `textarea`, `email`, `phone`, `url`
- 불가 타입: Address, Person, Names, Fiscal Periods 등 복합 필드
- 체크박스는 UI에서 기본값 설정 가능하나 formula field로는 불가

**기본값 미적용 케이스:**
- 리드 전환 (lead conversion)
- 가져오기 (importing)
- 레코드 병합 (merging)

---

## Managed Packages와 API 이름

Unmanaged 패키지 → Managed 패키지 전환 시 이름 변경:
- `name__c` → `prefix__name__c`

전환 절차: 데이터 내보내기 → 기존 패키지 제거 → 새 패키지 설치 → 데이터 재import (매핑 검토 포함).

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[Custom Objects]] — 커스텀 오브젝트 정의·네이밍·감사 필드
- [[Field Types]] — 커스텀 필드 기반 타입 (double, string 등)
- [[API Field Properties]] — `custom`, `unique`, `caseSensitive`, `nillable` 등 속성 상세
