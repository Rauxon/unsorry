import Mathlib

theorem fib_two_mul_sq_diff_int (n : ℤ) : Int.fib (2 * n) = Int.fib (n + 1) ^ 2 - Int.fib (n - 1) ^ 2 := by
  have h : Int.fib (n + 1) = Int.fib (n - 1) + Int.fib n := by
    have e := Int.fib_add_two (n - 1)
    have h1 : n - 1 + 2 = n + 1 := by ring
    have h2 : n - 1 + 1 = n := by ring
    rw [h1, h2] at e
    exact e
  rw [Int.fib_two_mul]
  have hn : Int.fib n = Int.fib (n + 1) - Int.fib (n - 1) := by linarith [h]
  rw [hn]; ring