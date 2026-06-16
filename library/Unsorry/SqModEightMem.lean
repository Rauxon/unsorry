import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sq_mod_eight_mem (n : ℕ) : n ^ 2 % 8 = 0 ∨ n ^ 2 % 8 = 1 ∨ n ^ 2 % 8 = 4 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 8 < 8 := Nat.mod_lt n (by norm_num); interval_cases (n % 8) <;> decide)
    | (have h : n % 8 < 8 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 8) <;> decide)
    | (have h : n % 8 < 8 := Nat.mod_lt n (by norm_num); interval_cases (n % 8) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 8 < 8 := Nat.mod_lt n (by norm_num); interval_cases (n % 8) <;> omega)
