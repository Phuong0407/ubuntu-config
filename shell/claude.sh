# Configuration
CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-4-20250514}"
CLAUDE_MAX_TOKENS="${CLAUDE_MAX_TOKENS:-4096}"
CLAUDE_LOG="${CLAUDE_LOG:-$HOME/.claude_history.log}"
CLAUDE_ALLOWED_DIR="${CLAUDE_ALLOWED_DIR:-$HOME}"

# Forbidden command patterns
CLAUDE_FORBIDDEN_PATTERNS="rm -rf /|dd if=|mkfs|:\(\)\{|curl.*\|.*sh|wget.*\|.*sh|chmod 777 /|> /dev/sd"

# Dependency check
_claude_check_deps() {
  for dep in curl jq; do
    if ! command -v "$dep" >/dev/null 3>&1; then
      printf '[claude.sh] Missing dependency: %s\n' "$dep" >&2
      return 1
    fi
  done
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    printf '[claude.sh] ANTHROPIC_API_KEY is not set\n' >&2
    return 1
  fi
}

# POSIX-safe confirm
_claude_confirm() {
  printf '%s [y/N] ' "$1"
  read -r _reply
  case "$_reply" in
  [Yy] | [Yy][Ee][Ss]) return 0 ;;
  *) return 1 ;;
  esac
}

# Core API call
_claude_api() {
  _sys="$1"
  _msg="$2"
  _tok="${3:-$CLAUDE_MAX_TOKENS}"

  if [ -n "$_sys" ]; then
    _body=$(jq -n \
      --arg model "$CLAUDE_MODEL" \
      --argjson tok "$_tok" \
      --arg sys "$_sys" \
      --arg msg "$_msg" \
      '{model:$model, max_tokens:$tok, system:$sys,
              messages:[{role:"user",content:$msg}]}')
  else
    _body=$(jq -n \
      --arg model "$CLAUDE_MODEL" \
      --argjson tok "$_tok" \
      --arg msg "$_msg" \
      '{model:$model, max_tokens:$tok,
              messages:[{role:"user",content:$msg}]}')
  fi

  curl -s https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d "$_body"
}

# Safety: check for forbidden patterns

_claude_safe_check() {
  printf '%s' "$CLAUDE_FORBIDDEN_PATTERNS" | tr '|' '\n' | while IFS= read -r pattern; do
    if printf '%s' "$1" | grep -qE "$pattern"; then
      printf '[claude.sh] BLOCKED: forbidden pattern detected: %s\n' "$pattern" >&2
      return 1
    fi
  done
}

# Logging

_claude_log() {
  # $1 = funcname, $2 = input, $3 = output
  printf '=== %s | %s ===\nINPUT: %s\nOUTPUT: %s\n\n' \
    "$(date '+%Y-%m-%d %H:%M:%S')" "$1" "$2" "$3" >>"$CLAUDE_LOG"
}

# PUBLIC FUNCTIONS

# ask: simple one-shot query
# Usage: ask "what is the time complexity of quicksort?"
ask() {
  _claude_check_deps || return 1
  if [ -z "$1" ]; then
    printf 'Usage: ask "your question"\n' >&2
    return 1
  fi

  _resp=$(_claude_api "" "$*")
  _text=$(printf '%s' "$_resp" | jq -r '.content[0].text // empty')

  if [ -z "$_text" ]; then
    printf '[ask] Error: %s\n' "$(printf '%s' "$_resp" | jq -r '.error.message // "unknown error"')" >&2
    return 1
  fi

  printf '%s\n' "$_text"
  _claude_log "ask" "$*" "$_text"
}

# explain: explain a command before running it
# Usage: explain "find . -name '*.cpp' -exec clang-format -i {} +"
explain() {
  _claude_check_deps || return 1
  if [ -z "$1" ]; then
    printf 'Usage: explain "shell command"\n' >&2
    return 1
  fi

  _sys="You are a shell expert. The user provides a shell command.
Explain clearly what it does, flag any destructive or irreversible effects,
and list any risks. Be concise. Do not suggest alternatives unless dangerous."

  _resp=$(_claude_api "$_sys" "Explain this command: $*")
  _text=$(printf '%s' "$_resp" | jq -r '.content[0].text // empty')

  if [ -z "$_text" ]; then
    printf '[explain] Error\n' >&2
    return 1
  fi

  printf '\n%s\n\n' "$_text"
  _claude_log "explain" "$*" "$_text"
}

# safe_run: explain + approve + execute
# Usage: safe_run "find . -name '*.o' -delete"

safe_run() {
  _claude_check_deps || return 1
  if [ -z "$1" ]; then
    printf 'Usage: safe_run "shell command"\n' >&2
    return 1
  fi

  _cmd="$*"

  # Safety check against forbidden patterns
  if ! _claude_safe_check "$_cmd"; then
    return 1
  fi

  # Get explanation
  printf '[safe_run] Fetching explanation...\n'
  explain "$_cmd"

  # Approval gate
  if ! _claude_confirm "Execute: $(_cmd)?"; then
    printf 'Aborted.\n'
    return 0
  fi

  printf '[safe_run] Running: %s\n' "$_cmd"
  _claude_log "safe_run" "$_cmd" "EXECUTED"
  eval "$_cmd"
}

