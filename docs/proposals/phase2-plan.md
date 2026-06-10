# unsorry Phase 2 — Implementation Plan: Open Lemmas and Target Decomposition

| Field | Value |
|-------|-------|
| **Document** | Phase-2 implementation plan |
| **Initiative** | unsorry Phase 2 — open lemmas and target decomposition |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-10 |
| **Status** | Proposed |

This is an execution plan, not an architecture document and not an ADR. It scopes *what gets built, in what order, gated by what evidence* to take the swarm from Phase 1 (a validated loop that proves known-true theorems already in mathlib) to Phase 2 (a loop that drives verified proofs to a chosen result **not** already in mathlib, by decomposition). It mirrors the staging discipline of [`distributed-research-swarm-plan.md`](distributed-research-swarm-plan.md) but at the granularity of pull requests and the specs that land in each. The design doc remains the master; this plan does not reopen any of its decisions. Where it names new ADRs and specs (ADR-009/010/011, SPEC-009-A/010-A/011-A, `docs/phase2-targets.md`, `phase1-run-002`), those are the artifacts Phase 2 must produce — the plan defines the work, the ADRs ratify the decisions, the specs constrain the build.

## 1. Context

Phase 1 did exactly what it was designed to do, and it is important to be precise about what that was. The prove cycle ran end-to-end against `agenticsnz/unsorry`: distinctly-identified swarm agents claimed unproved goals, drove `claude` to write Lean proofs, self-verified locally, and merged through Gate A and Gate B (`phase1-run-001`: 5 prove attempts, 3 merges, merge rate 0.6, 0 coordination errors, 0 unsound proofs). That is a working autonomous research loop with a real kernel-enforced soundness boundary. But the three theorems it banked — `int-add-neg` (#72), `int-neg-neg` (#74), `and-comm-imp` (#70) — are one-line citations of existing mathlib lemmas (`:= Int.neg_neg n` and the like). They carry **zero new mathematical value, by design**. Phase 1 proved the machine, not mathematics. The merged proofs were instrumentation: they exist to show the claim/verify/merge plumbing, the gates, and the agent identity trail all hold under a real contributor workflow, which `phase1-run-001` and the Round-001 red team (`gate-a-redteam-001.md`) jointly establish.

Phase 2 is where solved theorems start to matter. The objective is no longer "show the loop runs"; it is "drive verified proofs to a result that is **not already in mathlib**, by decomposing it into sub-lemmas that the swarm proves and recomposes." This is the first phase whose output is a contribution rather than a self-test. It exercises the three mechanisms the design doc describes but Phase 1 deliberately left unbuilt: decomposition on prove-failure (Components §6), affinity-weighted and gap-based selection (Components §6), and the library index as a compounding substrate (Component §7). None of these is wired today — Phase-1 selection is plain lexicographic order, prove-failure just releases and flags with no decomposition (SPEC-007-A step 11), and affinity is never computed.

The honest framing from the master design carries straight through and must not be oversold: **formal mathematics is an enabling public good, not a direct-welfare deliverable.** It sits upstream of human welfare — verified software, clean cryptography, an error-free mathematical record, a sound substrate for AI reasoning — rather than at the point of delivery. A first lemma proved that is genuinely absent from mathlib is a real and lasting contribution; it is not a cure for a disease. Phase 2 is judged against that upstream standard, deliberately.

## 2. What must be true before Phase 2 starts (prerequisites)

Phase 2 points an autonomous swarm at a hard, unsolved-by-the-library target. That is only safe and only meaningful once five things hold. None is optional; pointing the machine at hard targets on an unproven loop, or with an unbound notion of "proved," wastes budget and produces results no one can trust.

- **(a) Decomposition is built — ADR-009 / SPEC-009-A.** Today a prove-failure ends the line (SPEC-007-A step 11: release + flag, "Phase 1 keeps it simple — no decomposition"). Phase 2 needs the failure path to instead produce a `decompositions/<parent>.<agent>.aisp` record (schema already in SPEC-003-C), generate the sub-goal records, wire the `Post(A) ⊆ Pre(B)` dependency edges, re-queue the subs, and block/unblock the parent. Without this the swarm cannot make progress on anything it cannot one-shot — which a real target, by definition, is.
- **(b) Affinity and gap-based selection are wired — ADR-010 / SPEC-010-A.** The protocol already specifies the mechanism (`⟦Γ:Affinity⟧`: `+1` on merge, `−10` on fail, viability threshold `τ_v = −5`, `select ≜ argmax(aff(g), −gap(g, library))`, `gap ≜ |deps(g) \ proved|`). It is **not** implemented: SPEC-007-A selects the first candidate in lexicographic goal-id order and never reads or writes affinity. At Phase-2 scale a target fans out into many sub-goals of very different value; lexicographic order would have the swarm grind through them blindly. Selection must prefer the smallest viable gap and proven patterns before the machine is pointed at a target.
- **(c) The statement-binding check is live — ADR-011 / SPEC-011-A.** This is the load-bearing prerequisite. Gate A proves a theorem is *sound*; it does **not** prove the theorem *says what the goal asks* — the gap the Round-001 red team exposed with PR #64 (`autoImplicit` vacuity, `axioms: []`, sound but meaningless). `gate-a-redteam-001.md` records the proper fix explicitly: a statement-vs-canonical-sha binding check that lowers the goal's canonical statement to Lean and checks the merged theorem matches it. Until that exists, "this target is proved" is an unbound claim. Phase 2 cannot declare a target solved against a check that does not bind meaning — and decomposition makes this strictly worse (see §5), because every generated sub-statement is a fresh place to be vacuous or over-general. The binding check must extend to generated subs, not just top-level goals.
- **(d) A stable, measured Phase-1 run exists first — `phase1-run-002`.** `phase1-run-001` is a floor, not a clean baseline: merge rate 0.6 was dragged down by an infrastructure fault (the bare prove worktree never runs `lake exe cache get`, so local verify rebuilds ~8486 mathlib modules from source and times out), a full `/tmp`, and two redundant duplicate PRs from agents re-selecting the same goal under pending auto-merge. Before Phase 2, re-run the prove swarm with the cache fix in place, close most of the 20-goal backlog cleanly, and record `phase1-run-002` with a merge rate that reflects the loop's real capability rather than disk and cache friction. **Do not point the machine at hard targets on a loop whose merge rate is still an infrastructure artifact.**
- **(e) A target is chosen — `docs/phase2-targets.md`.** This is an explicit human curation call and cannot be automated: the kernel guarantees soundness, not relevance. `docs/phase2-targets.md` holds the shortlist, grounded in the swarm's real Phase-1 band (Int/Nat one-liners delegating to mathlib). The recommended **first** target is the Nicomachus identity, Σk³ = (Σk)² — an unambiguous definitional statement that sidesteps the binding gap, genuinely needs two or three lemmas depending on an existing mathlib Σk lemma (so it exercises decomposition records and gap-selection), and is cheap and true. A genuine first contribution follows: a LeanComb/CombiBench combinatorial identity (high-confidence absence, mathlib's thinnest area) or an unsolved PutnamBench item. The AISP-15 dogfooding set is kept as a later flagship, **not** first: its claims have no Lean statement (paper/natural-deduction only), so it would co-load autoformalisation with the still-open vacuity/fidelity gap. Absence claims are 2026-06-10 snapshots and **must be re-grepped against mathlib HEAD at commit time** — several "obvious" candidates (Bertrand, Stirling, Frobenius/Chicken-McNugget, sum-of-two-squares) were dropped precisely because they are already in mathlib, and Pick's theorem was downgraded to unverified after a Lean formalization appeared (arXiv 2603.23095, Mar 2026).

