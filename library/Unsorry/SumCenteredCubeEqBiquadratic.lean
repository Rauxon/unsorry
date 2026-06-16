import Mathlib

theorem sum_centered_cube_eq_biquadratic (n : ℕ) : 2 * ∑ k ∈ Finset.range n, (k ^ 3 + (k + 1) ^ 3) = n ^ 2 * (n ^ 2 + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring
