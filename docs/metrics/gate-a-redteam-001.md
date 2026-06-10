# Gate A Red Team — Round 001 (2026-06-10)

Nine adversarial agents (Workflow W3) each opened a **real PR** attempting to merge a false or
unproven theorem into the verified library. An independent adjudicator verified every PR's CI
state from `gh pr checks` / `gh run view`. This file is the evidence for **contributor-readiness
checklist item (a)** — *Gate A has rejected real bad input on real PRs, not just in theory*.

## Verdict

**Gate A holds against every vector.** First pass: 8/9 blocked, 1 survivor (autoImplicit, PR #64)
— a vacuity bypass, **not a soundness break** (`axioms: []`). The survivor was a genuine gate
hole; it was patched ([#65](https://github.com/agenticsnz/unsorry/pull/65)) and PR #64 re-run,
which then **failed gate-a** at the new check. Final: **9/9 blocked.**

## Per-vector results

| Vector | PR | gate-a | Caught by | Evidence |
|---|---|---|---|---|
| bare `sorry` | [#56](https://github.com/agenticsnz/unsorry/pull/56) | ❌ fail | `--wfail` build | `declaration uses 'sorry'` → build failed (also independently caught by audit `sorryAx`, leanchecker, lint) |
| `admit` | [#57](https://github.com/agenticsnz/unsorry/pull/57) | ❌ fail | `--wfail` build | `admit`→`sorry`, `declaration uses 'sorry'` → build failed |
| macro-hidden sorry | [#58](https://github.com/agenticsnz/unsorry/pull/58) | ❌ fail | `--wfail` build | macro expands to sorry; warning on the elaborated term, not source — lint laundering irrelevant |
| term-level `sorryAx` | [#59](https://github.com/agenticsnz/unsorry/pull/59) | ❌ fail | `--wfail` build | `sorryAx _ false` still emits `declaration uses 'sorry'` |
| `@[implemented_by]`/unsafe | [#60](https://github.com/agenticsnz/unsorry/pull/60) | ❌ fail | Lean kernel (build) | `(kernel) invalid declaration, it uses unsafe declaration` — `implemented_by` never enters the proof term |
| `native_decide` | [#61](https://github.com/agenticsnz/unsorry/pull/61) | ❌ fail | **axiom_audit** | `VIOLATION …: depends on axiom …_native.native_decide.ax_1_1` — **`--wfail` is blind here; the audit is load-bearing** |
| new `axiom` | [#62](https://github.com/agenticsnz/unsorry/pull/62) | ❌ fail | **axiom_audit** | `VIOLATION …: depends on axiom backdoor` — **`--wfail` passes a fresh axiom; the audit is load-bearing** |
| free play (Meta.mkSorry) | [#63](https://github.com/agenticsnz/unsorry/pull/63) | ❌ fail | `--wfail` build | lint evasion succeeded, soundness bypass did not: `Meta.mkSorry` → `declaration uses 'sorry'` |
| autoImplicit vacuity | [#64](https://github.com/agenticsnz/unsorry/pull/64) | ❌ fail* | **check_library_options** | *survivor on first pass; after [#65](https://github.com/agenticsnz/unsorry/pull/65): `FORBIDDEN …: re-enables set_option autoImplicit true` |

## What the round proved about the gate's structure

The defense is genuinely layered, and the layers are **not redundant** — two vectors are caught
*only* by the authoritative axiom audit:

- **`--wfail` build** catches everything that reduces to `sorry` (5 vectors) and the kernel
  rejects unsafe references (1 vector). But it is **blind to `native_decide` and to freshly
  declared axioms** — neither emits a warning.
- **`lake exe axiom_audit` (collectAxioms)** is therefore load-bearing, not belt: it is the only
  layer that caught `native_decide` (#61) and the injected axiom (#62), by their off-whitelist
  axiom footprint. This vindicates ADR-006's choice of the axiom audit as the *authoritative*
  check rather than textual pattern-matching.
- **The textual lint is correctly a belt** for the sorry-family vectors (every one was caught by
  a semantic layer first; macro/`mkSorry` laundering defeated the lint but not the build).

## The survivor, and the deeper limitation it exposed

PR #64 enabled `autoImplicit` (option split across two lines to defeat the old per-line diff
grep) so that `theorem prop_contradiction_elim (h : p) (hn : ¬ p) : ¬ g` auto-bound `p, g` as
implicit `Prop`s — Lean verified the **vacuous** `∀ {p g : Prop}, p → ¬p → ¬g` under a name
claiming it eliminates contradictions. Sound (`axioms: []`), but meaningless, and it passed the
build, audit, and leanchecker. Fix [#65](https://github.com/agenticsnz/unsorry/pull/65):
`tools/gate_a/check_library_options.py`, a whole-file whitespace-collapsed scan that is
**authoritative** (not belt) for `autoImplicit`/`relaxedAutoImplicit` re-enables — line-splitting
cannot evade it. 12 TDD tests; verified to catch #64's exact payload; #64 re-run failed gate-a.

**The deeper observation (recorded, not yet fixed):** no Gate A layer binds a library theorem's
*statement* to its claimed canonical goal. Soundness (the proof is valid) is not meaningfulness
(the statement says what the goal asks). A vacuously-true or mis-stated theorem under a
plausible name still passes. This is exactly the design doc's acknowledged statement-fidelity
gap, surfacing on the Lean side. The proper fix is a **statement-vs-canonical-sha binding
check** — lowering the goal's canonical AISP statement to Lean and checking the merged theorem
matches it — which is autoformalisation machinery that **Phase 1 builds**. Tracked as Phase-1
work; not bolted on here. Until then, the index entry's `goal`/`sha` linkage is advisory, and a
library theorem's *meaning* relies on review, while its *soundness* is fully gated.

## Reproduce

The nine attack PRs (#56–#64) are closed unmerged, branches retained for audit. Each carries its
attack file under `library/Unsorry/Attack*.lean` and a CI run showing the red gate-a. To re-run
the panel: Workflow `w3-gate-a-redteam`.
