import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Nat.Factorial.Basic

/-!
# Telescoping sum of `k * k!`

We prove that `(∑ k ∈ Finset.range n, k * k!) + 1 = n!`.

The key step is the telescoping identity `k * k! = (k+1)! - k!`, which makes the
partial sum collapse; equivalently, the inductive step uses
`(n + 1)! = (n + 1) * n! = n! + n * n!`.
-/

open Finset

theorem sum_range_k_mul_factorial_succ (n : ℕ) :
    (∑ k ∈ Finset.range n, k * k.factorial) + 1 = n.factorial := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, Nat.factorial_succ]
    -- `(∑ k ∈ range n, k * k!) + n * n! + 1 = (n + 1) * n!`
    rw [add_right_comm, ih, Nat.succ_mul, Nat.add_comm]
