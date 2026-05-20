---
tags: [apex, namespace, slack, slack-sdk, integration, bot, workflow]
source: salesforce_apex_reference_guide.pdf p.3578-3580
created: 2026-05-20
aliases: [Slack, Slack Namespace, Slack SDK Apex, 슬랙 네임스페이스, Slack 앱 개발, RunnableHandler, BotClient, AppClient]
---

# Slack Namespace

> Salesforce 플랫폼에서 Slack 앱 개발을 가속화하는 Apex SDK — 채널·메시지·사용자·워크플로우 등 Slack API 전 영역을 Apex 클래스로 추상화한다.

---

## 개요

`Slack` 네임스페이스는 Slack 앱을 Salesforce 플랫폼 위에서 빌드할 때 필요한 Apex 클래스·인터페이스 모음을 제공한다.

> [!note] 이 페이지는 Apex Reference Guide v67.0 기준 클래스 인벤토리다.  
> 각 클래스의 메서드·프로퍼티 상세 API는 **Salesforce Slack SDK 개발자 가이드**를 참조한다.

---

## 클래스 인벤토리 (43개 그룹)

### 앱 & 클라이언트

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.App` | Slack 앱 메타데이터 표현 |
| `Slack.AppClient` | Slack App API 호출 클라이언트 |
| `Slack.AppRequest` (Classes) | 앱 설치·승인 요청 데이터 |
| `Slack.Apps` (Classes) | 앱 목록 조회 응답 |

### 액션 & 단축키 & 커맨드

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Action` | 블록 액션 이벤트 페이로드 |
| `Slack.Shortcut` (Classes) | 글로벌·메시지 단축키 페이로드 |
| `Slack.SlackCommand` (Classes) | 슬래시 커맨드(`/command`) 요청 데이터 |

### 인증

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Auth` (Classes) | OAuth 인증 흐름 데이터 |

### 봇

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.BotClient` | 봇 토큰 기반 API 호출 클라이언트 |
| `Slack.BotsInfo` (Classes) | 봇 정보 조회 응답 |

### 채널 & 대화

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Channel` | 채널 메타데이터 |
| `Slack.Chat` (Classes) | 메시지 게시·수정·삭제 응답 |
| `Slack.Conversation` | 채널·DM·그룹DM 통합 표현 |

### 통화

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Call` (Classes) | Slack Call 시작·업데이트 데이터 |

### 콘텐츠 & 파일

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Emoji` (Classes) | 이모지 목록 응답 |
| `Slack.Field` | 섹션 블록 필드 요소 |
| `Slack.File` (Classes) | 파일 업로드·조회 데이터 |

### 방해 금지

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Dnd` (Classes) | Do Not Disturb 스케줄 데이터 |

### 이벤트

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Event` (Classes) | Events API 이벤트 페이로드 |

### 메시지

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Latest` (Classes) | 채널의 최신 메시지 정보 |
| `Slack.Message` (Classes) | 메시지 블록·첨부파일 구성 |
| `Slack.MigrationExchange` (Classes) | 레거시 팀 ID 마이그레이션 매핑 |

### 모달 & 뷰

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Modals` | 모달 다이얼로그 빌더 |
| `Slack.Options` (Classes) | 드롭다운·외부 셀렉트 옵션 응답 |
| `Slack.Views` (Classes) | 뷰 게시·업데이트·푸시 응답 |

### 페이지네이션

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Paging` | cursor 기반 페이지네이션 메타데이터 |

### 핀 & 리액션 & 별표

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Pin` (Classes) | 채널 핀 추가·제거 응답 |
| `Slack.Reaction` (Classes) | 이모지 리액션 추가·제거 응답 |
| `Slack.Star` (Classes) | 즐겨찾기(별표) 항목 데이터 |

### 목적 & 주제

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Purpose` | 채널 목적 텍스트 |
| `Slack.Topic` | 채널 주제 텍스트 |

### 알림

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Reminder` (Classes) | 리마인더 설정·목록 데이터 |

### 요청 & 응답

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.RequestContext` (Classes) | Slack 요청 컨텍스트 (팀 ID, 사용자 ID 등) |
| `Slack.ResponseMetadata` (Classes) | API 응답 메타데이터 (messages, warnings) |

### 검색

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Search` (Classes) | 메시지·파일 검색 결과 |

### 팀

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Team` (Classes) | 워크스페이스 팀 정보 |
| `Slack.TestHarness` (Classes) | @isTest 환경에서 Slack 이벤트 시뮬레이션 |

### 사용자 & 그룹

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.User` (Classes) | 사용자 프로필·존재 여부 데이터 |
| `Slack.UserClient` | 사용자 토큰 기반 API 호출 클라이언트 |
| `Slack.Usergroup` (Classes) | 사용자 그룹 생성·수정 데이터 |
| `Slack.UserMapping` Service Class | Salesforce User ↔ Slack User ID 매핑 |

### 워크플로우

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.Workflow` (Classes) | Workflow Builder 스텝 완료 데이터 |

### 핸들러 인터페이스

| 클래스 / 인터페이스 | 역할 |
|---|---|
| `Slack.RunnableHandler` | 이벤트·액션·커맨드·단축키를 처리하는 핵심 진입점 인터페이스 |

---

## RunnableHandler — 핵심 진입점

`Slack.RunnableHandler`는 `Slack` 네임스페이스에서 유일한 인터페이스로, Slack 앱의 모든 인바운드 요청(이벤트, 액션, 커맨드, 단축키)을 처리하는 진입점 역할을 한다.

```apex
// 구조 예시 — 실제 동작 코드 아님
global class MySlackHandler implements Slack.RunnableHandler {

    global void run(Slack.RequestContext context) {
        // context에서 팀 ID, 사용자 ID, 페이로드 타입 추출
        // Slack.Chat, Slack.Message 등으로 응답 구성
    }
}
```

---

## 주요 클라이언트 패턴

Slack API를 호출할 때는 토큰 종류에 따라 클라이언트를 선택한다.

| 시나리오 | 클라이언트 |
|---|---|
| 봇 토큰으로 API 호출 | `Slack.BotClient` |
| 사용자 토큰으로 API 호출 | `Slack.UserClient` |
| 앱 레벨 API 호출 | `Slack.AppClient` |

---

## 관련 노트

- [[Apex MOC]]
- [[ConnectApi Namespace 개요]] — Einstein LLM, Chatter 등 Salesforce 플랫폼 통합
- [[RestClient 패턴]] — 외부 HTTP API 직접 호출이 필요한 경우
