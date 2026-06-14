# SPEC-043-A: The Identity Engine

Specification for **ADR-043**. Defines the sourcing pipeline, the candidate-backlog
format, the themes, the `/goal` stop condition, and the tracking/announcing protocol.

## 1. The per-candidate gate pipeline (fail-fast, every drop logged)

A *candidate* is `{slug, name, statement, intended_proof, opens, difficulty, theme}`.
It becomes a sourced goal triple only after passing, **in order**:

1. **Absence** — `python3 -m tools.sourcing.check_absence --pattern <regex>` over the
   pinned mathlib (`c5ea00351c…`). Exit 0 = absent. A content-regex match is
   investigated (often a false positive on an unrelated line); a genuine named match
   drops the candidate.
2. **Non-triviality (ADR-035)** — `python3 -m tools.sourcing.check_triviality
   goals/<slug>.lean`. Verdict must be `non-trivial` (battery `rfl, trivial, decide,
   norm_num, omega, simp, simp_all, aesop, ring, linarith, tauto` does not close it;
   `nlinarith/positivity/field_simp/gcongr` are deliberately **not** in the battery, so
   SOS inequalities reliably survive). `trivial` or `probe-error` drops it.
3. **Provable** — the *intended proof* compiles under `lake env lean /tmp/scratch.lean`
   (cwd = repo root, `import Mathlib`). A non-compiling proof drops the candidate. This
   gate has historically caught false candidates (off-by-one closed forms, sign-wrong
   identities) — it is mandatory and **pre-source**.
4. **Adversarial skeptic** — at least one independent agent argues the statement is a
   disguised special case of a named mathlib lemma *or* that the proof proves something
   weaker than the prose; a finding must be backed by a re-runnable check (a mathlib
   lemma name fed back into gate 1/2). Upheld → accept; otherwise drop.

Then **write the triple** (gate 5) and run `python3 -m tools.gate_b validate .` once per
batch (barrier). Across candidates the gates fan out in parallel; within a candidate they
are a strict fail-fast pipeline (cheap checks first). `check_triviality` uses a private
`TemporaryDirectory`, so parallel probes are safe.

## 2. The goal triple (canonical shape)

Identical to every existing target:
- `goals/<slug>.lean` — `import Mathlib` + `theorem <snake_name> <sig> := by\n  sorry`
- `goals/<slug>.aisp` — `𝔸5.1.goal.<slug>@<date>` … `⟦Ω:Goal⟧{id;phase≜prove;status≜open;
  difficulty}` … `⟦Σ:Source⟧{src≜backlog/<slug>.md}` … `⟦Γ:Deps⟧{deps≜⟨⟩}` …
  `⟦Λ:Artifact⟧{lean≜goals/<slug>.lean;sha≜∅;aff≜-10}` … `⟦Ε⟧⟨δ≜0.60;τ≜◊⁺⟩`
- `backlog/<slug>.md` — English statement + Source/Reference/Absence/Triviality/
  Difficulty/Decomposition-sketch bullets (the decomposition sketch records the verified
  intended proof so the prover swarm has a hint).

Slug ↔ name: kebab ↔ snake (`one-hundred-twenty-dvd-five-consecutive` ↔
`one_hundred_twenty_dvd_five_consecutive`).

## 3. The candidate backlog (the "planned" deliverable)

`backlog/candidates/<theme>.md`, one file per theme, each a checklist of
**vetted-but-not-sourced** candidates that already passed gates 1–2 (absence +
triviality) — promotion adds gates 3–4. Entry format:

```
- [ ] `snake_name` — one-line statement in words
      absence: no-local-match · triviality: non-trivial · intended: <tactic sketch> · conf: high|med
```

A checkbox flips to `[x]` when the candidate is promoted and lands. Gate B does not
validate this directory. `docs/plans/identity-engine.md` aggregates the counts.

## 4. The `/goal` stop condition

> Source in PR-sized batches (8–12). **Do not stop** until **(1) 100 new problems
> SHIPPED** and **(2) ≥200 candidate-backlog entries**.

**Shipped** = sourced triple (gate 5) + verified (gates 1–4) + Gate B clean + **landed
on `origin/main` via a merged PR** + **announced on #81**. "On a branch" ≠ shipped.
Each merged batch is a durable checkpoint; resume by recounting `origin/main`.

Concurrency: the repo is mutated continuously by the prover swarm and other sessions,
so **sync before every batch** (`git fetch origin`; branch off fresh `origin/main`),
dedup at mine-time against live `origin/main` `goals/`, and never source off a stale
local board.

## 5. Tracking & announcing

- **#400** — a single pinned program-status comment, edited in place per batch:
  `Shipped N/100 · Scoped M/200 · mathlib <rev>`, a per-track table, per-theme breakdown,
  last-batch PR link.
- **#81** — one 📣 comment **per merged batch** (mandatory): per-target bullets (slug,
  statement in words, difficulty), the cleared absence + ADR-035 gate, a closing live
  board-count line linking `docs/targets.md` + `CONTRIBUTING.md`.
- **Release** — one `changelog.d/added-identity-engine-400.md` fragment for the program;
  individual goal batches do not need fragments (ADR-040: a single swarm proof does not).
