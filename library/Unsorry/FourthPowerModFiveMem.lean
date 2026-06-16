import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_five_mem (n : ℕ) : n ^ 4 % 5 = 0 ∨ n ^ 4 % 5 = 1 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 5 < 5 := Nat.mod_lt n (by norm_num); interval_cases (n % 5) <;> decide)
    | (have h : n % 5 < 5 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 5) <;> decide)
    | (have h : n % 5 < 5 := Nat.mod_lt n (by norm_num); interval_cases (n % 5) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 5 < 5 := Nat.mod_lt n (by norm_num); interval_cases (n % 5) <;> omega)
