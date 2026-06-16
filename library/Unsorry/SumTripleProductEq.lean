import Mathlib

theorem sum_triple_product_eq (n : ℕ) : 4 * ∑ k ∈ Finset.range n, ((k : ℤ) * (k + 1) * (k + 2)) = (n - 1) * n * (n + 1) * (n + 2) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring