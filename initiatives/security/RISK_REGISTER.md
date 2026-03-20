# Risk Register — OpenClaw + Home Assistant Security

**Scale:** 5×5 matrix — Likelihood (1 Rare → 5 Almost Certain) × Impact (1 Negligible → 5 Critical)

**Bands:** 1–4 Low · 5–9 Medium · 10–14 High · 15–25 Critical

**Owner key:** `Auto` = supervisor can act without approval · `Cronje` = requires explicit sign-off

**Review cadence:** Critical = immediate · High = monthly · Medium = quarterly · Low/Accepted = annually

---

## Open Risks

| ID | Risk | L | I | Score | Band | Current Mitigation | Owner | Last Reviewed | Next Review | Status |
|----|------|---|---|-------|------|--------------------|-------|--------------|-------------|--------|
| SEC-001 | Agent deactivates alarm system via prompt injection — external malicious input triggers `alarm_control_panel.*` write | 1 | 5 | 5 | Medium | None confirmed — token scope audit pending | Cronje | 2026-03-20 | 2026-06-20 | **Open — audit required** |
| SEC-002 | Over-scoped HA API token — single broad token grants more access than any agent role needs, amplifying blast radius of any compromise | 3 | 3 | 9 | Medium | None confirmed | Cronje | 2026-03-20 | 2026-06-20 | **Open — audit required** |
| SEC-003 | Plaintext credentials in workspace files — HA token, Telegram IDs, and API endpoints visible in TOOLS.md and similar files | 3 | 3 | 9 | Medium | None — workspace access assumed controlled | Cronje | 2026-03-20 | 2026-06-20 | **Open — hygiene sweep needed** |
| SEC-004 | Unscreened external inputs reaching agent context — WhatsApp groups, webhooks, RSS feeds injected into prompts without filtering once integrations go live | 3 | 2 | 6 | Medium | Not yet applicable — integrations not live | Auto | 2026-03-20 | 2026-06-20 | Pre-emptive — revisit before WhatsApp triage goes live |
| SEC-005 | Agent reads outside workspace boundary — file access to `/mnt/`, `~/.ssh/`, Windows filesystem via WSL2 | 2 | 4 | 8 | Medium | WSL2 provides partial isolation; explicit tool permission grants required | Auto | 2026-03-20 | 2026-06-20 | Awareness — boundary documentation needed |

## Accepted Risks

| ID | Risk | L | I | Score | Rationale | Accepted by | Date |
|----|------|---|---|-------|-----------|-------------|------|
| SEC-006 | Agent manipulates lights, switches, or scenes via prompt injection | 2 | 1 | 2 | Cosmetic impact only; not worth degrading functionality to prevent | Cronje | 2026-03-20 |

---

## Compromise Signal Map

Signals checked automatically by the security heartbeat (see `HEARTBEAT.md` Phase 1).

| Signal | Maps to Risk | Detection Method |
|--------|-------------|-----------------|
| Repeated failed HA login / auth lines | SEC-002 | Run `scripts/security-ha-failed-login-check.sh` via `ssh homeassistant "bash -s"`; searches `ha core logs -n 2000`; incident threshold = 5 matches |
| Alarm entity state change without user action | SEC-001 | HA logbook query — `alarm_control_panel.*` state changes last 24h |
| OpenClaw token accessed `alarm_control_panel.*` domain | SEC-001, SEC-002 | HA logbook — API calls from OpenClaw token to alarm entities |
| HA token API activity with no active agent session | SEC-002 | HA logbook — activity timestamp vs known session windows |
| `TOOLS.md` or `.env` files modified unexpectedly | SEC-003 | File modification timestamp vs last known-good state |
| Repeated 403 responses in agent session | SEC-002, SEC-005 | Agent logs or HA logbook — access-denied patterns |

---

## Changelog

| Date | ID | Action | By |
|------|----|---------|----|
| 2026-03-20 | SEC-001 to SEC-006 | Initial register seeded from threat model discussion | Cronje + Supervisor |
| 2026-03-20 | SEC-002 | Added lightweight POC compromise signal for repeated failed HA login/auth lines in `home-assistant.log` | Supervisor |
