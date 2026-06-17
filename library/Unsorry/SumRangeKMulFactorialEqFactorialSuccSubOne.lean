import Mathlib

/-- The telescoping sum `∑ k ≤ n, k * k! = (n+1)! - 1`, proved by induction using
`k * k! = (k+1)! - k!`. -/
theorem sum_range_k_mul_factorial_eq_factorial_succ_sub_one (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), k * Nat.factorial k = Nat.factorial (n + 1) - 1 := by
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih, Nat.factorial_succ (m + 1)]
    have h1 : 1 ≤ Nat.factorial (m + 1) := Nat.factorial_pos _
    have h2 : (m + 1 + 1) * Nat.factorial (m + 1)
        = (m + 1) * Nat.factorial (m + 1) + Nat.factorial (m + 1) := by ring
    rw [h2]
    omega
