import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_n_add_six_dvd_six (n : ℕ) : Nat.gcd n (n + 6) ∣ 6 := by
  have h1 := Nat.gcd_dvd_left (n) (n + 6)
  have h2 := Nat.gcd_dvd_right (n) (n + 6)
  have hA : Nat.gcd (n) (n + 6) ∣ 1 * (n + 6) := h2.mul_left 1
  have hB : Nat.gcd (n) (n + 6) ∣ 1 * (n) := h1.mul_left 1
  have key : 1 * (n + 6) = 1 * (n) + 6 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
