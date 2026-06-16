import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_n2_n8_dvd_six (n : ℕ) : Nat.gcd (n + 2) (n + 8) ∣ 6 := by
  have h1 := Nat.gcd_dvd_left (n + 2) (n + 8)
  have h2 := Nat.gcd_dvd_right (n + 2) (n + 8)
  have hA : Nat.gcd (n + 2) (n + 8) ∣ 1 * (n + 8) := h2.mul_left 1
  have hB : Nat.gcd (n + 2) (n + 8) ∣ 1 * (n + 2) := h1.mul_left 1
  have key : 1 * (n + 8) = 1 * (n + 2) + 6 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
