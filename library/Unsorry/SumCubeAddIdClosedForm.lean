import Mathlib

theorem sum_cube_add_id_closed_form (n : ℕ) : 4 * ∑ k ∈ Finset.range (n + 1), (k ^ 3 + k) = n * (n + 1) * (n ^ 2 + n + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring