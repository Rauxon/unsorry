import Mathlib

theorem sum_range_sq_mul_two_pow (n : ℕ) : (∑ k ∈ Finset.range n, (k : ℤ) ^ 2 * 2 ^ k) + 6 = 2 ^ n * ((n : ℤ) ^ 2 - 4 * n + 6) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ]
    push_cast
    push_cast at ih
    ring_nf
    ring_nf at ih
    linarith [ih]