import Mathlib

open Finset
theorem sum_icc_k_div_three_shifted_consecutive_telescope (n : ℕ) :
    ∑ k ∈ Icc 1 n, (k : ℝ) / ((k + 1) * (k + 2) * (k + 3))
      = 1 / 4 + 1 / (2 * (n + 2)) - 3 / (2 * (n + 3)) := by
  induction n with
  | zero => norm_num
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    push_cast
    have h1 : (m : ℝ) + 2 ≠ 0 := by positivity
    have h2 : (m : ℝ) + 3 ≠ 0 := by positivity
    have h3 : (m : ℝ) + 1 + 1 ≠ 0 := by positivity
    have h4 : (m : ℝ) + 1 + 2 ≠ 0 := by positivity
    have h5 : (m : ℝ) + 1 + 3 ≠ 0 := by positivity
    field_simp
    ring