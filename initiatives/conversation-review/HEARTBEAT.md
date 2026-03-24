# Conversation Review Heartbeat

## Status

Manual-only.

## Purpose

Keep the supervisor-side description of nightly message-response integrity aligned with the real `OpenClawHA` workflow.

## Cadence

- Do not run this as part of unattended supervisor heartbeat.
- Run only when Cronje explicitly asks for a conversation-review check or wants to inspect drift in the downstream `OpenClawHA` workflow.
- A manual review session may use a subscription-backed agent or IDE-driven review flow instead of the normal heartbeat path.

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
7. `/mnt/c/git/OpenClawHA/bin/review_simple_slow_requests.py`
   - still supports the simple-but-slow latency lane
8. `/mnt/c/git/OpenClawHA/bin/create_validation_case.py`
   - still supports offline validation-case capture
9. `/mnt/c/git/OpenClawHA/bin/run_validation_cases.py`
   - still supports automated validation-case execution
10. `/mnt/c/git/OpenClawHA/validation/README.md`
   - still describes the safe rollout gate before primary exposure
11. `/mnt/c/git/OpenClawHA/validation/cases/`
   - still contains the executable case set being used for regression checks

## Integrity Questions

During heartbeat, check whether the workflow still:
- uses real bad-interaction evidence instead of speculative context churn
- prefers the smallest durable fix
- protects user-facing replies from reasoning leakage and process pollution
- keeps voice review focused on silence, brevity, and calm clarifications
- flags simple requests that are still too slow for the tool path already available
- keeps risky nightly-review fixes in candidate status until validation evidence exists
- keeps the executable validation harness aligned with the documented safety rules
- routes external dependency gaps into the established issue workflow instead of hiding them in local notes

## Output Shape

If this file is reached during a generic automated heartbeat, stop and report `HEARTBEAT_OK` without performing the review.

If drift or action is found, report only compact operational findings:
- what changed
- which file is now the source of truth
- whether supervisor docs or `OpenClawHA` docs need updating
- the next bounded sync action
