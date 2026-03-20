#!/usr/bin/env bash
# ha-pull-daily-logs.sh [YYYY-MM-DD]
#
# Pulls a full calendar day of Home Assistant logs from the HA host via SSH.
# Defaults to yesterday. Output written to workspace-supervisor/logs/ha/.
# Retains last 7 days; older files are cleaned up automatically.
#
# Invocation:
#   scripts/ha-pull-daily-logs.sh              # yesterday
#   scripts/ha-pull-daily-logs.sh 2026-03-19   # specific date
#
# Intended to run daily at 01:00 SAST via crontab.
# Log files are then available for security checks, reporting, and other initiatives.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
LOGS_DIR="$WORKSPACE_DIR/logs/ha"

DATE="${1:-$(date -d yesterday '+%Y-%m-%d')}"
OUTPUT="$LOGS_DIR/ha-$DATE.log"

HA_SSH_OPTS="-o BatchMode=yes -o ConnectTimeout=8"
FETCH_LINES="${FETCH_LINES:-100000}"

mkdir -p "$LOGS_DIR"

if [[ -f "$OUTPUT" ]]; then
  echo "INFO: $OUTPUT already exists ($(wc -l < "$OUTPUT") lines) — skipping pull"
  exit 0
fi

echo "INFO: Pulling HA logs for $DATE from homeassistant..."

ssh $HA_SSH_OPTS homeassistant \
  "ha core logs -n $FETCH_LINES 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g'" \
  | grep "^$DATE" \
  > "$OUTPUT" || true

line_count=$(wc -l < "$OUTPUT" | tr -d ' ')

if [[ "$line_count" -eq 0 ]]; then
  rm -f "$OUTPUT"
  echo "WARN: No log lines found for $DATE — file not written. Date may be outside the $FETCH_LINES-line window." >&2
  exit 1
fi

echo "OK: Wrote $line_count lines to $OUTPUT"

# Retain last 7 days; remove older files
find "$LOGS_DIR" -name 'ha-*.log' -mtime +7 -delete
