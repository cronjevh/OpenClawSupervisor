# Home Ownership Maintenance Schedules and Reminders

## Purpose

Create a durable system for proactive home ownership maintenance schedules, reminders, and completion tracking across recurring household tasks.

## Outcome Vision

A maintenance register that:
- tracks important assets and recurring tasks
- knows cadence, due dates, and seasonal timing
- reminds ahead of time
- records completion history
- reduces preventable damage and expensive neglect

## Example Seed Item

- Replace geyser sacrificial anode every 2 years
- Next due: May 2026

## Candidate Scope

- plumbing
- electrical
- roofing and gutters
- HVAC / heating / cooling
- security systems
- garden and exterior
- appliances
- insurance / compliance-related upkeep

## Data Model Ideas

For each maintenance item:
- asset / system
- task
- cadence
- last done date
- next due date
- lead time for reminder
- season or best month
- owner / responsible person
- estimated cost / difficulty
- notes / vendor / part numbers
- proof of completion

## Early Questions

- Where should the source of truth live: markdown, sheet, HA entities, or another system?
- Do reminders belong in OpenClaw cron, Home Assistant, Calendar, or a hybrid?
- Should tasks be grouped by season, system, or urgency?
- How much completion evidence should be captured?

## Constraints and Risks

- A reminder system is only useful if the task register stays current.
- Some tasks need flexible windows rather than exact dates.
- The system must stay simple enough to maintain.

## Possible Work Packages for External Agent Flows

1. Home maintenance taxonomy and template design
2. Initial asset and task register creation
3. Reminder/scheduling architecture design
4. Completion logging and audit trail design
5. Seasonal planning views and digests
6. Pilot implementation using a small real task set

## Dependencies

- Initial list of known recurring tasks
- Decision on source of truth and reminder channel
- Agreement on reminder lead times and escalation style

## Open Questions

- Should this be personal reminders only, or shared household planning?
- Should overdue tasks escalate differently from upcoming tasks?
- Should consumables and spare-part procurement also be tracked?

## Next Moves

- Start a first-pass maintenance register with 10-20 real tasks.
- Decide where the durable source of truth should live.
- Pilot reminder logic with the geyser anode example and a few other high-value tasks.
