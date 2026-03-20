# Failed Login Check — Repeatable Heartbeat Check

## Status: VALIDATED 2026-03-20

## Purpose

Recurring security heartbeat check for the OpenClaw + Home Assistant initiative. Detects repeated failed Home Assistant login or authentication attempts.

This check is intentionally lightweight — it is one signal among several, not a complete intrusion detection system.

## Access Model

**HA 2024.5+ removed `/api/error_log`.** Logs are accessed via the `ha` CLI on the HA host, which reads from the running HA container.

Invocation from WSL2:
```bash
ssh -o BatchMode=yes -o ConnectTimeout=8 homeassistant "bash -s" \
  < workspace-supervisor/scripts/security-ha-failed-login-check.sh
```

SSH prerequisite: `/home/cronjev/.ssh/config`, `id_ed25519`, and `known_hosts` must exist with Linux-safe permissions (see TOOLS.md).

The `ha-filesystem` MCP server (used by OpenClaw agents in the home-improvement context) does **not** apply here — HA logs are not on the filesystem as a plain file in HA 2026.x. Use `ha core logs` via SSH instead.

## Detection Rule

- Source: `ha core logs -n 2000` (last 2000 log lines from the running HA container)
- Confirmed working pattern: `Login attempt or request with invalid authentication`
- Additional patterns: `Invalid authentication`, `Failed login`
- Incident threshold: 5 or more matching lines in the inspection window
- IP extraction: handles both IPv4 and IPv6 (extracted from `from <ip> (` pattern in log lines)

## Validated Log Format

```
2026-03-20 16:10:29.722 WARNING (MainThread) [homeassistant.components.http.ban] Login attempt or request with invalid authentication from fe80::c943:28dc:42b1:f7da (fe80::c943:28dc:42b1:f7da). Requested URL: '/auth/login_flow/...'. (Mozilla/5.0 ...)
```

- Logger: `homeassistant.components.http.ban`
- Level: `WARNING`
- IP appears as IPv6 link-local for LAN clients (e.g. `fe80::...`)
- User agent is included — useful for distinguishing browser tests from automation probes

## Script Output Format

```
STATUS=CLEAN|INCIDENT|ERROR
MATCH_COUNT=<n>
MATCH_THRESHOLD=5
TAIL_LINES=2000
REPEATED_IP=<ip or none>
REPEATED_IP_COUNT=<n>
MATCH_SAMPLE<<EOF
<up to 10 matching log lines>
EOF
```

## How to Use in Heartbeat

1. Run script via SSH against the HA host (see invocation above)
2. Parse `STATUS`
3. If `CLEAN`: record `MATCH_COUNT` and timestamp in STATUS.md, continue heartbeat
4. If `INCIDENT`: record in STATUS.md with `REPEATED_IP` and `MATCH_SAMPLE`, stop heartbeat, follow notification protocol
5. If `ERROR`: record in STATUS.md, flag for manual investigation

## Notes

- IPv6 link-local addresses (`fe80::`) indicate LAN clients — not necessarily external attackers
- A threshold of 5 is conservative; calibrate upward if benign stale clients generate noise
- `ha core logs` default is 100 lines; script uses `-n 2000` for adequate coverage
- ANSI escape codes are stripped from `ha core logs` output before pattern matching
