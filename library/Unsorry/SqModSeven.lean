import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sq_mod_seven (n : ℕ) :
    n ^ 2 % 7 = 0 ∨ n ^ 2 % 7 = 1 ∨ n ^ 2 % 7 = 2 ∨ n ^ 2 % 7 = 4 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 7 < 7 := Nat.mod_lt n (by norm_num); interval_cases (n % 7) <;> decide)
    | (have h : n % 7 < 7 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 7) <;> decide)
    | (have h : n % 7 < 7 := Nat.mod_lt n (by norm_num); interval_cases (n % 7) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 7 < 7 := Nat.mod_lt n (by norm_num); interval_cases (n % 7) <;> omega)
