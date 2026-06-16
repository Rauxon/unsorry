import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_2n5_3n7_eq_one (n : ℕ) : Nat.gcd (2 * n + 5) (3 * n + 7) = 1 := by
  have h1 := Nat.gcd_dvd_left (2 * n + 5) (3 * n + 7)
  have h2 := Nat.gcd_dvd_right (2 * n + 5) (3 * n + 7)
  have hA : Nat.gcd (2 * n + 5) (3 * n + 7) ∣ 3 * (2 * n + 5) := h1.mul_left 3
  have hB : Nat.gcd (2 * n + 5) (3 * n + 7) ∣ 2 * (3 * n + 7) := h2.mul_left 2
  have key : 3 * (2 * n + 5) = 2 * (3 * n + 7) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
