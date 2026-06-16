import Mathlib

set_option maxRecDepth 8000 in
set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_eighty_mem (n : ℕ) : n ^ 4 % 80 = 0 ∨ n ^ 4 % 80 = 1 ∨ n ^ 4 % 80 = 16 ∨ n ^ 4 % 80 = 65 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 80 < 80 := Nat.mod_lt n (by norm_num); interval_cases (n % 80) <;> decide)
    | (have h : n % 80 < 80 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 80) <;> decide)
    | (have h : n % 80 < 80 := Nat.mod_lt n (by norm_num); interval_cases (n % 80) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 80 < 80 := Nat.mod_lt n (by norm_num); interval_cases (n % 80) <;> omega)
