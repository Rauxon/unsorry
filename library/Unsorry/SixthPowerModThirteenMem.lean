import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sixth_power_mod_thirteen_mem (n : ℕ) : n ^ 6 % 13 = 0 ∨ n ^ 6 % 13 = 1 ∨ n ^ 6 % 13 = 12 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 13 < 13 := Nat.mod_lt n (by norm_num); interval_cases (n % 13) <;> decide)
    | (have h : n % 13 < 13 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 13) <;> decide)
    | (have h : n % 13 < 13 := Nat.mod_lt n (by norm_num); interval_cases (n % 13) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 13 < 13 := Nat.mod_lt n (by norm_num); interval_cases (n % 13) <;> omega)
