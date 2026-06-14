# nicomachus-sum-cubes

Nicomachus's theorem: the sum of the first n cubes equals the square of the sum
of the first n naturals. For every natural number n,
∑_{k<n} k³ = (∑_{k<n} k)².

This identity is not a named lemma in mathlib (verified against the pinned
mathlib v4.30.0: only the general Bernoulli power-sum `sum_range_pow` exists,
a different statement). It is the first Phase-2 target (ADR-009/010/011).

- **Source:** Phase-2 seeded target (pre-ADR-012)
- **Reference:** Nicomachus of Gerasa, *Introduction to Arithmetic* II.20; left as a reader exercise in *Mathematics in Lean* §5
- **Absence:** machine-checked no-local-match (verified against pinned mathlib v4.30.0, 2026-06-10: only the general Bernoulli `sum_range_pow` exists — a different statement); normalized to the ADR-012 field format 2026-06-12, evidence unchanged
- **Difficulty:** 3
