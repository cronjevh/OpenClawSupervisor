# Initiative Directory

This folder tracks medium- and long-horizon initiatives that are good candidates for external subscription-based agent flows.

The aim is to keep a compact local control plane in the supervisor workspace:
- one index page to see the landscape
- active initiatives in their own directory with a risk register or working artefacts alongside the stub
- stubs not yet ready for work in `backlog/`
- enough structure to hand work to an external agent without rethinking the problem from scratch each time

## Active Initiatives

| Initiative | Directory | Status |
|------------|-----------|--------|
| [OpenClaw + Home Assistant Security Hardening and Proactive Monitoring](./security/security-hardening-and-proactive-monitoring.md) | [security/](./security/) | Risk register seeded — HA access audit is next move |

## Backlog

Stubs awaiting prioritisation before active work begins:

1. [Community WhatsApp Signal Triage](./backlog/community-whatsapp-signal-triage.md)
2. [Monica Cognitive Engagement](./backlog/monica-cognitive-engagement.md)
3. [Home Assistant Maintenance and Improvement Flow](./backlog/home-assistant-maintenance-and-improvement-flow.md)
4. [Home Ownership Maintenance Schedules and Reminders](./backlog/home-ownership-maintenance-schedules-and-reminders.md)

## Control Files

- [Heartbeat](./HEARTBEAT.md)
- [PR Workflow](./PR_WORKFLOW.md)

## Suggested Working Pattern

For each active initiative:
1. Clarify desired outcome and constraints.
2. Capture known inputs, systems, and data sources.
3. Break the work into subscription-agent-sized work packages.
4. Maintain a `RISK_REGISTER.md` for initiatives with security or safety considerations.
5. Keep implementation notes and decisions in the initiative page.
6. Link any repos, prompts, issues, or automations that get created.

## Cross-Initiative Questions

- Which initiatives should stay advisory vs. become autonomous?
- Which ones need human approval before sending messages or changing systems?
- Which systems are the source of truth for state, schedules, and history?
- Which work should be done in supervisor runtime files vs. repo-guided control-plane flows?
