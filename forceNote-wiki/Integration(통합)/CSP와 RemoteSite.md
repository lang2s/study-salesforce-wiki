---
tags: [security, csp, remote-site, integration, pattern]
source: dreamhouse-lwc/cspTrustedSites, remoteSiteSettings
created: 2026-05-17
aliases: [CSP Trusted Site, Remote Site, 외부 연동 보안]
---

# CSP Trusted Sites & Remote Site Settings

> 외부 서비스를 LWC 또는 Apex에서 사용할 때 반드시 등록해야 하는 두 가지 보안 설정. 미등록 시 브라우저 CSP 차단 또는 callout 오류 발생.

---

## 개념

Salesforce에서 외부 서비스를 연동할 때는 요청이 발생하는 **레이어에 따라 서로 다른 보안 설정**이 필요하다.

**CSP Trusted Site**는 브라우저 레이어에서 동작한다. 브라우저는 기본적으로 Same-Origin Policy에 따라 현재 도메인과 다른 도메인으로의 요청을 차단한다. Salesforce는 여기에 더해 Content Security Policy(CSP) 헤더를 통해 허용 도메인을 명시적으로 제한한다. LWC에서 외부 이미지를 `<img>` 태그로 로드하거나, `fetch()`로 외부 API를 직접 호출하거나, `loadScript()`로 외부 JS를 가져올 때 모두 브라우저가 CSP를 검사한다. 미등록 도메인은 브라우저 콘솔에 `Refused to connect` 에러가 발생한다.

**Remote Site Setting**은 서버 레이어에서 동작한다. Apex의 `Http.send()`는 브라우저가 아닌 Salesforce 서버에서 실행되므로 브라우저 CSP와 무관하다. 대신 Salesforce는 서버에서 나가는 HTTP callout 대상 URL을 허용 목록으로 관리한다. 미등록 URL로 callout을 시도하면 `System.CalloutException: Unauthorized endpoint` 에러가 발생한다.

Named Credential을 통한 callout은 Remote Site Setting 등록이 면제된다. Named Credential 자체가 허용된 엔드포인트를 정의하기 때문이다.

---

## 결정 매트릭스

| 사용 목적 | 필요한 설정 |
|---|---|
| LWC에서 외부 이미지 로드 | CSP Trusted Site (`isApplicableToImgSrc=true`) |
| LWC에서 외부 API 호출 (fetch) | CSP Trusted Site (`isApplicableToConnectSrc=true`) |
| LWC에서 외부 JS 로드 (`loadScript`) | Static Resource 사용 권장 (CSP 우회) |
| Apex에서 외부 HTTP callout | Remote Site Setting |
| Apex + Named Credential | Named Credential만 등록 (Remote Site 불필요) |

---

## CSP Trusted Site 메타데이터

```xml
<!-- cspTrustedSites/openStreetMap.cspTrustedSite-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<CspTrustedSite xmlns="http://soap.sforce.com/2006/04/metadata">
    <context>LEX</context>
    <endpointUrl>https://tile.openstreetmap.org</endpointUrl>
    <isActive>true</isActive>

    <!-- 이미지 src 허용 (img 태그, CSS background-image) -->
    <isApplicableToImgSrc>true</isApplicableToImgSrc>

    <!-- API 호출 허용 (fetch, XMLHttpRequest) -->
    <isApplicableToConnectSrc>false</isApplicableToConnectSrc>

    <!-- 폰트 파일 허용 -->
    <isApplicableToFontSrc>false</isApplicableToFontSrc>

    <!-- iframe 허용 -->
    <isApplicableToFrameSrc>false</isApplicableToFrameSrc>

    <!-- 미디어(video/audio) 허용 -->
    <isApplicableToMediaSrc>false</isApplicableToMediaSrc>

    <!-- 스타일시트 허용 -->
    <isApplicableToStyleSrc>false</isApplicableToStyleSrc>

    <!-- 카메라/마이크 -->
    <canAccessCamera>false</canAccessCamera>
    <canAccessMicrophone>false</canAccessMicrophone>
</CspTrustedSite>
```

### context 값

| 값 | 적용 범위 |
|---|---|
| `LEX` | Lightning Experience (기본) |
| `Communities` | Experience Cloud |
| `All` | LEX + Communities |

---

## Remote Site Setting 메타데이터

```xml
<!-- remoteSiteSettings/nominatim.remoteSite-meta.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<RemoteSiteSetting xmlns="http://soap.sforce.com/2006/04/metadata">
    <disableProtocolSecurity>false</disableProtocolSecurity>
    <isActive>true</isActive>
    <url>https://nominatim.openstreetmap.org</url>
</RemoteSiteSetting>
```

> `disableProtocolSecurity=true` — HTTPS 검증 무시 (프로덕션에서는 절대 사용 금지).

---

## 실제 사용 예 (dreamhouse-lwc)

dreamhouse-lwc의 외부 연동 구조:

```
OpenStreetMap tiles (이미지)
  └── CSP Trusted Site: openStreetMap (isApplicableToImgSrc=true)
  └── Static Resource: leafletjs (JS/CSS — CSP 우회)

Nominatim Geocoding API (Apex callout)
  └── Remote Site Setting: nominatim_openstreetmap
  └── GeocodingService.cls → @InvocableMethod(callout=true)
```

---

## CSP vs Named Credential

| | CSP Trusted Site | Named Credential |
|---|---|---|
| 대상 | LWC (브라우저) | Apex callout |
| 인증 정보 | 없음 | OAuth / Basic Auth |
| URL 방식 | 도메인 등록 | `callout:NC_Name` |
| 관리 위치 | 메타데이터 XML | Setup > Named Credentials |

---

## 주의사항

- **LWC에서 직접 외부 API 호출 시 CORS도 검토** — CSP Trusted Site를 등록해도 외부 서버가 CORS 헤더(`Access-Control-Allow-Origin`)를 응답에 포함하지 않으면 브라우저가 여전히 차단한다. CSP는 Salesforce 측 설정이고 CORS는 외부 서버 측 설정이다.
- **`disableProtocolSecurity=true` 프로덕션 금지** — Remote Site Setting에서 HTTPS 검증을 비활성화하면 중간자 공격에 취약해진다. 테스트 목적으로만 Sandbox에서 사용하고 프로덕션에는 절대 배포하지 않는다.
- **LWC에서 외부 JS 로드** — `loadScript()`로 CDN에서 JS를 직접 로드하면 Locker Service/LWS 제약과 CSP가 함께 작동한다. 외부 JS는 Static Resource로 번들링하는 것이 권장되며, 이 경우 CSP 등록도 불필요하다.
- **Experience Cloud(Communities)** — Context가 `LEX`이면 Experience Cloud 사이트에는 적용되지 않는다. 두 환경 모두 커버하려면 `All`로 설정.
- **URL 범위** — Remote Site Setting의 URL은 정확한 도메인 기반으로 매칭된다. 서브도메인이 다르면 별도 등록이 필요하다.

## 관련 노트

- [[Named Credential]]
- [[RestClient 패턴]]
- [[LWC 보안 패턴]]
- [[Static Resource 로딩]]
