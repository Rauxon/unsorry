import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem sq_mod_eleven_mem (n : ℕ) : n ^ 2 % 11 = 0 ∨ n ^ 2 % 11 = 1 ∨ n ^ 2 % 11 = 3 ∨ n ^ 2 % 11 = 4 ∨ n ^ 2 % 11 = 5 ∨ n ^ 2 % 11 = 9 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 11 < 11 := Nat.mod_lt n (by norm_num); interval_cases (n % 11) <;> decide)
    | (have h : n % 11 < 11 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 11) <;> decide)
    | (have h : n % 11 < 11 := Nat.mod_lt n (by norm_num); interval_cases (n % 11) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 11 < 11 := Nat.mod_lt n (by norm_num); interval_cases (n % 11) <;> omega)
