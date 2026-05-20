---
tags: [apex, compression, namespace, zip, zipwriter, zipreader, zipentry, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — Compression Namespace (p.646~660)
created: 2026-05-18
aliases: [Compression Namespace, ZipWriter, ZipReader, ZipEntry, Apex Zip, 압축, zip 파일, 첨부파일 압축, Compression.ZipWriter, Compression.ZipReader]
---

# Compression Namespace

> Apex 네이티브 Zip 압축·해제 라이브러리. Spring '25에 GA. ZipWriter로 생성, ZipReader로 추출.

---

## 클래스 목록

| 클래스/Enum | 설명 |
|---|---|
| `ZipWriter` | Zip 아카이브 생성 및 항목 추가 |
| `ZipReader` | Zip 파일에서 항목 조회 및 내용 추출 |
| `ZipEntry` | Zip 항목 정보 조회·설정 |
| `Level` Enum | 압축 수준 (BEST_COMPRESSION / BEST_SPEED / DEFAULT_LEVEL / NO_COMPRESSION) |
| `Method` Enum | 압축 방식 (DEFLATED / STORED) |
| `ZipException` | Compression 네임스페이스 예외 클래스 |

---

## ZipWriter — 압축 파일 생성

### 핵심 메서드

```apex
Compression.ZipWriter writer = new Compression.ZipWriter();

// 항목 추가 — 이름 + Blob 내용
Compression.ZipEntry entry = writer.addEntry('reports/q1.csv', csvBlob);

// 항목 추가 — 상세 옵션 포함
writer.addEntry(
    'readme.txt',                      // name
    '분기 보고서 첨부',                 // comment
    DateTime.now(),                    // modTime
    Compression.Method.DEFLATED,       // method
    txtBlob                            // data
);

// 압축 완료 → Blob 반환
Blob zipBlob = writer.getArchive();
```

### 실전 예제 — ContentVersion 파일을 Zip으로 묶어 이메일 첨부

```apex
Compression.ZipWriter writer = new Compression.ZipWriter();
List<Id> contentDocumentIds = new List<Id>();
// contentDocumentIds에 압축할 파일 ID 추가

for (ContentVersion cv : [SELECT PathOnClient, VersionData
                           FROM ContentVersion
                           WHERE ContentDocumentId IN :contentDocumentIds]) {
    writer.addEntry(cv.PathOnClient, cv.VersionData);
}
Blob zipAttachment = writer.getArchive();

Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
efa.setFileName('attachments.zip');
efa.setBody(zipAttachment);

Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
email.setFileAttachments(new List<Messaging.EmailFileAttachment>{ efa });
Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ email });
```

### ZipWriter 메서드 전체

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `addEntry(name, data)` | `ZipEntry` | 이름 + Blob으로 항목 추가 |
| `addEntry(prototype)` | `ZipEntry` | ZipEntry 복사로 항목 추가 |
| `addEntry(name, comment, modTime, method, data)` | `ZipEntry` | 상세 옵션으로 항목 추가 |
| `getArchive()` | `Blob` | 압축 아카이브 생성 반환 |
| `getEntries()` | `List<ZipEntry>` | 모든 항목 목록 |
| `getEntry(name)` | `ZipEntry` | 이름으로 항목 조회 |
| `getEntryNames()` | `Set<String>` | 모든 항목 이름 Set |
| `getLevel()` | `Compression.Level` | 현재 압축 수준 |
| `getMethod()` | `Compression.Method` | 현재 압축 방식 |
| `removeEntry(name)` | `Void` | 이름으로 항목 제거 (없으면 ZipException) |
| `setLevel(level)` | `Compression.ZipWriter` | 압축 수준 설정 (fluent 반환) |
| `setMethod(method)` | `Compression.ZipWriter` | 압축 방식 설정 (fluent 반환) |

---

## ZipReader — 압축 파일 해제

### 핵심 메서드

```apex
// Blob에서 ZipReader 생성
Compression.ZipReader reader = new Compression.ZipReader(zipBlob);

// 전체 항목 이름 목록
List<String> names = reader.getEntryNames();

// 특정 항목 추출 — 이름으로
Blob content = reader.extract('translations/fr.json');

// 특정 항목 추출 — ZipEntry로
Compression.ZipEntry entry = reader.getEntry('data.csv');
Blob csvContent = reader.extract(entry);

// 모든 항목 Map으로 조회
Map<String, Compression.ZipEntry> entryMap = reader.getEntriesMap();
```

### ZipReader 메서드 전체

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `ZipReader(Blob data)` | — | 생성자: Zip Blob에서 리더 생성 |
| `extract(String name)` | `Blob` | 이름으로 항목 추출·압축 해제 |
| `extract(ZipEntry entry)` | `Blob` | ZipEntry로 항목 추출·압축 해제 |
| `getEntries()` | `List<ZipEntry>` | 모든 항목 목록 |
| `getEntriesMap()` | `Map<String, ZipEntry>` | 이름→ZipEntry 맵 |
| `getEntry(String name)` | `ZipEntry` | 이름으로 항목 조회 (없으면 ZipException) |
| `getEntryNames()` | `List<String>` | 모든 항목 이름 목록 |

---

## ZipEntry — 항목 정보

```apex
Compression.ZipEntry entry = reader.getEntry('report.pdf');
String name = entry.getName();           // 항목 이름
Long size = entry.getUncompressedSize(); // 압축 해제 전 크기 (bytes)
Long compSize = entry.getCompressedSize();
Long crc = entry.getCrc();               // CRC 체크섬 값
Blob content = entry.getContent();       // 항목 내용 (ZipWriter 생성 항목만, ZipReader 불가)
Compression.Method method = entry.getMethod(); // DEFLATED or STORED
Datetime modified = entry.getLastModifiedTime();
String comment = entry.getComment();
String str = entry.toString();           // 항목 문자열 표현
Boolean isEqual = entry.equals(otherEntry);
Integer hash = entry.hashcode();
```

**ZipEntry getter 전체**

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `equals(obj)` | `Boolean` | 두 객체 동일 여부 비교 |
| `hashcode()` | `Integer` | 해시코드 값 반환 |
| `getComment()` | `String` | 항목 주석 반환 |
| `getCompressedSize()` | `Long` | 압축 후 크기 (bytes) |
| `getContent()` | `Blob` | 항목 내용 반환 (ZipReader 불가) |
| `getCrc()` | `Long` | CRC 체크섬 값 반환 |
| `getLastModifiedTime()` | `Datetime` | 마지막 수정 시간 반환 |
| `getMethod()` | `Compression.Method` | 압축 방식 반환 |
| `getName()` | `String` | 항목 이름 반환 |
| `getUncompressedSize()` | `Long` | 압축 전 크기 (bytes) |
| `toString()` | `String` | 문자열 표현 반환 |

**ZipEntry setter** (ZipWriter 사용 시에만 유효, ZipReader 사용 시 동작 안 함. 모두 `Compression.ZipEntry` 반환 — fluent 체이닝 가능):

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `setComment(String comment)` | `Compression.ZipEntry` | 주석 설정 |
| `setContent(Blob blob)` | `Compression.ZipEntry` | 항목 내용 설정 |
| `setLastModifiedTime(Datetime modTime)` | `Compression.ZipEntry` | 수정 시간 설정 |
| `setMethod(Compression.Method method)` | `Compression.ZipEntry` | 압축 방식 설정 |

---

## Level / Method Enum

```apex
// Level — 압축 수준
Compression.Level.BEST_COMPRESSION  // 최고 압축률 (느림)
Compression.Level.BEST_SPEED        // 최고 속도 (낮은 압축률)
Compression.Level.DEFAULT_LEVEL     // 기본 수준
Compression.Level.NO_COMPRESSION    // 압축 없음

// Method — 압축 방식
Compression.Method.DEFLATED  // 압축 (기본)
Compression.Method.STORED    // 비압축 저장

// 적용 예시
writer.setLevel(Compression.Level.BEST_COMPRESSION);
writer.setMethod(Compression.Method.DEFLATED);
```

---

## 관련 노트

- [[Spring '25]] — Compression Namespace GA 릴리즈 (이전 Summer '24 Beta)
- [[SingleEmailMessage]] — 이메일에 Zip 첨부 패턴
- [[Messaging Namespace]] — EmailFileAttachment 클래스