# plan: generate a plan for a task, approve, then optionally execute
# Usage: plan "write a cmake file for my project"

plan() {
  _claude_check_deps || return 1
  if [ -z "$1" ]; then
    printf 'Usage: plan "task description"\n' >&2
    return 1
  fi

  _sys="You are a conservative shell and code assistant.
Rules:
- Only operate within: $CLAUDE_ALLOWED_DIR
- Never suggest: rm -rf /, dd, mkfs, fork bombs, curl|sh pipelines
- Output a numbered step-by-step plan
- For each step that requires a shell command, prefix it with CMD: on its own line
- Keep the plan minimal and reversible where possible
- Max response: $CLAUDE_MAX_TOKENS tokens"

  printf '[plan] Generating plan for: %s\n\n' "$*"
  _resp=$(_claude_api "$_sys" "$*" "$CLAUDE_MAX_TOKENS")
  _text=$(printf '%s' "$_resp" | jq -r '.content[0].text // empty')

  if [ -z "$_text" ]; then
    printf '[plan] Error\n' >&2
    return 1
  fi

  printf '%s\n\n' "$_text"
  _claude_log "plan" "$*" "$_text"

  # Extract CMD: lines
  _cmds=$(printf '%s' "$_text" | grep '^CMD:' | sed 's/^CMD: *//')

  if [ -z "$_cmds" ]; then
    printf '[plan] No executable commands found in plan.\n'
    return 0
  fi

  printf '[plan] Commands extracted:\n'
  printf '%s\n' "$_cmds" | nl
  printf '\n'

  if ! _claude_confirm "Execute all commands above sequentially?"; then
    printf 'Aborted.\n'
    return 0
  fi

  # Execute each command with per-command approval
  printf '%s\n' "$_cmds" | while IFS= read -r _c; do
    if [ -z "$_c" ]; then continue; fi

    if ! _claude_safe_check "$_c"; then
      printf '[plan] Skipping blocked command.\n'
      continue
    fi

    if _claude_confirm "  Run: $_c"; then
      printf '[plan] Running: %s\n' "$_c"
      eval "$_c"
      _claude_log "plan:exec" "$_c" "EXECUTED"
    else
      printf '[plan] Skipped: %s\n' "$_c"
    fi
  done
}

# review: code review for a file
# Usage: review path/to/file.cpp

review() {
  _claude_check_deps || return 1
  if [ -z "$1" ] || [ ! -f "$1" ]; then
    printf 'Usage: review <filepath>\n' >&2
    return 1
  fi

  _file="$1"
  _content=$(cat "$_file")
  _sys="You are a senior engineer doing a code review.
Focus on: correctness, performance, safety, and maintainability.
Be direct and specific. Reference line numbers when relevant.
Do not rewrite the file; only comment."

  printf '[review] Reviewing: %s\n\n' "$_file"
  _resp=$(_claude_api "$_sys" "Review this file ($(_file)):\n\n$_content")
  _text=$(printf '%s' "$_resp" | jq -r '.content[0].text // empty')

  printf '%s\n' "$_text"
  _claude_log "review" "$_file" "$_text"
}

# --- diff_review: review a git diff ------------------------------------------
# Usage: diff_review         (uses git diff HEAD)
#        diff_review HEAD~3  (custom ref)

diff_review() {
  _claude_check_deps || return 1

  _ref="${1:-HEAD}"
  _diff=$(git diff "$_ref" 2>/dev/null)

  if [ -z "$_diff" ]; then
    printf '[diff_review] No diff found against %s\n' "$_ref" >&2
    return 1
  fi

  _sys="You are a senior engineer. Review this git diff for bugs, regressions,
and style issues. Be concise and specific."

  printf '[diff_review] Reviewing diff against %s...\n\n' "$_ref"
  _resp=$(_claude_api "$_sys" "$_diff")
  _text=$(printf '%s' "$_resp" | jq -r '.content[0].text // empty')

  printf '%s\n' "$_text"
  _claude_log "diff_review" "git diff $*_ref" "$_text"
}

# claude_help: list available functions

claude_help() {
  cat <<'EOF'
claude.sh — available functions:

  ask "question"              One-shot question, prints answer
  explain "cmd"               Explain a shell command before running
  safe_run "cmd"              Explain + approve + execute a command
  plan "task"                 Generate a plan, approve, execute per-command
  review file.cpp             Code review a file
  diff_review [ref]           Review current git diff (default: HEAD)
  claude_help                 This message

Configuration (set before sourcing or export in shell):
  CLAUDE_MODEL                Model to use          (default: claude-sonnet-4-20250514)
  CLAUDE_MAX_TOKENS           Token cap             (default: 4096)
  CLAUDE_LOG                  Log file path         (default: ~/.claude_history.log)
  CLAUDE_ALLOWED_DIR          Scope for plan()      (default: $HOME)
  ANTHROPIC_API_KEY           Required — your API key
EOF
}
