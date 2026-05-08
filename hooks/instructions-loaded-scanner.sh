#!/bin/bash
# =============================================================================
# Instructions Loaded Scanner Hook
# =============================================================================
# Event: InstructionsLoaded (each time a CLAUDE.md or .claude/rules/*.md loads)
# Purpose: Defense-in-depth scan of lazy-loaded instruction files that
#          claudemd-scanner.sh (SessionStart) misses — specifically
#          path-scoped rules that load on demand when Claude reads matching
#          files, and nested CLAUDE.md files in subdirectories.
#
# Note: InstructionsLoaded cannot block — it can only emit a systemMessage
# warning. See https://code.claude.com/docs/en/hooks
# =============================================================================

set -euo pipefail

INPUT=$(cat)

FILE_PATH=$(echo "$INPUT" | jq -r '.file_path // empty' 2>/dev/null)
LOAD_REASON=$(echo "$INPUT" | jq -r '.load_reason // empty' 2>/dev/null)

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
    exit 0
fi

# Skip session_start: claudemd-scanner.sh already covers it at launch.
if [[ "$LOAD_REASON" == "session_start" ]]; then
    exit 0
fi

SUSPICIOUS_PATTERNS=(
    "ignore.*previous.*instruction"
    "ignore.*all.*instruction"
    "disregard.*instruction"
    "forget.*instruction"
    "new.*instruction.*follow"
    "curl.*\|.*bash"
    "curl.*\|.*sh"
    "wget.*\|.*bash"
    "wget.*\|.*sh"
    "eval\s*\("
    "base64.*decode"
    "\$\(.*curl"
    "\$\(.*wget"
    "<!--.*ignore"
    "<!--.*instruction"
)

WARNINGS=()

for pattern in "${SUSPICIOUS_PATTERNS[@]}"; do
    if grep -qiE "$pattern" "$FILE_PATH" 2>/dev/null; then
        WARNINGS+=("matches '$pattern'")
    fi
done

if awk 'length > 500' "$FILE_PATH" 2>/dev/null | grep -q .; then
    WARNINGS+=("contains very long lines (potential obfuscation)")
fi

if grep -P '[^\x00-\x7F]' "$FILE_PATH" 2>/dev/null | grep -qiE "instruction|ignore|run|execute"; then
    WARNINGS+=("contains non-ASCII characters near sensitive keywords")
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    DETAILS=""
    for w in "${WARNINGS[@]}"; do
        DETAILS+="- ${w}; "
    done
    MSG="LATE INSTRUCTION LOAD ALERT: ${FILE_PATH} (reason: ${LOAD_REASON}) — ${DETAILS}Review before relying on its content."
    echo "{\"systemMessage\": \"${MSG}\"}"
fi

exit 0
