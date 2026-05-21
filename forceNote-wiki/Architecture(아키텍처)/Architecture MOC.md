---
tags: [moc, architecture, pattern, namespace, reference]
source: wiki-navigation
created: 2026-05-22
aliases: [Architecture MOC, 아키텍처 목차, Architecture Map of Content]
---

# Architecture MOC

> Architecture(아키텍처) 섹션 전체 목차 — Salesforce 설계 패턴, 설정 관리, 검증 규칙, 네임스페이스 레퍼런스 모음.

**상위:** [[00 Home]]

---

## 설계 패턴

- [[서비스 레이어 패턴]] — TriggerHandler → ServiceLayer 브로커 분리, 비즈니스 로직 재사용 설계
- [[Permission Set 설계]] — objectPermissions, fieldPermissions, classAccesses 구성 표준

---

## 설정·메타데이터 관리

- [[Custom Metadata Types]] — CMDT 읽기·쓰기(Metadata.Operations), getInstance, SOQL 조회, isProtected 보호 설정
- [[Schema Namespace 상세]] — DescribeSObjectResult/DescribeFieldResult/RecordTypeInfo/PicklistEntry/ChildRelationship 전체

---

## 검증·수식

- [[Validation Rules 예제]] — REGEX, ISBLANK, ISNUMBER, ISCHANGED, PRIORVALUE, VLOOKUP, ISPICKVAL 예제 모음

---

## 플랫폼 개요

- [[Salesforce 플랫폼 개요]] — Org/Object/Record/Field/App, Cloud 종류, 거버너 한도, 환경 분리

---

## 네임스페이스 레퍼런스

- [[Approval Namespace]] — Apex에서 승인 프로세스 제출·처리·잠금 — ProcessSubmitRequest, ProcessWorkitemRequest
- [[System Namespace]] — System 전체 클래스 레퍼런스 — AccessLevel, Assert, AsyncOptions, UserInfo, UUID, Callable, FeatureManagement
- [[Site Namespace]] — Force.com Sites URL 재작성 — UrlRewriter (generateUrlFor, mapRequestUrl)
- [[Context Namespace]] — Industries Cloud Context Service Apex — IndustriesContext
- [[ApexPages Namespace]] — Visualforce 컨트롤러 클래스 전체 — StandardController, StandardSetController, Message, Action
- [[AppLauncher Namespace]] — App Launcher 앱 가시성·정렬 제어 — AppMenu.setAppVisibility
- [[VisualEditor Namespace]] — Lightning App Builder 동적 피클리스트 — DynamicPickList, DesignTimePageContext
- [[Canvas Namespace]] — 외부 웹 앱 임베드 Apex SDK — CanvasLifecycleHandler, RenderContext, Canvas.Test

---

## 관련 섹션 MOC

- [[Apex MOC]] — Apex 전체 목차
- [[LWC MOC]] — LWC 전체 목차
- [[Flow MOC]] — Flow 전체 목차
