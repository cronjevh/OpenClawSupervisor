# Monica Cognitive Engagement

## Purpose

Design and deliver a dignified, low-friction system that gives Monica regular opportunities for meaningful cognitive engagement — with foreign language stimulation as the primary technical initiative, and broader reminiscence, music, and conversational activities as supporting channels.

## Outcome Vision

A system where Monica:
- Has gentle, enjoyable encounters with German and French several times a week, using her own voice and the Smart Speaker she already has in the room
- Is never tested or graded — the interactions feel like conversation or a game, not a cognitive assessment
- Can opt out at any moment, with no pressure and no sense of failure
- Gets different kinds of engagement on different days, matched to her energy and mood
- Has her participation reviewed quietly in the background so the quality of interactions can improve over time

## Why This Matters

### Monica's background makes language stimulation a strong fit

Monica spent her career as a lecturer in education with a specialisation in language education, and holds a PhD in Education Innovation. She is not a passive consumer of language — she studied it, taught it, and thought deeply about how it works. Engaging her in German or French is not an abstract "brain training" exercise; it connects to a domain where she has real expertise, identity, and memory.

Research widely supports multilingual practice as one of the most effective forms of cognitive exercise for slowing cognitive decline. For Monica specifically, the fit is unusually good:
- **German** was an advanced university course subject — she has deep, practiced material to draw on
- **French** is at a useful basic level — familiar enough to engage with, with enough room to explore

### Word games failed because they were disconnected from her identity

The word games already placed on her phone were not used. Foreign language conversation is different: it is something she has a real history with, a real skill in, and a real reason to find meaningful rather than arbitrary.

## Monica's Language Profile

| Language | Level | Background | Design implication |
|----------|-------|------------|--------------------|
| German | Advanced (university course) | Academic study, likely reading/writing/grammar as well as speaking | Can handle richer vocabulary, recall of grammar structures, topic-led conversation |
| French | Basic | General acquisition | Should stay at everyday phrases, greetings, familiar topics — keep it gentle and rewarding |

## Technical Architecture

### Components already in place

- **VACA** running on the primary Android Smart Speaker device in Monica's environment
- **Home Assistant voice assistants** named `German` and `French` — already configured with matching multi-lingual STT and TTS
- Nightly context review pipeline already monitors VACA interactions via:
  - `sensor.vaca_215d3e5be_stt` — spoken input log
  - `sensor.vaca_215d3e5be_tts` — spoken output log

### Interaction flow

```
Monica speaks → VACA (Android Smart Speaker)
              → HA voice assistant (German or French)
              → STT: speech recognised in target language
              → Agent/script: selects appropriate prompt or response
              → TTS: responds in target language
              → sensor logs captured for nightly review
```

### Invocation modes

**Mode 1 — Caregiver-initiated (Phase 1 target)**
A caregiver or family member triggers a session by voice command or HA dashboard tap. Monica hears a warm, natural-language invitation in German or French and can respond or decline.

**Mode 2 — Scheduled gentle prompt (Phase 2 target)**
HA automation fires at a chosen time of day (afternoon is typically best). The Smart Speaker plays a brief, friendly opener in the target language. No response required; Monica can ignore it. If she responds, the session continues.

**Mode 3 — Passive ambient (optional, Phase 3)**
Short spoken phrases or familiar vocabulary play in the background at low volume without requiring any response — more like ambient engagement than interaction.

## Content Design

### German sessions (advanced)

The aim is to draw on material she already has, not to teach her new content.

Good starting points:
- Familiar topics from her professional life: teaching, children learning to read, how people learn languages
- Short exchanges about the day, the weather, what she had for lunch — low-stakes, familiar frames
- Recall games framed as sharing rather than testing: "Do you remember how you'd say X in German?"
- Short passages of German poetry or song lyrics — especially anything she may have encountered at university
- Proverbs and idioms — often memorable and pleasantly surprising when recalled

Avoid:
- Grammar correction or error flagging
- Vocabulary lists or flashcard-style recall under any pressure
- Anything that signals she got it wrong

### French sessions (basic)

Keep it warm and accessible:
- Greetings and time-of-day phrases
- Food and everyday vocabulary
- Familiar French songs
- Simple yes/no or fill-in exchanges where success is easy

### Session length and pacing

- Target: 3–8 minutes per session
- Hard stop: no session should feel like it is going on too long
- Natural close: always end on a positive, never mid-puzzle or mid-failure
- Frequency: aim for 2–4 sessions per week, not daily — avoids becoming a chore

## Scheduling Design

