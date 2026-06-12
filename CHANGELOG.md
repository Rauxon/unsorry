# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Statement-binding generator (ADR-011/SPEC-011-A): a goal whose statement has a named hypothesis binder following an implicit binder (e.g. `theorem t {n : ℕ} (hn : 1 < n) : …`) produced a binding obligation whose eta-expanded binder is flagged by `linter.unusedVariables`, failing the Gate A `--wfail` build for **any** correct proof of such a goal (first hit: `not-prime-pow-four-add-four`, PR #221). Generated bindings now carry `set_option linter.unusedVariables false in` — their force is the type-check, not lints, and the files are regenerated glue that never lands in a PR. Regression test added; all 38 current bindings rebuilt clean under `--wfail`

## [1.5.1] - 2026-06-12

### Fixed

- `agent.sh` self-test on macOS: under bash 5.3 with a UTF-8 locale, the unbraced `$csv` adjacent to the `⟩` glyph in `set_goal_deps` parses the multibyte character into the identifier and aborts the suite at test 20/32 (`csv: unbound variable` under `set -u`), silently skipping the last 12 tests; the same line's `sed -i` also requires a backup-suffix argument under BSD sed. Braced the expansion and replaced in-place sed with portable write+rename. Repro: `bash -uc 'csv=x; echo "$csv⟩"'` on macOS/bash 5.3.9. A full-script scan (`perl -ne 'print if /\$[A-Za-z_]\w*[^\x00-\x7F]/'`) confirms this was the only expansion/glyph adjacency; the live loop path is unaffected

## [1.5.0] - 2026-06-12

### Added

- **Thread B exit — first compounding** (`docs/metrics/phase3-run-002.{json,md}`): `sum_range_cube_eq_triangular_sq` proved in 4m57s on the first attempt by **importing and invoking the swarm's own `nicomachus_sum_cubes`** (#154) — the first merged-lemma reuse by mechanism (ADR-014: proved deps surfaced in the prove prompt as importable `Unsorry.*` modules). Run-001's four recompositions corroborate (same surfacing, parents importing their proved subs). Honest limits recorded: depth-1 tree, one declared edge; deep bottom-up routing remains open. README compounding claim updated

## [1.4.0] - 2026-06-12

### Added

- **Thread A exit — the chain, in anger** (`docs/metrics/phase3-run-001.{json,md}`): `platonic_schlafli_pairs` (the Platonic-solids Schläfli arithmetic core, mathlib-absent) kernel-verified on main **via** a forced depth-3 decompose → prove-subs → recompose chain — 13 goals, 4 decompositions, 4 recompositions, statement binding held throughout, the parent's proof literally composing its sub-lemmas (#149→#211). Honest record: stage-1 budget forcing, three quota outages (the third absorbed unattended by ADR-016/017), the #166 conflicted-PR silent stall, claim races and their bounded cost, ladder rung stats (11/13 proofs at the cheapest rung). README/roadmap updated: "demonstrated on paper, not in anger" retired

### Fixed

- ADR-017 claim guard: GitHub title search tokenizes punctuation, so `"prove(<goal>):" in:title` also matched open PRs for sibling goals sharing the name's tokens — the leftover duplicate #198 (`...-s2-s2`) blocked both agents from claiming the recompose-ready parent. The verdict now comes from an exact title-prefix match over the search results; the regression (sibling↛parent, parent↛sub) is covered in `test_open_pr_claim_guard`

## [1.3.0] - 2026-06-11

### Added

