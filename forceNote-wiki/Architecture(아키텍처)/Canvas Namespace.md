---
tags: [apex, namespace, canvas, canvas-app, lifecycle, embedded-app, architecture]
source: salesforce_apex_reference_guide.pdf p.279-298
created: 2026-05-20
aliases: [Canvas, Canvas Namespace, 캔버스 앱 Apex, CanvasLifecycleHandler, RenderContext, ApplicationContext Canvas, EnvironmentContext Canvas]
---

# Canvas Namespace

> Salesforce에 외부 웹 앱(Canvas App)을 임베드할 때 사용하는 Apex 인터페이스 모음 — `CanvasLifecycleHandler`로 렌더 시점 커스터마이즈, `RenderContext`로 앱·환경 컨텍스트 정보를 읽고 수정한다.

---

## 구성 요소 요약

| 클래스 / 인터페이스 | 유형 | 역할 |
|---|---|---|
| `Canvas.CanvasLifecycleHandler` | Interface (구현 필요) | 렌더 단계 커스터마이즈 — `excludeContextTypes` + `onRender` |
| `Canvas.ApplicationContext` | Interface (기본 구현 제공) | Canvas 앱의 URL·이름·버전·네임스페이스 조회 |
| `Canvas.EnvironmentContext` | Interface (기본 구현 제공) | 앱 표시 위치, 커스텀 파라미터, 엔티티 필드 설정 |
| `Canvas.RenderContext` | Interface (기본 구현 제공) | ApplicationContext + EnvironmentContext 래퍼 |
| `Canvas.Test` | Class (static) | 테스트용 mock RenderContext 생성, 라이프사이클 호출 |
| `Canvas.ContextTypeEnum` | Enum | 컨텍스트 제외 대상 지정 (ORGANIZATION/RECORD_DETAIL/USER) |
| `Canvas.CanvasRenderException` | Exception | `onRender()` 내부에서 사용자에게 에러 표시 |

---

## Canvas.CanvasLifecycleHandler Interface

렌더 단계를 제어하는 핵심 인터페이스. **두 메서드를 모두 구현**해야 한다.

```apex
public Set<Canvas.ContextTypeEnum> excludeContextTypes()
// 비활성화할 컨텍스트 타입 Set 반환; null 반환 시 모든 컨텍스트 포함(기본값)

public void onRender(Canvas.RenderContext renderContext)
// 앱 렌더 시점에 호출; renderContext에서 ApplicationContext/EnvironmentContext 접근
```

### 전체 구현 예제

```apex
public class MyCanvasListener implements Canvas.CanvasLifecycleHandler {

    // ORGANIZATION 컨텍스트를 제외 → 서명 요청 크기 절감
    public Set<Canvas.ContextTypeEnum> excludeContextTypes() {
        Set<Canvas.ContextTypeEnum> excluded = new Set<Canvas.ContextTypeEnum>();
        excluded.add(Canvas.ContextTypeEnum.ORGANIZATION);
        return excluded;
    }

    public void onRender(Canvas.RenderContext renderContext) {
        Canvas.ApplicationContext app = renderContext.getApplicationContext();

        // 네임스페이스로 앱 확인
        if (!'MyNamespace'.equals(app.getNamespace())) {
            // ...
        }

        // 버전에 따라 URL 재지정
        Double currentVersion = Double.valueOf(app.getVersion());
        if (currentVersion <= 5) {
            app.setCanvasUrlPath('/canvas?deprecated=true');
        }

        // 환경 컨텍스트에 커스텀 파라미터 추가
        Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();
        Map<String, Object> params = (Map<String, Object>)
            JSON.deserializeUntyped(env.getParametersAsJSON());
        params.put('param1', 1);
        params.put('param2', 3.14159);
        env.setParametersAsJSON(JSON.serialize(params));
    }
}
```

---

## Canvas.ApplicationContext Interface

Canvas 앱의 앱 레벨 메타데이터를 조회하는 인터페이스. Salesforce 기본 구현 사용 — 직접 구현 불필요.

```apex
public String getCanvasUrl()        // 앱의 완전 수식 URL
public String getDeveloperName()    // 앱 API 이름 (Connected App의 API Name 필드)
public String getName()             // 앱 표시 이름
public String getNamespace()        // 앱과 연결된 Salesforce 네임스페이스 접두사
public String getVersion()          // 앱 현재 버전 (Developer Edition org에서는 항상 최신)
public void setCanvasUrlPath(String newPath)
// 현재 요청에 한해 앱 URL 경로 재지정 (도메인 제외한 경로만; 2048자 초과 시 System.CanvasException)
```

---

## Canvas.EnvironmentContext Interface

앱이 표시되는 환경(위치, 파라미터, 엔티티 필드)을 제어한다.

```apex
// 엔티티 필드 설정 (Visualforce 페이지에 배치된 canvas 앱에서 Record 정보 포함)
public void addEntityField(String fieldName)             // 단일 필드 추가 ('*' → 권한 있는 전체)
public void addEntityFields(Set<String> fieldNames)      // 복수 필드 추가
public List<String> getEntityFields()                    // 현재 필드 목록 조회

// 위치 정보
public String getDisplayLocation()
// 반환값: Chatter | ChatterFeed | MobileNav | OpenCTI | PageLayout |
//         Publisher | ServiceDesk | Visualforce | None

public String getSublocation()
// 반환값 (모바일): S1MobileCardFullview | S1MobileCardPreview |
//                  S1RecordHomePreview | S1RecordHomeFullview

public String getLocationUrl()      // 앱이 호출된 페이지 URL

// 커스텀 파라미터 (JSON 직렬화)
public String getParametersAsJSON()                // 현재 커스텀 파라미터 JSON 문자열 반환
public void setParametersAsJSON(String jsonString) // 커스텀 파라미터 교체 (32KB 초과 시 System.CanvasException)
```

### 엔티티 필드 + 파라미터 조작 예제

```apex
public void onRender(Canvas.RenderContext renderContext) {
    Canvas.EnvironmentContext env = renderContext.getEnvironmentContext();

    // Account 레코드에서 Name, BillingAddress 필드 포함
    env.addEntityFields(new Set<String>{'Name', 'BillingAddress'});

    // 커스텀 파라미터에 Opportunity 레코드 추가
    Map<String, Object> params = (Map<String, Object>)
        JSON.deserializeUntyped(env.getParametersAsJSON());
    Opportunity[] opps = [SELECT id, name FROM Opportunity];
    params.put('opportunities', opps);
    env.setParametersAsJSON(JSON.serialize(params));
}
```

---

## Canvas.RenderContext Interface

`ApplicationContext`와 `EnvironmentContext`를 감싸는 래퍼. `onRender(renderContext)` 파라미터로 전달된다.

```apex
public Canvas.ApplicationContext getApplicationContext()
public Canvas.EnvironmentContext getEnvironmentContext()
```

---

## Canvas.ContextTypeEnum Enum

`excludeContextTypes()`에서 반환할 비활성화 대상 컨텍스트 타입.

| 값 | 설명 |
|---|---|
| `ORGANIZATION` | 캔버스 앱이 실행 중인 조직 정보 제외 |
| `RECORD_DETAIL` | 앱이 표시되는 오브젝트 레코드 정보 제외 |
| `USER` | 현재 사용자 정보 제외 |

> 불필요한 컨텍스트를 제외하면 서명 요청 크기가 줄고 성능이 향상된다.

---

## Canvas.Test Class — 단위 테스트

`CanvasLifecycleHandler` 구현을 실제 캔버스 앱 없이 테스트한다.

### Test 상수 (mockRenderContext 파라미터 키)

| 상수 | 대응 컨텍스트 |
|---|---|
| `KEY_CANVAS_URL` | ApplicationContext.getCanvasUrl() |
| `KEY_DEVELOPER_NAME` | ApplicationContext.getDeveloperName() |
| `KEY_NAME` | ApplicationContext.getName() |
| `KEY_NAMESPACE` | ApplicationContext.getNamespace() |
| `KEY_VERSION` | ApplicationContext.getVersion() |
| `KEY_DISPLAY_LOCATION` | EnvironmentContext.getDisplayLocation() |
| `KEY_LOCATION_URL` | EnvironmentContext.getLocationUrl() |
| `KEY_SUB_LOCATION` | EnvironmentContext.getSublocation() |

### Test 메서드

```apex
// mock RenderContext 생성
public static Canvas.RenderContext mockRenderContext(
    Map<String,String> applicationContextTestValues,  // null → 기본 mock 값 사용
    Map<String,String> environmentContextTestValues)  // null → 기본 mock 값 사용

// CanvasLifecycleHandler.onRender() 호출
public static Void testCanvasLifecycle(
    Canvas.CanvasLifecycleHandler lifecycleHandler,
    Canvas.RenderContext mockRenderContext)            // null → 기본 mock RenderContext 사용
```

### 전체 테스트 예제

```apex
@IsTest
global class CanvasRendercontextTest {
    @IsTest
    static void testRenderContext() {
        Map<String,String> appValues = new Map<String,String>();
        appValues.put(Canvas.Test.KEY_NAMESPACE, 'alternateNamespace');
        appValues.put(Canvas.Test.KEY_VERSION, '3.0');

        Map<String,String> envValues = new Map<String,String>();
        envValues.put(Canvas.Test.KEY_DISPLAY_LOCATION, 'Chatter');

        Canvas.RenderContext mock = Canvas.Test.mockRenderContext(appValues, envValues);
        mock.getEnvironmentContext().setParametersAsJSON(
            '{"param1":1,"boolParam":true,"stringParam":"test string"}');

        MyCanvasListener handler = new MyCanvasListener();
        Canvas.Test.testCanvasLifecycle(handler, mock);
    }
}
```

---

## Canvas.CanvasRenderException

`onRender()` 내부에서 사용자에게 에러를 표시할 때 사용한다. **`onRender()` 안에서만 관리되며 외부로 전파되지 않는다.**

```apex
public void onRender(Canvas.RenderContext renderContext) {
    Canvas.ApplicationContext app = renderContext.getApplicationContext();
    try {
        app.setCanvasUrlPath(aUrlPathThatIsTooLong);
    } catch (CanvasException e) {
        throw new Canvas.CanvasRenderException(e.getMessage());
    }
}
```

---

## 관련 노트

- [[Apex MOC]]
- [[ApexPages Namespace]] — Visualforce 컨트롤러에서 canvas 앱을 `<apex:canvasApp>`으로 표시
- [[VisualEditor Namespace]] — Lightning App Builder 동적 피클리스트 (다른 UI 프레임워크 확장)
