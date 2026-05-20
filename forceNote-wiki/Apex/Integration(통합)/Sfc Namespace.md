---
tags: [apex, namespace, sfc, salesforce-files, content-download, irm, files-security]
source: salesforce_apex_reference_guide.pdf v67.0 — Sfc Namespace (doc p.3554–3557)
created: 2026-05-21
aliases: [Sfc Namespace, Sfc apex, salesforce files apex, ContentDownloadHandler, ContentDownloadHandlerFactory, ContentDownloadContext, 파일 다운로드 커스터마이징 Apex, IRM 파일 제어 Apex]
---

# Sfc Namespace

> Salesforce Files 콘텐츠 다운로드 동작을 Apex로 커스터마이징하는 네임스페이스 — 다운로드 허용/차단, IRM 제어, 리디렉션 URL 설정

---

## 개요

`Sfc` 네임스페이스는 **Salesforce Files의 다운로드 경험을 커스터마이징**하는 클래스를 제공한다.

- `ContentDownloadHandlerFactory` 인터페이스를 구현해 다운로드 핸들러 클래스 팩토리 등록
- 파일 ID 목록과 다운로드 컨텍스트(모바일, Chatter 등)를 기반으로 다운로드 허용·차단·리디렉션 제어
- IRM(Information Rights Management), 바이러스 스캐닝 등 다운로드 차단 시나리오에서 활용

### 클래스 목록

| 클래스 / 인터페이스 / 열거형 | 설명 |
|---|---|
| `ContentDownloadContext` | 다운로드 컨텍스트를 나타내는 열거형 (7개 값) |
| `ContentDownloadHandler` | 커스텀 다운로드 핸들러 — 허용 여부, 오류 메시지, 리디렉션 URL 설정 |
| `ContentDownloadHandlerFactory` | `ContentDownloadHandler` 인스턴스를 생성하는 팩토리 인터페이스 |

---

## ContentDownloadContext (Enum)

다운로드가 발생하는 컨텍스트를 나타낸다. 팩토리 메서드의 `context` 파라미터로 수신된다.

### 열거값

| 값 | 설명 |
|---|---|
| `CHATTER` | Chatter에서 다운로드 |
| `CONTENT` | 기본값. Salesforce CRM Content 제품에서 다운로드 |
| `DELIVERY` | Content Delivery 다운로드 |
| `REST_API` | Connect API(`/connect/files/${fileId}/content`)를 통한 다운로드. Android·iOS 앱 모두 사용 |
| `RETRIEVE` | SObject API에서 VersionData 조회 |
| `S1` | Lightning Experience에서 다운로드 |
| `SOQL` | SOQL로 VersionData 조회 |

> **참고:** `CONTENT`, `CHATTER`, `DELIVERY`, `S1`, `MOBILE`은 shepherd servlet 쿼리 파라미터로 사용할 수 있다(사용자가 변경 가능). `REST_API`, `SOQL`, `RETRIEVE`는 쿼리 파라미터로 설정 불가하므로 코드에서 정확한 값으로 취급해도 안전하다.

---

## ContentDownloadHandler (Class)

다운로드 허용 여부와 차단 시 동작(오류 메시지 또는 리디렉션)을 제어하는 클래스.

### 프로퍼티

| 프로퍼티 | 타입 | 설명 |
|---|---|---|
| `downloadErrorMessage` | String | 다운로드가 불허될 때 표시할 커스텀 오류 메시지. `redirectUrl`이 없을 때 사용. 다운로드 불허 시 Salesforce는 `ContentCustomizedDownloadException` 예외를 던지며 이 메시지를 포함한다. |
| `isDownloadAllowed` | Boolean | 다운로드 허용 여부 |
| `redirectUrl` | String | 다운로드가 불허될 때 리디렉션할 URL. IRM 제어·바이러스 스캐닝 등에 활용. **반드시 유효한 상대 URL이어야 함** (예: `/apex/IRMControl`). 도메인만 있는 URL(`www.domain.com`)은 `InvalidParameterValueException` 발생. |

---

## ContentDownloadHandlerFactory (Interface)

Salesforce가 호출해 `ContentDownloadHandler` 인스턴스를 생성하는 팩토리 인터페이스.

### 메서드

```apex
public Sfc.ContentDownloadHandler getContentDownloadHandler(List<Id> var1, Sfc.ContentDownloadContext var2)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `var1` | List\<Id\> | 다운로드 대상 콘텐츠 ID 목록 |
| `var2` | Sfc.ContentDownloadContext | 다운로드 컨텍스트 |

반환: `Sfc.ContentDownloadHandler`

---

## 구현 예시

모바일 기기에서의 파일 다운로드를 차단하는 팩토리 구현:

```apex
// Allow customization of the content Download experience
public class ContentDownloadHandlerFactoryImpl implements Sfc.ContentDownloadHandlerFactory {
    public Sfc.ContentDownloadHandler getContentDownloadHandler(
            List<ID> ids, Sfc.ContentDownloadContext context) {
        Sfc.ContentDownloadHandler contentDownloadHandler = new Sfc.ContentDownloadHandler();
        if (context == Sfc.ContentDownloadContext.MOBILE) {
            contentDownloadHandler.isDownloadAllowed = false;
            contentDownloadHandler.downloadErrorMessage =
                'Downloading a file from a mobile device is not allowed.';
            return contentDownloadHandler;
        }
        contentDownloadHandler.isDownloadAllowed = true;
        return contentDownloadHandler;
    }
}
```

---

## 관련 노트

- [[ConnectApi Namespace 개요]] — Connect API 파일 엔드포인트(`/connect/files/`) 관련 (ContentDownloadContext.REST_API)
