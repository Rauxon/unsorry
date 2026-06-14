import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Rat.Defs
import Mathlib.Tactic.Positivity

open Finset

theorem prod_range_one_add_inv (n : ℕ) : ∏ k ∈ Finset.Icc 1 n, ((k : ℚ) + 1) / k = (n : ℚ) + 1 := by
  induction n with
  | zero => simp
  | succ n ih =>
    have h1 : 1 ≤ n + 1 := Nat.succ_le_succ (Nat.zero_le n)
    rw [Finset.prod_Icc_succ_top h1]
    rw [ih]
    have h2 : (n + 1 : ℚ) ≠ 0 := by positivity
    push_cast
    have h3 : (n : ℚ) + 1 = (n + 1 : ℚ) := by rfl
    rw [h3]
    rw [mul_comm]
    exact div_mul_cancel₀ _ h2
