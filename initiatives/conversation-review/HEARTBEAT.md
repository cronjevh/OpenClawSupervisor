# Conversation Review Heartbeat

## Purpose

Keep the supervisor-side description of nightly message-response integrity aligned with the real `OpenClawHA` workflow.

## Cadence

- Weekly during initiative review
- Immediately after any material change to the nightly review methodology or scripts in `OpenClawHA`

## Drift Checks

Review these items:

1. `initiatives/conversation-review/conversation-review.md`
   - still accurately describes the review lanes, integrity goals, and decision outputs
2. `initiatives/conversation-review/STATUS.md`
   - still points to the correct downstream files
3. `/mnt/c/git/OpenClawHA/NIGHTLY_CONTEXT_REVIEW.md`
   - still matches the intent captured by this initiative
4. `/mnt/c/git/OpenClawHA/bin/nightly_context_review.sh`
   - still seeds the expected daily review log
5. `/mnt/c/git/OpenClawHA/bin/review_whatsapp_sad_markers.py`
   - still supports the WhatsApp bad-response lane
6. `/mnt/c/git/OpenClawHA/bin/review_vaca_history.py`
   - still supports the VACA voice lane

## Integrity Questions

During heartbeat, check whether the workflow still:
- uses real bad-interaction evidence instead of speculative context churn
- prefers the smallest durable fix
- protects user-facing replies from reasoning leakage and process pollution
- keeps voice review focused on silence, brevity, and calm clarifications
- routes external dependency gaps into the established issue workflow instead of hiding them in local notes

## Output Shape

If nothing meaningful changed, report `HEARTBEAT_OK`.

If drift or action is found, report only compact operational findings:
- what changed
- which file is now the source of truth
- whether supervisor docs or `OpenClawHA` docs need updating
- the next bounded sync action
