# Security Heartbeat — Runbook

**Cadence:** Weekly (or on-demand if a trigger event occurs)
**Expected token budget:** Low — bounded by the one-enhancement rule
**Output:** Updated `STATUS.md`, updated `RISK_REGISTER.md` (last reviewed dates), and optionally one autonomous enhancement or one Cronje notification

---

## Phase 1: Compromise Signal Checks

Run each check below. For any DETECTED signal, immediately skip to the Notification Protocol — do not continue to Phase 2.

### POC Implementation Rule

Until richer HA-side telemetry is available, the first working heartbeat check should stay lightweight:
- use a read-only grep/search against `/config/home-assistant.log` via the HA filesystem path
- prefer simple string-pattern heuristics over complex parsing
- inspect a recent log slice where possible instead of the entire file
- treat this as a proof-of-concept signal, not a definitive intrusion detector

### POC Check — Failed Login / Auth Anomaly

This is the first concrete heartbeat monitor to implement.

**Goal:** detect obvious repeated failed Home Assistant login or authentication attempts.

**Source:** `/config/home-assistant.log` (via HA filesystem MCP path)

**Implementation reference:** `FAILED_LOGIN_POC.md`

**Suggested search strings (start simple):**
- `Login attempt or request with invalid authentication`
- `Invalid authentication`
- `Failed login`
- `401`

**Inspection window:** last 5000 lines by default

**POC threshold:**
- `INCIDENT` if 5 or more matching failed-auth lines are found in the recent inspection window
- otherwise `CLEAN`

**Repeatable check script:** `scripts/security-ha-failed-login-check.sh`

**Record in STATUS.md:**
- whether the failed-auth check was run
- the match count
- whether any repeated source IP was visible in the matching lines

| Check | How to Verify | Signal = Compromise Suspected |
|-------|---------------|-------------------------------|
| **Failed HA login / auth anomaly (POC)** | Grep/search `/config/home-assistant.log` for simple failed-auth patterns in a recent window | 5 or more matching failed-auth lines in the recent inspection window |
| **Alarm state anomaly** | Query `alarm_control_panel.*` state via HA REST; check logbook for state changes in the last 24h | State changed to `disarmed` or `disabled` without a corresponding user action in the logbook |
| **Alarm domain access by agent** | Scan HA logbook for any API calls to `alarm_control_panel.*` entities from the OpenClaw token | Any entry — agents must never touch this domain |
| **HA token unexpected activity** | Check HA logbook for API activity during periods when no agent session was active | Activity attributed to the OpenClaw token when no session was running |
| **Workspace credential file modified** | Check modification timestamp of `TOOLS.md` and any `.env` files against last known-good state | Unexpected modification — file changed without a recorded supervisor action |
| **Repeated HA 403 errors** | Scan agent logs or HA logbook for access-denied responses | Multiple 403s in a single session — may indicate scope probing |

If **no signals detected**: record `CLEAN` with timestamp in STATUS.md and continue to Phase 2.
If **signal detected**: record `INCIDENT` with details, skip to Notification Protocol, stop.

---

## Phase 2: Risk Register Review

Read `RISK_REGISTER.md`. For each open risk:

1. Check the **Last Reviewed** date against the review cadence for its band.
2. Flag any item overdue for review.
3. Check whether the **Current Mitigation** status has changed since last entry (e.g. an audit was completed, a token was updated).
4. Update the Last Reviewed date for any item you actively assess this run.

Identify the highest-scored open item with Owner = `Cronje` that has been open > 30 days without progress — flag for Cronje notification (low-priority digest, not immediate alert).

---

## Phase 3: Autonomous Enhancement Selection

Select **exactly one** item for autonomous action this run. Criteria (in priority order):

1. Highest risk score with Owner = `Auto` and Last Reviewed > 30 days
2. Any documentation or analysis action (not a system change) that advances an open risk
3. If nothing qualifies, update STATUS.md and stop — do not manufacture work

**Permitted autonomous actions (no Cronje approval needed):**
- Updating STATUS.md and RISK_REGISTER.md
- Running a read-only HA API query for audit or signal checking
- Researching and documenting a best-practice recommendation
- Adding a new risk entry to the register from a newly observed pattern

**Requires Cronje approval before acting:**
- Any change to HA token configuration or scope
- Any change to agent permissions or tool access
- Any new integration or webhook configuration
- Implementing a hard block or filter on agent behaviour

Document the chosen action and outcome in the Changelog section of RISK_REGISTER.md.

---

## Phase 4: Status Document Update

After completing Phases 1–3, update `STATUS.md` with:
- Current date and heartbeat run summary
- Headline status: GREEN / AMBER / RED
- Any open incidents or newly flagged risks
- The autonomous action taken (if any)
- Any risks now awaiting Cronje decision

Keep STATUS.md current — it is the single answer to "how are we doing on security?"

---

## Phase 5: Notification Protocol

### Immediate (compromise signal detected)
Do not alert at the moment of detection if it is outside 06:00–21:00 Africa/Johannesburg.
Instead: use `CronCreate` to schedule a one-shot job at 07:00 Africa/Johannesburg that sends a Telegram message to Cronje (ID: 8255517069).

Telegram message format:
```
🔴 SECURITY ALERT — OpenClaw Security Heartbeat
Detected: [signal name]
Detail: [what was observed, entity/file/log entry]
Risk: [SEC-ID] — [risk title]
Recommended action: [one clear action for Cronje]
Full status: workspace-supervisor/initiatives/security/STATUS.md
```

If detection occurs within 06:00–21:00: send immediately via Telegram.

### Weekly digest (no incident)
If heartbeat is clean and no Cronje-approval items are newly flagged: no notification required.
If one or more Cronje-approval items have been open > 30 days: send a low-priority Telegram digest at next morning 07:00.

Digest format:
```
📋 Weekly Security Digest — OpenClaw
Status: GREEN / AMBER
Risks awaiting your decision: [count]
  · [SEC-ID] [title] — open [N] days
Latest action taken: [one line]
Full status: workspace-supervisor/initiatives/security/STATUS.md
```
