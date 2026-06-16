import Mathlib

theorem sum_range_id_mul_succ_mul_two_pow_closed (n : ℕ) : ∑ k ∈ Finset.range n, (k : ℤ) * ((k : ℤ) + 1) * 2 ^ k = ((n : ℤ) ^ 2 - 3 * n + 4) * 2 ^ n - 4 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    push_cast
    ring