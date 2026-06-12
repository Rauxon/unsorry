# SPEC-011-A: Statement-Binding Gate

Implements: [ADR-011](../ADR-011-Statement-Binding-Gate.md) · Refines: [SPEC-006-B](SPEC-006-B-Gate-A-Workflow.md) · Status: Living · Updated: 2026-06-12

Closes the meaningfulness gap the W3 red team exposed (gate-a-redteam-001, PR #64): Gate A certifies a proof is *sound* but not that the merged declaration's *statement* is the one the goal asked for. This binds formal-statement → proof, alongside the dual-translation fidelity gate that binds English → formal.

## Mechanism: a regenerated kernel obligation

ADR-011 chose an elaborated-type defeq check. It is realised not by a metaprogram but by a **generated proof obligation the kernel discharges** — simpler, stronger, and free of the name-clash a two-environment `isDefEq` would hit.

For each proved goal `<g>` (a `library/index/<sha>.aisp` naming it), Gate A writes `library/Unsorry/<Camel>Binding.lean`:

```lean
import <module declaring the proved theorem>

<open commands of goals/<g>.lean, if any>
theorem <name>_binding_check : <∀-type of goals/<g>.lean> := <name>
```

- `<name>` = the goal theorem's name (`tools.lean_sig.theorem_name`).
- `<∀-type>` = the goal's own statement as a closed ∀-expression (`tools.lean_sig.foralltype`: `theorem <n> <binders> : <prop>` → `∀ <binders>, <prop>`, split at the first depth-0 `:`).
- The import targets the library module that actually declares `<name>`, located **by content** (`_module_declaring`) so a grandfathered module (e.g. `Basic.lean`) is handled, not only the `<Camel>.lean` convention.
- The goal file's top-level `open …` commands (`tools.lean_sig.open_lines`) are carried into the generated module, after the import and before the obligation. A goal stated under `open Finset` names `range` unqualified; the obligation restates that type verbatim, so it must elaborate in the goal's own namespace context (surfaced by the batch-3 goals, PR #259). The opens come from the ADR-018-immutable goal file — never from the prover's module — so the gate's tamper surface is unchanged.
- The generated file is prefixed with `set_option linter.unusedVariables false in` (issue #231). A goal whose statement has a **named hypothesis binder after an implicit binder** (`∀ {n : ℕ} (hn : 1 < n), …`) is eta-expanded in the obligation and the eta-introduced binder is flagged unused, which the `--wfail` build promotes to an error — making *every* correct proof of such a goal fail Gate A. The suppression is **unconditional** (every generated binding carries it), so the whole class is covered, not only the shape that surfaced it; it disables a lint on regenerated, never-committed glue and leaves the type-check — the obligation's entire force — untouched, so soundness is unaffected.

The obligation type-checks under `lake build UnsorryLibrary --wfail` **iff** the proved theorem's type is definitionally equal to (or more general than, via implicit insertion) the goal's type. A weakened, vacuous, or otherwise different statement under the goal's name cannot inhabit the goal type, so the binding build fails and Gate A goes red — verified in sandbox: the real proof's binding builds (exit 0), a `True`-vacuous restatement's binding fails (exit 1).

## Non-bypassable by construction

Gate A **regenerates** the binding from the goal (`python3 -m tools.gate_a.check_statement_binding generate .`, the step before the `--wfail` build), rather than trusting a committed binding. A contributor therefore cannot weaken the asserted type, omit the obligation, or fake the proof term — Gate A controls the generation. The agent's prove cycle (`run_proof` → `write_binding_module`) generates the same obligation locally for its self-verify, then drops it before check-in (`check_in_proof`); bindings are CI-ephemeral, never committed.

Because the obligation is regenerated for **every** index entry, decomposition's generated sub-lemmas (ADR-009) are bound on exactly the same footing as top-level targets — the #64 class does not reopen under fan-out.

## Scope and residue

This gate binds the proof to the goal's *chosen formalisation*. A goal that mis-formalises its informal target still yields a meaningful-looking proof of the wrong thing — that residue is the **fidelity gate's** job (dual independent translation, design doc §5), not this one. Stated honestly per ADR-011.

`tools/lean_sig.py` holds the shared Lean-signature parsing (statement, name, sha, foralltype, open_lines, camel) imported by both `swarm/agent.sh` and this check (DRY).

## Acceptance criteria

1. `test_generate_writes_canonical_binding` — the generated obligation is byte-exactly the canonical `theorem <n>_binding_check : <ftype> := <n>`.
2. `test_generate_finds_module_by_theorem_name` — a proof in a non-`<Camel>` module (the `Basic.lean` case) is found by content.
3. `test_generate_errors_when_no_module_declares_the_theorem` — a proved goal with no declaring module fails (exit 1).
4. `test_foralltype_no_binders` / `test_foralltype_implicit_and_instance_binders` — `foralltype` handles `: P`, and `{…}`/`[…]`/`(…)` binders.
5. Sandbox/CI: every existing proved goal's binding builds under `--wfail`; a weakened restatement's binding fails (red-team round 002, `gate-a-redteam-002`).
6. `test_generate_suppresses_unused_variable_lint` — the obligation for an implicit-then-named-hypothesis goal carries the `set_option linter.unusedVariables false in` line (issue #231).
7. `test_generate_carries_goal_open_commands` — a goal stated under `open Finset` yields an obligation carrying that `open` between the import and the theorem; `test_generate_without_opens_is_byte_identical_to_canonical` — without opens the output keeps the exact pre-open canonical shape.

## End-to-end regression guard (`binder-shape-canary`)

The hermetic generator tests (1–6) check the obligation's *text*, never that it *builds* `--wfail`-clean — which is why #231 reached a contributor (#221) instead of CI. The permanent fixture goal **`binder-shape-canary`** closes that: a sound, mathlib-free lemma (`theorem binder_shape_canary {n : Nat} (h : 1 < n) : 0 < n`) carrying the exact problematic shape. Because Gate A regenerates and builds every proved goal's binding on every run, the canary's binding is built `--wfail` each time — so removing the suppression, or a future linter tripping the same shape, goes red **on the canary, at the gate**. Validated both ways: with the suppression the binding builds (exit 0); without it the build fails on `unused variable h`. The proof uses `h`, so the library module itself stays `--wfail`-clean — only the binding's eta-expansion exercises the lint. It carries no `Absence` provenance, so the upstream pipeline (ADR-020) never packets it.
