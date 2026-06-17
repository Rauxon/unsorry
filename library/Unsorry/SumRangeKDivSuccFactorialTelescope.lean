import Mathlib

/-- The telescoping sum `∑_{k<n} k/(k+1)! = 1 - 1/n!`, proved by writing each
term as `1/k! - 1/(k+1)!` and collapsing the resulting telescoping series. -/
theorem sum_range_k_div_succ_factorial_telescope (n : ℕ) : (∑ k ∈ Finset.range n, (k : ℚ) / Nat.factorial (k + 1)) = 1 - 1 / Nat.factorial n := by
  have key : ∀ k ∈ Finset.range n, (k : ℚ) / Nat.factorial (k + 1)
      = (fun j => (1 : ℚ) / Nat.factorial j) k - (fun j => (1 : ℚ) / Nat.factorial j) (k + 1) := by
    intro k _
    simp only
    have hk : (Nat.factorial k : ℚ) ≠ 0 := Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero k)
    rw [Nat.factorial_succ]
    push_cast
    field_simp
    ring
  rw [Finset.sum_congr rfl key, Finset.sum_range_sub' (fun j => (1 : ℚ) / Nat.factorial j) n]
  simp
