import Mathlib

open Finset
theorem sum_four_consecutive_eq_hyper_tetrahedral (n : ℕ) : 5 * ∑ k ∈ Finset.range n, (k + 1) * (k + 2) * (k + 3) * (k + 4) = n * (n + 1) * (n + 2) * (n + 3) * (n + 4) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring