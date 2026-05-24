---
tags: [devops, metadata-api, metadata-types, other, sustainability, v67]
source: api_meta.pdf v67.0 Summer '26 — Chapter 13 (Metadata Types)
created: 2026-05-22
aliases: [Metadata 기본 클래스, MetadataWithContent, 기타 메타데이터 타입]
---

# Metadata Types — Other

> Metadata/MetadataWithContent 기본 타입, FuelType, Fundraising, 기타 분류되지 않은 메타데이터 타입.

---

## 이 그룹의 타입 목록

| 타입명 | 설명 |
|---|---|
| AccountPlanObjMeasCalcDef | 계정 플랜 목표 측정 계산 정의 |
| FuelType | 커스텀 연료 타입 |
| FuelTypeSustnUom | 연료 타입 ↔ UOM 매핑 |
| FundraisingConfig | Fundraising 설정 |
| GiftEntryGridTemplate | Fundraising 선물 입력 그리드 템플릿 |
| InsPlcyLimitConsumptionRule | 보험 정책 한도 소비 규칙 |
| Metadata | 모든 메타데이터 타입의 기본 클래스 (편집 불가) |
| MetadataWithContent | 콘텐츠 포함 메타데이터 기본 타입 (편집 불가) |
| RpaRobotPoolMetadata | Reserved for future use |
| Scontrol | Deprecated. S-control 컴포넌트 |
| SustainabilityUom | 커스텀 연료 타입 UOM |
| SustnUomConversion | UOM 변환 정보 |
| Tag | Reserved for future use |
| TagSet | Reserved for future use |
| UserProfileSearchScope | Internal use only |

---

## Metadata (기본 클래스)

**모든 메타데이터 타입의 기본 클래스.** 직접 편집 불가. 모든 Metadata 타입이 상속.

### Fields

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `fullName` | string | - | 컴포넌트의 고유 이름. 각 타입마다 고유 형식 |

---

## MetadataWithContent (기본 클래스)

콘텐츠(파일 데이터)를 포함하는 메타데이터 타입의 기본 클래스. `Metadata`를 extends. 직접 편집 불가.

ApexClass, ApexTrigger, ApexPage, ApexComponent, Document, EmailTemplate, Certificate, ContentAsset, StaticResource 등이 상속.

### Fields (Metadata에서 추가된 필드)

| Field Name | Field Type | Required | Description |
|---|---|---|---|
| `content` | base64Binary | - | Base64 인코딩된 파일 내용. API 호출 전 클라이언트가 인코딩 필요. 응답 시 디코딩 필요. SOAP 클라이언트는 자동 처리 |
| `fullName` | string | - | 컴포넌트 이름. `Metadata`에서 상속 |

---

## Scontrol (Deprecated)

S-control 컴포넌트. Deprecated — 사용 중단. 새 구현에서 사용 금지.

---

## FuelType

커스텀 연료 타입. Sustainability(Net Zero Cloud) 관련.

---

## FuelTypeSustnUom

커스텀 연료 타입 ↔ UOM(단위) 매핑.

---

## SustainabilityUom

커스텀 연료 타입 UOM 값. 연료 소비 및 배출 결과 추적.

---

## SustnUomConversion

커스텀 연료 타입 UOM 변환 정보.

---

## AccountPlanObjMeasCalcDef

계정 플랜 목표 측정 계산 정의. 대상 오브젝트, 롤업 필드, 영업 계정 플랜 목표 현재 값 계산 로직 포함.

---

## InsPlcyLimitConsumptionRule

보험 정책 한도 소비 규칙. 소비 모드와 제품 바인딩을 포함한 보험 정책 제품 한도 소비 방법 설정.

---

## FundraisingConfig

Fundraising 제품 구성 설정 컬렉션.

---

## GiftEntryGridTemplate

Fundraising 선물 입력 그리드 커스터마이즈 템플릿.

---

## RpaRobotPoolMetadata / Tag / TagSet

Reserved for future use.

---

## UserProfileSearchScope

Internal use only.

---

## 관련 노트

- [[Metadata Types — 개요 및 분류]] — 전체 타입 목록 및 분류
- [[Metadata Types — Apex & Code]] — MetadataWithContent를 상속하는 Apex 타입
- [[Metadata API 개요]] — Metadata API 전체 개념
- [[2GP — Components: Other]] — 같은 타입(Sustainability·Service Catalog·Translation·Slack 등 60+)의 2GP 패키징 동작

---

## Declarative Metadata 예시

### MetadataWithContent 상속 타입 — 코드 추출 예시

```java
// MetadataWithContent를 상속한 타입(ApexClass 등)은 content 필드에 Base64 파일이 담긴다
// Java 클라이언트에서 content 필드를 읽어 디코딩하는 패턴
ApexClass[] classes = (ApexClass[]) metadataConnection.readMetadata(
    "ApexClass", new String[]{"MyClass"}
);
String rawContent = new String(classes[0].getContent(), "UTF-8");
System.out.println(rawContent); // Apex 소스 코드 출력
```

### FuelType — Net Zero Cloud Declarative 예시

```xml
<!-- package.xml — FuelType 배포 -->
<types>
    <members>*</members>
    <name>FuelType</name>
</types>
<types>
    <members>*</members>
    <name>SustainabilityUom</name>
</types>
```
