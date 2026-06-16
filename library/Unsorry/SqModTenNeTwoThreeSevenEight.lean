import Mathlib

/-- The last decimal digit of a perfect square is never 2, 3, 7, or 8. -/
theorem sq_mod_ten_ne_two_three_seven_eight (n : ℕ) :
    n ^ 2 % 10 ≠ 2 ∧ n ^ 2 % 10 ≠ 3 ∧ n ^ 2 % 10 ≠ 7 ∧ n ^ 2 % 10 ≠ 8 := by
  have key : n ^ 2 % 10 = (n % 10) ^ 2 % 10 := ((Nat.mod_modEq n 10).pow 2).symm
  rw [key]
  have hlt : n % 10 < 10 := Nat.mod_lt _ (by norm_num)
  interval_cases (n % 10) <;> decide
