# 환경: macOS

> `uname -s` → `Darwin` 일 때 이 파일을 참조한다. 진입점: `forceNote-wiki/CLAUDE.local.md`.

## 값 (⚠️ 미검증 — 원래 에이전트 설정 기준 추정값. Mac 접속 시 검증 후 아래 날짜 갱신)

| 항목 | 값 |
|---|---|
| OS | macOS (`Darwin`) |
| 레포 루트 (절대, 추정) | `/Users/a/Desktop/Study` |
| `$WIKI` | `forceNote-wiki` (레포 루트 기준 상대) |
| `$DOCS` | `Salesforce Documents` |
| `$PDF2TXT` | `pdftotext` → `/opt/homebrew/bin/pdftotext` (Homebrew) |
| `$TMP` | `/tmp` |

## OS 특이사항

- 셸: zsh / bash. Bash 도구로 PDF 추출·`find`·`grep` 실행.
- 절대경로 형태: `/Users/...`.
- pdftotext는 Homebrew 설치(`brew install poppler`) 시 `/opt/homebrew/bin`(Apple Silicon) 또는 `/usr/local/bin`(Intel). PATH에 있으면 그냥 `pdftotext`.

## 검증 커맨드 (Mac 접속 시 실행 후 위 표 갱신)

```bash
uname -s                  # Darwin
pwd                       # 레포 루트인지 확인
command -v pdftotext      # 경로 확인 (없으면 brew install poppler)
ls "Salesforce Documents"/*.pdf | wc -l
```

> 레포 구조(`루트/forceNote-wiki/` + `루트/Salesforce Documents/`)는 Windows와 동일하므로, 상대경로(`$WIKI`/`$DOCS`)는 그대로 동작한다. 절대 루트와 pdftotext 위치만 이 파일에서 다르다.
