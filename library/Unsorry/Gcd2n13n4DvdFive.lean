import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_2n1_3n4_dvd_five (n : ℕ) : Nat.gcd (2 * n + 1) (3 * n + 4) ∣ 5 := by
  have h1 := Nat.gcd_dvd_left (2 * n + 1) (3 * n + 4)
  have h2 := Nat.gcd_dvd_right (2 * n + 1) (3 * n + 4)
  have hA : Nat.gcd (2 * n + 1) (3 * n + 4) ∣ 2 * (3 * n + 4) := h2.mul_left 2
  have hB : Nat.gcd (2 * n + 1) (3 * n + 4) ∣ 3 * (2 * n + 1) := h1.mul_left 3
  have key : 2 * (3 * n + 4) = 3 * (2 * n + 1) + 5 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
