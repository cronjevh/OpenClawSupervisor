# Supervisor Improvement Workflow

This workspace is the interactive escalation path for larger OpenClaw / Home Assistant troubleshooting that is being driven directly by Cronje in Telegram.

Use this when:
- Cronje is specifying a complex failure or enhancement interactively in supervisor chat
- the issue needs iterative diagnosis before it is ready for implementation
- the task may become GitHub-tracked work for `cronjevh/home-improvement`
- the eventual fix may involve `home-improvement`, `AlexaHA`, live Home Assistant, or live OpenClaw runtime changes

Do not use this workflow for routine end-user assistance or lightweight field-medic fixes that can be closed immediately.

## Purpose

This is the supervisor-side companion to `workspace/SELF_IMPROVEMENT.md`.

Difference in operating model:
- `main` -> `self_improvement` is the autonomous first-aid kit for unattended backlog work
- `supervisor` -> supervisor improvement flow is the interactive escalation path for harder cases being shaped live with Cronje

## Core Rule

The supervisor may help **spec, diagnose, and queue** complex issues interactively.
It should only jump to implementation when scope is verified and the live edit path is safe.

## Available Execution Paths

1. **Queue a GitHub Issue**
   - Use `workspace/AlexaHA/scripts/submit-improvement-issue.sh --stdin-json`
   - Repo defaults to `cronjevh/home-improvement`
   - Preferred when the issue needs multi-step implementation, repo work, or later unattended processing

2. **Drive live diagnosis from supervisor**
   - Inspect OpenClaw live files under `/home/cronjev/.openclaw`
   - Use Home Assistant REST API at `http://192.168.0.117:8123`
   - Use official Home Assistant MCP endpoint at `http://192.168.0.117:8123/api/mcp`
   - Use local repos under `/mnt/c/git/home-improvement`, `/mnt/c/git/OpenClawHA`, `/mnt/c/git/AlexaHA`

3. **Escalate to implementation path**
   - For repo-guided work: use `home-improvement` prompts and scripts
   - For live HA/OpenClaw file surgery: use the established higher-surgery workflow rather than improvising from supervisor

## Queue vs Implement Decision Rule

**Queue a GitHub Issue when any of the following are true:**
- The problem statement is still being clarified and needs durable tracking
- The task spans multiple systems, repos, or deployment boundaries
- The fix likely belongs in `home-improvement` orchestration or a related repo
- The issue needs unattended follow-through, review, or repeated attempts
- The supervisor can diagnose the gap, but should not perform speculative live edits yet

**Implement directly from supervisor only when ALL of the following are true:**
- The target system and path are verified live
- The requested change is small, targeted, and reversible
- Cronje is explicitly asking for a live fix in this chat
- The verification step is clear and low-risk

**Never:**
- invent missing implementation details
- write speculative HA/OpenClaw config
- pretend a queued issue is already fixed
- widen supervisor into an always-on unrestricted surgery tool

## Issue Spec Template

When queuing an issue, capture:

- `title`: short, concrete, deduplicatable
- `request`: what Cronje wants changed
- `actual`: what currently happens
- `gap`: the suspected missing capability / root cause / tooling gap
- `verification`: how the future fix should be verified
- `evidence`: optional logs, URLs, transcript snippets, observed endpoints, tool results
- `classification`: one of:
  - `ha-config`
  - `openclaw-runtime`
  - `control-plane-only`

## Preferred Queue Command

Use the live workspace copy of the script:

```sh
/home/cronjev/.openclaw/workspace/AlexaHA/scripts/submit-improvement-issue.sh --stdin-json
```

Pass JSON on stdin. Example:

```json
{
  "title": "Supervisor: add interactive escalation path for complex HA/OpenClaw troubleshooting",
  "request": "Let supervisor handle complex improvement cases interactively in Telegram using the same GitHub issue workflow as self_improvement.",
  "actual": "Supervisor can diagnose and edit local files, but has no dedicated documented escalation workflow tied to the GitHub issue pipeline.",
  "gap": "Missing supervisor-side runbook for when to diagnose live, when to queue, and how to hand work into the existing improvement pipeline.",
  "verification": "Supervisor can consistently document, classify, and queue complex cases without improvising or conflating field-medic fixes with surgery.",
  "classification": "openclaw-runtime"
}
```

The script deduplicates on exact open issue title and prints the issue URL.

## Suggested Interactive Conversation Flow

1. Clarify the problem until scope is concrete enough to classify.
2. Decide: quick live fix vs tracked issue.
3. If tracked issue:
   - write the issue cleanly
   - include the exact observed environment details that matter
   - queue it immediately
4. If live fix:
   - verify target path/entity/system first
   - apply the smallest safe change
   - verify immediately
   - if the result exposes a durable process lesson, update supervisor memory

## Environment Notes

- OpenClaw live state: `/home/cronjev/.openclaw`
- Main workspace: `/home/cronjev/.openclaw/workspace`
- Supervisor workspace: `/home/cronjev/.openclaw/workspace-supervisor`
- Home Assistant REST API: `http://192.168.0.117:8123`
- Home Assistant MCP: `http://192.168.0.117:8123/api/mcp`
- HA auth token: `HOMEASSISTANT_TOKEN`
- Improvement issue script: `/home/cronjev/.openclaw/workspace/AlexaHA/scripts/submit-improvement-issue.sh`

## Reporting Back To Cronje

Keep the Telegram reply short and operational:
- if queued: say it was queued and give the issue URL
- if fixed live: say what changed and how it was verified
- if blocked: say the blocker and the next bounded step
