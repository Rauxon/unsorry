import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_4n3_6n5_eq_one (n : ℕ) : Nat.gcd (4 * n + 3) (6 * n + 5) = 1 := by
  have h1 := Nat.gcd_dvd_left (4 * n + 3) (6 * n + 5)
  have h2 := Nat.gcd_dvd_right (4 * n + 3) (6 * n + 5)
  have hA : Nat.gcd (4 * n + 3) (6 * n + 5) ∣ 2 * (6 * n + 5) := h2.mul_left 2
  have hB : Nat.gcd (4 * n + 3) (6 * n + 5) ∣ 3 * (4 * n + 3) := h1.mul_left 3
  have key : 2 * (6 * n + 5) = 3 * (4 * n + 3) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
