#!/usr/bin/env bash
# L1 wiki structural lint
# Fires from PostToolUse hook (Write|Edit|MultiEdit). Reads hook JSON via stdin,
# validates the touched .md file's structure, reports issues to Claude via stderr.
#
# Exit codes:
#   0  — no issues, or file is out of scope
#   2  — issues found; stderr is fed back to Claude as feedback
#
# Scope: only .md files inside forceNote-wiki/ that are content pages
#        (excludes _index/_templates/_MOC/.claude/memory, index.md, MOC files,
#         00 Home.md, 00 SEARCH_INDEX.md, CLAUDE*.md, TEAM_PROTOCOL.md, README.md).

set -u

INPUT=$(cat)

# --- Extract a top-level string field from hook JSON (pure bash — Mac/Win 공통) ---
# Sufficient for hook inputs: tool_name (literal) and tool_input.file_path (path string).
# Handles JSON escapes \\ and \/ which appear in Windows paths.
extract_json_str() {
  local key="$1"
  local raw
  raw=$(printf '%s' "$INPUT" \
    | grep -o "\"${key}\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" \
    | head -1)
  [[ -z "$raw" ]] && return 0
  raw="${raw#*\"${key}\"*:*\"}"
  raw="${raw%\"}"
  printf '%s' "$raw" | sed 's|\\\\|\\|g; s|\\/|/|g'
}

TOOL_NAME=$(extract_json_str tool_name)
case "$TOOL_NAME" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

FILE_PATH=$(extract_json_str file_path)
[[ -z "$FILE_PATH" ]] && exit 0
[[ "$FILE_PATH" != *.md ]] && exit 0
[[ ! -f "$FILE_PATH" ]] && exit 0

# --- Scope: inside forceNote-wiki/ ---
case "$FILE_PATH" in
  */forceNote-wiki/*) ;;
  *) exit 0 ;;
esac

# --- Skip navigation/template/system files ---
case "$FILE_PATH" in
  */_index/*|*/_templates/*|*/_MOC/*|*/.claude/*|*/memory/*|*/scripts/*) exit 0 ;;
esac
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  index.md|CLAUDE.md|CLAUDE.local.md|TEAM_PROTOCOL.md|README.md|WIKI_RULES.md|SEAM_MAP.md) exit 0 ;;
  "00 SEARCH_INDEX.md"|"00 Home.md") exit 0 ;;
esac
# Skip MOC files (e.g. "Apex MOC.md", "통합 MOC.md")
case "$BASENAME" in
  *" MOC.md") exit 0 ;;
esac

# --- Locate wiki root for wikilink resolution ---
WIKI_ROOT=$(echo "$FILE_PATH" | sed 's|\(.*/forceNote-wiki\)/.*|\1|')

ISSUES=()

# ── Check 1: frontmatter presence + required keys ──────────────────────────
if ! head -1 "$FILE_PATH" | grep -q '^---$'; then
  ISSUES+=("frontmatter 누락 — 1행이 '---'이 아님")
else
  FM_END=$(awk 'NR>1 && /^---$/{print NR; exit}' "$FILE_PATH")
  if [[ -z "$FM_END" ]]; then
    ISSUES+=("frontmatter 닫힘 누락 — 두 번째 '---' 없음")
  else
    FM=$(sed -n "2,$((FM_END-1))p" "$FILE_PATH")
    for k in tags source created aliases; do
      if ! echo "$FM" | grep -q "^${k}:"; then
        ISSUES+=("frontmatter 필드 '${k}:' 없음")
      fi
    done
    SRC=$(echo "$FM" | grep '^source:' | head -1 | sed 's/^source:[[:space:]]*//; s/[[:space:]]*$//')
    case "$SRC" in
      ""|"없음"|"일반 지식"|"general"|"unknown")
        ISSUES+=("source 값 부적절: '$SRC' — 파일명·문서명·external-knowledge 중 하나 필요")
        ;;
    esac
  fi
fi

# ── Check 2: one-line summary "> ..." within top 40 lines ──────────────────
if ! sed -n '1,40p' "$FILE_PATH" | grep -q '^> '; then
  ISSUES+=("'> 한 줄 요약' 라인 없음 (상단 40줄 안에 '> ' 시작 라인 필요)")
fi

# ── Check 3: at least one code block ───────────────────────────────────────
if ! grep -q '^```' "$FILE_PATH"; then
  ISSUES+=("코드블록 없음 — 최소 1개의 \`\`\` 블록 필요")
fi

# ── Check 4: '## 관련 노트' section ─────────────────────────────────────────
if ! grep -q '^## 관련 노트' "$FILE_PATH"; then
  ISSUES+=("'## 관련 노트' 섹션 없음")
fi

# ── Check 4b: escaped backtick (raw \` in path/code cell) ──────────────────
# Common index-manager typo: when writing | ... | \`path/file.md\` |, the
# backslash leaks through markdown rendering and breaks grep-based path lookup.
# Real backticks should be \` is escape-sequence only inside code fences, never
# in inline code cells. Detect to prevent escape-backtick regression (AP-04 회고).
if grep -nE '\\\`' "$FILE_PATH" >/dev/null 2>&1; then
  ESC_LINE=$(grep -nE '\\\`' "$FILE_PATH" | head -1 | cut -d: -f1)
  ISSUES+=("escape backtick(\\\`) 발견 (line ${ESC_LINE}) — 인라인 코드는 정상 backtick(\`) 사용. grep 경로 매칭이 깨져 고아 false positive 발생 위험")
fi

# ── Check 5: broken wikilinks ──────────────────────────────────────────────
# Match basename only — wiki uses Obsidian-style [[Name]] and [[Folder/Name]] interchangeably.
if [[ -d "$WIKI_ROOT" ]]; then
  LINKS=$(grep -o '\[\[[^]]*\]\]' "$FILE_PATH" 2>/dev/null | sort -u)
  while IFS= read -r LINK; do
    [[ -z "$LINK" ]] && continue
    INNER=$(echo "$LINK" | sed 's/^\[\[//; s/\]\]$//')
    # skip explicit "(미작성)" placeholders
    echo "$INNER" | grep -qi '미작성' && continue
    # alias: [[A|B]] → A
    TARGET=$(echo "$INNER" | sed 's/|.*//')
    # anchor: A#section → A
    TARGET=$(echo "$TARGET" | sed 's/#.*//')
    [[ -z "$TARGET" ]] && continue
    LEAF=$(basename "$TARGET")
    # find a matching .md anywhere in wiki
    HIT=$(find "$WIKI_ROOT" -type f -name "${LEAF}.md" -print 2>/dev/null | head -1)
    if [[ -z "$HIT" ]]; then
      ISSUES+=("깨진 위키링크: $LINK")
    fi
  done <<< "$LINKS"
fi

# ── Report ─────────────────────────────────────────────────────────────────
if [[ ${#ISSUES[@]} -gt 0 ]]; then
  {
    echo "[L1 wiki lint] $BASENAME"
    for i in "${ISSUES[@]}"; do
      echo "  ❌ $i"
    done
    echo "  (Phase 1 구조 검증층 — 의미 검증은 source-verifier / completeness-validator가 담당)"
  } >&2
  exit 2
fi

exit 0
