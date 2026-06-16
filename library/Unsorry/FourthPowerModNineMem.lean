import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_nine_mem (n : ℕ) : n ^ 4 % 9 = 0 ∨ n ^ 4 % 9 = 1 ∨ n ^ 4 % 9 = 4 ∨ n ^ 4 % 9 = 7 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 9 < 9 := Nat.mod_lt n (by norm_num); interval_cases (n % 9) <;> decide)
    | (have h : n % 9 < 9 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 9) <;> decide)
    | (have h : n % 9 < 9 := Nat.mod_lt n (by norm_num); interval_cases (n % 9) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 9 < 9 := Nat.mod_lt n (by norm_num); interval_cases (n % 9) <;> omega)
