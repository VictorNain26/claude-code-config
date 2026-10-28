#!/usr/bin/env bash
# Claude Code status line: model · effort · ctx% · dir · git branch
export PATH="/home/ordiv/.local/bin:$PATH"
JQ=/home/ordiv/.local/bin/jq
[ -x "$JQ" ] || JQ=$(command -v jq)

input=$(cat)

# \x1f instead of tab: tab is IFS whitespace, so empty fields would collapse
IFS=$'\x1f' read -r model effort used cwd < <(
  printf '%s' "$input" | "$JQ" -r '[
    (.model.display_name // .model.id // "Claude"),
    (.effort.level // ""),
    (.context_window.used_percentage // "" | if type=="number" then (. | floor | tostring) else "" end),
    (.workspace.current_dir // .cwd // "")
  ] | join("\u001f")' 2>/dev/null
)
[ -z "$model" ] && model="Claude"
[ -z "$cwd" ] && cwd=$PWD

parts=("$model")
[ -n "$effort" ] && parts+=("$effort")
[ -n "$used" ] && parts+=("ctx ${used}%")
parts+=("$(basename "$cwd")")

branch=""
if [ -d "$cwd" ]; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short -q HEAD 2>/dev/null \
    || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi
[ -n "$branch" ] && parts+=("$branch")

out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then out="$p"; else out="$out · $p"; fi
done
printf '%s\n' "$out"
