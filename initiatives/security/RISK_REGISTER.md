# Risk Register — OpenClaw + Home Assistant Security

**Scale:** 5×5 matrix — Likelihood (1 Rare → 5 Almost Certain) × Impact (1 Negligible → 5 Critical)

**Bands:** 1–4 Low · 5–9 Medium · 10–14 High · 15–25 Critical

**Owner key:** `Auto` = supervisor can act without approval · `Cronje` = requires explicit sign-off

---

## Register

| ID | Risk | L | I | Score | Band | Current Mitigation | Owner | Status |
|----|------|---|---|-------|------|--------------------|-------|--------|
| SEC-001 | Agent deactivates alarm system via prompt injection — external malicious input triggers `alarm_control_panel.*` write | 1 | 5 | 5 | Medium | None confirmed — audit of token scope pending | Cronje | **Open — audit required** |
| SEC-002 | Over-scoped HA API token — single broad token grants more access than any agent role needs, amplifying blast radius of any compromise | 3 | 3 | 9 | Medium | None confirmed | Cronje | **Open — audit required** |
| SEC-003 | Plaintext credentials in workspace files — HA token, Telegram IDs, and API endpoints visible in TOOLS.md and similar files | 3 | 3 | 9 | Medium | None — current working assumption is workspace access is controlled | Cronje | **Open — hygiene sweep needed** |
| SEC-004 | Unscreened external inputs reaching agent context — WhatsApp groups, webhooks, RSS feeds injected into prompts without filtering once integrations go live | 3 | 2 | 6 | Medium | Not yet applicable — integrations not live | Auto | Pre-emptive — revisit before WhatsApp triage goes live |
| SEC-005 | Agent reads outside workspace boundary — file access to `/mnt/`, `~/.ssh/`, Windows filesystem via WSL2 | 2 | 4 | 8 | Medium | WSL2 provides partial isolation; explicit tool permission grants required | Auto | Awareness — document boundary, no hard block needed now |
| SEC-006 | Agent manipulates lights, switches, or scenes via prompt injection | 2 | 1 | 2 | Low | None — accepted risk | Auto | **Accepted** |

---

## Accepted Risks

| ID | Risk | Rationale | Accepted by | Date |
|----|------|-----------|-------------|------|
| SEC-006 | Light/switch/scene manipulation via prompt injection | Cosmetic impact only; not worth degrading functionality to prevent | Cronje | 2026-03-20 |

---

## Review Cadence

| Band | Frequency |
|------|-----------|
| Critical | Immediate — block and notify |
| High | Monthly review |
| Medium | Quarterly review or on material change to integrations |
| Low / Accepted | Annual or on architecture change |

---

## Changelog

| Date | ID | Change |
|------|----|--------|
| 2026-03-20 | SEC-001 to SEC-006 | Initial register seeded from threat model discussion |
