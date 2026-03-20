# Home Assistant Maintenance and Improvement Flow

## Purpose

Design an automated maintenance and improvement workflow for the Home Assistant environment so the system is reviewed, kept healthy, and improved continuously rather than only when something breaks.

## Outcome Vision

A recurring operational flow that:
- reviews Home Assistant health and hygiene
- detects issues, drift, stale entities, and low-quality automations
- proposes or executes safe improvements
- tracks bigger work items for guided follow-up

## Opportunity Areas

- backup verification
- integration health review
- stale / unavailable entities review
- low battery device review
- automation error review
- log anomaly review
- blueprint / automation quality improvements
- dashboard cleanup opportunities
- issue queueing for larger improvements

## Guiding Principle

Treat Home Assistant as a maintained system with a backlog and review cadence, not only as an event-driven automation box.

## Early Questions

- What checks should run nightly, weekly, and monthly?
- Which actions are advisory-only vs. safe to automate?
- How should findings be surfaced: digest, issue queue, cron reminders, GitHub issues?
- Which repo or workspace should hold durable improvement plans?

## Constraints and Risks

- Automated changes must have strict guardrails.
- Health checks can be autonomous more easily than remediation.
- Noise must stay low or the flow will be ignored.
- HA source-of-truth may span live config, add-ons, repos, and UI-managed state.

## Possible Work Packages for External Agent Flows

1. Define review taxonomy and cadence
2. Inventory available HA data sources and APIs
3. Design safe health-check pipeline
4. Design issue queue / recommendation workflow
5. Pilot one nightly review lane
6. Design change-approval model for safe remediations

## Available Infrastructure

### Daily HA Log Files

A daily pull of the full HA container log is already in place from the security initiative:

- **Location:** `workspace-supervisor/logs/ha/ha-YYYY-MM-DD.log`
- **Content:** full calendar day of HA logs, ANSI-stripped, one line per log entry
- **Pull script:** `workspace-supervisor/scripts/ha-pull-daily-logs.sh [YYYY-MM-DD]`
- **Cron:** `3 1 * * *` — pulls previous day's logs at 01:03 SAST daily
- **Retention:** 7 days

These files are directly usable for log anomaly review, error pattern analysis, integration health signals, and automation error detection without additional HA access setup. The `log anomaly review` opportunity area can be prototyped immediately against these files.

## Dependencies

- Reliable access to Home Assistant APIs / state
- Clarity on where recommendations and issues should be stored
- Agreement on what can be changed automatically

## Open Questions

- Should this feed the existing nightly review process or stay separate?
- Should improvements create GitHub issues automatically?
- How much should live HA changes depend on repo-backed review first?

## Next Moves

- Define the first useful nightly HA review pack.
- Separate health checks from improvement suggestions.
- Pick one safe, high-value pilot such as unavailable entities + low battery + backup status.

---

## Fork Security and Upstream Sync

### Background

Third-party HACS custom integrations are a supply-chain security surface. Integrations run as root on HA OS and have access to long-lived tokens, the local network, and the HA API. A compromised upstream maintainer or a silent HACS auto-update can deliver malicious code to a live HA system with no user-visible warning.

The strategy documented in `home-improvement/docs/fork-security-strategy.md` addresses this with a **fork isolation pattern**:

- Every actively maintained third-party integration is forked under `cronjevh/` on GitHub.
- HACS installs only from the fork, pinned to a specific release tag — never from the upstream repo directly.
- Upstream changes enter only through a deliberate branch → security review → merge → tag cycle.

### Tier 1 Repos (actively forked)

| Repo | Upstream | Type |
|---|---|---|
| `view_assist_integration` | `dinki/view_assist_integration` | HACS integration |
| `View-Assist` | `dinki/View-Assist` | Asset/content repo |
| `ViewAssist_Companion_App` | `msp1974/ViewAssist_Companion_App` | HACS integration |
| `hass_Bluetooth_Proxy` | `kvj/hass_Bluetooth_Proxy` | HACS integration |
| `hass_Bluetooth_Proxy_Companion` | `kvj/hass_Bluetooth_Proxy_Companion` | Asset repo |
| `OpenClawHA` | n/a (own repo) | HA integration |

