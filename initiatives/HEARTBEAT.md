# Initiative Heartbeat

This file defines the lightweight heartbeat routine for the `initiatives/` control-plane folder.

## Purpose

Keep strategic initiative work from going stale without turning supervisor into a noisy background nag.

## Heartbeat Checks

When reviewing initiatives, check for:
- initiatives with no recent progress notes
- initiatives that need to be queued into an external subscription-based agent flow
- initiatives that have open questions blocking next action
- initiatives that would benefit from a GitHub issue / PR-backed work item
- near-due real-world tasks that should graduate into reminders or tracked execution

## Suggested Cadence

- Weekly: review all initiative stubs for movement, blockers, and next action
- Monthly: reassess priority, scope, and whether each initiative should stay exploratory or move to implementation

## Response Shape

A useful heartbeat output should stay compact:
- initiative name
- status: dormant / exploring / ready for agent handoff / active / blocked
- next best action
- whether a GitHub issue or PR-backed flow should be created

## Trigger Heuristic

If an initiative has enough shape for a bounded work package, prefer creating a tracked artifact rather than leaving the idea only in markdown.
