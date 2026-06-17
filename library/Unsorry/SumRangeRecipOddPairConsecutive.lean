import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Positivity

/-- The telescoping sum `∑_{k<n} 1/((2k+1)(2k+3)) = n/(2n+1)`. -/
theorem sum_range_recip_odd_pair_consecutive (n : ℕ) :
    ∑ k ∈ Finset.range n, (1 : ℚ) / ((2 * (k : ℚ) + 1) * (2 * (k : ℚ) + 3)) =
      (n : ℚ) / (2 * (n : ℚ) + 1) := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (2 * (m : ℚ) + 1) ≠ 0 := by positivity
    have h2 : (2 * (m : ℚ) + 3) ≠ 0 := by positivity
    push_cast
    field_simp
    ring
