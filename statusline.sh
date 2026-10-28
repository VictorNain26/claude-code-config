#!/usr/bin/env bash
# Claude Code status line: model · effort · ctx% · 5h/7j plan usage · dir · git branch
# Fields: https://code.claude.com/docs/en/statusline#available-data
export PATH="$HOME/.local/bin:$PATH"
JQ=$(command -v jq)

input=$(cat)

# \x1f instead of tab: tab is IFS whitespace, so empty fields would collapse
if [ -n "$JQ" ]; then
  IFS=$'\x1f' read -r model effort used five seven cwd < <(
    printf '%s' "$input" | "$JQ" -r 'def pct: if type=="number" then (floor | tostring) else "" end;
    [
      (.model.display_name // .model.id // "Claude"),
      (.effort.level // ""),
      (.context_window.used_percentage // "" | pct),
      (.rate_limits.five_hour.used_percentage // "" | pct),
      (.rate_limits.seven_day.used_percentage // "" | pct),
      (.workspace.current_dir // .cwd // "")
    ] | join("\u001f")' 2>/dev/null
  )
fi
[ -z "${model:-}" ] && model="Claude"
[ -z "${cwd:-}" ] && cwd=$PWD

parts=("$model")
[ -n "${effort:-}" ] && parts+=("$effort")
[ -n "${used:-}" ] && parts+=("ctx ${used}%")
# rate_limits only exists for Pro/Max plans, after the session's first response
[ -n "${five:-}" ] && parts+=("5h ${five}%")
[ -n "${seven:-}" ] && parts+=("7j ${seven}%")
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
