# Candidate backlog (Identity Engine — ADR-043 / SPEC-043-A)

This directory stages **vetted-but-not-yet-sourced** candidates for the Identity Engine
(#400). One file per theme (`<theme>.md`). Each entry has already passed the two cheap
gates — **absence** (no name/content match in pinned mathlib) and **non-triviality**
(ADR-035 battery) — but **not** the expensive ones (the intended proof compiling under
`lake env lean`, and the adversarial skeptic pass). Promotion to a real goal triple
(`goals/<slug>.{lean,aisp}` + `backlog/<slug>.md`) runs those last gates.

This is the "next 200–300 planned" half of the program's `/goal`: a reviewable, auditable
pipeline of work without paying the build cost up front.

## Entry format

```
- [ ] `snake_name` — one-line statement in words
      absence: no-local-match · triviality: non-trivial · intended: <tactic sketch> · conf: high|med
```

- `[ ]` → `[x]` when the candidate is promoted and the goal lands on `main`.
- `conf` is the miner's confidence that the intended proof will compile (the gate that
  most often fails); `med` entries are expected to have a higher drop rate on promotion.

Gate B does **not** validate this directory (same as `backlog/*.md`), so entries add no
schema churn. `docs/plans/identity-engine.md` aggregates the checkbox counts.
