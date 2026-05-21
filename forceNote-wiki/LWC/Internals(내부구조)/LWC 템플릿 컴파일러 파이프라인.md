---
tags: [lwc, template-compiler, internals, compiler, AST, static-content-optimization, codegen, parse5]
source: lwc-master/packages/@lwc/template-compiler/src/index.ts, config.ts, parser/parser.ts, codegen/codegen.ts, codegen/optimize.ts, codegen/static-element.ts, shared/types.ts
created: 2026-05-22
aliases: [LWC 템플릿 컴파일러, @lwc/template-compiler, compile() 함수, TemplateCompileResult, RENDER_APIS, static-element optimization, LWC HTML 컴파일, LWC AST]
---

# LWC 템플릿 컴파일러 파이프라인

> `.html` 파일을 LWC 런타임이 실행할 수 있는 JavaScript 모듈로 변환하는 `@lwc/template-compiler` 내부 동작 전체.

**상위:** [[index|Internals(내부구조) index]] → [[LWC MOC]] → [[00 Home]]

---

## 주 API — compile()

```typescript
// template-compiler/src/index.ts
export default function compile(
    source: string,    // .html 파일 내용
    filename: string,  // 파일명 (CSS import 경로 및 scope 토큰 생성에 사용)
    config: Config     // 컴파일 옵션
): TemplateCompileResult
```

```typescript
export interface TemplateCompileResult {
    code: string;                  // 생성된 JS 모듈 코드 (문자열)
    root?: Root;                   // 파싱된 AST root (에러 없으면 존재)
    warnings: CompilerDiagnostic[]; // 경고 및 에러 진단 정보
    cssScopeTokens: string[];      // CSS 스코프 토큰 목록
}
```

---

## 컴파일 파이프라인

```
.html source
    │
    ▼  (1) parseTemplate(source, state)     — @lwc/template-compiler/parser
    │        parse5로 HTML 파싱 → LWC AST 변환
    │        • directive 처리 (lwc:if, lwc:for-each, lwc:key, lwc:ref, lwc:on, ...)
    │        • 식 파싱 (Identifier, MemberExpression, ComplexExpression)
    │        • seenIds / seenSlots 수집
    │        → TemplateParseResult { root, warnings }
    │
    ▼  (2) generate(root, state)            — @lwc/template-compiler/codegen
    │        AST → JavaScript 코드 생성
    │        • static 노드 식별 (getStaticNodes)
    │        • RENDER_APIS 함수 참조 생성 (api_element, api_text, ...)
    │        • optimizeStaticExpressions() — static 객체를 const로 호이스팅
    │        → JS code string
    │
    ▼
 TemplateCompileResult { code, root, warnings, cssScopeTokens }
```

---

## Config 옵션 전체

```typescript
// template-compiler/src/config.ts
export interface Config {
    name?: string;       // 컴포넌트명 (예: "component")
    namespace?: string;  // 컴포넌트 네임스페이스 (예: "c")
    apiVersion?: number; // LWC API 버전

    // ── 기능 토글 ────────────────────────────────────
    enableStaticContentOptimization?: boolean;  // default: true  ← Static content optimization
    enableDynamicComponents?: boolean;          // lwc:is directive 활성화
    enableLwcOn?: boolean;                      // lwc:on directive 활성화
    preserveHtmlComments?: boolean;             // default: false

    // ── 실험적 ──────────────────────────────────────
    experimentalComputedMemberExpression?: boolean;  // {list[0].name} 형태
    experimentalComplexExpressions?: boolean;        // {a ?? b()} 같은 복합 표현식
    experimentalDynamicDirective?: boolean;          // lwc:dynamic (deprecated)

    // ── Shadow DOM ─────────────────────────────────
    disableSyntheticShadowSupport?: boolean;  // Synthetic Shadow 불필요 시 더 작은/빠른 출력 생성

    // ── 기타 ───────────────────────────────────────
    customRendererConfig?: CustomRendererConfig;  // 커스텀 renderer 훅 설정
    instrumentation?: InstrumentationObject;      // 메트릭/로그 수집
}
```

기본값:
| 옵션 | 기본값 |
|---|---|
| `enableStaticContentOptimization` | `true` |
| `experimentalComputedMemberExpression` | `false` |
| `experimentalComplexExpressions` | `false` |
| `enableDynamicComponents` | `false` |
| `enableLwcOn` | `false` |
| `preserveHtmlComments` | `false` |
| `disableSyntheticShadowSupport` | `false` |

---

## RENDER_APIS — 코드 생성 원시 함수 매핑

컴파일러 출력 JS는 엔진의 render API를 import해 사용한다. `RENDER_APIS` 테이블이 단축명과 전체명을 정의한다.

```typescript
// codegen/codegen.ts
const RENDER_APIS = {
    element:               { name: 'h',   alias: 'api_element' },           // 일반 HTML 요소
    customElement:         { name: 'c',   alias: 'api_custom_element' },     // LWC 커스텀 요소
    text:                  { name: 't',   alias: 'api_text' },               // 정적 텍스트
    dynamicText:           { name: 'd',   alias: 'api_dynamic_text' },       // 동적 텍스트 {expr}
    slot:                  { name: 's',   alias: 'api_slot' },               // <slot>
    fragment:              { name: 'fr',  alias: 'api_fragment' },           // 일반 fragment
    staticFragment:        { name: 'st',  alias: 'api_static_fragment' },    // 정적 fragment (최적화)
    staticPart:            { name: 'sp',  alias: 'api_static_part' },        // 정적 블록 내 동적 부분
    iterator:              { name: 'i',   alias: 'api_iterator' },           // for:each / iterator
    flatten:               { name: 'f',   alias: 'api_flatten' },            // array 평탄화
    key:                   { name: 'k',   alias: 'api_key' },               // lwc:key
    bind:                  { name: 'b',   alias: 'api_bind' },               // 이벤트 핸들러 바인딩
    dynamicCtor:           { name: 'dc',  alias: 'api_dynamic_component' },  // lwc:is
    tabindex:              { name: 'ti',  alias: 'api_tab_index' },          // tabindex 정규화
    scopedId:              { name: 'gid', alias: 'api_scoped_id' },          // id 스코핑
    scopedFragId:          { name: 'fid', alias: 'api_scoped_frag_id' },     // fragment id 스코핑
    comment:               { name: 'co',  alias: 'api_comment' },            // HTML 주석
    sanitizeHtmlContent:   { name: 'shc', alias: 'api_sanitize_html_content' },
    scopedSlotFactory:     { name: 'ssf', alias: 'api_scoped_slot_factory' },
    normalizeClassName:    { name: 'ncls', alias: 'api_normalize_class_name' },
};
```

