import Mathlib

theorem sum_range_id_mul_three_pow (n : ℕ) : 4 * (∑ i ∈ Finset.range n, i * 3 ^ i) + 3 ^ (n + 1) = 2 * n * 3 ^ n + 3 := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ]
    ring_nf
    ring_nf at ih
    nlinarith [ih, pow_succ 3 k]