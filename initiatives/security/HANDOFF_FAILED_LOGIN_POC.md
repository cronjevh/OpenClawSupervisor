# Handoff — Failed Login Heartbeat POC

## Objective

Finish the lightweight proof-of-concept security heartbeat monitor for repeated failed Home Assistant login/authentication attempts.

This work is intentionally narrow. Do not broaden scope into a full security redesign.

## Current State

The supervisor workspace already contains:

- heartbeat runbook updated with the POC monitor:
  - `initiatives/security/HEARTBEAT.md`
- risk/status docs updated:
  - `initiatives/security/RISK_REGISTER.md`
  - `initiatives/security/STATUS.md`
- POC implementation note:
  - `initiatives/security/FAILED_LOGIN_POC.md`
- repeatable check script:
  - `scripts/security-ha-failed-login-check.sh`

Recent commits:
- `8e9a551` — `Define lightweight HA failed-login heartbeat POC`
- `293a1f4` — `Add repeatable HA failed-login heartbeat check`

## Intent / Constraints

- This is a **POC heartbeat mechanism**, not full detection engineering.
- Keep it **lightweight**, **read-only**, and **simple**.
- Prefer **grep / tail** against `/config/home-assistant.log`.
- No remediation, no blocking, no token/permission changes.
- Only goal: achieve a working repeatable heartbeat check.

## What Still Needs To Be Done

### 1. Validate real HA access path
Use the existing HA filesystem / SSH route already documented in the workspace context.

Known references:
- `/mnt/c/git/home-improvement/.vscode/mcp.json`
- server name: `ha-filesystem`
- SSH host alias: `homeassistant`
- allowed paths include `/homeassistant`
- Cronje suggested directly using `/config/home-assistant.log`

You need to verify which real path is accessible on the HA host. Possibilities:
- `/config/home-assistant.log`
- `/homeassistant/home-assistant.log`
- another equivalent path exposed by the SSH target

### 2. Validate real log patterns
Run a read-only inspection against the real HA log and confirm whether auth failures look like any of these:
- `Login attempt or request with invalid authentication`
- `Invalid authentication`
- `Failed login`
- `401`

Adjust the script pattern list if the real HA logs use different wording.

### 3. Execute the script against the live HA log
Current script:
- `scripts/security-ha-failed-login-check.sh`

Expected behavior:
- inspect last 5000 lines
- count auth-failure matches
- emit `STATUS=CLEAN|INCIDENT|ERROR`
- emit repeated IP info when visible

Validate that it works against the HA host log path.

### 4. Keep changes minimal
If needed, make only the smallest changes required to:
- correct the live log path
- tune the search patterns
- document the actual invocation shape

Do **not** expand into cron wiring unless explicitly asked.
Do **not** change the incident model beyond the current simple threshold unless the real log shape forces it.

## Suggested Validation Flow

1. Confirm HA host path accessibility
2. Read a recent slice of the HA log
3. Search manually for auth-failure strings
4. Tune `PATTERN` in `scripts/security-ha-failed-login-check.sh` if needed
5. Re-run the script against the real log path
6. Update `FAILED_LOGIN_POC.md` with the real invocation/path
7. Update `STATUS.md` with a compact note that the POC has been live-validated

## Success Criteria

The work is complete when all of the following are true:
- the script runs successfully against the real HA log source
- the pattern list matches actual HA auth-failure lines
- the invocation path is documented clearly
- the POC can be rerun repeatably by the supervisor without redesign

## Non-Goals

- full Home Assistant security analytics
- dashboarding
- alert deduplication
- remediation / blocking
- full heartbeat scheduler automation
- access audit or token-scope analysis

## Notes for the next agent

Keep the change set tight. The user explicitly said this is just a POC for the heartbeat monitoring mechanism and should stay lightweight.
