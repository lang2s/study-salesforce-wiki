---
tags: [apex, namespace, chatteranswers, portal, deprecated]
source: salesforce_apex_reference_guide.pdf p.299-300
created: 2026-05-20
aliases: [ChatterAnswers, AccountCreator Interface, chatteranswers:registration, Chatter Answers 포털 계정 생성]
---

# ChatterAnswers Namespace

> Chatter Answers 포털 사용자를 위한 Account 레코드 커스텀 생성 인터페이스 — `AccountCreator`를 구현해 사용자 등록 시 Account를 동적으로 만든다.

> [!warning] Chatter Answers는 거의 deprecated 상태다. 신규 프로젝트에서는 Experience Cloud(커뮤니티)와 Knowledge를 사용한다.

---

## 구성 요소

| 인터페이스 | 역할 |
|---|---|
| `ChatterAnswers.AccountCreator` | Chatter Answers 포털 사용자 등록 시 Account 레코드 생성 |

---

## AccountCreator Interface

`chatteranswers:registration` Visualforce 컴포넌트의 `registrationClassName` 속성에 지정한다. Chatter Answers가 사용자 등록 시 이 인터페이스를 호출해 포털 사용자와 연결할 Account를 생성한다.

### 메서드

```apex
public String createAccount(String firstName, String lastName, Id siteAdminId)
// firstName: 등록 사용자 이름
// lastName:  등록 사용자 성
// siteAdminId: Site 관리자 User ID — 예외 발생 시 알림 대상
// 반환: Account ID (String)
```

구현 클래스는 `global` 또는 `public`으로 선언해야 한다.

### 구현 예제

```apex
public class ChatterAnswersRegistration implements ChatterAnswers.AccountCreator {

    public String createAccount(String firstname, String lastname, Id siteAdminId) {
        Account a = new Account(name = firstname + ' ' + lastname, ownerId = siteAdminId);
        insert a;
        return a.Id;
    }
}
```

### 테스트 예제

```apex
@isTest
private class ChatterAnswersCreateAccountTest {
    static testMethod void validateAccountCreation() {
        User[] user = [SELECT Id, Firstname, Lastname FROM User WHERE UserType='Standard'];
        if (user.size() == 0) { return; }

        String firstName = user[0].FirstName;
        String lastName  = user[0].LastName;
        String userId    = user[0].Id;
        String accountId = new ChatterAnswersRegistration()
            .createAccount(firstName, lastName, userId);

        Account acct = [SELECT name, ownerId FROM Account WHERE Id =: accountId];
        System.assertEquals(firstName + ' ' + lastName, acct.name);
        System.assertEquals(userId, acct.ownerId);
    }
}
```

---

## Visualforce 연동

```xml
<!-- chatteranswers:registration 컴포넌트에 구현 클래스를 지정 -->
<chatteranswers:registration
    registrationClassName="ChatterAnswersRegistration"
    .../>
```

---

## 관련 노트

- [[Apex MOC]]
- [[ApexPages Namespace]] — Visualforce 컨트롤러 전반
