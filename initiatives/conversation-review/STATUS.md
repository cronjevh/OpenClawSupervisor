# Conversation Review Status

> This document is the single answer to: **"Where is the nightly conversation-review workflow specified?"**
> Updated by the supervisor when the control-plane shape changes materially.

---

## Headline

**Status:** 🟢 GREEN
**As of:** 2026-03-21
**Summary:** The nightly message-response integrity workflow is now isolated as the `conversation-review` initiative in the supervisor workspace, with explicit links to the downstream `OpenClawHA` methodology and scripts.

---

## Specification Map

| What you need | Where it lives |
|---------------|----------------|
| Supervisor-side initiative overview | `initiatives/conversation-review/conversation-review.md` |
| Supervisor-side drift/maintenance runbook | `initiatives/conversation-review/HEARTBEAT.md` |
| Downstream nightly methodology | `/mnt/c/git/OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md` |
| Nightly scaffold script | `/mnt/c/git/OpenClawHA/bin/nightly_context_review.sh` |
| WhatsApp bad-response collector | `/mnt/c/git/OpenClawHA/bin/review_whatsapp_sad_markers.py` |
| VACA voice collector | `/mnt/c/git/OpenClawHA/bin/review_vaca_history.py` |
| Daily review logs | `/mnt/c/git/OpenClawHA/memory/YYYY-MM-DD-nightly-context-review.md` |

---

## Active Review Lanes

| Lane | Trigger / Source | Purpose |
|------|------------------|---------|
| WhatsApp bad-response review | `😢` or `👎` reply marker in main-agent sessions | Capture bad interaction clusters and diagnose why the answer failed |
| VACA voice review | HA history for `sensor.vaca_215d3e5be_stt` and `sensor.vaca_215d3e5be_tts` | Identify the worst voice interactions and improve first-response behavior |

---

## Recent Control-Plane Changes

| Date | Action | Outcome |
|------|--------|---------|
| 2026-03-21 | Created `conversation-review` initiative in supervisor workspace | Nightly response-integrity logic is now grouped with other active initiatives |
| 2026-03-21 | Added explicit source map to `OpenClawHA` workflow files | Exact methodology and collector locations are easier to rediscover |

---

## Next Recommended Action

Use this initiative as the supervisor-side home for any future changes to nightly review methodology, and treat `OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md` as the downstream execution spec that must stay in sync.
