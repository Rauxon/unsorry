import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_n2_2n5_eq_one (n : ℕ) : Nat.gcd (n + 2) (2 * n + 5) = 1 := by
  have h1 := Nat.gcd_dvd_left (n + 2) (2 * n + 5)
  have h2 := Nat.gcd_dvd_right (n + 2) (2 * n + 5)
  have hA : Nat.gcd (n + 2) (2 * n + 5) ∣ 1 * (2 * n + 5) := h2.mul_left 1
  have hB : Nat.gcd (n + 2) (2 * n + 5) ∣ 2 * (n + 2) := h1.mul_left 2
  have key : 1 * (2 * n + 5) = 2 * (n + 2) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