### Automation Layer

A GitHub Actions workflow (`home-improvement/.github/workflows/sync-upstream-forks.yml`) runs daily:
- Checks each Tier 1 upstream for new release tags via the GitHub API.
- Compares against the last-synced tag recorded in `home-improvement/config/upstream-tracking.json`.
- Opens a labeled issue in `home-improvement` for any new upstream release, with the security review checklist and diff link pre-populated.

The security review, merge decision, and HACS update remain human-in-the-loop — the workflow is detection only.

### Security Review Checklist (summary)

For each upstream diff: check for new Python dependencies, new external HTTP calls, new subprocess/exec/eval usage, new token handling, and changes to upstream CI/CD workflows. Full checklist in `home-improvement/docs/fork-security-strategy.md`.

### Related Docs

- `home-improvement/docs/fork-security-strategy.md` — threat model, per-repo matrix, checklist
- `home-improvement/docs/upstream-sync-workflow.md` — step-by-step sync procedure, branching, tagging
- `home-improvement/config/upstream-tracking.json` — machine-readable repo registry

---

## OpenClaw Memory Agent: Potential Coordination Roles

OpenClaw is well-positioned to act as a coordination layer between the automated detection (GitHub Actions) and the human review step, without owning the review itself. Possible avenues:

### 1. Pending sync reminder

When GitHub opens an `upstream-sync` issue, OpenClaw could surface it as a reminder via voice or dashboard:
> "You have 2 upstream security reviews pending in home-improvement."

Trigger: OpenClaw polls the GitHub API for open `upstream-sync` issues (or reads a summary file the workflow writes). Cadence: weekly digest, or on request.

### 2. Tag reconciliation tracker

The fork repos currently have version mismatches between their manifest versions and git tags (e.g., `hass_Bluetooth_Proxy` manifest=`0.1.31`, tag=`0.1.3`). OpenClaw's memory could hold the list of outstanding reconciliation actions and report progress:
> "3 of 6 fork tags are still unreconciled."

Source: OpenClaw reads `config/upstream-tracking.json` and compares `fork_current_tag` vs `fork_manifest_version`.

### 3. Post-HACS-update prompt

When a Tier 2 integration (click-to-update) is updated via HACS, OpenClaw could prompt a post-install hygiene check:
> "You just updated X. Did you review the changelog before confirming?"

Trigger: HA event or log pattern indicating a HACS install completed.

### 4. Fork health digest

A periodic (e.g., monthly) digest surface in the dashboard or via voice:
- Which Tier 1 repos are behind upstream (and by how many releases)
- Which repos still have no tags
- Which have open sync issues

Data source: `config/upstream-tracking.json` + GitHub API (upstream latest tag vs. recorded last-synced).

### 5. Memory of past security decisions

OpenClaw's memory agent could record decisions made during upstream reviews:
> "Rejected upstream PR from dinki/view_assist_integration on 2026-03-15 — added unexplained aiohttp call to external server."

This gives future reviewers (human or AI) a decision trail without needing to dig through git history.

### 6. Escalation gating

If an upstream sync issue has been open for more than N days without being closed, OpenClaw could escalate — either bumping it in the digest or creating a task in the improvement queue for a guided review session in the IDE.

### Design Constraints

- OpenClaw should **not** perform the security review itself — that requires human judgment or a dedicated Codex session with the full diff in context.
- OpenClaw should **not** trigger HACS updates or merge PRs — coordination and reminder only.
- Memory entries about past decisions should be timestamped and scoped to the specific upstream version reviewed, so they don't mislead future reviews.
- Noise control is critical: reminders should be batched into a weekly digest rather than interrupting daily operation.
