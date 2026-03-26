# Conversation Review Heartbeat

## Status

Legacy breadcrumb only.

## Purpose

Point readers from the old supervisor initiative to the active Mission Control board and workspaces.

## Cadence

- Do not run this as part of unattended supervisor heartbeat.
- Do not revive this file as an operational review runbook.
- Only update this file if the active board or workspace locations change again.

## Active Locations

Current execution surface:
- Board: `http://localhost:3000/boards/07b7a8fd-942a-4664-b5c8-a73310f1764c`
- Lead workspace: `/home/cronjev/.openclaw/workspace-lead-07b7a8fd-942a-4664-b5c8-a73310f1764c`
- Specialist workspace: `/home/cronjev/.openclaw/workspace-conv-review`
- Downstream execution and validation: `/mnt/c/git/OpenClawHA/`

## Output Shape

If this file is reached during a generic automated heartbeat, stop and report `HEARTBEAT_OK`.

If a human lands here looking for the live workflow, send them to the board and workspaces above.
