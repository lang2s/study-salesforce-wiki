---
tags: [sobject-reference, index, object-reference]
source: object_reference.pdf (v67.0 Summer '26)
created: 2026-05-22
aliases: [sObject Reference 인덱스, Object Reference 목차]
---

# sObject Reference(sObject 레퍼런스) — 폴더 인덱스

> Salesforce Platform Object Reference v67.0 (Summer '26) 기반 — 6개 챕터별 위키

---

## 챕터 개요 파일

| 파일 | 챕터 | 내용 |
|---|---|---|
| [[1 Overview]] | Chapter 1 | Primitive 타입·Field 타입·API 속성·Compound Fields·External·Big Objects |
| [[2 Object Behavior]] | Chapter 2 | Object 그룹·타입·Data Cloud·치트시트 |
| [[3 Associated Objects]] | Chapter 3 | Feed·History·OwnerSharingRule·Share·ChangeEvent 패턴 |
| [[4 Custom Objects]] | Chapter 4 | __mdt·__c·__Feed 표준 필드 |
| [[5 Object Interfaces]] | Chapter 5 | PriceAdjustmentGroup·PriceAdjustmentItem·SalesTransaction |
| [[6 Standard Objects]] | Chapter 6 | 표준 Object 도메인별 카탈로그 |

---

## Chapter 1 세부 페이지

| 파일 | 내용 |
|---|---|
| [[Primitive Data Types]] | base64·boolean·byte·date·dateTime·double·int·long·string·time 10개 SOAP 기본 타입 |
| [[Field Types]] | address·ID·JunctionIdList·reference·picklist 등 20+ API 필드 타입 |
| [[API Field Properties]] | Aggregatable·Create·Filter·Nillable·Sort 등 15개 필드 속성 |
| [[System Fields]] | Id·IsDeleted·CreatedById·LastModifiedDate·SystemModstamp + Audit Fields + OwnerId |
| [[Compound Fields]] | Address 복합 필드·Geolocation 복합 필드·DISTANCE/GEOLOCATION SOQL |
| [[Custom Objects]] | __c 오브젝트 네이밍·Audit Fields 설정·Sharing(__Share)·Tags(__Tag)·nillable 필수 규칙 |
| [[Custom Fields]] | External ID·Uniqueness(caseSensitive)·Default Values·Managed Package prefix |
| [[Object Relationships]] | Master-Detail·Many-to-many(Junction)·Lookup 비교 + 데이터 접근 팩터 |
| [[External Objects]] | __x 네이밍·Salesforce Connect 어댑터·Files Connect·External/Indirect Lookup |
| [[Big Objects]] | __b 네이밍·비트랜잭션·Metadata XML(CustomObject·CustomField·Index·IndexField) |

---

## 빠른 선택

- Primitive 타입(base64·dateTime 등) → [[Primitive Data Types]]
- Field 타입(reference·JunctionIdList 등) → [[Field Types]]
- 필드 속성(Filterable·Nillable 등) → [[API Field Properties]]
- 시스템 필드(CreatedDate·OwnerId 등) → [[System Fields]]
- 복합 주소·위치 필드 → [[Compound Fields]]
- 커스텀 오브젝트 생성·공유 규칙 → [[Custom Objects]]
- 커스텀 필드 External ID·유니크 설정 → [[Custom Fields]]
- Master-Detail vs Lookup 비교 → [[Object Relationships]]
- 외부 시스템 연결(Salesforce Connect) → [[External Objects]]
- 대용량 아카이브 데이터 → [[Big Objects]]
- Object 그룹·Data Cloud(DLO·DMO) → [[2 Object Behavior]]
- Feed·History 패턴 → [[3 Associated Objects]]
- __mdt / __c 표준 필드 목록 → [[4 Custom Objects]]
- 가격조정 인터페이스(B2B) → [[5 Object Interfaces]]
- Account·Case·Opportunity 등 표준 Object → [[6 Standard Objects]]
