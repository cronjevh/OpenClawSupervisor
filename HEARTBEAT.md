# HEARTBEAT.md

## Initiative control-plane review

Weekly, review `/home/cronjev/.openclaw/workspace-supervisor/initiatives/README.md`, each initiative stub in `/home/cronjev/.openclaw/workspace-supervisor/initiatives/`, and `/home/cronjev/.openclaw/workspace-supervisor/initiatives/HEARTBEAT.md`.

Exception:
- Do not run the `conversation-review` initiative as an automated heartbeat review item.
- Treat `initiatives/conversation-review/` as manual-only until Cronje explicitly asks for a review session.
- Reason: the review is too token-expensive for unattended heartbeat use and the intended human-in-the-loop outcome is better served by a manual subscription-backed review pass.

If there is no meaningful movement or action needed, reply exactly `HEARTBEAT_OK`.

If action is needed, report only compact operational findings such as:
- which initiative is ready for an external subscription-based agent handoff
- which initiative needs a GitHub issue or PR-backed work package next
- which initiative is stale or blocked
- any near-due real-world maintenance item that should be turned into a tracked reminder or execution plan
