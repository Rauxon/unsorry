import Mathlib

theorem sum_octagonal_eq (n : ℕ) : 2 * ∑ k ∈ Finset.range n, ((k : ℤ) * (3 * k - 2)) = (n - 1) * n * (2 * n - 3) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring