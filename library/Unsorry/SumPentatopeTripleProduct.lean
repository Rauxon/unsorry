import Mathlib

theorem sum_pentatope_triple_product (n : ℕ) : 4 * ∑ k ∈ Finset.range (n + 1), k * (k + 1) * (k + 2) = n * (n + 1) * (n + 2) * (n + 3) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, Nat.mul_add, ih]
    ring