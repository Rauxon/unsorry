import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

/-- The partial sums of `k / (k+1)!` telescope to `1 - 1 / n!`. -/
theorem sum_range_k_div_succ_factorial_eq (n : ℕ) :
    ∑ k ∈ Finset.range n, (k : ℚ) / (Nat.factorial (k + 1) : ℚ)
      = 1 - 1 / (Nat.factorial n : ℚ) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih, Nat.factorial_succ]
    have hn : (Nat.factorial n : ℚ) ≠ 0 := by
      exact_mod_cast (Nat.factorial_pos n).ne'
    have hn1 : (n : ℚ) + 1 ≠ 0 := by positivity
    push_cast
    field_simp
    ring
