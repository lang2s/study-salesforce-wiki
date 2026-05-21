# CLAUDE.local.md — 로컬 환경 설정 (작업 전 필독)

> 이 위키 팀은 **Mac / Windows 양쪽**에서 작업될 수 있다. 어떤 에이전트든 **콘텐츠 작업(소스 추출·파일 생성)을 시작하기 전 이 파일을 먼저 읽고 환경을 확인**한다.
> 경로는 절대경로 하드코딩 대신 **레포 루트 기준 상대경로**를 쓴다. 그러면 OS가 달라도 동일하게 동작한다.

---

## 0. 환경 감지 (세션당 1회)

```bash
uname -s              # Darwin = macOS · MINGW*/MSYS* = Windows(git-bash)
pwd                   # 작업 디렉터리 = 레포 루트여야 함
command -v pdftotext  # PDF 추출 도구 (Mac/Win 공통, PATH에 있어야 함)
ls "Salesforce Documents" >/dev/null 2>&1 && echo "DOCS OK"
ls forceNote-wiki      >/dev/null 2>&1 && echo "WIKI OK"
```

감지 결과에 따라 **해당 환경 파일을 읽는다:**

| `uname -s` 결과 | 환경 | 읽을 파일 |
|---|---|---|
| `Darwin` | macOS | `forceNote-wiki/.claude/env/mac.md` |
| `MINGW*` / `MSYS*` | Windows (git-bash) | `forceNote-wiki/.claude/env/windows.md` |

하나라도 실패(pwd가 레포 루트 아님 / pdftotext 없음 / 폴더 없음)하면 **작업을 중단하고 사용자에게 보고**한다.

---

## 1. 경로 변수 (양 OS 공통 — 레포 루트 기준 상대경로)

작업 디렉터리(= 레포 루트)에서 아래 상대경로를 쓴다. 절대경로 하드코딩 금지.

| 변수 | 값 (레포 루트 기준) | 설명 |
|---|---|---|
| `$WIKI` | `forceNote-wiki` | 위키 콘텐츠 루트 |
| `$DOCS` | `Salesforce Documents` | 원본 PDF 폴더 |
| `$PDF2TXT` | `pdftotext` | PATH의 pdftotext (Mac/Win 공통) |
| `$TMP` | `/tmp` | 추출 임시 파일 (git-bash·Mac 공통) |

예: PDF 추출 → `pdftotext "Salesforce Documents/salesforce_apex_reference_guide.pdf" /tmp/apex_ref.txt`

> 레포 구조가 양 OS에서 동일(`루트/forceNote-wiki/` + `루트/Salesforce Documents/`)하므로, 위 상대경로면 OS 분기가 필요 없다. OS별 절대경로·도구 위치 등 세부는 환경 파일(`mac.md`/`windows.md`)에 기록한다.

---

## 2. 작업 전 프리플라이트 체크리스트

```
□ uname -s 로 OS 확인 → 해당 env 파일 읽음
□ pwd 가 레포 루트인지 확인 (아니면 cd)
□ pdftotext 존재 확인
□ Salesforce Documents/ , forceNote-wiki/ 폴더 존재 확인
□ 대상 PDF 파일 존재 확인 (예: "Salesforce Documents/salesforce_apex_reference_guide.pdf")
```

---

## 3. 참고

- 이 파일과 `env/*.md`는 **OS 비종속(상대경로)**이라 커밋해도 무방하다 — 두 머신 모두에서 참조 가능해야 하므로 gitignore하지 않는다.
- 새 머신/새 PDF를 추가하면 해당 env 파일의 "마지막 확인" 날짜와 검증 항목을 갱신한다.