---

## Static Content Optimization (정적 콘텐츠 최적화)

`enableStaticContentOptimization: true` (기본값)일 때, 컴파일러가 정적 노드를 식별해 VDOM diffing 대신 `<template>` / `cloneNode` 방식으로 처리.

### 정적 노드 판별 기준 (isStaticNode)

```typescript
// codegen/static-element.ts — isStaticNode(node, apiVersion)
function isStaticNode(node: BaseElement, apiVersion: APIVersion): boolean {
    // SVG는 구형 API 버전에서 정적 최적화 제외 (CSS scope token 대소문자 문제)
    if (!isAPIFeatureEnabled(APIFeature.LOWERCASE_SCOPE_TOKENS, apiVersion) && namespace !== HTML_NAMESPACE) return false;

    // 반드시 일반 Element여야 함 (커스텀 요소 X)
    result &&= isElement(node);

    // <iframe> 제외 (W-17015807)
    result &&= node.name !== 'iframe';

    // slot 속성 없음 (synthetic shadow, light DOM에서 VDOM이 특수 처리)
    result &&= attributes.every(({ name }) => name !== 'slot');

    // 안전하지 않은 directive 없음
    result &&= !directives.some((d) => !STATIC_SAFE_DIRECTIVES.has(d.name));

    // <input value> / <input checked> 제외 (attr/prop 특수 동작)
    result &&= properties.length === 0;

    return result;
}
```

**정적 최적화 제외 케이스 요약:**
| 케이스 | 이유 |
|---|---|
| 커스텀 요소 (`<my-comp>`) | 동적 lifecycle 필요 |
| `<iframe>` | 보안/특수 동작 |
| `slot` 속성 있는 요소 | synthetic shadow, light DOM에서 VDOM 특수 처리 |
| `<input value>` / `<input checked>` | attribute ≠ property 관계 |
| SVG (구형 API 버전) | CSS scope token 대소문자 문제 |
| 동적 directive (`lwc:if`, `for:each` 등) | 동적 변경 가능 |

### Static 객체 호이스팅 (optimizeStaticExpressions)

```typescript
// codegen/optimize.ts — optimizeStaticExpressions(templateFn)
// 입력:
function tmpl($api) {
    return h('div', { class: { active: true }, style: { color: 'red' } }, [...]);
}

// 출력: 중복 없이 const로 분리
const stc0 = { active: true };
const stc1 = { color: 'red' };
function tmpl($api) {
    return h('div', { class: stc0, style: stc1 }, [...]);
}
```

- 완전 정적인 객체/배열을 `const stcN`으로 호이스팅
- astring으로 직렬화해 중복 제거 (같은 내용이면 동일 const 재사용)

---

## 컴파일 출력 예시

```html
<!-- 입력: myComp.html -->
<template>
    <p class="greeting">Hello, {name}!</p>
    <c-child message={msg}></c-child>
</template>
```

```javascript
// 출력: myComp.html.js (개념적 표현)
import _cChild from 'c/child';
import { registerTemplate } from 'lwc';

const stc0 = { className: 'greeting' };

function tmpl($api, $cmp, $slotset, $ctx) {
    const { t: api_text, h: api_element, d: api_dynamic_text, c: api_custom_element } = $api;

    return [
        api_element('p', stc0, [
            api_text('Hello, '),
            api_dynamic_text($cmp.name),       // {name} → api_dynamic_text
            api_text('!'),
        ]),
        api_custom_element('c-child', _cChild, {
            props: { message: $cmp.msg },       // @api prop binding
        }, []),
    ];
}

export default registerTemplate(tmpl);
tmpl.stylesheets = [];
```

---

## AST 주요 타입

```typescript
// shared/types.ts

// 두 렌더 모드 (lwc:render-mode directive)
export const LWCDirectiveRenderMode = { shadow: 'shadow', light: 'light' };
export const LWCDirectiveDomMode = { manual: 'manual' };

// 노드 타입들
type Root, Element, Text, Comment
type IfBlock, ElseifBlock, ElseBlock
type ForBlock (for:each)
type Slot, Component
type Attribute, Property, EventListener
type RefDirective (lwc:ref)
type OnDirective (lwc:on)

// 식 타입
type Expression = Identifier | MemberExpression   // 단순 식
type ComplexExpression = AcornNode                 // 복합 식 (experimentalComplexExpressions)
```

---

## 관련 노트

- [[LWC 오픈소스 아키텍처]] — @lwc/template-compiler 패키지 역할, 파서별 사용 라이브러리
- [[LWC Shadow DOM 모드]] — disableSyntheticShadowSupport 옵션, isSyntheticShadow 영향
- [[LWC API 버전 관리]] — apiVersion 컴파일 옵션, APIFeature.LOWERCASE_SCOPE_TOKENS
