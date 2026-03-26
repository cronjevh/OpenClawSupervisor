# Conversation Review Status

> This document is the single answer to: **"Where does Conversation Review live now?"**

---

## Headline

**Status:** GREEN
**As of:** 2026-03-25
**Summary:** This supervisor initiative is deprecated. The active workflow now runs through the Mission Control Conversation Review board and its lead-plus-specialist workspaces.

---

## Active Locations

| What you need | Where it lives now |
|---------------|--------------------|
| Mission Control board | `http://localhost:3000/boards/07b7a8fd-942a-4664-b5c8-a73310f1764c` |
| Board lead charter and daily orchestration | `/home/cronjev/.openclaw/workspace-lead-07b7a8fd-942a-4664-b5c8-a73310f1764c/` |
| Review specialist method and durable review rules | `/home/cronjev/.openclaw/workspace-conv-review/` |
| Downstream nightly methodology | `/mnt/c/git/OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md` |
| Collectors and validation tooling | `/mnt/c/git/OpenClawHA/bin/` and `/mnt/c/git/OpenClawHA/validation/` |

---

## What Moved

- The dated daily review task is now created on the Mission Control board.
- Mira manages the board and task packet creation.
- `conv-review` performs the evidence review and writes a structured handoff.
- Mira evaluates that handoff, creates follow-up tasks, and closes or blocks the dated task.
- The useful methodology that used to live here has been copied into the live specialist docs.

---

## Legacy Use

Keep this directory only as a breadcrumb for rediscovery.
Do not update workflow behavior here.

---

## Next Recommended Action

If the review loop changes, update the board lead workspace or the `conv-review` workspace, then leave only a pointer here if the live location changes again.
