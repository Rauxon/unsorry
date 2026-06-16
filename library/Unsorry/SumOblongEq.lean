import Mathlib

theorem sum_oblong_eq (n : ℕ) : 3 * ∑ k ∈ Finset.range n, ((k : ℤ) * (k + 1)) = (n - 1) * n * (n + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring