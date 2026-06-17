import Mathlib.Data.Nat.Fib.Basic
import Mathlib.Algebra.BigOperators.Group.Finset.Basic

/-!
# Sum of a shifted Lucas-style Fibonacci pairing over an initial range

This module proves a closed form for the partial sums of the sequence
`Nat.fib i + Nat.fib (i + 2)` over `Finset.range n`.
-/

theorem sum_range_lucas_shift_nat (n : ℕ) :
    ∑ i ∈ Finset.range n, (Nat.fib i + Nat.fib (i + 2)) = Nat.fib (n + 1) + Nat.fib (n + 3) - 3 := by
  induction n with
  | zero => simp only [Finset.sum_range_zero]; decide
  | succ k ih =>
    rw [Finset.sum_range_succ, ih]
    show Nat.fib (k + 1) + Nat.fib (k + 3) - 3 + (Nat.fib k + Nat.fib (k + 2))
        = Nat.fib (k + 2) + Nat.fib (k + 4) - 3
    have h1 : Nat.fib (k + 2) = Nat.fib k + Nat.fib (k + 1) := Nat.fib_add_two
    have h2 : Nat.fib (k + 3) = Nat.fib (k + 1) + Nat.fib (k + 2) := Nat.fib_add_two (n := k + 1)
    have h3 : Nat.fib (k + 4) = Nat.fib (k + 2) + Nat.fib (k + 3) := Nat.fib_add_two (n := k + 2)
    have hb : 0 < Nat.fib (k + 1) := Nat.fib_pos.mpr (Nat.succ_pos k)
    omega
