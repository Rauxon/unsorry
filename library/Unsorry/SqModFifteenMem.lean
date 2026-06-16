import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sq_mod_fifteen_mem (n : ℕ) : n ^ 2 % 15 = 0 ∨ n ^ 2 % 15 = 1 ∨ n ^ 2 % 15 = 4 ∨ n ^ 2 % 15 = 6 ∨ n ^ 2 % 15 = 9 ∨ n ^ 2 % 15 = 10 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 15 < 15 := Nat.mod_lt n (by norm_num); interval_cases (n % 15) <;> decide)
    | (have h : n % 15 < 15 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 15) <;> decide)
    | (have h : n % 15 < 15 := Nat.mod_lt n (by norm_num); interval_cases (n % 15) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 15 < 15 := Nat.mod_lt n (by norm_num); interval_cases (n % 15) <;> omega)
