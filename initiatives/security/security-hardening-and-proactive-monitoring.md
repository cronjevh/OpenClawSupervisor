# OpenClaw + Home Assistant Security Hardening and Proactive Monitoring

## Purpose

Maintain a living risk register for the OpenClaw and Home Assistant setup, with automated best-effort security hygiene and proactive best-practice research — without compromising working functionality.

## Outcome Vision

A supervisor agent that:
- maintains a tiered risk register: each risk classified by impact, current mitigation status, and review cadence
- proactively researches and surfaces best-practice improvements, advisory only
- applies a hard guardrail to the one critical-tier risk: alarm system access
- keeps secrets hygiene, token scope, and access patterns in steady-state review
- never blocks or degrades working functionality to address a theoretical threat

## Threat Model

**Critical (hard guardrail warranted):**
- Alarm system deactivation via `alarm_control_panel.*` — physical security bypass risk even if unlikely

**Low (best-effort awareness, no hard blocking):**
- Light/switch/scene manipulation — cosmetic, not worth breaking functionality to prevent
- Sensor data exfiltration — privacy concern but not actuation risk
- Unauthorised HA state reads — low real-world impact

**Out of scope (accepted risk):**
- Sophisticated targeted attacks — not realistic for a home setup; attacker capable of mounting a prompt injection precise enough to defeat layered controls is not the threat model here

## Opportunity Areas

- Risk register design and maintenance cadence
- HA API token audit (current scope vs minimum needed)
- Single hard guardrail: `alarm_control_panel.*` blocked from all agent access
- Per-agent least-privilege token strategy (advisory; implement without breaking flows)
- Workspace and host file-access boundary awareness
- Prompt injection awareness for external input channels (WhatsApp triage, future webhooks)
- Secrets hygiene (hardcoded tokens, credentials in workspace files)
- NeMo / NeMoClaw guardrail research — evaluate whether NVIDIA NeMo Guardrails / NemoClaw can add practical safety controls without breaking OpenClaw workflows

## Guiding Principle

Security posture should match actual risk. One hard guardrail on the single critical domain. Best-effort hygiene everywhere else. Advisory and research-driven, not enforcement-driven. Functionality is never sacrificed for a theoretical threat.

## Early Questions

- What HA token(s) are currently in use and what scopes do they carry?
- Is `alarm_control_panel.*` currently accessible via any agent token or MCP endpoint?
- What external inputs currently reach agent context (WhatsApp groups, webhooks, RSS feeds)?
- Are credentials stored in plain text in workspace files (TOOLS.md, .env, etc.)?

## Constraints and Risks

- No change should break working automations or agent flows.
- The alarm guardrail is the only justified hard block; everything else is advisory.
- Security noise must stay low — frequent low-value alerts will be ignored.
- The supervisor cannot enforce OS-level confinement; workspace boundary work is awareness and recommendation only.

## Possible Work Packages for External Agent Flows

1. **Risk Register Design** — create a structured risk register template: each entry has impact tier, likelihood, current mitigation status, owner (auto vs Cronje-approval), and review cadence; seed it with known risks from this initiative
2. **HA Access Audit** — inventory every token and integration used by OpenClaw agents; map current permission scope; identify whether `alarm_control_panel.*` is reachable; produce a gap report feeding directly into the risk register
3. **Alarm Domain Guardrail** — implement the single hard guardrail: confirm `alarm_control_panel.*` is excluded from all agent-accessible token scopes or MCP filters; verify without disrupting other HA flows
4. **Least-Privilege Token Review** — advisory review of token scopes; propose a migration to per-agent minimal tokens; flag any single token granting broad write access; do not implement without Cronje sign-off
5. **External Input Injection Awareness** — document which external channels (WhatsApp groups, webhooks, future integrations) reach agent prompts; draft lightweight screening heuristics; design as advisory flags, not hard blocks
6. **Secrets Hygiene Sweep** — scan workspace files for plaintext credentials; flag findings in the risk register with recommended remediation (env files, vault, or explicit accepted-risk notation)
7. **Security Review Cadence** — design a recurring security review routine for the supervisor: risk register review, token rotation reminders, access drift detection, and a periodic best-practice research brief tailored to the actual threat model
8. **NeMo / NemoClaw Applicability Review** — investigate `https://github.com/NVIDIA/NemoClaw` and adjacent NVIDIA guardrail tooling; determine whether any part of it can be used as a lightweight safety layer for OpenClaw without adding brittle complexity or degrading normal assistant behavior

## Dependencies

- Access to current HA token configuration and scope details
- Clarity on which integrations and external inputs are active
- Cronje's explicit accepted-risk decisions (captured in the risk register, not assumed)

## Open Questions

- Should the risk register live as a workspace file (e.g. `RISK_REGISTER.md`) or as a structured data file?
- Should security findings share the Telegram operational channel or use a lower-priority digest format?
- Once the alarm guardrail is confirmed, which risk register item is the next meaningful one to address?
- Does `NVIDIA/NemoClaw` provide a realistic, low-friction safety benefit for this installation, or would it add more integration and maintenance risk than practical protection?

## Next Moves

- Design the risk register format and seed it from this initiative's known risks.
- Run the HA Access Audit to establish baseline, with specific focus on alarm domain reachability.
- Confirm the alarm domain guardrail is in place before any other security work proceeds.