| Time | Suitability | Notes |
|------|-------------|-------|
| Morning | Lower — often slower to start | Avoid unless caregiver-initiated |
| Mid-morning | Good if she is already engaged | Short, gentle opener |
| After lunch | Best window for many people | Natural pause, relaxed mood |
| Late afternoon | Variable | Avoid if fatigue or sundowning is a factor |
| Evening | Not recommended for cognitive tasks | |

HA automations should use randomised timing within a preferred window to avoid feeling like clockwork.

## Broader Engagement Areas

Foreign language stimulation is the primary technical initiative. Supporting channels that remain worth exploring:

- Guided reminiscence prompts (voice-led, no screen required)
- Music-linked memory: playing a familiar piece and following with a conversational prompt about it
- Family photo prompts via a screen-capable device (separate initiative if pursued)
- Orientation prompts tied to time, place, and daily routine
- Simple purposeful tasks: being asked for her opinion or expertise rather than being given an activity

These should be designed as distinct activity types that can be rotated with language sessions to avoid repetition.

## Monitoring and Review

### Integration with nightly context review

VACA STT/TTS logs are already reviewed nightly. Monica's language sessions should be flagged and reviewed separately:
- Did she respond?
- Did the session complete naturally or did it drop?
- Were there signs of confusion or frustration in the STT output?
- Did TTS pacing and language feel natural on playback?

### What counts as working

- Monica completes a session without needing help or showing distress
- Monica initiates or continues an exchange beyond the opening prompt
- Sessions end positively (no frustration signals in STT log)
- Caregiver reports: "she seemed to enjoy it" or "she was trying to remember words"

### What would signal a problem

- Repeated short sessions ending immediately (less than 30 seconds)
- STT logs showing repeated confusion or no speech
- Caregiver reports of frustration or distress
- Monica asking to stop or telling someone she doesn't want to do it

## Design Boundaries

- Do not frame any session as a test, a game with a score, or a skill-builder — use conversational framing only
- Do not correct her errors in real-time; respond naturally and move forward
- Do not use clinical language anywhere in prompts or session openers
- Do not schedule sessions during known low-energy windows
- Do not start with French (the weaker language) as the default — German sessions first, where confidence is higher
- Do not make sessions so frequent that they become expected and then resented
- Do not involve caregiver burden: sessions must be triggerable without much setup
- Do not measure "cognitive performance" — the goal is enjoyment and engagement, not assessment

## Work Packages

| # | Package | Description |
|---|---------|-------------|
| 1 | Prompt library — German | Write 20–30 session-opener and follow-up prompts in German; varied topics, warm tone |
| 2 | Prompt library — French | Write 15–20 basic-level prompts in French; greetings, daily life, simple exchanges |
| 3 | HA automation — scheduled prompt | Configure afternoon-window automation firing German or French prompt via VACA |
| 4 | HA automation — caregiver trigger | Dashboard tile or voice command that caregivers can use to start a session |
| 5 | Session logging spec | Define how STT/TTS logs are tagged and surfaced in nightly review for Monica sessions |
| 6 | Pilot run and review | Run 2-week pilot; review nightly logs; adjust prompts and timing based on evidence |
| 7 | Broader engagement activity library | Develop the reminiscence, music, and orientation activity types for rotation |

## Dependencies

- Confirmation that VACA can be addressed by name/language via HA voice assistant invocation (German/French)
- Understanding of Monica's daily routine and peak-engagement window (needs input from caregiver)
- Agreement from caregiver on acceptable session frequency and who handles the initial trigger
- Nightly review pipeline tagging Monica's sessions distinctly from general VACA usage

## Open Questions

- Can the German and French HA voice assistants be called programmatically from an automation, or only by direct voice command?
- Should sessions be fully automated or always caregiver-initiated in Phase 1?
- Is there any existing content Monica has strong positive associations with — specific German songs, phrases, or topics from her teaching career?
- Who reviews nightly logs for Monica-specific quality signals — the supervisor agent, or a human caregiver?

## Next Moves

1. Confirm that the `German` and `French` voice assistants respond correctly to a test invocation via VACA on the Smart Speaker.
2. Write a small set of 5 German session openers as the pilot prompt set — warm, conversational, connected to her professional background.
3. Configure a single HA automation that fires one German prompt on a single weekday afternoon as a low-risk first test.
4. After first test run, review STT/TTS logs from that session in the nightly review pipeline.
5. Adjust prompt and timing based on what the logs show, then expand to 3 sessions per week.
6. When German sessions are running reliably, introduce French as a second rotation.