## 3. Staged delivery

Five stages, gated so each lands its specs and its evidence before the next begins. The dependency order is deliberate: stabilise and measure the loop, give it good selection, give it decomposition, bind its claims to meaning, then — and only then — point it at a target. Statement-binding (Stage D) lands **before** the first Phase-2 run because decomposition (Stage C) multiplies the binding gap; the two are sequenced so that no target run happens against an unbound notion of "proved."

### Stage A — Stabilise and measure Phase 1 (`phase1-run-002`)

Re-run the prove swarm on the existing 20-goal backlog with the infrastructure faults from `phase1-run-001` fixed first: add `lake exe cache get` to the prove worktree setup (the one-line fix `phase1-run-001` flagged but the observer was not permitted to make), and run with clone + workdir + `CLAUDE_CODE_TMPDIR` on a roomy filesystem so no agent hard-blocks on a full `/tmp`. Close most of the backlog. Record `phase1-run-002` with merge rate, collision rate, coordination-error count, and the duplicate-PR/fan-out behaviour, so the Phase-2 baseline is the loop's real capability rather than disk-and-cache friction.

- **Lands:** the cache-warm prove-worktree change to `swarm/agent.sh` (SPEC-007-A step 6 amendment); `docs/metrics/phase1-run-002.md` + `.json`.
- **Exit:** most of the 20-goal backlog proved and merged; a trustworthy merge rate recorded with the cache fix in place; the redundant-PR/fan-out behaviour characterised (input to the Stage C fan-out caps).

