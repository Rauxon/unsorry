import Mathlib

theorem sum_quintic_gnomon_eq_fifth_power (n : ℕ) : ∑ k ∈ Finset.range n, (5 * k ^ 4 + 10 * k ^ 3 + 10 * k ^ 2 + 5 * k + 1) = n ^ 5 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    ring
