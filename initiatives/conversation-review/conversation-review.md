# Conversation Review and Nightly Response Integrity

## Purpose

Keep the nightly conversation-quality improvement loop easy to find, easy to reason about, and aligned with the downstream `OpenClawHA` workflow that actually stages the changes.

This initiative exists because the process is working, but its specification had become scattered between supervisor memory notes and the implementation repo.

## Outcome Vision

A single supervisor-side initiative that answers:
- what the nightly review is for
- which channels it reviews
- what counts as a response-integrity failure
- where the executable workflow lives
- how findings are meant to turn into durable improvements

## What "Response Integrity" Means Here

The nightly review is meant to protect and improve reply quality, especially on high-value channels.

Integrity checks focus on whether responses:
- stayed aligned with the intended tone and brevity
- avoided reasoning leakage or workflow/admin language in user-facing replies
- used the smallest useful clarification instead of drifting into procedural noise
- stayed faithful to the actual interaction context instead of inventing or overextending
- produced the right kind of fix: memory, prompt, tooling, workflow, upstream issue, or no change

## Review Lanes

### 1) WhatsApp bad-response lane

Trigger:
- user replies to a bad main-agent answer with `😢` or `👎`

Collection rule:
1. Find the marked reply in the main session log.
2. Walk back the parent chain.
3. Always include at least the first two parents.
4. Keep walking back while the time gap to the prior turn is 10 minutes or less.
5. Treat the resulting slice as one bad-interaction cluster.

### 2) VACA voice lane

Source signals:
- `sensor.vaca_215d3e5be_stt`
- `sensor.vaca_215d3e5be_tts`

Collection rule:
1. Pull yesterday's history for both sensors.
2. Merge entries chronologically.
3. Group nearby STT/TTS entries into candidate interactions.
4. Identify the worst three interactions.
5. Pull matching OpenClaw session evidence for diagnosis.

## Expected Improvement Outputs

Each reviewed failure should resolve to exactly one primary action:
- durable fact -> `MEMORY.md`
- short-lived context -> `memory/YYYY-MM-DD.md`
- behavior/policy fix -> prompt/workspace files
- runtime/tooling/workflow fix -> code/config/docs
- external dependency gap -> issue via the established self-improvement path
- no change

## Source-of-Truth Map

This initiative is the supervisor-side control plane. The concrete nightly workflow lives in `OpenClawHA`.

| Concern | Source |
|--------|--------|
| Supervisor-side initiative and discoverability | `initiatives/conversation-review/` |
| Downstream methodology spec | `/mnt/c/git/OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md` |
| Nightly review scaffold | `/mnt/c/git/OpenClawHA/bin/nightly_context_review.sh` |
| WhatsApp marker review collector | `/mnt/c/git/OpenClawHA/bin/review_whatsapp_sad_markers.py` |
| VACA history review collector | `/mnt/c/git/OpenClawHA/bin/review_vaca_history.py` |
| Daily run notes / evidence log | `/mnt/c/git/OpenClawHA/memory/YYYY-MM-DD-nightly-context-review.md` |

## Supervisor Responsibilities

- keep the control-plane description easy to locate in this workspace
- ensure the nightly workflow still matches the intent described here
- spot drift between supervisor docs and the `OpenClawHA` implementation
- translate reviewed failures into the smallest durable improvement
- queue upstream or external fixes when the problem is not local to `OpenClawHA`

## Current Design Boundaries

- Do not send overnight user messages as part of review.
- Do not create a fresh PR every night.
- Do not balloon memory files with speculative clutter.
- Do not treat repo snapshots as live runtime truth unless the review explicitly needs an audit step.
- Do not keep this methodology only in session memory again; update this initiative when the workflow changes materially.

## Next Moves

- Keep `STATUS.md` current as the quick answer to "where does this live now?"
- Use `HEARTBEAT.md` to check for drift when the downstream workflow changes.
- If the review lanes or decision rubric change in `OpenClawHA`, mirror the change back into this initiative promptly.