### Stage B — Affinity and gap-based selection (ADR-010 / SPEC-010-A)

Wire the selection mechanism the protocol already specifies but the script ignores. Implement affinity bookkeeping on the index (`+1` on merge, `−10` on fail, `τ_v = −5` viability skip + re-queue for re-decomposition) and replace lexicographic selection with `argmax(aff(g), −gap(g, library))`, `gap ≜ |deps(g) \ proved|`. This is pure coordination/queue logic — it never touches Gate A, never touches soundness — so it is built and tested before decomposition gives it many sub-goals of differing value to choose between.

- **Lands:** ADR-010 (selection and affinity decision); SPEC-010-A (selection algorithm, affinity update rules, index-entry `aff` lifecycle); `swarm/agent.sh` selection step rewrite + index affinity-update on merge/fail; `--self-test` cases for ranking, the viability skip, gap computation, and re-queue.
- **Exit:** selection demonstrably prefers smaller-gap, higher-affinity goals over lexicographic order on a fixture tree; affinity updates land on the index on merge and fail; below-`τ_v` patterns are skipped and re-queued, all under hermetic `--self-test`.

### Stage C — Decomposition (ADR-009 / SPEC-009-A)

Turn the prove-failure path from "release + flag" into "decompose." On a prove-failure within budget, the agent produces a `decompositions/<parent>.<agent>.aisp` record (SPEC-003-C schema): sub-lemma statements, fresh `goals/<sub>.aisp` records with `src` pointing at the decomposition, and `Post(A) ⊆ Pre(B)` dependency edges. The parent is marked **blocked** until its subs prove; **unblock** logic re-opens it when its dependency set is covered. Guards are non-negotiable: the SPEC-003-C cap of 8 subs per decomposition, plus tight depth and budget caps to prevent runaway fan-out (a sibling flood worsens the duplicate-PR throughput risk `phase1-run-001` already observed). The dependency edges must form a DAG — `Post(A) ⊆ Pre(B)` edges that cycle would deadlock the queue. **SPEC-003-C defines the edge type but specifies no acyclicity check; Gate B must reject cycles, and this plan treats closing that gap as in-scope for Stage C, not a follow-up.**

The load-bearing soundness rule for this stage, stated once and enforced: **sub-lemmas alone prove nothing about the target.** A Decomp record plus merged sub-index entries must **not** flip the parent to `proved`. The parent counts as proved only when an agent writes a library module that imports the subs, proves the parent's *exact* signature, and that module passes Gate A — the same trust model as every other proof. The parent's kernel recomposition is the proof; the decomposition is only queue structure.

