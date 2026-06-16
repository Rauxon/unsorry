import Mathlib

theorem sum_icc_four_div_three_consec_odd_telescope (n : ℕ) :
    ∑ k ∈ Finset.Icc 1 n,
      (4 : ℝ) / (((2 * k - 1 : ℝ)) * (2 * k + 1) * (2 * k + 3)) =
      1 / 3 - 1 / ((2 * n + 1) * (2 * n + 3)) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_Icc_succ_top (by omega : 1 ≤ m + 1), ih]
    push_cast
    have h1 : ((2 : ℝ) * ((m : ℝ) + 1) - 1) = 2 * m + 1 := by ring
    rw [h1]
    have hm1 : (2 : ℝ) * (m : ℝ) + 1 > 0 := by positivity
    have hm3 : (2 : ℝ) * (m : ℝ) + 3 > 0 := by positivity
    have hm5 : (2 : ℝ) * ((m : ℝ) + 1) + 3 > 0 := by positivity
    field_simp
    ring