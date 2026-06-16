import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem gcd_np1_2np1_eq_one (n : ℕ) : Nat.gcd (n + 1) (2 * n + 1) = 1 := by
  have h1 := Nat.gcd_dvd_left (n + 1) (2 * n + 1)
  have h2 := Nat.gcd_dvd_right (n + 1) (2 * n + 1)
  have hA : Nat.gcd (n + 1) (2 * n + 1) ∣ 2 * (n + 1) := h1.mul_left 2
  have hB : Nat.gcd (n + 1) (2 * n + 1) ∣ 1 * (2 * n + 1) := h2.mul_left 1
  have key : 2 * (n + 1) = 1 * (2 * n + 1) + 1 := by omega
  rw [key] at hA
  exact Nat.dvd_one.mp ((Nat.dvd_add_right hB).mp hA)
