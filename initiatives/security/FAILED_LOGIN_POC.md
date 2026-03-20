# Failed Login POC — Repeatable Heartbeat Check

## Purpose

This is the first concrete, lightweight security heartbeat check for the OpenClaw + Home Assistant initiative.

Goal: detect obvious repeated failed Home Assistant login or authentication attempts using a read-only scan of `/config/home-assistant.log`.

This is a proof-of-concept signal only. It is intended to validate the heartbeat mechanism, not to provide complete intrusion detection.

## Detection Rule

- Source: `/config/home-assistant.log`
- Search patterns:
  - `Login attempt or request with invalid authentication`
  - `Invalid authentication`
  - `Failed login`
  - `401`
- Inspection window: last `5000` log lines by default
- Incident threshold: `5` or more matching lines in the inspected window

## Repeatable Command Logic

Script in supervisor workspace:
- `scripts/security-ha-failed-login-check.sh`

Expected execution model:
- run on the Home Assistant host or against a copied log path
- read-only only
- output compact key-value fields plus a short sample

Example local invocation shape:
```bash
scripts/security-ha-failed-login-check.sh /path/to/home-assistant.log
```

Example HA-host invocation shape via SSH / ha-filesystem route:
```bash
ssh homeassistant "bash -s" < scripts/security-ha-failed-login-check.sh -- /config/home-assistant.log
```

## Expected Output

The script emits:
- `STATUS=CLEAN|INCIDENT|ERROR`
- `MATCH_COUNT`
- `MATCH_THRESHOLD`
- `TAIL_LINES`
- `REPEATED_IP`
- `REPEATED_IP_COUNT`
- `MATCH_SAMPLE<<EOF ... EOF`

## How to Use in Heartbeat

1. Run the script against `/config/home-assistant.log`
2. Read the emitted `STATUS`
3. If `CLEAN`, update `STATUS.md` with compact findings and continue heartbeat
4. If `INCIDENT`, update `STATUS.md`, stop the heartbeat, and follow notification protocol

## Notes

- Reverse proxies may obscure true client IPs
- Some benign stale clients may produce noise
- Pattern matching may need adjustment once real HA log samples are reviewed
- Keep this check simple until the broader access audit is complete
