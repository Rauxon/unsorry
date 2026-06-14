import Mathlib.Data.Nat.Basic
import Mathlib.Algebra.BigOperators.Intervals

open Finset

theorem sum_range_pentagonal_closed_form (n : ℕ) :
    2 * (∑ k ∈ range (n + 1), (3 * k^2 - k) / 2) = n^2 * (n + 1) := by
  sorry