- **Lands:** ADR-009 (decomposition decision, the no-auto-prove-on-subs rule, fan-out/depth caps); SPEC-009-A (decomposition-record production on prove-failure, sub-goal generation and re-queue, parent blocked/unblock semantics, depth/breadth guards, the Gate B acyclicity check on `Post(A) ⊆ Pre(B)` edges); `swarm/agent.sh` prove-failure path rewrite (replacing SPEC-007-A step 11); Gate B DAG validation; `--self-test` for record production, edge validity, the blocked/unblock transitions, the cap/depth guards, and rejection of a planted cyclic decomposition.
- **Exit:** a prove-failure produces a valid, acyclic, capped decomposition with re-queued subs; the parent is blocked and only unblocks when its subs are covered; a parent **never** flips to proved without a kernel-recomposing library module passing Gate A; Gate B rejects a planted cyclic decomposition; all under `--self-test` plus a live decomposition smoke.

### Stage D — Statement-binding (ADR-011 / SPEC-011-A)

Close the gap PR #64 exposed and the Round-001 red team recorded as deferred. Add a defeq meta-check to Gate A that lowers a goal's canonical statement to Lean and checks the merged theorem's statement is definitionally equal to it — binding *soundness* (which Gate A already enforces) to *meaning* (which it does not). Because decomposition (Stage C) creates many new sub-statements, and **every generated sub-statement is a new place to be vacuous or over-general**, the binding check must extend to generated subs, not only top-level goals — this is why Stage D lands before any Phase-2 target run, not after. Build `AuditFixtures` for vacuous and weakened statements (the `autoImplicit`-class vacuity vector from #64 among them) and re-run a red-team round to prove the gate now blocks what it previously let through.

