import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_threen_n7_dvd_twentyone (n : ℕ) : Nat.gcd (3 * n) (n + 7) ∣ 21 := by
  have h1 := Nat.gcd_dvd_left (3 * n) (n + 7)
  have h2 := Nat.gcd_dvd_right (3 * n) (n + 7)
  have hA : Nat.gcd (3 * n) (n + 7) ∣ 3 * (n + 7) := h2.mul_left 3
  have hB : Nat.gcd (3 * n) (n + 7) ∣ 1 * (3 * n) := h1.mul_left 1
  have key : 3 * (n + 7) = 1 * (3 * n) + 21 := by omega
  rw [key] at hA
  exact ((Nat.dvd_add_right hB).mp hA).trans (by norm_num)
