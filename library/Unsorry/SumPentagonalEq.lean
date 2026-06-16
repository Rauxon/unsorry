import Mathlib

theorem sum_pentagonal_eq (n : ℕ) : ∑ k ∈ Finset.range n, ((k : ℤ) * (3 * k - 1)) = (n - 1) ^ 2 * n := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring