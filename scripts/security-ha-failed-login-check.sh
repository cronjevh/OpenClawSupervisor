#!/usr/bin/env bash
# security-ha-failed-login-check.sh [log_file]
#
# Checks for repeated failed Home Assistant login attempts.
#
# Two modes:
#   File mode:  pass a daily log file as $1 (full coverage — preferred)
#               scripts/security-ha-failed-login-check.sh logs/ha/ha-2026-03-19.log
#
#   Live mode:  no argument — runs via SSH against live HA container logs (last 2000 lines)
#               ssh homeassistant "bash -s" < scripts/security-ha-failed-login-check.sh
#
# See initiatives/security/FAILED_LOGIN_CHECK.md for details.

set -euo pipefail

MATCH_THRESHOLD="${MATCH_THRESHOLD:-5}"
PATTERN='Login attempt or request with invalid authentication|Invalid authentication|Failed login'

LOG_FILE="${1:-}"

if [[ -n "$LOG_FILE" ]]; then
  # File mode — run locally against the pulled daily log
  if [[ ! -f "$LOG_FILE" ]]; then
    echo "STATUS=ERROR"
    echo "DETAIL=log file not found: $LOG_FILE"
    exit 0
  fi
  log_content=$(cat "$LOG_FILE")
  source_label="file:$LOG_FILE"
else
  # Live mode — runs on the HA host via: ssh homeassistant "bash -s" < this_script
  TAIL_LINES="${TAIL_LINES:-2000}"
  log_content=$(ha core logs -n "$TAIL_LINES" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' || true)
  source_label="live:ha-core-logs-n${TAIL_LINES}"

  if [[ -z "$log_content" ]]; then
    echo "STATUS=ERROR"
    echo "DETAIL=ha core logs returned no output"
    exit 0
  fi
fi

matches=$(printf '%s\n' "$log_content" | grep -E "$PATTERN" || true)
match_count=$(printf '%s\n' "$matches" | sed '/^$/d' | wc -l | tr -d ' ')

# Extract IPs (IPv4 and IPv6) from 'from <ip> (' pattern
ips=$(
  printf '%s\n' "$matches" \
    | grep -Eo 'from [^ ]+' \
    | awk '{print $2}' \
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
echo "SOURCE=$source_label"
echo "MATCH_COUNT=$match_count"
echo "MATCH_THRESHOLD=$MATCH_THRESHOLD"
echo "REPEATED_IP=${repeat_ip}"
echo "REPEATED_IP_COUNT=${repeat_ip_count}"

echo "MATCH_SAMPLE<<EOF"
if [[ -n "${matches// /}" ]]; then
  printf '%s\n' "$matches" | tail -n 10
fi
echo "EOF"
