import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_ten_mem (n : ℕ) : n ^ 4 % 10 = 0 ∨ n ^ 4 % 10 = 1 ∨ n ^ 4 % 10 = 5 ∨ n ^ 4 % 10 = 6 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 10) <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 10 < 10 := Nat.mod_lt n (by norm_num); interval_cases (n % 10) <;> omega)
