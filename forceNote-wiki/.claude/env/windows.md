# 환경: Windows (git-bash)

> `uname -s` → `MINGW*` / `MSYS*` 일 때 이 파일을 참조한다. 진입점: `forceNote-wiki/CLAUDE.local.md`.

## 확인된 값 (마지막 확인: 2026-05-21 ✅)

| 항목 | 값 |
|---|---|
| OS | Windows 11 (git-bash, `MINGW64_NT-10.0-26200`) |
| 레포 루트 (절대) | `C:\Users\A\Desktop\Salesforce\forceNote-wiki-main` (git-bash: `/c/Users/A/Desktop/Salesforce/forceNote-wiki-main`) |
| `$WIKI` | `forceNote-wiki` (레포 루트 기준 상대) |
| `$DOCS` | `Salesforce Documents` (PDF 43개, `salesforce_apex_reference_guide.pdf` 28MB 포함) |
| `$PDF2TXT` | `pdftotext` → `/mingw64/bin/pdftotext` |
| `$TMP` | `/tmp` |

## OS 특이사항

- 셸: PowerShell 또는 git-bash. PDF 추출·`find`·`grep`은 **git-bash(Bash 도구)** 에서 실행.
- 절대경로 형태: `/c/Users/...` (git-bash) ↔ `C:\Users\...` (PowerShell).
- pdftotext는 mingw64에 설치돼 PATH에 있음 → 그냥 `pdftotext` 호출.

## 검증 커맨드

```bash
uname -s                  # MINGW64_NT-...
command -v pdftotext      # /mingw64/bin/pdftotext
ls "Salesforce Documents"/*.pdf | wc -l
```
