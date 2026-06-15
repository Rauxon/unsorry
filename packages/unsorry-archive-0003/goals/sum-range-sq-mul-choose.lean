import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Intervals

open Finset

theorem sum_range_sq_mul_choose (n : ℕ) :
    4 * (∑ k ∈ range (n + 1), k^2 * n.choose k) = n * (n + 1) * 2^n := by
  sorry
