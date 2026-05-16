---
tags: [lwc, javascript, module, shared, pattern]
source: lwc-recipes/mortgage, miscSharedJavaScript
created: 2026-05-17
aliases: [Shared JS, 공유 모듈, ES6 모듈]
---

# 공유 JS 모듈

> 여러 컴포넌트에서 재사용하는 로직을 별도 LWC 컴포넌트에 순수 함수로 작성. HTML 없이 JS만으로 구성.

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

## 관련 노트

- [[ldsUtils reduceErrors]]
- [[Imperative 호출 패턴]]
