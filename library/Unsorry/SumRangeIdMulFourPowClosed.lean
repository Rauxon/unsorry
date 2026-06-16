import Mathlib

theorem sum_range_id_mul_four_pow_closed (n : ℕ) : 9 * ∑ k ∈ Finset.range n, (k : ℤ) * 4 ^ k = (3 * (n : ℤ) - 4) * 4 ^ n + 4 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, mul_add, ih]
    push_cast
    ring