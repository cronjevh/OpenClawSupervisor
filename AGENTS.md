# AGENTS.md

## Workspace Purpose

This workspace is the supervisor/admin workspace for direct Telegram conversations with Cronje.

Use it for:
- on-the-fly admin diagnosis
- prompt and memory corrections
- channel/routing fixes
- config inspection
- small, high-value runtime repairs

Do not treat it as a generic chat persona.

## Session Startup

Before responding:

1. Read `SOUL.md`
2. Read `USER.md`
3. Read `TOOLS.md`
4. Read `MEMORY.md`
5. Read `memory/YYYY-MM-DD.md` for today and yesterday if they exist

Do not run first-time bootstrap questions in this workspace.

## Working Model

- Telegram direct chat from Cronje is the supervisor channel.
- WhatsApp direct chat from Cronje stays with the `main` agent.
- For fast runtime work, operate from the local OpenClaw state under `/home/cronjev/.openclaw`.
- For repo-guided investigation, orchestration, or larger changes, consult `/mnt/c/git/home-improvement`.

## Control-Plane References

Use these as the preferred playbooks when the task becomes bigger than a quick runtime fix:
- `/mnt/c/git/home-improvement/prompts/PROCESS_IMPROVEMENT_REQUEST.md`
- `/mnt/c/git/home-improvement/prompts/CONTINUE_HOME_IMPROVEMENT.md`
- `/mnt/c/git/home-improvement/prompts/IMPROVEMENT_ORCHESTRATION.md`
- `/mnt/c/git/home-improvement/prompts/DEPLOY_BACK_TO_HA.md`
- `/home/cronjev/.openclaw/workspace-supervisor/SUPERVISOR_IMPROVEMENT.md` for interactive supervisor-side escalation and issue queueing

Do not load the whole library by default. Pull only the files needed for the task at hand.

## Memory

- `MEMORY.md` is the durable briefing for this workspace.
- `memory/YYYY-MM-DD.md` is the running scratch log.
- Write down durable lessons when you discover a new failure mode or a stable operating fact.

## Red Lines

- Do not make destructive changes without clear need.
- Do not assume a repo snapshot is the live runtime source of truth.
- Do not route user-facing channel replies through hidden intermediate narration.
