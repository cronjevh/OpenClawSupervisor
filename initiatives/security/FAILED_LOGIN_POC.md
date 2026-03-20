# Failed Login POC — Repeatable Heartbeat Check

## Purpose

This is the first concrete, lightweight security heartbeat check for the OpenClaw + Home Assistant initiative.

Goal: detect obvious repeated failed Home Assistant login or authentication attempts using a read-only scan of the HA log file.

This is a proof-of-concept signal only. It is intended to validate the heartbeat mechanism, not to provide complete intrusion detection.

## Access Model

The supervisor agent accesses the HA filesystem via the **`ha-filesystem` MCP server** (configured in `home-improvement/.vscode/mcp.json`).

- MCP server: `ha-filesystem`
- Allowed paths: `/homeassistant`, `/addon_configs/c2ac3963_openclaw_assistant/.openclaw`
- **Log path: `/homeassistant/home-assistant.log`**

Do not use SSH directly. Use the ha-filesystem MCP read tool to retrieve log content.

## Detection Rule

- Source: `/homeassistant/home-assistant.log`
- Search patterns:
  - `Login attempt or request with invalid authentication`
  - `Invalid authentication`
  - `Failed login`
- Inspection window: last `5000` lines by default
- Incident threshold: `5` or more matching lines in the inspected window

## Supervisor Execution Steps

1. Use the `ha-filesystem` MCP tool to read the tail of `/homeassistant/home-assistant.log` (last 5000 lines)
2. Search the returned content for the patterns above
3. Count matches
4. Extract any IP addresses visible in matching lines
5. Emit result in the standard output format below

## Expected Output Format

```
STATUS=CLEAN|INCIDENT|ERROR
MATCH_COUNT=<n>
MATCH_THRESHOLD=5
TAIL_LINES=5000
REPEATED_IP=<ip or none>
REPEATED_IP_COUNT=<n>
MATCH_SAMPLE=<up to 10 matching lines>
```

## Fallback Script (Human / Manual Validation)

For manual validation or one-off runs from the WSL2 host, a bash script is available:

```bash
# If SSH access to homeassistant is available:
ssh homeassistant "bash -s -- /homeassistant/home-assistant.log" \
  < scripts/security-ha-failed-login-check.sh
```

Script location: `scripts/security-ha-failed-login-check.sh`

## How to Use in Heartbeat

1. Read `/homeassistant/home-assistant.log` via ha-filesystem MCP
2. Apply pattern search
3. If `CLEAN`: record match count and timestamp in STATUS.md, continue heartbeat
4. If `INCIDENT`: record in STATUS.md, skip remaining heartbeat phases, follow notification protocol

## Notes

- Pattern list may need adjustment once real HA log samples are reviewed — update this doc if patterns are tuned
- Reverse proxies may obscure true client IPs
- Some benign stale clients (e.g. old app versions) may produce low-level noise — calibrate threshold if needed
- Keep this check simple until the broader access audit is complete
