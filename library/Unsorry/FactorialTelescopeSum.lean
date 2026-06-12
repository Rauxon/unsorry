import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Factorial.Basic
import Mathlib.Tactic.Ring

theorem sum_range_mul_factorial_telescope (n : ℕ) : ∑ i ∈ Finset.range (n + 1), i * Nat.factorial i = Nat.factorial (n + 1) - 1 := by
  induction n with
  | zero => simp
  | succ k ih =>
    have h1 : 1 ≤ Nat.factorial (k + 1) := Nat.factorial_pos (k + 1)
    rw [Finset.sum_range_succ, ih, Nat.factorial_succ (k + 1)]
    have h2 : (k + 1 + 1) * Nat.factorial (k + 1) =
        Nat.factorial (k + 1) + (k + 1) * Nat.factorial (k + 1) := by ring
    rw [h2]
    omega
