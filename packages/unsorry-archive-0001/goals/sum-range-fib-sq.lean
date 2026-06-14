import Mathlib

theorem sum_range_succ_fib_sq (n : ℕ) : ∑ i ∈ Finset.range (n + 1), Nat.fib i ^ 2 = Nat.fib n * Nat.fib (n + 1) := by
  sorry
