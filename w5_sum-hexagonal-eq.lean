import Mathlib

theorem sum_hexagonal_eq (n : ℕ) : 6 * ∑ k ∈ Finset.range n, ((k : ℤ) * (2 * k - 1)) = (n - 1) * n * (4 * n - 5) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring
