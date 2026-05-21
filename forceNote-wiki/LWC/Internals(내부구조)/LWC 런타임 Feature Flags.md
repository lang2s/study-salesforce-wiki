---
tags: [lwc, features, feature-flags, internals, lwcRuntimeFlags, setFeatureFlag, runtime-flags]
source: lwc-master/packages/@lwc/features/src/index.ts, types.ts
created: 2026-05-22
aliases: [LWC Feature Flags, lwcRuntimeFlags, setFeatureFlag, setFeatureFlagForTest, DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE, ENABLE_WIRE_SYNC_EMIT, DISABLE_SYNTHETIC_SHADOW, ENABLE_EXPERIMENTAL_SIGNALS, LWC 런타임 플래그, @lwc/features]
---

# LWC 런타임 Feature Flags (@lwc/features)

> `lwcRuntimeFlags` 글로벌 객체로 제어하는 LWC 런타임 동작 플래그 전체 목록과 사용법.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## FeatureFlagValue — 세 가지 상태

```typescript
// features/src/types.ts
export type FeatureFlagValue = boolean | null;
```

| 값 | 의미 | 런타임 변경 |
|---|---|---|
| `null` | 기능 있음, **기본 비활성** | `setFeatureFlag()`로 활성화 가능 |
| `true` | 기능 있음, **항상 활성** (빌드 타임 하드코딩) | 변경 불가 |
| `false` | **완전 비활성** — 관련 코드가 번들에서 제거됨 | 변경 불가 |

기본값은 모든 플래그가 `null`이다.

---

## 플래그 전체 목록

```typescript
// features/src/types.ts — FeatureFlagMap
```

| 플래그 이름 | 설명 |
|---|---|
| `PLACEHOLDER_TEST_FLAG` | 플래그 동작 테스트용 더미 (내부용) |
| `DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE` | `true`이면 네이티브 커스텀 엘리먼트 생명주기를 비활성화하고 합성(synthetic) 생명주기 사용 |
| `ENABLE_WIRE_SYNC_EMIT` | `true`이면 `@wire` 어댑터 `update()`를 컴포넌트 connect 직후 동기로 호출 (기본: 다음 tick) |
| `DISABLE_LIGHT_DOM_UNSCOPED_CSS` | Light DOM에서 스코프 없는 CSS를 비활성화 |
| `ENABLE_FROZEN_TEMPLATE` | `true`이면 HTML 파일에서 import한 template 객체가 frozen (수정 시 에러) |
| `ENABLE_LEGACY_SCOPE_TOKENS` | `true`이면 구형 CSS 스코프 토큰을 현대 토큰과 함께 렌더링 (하위 호환용) |
| `ENABLE_FORCE_SHADOW_MIGRATE_MODE` | `true`이면 Shadow DOM 마이그레이션 모드를 전역 강제 활성화 |
| `ENABLE_EXPERIMENTAL_SIGNALS` | `true`이면 Signal 반응성 추적 활성화 (**실험적, 프로덕션 사용 금지**) |
| `DISABLE_SYNTHETIC_SHADOW` | `true`이면 `@lwc/synthetic-shadow`가 로드되어 있어도 무시하고 네이티브 Shadow 모드로 실행 |
| `DISABLE_HOST_ATTACH_SHADOW_GUARD` | `true`이면 합성 shadow를 사용하는 LWC 호스트 엘리먼트에 `attachShadow` 호출 차단 가드를 비활성화 |
| `DISABLE_SCOPE_TOKEN_VALIDATION` | `true`이면 stylesheet scope token 내용 검증을 건너뜀 |
| `DISABLE_STRICT_VALIDATION` | `true`이면 레거시 생성자 참조 동등성 검사 사용 (기본: strict 검사) |
| `DISABLE_DETACHED_REHYDRATION` | `true`이면 DOM에서 분리된 엘리먼트의 리하이드레이션을 건너뜀 |

---

## 주요 API

### setFeatureFlag() — 앱 초기화 시 사용

```typescript
import { setFeatureFlag } from '@lwc/features';

// 앱 진입점에서 1회만 호출
setFeatureFlag('DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE', true);
setFeatureFlag('ENABLE_WIRE_SYNC_EMIT', true);
```

**제약:**
- `boolean`만 허용 (non-boolean → 프로덕션에서 `console.error`, dev에서 `TypeError`)
- 알 수 없는 플래그명 → `console.info` 로그 후 NOOP
- **프로덕션**: 동일 플래그를 두 번 설정하면 에러 (`defineProperty`로 불변 처리)
- **dev/test**: 동일 플래그 재설정 허용

### setFeatureFlagForTest() — 테스트 전용

```typescript
import { setFeatureFlagForTest } from '@lwc/features';

// 프로덕션에서는 no-op
setFeatureFlagForTest('ENABLE_WIRE_SYNC_EMIT', true);
```

---

## lwcRuntimeFlags 글로벌

```typescript
// features/src/index.ts
if (!(globalThis as any).lwcRuntimeFlags) {
    Object.defineProperty(globalThis, 'lwcRuntimeFlags', { value: create(null) });
}

const flags: Partial<FeatureFlagMap> = (globalThis as any).lwcRuntimeFlags;

export {
    flags as runtimeFlags,    // 하위 호환 이름
    flags as lwcRuntimeFlags, // 현재 이름
};
```

엔진 내부에서는 `lwcRuntimeFlags` 글로벌을 직접 읽어 플래그를 확인한다.

```typescript
// 엔진 내부 사용 예 (vm.ts)
if (lwcRuntimeFlags.DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE) {
    // synthetic lifecycle 경로
}

// @wire 내부 (wiring.ts)
if (!lwcRuntimeFlags.ENABLE_WIRE_SYNC_EMIT) {
    if (hasDynamicParams) {
        Promise.resolve().then(computeConfigAndUpdate); // micro-task
        return;
    }
}
```

---

## 플래그 조합 사용 예 — 합성 Shadow 비활성화

```javascript
// 모든 컴포넌트를 네이티브 Shadow DOM으로 실행
setFeatureFlag('DISABLE_SYNTHETIC_SHADOW', true);
```

이 경우 `@lwc/synthetic-shadow`가 페이지에 로드되어 있어도 무시된다.

---

## 프로덕션 vs dev 동작 차이

| 동작 | dev | 프로덕션 |
|---|---|---|
| non-boolean 값 설정 | `TypeError` throw | `console.error` + return |
| 알 수 없는 플래그 | `console.info` + NOOP | `console.info` + NOOP |
| 같은 플래그 재설정 | 허용 (덮어씀) | `console.error` + `defineProperty` (불변) |
| `setFeatureFlagForTest()` | 동작 | NOOP |

---

## 관련 노트

- [[LWC Signals]] — ENABLE_EXPERIMENTAL_SIGNALS 플래그로 활성화
- [[@wire 어댑터 내부 구조]] — ENABLE_WIRE_SYNC_EMIT 동작
- [[LWC 오픈소스 아키텍처]] — @lwc/features 패키지 역할 (공유 패키지)
- [[LWC VM 내부 구조]] — DISABLE_NATIVE_CUSTOM_ELEMENT_LIFECYCLE 사용 위치
