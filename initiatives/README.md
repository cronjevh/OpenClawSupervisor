# Initiative Directory

This folder tracks medium- and long-horizon initiatives that are good candidates for external subscription-based agent flows.

The aim is to keep a compact local control plane in the supervisor workspace:
- one index page to see the landscape
- one stub per initiative
- enough structure to hand work to an external agent without rethinking the problem from scratch each time

## Current Initiatives

1. [Community WhatsApp Signal Triage](./community-whatsapp-signal-triage.md)
2. [Monica Cognitive Engagement](./monica-cognitive-engagement.md)
3. [Home Assistant Maintenance and Improvement Flow](./home-assistant-maintenance-and-improvement-flow.md)
4. [Home Ownership Maintenance Schedules and Reminders](./home-ownership-maintenance-schedules-and-reminders.md)

## Control Files

- [Heartbeat](./HEARTBEAT.md)
- [PR Workflow](./PR_WORKFLOW.md)

## Suggested Working Pattern

For each initiative:
1. Clarify desired outcome and constraints.
2. Capture known inputs, systems, and data sources.
3. Break the work into subscription-agent-sized work packages.
4. Keep implementation notes and decisions in the initiative page.
5. Link any repos, prompts, issues, or automations that get created.

## Cross-Initiative Questions

- Which initiatives should stay advisory vs. become autonomous?
- Which ones need human approval before sending messages or changing systems?
- Which systems are the source of truth for state, schedules, and history?
- Which work should be done in supervisor runtime files vs. repo-guided control-plane flows?

## Next Step Ideas

- Add prioritisation and sequencing across the four initiatives.
- Add an external-agent handoff template for substantial work.
- Add links to any GitHub issues, prompt files, or recurring review flows that emerge.
