# Security Status

> This document is the single answer to: **"How are we doing on security?"**
> Updated by the supervisor after each security heartbeat run.

---

## Headline

**Status:** 🟡 AMBER
**As of:** 2026-03-20
**Summary:** Risk register initialised. No compromise signals detected. Three medium risks require Cronje decision before mitigation can begin (SEC-001, SEC-002, SEC-003). No autonomous enhancements taken yet — HA access audit is the designated first action.

---

## Active Incidents

None.

---

## Risk Summary

| Band | Count | IDs |
|------|-------|-----|
| Critical | 0 | — |
| High | 0 | — |
| Medium | 5 | SEC-001, SEC-002, SEC-003, SEC-004, SEC-005 |
| Low / Accepted | 1 | SEC-006 |

**Risks awaiting Cronje decision:** 3 (SEC-001, SEC-002, SEC-003)
**Risks supervisor can progress autonomously:** 2 (SEC-004 pre-emptive, SEC-005 boundary documentation)

---

## Recent Heartbeat Actions

| Date | Action | Outcome |
|------|--------|---------|
| 2026-03-20 | Risk register and heartbeat runbook created | Initialised — no prior baseline |

---

## Risks Awaiting Cronje Decision

| ID | Risk | Open Since | Recommended Next Step |
|----|------|------------|----------------------|
| SEC-001 | Alarm domain access via agent | 2026-03-20 | Confirm whether `alarm_control_panel.*` is reachable by any current token — answer needed to determine if guardrail is already in place or must be added |
| SEC-002 | Over-scoped HA API token | 2026-03-20 | Approve HA Access Audit work package so supervisor can map current token scopes |
| SEC-003 | Plaintext credentials in TOOLS.md | 2026-03-20 | Decide: accept current risk (workspace access is controlled) or migrate credentials to env file approach |

---

## Heartbeat History

| Date | Compromise Signals | Action Taken | Status |
|------|--------------------|--------------|--------|
| 2026-03-20 | Not yet run — baseline entry | Register initialised | AMBER |
