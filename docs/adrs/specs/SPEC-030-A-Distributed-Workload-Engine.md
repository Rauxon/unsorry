# SPEC-030-A: Distributed-Workload Engine — Plugin Seam

Implements: [ADR-030](../ADR-030-Distributed-Workload-Engine.md) · Status: Proposed · Updated: 2026-06-13

This spec defines the contract that separates the **domain-agnostic engine**
from a **domain plugin**. It is a design target, not yet an implementation; the
Lean plugin (below) is the conformance reference because it already exists in
behaviour, only not yet behind the seam.

## 1. Roles

- **Engine** (domain-agnostic, reused as-is): scheduling and candidate
  selection, claims/lease coordination, the multi-provider call abstraction,
  cross-cycle lesson memory, provenance + leaderboard, the gate-as-CI runner,
  and autonomous merge-on-green.
- **Plugin** (one per domain): everything that knows what the *work* is — the
  work-unit schema, how to generate a candidate, how to verify it, how (option-
  ally) to split it, and how to fold an accepted result into the canonical
  corpus.

The engine never imports domain code directly; it calls the plugin through the
operations in §3.

## 2. WorkUnit

A plugin describes its unit with a small, serialisable record:

```text
WorkUnit {
  id            : stable slug (Id grammar, as today)
  spec          : the problem statement, by value or content-address
  status        : open | claimed | solved | blocked
  difficulty    : integer rung (drives ranking/credit; plugin-assigned)
  deps          : ids this unit depends on (⟨⟩ if none)
  tier          : VERIFIED | SCORED | CONSENSUS   (see §4)
}
```

`status` is the lifecycle the engine drives; `spec`, `difficulty`, `deps`, and
`tier` are plugin-owned. The canonical state of a unit lives in the corpus
(today: `goals/<id>.aisp` on `main`), which is the single source of truth the
engine reads when deciding whether work remains.

## 3. Plugin operations

```text
generate(unit, context) -> Candidate
    Produce a candidate solution. `context` carries prior-attempt lessons
    (ADR-024) and provider/effort selection. The engine owns the provider call;
    the plugin owns the prompt/result shaping.

verify(unit, candidate) -> Verdict {
    accepted : bool                  # VERIFIED: deterministic truth
    score    : number | null         # SCORED: higher is better
    evidence : artifact              # audit report / kernel log / metrics
    cost     : { wall_s, ... }       # for telemetry, never a trust input
}
    MUST be deterministic and SHOULD be cheap relative to generate(). This is
    the trust kernel; it is the only thing that decides acceptance.

decompose(unit) -> [WorkUnit]        # optional
    Split an unsolved unit into strictly-smaller sub-units (ADR-009). Advisory:
    a unit still closes only through verify(), never through its decomposition.

assimilate(candidate) -> CorpusChange
    Render the accepted candidate as the change set merged into the canonical
    corpus (new module + index entry + provenance, today).
```

`verify` is authoritative and self-contained: the engine trusts its `Verdict`
and nothing else. `generate`/`decompose` are best-effort and may fail without
affecting soundness — a bad candidate simply fails `verify`.

## 4. Verifiability tiers

The `tier` field selects how many accepted verdicts close a unit:

- **VERIFIED** — `verify` is a deterministic checker; a single `accepted`
  verdict is ground truth. No redundancy needed. (Lean: the kernel gate.)
- **SCORED** — `verify` returns a `score`; the unit keeps the best-scoring
  accepted candidate; later candidates may supersede on a strictly better score.
- **CONSENSUS** — no cheap deterministic verifier exists; the engine requires
  N independent accepted verdicts and resolves by quorum, weighted by
  contributor reputation. This is the classic SETI@home/BOINC trust model and
  the only tier that needs redundant computation.

The engine implements all three; a plugin declares which it uses. The VERIFIED
tier is the design centre and the reason unsorry needs no redundancy today.

## 5. Lean plugin (conformance reference)

| Seam element | Lean realisation |
|--------------|------------------|
| `WorkUnit`   | a goal (`goals/<id>.aisp` + `.lean`), `tier = VERIFIED` |
| `generate`   | the proof prompt to the selected provider |
| `verify`     | Gate A: `lake build --wfail`, `axiom_audit`, `leanchecker`, statement-binding (ADR-011) |
| `decompose`  | sub-lemma split (ADR-009) |
| `assimilate` | new `library/Unsorry/<Camel>.lean` + index entry + provenance |

Re-expressing today's behaviour through the seam must be **behaviour-preserving**:
the same proofs pass, the same gate fails closed, no soundness change.

## 6. Validation

Because this is a design ADR, conformance is defined for the eventual
implementation, not asserted here:

1. The Lean plugin, once behind the seam, reproduces current Gate A outcomes on
   a known proof and a known sorried module (pass / fail-closed unchanged).
2. The engine builds and runs with the Lean plugin removed and a trivial stub
   plugin present (proves the boundary is real, not nominal).
3. A second, non-Lean plugin (even a toy: e.g. a `VERIFIED` arithmetic-identity
   domain) onboards by implementing only §3, with zero engine edits — the
   acceptance test for "is this actually a template."

## 7. Out of scope

### 7.1 Separate decisions (each gets its own ADR)

- **Deduplication & claim-at-merge** — preventing two agents from racing the
  same unit and wasting verification (a recurring, observed cost). Its own ADR.
- **Identity, rate-limiting, anti-abuse** — per-contributor throttling, sybil
  resistance, credit-gaming. Its own ADR.
- **Coordination at scale** — replacing the single claims branch with a service
  when git-as-database contention demands it (ADR-004 stands until measured).
- **Contributor onboarding / client packaging** — the container/BYO-key client
  that makes "more users" practical.

### 7.2 Noted, not yet scoped

These are not decided here and have no ADR yet, but are recorded so they are not
lost when this seam is built out:

- **Plugin trust boundary.** `verify` (§3) is *the* trust kernel: a plugin that
  lies in its `Verdict` (e.g. returns `accepted=true` for an unchecked
  candidate) breaks soundness for that domain. First-party plugins (Lean) are
  trusted by code review; **third-party plugins are not trusted** until there is
  sandboxing, an independent re-verification path, or a signed/audited plugin
  registry. Generalization must never let a plugin lower a domain's soundness
  bar (cf. ADR-030's "trust model unchanged").
- **`verify` reproducibility.** A deterministic verdict must hold across
  machines and over time; each plugin needs the per-domain analog of ADR-002
  (mathlib/toolchain pinning), or a verdict could differ by environment.
- **Compute cost model.** Who pays for candidate generation (LLM inference) and
  verification. The natural analog of SETI's donated CPU is a contributor's
  BYO provider key (already supported); pooled credits, sponsorship, and
  per-contributor quotas are unspecified.
- **Central CI cost & DoS surface.** Verification runs centrally per PR today
  (expensive). Volunteers already self-verify; pushing authoritative
  verification toward the contributor and keeping a cheap central re-check
  (e.g. kernel replay only) bounds both cost and abuse. Tied to §7.1's
  coordination-at-scale and anti-abuse decisions.
- **Work-unit ingestion.** Where units come from and how they are admitted
  (today: `backlog/` + translation, ADR-007). A general template needs a
  pluggable problem-source contract and a way to vet/scope submitted problems.
- **Corpus governance & licensing.** Ownership, license, and provenance of
  results merged into the canonical corpus, and how credit accrues across
  projects (ADR-023 already flags cross-project credits as needing an anti-abuse
  design first).
- **Work-unit sensitivity / privacy.** The engine assumes public, world-readable
  units today; some domains carry private or sensitive specs.
