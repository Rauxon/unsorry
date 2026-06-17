import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# Sum of `multichoose 2` over a range

This module proves that summing `Nat.multichoose 2 j` for `j` ranging over
`Finset.range (m + 1)` equals `Nat.choose (m + 2) 2`.

Since `Nat.multichoose 2 j = j + 1`, the left-hand side is the Gauss sum
`1 + 2 + ⋯ + (m + 1)`, which equals the triangular number `(m + 2).choose 2`.
-/

open Finset

theorem sum_range_multichoose_two_eq_choose_succ_two (m : ℕ) :
    ∑ j ∈ Finset.range (m + 1), Nat.multichoose 2 j = Nat.choose (m + 2) 2 := by
  induction m with
  | zero => rw [Finset.sum_range_one, Nat.multichoose_two]; decide
  | succ m ih =>
    rw [Finset.sum_range_succ, ih, Nat.multichoose_two]
    have h : (m + 1 + 2).choose 2 = (m + 2) + (m + 2).choose 2 := by
      change ((m + 2) + 1).choose (1 + 1) = _
      rw [Nat.choose_succ_succ', Nat.choose_one_right]
    rw [h]
    omega
