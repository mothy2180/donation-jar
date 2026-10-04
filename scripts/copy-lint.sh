#!/usr/bin/env bash
# copy-lint: fail the build if user-facing copy contains wording that would
# misdescribe the product to a regulator or donor (PROJECT.md §11).
#
# Scope: locale JSON, content Markdown, public assets, HTML, Supabase email
# templates and docs/legal; plus the *.ts/*.tsx of the OG worker (apps/*/worker)
# and the send-email function, whose user-facing text should come from locale
# JSON or *.html templates (allow-list code-only hits such as method === "wallet").
# For *.json only the VALUE of each `"key": "value"` line is checked, so keys such
# as "coverTopUp" never trip a rule; locale JSON must therefore have one key per line.
# Exemptions: reviewed entries in scripts/copy-lint-allow.txt, one per line,
# "path|text" — a hit in <path> is allowed when its full line contains <text>
# (an empty <text> exempts the whole file). There are no inline markers.
set -euo pipefail
cd "$(dirname "$0")/.."

ALLOW_FILE="scripts/copy-lint-allow.txt"
INCLUDES=(--include='*.json' --include='*.md' --include='*.mdx' --include='*.html'
          --include='*.txt' --include='*.webmanifest' --include='*.yaml' --include='*.yml')
TS_INCLUDES=(--include='*.ts' --include='*.tsx')

PATHS=()
for p in apps/*/src apps/*/public apps/*/worker apps/*/index.html \
         supabase/templates supabase/functions/send-email docs/legal; do
  if [ -e "$p" ]; then PATHS+=("$p"); fi
done
TS_PATHS=()
for p in apps/*/worker supabase/functions/send-email; do
  if [ -e "$p" ]; then TS_PATHS+=("$p"); fi
done
if [ ${#PATHS[@]} -eq 0 ]; then echo "copy-lint: nothing to scan yet"; exit 0; fi

hits() {  # $1 = pattern; prints grep -n hits from both scopes
  grep -rniE "${INCLUDES[@]}" -- "$1" "${PATHS[@]}" 2>/dev/null || true
  if [ ${#TS_PATHS[@]} -gt 0 ]; then
    grep -rniE "${TS_INCLUDES[@]}" -- "$1" "${TS_PATHS[@]}" 2>/dev/null || true
  fi
}

# Keep this list identical to PROJECT.md §11.
BANNED=(
  'social[- ]exchange' 'bursa sosial' 'pertukaran sosial'
  'social[- ]impact projects?' 'projek impak sosial'
  'investment' 'investor' 'pelaburan'
  'return on' '(high|fixed|guaranteed|expected) returns?' 'pulangan (pelaburan|dijamin|tetap)'
  '(^|[^-[:alpha:]])wallets?([^[:alpha:]]|$)' '(^|[^-[:alpha:]])dompet([^[:alpha:]]|$)'
  '(^|[^[:alpha:]])top[- ]?up([^[:alpha:]]|$)' 'tambah nilai'
  '(LHDN|HASiL|IRBM?)[- ]approved' 'approved by (the )?(LHDN|HASiL|IRBM?)' 'diluluskan (oleh )?(LHDN|HASiL)'
  'tax[- ]deductible' 'tax (deduction|relief)' 'boleh ditolak cukai' 'potongan cukai' 'pelepasan cukai'
  'guaranteed' 'dijamin'
  'zakat' 'fitrah' 'fid(y|i)ah' 'kaff?arah'
)

allowed() {  # $1 = path, $2 = full line
  [ -f "$ALLOW_FILE" ] || return 1
  local apath atext
  while IFS='|' read -r apath atext || [ -n "$apath" ]; do
    case "$apath" in ''|'#'*) continue ;; esac
    [ "$apath" = "$1" ] || continue
    [ -z "$atext" ] && return 0
    case "$2" in *"$atext"*) return 0 ;; esac
  done < "$ALLOW_FILE"
  return 1
}

status=0

# 1) locale JSON must have one key per line
while IFS= read -r f; do
  [ -n "$f" ] || continue
  if grep -nE '"[^"]*"[[:space:]]*:[^,]*,[[:space:]]*"[^"]*"[[:space:]]*:' "$f" >/dev/null; then
    echo "copy-lint: $f has more than one key on a line — pretty-print it (one key per line)"
    status=1
  fi
done < <(find apps -path '*/locales/*.json' -type f 2>/dev/null || true)

# 2) banned wording
for pat in "${BANNED[@]}"; do
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    file=${hit%%:*}; rest=${hit#*:}; lineno=${rest%%:*}; line=${rest#*:}
    text=$line
    case "$file" in
      *.json) text=$(printf '%s' "$line" | sed -E 's/^[[:space:]]*"[^"]*"[[:space:]]*:[[:space:]]*//') ;;
    esac
    printf '%s' "$text" | grep -qiE -- "$pat" || continue   # matched only inside a JSON key
    if allowed "$file" "$line"; then continue; fi
    echo "copy-lint: /$pat/ in $file:$lineno: $line"
    status=1
  done < <(hits "$pat")
done

if [ $status -eq 0 ]; then echo "copy-lint: OK"; fi
exit $status
