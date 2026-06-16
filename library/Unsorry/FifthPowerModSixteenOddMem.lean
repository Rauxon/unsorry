import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fifth_power_mod_sixteen_odd_mem (n : ℕ) : n ^ 5 % 16 = 0 ∨ n ^ 5 % 16 = 1 ∨ n ^ 5 % 16 = 3 ∨ n ^ 5 % 16 = 5 ∨ n ^ 5 % 16 = 7 ∨ n ^ 5 % 16 = 9 ∨ n ^ 5 % 16 = 11 ∨ n ^ 5 % 16 = 13 ∨ n ^ 5 % 16 = 15 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 16 < 16 := Nat.mod_lt n (by norm_num); interval_cases (n % 16) <;> decide)
    | (have h : n % 16 < 16 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 16) <;> decide)
    | (have h : n % 16 < 16 := Nat.mod_lt n (by norm_num); interval_cases (n % 16) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 16 < 16 := Nat.mod_lt n (by norm_num); interval_cases (n % 16) <;> omega)
