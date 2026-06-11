# ADR-015: Progressive Effort Escalation

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-015 |
| **Initiative** | unsorry Phase 3 — cycle economics |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-11 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** ADR-013 running every proof-surface call at `max` effort, where a `max` attempt spends its deep reasoning identically on a statement `simp` would have closed and on one that genuinely needs it,
**facing** the observation that most attempt budget is consumed by goals across a wide difficulty spread (phase-2/3 runs closed some targets in minutes while others exhausted two 30-minute walls), and that a fixed top-effort policy pays the maximum token and latency price on every rung of that spread,
**we decided for** a per-attempt effort ladder as the prove-mode default: attempt 1 runs at `high`, attempt 2 at `xhigh`, attempt 3 (and beyond) at `max`, with the default attempt budget raised from 2 to 3 so a hard goal always reaches the top rung before decomposition or demotion; decomposition — which only fires after the ladder is exhausted — always runs at the top rung; an explicit `UNSORRY_EFFORT` pins every attempt (no escalation),
**and neglected** difficulty-routed effort (predicting a goal's difficulty up front — no reliable signal exists before an attempt is spent), per-goal persistent ladders across cycles (a re-claimed goal restarts at rung 1; affinity already encodes "this resisted"), and model-tier escalation (the model stays `fable` on every rung per the user's standing decision — only reasoning depth escalates),
**to achieve** cheaper time-to-proved in expectation — easy goals close on a `high` attempt without paying `max` latency, hard goals still get the full-depth attempt they need plus error feedback from the cheaper passes,
**accepting that** a goal that would have closed at `max` on attempt 1 may now take three attempts (one extra wall-clock worst case per such goal), the default budget rising to 3 lengthens the worst-case unproved cycle by one wall, and effort tokens remain CLI-defined strings passed through without a script-side whitelist.

## Context

Amends ADR-013, which set proof-surface calls to `fable` at static `max` effort. The model choice stands; this ADR replaces only the effort default. The kernel and gates still judge every result identically — effort, like model, is a performance knob, never a soundness one. The escalation also composes with the existing retry design: attempt 2 and 3 receive the prior attempt's verification errors, so the deeper rungs start from diagnosed failures rather than cold.

## Options Considered

### Option 1: Per-attempt ladder high → xhigh → max (Selected)
Escalate reasoning depth only after a cheaper attempt failed; decomposition runs at the top rung.
**Pros:** pays for depth only where it is needed; preserves error-feedback retries; pure-function implementation testable hermetically.
**Cons:** worst case one extra attempt per hard goal; ladder shape is fixed rather than adaptive.

### Option 2: Keep static max (ADR-013 status quo) (Rejected)
**Pros:** simplest; maximal single-attempt success probability.
**Cons:** spends top effort on goals that do not need it; with quota-limited CLIs, burns session budget fastest exactly when running unattended.

### Option 3: Difficulty-routed effort (Rejected)
Choose the rung from goal metadata (difficulty score, statement size). Rejected: no signal available before an attempt is spent has predicted difficulty reliably in our runs; the ladder *is* the measurement.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Amends | ADR-013 | Model/Effort Policy | Replaces the static `max` effort default; model default unchanged |
| Relates To | ADR-009 | Goal Decomposition | Decomposition fires post-ladder, at the top rung |
| Relates To | ADR-007 | Agent Identity and Budgets | Prove-mode default attempt budget 2 → 3 |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-015-A — Progressive effort escalation | Specification | specs/SPEC-015-A-Progressive-Effort-Escalation.md |
| REF-2 | SPEC-013-A — Model/effort plumbing | Specification | specs/SPEC-013-A-Model-Effort-Policy.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-11 |
| Accepted | unsorry maintainers | 2026-06-11 |
