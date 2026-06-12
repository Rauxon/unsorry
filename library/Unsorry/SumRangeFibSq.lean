import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Fib.Basic
import Mathlib.Tactic.Ring

theorem sum_range_succ_fib_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), Nat.fib i ^ 2 = Nat.fib n * Nat.fib (n + 1) := by
  induction n with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, ih, Nat.fib_add_two]
    ring
