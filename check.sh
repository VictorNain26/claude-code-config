#!/usr/bin/env bash
# Checks that this machine has what settings.json relies on, reading it from the config itself.
# Installs nothing. Exit code 1 when something is missing.
set -uo pipefail
C="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
S="$C/settings.json"
M="$C/plugins/marketplaces/claude-plugins-official/.claude-plugin/marketplace.json"
missing=0
ok() { printf 'OK        %s\n' "$1"; }
ko() { printf 'MANQUANT  %s\n' "$1"; missing=1; }
cmd() { if command -v "$1" >/dev/null 2>&1; then ok "$1 ($2)"; else ko "$1 ($2)"; fi; }

command -v jq >/dev/null 2>&1 || { echo "MANQUANT  jq (requis pour lire $S)"; exit 1; }

if [ "$(jq -r '.sandbox.enabled // false' "$S")" = true ]; then
  cmd bwrap "sandbox"
  cmd socat "sandbox"
fi
jq -e '.statusLine' "$S" >/dev/null && cmd jq "status line"
cmd gh "git push, jeton masqué par sandbox.credentials"

while read -r path; do
  [ -z "$path" ] && continue
  f="${path/#\~/$HOME}"
  if [ -e "$f" ]; then ok "$path (sandbox.credentials)"; else ko "$path (sandbox.credentials : se connecter avec gh auth login)"; fi
done < <(jq -r '.sandbox.credentials.files[]?.path' "$S")

if [ -f "$M" ]; then
  while read -r bin plugin; do
    cmd "$bin" "LSP de $plugin"
  done < <(jq -r --slurpfile s "$S" '
    .plugins[] | select($s[0].enabledPlugins[.name + "@claude-plugins-official"] == true)
    | .name as $n | (.lspServers // {}) | to_entries[] | "\(.value.command) \($n)"' "$M")
else
  echo "INFO      marketplace officiel pas encore téléchargé : lancer claude une fois, puis relancer ce script"
fi

exit "$missing"
