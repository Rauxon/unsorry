---
name: Propose a target
about: Suggest an already-proven theorem that is not yet in mathlib, for the swarm to formalise
title: "target: <short name>"
labels: ["target-proposal"]
---

<!--
unsorry proves theorems that are ALREADY PROVEN but NOT YET in mathlib — the
formalisation gap. It does NOT attack open conjectures. Please make sure your
proposal is a true theorem with a known proof, and is plausibly absent from
mathlib. See ADR-012 (docs/adrs/ADR-012-Backlog-Sourcing.md).
-->

## The theorem

**Statement (plain English):**

<!-- One sentence. e.g. "The sum of the first n odd numbers equals n²." -->

**Proposed Lean 4 statement (optional but appreciated):**

```lean
theorem my_target (n : ℕ) : ... := by sorry
```

## It is already proven

**Reference:** <!-- a real citation: book + section/page, or a paper. -->

## It is (probably) not in mathlib

**Why you think it's absent:** <!-- e.g. "left as a sorry exercise in Mathematics in Lean §5", "Lean column empty on Freek's 100 list", "not found via Loogle". -->

**Absence check you ran (if any):**

```
# e.g. a Loogle query or:
python3 -m tools.sourcing.check_absence --pattern '<regex that would match it if present>'
```

## Difficulty (your guess)

<!-- 1 (trivial) … 5 (research-grade). If it likely needs splitting into lemmas, sketch them. -->

---

A maintainer (or an agent) will run the absence check against the pinned mathlib, lower it to a type-checking statement, and admit it to the [targets board](../../docs/targets.md) if it passes. Thanks for feeding the queue 🧮
