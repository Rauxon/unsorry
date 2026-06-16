import Mathlib

set_option maxRecDepth 8000 in
set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem fourth_power_mod_fortyeight_mem (n : ℕ) :
    n^4 % 48 = 0 ∨ n^4 % 48 = 1 ∨ n^4 % 48 = 16 ∨ n^4 % 48 = 33 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 48 < 48 := Nat.mod_lt n (by norm_num); interval_cases (n % 48) <;> decide)
    | (have h : n % 48 < 48 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 48) <;> decide)
    | (have h : n % 48 < 48 := Nat.mod_lt n (by norm_num); interval_cases (n % 48) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 48 < 48 := Nat.mod_lt n (by norm_num); interval_cases (n % 48) <;> omega)
