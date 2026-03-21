# Conversation Review Status

> This document is the single answer to: **"Where is the nightly conversation-review workflow specified?"**
> Updated by the supervisor when the control-plane shape changes materially.

---

## Headline

**Status:** 🟢 GREEN
**As of:** 2026-03-21
**Summary:** The nightly message-response integrity workflow is isolated as the `conversation-review` initiative in the supervisor workspace, now includes latency review for simple requests, and now explicitly blocks unvalidated primary-user rollout for risky behavior changes.

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
| Slow simple request collector | `/mnt/c/git/OpenClawHA/bin/review_simple_slow_requests.py` |
| Validation case extractor | `/mnt/c/git/OpenClawHA/bin/create_validation_case.py` |
| Validation harness runner | `/mnt/c/git/OpenClawHA/bin/run_validation_cases.py` |
| Validation workflow notes | `/mnt/c/git/OpenClawHA/validation/README.md` |
| Executable validation cases | `/mnt/c/git/OpenClawHA/validation/cases/` |
| Daily review logs | `/mnt/c/git/OpenClawHA/memory/YYYY-MM-DD-nightly-context-review.md` |

---

## Active Review Lanes

| Lane | Trigger / Source | Purpose |
|------|------------------|---------|
| WhatsApp bad-response review | `😢` or `👎` reply marker in main-agent sessions | Capture bad interaction clusters and diagnose why the answer failed |
| VACA voice review | HA history for `sensor.vaca_215d3e5be_stt` and `sensor.vaca_215d3e5be_tts` | Identify the worst voice interactions and improve first-response behavior |
| Simple-but-slow review | Recent session logs plus timing breakdown | Catch short straightforward requests that took too long and tighten the fast path |

---

## Recent Control-Plane Changes

| Date | Action | Outcome |
|------|--------|---------|
| 2026-03-21 | Created `conversation-review` initiative in supervisor workspace | Nightly response-integrity logic is now grouped with other active initiatives |
| 2026-03-21 | Added explicit source map to `OpenClawHA` workflow files | Exact methodology and collector locations are easier to rediscover |
| 2026-03-21 | Added simple-request latency review lane | Nightly review can now flag short requests that were slowed by avoidable reasoning or missing fast-path tooling |
| 2026-03-21 | Added validation gate for risky behavior changes | Candidate fixes now need offline review or safe canary evidence before primary rollout |
| 2026-03-21 | Added executable validation harness scaffold | Real phrases can now be run through an automated CLI case runner with assertions for reply shape, tool path, and latency |

---

## Next Recommended Action

Use this initiative as the supervisor-side home for any future changes to nightly review methodology, and treat `OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md` as the downstream execution spec that must stay in sync.
