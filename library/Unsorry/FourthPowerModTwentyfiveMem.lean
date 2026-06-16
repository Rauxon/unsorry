import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_twentyfive_mem (n : ℕ) : n ^ 4 % 25 = 0 ∨ n ^ 4 % 25 = 1 ∨ n ^ 4 % 25 = 6 ∨ n ^ 4 % 25 = 11 ∨ n ^ 4 % 25 = 16 ∨ n ^ 4 % 25 = 21 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 25 < 25 := Nat.mod_lt n (by norm_num); interval_cases (n % 25) <;> decide)
    | (have h : n % 25 < 25 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 25) <;> decide)
    | (have h : n % 25 < 25 := Nat.mod_lt n (by norm_num); interval_cases (n % 25) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 25 < 25 := Nat.mod_lt n (by norm_num); interval_cases (n % 25) <;> omega)
