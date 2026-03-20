#!/usr/bin/env bash
set -euo pipefail

LOG_PATH="${1:-/homeassistant/home-assistant.log}"
MATCH_THRESHOLD="${MATCH_THRESHOLD:-5}"
TAIL_LINES="${TAIL_LINES:-5000}"

PATTERN='Login attempt or request with invalid authentication|Invalid authentication|Failed login'

if [[ ! -f "$LOG_PATH" ]]; then
  echo "STATUS=ERROR"
  echo "DETAIL=log file not found: $LOG_PATH"
  exit 0
fi

matches=$(tail -n "$TAIL_LINES" "$LOG_PATH" 2>/dev/null | grep -E "$PATTERN" || true)
match_count=$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')

ips=$(
  printf '%s\n' "$matches" \
    | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' \
    | sort \
    | uniq -c \
    | sort -nr \
    || true
)

repeat_ip="none"
repeat_ip_count=0
if [[ -n "${ips// /}" ]]; then
  repeat_ip_count=$(printf '%s\n' "$ips" | awk 'NR==1 {print $1}')
  repeat_ip=$(printf '%s\n' "$ips" | awk 'NR==1 {print $2}')
fi

if (( match_count >= MATCH_THRESHOLD )); then
  status="INCIDENT"
else
  status="CLEAN"
fi

echo "STATUS=$status"
echo "MATCH_COUNT=$match_count"
echo "MATCH_THRESHOLD=$MATCH_THRESHOLD"
echo "TAIL_LINES=$TAIL_LINES"
echo "REPEATED_IP=${repeat_ip}"
echo "REPEATED_IP_COUNT=${repeat_ip_count}"

echo "MATCH_SAMPLE<<EOF"
if [[ -n "${matches// /}" ]]; then
  printf '%s\n' "$matches" | tail -n 10
fi
echo "EOF"
