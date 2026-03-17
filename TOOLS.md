# TOOLS.md

## Runtime Paths

- OpenClaw live config: `/home/cronjev/.openclaw/openclaw.json`
- Main workspace: `/home/cronjev/.openclaw/workspace`
- Supervisor workspace: `/home/cronjev/.openclaw/workspace-supervisor`
- Main session logs: `/home/cronjev/.openclaw/agents/main/sessions`
- Supervisor session logs: `/home/cronjev/.openclaw/agents/supervisor/sessions`

## Local Repositories

- home-improvement control plane: `/mnt/c/git/home-improvement`
- OpenClaw runtime repo mirror: `/mnt/c/git/OpenClawHA`
- Request repo: `/mnt/c/git/AlexaHA`

## High-Value Prompt Library

- `/mnt/c/git/home-improvement/prompts/PROCESS_IMPROVEMENT_REQUEST.md`
- `/mnt/c/git/home-improvement/prompts/CONTINUE_HOME_IMPROVEMENT.md`
- `/mnt/c/git/home-improvement/prompts/IMPROVEMENT_ORCHESTRATION.md`
- `/mnt/c/git/home-improvement/prompts/DEPLOY_BACK_TO_HA.md`
- `/mnt/c/git/home-improvement/prompts/CONTINUE_ALEXAHA_REQUEST_REPO.md`

## Admin Identity Notes

- Cronje Telegram sender_id: `8255517069`
- Cronje WhatsApp number: `+27832639322`
- Telegram is the supervisor/admin channel.
- WhatsApp remains the normal `main`-agent channel.

## Useful Gateway Commands

Run in a login shell if commands are missing from PATH.

- `openclaw gateway status`
- `openclaw gateway restart`
- `openclaw config validate`
- `openclaw sessions list`

## Working Heuristic

- Use live runtime files for urgent operational fixes.
- Use `home-improvement` for guided diagnosis, process work, and larger multi-repo changes.
- Mirror runtime changes back to `OpenClawHA` only when the audit trail matters.

## Home Assistant Access Paths

- Home Assistant REST API base URL on this environment: `http://192.168.0.117:8123`
- Official Home Assistant MCP endpoint: `http://192.168.0.117:8123/api/mcp`
- MCP endpoint behavior verified from supervisor shell:
  - `GET /api/mcp` returns `405 Only POST method is supported`
  - `POST /api/mcp` requires `Accept: application/json`
  - MCP `initialize` succeeds and reports server `home-assistant` version `1.26.0`
  - MCP `tools/list` succeeds
- Authentication for both REST API and `/api/mcp` works with `HOMEASSISTANT_TOKEN`
- The official HA MCP integration is distinct from the custom `ha-filesystem` MCP server used in `home-improvement`
- Custom HA filesystem MCP reference:
  - config file: `/mnt/c/git/home-improvement/.vscode/mcp.json`
  - server name: `ha-filesystem`
  - SSH host alias: `homeassistant`
  - allowed paths: `/homeassistant`, `/addon_configs/c2ac3963_openclaw_assistant/.openclaw`

## Supervisor Improvement Path

- Interactive supervisor-side escalation runbook: `/home/cronjev/.openclaw/workspace-supervisor/SUPERVISOR_IMPROVEMENT.md`
- Use the same GitHub issue workflow as `workspace/SELF_IMPROVEMENT.md`, but for interactive admin-led troubleshooting in Telegram
- Issue queue script: `/home/cronjev/.openclaw/workspace/AlexaHA/scripts/submit-improvement-issue.sh --stdin-json`
- Repo defaults:
  - owner: `cronjevh`
  - repo: `home-improvement`
- Environment/token resolution for GitHub is provided by: `/home/cronjev/.openclaw/workspace/bin/openclaw_env.sh`
- Keep supervisor as field medic by default; use this path when a case is complex enough to require durable issue tracking or guided escalation
