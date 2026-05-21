---
title: Custom Objects
tags: [salesforce, sobject, custom-objects, api, metadata]
source: object_reference.pdf v67.0 — Ch1 pp.21–23 (물리 pp.63–65)
---

# Custom Objects

## 개요

커스텀 오브젝트는 사용자가 UI 또는 Metadata API로 직접 정의한 커스텀 데이터베이스 테이블이다.  
`describeSObjects()` 반환값의 `custom` Boolean 필드가 `true`이면 커스텀 오브젝트다.

커스텀 오브젝트는 다음 세 가지 방법으로 생성할 수 있다:
- Salesforce 사용자 인터페이스(Setup)
- Metadata API(WSDL 기반 클라이언트)
- Salesforce Extensions for Visual Studio Code

---

## 네이밍 컨벤션

- API 이름에는 두 언더스코어 + 소문자 `c` 접미사 `__c`가 붙는다.
  - UI 레이블 `Issue` → API 이름 `Issue__c`
- 오브젝트 이름은 org 내에서 **고유**해야 한다.
- 레코드의 Name 필드가 없으면 API로 레코드 생성 시 **레코드 ID**가 이름으로 사용된다.

---

## 커스텀 오브젝트 간 관계

커스텀 오브젝트는 표준 오브젝트와 동일한 방식으로 관계를 맺는다.

### 관계 네이밍 규칙

관계 필드 이름이 `MyRel`일 때:

| 이름 | 값 |
|---|---|
| ID 필드 이름 | `MyRelId__r` |
| 부모 오브젝트 포인터 | `MyRel__c` |
| 관계 이름 | `MyRel__r` |

### 표준 오브젝트와의 관계 가능 여부

| 표준 오브젝트 | Master-Detail 가능 | Lookup 가능 | 커스텀 필드 가능 |
|---|---|---|---|
| Account | Yes | Yes | Yes |
| Campaign | Yes | Yes | Yes |
| Case | Yes | Yes | Yes |
| Contact | Yes | Yes | Yes |
| Contract | Yes | Yes | Yes |
| Event | No | No | Yes |
| Lead | No | No | Yes |
| Opportunity | Yes | Yes | Yes |
| Product2 | No | Yes | Yes |
| Solution | Yes | Yes | Yes |
| Task | No | No | Yes |
| User | No | Yes | Yes |

> Master-Detail에서 캐스케이드 삭제가 지원된다.  
> Master-Detail 관계에서 Standard Object가 Detail(자식) 쪽이 될 수 없다.

---

## Audit Fields

커스텀 오브젝트 생성 시 4개의 감사 필드가 자동 생성된다:

| 필드 | 설명 |
|---|---|
| `CreatedById` | 생성자 ID |
| `CreatedDate` | 생성 날짜 |
| `LastModifiedById` | 최종 수정자 ID |
| `LastModifiedDate` | 최종 수정 날짜 |

이 필드들은 **읽기 전용**이다.

### 감사 필드 값 직접 설정 (import 시)

소스 시스템의 감사 필드 값을 유지하며 가져오려면:

1. Setup → Quick Find → **User Interface**
2. **"Set Audit Fields upon Record Creation"** 및 **"Update Records with Inactive Owners" User Permissions** 활성화
3. Permission Set 또는 Profile에서 **Set Audit Fields upon Record Creation** 권한 부여
4. API로 레코드 생성 시 감사 필드 값 직접 설정

**제약사항:**
- `CreatedDate`는 `LastModifiedDate`보다 클 수 없다.
- 날짜 필드를 현재 시각보다 미래로 설정할 수 없다.
- `SystemModstamp`는 값을 설정할 수 없다.
- 조직에 API 액세스가 활성화되어 있어야 하고, "Modify All Data" 권한이 필요하다.

---

## Sharing

- Master-Detail 관계가 없는 커스텀 오브젝트마다 **공유 규칙 오브젝트**가 자동 생성된다.
  - 형식: `MyObjectName__Share` (예: `AccountShare`와 동일한 패턴)
- 오브젝트 생성자에게 "Manage Sharing" 권한이 있으면 공유 오브젝트가 자동 생성된다.
- Apex 공유 이유(Apex sharing reason)는 `rowCause` 필드로 조회 가능하다.

---

## Tags

커스텀 오브젝트 생성 시 관련 **Tag 오브젝트**도 함께 생성된다.
- 형식: `MyObjectName__Tag` (예: `AccountTag`와 동일한 패턴)

---

## Standard Fields for Custom Objects

커스텀 오브젝트 생성 시 Salesforce가 자동 할당하는 표준 필드가 있다.  
상세는 오브젝트 레퍼런스의 Custom Objects 섹션 참조.

---

## Required Fields

커스텀 필드의 `nillable` 속성(Boolean)으로 필수 여부가 결정된다.

| `nillable` 값 | 의미 |
|---|---|
| `false` (기본값) | 필수 — 값 없이 요청하면 실패 |
| `true` | 선택적 |

- UI에서 필드를 필수로 표시하면 API에서도 동일하게 적용된다.
- 필수 필드에 값이 없으면 `REQUIRED_FIELD_MISSING` 상태 코드 반환.
- `nillable` 속성을 수정하려면 "Customize Application" 권한이 필요하다.

---

## Managed Packages와 API 이름

Unmanaged 패키지에서 Managed 패키지 버전으로 전환 시 API 이름이 변경된다:
- `name__c` → `prefix__name__c` (네임스페이스 프리픽스 추가)

전환 절차:
1. 데이터 내보내기
2. 기존 패키지 제거
3. 새 패키지 설치
4. 이름 변경 검토 후 데이터 re-import (관련 매핑 반영)

---

## 관련 노트

- [[1 Overview]] — Chapter 1 전체 구조 요약
- [[Custom Fields]] — 커스텀 필드 네이밍·External ID·유니크 설정
- [[Object Relationships]] — Master-Detail·Lookup·Many-to-many 관계 상세
- [[System Fields]] — CreatedDate·LastModifiedDate 등 감사 필드 공통 설명
- [[API Field Properties]] — `custom`, `nillable` 등 필드 속성 상세
