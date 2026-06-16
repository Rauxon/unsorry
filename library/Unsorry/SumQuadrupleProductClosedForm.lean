import Mathlib

theorem sum_quadruple_product_closed_form (n : ℕ) : 5 * ∑ k ∈ Finset.range (n + 1), k * (k + 1) * (k + 2) * (k + 3) = n * (n + 1) * (n + 2) * (n + 3) * (n + 4) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring