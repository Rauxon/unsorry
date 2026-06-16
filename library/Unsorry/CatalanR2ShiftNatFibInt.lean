import Mathlib

theorem catalan_r2_shift_nat_fib_int (n : ℕ) : (Nat.fib (n + 2) : ℤ) ^ 2 - Nat.fib n * Nat.fib (n + 4) = (-1) ^ n := by
  have h := Int.fib_add_sq_sub_fib_mul_fib_add_two_mul (n : ℤ) 2
  simp only [Int.natAbs_natCast] at h
  norm_num at h
  have e2 : (n : ℤ) + 2 = ((n + 2 : ℕ) : ℤ) := by push_cast; ring
  rw [e2, Int.fib_natCast] at h
  exact h