- **Lands:** ADR-011 (statement-binding decision, scope over goals and generated subs); SPEC-011-A (the defeq meta-check in Gate A, canonical-statement lowering, the sub-statement extension, fixture catalogue); `tools/gate_a` binding check; `AuditFixtures` for vacuous/weakened/over-general statements; a fresh red-team round (`gate-a-redteam-002`) including the #64 `autoImplicit` payload.
- **Exit:** Gate A rejects a vacuously-true or weakened restatement under a plausible name (the #64 payload now fails on the binding check, not only on the option scan); the binding check fires on generated subs as well as top-level goals; the new red-team round records every binding vector blocked.

### Stage E — Choose target and first Phase-2 run

With Stages A–D landed, make the human curation call (`docs/phase2-targets.md`), re-grep the chosen target's absence against mathlib HEAD at commit time, and run the first Phase-2 orchestration: point N agents at the target with decomposition on (Stage C), affinity and gap-selection on (Stage B), and the binding check live (Stage D). Recommended first target is the Nicomachus identity Σk³ = (Σk)² — it exercises decomposition and gap-selection end-to-end on an unambiguous, definitionally-clean statement, cheaply. Observe and record: did the swarm decompose, prove the subs, and recompose to the parent's exact signature through Gate A — and did it reach the target rather than merely fragmenting it.

- **Lands:** the finalised `docs/phase2-targets.md` target selection with a HEAD re-grep note; the Phase-2 run record (`phase2-run-001`).
- **Exit:** the success metric in §4 — a first lemma proved that was not already in mathlib — or a recorded, diagnosed failure to reach it.

## 4. Exit and success metric

The single number that matters for Phase 2 is **the first lemma proved that was not already in mathlib**, recomposed to the target's exact signature and passing Gate A with the binding check live. Not sub-lemma throughput. Not decomposition-record count. Not PRs merged.

State the trap explicitly, because the architecture makes it easy to fall into: **a swarm can decompose busily and prove a hundred trivial fragments while never reaching the target.** High sub-lemma throughput with zero target progress is failure, not partial success. Affinity and gap-selection (Stage B) are meant to pull the swarm toward the target rather than into a comfortable thicket of easy subs, but the *metric* is the backstop — Phase 2 is measured by target reach, and the run record must report distance-to-target, not just activity. The Nicomachus first target is chosen partly so this metric has an unambiguous yes/no answer on a cheap run before any real-contribution target is attempted.

## 5. Risks

- **Runaway decomposition fan-out.** Decomposition that re-decomposes its own subs can fan out exponentially; a sibling flood also worsens the duplicate-PR throughput problem `phase1-run-001` already observed (agents re-selecting the same goal under pending auto-merge). *Mitigate:* the SPEC-003-C cap of 8 subs per decomposition, plus the tight depth and total-budget caps that land with Stage C, plus the affinity viability skip (`τ_v`) that stops re-decomposing unproductive patterns.
- **Affinity local optima.** Affinity favours proven approaches (`+1`/`−10` is deliberately asymmetric), which can trap the swarm in a locally-good decomposition that never reaches the target. *Mitigate:* the `−gap(g, library)` term keeps pulling toward the target; re-queue-for-re-decomposition on sub-threshold patterns; and the §4 metric makes "busy but not progressing" visible rather than rewarded.
- **Build and throughput cost at Phase-2 scale; Agent SDK credit economics.** Phase 2 runs more agents over more cycles, each a `claude` call plus a `lake build` (the `phase1-run-001` cache fix is a prerequisite precisely to keep per-cycle cost bounded). At scale this is a real credit and wall-clock budget question, not a rounding error. *Mitigate:* the warm-cache fix from Stage A; the per-cycle wall/turn/attempt budgets the protocol already enforces (`budget ≜ ⟨turns ≤ 40, wall ≤ 1800s, attempts ≤ 2⟩`); fan-out caps that bound the total work a single target can spawn; cheap first target (Nicomachus) before any expensive one.
- **Target chosen too hard, or already in mathlib.** Too hard → no progress and burnt budget; already in mathlib → no value even on success. *Mitigate:* the staged target ladder in `docs/phase2-targets.md` (Nicomachus → combinatorial identity → PutnamBench), the explicit human curation call, and the mandatory re-grep against mathlib HEAD at commit time (several "obvious" candidates were dropped exactly for being already present; Pick's theorem was downgraded after a 2026 Lean formalization appeared).
- **Statement-binding defeq edge cases.** The Stage D defeq meta-check is not a fully solved problem — two faithful statements can differ in ways defeq does or does not see, and decomposition multiplies the surface (every generated sub is a new binding site). *Mitigate:* the `AuditFixtures` catalogue of vacuous/weakened/over-general statements; flag-don't-block where the check is uncertain (mirroring the dual-translation fidelity gate's discipline); and treat the sub-statement extension as a prerequisite of Stage D, not a follow-up, so no Phase-2 target run happens against an unbound sub.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Distributed Autonomous Research Swarm: Architecture and Plan | Design document | distributed-research-swarm-plan.md |
| REF-2 | Swarm contract (Affinity, Records, Loop) | Protocol | ../../swarm/protocol.aisp |
| REF-3 | SPEC-003-C — Translation and Decomposition Records | Specification | ../adrs/specs/SPEC-003-C-Translation-and-Decomposition-Records.md |
| REF-4 | SPEC-007-A — Agent Loop Script | Specification | ../adrs/specs/SPEC-007-A-Agent-Loop-Script.md |
| REF-5 | ADR-006 — Gate A Soundness Enforcement | Decision | ../adrs/ADR-006-Gate-A-Soundness-Enforcement.md |
| REF-6 | Gate A Red Team — Round 001 | Metrics | ../metrics/gate-a-redteam-001.md |
| REF-7 | Phase-1 swarm trial — run 001 | Metrics | ../metrics/phase1-run-001.md |
| REF-8 | Phase-2 target shortlist | Curation | ../phase2-targets.md |
| REF-9 | ADR-009 — Decomposition (to be authored) | Decision | ../adrs/ADR-009-Decomposition.md |
| REF-10 | ADR-010 — Affinity and Gap-Based Selection (to be authored) | Decision | ../adrs/ADR-010-Affinity-Gap-Selection.md |
| REF-11 | ADR-011 — Statement-Binding Check (to be authored) | Decision | ../adrs/ADR-011-Statement-Binding.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-10 |
