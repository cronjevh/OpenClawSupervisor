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

## Current Status (2026-03-21)

### What is now working

- Added a second WhatsApp account named `personal` intended for monitored-group ingestion.
- Bound WhatsApp `accountId: "personal"` to the `messaging` agent.
- Kept the default WhatsApp account pinned to `default` so generic proactive sends can originate from Alexa rather than the personal number.
- Confirmed that inbound messages from the test group route into the `messaging` agent session.
- Confirmed that group session history is being created and retained for troubleshooting.
- Created and tuned a dedicated `workspace-messaging` watcher workspace with:
  - watcher identity / quiet-monitoring role
  - explicit municipal-utility outage use case
  - memory and daily notes
  - instructions to prefer `NO_REPLY` in monitored groups
- Added a dedicated alert script in the messaging workspace:
  - `scripts/send-alert-to-cronje.sh`
  - uses `openclaw message send --channel whatsapp --account default --target +27832639322 --message ...`
- Confirmed that direct `openclaw message send` can work for proactive delivery from the default/Alexa WhatsApp account after pairing work.

### Test scenario used so far

- Test group: `TestAlexa`
- Membership: only Cronje
- Intent: safe test bed for monitored-group behavior
- Example target use case: municipal representative information group where only admins can post
- Desired behavior: monitor every message, stay silent in-group, and proactively notify Cronje only for water/electricity interruption notices relevant to the area

### What was tried

1. **Routing setup**
   - Added account-level binding from WhatsApp `personal` to `messaging`.

2. **Group admission fixes**
   - Adjusted sender/group policy so the personal account could ingest the test group traffic.

3. **Always-on activation**
   - Set the test group to `requireMention: false` so every inbound message would trigger evaluation.

4. **Prompt/workspace tightening**
   - Rewrote the messaging workspace to act like a silent watcher rather than a chat assistant.
   - Added explicit instructions: default `NO_REPLY`, never paraphrase messages back into the monitored group, prefer out-of-band alerts.

5. **Bootstrap injection attempt**
   - Added `bootstrap-extra-files` entries so the messaging workspace files are injected during agent bootstrap.

6. **Explicit proactive-send path**
   - Added local script wrapper for proactive WhatsApp delivery to Cronje via Alexa/default.

7. **Self-chat mode diagnostic**
   - Disabled `channels.whatsapp.selfChatMode` globally and for the `personal` account to test whether same-number self-phone behavior was distorting results.

## Findings / Lessons So Far

### Confirmed

- The `messaging` agent can receive and process messages from the monitored WhatsApp group.
- Session creation and history retention work.
- Simple proactive outbound delivery via `openclaw message send` is viable as a delivery primitive.

### Main failure mode observed

Even with always-on activation and repeated prompt tightening, the monitored-group turn still tends to produce a **normal in-channel reply**, paraphrasing the source message back into the same WhatsApp group.

This happened repeatedly for outage notices and indicates that:
- routing is not the main problem
- ingestion is not the main problem
- the hard part is preventing the group-bound agent turn from behaving like a normal reply turn

### Current hypothesis

Plain always-on group auto-reply turns appear to be the wrong primitive for this use case when the bot is expected to:
- read the source group
- remain silent there
- classify the message
- and send an out-of-band alert elsewhere

The likely better architecture is to separate:
1. source group ingestion
2. classification/evaluation
3. proactive alert delivery

rather than relying on perfect prompt obedience inside the source-group reply turn.

### Additional suspected factor

Because the `personal` WhatsApp account is Cronje's own number, `selfChatMode` / same-phone semantics may be affecting behavior and are still worth keeping in mind for future diagnosis, even though the main architectural issue may be broader than that.

## Constraints and Risks

- Message ingestion and channel access may be the hardest part.
- Privacy and trust boundaries must be explicit.
- False negatives may be more costly than false positives in some groups.
- Group-specific tuning will likely be necessary.
- Same-number / self-phone WhatsApp setups are likely more fragile than dedicated-number setups.
- Relying on prompt-only `NO_REPLY` compliance in an always-on group may be too brittle for safe production use.

## Candidate Capabilities

- group allowlist
- keyword/entity detection
- urgency scoring
- duplicate/forward suppression
- digest generation
- feedback loop on missed or misclassified items
- category tagging (security, neighbourhood, municipal, school, social, etc.)
- explicit out-of-band delivery scripts or hooks

## Recommended Next Investigation

Focus less on prompt wording and more on execution architecture.

Priority questions for next session:
- Can monitored group ingestion trigger a separate workflow/hook/sub-session instead of a normal in-channel auto-reply turn?
- Is there a cleaner OpenClaw-native event/hook path for "ingest silently, evaluate, then optionally send elsewhere"?
- If not, can the reply turn be constrained strongly enough to use only the explicit alert script and then return `NO_REPLY` reliably?
- Does disabling self-chat mode materially change behavior once re-tested after the latest patch?

## Possible Work Packages for External Agent Flows

1. Discovery and requirements framing
2. Ingestion options and channel constraints review
3. Relevance scoring design
4. Digest and alert UX design
5. Pilot implementation plan
6. Feedback and tuning loop design
7. Architecture review for silent-ingest + out-of-band alert execution

## Dependencies

- Reliable access to selected WhatsApp group content
- Clear routing destination for summaries/alerts
- A small labelled sample of real messages for tuning
- Stable proactive outbound path from Alexa/default

## Open Questions

- Is this advisory-only, or allowed to proactively notify?
- What is the acceptable miss rate for important items?
- Should each group have its own profile and rules?
- Should the monitored-group implementation rely on agent prompts at all, or move to a hook/script-driven pattern?

## Next Moves

- Re-test after disabling self-chat mode.
- Verify whether in-group parroting still occurs.
- If it does, stop treating plain always-on group auto-reply as the target architecture and shift to a separated ingest/evaluate/alert design.
- Keep `workspace-messaging` as the watcher workspace, but use it as the decision layer rather than a conversational group participant.
