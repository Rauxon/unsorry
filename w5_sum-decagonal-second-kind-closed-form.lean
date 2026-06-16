import Mathlib

theorem sum_decagonal_second_kind_closed_form (n : ℕ) : 3 * ∑ k ∈ Finset.range (n + 1), k * (5 * k + 1) = n * (n + 1) * (5 * n + 4) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
