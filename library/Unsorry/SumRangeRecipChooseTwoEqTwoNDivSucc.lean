import Mathlib

/-!
# Telescoping sum of reciprocal triangular numbers

This module proves that the partial sums of the reciprocals of the binomial
coefficients `(k + 2).choose 2` telescope to `2 * n / (n + 1)`.
-/

open Finset

theorem sum_range_recip_choose_two_eq_two_n_div_succ (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 / ((k + 2).choose 2 : ℚ)) = 2 * n / (n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have hchoose : (((m + 2).choose 2 : ℕ) : ℚ) = (m + 1) * (m + 2) / 2 := by
      rw [Nat.cast_choose_two]
      push_cast
      ring
    rw [hchoose]
    have h1 : (m : ℚ) + 1 ≠ 0 := by positivity
    have h2 : (m : ℚ) + 2 ≠ 0 := by positivity
    push_cast
    field_simp
    ring
