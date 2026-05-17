---
tags: [apex, dom, xml, namespace, document, xmlnode]
source: salesforce_apex_reference_guide (Version 67.0, Summer '26)
created: 2026-05-17
aliases: [Dom Namespace, Dom.Document, Dom.XmlNode, XML 파싱, XML 생성, Dom XML]
---

# Dom Namespace

> Apex에서 XML 콘텐츠를 생성하고 파싱하는 DOM API — `Dom.Document`와 `Dom.XmlNode`로 HTTP 요청/응답 본문을 처리한다.

---

## Dom.Document — XML 문서 루트

```apex
// XML 생성
Dom.Document doc = new Dom.Document();
Dom.XmlNode root = doc.createRootElement('Request', 'http://example.com/ns', 'ex');
Dom.XmlNode child = root.addChildElement('Item', null, null);
child.addTextNode('SomeValue');
child.setAttribute('id', '123');

String xmlBody = doc.toXmlString();
// → <ex:Request xmlns:ex="http://example.com/ns"><Item id="123">SomeValue</Item></ex:Request>

// XML 파싱 (HTTP Response 본문 파싱 패턴)
HttpResponse res = new Http().send(req);
Dom.Document resDoc = new Dom.Document();
resDoc.load(res.getBody());
Dom.XmlNode resRoot = resDoc.getRootElement();
```

### Document 메서드

| 메서드 | 설명 |
|---|---|
| `createRootElement(name, namespace, prefix)` | 루트 요소 생성 (문서당 한 번만 호출 가능) |
| `getRootElement()` | 루트 노드 반환 — 미생성이면 null |
| `load(xml)` | XML 문자열을 파싱하여 문서 로드 |
| `toXmlString()` | 문서를 XML 문자열로 직렬화 |

---

## Dom.XmlNode — 개별 노드 조작

```apex
Dom.XmlNode root = doc.getRootElement();

// 자식 요소 추가
Dom.XmlNode item = root.addChildElement('Product', null, null);
item.addTextNode('Widget');
item.setAttribute('code', 'P001');

// 자식 탐색
Dom.XmlNode found = root.getChildElement('Product', null);
List<Dom.XmlNode> allChildren = root.getChildElements(); // 요소 노드만
List<Dom.XmlNode> allNodes   = root.getChildren();       // 텍스트·주석 포함

// 속성 읽기
String val  = found.getAttribute('code', null);        // → P001 (접두어 포함값)
String valNs = found.getAttributeValue('code', null);  // → P001 (접두어 제외값)

// 텍스트, 이름, 타입
String text     = found.getText();      // → Widget
String name     = found.getName();      // → Product
String ns       = found.getNamespace();
Dom.XmlNodeType t = found.getNodeType(); // ELEMENT | TEXT | COMMENT

// 노드 삽입 / 제거
root.insertBefore(newChild, refChild);   // refChild 앞에 삽입
root.removeChild(item);
root.removeAttribute('code', null);
```

### XmlNode 메서드 요약

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `addChildElement(name, ns, prefix)` | `Dom.XmlNode` | 자식 요소 추가 |
| `addTextNode(text)` | `Dom.XmlNode` | 텍스트 노드 추가 |
| `addCommentNode(comment)` | `Dom.XmlNode` | 주석 노드 추가 |
| `getAttribute(key, keyNs)` | `String` | 속성값 (prefix:value 형태) |
| `getAttributeValue(key, keyNs)` | `String` | 속성값 (prefix 제외) |
| `getAttributeValueNs(key, keyNs)` | `String` | 속성값 네임스페이스 |
| `getChildElement(name, ns)` | `Dom.XmlNode` | 지정 이름 자식 요소 |
| `getChildElements()` | `Dom.XmlNode[]` | 요소 노드 자식 목록 |
| `getChildren()` | `Dom.XmlNode[]` | 모든 자식 노드 (TEXT 포함) |
| `getName()` | `String` | 요소 이름 |
| `getNamespace()` | `String` | 요소 네임스페이스 |
| `getNamespaceFor(prefix)` | `String` | 접두어의 네임스페이스 |
| `getPrefixFor(namespace)` | `String` | 네임스페이스의 접두어 |
| `getNodeType()` | `Dom.XmlNodeType` | ELEMENT / TEXT / COMMENT |
| `getParent()` | `Dom.XmlNode` | 부모 노드 |
| `getText()` | `String` | 노드 텍스트 |
| `insertBefore(newChild, refChild)` | `Dom.XmlNode` | 특정 노드 앞에 삽입 |
| `removeChild(child)` | `Boolean` | 자식 노드 제거 |
| `removeAttribute(key, keyNs)` | `Boolean` | 속성 제거 |
| `setAttribute(key, value)` | `void` | 속성 설정 |
| `setNamespace(prefix, ns)` | `void` | 네임스페이스 설정 |

---

## Dom.XmlNodeType Enum

| 값 | 설명 |
|---|---|
| `ELEMENT` | 요소 노드 (`<tag>`) |
| `TEXT` | 텍스트 노드 |
| `COMMENT` | 주석 노드 (`<!-- -->`) |

---

## HTTP 연동 전체 패턴 (SOAP-like XML)

```apex
// 요청 XML 생성
Dom.Document reqDoc = new Dom.Document();
Dom.XmlNode env = reqDoc.createRootElement(
    'Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv'
);
Dom.XmlNode body = env.addChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
Dom.XmlNode method = body.addChildElement('GetAccount', 'http://api.example.com/', 'api');
method.addChildElement('AccountId', 'http://api.example.com/', 'api').addTextNode(accId);

HttpRequest req = new HttpRequest();
req.setEndpoint('callout:MyNC/api/soap');
req.setMethod('POST');
req.setHeader('Content-Type', 'text/xml');
req.setBody(reqDoc.toXmlString());

// 응답 XML 파싱
HttpResponse res = new Http().send(req);
Dom.Document resDoc = new Dom.Document();
resDoc.load(res.getBody());
Dom.XmlNode resRoot = resDoc.getRootElement();
String accountName = resRoot
    .getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/')
    .getChildElement('GetAccountResponse', 'http://api.example.com/')
    .getChildElement('Name', 'http://api.example.com/')
    .getText();
```

---

## 제약

- 중첩 노드 최대 **50단계** 깊이
- `createRootElement()` 는 문서당 **한 번만** 호출 가능 (두 번 호출 시 오류)

---

## 관련 노트

- [[RestClient 패턴]] — HTTP 호출에서 이 XML 본문을 사용
- [[Custom REST Endpoint]] — 인바운드 XML 요청 처리
- [[Search Namespace]] — SOSL 기반 동적 검색 (XML 아닌 Apex API)
