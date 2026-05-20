---
tags: [apex, pref_center, namespace, privacy-center, preference-manager, reference]
source: salesforce_apex_reference_guide.pdf v67.0 — pref_center Namespace (doc p.3208~3225)
created: 2026-05-20
aliases: [Pref_center Namespace, PreferenceCenterApexHandler, TokenUtility, generateToken, LoadFormData, SubmitFormData, 개인정보 동의 관리 Apex, Privacy Center Apex]
---

# Pref_center Namespace

> Privacy Center 앱의 Preference Manager(동의 양식) 커스터마이징 Apex SDK — `PreferenceCenterApexHandler` 인터페이스 구현으로 양식 로드·제출 로직을 재정의하고, `TokenUtility`로 인증 토큰을 생성한다.

---

## 클래스 목록

| 클래스 / 인터페이스 / enum | 설명 |
|---|---|
| `LoadFormData` | 양식 로드 시 필드 옵션·선택값·힌트 등을 설정하는 응답 객체 |
| `LoadParameters` | `load()` 호출 시 전달되는 파라미터 — 레코드 ID 조회 |
| `PreferenceCenterApexHandler` | 양식 로드·제출 로직을 커스터마이징하는 인터페이스 |
| `SubmitFormData` | 양식 제출 시 현재·이전 필드값을 읽는 입력 객체 |
| `SubmitParameters` | `submit()` 호출 시 전달되는 파라미터 — 레코드 ID 조회 |
| `TokenType` | 인증 토큰 유형 enum (`EMAIL` / `STANDARD`) |
| `TokenUtility` | Preference 양식용 인증 토큰 생성 유틸리티 |
| `ValidationResult` | 미래 사용을 위해 예약된 클래스 (현재 메서드 없음) |

---

## PreferenceCenterApexHandler 인터페이스

Preference Center 양식의 로드/제출 동작을 Apex로 재정의할 때 구현한다. Preference Manager 설정에서 구현 클래스를 지정하면 양식 렌더링/제출 시 자동 호출된다.

### 메서드

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `load` | `public pref_center.LoadFormData load(pref_center.LoadParameters loadParams, pref_center.LoadFormData formData, pref_center.ValidationResult validationResult)` | 양식 초기 로드 시 호출 — 필드 옵션·선택값을 동적으로 설정 |
| `submit` | `public void submit(pref_center.SubmitParameters submitParams, pref_center.SubmitFormData formData, pref_center.ValidationResult validationResult)` | 양식 제출 시 호출 — 제출 데이터 처리 및 후속 로직 실행 |

---

## LoadFormData 클래스

`load()` 메서드의 반환값. 양식 필드에 표시할 옵션 목록·선택값·텍스트 힌트 등을 설정한다.

**API 버전:** v56.0+

### 생성자

```apex
public LoadFormData(Map<String, pref_center.FieldProperties> data)
```

### 메서드

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `addOption` | `public void addOption(String fieldId, String value, String label)` | 드롭다운·체크박스 필드에 옵션 추가 (value + label) |
| `addOption` | `public void addOption(String fieldId, System.SelectOption option)` | `SelectOption` 객체로 옵션 추가 |
| `addSelectedOption` | `public void addSelectedOption(String fieldId, String option)` | 선택된 옵션 값 추가 |
| `setButtonLabel` | `public void setButtonLabel(String fieldId, String label)` | 버튼 라벨 설정 |
| `setOptions` | `public void setOptions(String fieldId, List<System.SelectOption> options)` | 옵션 목록 일괄 설정 |
| `setSelectedOption` | `public void setSelectedOption(String fieldId, String optionValue)` | 단일 선택값 설정 |
| `setSelectedOptions` | `public void setSelectedOptions(String fieldId, List<String> options)` | 다중 선택값 설정 |
| `setTextHint` | `public void setTextHint(String fieldId, String hintText)` | 텍스트 필드 힌트(placeholder) 설정 |
| `setTextValue` | `public void setTextValue(String fieldId, String value)` | 텍스트 필드 초기값 설정 |

---

## LoadParameters 클래스

`load()` 호출 시 전달되는 파라미터 객체.

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getRecordId()` | `String` | 토큰화되지 않은 레코드 Id 반환 |

---

## SubmitFormData 클래스

`submit()` 호출 시 전달되는 양식 데이터. 현재 값과 이전 값 모두 조회 가능하다.

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getButtonClicked()` | `String` | 클릭된 버튼의 ID 반환 |
| `getOldSelectedValue(String fieldId)` | `String` | 이전 단일 선택값 |
| `getOldSelectedValues(String fieldId)` | `List<String>` | 이전 다중 선택값 |
| `getOldStringValue(String fieldId)` | `String` | 이전 텍스트값 (체크박스 필드에 사용 시 `TypeError` 발생) |
| `getSelectedValue(String fieldId)` | `String` | 현재 단일 선택값 |
| `getSelectedValues(String fieldId)` | `List<String>` | 현재 다중 선택값 |
| `getStringValue(String fieldId)` | `String` | 현재 텍스트값 |

---

## SubmitParameters 클래스

`submit()` 호출 시 전달되는 파라미터 객체.

### 메서드

| 메서드 | 반환 타입 | 설명 |
|---|---|---|
| `getRecordId()` | `String` | 토큰화되지 않은 레코드 ID 반환 |

---

## TokenType Enum

인증 토큰의 유형을 지정한다.

| 값 | 설명 |
|---|---|
| `EMAIL` | 토큰 값이 이메일 주소 |
| `STANDARD` | 토큰 값이 Salesforce 레코드 ID (기본값) |

---

## TokenUtility 클래스

Preference Center 양식의 인증 토큰을 생성한다. 모든 메서드는 `static`이다.

### 메서드

| 메서드 | 시그니처 | 설명 |
|---|---|---|
| `generateToken` | `public static String generateToken(String tokenValue, pref_center.TokenType tokenType)` | 지정 토큰 유형으로 단일 토큰 생성 |
| `generateToken` | `public static String generateToken(String tokenValue)` | `STANDARD` 토큰 유형으로 단일 토큰 생성 |
| `generateTokens` | `public static Map<String,String> generateTokens(List<String> tokenValues, pref_center.TokenType tokenType)` | 지정 토큰 유형으로 다수 토큰 생성 — 입력값 → 토큰 Map 반환 |
| `generateTokens` | `public static Map<String,String> generateTokens(List<String> tokenValues)` | `STANDARD` 토큰 유형으로 다수 토큰 생성 |

---

## ValidationResult 클래스

미래 사용을 위해 예약됨. 현재 메서드 없음.

---

## 코드 예시

```apex
// PreferenceCenterApexHandler 구현 예시
public class MyPrefHandler implements pref_center.PreferenceCenterApexHandler {

    public pref_center.LoadFormData load(
            pref_center.LoadParameters loadParams,
            pref_center.LoadFormData formData,
            pref_center.ValidationResult validationResult) {

        String recordId = loadParams.getRecordId();
        // 레코드에서 현재 선호도 조회
        Contact c = [SELECT Email, HasOptedOutOfEmail FROM Contact WHERE Id = :recordId];
        formData.setTextValue('emailField', c.Email);
        formData.setSelectedOption('optOutField', String.valueOf(c.HasOptedOutOfEmail));
        return formData;
    }

    public void submit(
            pref_center.SubmitParameters submitParams,
            pref_center.SubmitFormData formData,
            pref_center.ValidationResult validationResult) {

        String recordId = submitParams.getRecordId();
        String newOptOut = formData.getSelectedValue('optOutField');
        update new Contact(Id = recordId, HasOptedOutOfEmail = Boolean.valueOf(newOptOut));
    }
}

// TokenUtility — 이메일 기반 토큰 생성
String emailToken = pref_center.TokenUtility.generateToken(
    'user@example.com', pref_center.TokenType.EMAIL);

// 레코드 ID 기반 토큰 생성 (STANDARD 기본값)
String recordToken = pref_center.TokenUtility.generateToken(recordId);

// 다수 레코드 일괄 토큰화
List<String> ids = new List<String>{'001xx...', '001yy...'};
Map<String,String> tokenMap = pref_center.TokenUtility.generateTokens(ids);
```

---

## 관련 노트

- [[System Namespace]] — `System.SelectOption` (옵션 객체)
- [[Support Namespace]] — Case Feed 이메일 기본값 커스터마이징 (Privacy와 유사한 핸들러 패턴)
