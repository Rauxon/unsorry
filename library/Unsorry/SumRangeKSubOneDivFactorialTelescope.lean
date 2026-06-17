import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-- The telescoping sum `∑_{k=1}^{n} (k-1)/k! = 1 - 1/n!` over the reals.

Each term satisfies `(k-1)/k! = 1/(k-1)! - 1/k!`, so the sum collapses by
induction on `n`, with `Finset.sum_Icc_succ_top` peeling off the top term. -/
theorem sum_range_k_sub_one_div_factorial_telescope (n : ℕ) :
    ∑ k ∈ Finset.Icc 1 n, ((k : ℝ) - 1) / k.factorial = 1 - 1 / n.factorial := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_Icc_succ_top (Nat.succ_le_succ (Nat.zero_le n)), ih]
    have h1 : (n.factorial : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
    have h2 : ((n + 1).factorial : ℝ) ≠ 0 :=
      Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero (n + 1))
    rw [Nat.factorial_succ]
    push_cast
    field_simp
    ring
