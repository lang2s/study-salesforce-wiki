---
tags: [lwc, internals, index]
created: 2026-05-22
---

# LWC Internals(내부구조) — 폴더 인덱스

> LWC 오픈소스 프레임워크(salesforce/lwc) 소스코드 기반 내부 구조 분석.  
> 소스: `lwc-master/` (Tier 1 — 로컬 소스 직접 발췌)

**상위:** [[LWC MOC]] → [[00 Home]]

---

| 파일 | 설명 |
|---|---|
| [[LWC 오픈소스 아키텍처]] | 패키지 전체 구조 — Compiler/Runtime/SSR 분리 설계 |
| [[@api 데코레이터 내부 구조]] | `createPublicPropertyDescriptor`, vm.cmpProps, 반응성 연결 |
| [[@track 데코레이터 내부 구조]] | `internalTrackDecorator`, vm.cmpFields, observable-membrane proxy |
| [[LWC VM 내부 구조]] | VM 인터페이스 전체 필드, VMState/RenderMode/ShadowMode enum |
| [[@wire 어댑터 내부 구조]] | WireAdapter 인터페이스, createConnector, configWatcher, legacy API |
| [[LWC Signals]] | Signal 인터페이스, SignalBaseClass, addTrustedSignal, ENABLE_EXPERIMENTAL_SIGNALS |
| [[LWC 런타임 Feature Flags]] | 13개 플래그 전체 목록, setFeatureFlag, lwcRuntimeFlags 글로벌 |
