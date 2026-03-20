# MEMORY.md

## Workspace Mission

This workspace is the supervisor channel for Cronje over Telegram.

It is meant for field-medic work:
- unstick OpenClaw runtime issues
- inspect live session logs
- repair prompts, memory, routing, and lightweight config problems
- handle authenticated admin requests quickly

Normal day-to-day conversation remains on WhatsApp with the `main` agent.

## Channel Map

- WhatsApp direct DM from `+27832639322` should land on `main`
- Telegram direct DM from sender `8255517069` should land on `supervisor`
- `supervisor` should use `openrouter/openai/gpt-5.4` as primary model

## Repo and Runtime Map

- `/mnt/c/git/home-improvement` is the orchestration and process library
- `/mnt/c/git/OpenClawHA` is the runtime/workspace repo mirror when an audit snapshot is useful
- `/mnt/c/git/AlexaHA` is the request repo
- `/home/cronjev/.openclaw` is the live OpenClaw state and runtime source of truth on this machine

## Operating Guidance

- For small runtime fixes, work directly against the live OpenClaw state.
- For larger changes, anchor the work in the `home-improvement` prompts and docs.
- Prefer the smallest robust fix that closes the observed gap.
- Be explicit about whether a change is live-only or mirrored to a repo.

## Known Admin Facts

- Cronje is the authenticated system admin.
- Verified Telegram admin identity: `8255517069`
- Verified WhatsApp admin identity: `+27832639322`

## Durable Lessons

- Static peer binding is the correct mechanism for true interactive channel-to-agent routing.
- One-off subagent handoff is not a substitute for an interactive routed session.
- Smaller models become unreliable when admin policy is spread across multiple conflicting prompt files.
- Keep high-impact admin routing and identity rules short, explicit, and centralized.
- On this environment, Home Assistant is reachable live at `http://192.168.0.117:8123` using `HOMEASSISTANT_TOKEN`.
- The official Home Assistant MCP integration is reachable at `http://192.168.0.117:8123/api/mcp`; it is POST-only, requires `Accept: application/json`, and successfully answered MCP `initialize` and `tools/list` during supervisor validation.
- Do not confuse the official HA MCP integration (`/api/mcp`) with the separate custom `ha-filesystem` MCP server defined under `home-improvement/.vscode/mcp.json` for SSH-backed file edits on `/homeassistant` and add-on OpenClaw paths.
- Supervisor now has a documented interactive escalation workflow in `SUPERVISOR_IMPROVEMENT.md` that mirrors the GitHub-issue queueing pattern from `workspace/SELF_IMPROVEMENT.md`, but is meant for admin-led complex troubleshooting rather than unattended first-aid runs.
- Strategic initiatives are tracked under `initiatives/` in the supervisor workspace, with `initiatives/README.md` as the directory, `initiatives/HEARTBEAT.md` for periodic review guidance, and `initiatives/PR_WORKFLOW.md` for turning initiative work into external-agent branch/PR flows.
- Cronje prefers supervisor workspace changes to be pushed to GitHub regularly rather than existing only as local commits. Source: sessions/ca2c7316-1f02-43b3-96b7-46b0b48af300.jsonl#L56-L57
