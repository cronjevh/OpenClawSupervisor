# Community WhatsApp Signal Triage

## Purpose

Explore an OpenClaw-assisted workflow that monitors selected community WhatsApp groups, filters noise, and ensures important items reach Cronje with minimal junk.

## Outcome Vision

A system that:
- watches selected WhatsApp groups
- identifies high-signal messages
- suppresses routine chatter and low-value forwards
- produces digests and urgent alerts
- becomes more accurate over time based on feedback

## Why This Matters

Community groups contain useful local intelligence, but the signal-to-noise ratio is poor. The goal is to reduce attention cost without missing time-sensitive or important messages.

## Early Questions

- Which groups should be included first?
- What counts as important vs. junk?
- Should output be immediate alerts, scheduled digests, or both?
- Should the system only summarise, or also suggest actions?
- How should human feedback improve classification?

## Constraints and Risks

- Message ingestion and channel access may be the hardest part.
- Privacy and trust boundaries must be explicit.
- False negatives may be more costly than false positives in some groups.
- Group-specific tuning will likely be necessary.

## Candidate Capabilities

- group allowlist
- keyword/entity detection
- urgency scoring
- duplicate/forward suppression
- digest generation
- feedback loop on missed or misclassified items
- category tagging (security, neighbourhood, municipal, school, social, etc.)

## Possible Work Packages for External Agent Flows

1. Discovery and requirements framing
2. Ingestion options and channel constraints review
3. Relevance scoring design
4. Digest and alert UX design
5. Pilot implementation plan
6. Feedback and tuning loop design

## Dependencies

- Reliable access to selected WhatsApp group content
- Clear routing destination for summaries/alerts
- A small labelled sample of real messages for tuning

## Open Questions

- Is this advisory-only, or allowed to proactively notify?
- What is the acceptable miss rate for important items?
- Should each group have its own profile and rules?

## Next Moves

- Pick 1-2 pilot groups.
- Define an initial taxonomy of important message types.
- Decide what the first useful output should be: digest, urgent alert, or both.
