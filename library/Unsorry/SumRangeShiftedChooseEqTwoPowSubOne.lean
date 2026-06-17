import Mathlib.Data.Nat.Choose.Sum

/-!
# Sum of shifted binomial coefficients over a range

This module proves that the sum of `(n + 1).choose (k + 1)` for `k` ranging over
`Finset.range (n + 1)` equals `2 ^ (n + 1) - 1`.
-/

theorem sum_range_shifted_choose_eq_two_pow_sub_one (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (n + 1).choose (k + 1) = 2 ^ (n + 1) - 1 := by
  have h := Nat.sum_range_choose (n + 1)
  rw [Finset.sum_range_succ' (fun i => (n + 1).choose i) (n + 1)] at h
  simp only [Nat.choose_zero_right] at h
  omega
