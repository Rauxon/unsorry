import Mathlib

theorem sum_k_mul_succ_sq_closed_form (n : ℕ) : 12 * ∑ k ∈ Finset.range (n + 1), k * (k + 1) ^ 2 = n * (n + 1) * (n + 2) * (3 * n + 5) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ]
    ring_nf
    ring_nf at ih
    nlinarith [ih]