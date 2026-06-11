# ADR-016: Infrastructure-Failure Guard

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-016 |
| **Initiative** | unsorry Phase 3 — operational correctness |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-11 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** an agent loop whose failure path treats every failed claude call as evidence about the goal — exhausted budget → decompose, unusable split → demote −10 (below τ_v the goal leaves the pool),
**facing** two production incidents on 2026-06-11 in which a CLI quota outage made every call die in ~1 minute, and the loop — unable to tell "the model tried and failed" from "the model never ran" — demoted every open leaf of the active tree below the viability threshold, emptied its own pool, exited "no claimable goal", and twice required maintainer affinity-restore PRs (#165, and the #168–#181 cleanup),
**we decided for** classifying a failed proof-surface call as an *infrastructure failure* when it died in under `UNSORRY_FASTFAIL` seconds (default 240 — a real attempt must at least read the goal and run a build) **and** a follow-up health probe on the cheap model also fails; on that classification the cycle aborts with no `prove-failed` event, no decomposition, no demote, the claim is released, and the agent exits with a distinct code 3 so the orchestrator knows to reschedule rather than diagnose goals,
**and neglected** retry-with-backoff inside the loop (an outage measured in hours would idle a worktree and mislead the orchestrator; a clean exit hands timing to whoever can see the clock), pre-claim health probes on every cycle (cost on the healthy path for a rare event), and distinguishing quota from auth/network failures (identical handling either way; the probe answers "can the CLI run", which is all the queue needs),
**to achieve** a queue whose affinity and decomposition state only ever encode *model evidence about goals*, never infrastructure weather — an outage now costs wall-clock, not state repair,
**accepting that** a genuinely-broken call that fails fast while the cheap model happens to be healthy still counts as a real attempt (conservative: queue penalties stay possible), the probe spends one cheap-model call per fast failure, and a wall-timeout followed by a quota death is still recorded as a real attempt (the model had its chance).

## Context

The demote path (ADR-010) and the decomposition fallback (ADR-009) both assume the budget was actually *spent on the goal*. The 05:48Z and 10:43Z outages violated that assumption at scale: 8 and 9 spurious demotes respectively, plus duplicate-demote PR churn from two agents failing in parallel, plus a stalled Thread-A tree each time. The fix lives at the only place that can tell the difference — the call site, with the duration and a probe in hand. Soundness is untouched: this changes what the *queue* learns from failures, never what the gates accept.

## Options Considered

### Option 1: Fast-fail + health-probe classification, clean exit 3 (Selected)
**Pros:** zero cost on the healthy path; pure-function classifier is hermetically testable; the orchestrator gets an unambiguous signal; queue state stays meaningful.
**Cons:** conservative misclassification possible (fast real failures with a healthy CLI remain "real"); one cheap probe per fast failure.

### Option 2: In-loop retry with backoff (Rejected)
Sleep and retry until the CLI recovers. Rejected: outages here are quota windows measured in hours; a sleeping loop holds its claim worktree, emits nothing, and looks identical to a hang from outside.

### Option 3: Pre-claim health probe every cycle (Rejected)
Probe before claiming. Rejected: pays on every healthy cycle to catch a rare event, and a probe that passes at claim time says nothing about a death 20 minutes into the attempt.

## Dependencies
| Relationship | ADR ID | Title | Notes |
|--------------|--------|-------|-------|
| Amends | ADR-009 | Goal Decomposition | Decompose fallback skipped on infra failure |
| Amends | ADR-010 | Affinity-Gap Selection | Demote requires a real attempt |
| Relates To | ADR-015 | Progressive Effort Escalation | Ladder attempts are individually classified |

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | SPEC-016-A — Infrastructure-failure guard | Specification | specs/SPEC-016-A-Infrastructure-Failure-Guard.md |
| REF-2 | Incident timeline | Metrics | ../metrics/phase3-run-001.md (when landed) |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-11 |
| Accepted | unsorry maintainers | 2026-06-11 |
