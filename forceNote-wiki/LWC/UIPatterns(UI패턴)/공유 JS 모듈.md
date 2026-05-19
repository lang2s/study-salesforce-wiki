---
tags: [lwc, javascript, module, shared, pattern]
source: lwc-recipes/mortgage, miscSharedJavaScript
created: 2026-05-17
aliases: [Shared JS, 공유 모듈, ES6 모듈]
---

# 공유 JS 모듈

> 여러 컴포넌트에서 재사용하는 로직을 별도 LWC 컴포넌트에 순수 함수로 작성. HTML 없이 JS만으로 구성.

---

## 개념

여러 LWC 컴포넌트가 동일한 계산 로직이나 상수를 각자 정의하면 코드 중복과 불일치가 발생한다. 예를 들어 대출 상환액 계산 공식이 세 곳에 분산되면 수정 시 모두 찾아야 하고, 누락 시 버그가 생긴다.

공유 JS 모듈은 이 문제를 LWC 아키텍처 안에서 해결하는 방법이다. **HTML 파일 없이 JS만 있는 LWC 컴포넌트**를 만들어 순수 함수 라이브러리로 사용한다. LWC는 컴포넌트 기반 import 시스템(`c/모듈명`)을 사용하므로, 별도의 npm 패키지나 Static Resource 없이 동일한 방식으로 공유 로직을 가져올 수 있다.

이 패턴은 ES6 Named Export를 그대로 활용하기 때문에 Tree-shaking이 가능하고, 각 함수는 독립적으로 테스트할 수 있다.

---

## 모듈 정의 (JS만 있는 컴포넌트)

```javascript
// mortgage.js — 비즈니스 로직 순수 함수
const getTermOptions = () => [
    { label: '20 years', value: 20 },
    { label: '25 years', value: 25 },
    { label: '30 years', value: 30 }
];

const calculateMonthlyPayment = (principal, years, rate) => {
    if (!principal || !years || !rate || rate <= 0) return 0;
    const monthlyRate = rate / 100 / 12;
    return (principal * monthlyRate) /
        (1 - Math.pow(1 / (1 + monthlyRate), years * 12));
};

export { getTermOptions, calculateMonthlyPayment };
```

```
lwc/mortgage/
├── mortgage.js          ← 로직만, HTML 없음
└── mortgage.js-meta.xml ← isExposed: false (컴포넌트로 노출 안 함)
```

---

## 사용 (다른 컴포넌트에서 import)

```javascript
// miscSharedJavaScript.js
import { getTermOptions, calculateMonthlyPayment } from 'c/mortgage';

export default class MiscSharedJavaScript extends LightningElement {
    termOptions = getTermOptions(); // 초기화 시 실행

    handleCalculate() {
        this.result = calculateMonthlyPayment(
            this.principal,
            this.term,
            this.rate
        );
    }
}
```

---

## 설계 원칙

| 원칙 | 이유 |
|---|---|
| 순수 함수 | 상태 없음 → 테스트 용이 |
| Named export | 선택적 import 가능 |
| `isExposed: false` | 컴포넌트 팔레트에 노출 안 됨 |
| 도메인별 파일 분리 | `c/mortgage`, `c/ldsUtils`, `c/validationUtils` |

---

## ldsUtils와의 차이

| | `c/mortgage` | `c/ldsUtils` |
|---|---|---|
| 목적 | 도메인 계산 로직 | LDS 에러 정규화 유틸 |
| 사용처 | 특정 도메인 컴포넌트 | 모든 데이터 컴포넌트 |

---

## 제한사항 및 주의사항

- **HTML 파일 불가** — 공유 모듈 컴포넌트에 HTML 파일이 있으면 컴포넌트로 인식되어 렌더링을 시도한다. JS 파일만 포함해야 한다.
- **`isExposed: false` 필수** — `.js-meta.xml`에서 `isExposed`를 `true`로 설정하면 App Builder 팔레트에 노출된다. 공유 모듈은 반드시 `false`로 설정.
- **LWC Security 제약** — 공유 모듈도 일반 LWC와 동일한 Locker Service/Lightning Web Security 제약을 받는다. DOM 조작이나 `window` 전역 객체 접근은 제한될 수 있다.
- **상태(State) 금지** — 모듈 수준 변수에 상태를 저장하면 컴포넌트 간에 의도치 않게 공유될 수 있다. 순수 함수만 export하고 모듈 수준 상태는 두지 않는다.
- **네이밍 충돌** — 같은 이름의 함수를 여러 모듈에서 export하면 import 시 별칭(`as`)으로 구분해야 한다.

## 관련 노트

- [[ldsUtils reduceErrors]]
- [[Imperative 호출 패턴]]
