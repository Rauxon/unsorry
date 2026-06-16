import Mathlib

theorem sum_even_cubes_eq_twice_square (n : ℕ) : ∑ k ∈ Finset.range (n + 1), (2 * k) ^ 3 = 2 * n ^ 2 * (n + 1) ^ 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    ring
