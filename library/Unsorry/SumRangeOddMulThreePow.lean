import Mathlib

theorem sum_range_odd_mul_three_pow (n : ℕ) : (∑ i ∈ Finset.range n, (2 * i + 1) * 3 ^ i) + 3 ^ n = n * 3 ^ n + 1 := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, pow_succ]
    ring_nf
    ring_nf at ih
    omega