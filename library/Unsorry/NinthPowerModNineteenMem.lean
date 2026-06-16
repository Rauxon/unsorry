import Mathlib

set_option maxRecDepth 8000 in
set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem ninth_power_mod_nineteen_mem (n : ℕ) : n ^ 9 % 19 = 0 ∨ n ^ 9 % 19 = 1 ∨ n ^ 9 % 19 = 18 := by
  first
    | (rw [Nat.pow_mod]; have h : n % 19 < 19 := Nat.mod_lt n (by norm_num); interval_cases (n % 19) <;> decide)
    | (have h : n % 19 < 19 := Nat.mod_lt n (by norm_num); rw [Nat.pow_mod]; interval_cases (n % 19) <;> decide)
    | (have h : n % 19 < 19 := Nat.mod_lt n (by norm_num); interval_cases (n % 19) <;> simp [Nat.pow_mod] <;> decide)
    | (have h : n % 19 < 19 := Nat.mod_lt n (by norm_num); interval_cases (n % 19) <;> omega)
