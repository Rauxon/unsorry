import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_4n1_6n1_dvd_two (n : ℕ) : Nat.gcd (4 * n + 1) (6 * n + 1) ∣ 2 := by
  have h1 := Nat.gcd_dvd_left (4 * n + 1) (6 * n + 1)
  have h2 := Nat.gcd_dvd_right (4 * n + 1) (6 * n + 1)
  have hA : Nat.gcd (4 * n + 1) (6 * n + 1) ∣ 3 * (4 * n + 1) := h1.mul_left 3
  have hB : Nat.gcd (4 * n + 1) (6 * n + 1) ∣ 2 * (6 * n + 1) := h2.mul_left 2
  have key : 3 * (4 * n + 1) = 2 * (6 * n + 1) + 1 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
