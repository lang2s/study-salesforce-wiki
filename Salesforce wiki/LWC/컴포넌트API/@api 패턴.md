---
tags: [lwc, api, property, method, getter-setter, pattern]
source: lwc-recipes/apiProperty, apiMethod, apiSetterGetter, apiSpread
created: 2026-05-17
aliases: [@api, api property, api method, lwc:spread]
---

# @api 패턴

> `@api`는 부모 → 자식 데이터 전달(property) 또는 부모에서 자식 메서드 직접 호출(method)에 사용. 외부 공개 인터페이스.

---

## 패턴 1: @api Property (단순 전달)

```javascript
// child.js
import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
    @api firstName;
    @api lastName;

    // @api + getter로 계산 속성 노출
    get fullName() {
        return `${this.firstName} ${this.lastName}`;
    }
}
```

```html
<!-- 부모에서 사용 -->
<c-child first-name={contact.FirstName} last-name={contact.LastName}></c-child>
```

> [!note] HTML 속성명 변환
> `@api firstName` → HTML 속성은 `first-name` (camelCase → kebab-case 자동 변환)

---

## 패턴 2: @api Method (부모 → 자식 명령)

```javascript
// clock.js (자식)
export default class Clock extends LightningElement {
    timestamp = new Date();

    @api
    refresh() {
        this.timestamp = new Date(); // 부모가 명시적으로 호출
    }
}

// apiMethod.js (부모)
export default class ApiMethod extends LightningElement {
    handleRefresh() {
        // querySelector로 자식 참조 후 직접 호출
        this.template.querySelector('c-clock').refresh();
    }
}
```

> [!tip] 언제 @api method?
> 이벤트가 아닌 **명령형 액션**이 필요할 때. 예: 폼 리셋, 타이머 재시작, 데이터 새로고침.

---

## 패턴 3: @api Getter/Setter (Validation + 파생 상태)

```javascript
// todoList.js
export default class TodoList extends LightningElement {
    _todos = []; // private (underscore convention)
    filteredTodos = [];

    @api
    get todos() {
        return this._todos;
    }
    set todos(value) {
        this._todos = value;
        this.filterTodos(); // setter에서 side-effect 처리
    }

    filterTodos() {
        this.filteredTodos = this.priorityFilter
            ? this._todos.filter(t => t.priority)
            : this._todos;
    }
}

// 부모에서 — 반드시 새 배열로 업데이트 (immutable)
this.todos = [...this.todos, newTodo]; // ✅
this.todos.push(newTodo);              // ❌ setter 트리거 안 됨
```

**Getter/Setter를 쓰는 이유:**
- 입력값 유효성 검사
- 파생 상태 동기화 (`filteredTodos`)
- 부수 효과 처리 (로깅, 이벤트 발행 등)

---

## 패턴 4: lwc:spread (다중 @api 한번에 전달)

```javascript
// 부모
export default class ApiSpread extends LightningElement {
    props = { firstName: 'Amy', lastName: 'Taylor' };

    handleChange(event) {
        // spread로 새 객체 생성 → 반응성 보장
        this.props = {
            ...this.props,
            [event.target.name]: event.target.value
        };
    }
}
```

```html
<!-- 부모 템플릿 -->
<c-child lwc:spread={props}></c-child>

<!-- c-child는 @api firstName, @api lastName 선언
     props 객체의 key가 @api 이름에 자동 매핑 -->
```

> props 객체의 key가 자식의 `@api` 이름과 **정확히 일치**해야 함.

---

## @api 규칙

| 규칙 | 이유 |
|---|---|
| @api는 public 인터페이스 | 외부 변경 가능 — 내부 상태는 private |
| Mutation 금지 | `this.apiProp.push(...)` ❌ → 새 객체/배열 생성 |
| Primitive + Object 모두 가능 | 단, 객체 전달 시 deep clone 고려 |
| @api method는 동기/async 모두 가능 | `@api async invoke() { ... }` |

---

## 관련 노트

- [[컴포지션 패턴]]
- [[CustomEvent 패턴]] — 자식 → 부모 방향
