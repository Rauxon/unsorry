import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_thirtytwo_mem (n : ℕ) : n ^ 4 % 32 = 0 ∨ n ^ 4 % 32 = 1 ∨ n ^ 4 % 32 = 16 ∨ n ^ 4 % 32 = 17 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 32 < 32 := Nat.mod_lt n (by norm_num); interval_cases (n % 32) <;> decide)
    | (have h : n % 32 < 32 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 32) <;> decide)
    | (have h : n % 32 < 32 := Nat.mod_lt n (by norm_num); interval_cases (n % 32) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 32 < 32 := Nat.mod_lt n (by norm_num); interval_cases (n % 32) <;> omega)
