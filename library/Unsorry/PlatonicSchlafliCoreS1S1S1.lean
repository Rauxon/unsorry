import Mathlib.Algebra.Order.Ring.Rat
import Mathlib.Data.Nat.Cast.Order.Basic

/-!
# `nat_cast_le_rat_of_le` (goal `platonic-schlafli-core-s1-s1-s1`)

Casting natural numbers into `ℚ` preserves `≤`: the cast is an order
embedding (`Nat.cast_le`), since `ℚ` is an ordered semiring of
characteristic zero.
-/

theorem nat_cast_le_rat_of_le (m n : ℕ) : m ≤ n → (m : ℚ) ≤ (n : ℚ) :=
  fun h => Nat.cast_le.mpr h
