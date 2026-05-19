---
tags: [apex, context, industries-cloud, context-service, industries-context, architecture]
source: salesforce_apex_reference_guide.pdf (Apex Reference Guide v67.0, p.2688)
created: 2026-05-20
aliases: [Context Namespace, Context.IndustriesContext, IndustriesContext, Context Service Apex, 컨텍스트 서비스, Industries Context]
---

# Context Namespace

> Industries Cloud의 Context Service를 Apex로 제어하는 네임스페이스. 비즈니스 애플리케이션 데이터의 공유·소비를 관리한다.

> [!note] Industries Cloud 전용
> `Context` 네임스페이스는 Financial Services Cloud, Health Cloud 등 Salesforce Industries 제품에서 제공하는 **Context Service** 기능 전용이다. Context Service가 활성화된 org에서만 사용할 수 있다.

---

## 개념

Context Service는 여러 Industries Cloud 앱 간에 **비즈니스 컨텍스트 데이터**(현재 선택된 계정, 연락처, 금융 상품 등)를 공유하고 소비하는 메커니즘이다. `Context` 네임스페이스의 `IndustriesContext` 클래스를 통해 Apex 코드에서 이 데이터에 접근한다.

### 클래스 목록

| 클래스 | 설명 |
|---|---|
| `Context.IndustriesContext` | Context Service 데이터의 공유·소비를 관리하는 진입점 클래스 |

---

## 언제 쓰나

- Financial Services Cloud, Health Cloud 등 Industries Cloud 기반 org에서 컨텍스트 데이터를 Apex로 읽거나 설정해야 할 때
- 여러 LWC 또는 Apex 컴포넌트 간에 동일한 비즈니스 컨텍스트(예: 현재 선택된 고객 계정)를 공유해야 할 때
- Context Service의 데이터 공유 이벤트에 반응하는 커스텀 로직을 구현할 때

---

## Context.IndustriesContext 클래스

```apex
// 구조 예시 — 실제 동작 코드 아님
// Context Service에서 현재 컨텍스트 데이터 접근 패턴
Context.IndustriesContext ctx = Context.IndustriesContext.getInstance();
```

> [!note] 상세 메서드 참고
> `IndustriesContext` 클래스의 전체 메서드 목록과 사용 예제는 Salesforce 공식 Industries 개발자 문서(Financial Services Cloud / Health Cloud Developer Guide)를 참조한다. Apex Reference v67.0 p.2688은 네임스페이스 존재만 기록하며, 메서드 상세는 Industries 전용 문서에서 제공한다.

---

## 주의사항

### 1. Context Service 활성화 필요

Context Service가 Setup에서 활성화되어 있지 않은 org에서 `Context.IndustriesContext`를 호출하면 오류가 발생한다. 일반 Enterprise Edition이나 Developer Edition org에서는 사용할 수 없다.

### 2. Industries Cloud 라이선스 필요

Financial Services Cloud, Health Cloud 등 해당 Industries 라이선스가 있는 org에서만 사용 가능하다.

---

## 관련 노트

- [[System Namespace]] — 범용 Apex 시스템 유틸리티 클래스
- [[Approval Namespace]] — 승인 프로세스 제어 API
