# nicomachus-sum-cubes

Nicomachus's theorem: the sum of the first n cubes equals the square of the sum
of the first n naturals. For every natural number n,
∑_{k<n} k³ = (∑_{k<n} k)².

This identity is not a named lemma in mathlib (verified against the pinned
mathlib v4.30.0: only the general Bernoulli power-sum `sum_range_pow` exists,
a different statement). It is the first Phase-2 target (ADR-009/010/011).