- Swarm supervisor (ADR-017, SPEC-017-A): `swarm/supervise.sh` drives a goal tree to closure across infrastructure outages (exponential backoff on the ADR-016 exit-3 signal), cycle failures, and merge latency, terminating only when every goal in scope is `proved`. Each wait runs scope-limited PR hygiene: duplicate prove PRs (the claim-race symptom, #184/#185) are closed keeping the oldest, and CONFLICTING PRs are loudly flagged — GitHub runs no checks on a conflicted PR, so an armed auto-merge otherwise waits forever in silence (the #166 failure mode). Agent-side: prove selection now skips any goal whose prove PR is already open (the claim is released at PR-open, so the claims branch cannot see in-flight work). 3 supervisor self-tests + 1 agent self-test (32 total); agent-lint CI covers both scripts

### Added

- Infrastructure-failure guard (ADR-016, SPEC-016-A): a failed claude call that died in under `UNSORRY_FASTFAIL` seconds (default 240) and whose cheap-model health probe also fails is classified as an infrastructure failure — claim released with no `prove-failed` event, no decomposition, no demote, and the agent exits with code 3 for the orchestrator. Motivated by the two 2026-06-11 quota outages that each demoted a whole goal tree below τ_v. Prove prompt now also warns that Gate A's text lint greps comments for forbidden tokens (the word "axiom" in a doc comment failed an otherwise-sound proof)

### Changed

- Progressive effort escalation (ADR-015, SPEC-015-A, amends ADR-013): prove attempts now climb the effort ladder `high` → `xhigh` → `max` instead of running every attempt at static `max`, with the prove-mode attempt budget defaulting to 3 (one per rung) and decomposition always at the top rung. A set `UNSORRY_EFFORT` pins every attempt; fail-soft on CLIs without `--effort` unchanged. Each attempt's effort is logged for run reconstruction

### Added

- Cross-goal dependency reuse (ADR-014, SPEC-014-A): a goal's proved dependencies — declared `deps≜⟨…⟩` plus its own decomposition's subs — surface in the prove prompt as importable `Unsorry.*` modules with statements, so merged lemmas compound instead of being re-proved. Seeded the first dependency edge: `nicomachus-sum-cubes-triangular → nicomachus-sum-cubes` (thread B target)


### Fixed

- Index records no longer embed the statement (same brace hazard as the decomposition fix): `⟦Σ:Stmt⟧` → `⟦Σ:Source⟧{src≜goals/<goal>.lean}`, with Gate B recomputing the sha from the goal file when it exists (GB006 on mismatch; grandfathered translate-era entries keep the filename≡sha check). All 20 existing index records migrated; caught before the first brace-statement lemma (the recomposed platonic-schlafli-core parent) would have failed its prove PR


### Added

- Phase-3 roadmap (thread G): AISP value benchmark — observational instrumentation (tokens/record, Gate B first-try rejection rate) plus an A/B trial against a JSON mirror of the schemas and contract, to measure the notation's claimed value before contributors are asked to learn it


### Added

- PR labelling strategy (`docs/pr-labels.md`): 11 labels classified deterministically from the machine-generated titles (`tools/repo/pr_labels.py`, single source of truth), auto-applied by `.github/workflows/pr-labels.yml` on open/edit; all 145 historical PRs retroactively labelled. 5 classifier tests


### Added

- Phase-3 roadmap (thread E): failure-notes idea — a one-line approach diagnosis on the demote path, surfaced to the next claimant, so failed attempts become transferable knowledge instead of re-walked dead ends


### Fixed

- Decomposition records reference sub statements by content address (`sha≜`), never inline (SPEC-003-C): the record grammar reserves `{}` for block delimiters and real Lean statements contain braces — the first real decomposition (platonic-schlafli-core, Finset literal) broke the Σ-block parse and failed Gate B. Gate B now recomputes each sub's sha from `goals/<id>.lean` (GB016 on mismatch — strictly stronger integrity); `decompositions/` is created before first write (git tracks no empty dirs). 3 new regression tests


### Added

- Thread C plan: `docs/proposals/mathlib-upstream-plan.md` — the mathlib upstream path, designed around mathlib's verified AI-contribution policy (disclosure + `LLM-generated` label + author-understands-everything): machine-prepared upstream packets, human-sponsored PRs, Zulip-first; autonomous PRs are an explicit non-goal. Current candidates: the two mathlib-absent lemmas


### Added

- Model/effort policy for proof runs (ADR-013, SPEC-013-A): prove and decompose `claude` calls default to the most capable model (`fable`) at `--effort max`, env-overridable via `UNSORRY_MODEL`/`UNSORRY_EFFORT`, with the effort flag dropped fail-soft on CLIs that lack it; translation stays on `sonnet`. Run config recorded in the startup log. 28 self-tests


### Added

- Phase 3 roadmap proposal (`docs/proposals/phase3-roadmap.md`): the honest open frontier after Phase 2 — force decomposition end-to-end, drive to a chosen result through a dependency tree, upstream to mathlib, open the swarm at volume

### Changed

- README "The goal, honestly" reworked: the shakedown is over and Phase 2's bet paid off (first mathlib-absent lemma), reframed honestly — one elementary lemma is a proof of concept, not a research programme; the scale/compounding question is the Phase-3 frontier


### Added

- First sourced target batch (ADR-012): 10 vetted unformalised-in-mathlib theorems admitted to the backlog — sum of odd numbers = n², Faulhaber k=2/k=4 closed forms, Nicomachus triangular form, Fibonacci sum-of-squares, a factorial telescoping sum, n⁴+4 compositeness (Sophie Germain), the sum-of-odd-squares form, an alternating natural sum, and the Platonic-solids Schläfli arithmetic core. Each build-checked (type-checks vs mathlib v4.30.0) and machine-absence-checked; surfaced on the `docs/targets.md` board


### Added

- Backlog-sourcing pipeline (ADR-012, SPEC-012-A): `tools/sourcing/check_absence.py` (machine mathlib-absence check, grep-authoritative + best-effort Loogle, records the rev), `tools/sourcing/targets_board.py` → `docs/targets.md` (the human worklist), a `propose-target` issue template, and `docs/proposals/backlog-sourcing.md`. Scope boundary stated: formalisation gap, not open conjectures. 13 tests


## [1.2.0] - 2026-06-10

### Added

- **First unformalised-in-mathlib lemma proved**: Nicomachus's theorem `∑ k³ = (∑ k)²` (`nicomachus-sum-cubes`), verified mathlib-absent before the run, proved directly by the swarm with the statement-binding obligation satisfied — Phase 2's exit metric (#133)
- Phase-2 target run `phase2-run-001` (`docs/metrics/phase2-run-001.{md,json}`): direct-proof path, decomposition available but not needed, binding held (#134)

## [1.1.0] - 2026-06-10

### Added

- Phase-1 rerun baseline `phase1-run-002` (post-cache-fix): merge_rate 0.889 (↑ from 0.6), 0 prove failures, 0 gate-a failures, goal-level close rate 1.0
- Gate A binding red-team round 002 (`docs/metrics/gate-a-redteam-002.md`): 3/3 vacuity attacks blocked by the statement-binding gate, honest control passes

### Added

- Phase-2 Stage D — statement-binding gate (ADR-011, SPEC-011-A): Gate A now regenerates, for every proved goal, a kernel obligation `theorem <name>_binding_check : <∀-goal-type> := <name>` and builds it under `--wfail`, so a proof of a weakened or vacuous statement under the goal's name (the #64 class) fails to inhabit the goal type and goes red. Non-bypassable (Gate A controls generation, not the contributor); covers decomposition sub-lemmas. `tools/lean_sig.py` extracted (shared Lean-signature parsing); 6 new tests


### Added

- Phase-2 Stage C — goal decomposition (ADR-009, SPEC-009-A): on prove-budget exhaustion the agent drives `claude` to split the parent into 2-8 sub-lemma goals (typed `Post⊆Pre` edges, depth ≤3), requeues them as `open` prove goals, and parks the parent `blocked`; an unblock sweep re-opens a parent once all its subs are proved. Soundness unchanged — the parent still closes only through Gate A. Gate B gains acyclicity + strictly-smaller guardrails; 3 new agent self-tests + 3 Gate B tests. ADR-009 Accepted


### Added

- Phase-2 Stage B — affinity-weighted, gap-based goal selection (ADR-010, SPEC-010-A): selection now ranks claimable goals by (affinity desc, gap asc, id asc), skipping below-τ_v patterns; +1 affinity on a merge (folded into the prove PR), -10 on a failed attempt (a gated demote PR); affinity is an advisory `aff` field on goal records that degrades to 0 on absence/garbage. 5 new agent self-tests (24 total). ADR-010 Accepted
- Phase-2 plan (proposed): [`docs/proposals/phase2-plan.md`](docs/proposals/phase2-plan.md), candidate-target shortlist [`docs/phase2-targets.md`](docs/phase2-targets.md), and three ADRs — ADR-009 (goal decomposition on prove-budget exhaustion), ADR-010 (affinity-weighted gap-based selection), ADR-011 (statement-binding gate, closing the meaningfulness gap the W3 red team exposed)
- README: "Why this matters" and "The goal, honestly" — the purpose, value, and honest limits of the work, with Phase-2 links


## [1.0.0] - 2026-06-10

### Added

- Contributor-readiness checklist evidence (`docs/metrics/checklist-evidence.md`): all six items (a)–(f) adversarially verified `sufficient` at high confidence; the public contributor invitation opens (#79)
- README quickstart verified to run clean from a fresh clone (checklist item (f))


## [0.6.0] - 2026-06-10

### Added

- Phase-1 swarm run 001 (W4): 3 prover agents drove `claude` to write real Lean proofs; 3 theorems proved and merged into the verified library by a non-author agent (`prover-alpha`) end-to-end; metrics at `docs/metrics/phase1-run-001.{md,json}` (#75)
- First merged proofs: `int_add_neg_thm`, `int_neg_neg_thm`, `and_comm_imp_thm` in `library/Unsorry/`

### Fixed

- Prove cycle recompiled mathlib from source: the PR worktree has no `.lake`, so verification rebuilt all of mathlib and blew the attempt budget (phase1-run-001). `run_proof` now restores the prebuilt cache (`lake exe cache get`, best-effort) in the worktree before the first build (SPEC-007-A)

### Added

- Phase-1 backlog: 20 known-true prove-phase goals (`goals/*.aisp` + statement `.lean` files carrying `sorry`) spanning Nat/Int algebra, order, divisibility, gcd, parity, list and propositional facts; minimal imports, all type-check, all audit clean under `--allow-sorry`

## [0.5.0] - 2026-06-10

### Added

- Gate A red-team round 001 (W3): 9 adversarial bypass vectors as real PRs (#56–#64); 9/9 blocked after the autoImplicit fix. Evidence at `docs/metrics/gate-a-redteam-001.md` — checklist item (a)

### Fixed

- Gate A autoImplicit bypass found by the W3 red team (PR #64): a `set_option autoImplicit true` split across lines defeated the per-line diff lint and let a vacuous (sound-but-meaningless) theorem into `library/`. New authoritative whole-file, whitespace-collapsed check `tools/gate_a/check_library_options.py` (12 tests) — `autoImplicit`/`relaxedAutoImplicit` re-enables in the verified library now fail Gate A regardless of source formatting (SPEC-006-B)

## [0.4.0] - 2026-06-10

### Added

- Lean 4 project: `lean-toolchain` pinned to `leanprover/lean4:v4.30.0`, `lakefile.toml` with two packages — `UnsorryLibrary` (verified, zero-sorry) and `UnsorryGoals` (sorries expected) — mathlib required at release tag `v4.30.0`, manifest committed (ADR-002, ADR-006)
- First verified lemma `nat_zero_lt_succ` with content-addressed index entry `library/index/4c71a8b4….aisp` (goal `nat-zero-lt-succ`)
- ADR-006 Gate A Soundness Enforcement; SPEC-006-A (axiom audit executable), SPEC-006-B (gate-a workflow)
- `lake exe axiom_audit` — per-declaration transitive axiom audit (whitelist `propext`/`Classical.choice`/`Quot.sound`, `--allow-sorry` for goals); `AuditFixtures` adversarial lib + 16-assertion acceptance script `tools/gate_a/test_audit.sh`
- **Gate A live**: `gate-a.yml` (always-report detect job; lean-action mathlib cache; `--wfail` library build; axiom audit; leanchecker kernel replay; audit self-test; textual lint belt; axiom-footprint artifact + sticky PR comment) — required status check on `main` alongside `gate-b` (ADR-005, ADR-006, SPEC-006-B)

## [0.3.0] - 2026-06-10

### Added

- Phase-0 swarm trial run 001: four agent identities on two models, 39 claim cycles, 38 autonomous PR merges, TTL reap observed; metrics + evidence at `docs/metrics/phase0-run-001.{md,json}` (#47)
- `docs/metrics/METRICS.md` — metric definitions and run index

### Fixed

- Translation convergence race under overlapping PRs — convergence sweep, SPEC-007-A step 1b (#8)
- Fidelity normalizer false positives on redundant parentheses — normalization step 5; both trial flags adjudicated equivalent and resolved (#50)

### Changed

- All 10 Phase-0 backlog goals now `translated`; all 3 planted paraphrase pairs converged to byte-equal content addresses
- README roadmap: Phase 0 ticked with metrics link

## [0.2.0] - 2026-06-10

### Added

- `tools/gate_b/` — in-repo Gate B validator (GB001–GB018), CI workflow `gate-b.yml` (required job + advisory upstream aisp-validator job)
- `tools/gate_b/reaper.py` + `reaper.yml` — expired-claim reaper on a 15-min cron against the orphan `claims` branch
- `tools/fidelity/` — statement normalizer (NFC, canonical symbols, α-rename) + differ; content-address shas
- `swarm/agent.sh` — Phase-0 translation-only agent loop (ADR-007, SPEC-007-A)
- `swarm/prompts/translate.md` — one-shot translation prompt with pinned symbol palette
- `backlog/` seeded with 10 known-true statements (3 planted paraphrase pairs + 4 singletons) and matching `goals/` records
- ADR-007 Agent Identity and Budgets; SPEC-007-A Agent Loop Script
- Orphan `claims` branch created (ADR-004)

- `swarm/protocol.aisp` — the swarm contract (validates ◊⁺⁺ Platinum with aisp-validator 0.3.0); SPEC-003-D
- `swarm/AI_GUIDE.md` — AISP 5.1 grammar vendored from bar181/aisp-open-core (MIT, attribution: Bradley Ross)
- Record schemas: goal (SPEC-003-A), claim (SPEC-003-B), translation + decomposition + normalization/content-addressing (SPEC-003-C), claim lifecycle + reaper (SPEC-004-A)
- `claims/README.md` — pointer to the claims-branch mechanism (ADR-004)
- Gate B fixture corpus under `tools/gate_b/tests/fixtures/` (valid trees + 12 violation trees, TDD seed for the validator)

## [0.1.0] - 2026-06-10

### Added

- Vendored development protocols at `docs/protocols.md` (from [cgbarlow/protocols](https://github.com/cgbarlow/protocols)), adopted as binding (ADR-001)
- ADR-001 — Adopt Development Protocols
- ADR-002 — Lean 4 + mathlib4 Pinned to Release Tags
- ADR-003 — AISP Coordination Format with In-Repo Validation
- ADR-004 — Claims on a Dedicated Branch, First-Push-Wins
- ADR-005 — Autonomous Merge Policy
- `CLAUDE.md` development guide
- This changelog
