import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity

/-!
# A telescoping sum of reciprocals of consecutive odd-number products

This module proves a closed form for the partial sums of the series whose
`k`-th term is `1 / ((2k+1)(2k+3))`.  The argument is a direct induction on the
number of terms, with the inductive step reduced to a field identity.
-/

theorem sum_range_recip_odd_pair_consecutive (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 : ℚ) / ((2 * (k : ℚ) + 1) * (2 * (k : ℚ) + 3))
      = (n : ℚ) / (2 * (n : ℚ) + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (2 * (m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : (2 * (m : ℚ) + 3) ≠ 0 := by positivity
    push_cast
    field_simp
    ring
