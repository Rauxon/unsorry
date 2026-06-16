import Mathlib.Data.Nat.ModEq
import Mathlib.Tactic.IntervalCases

theorem sq_mod_five_ne_two_three (n : ℕ) : n ^ 2 % 5 ≠ 2 ∧ n ^ 2 % 5 ≠ 3 := by
  have hlt : n % 5 < 5 := Nat.mod_lt _ (by norm_num)
  have hmod : n ^ 2 % 5 = (n % 5) ^ 2 % 5 := ((Nat.mod_modEq n 5).pow 2).symm
  constructor
  · rw [hmod]
    interval_cases (n % 5) <;> decide
  · rw [hmod]
    interval_cases (n % 5) <;> decide
