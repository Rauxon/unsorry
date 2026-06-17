import Mathlib

/-!
# A signed binomial sum vanishes

This module proves that the sum over `k = 0, …, n` of `(2k - n) * C(n, k)` is zero.

The proof is by the reflection symmetry `k ↦ n - k`: under this involution the
binomial coefficient is fixed (`C(n, n - k) = C(n, k)`) while the linear factor
`2k - n` flips sign. Hence the sum equals its own negation and must vanish.
-/

open Finset

theorem sum_range_disp_mul_choose_eq_zero (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (2 * (k : ℤ) - n) * (n.choose k : ℤ) = 0 := by
  have h : ∑ k ∈ Finset.range (n + 1), (2 * (k : ℤ) - n) * (n.choose k : ℤ)
      = ∑ j ∈ Finset.range (n + 1), -((2 * (j : ℤ) - n) * (n.choose j : ℤ)) := by
    rw [← Finset.sum_range_reflect
      (fun k => (2 * (k : ℤ) - n) * (n.choose k : ℤ)) (n + 1)]
    apply Finset.sum_congr rfl
    intro j hj
    rw [Finset.mem_range, Nat.lt_succ_iff] at hj
    have hidx : n + 1 - 1 - j = n - j := by omega
    simp only [hidx]
    rw [Nat.choose_symm hj, Nat.cast_sub hj]
    ring
  rw [Finset.sum_neg_distrib] at h
  linarith
