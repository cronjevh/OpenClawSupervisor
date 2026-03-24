# Monica Cognitive Engagement

This legacy supervisor initiative is no longer the primary orchestration surface.

## Canonical Strategy

- Repo path: `C:\git\home-improvement\strategies\monica-cognitive-engagement\`
- Summary: repo-managed strategy for Monica cognitive engagement using VACA, Home Assistant voice assistants, prompt/content design, and nightly review flows

## Preferred Execution Surface

Use OpenClaw Mission Control for active OpenClaw-side coordination when this work needs board visibility, bounded task packets, manager review, or lightweight execution tracking.

- Mission Control repo: `\\wsl.localhost\Ubuntu\home\cronjev\openclaw-mission-control`
- Mission Control skill: `\\wsl.localhost\Ubuntu\home\cronjev\.openclaw\skills\mission-control`

## What This File Is For Now

Keep this file only as a legacy pointer and a place for supervisor-local runtime notes if something truly cannot live in the canonical strategy bundle or Mission Control.

Do not treat this file as the live initiative loop. Do not reintroduce supervisor heartbeat orchestration here.

## Next Supervisor Action

When this work is resumed from the OpenClaw side:

1. Load the canonical strategy bundle first.
2. If active OpenClaw-side execution is needed, use Mission Control rather than reviving the old initiative heartbeat flow.
3. Only add supervisor-specific runtime notes here when they are genuinely local to the supervisor workspace.