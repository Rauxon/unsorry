import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fifth_power_mod_twentytwo_mem (n : ℕ) : n ^ 5 % 22 = 0 ∨ n ^ 5 % 22 = 1 ∨ n ^ 5 % 22 = 10 ∨ n ^ 5 % 22 = 11 ∨ n ^ 5 % 22 = 12 ∨ n ^ 5 % 22 = 21 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 22 < 22 := Nat.mod_lt n (by norm_num); interval_cases (n % 22) <;> decide)
    | (have h : n % 22 < 22 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 22) <;> decide)
    | (have h : n % 22 < 22 := Nat.mod_lt n (by norm_num); interval_cases (n % 22) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 22 < 22 := Nat.mod_lt n (by norm_num); interval_cases (n % 22) <;> omega)
