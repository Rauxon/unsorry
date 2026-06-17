import Mathlib

/-- The sum `∑_{k<n} 1/((k+1)(k+2)(k+3))` telescopes to `1/4 - 1/(2(n+1)(n+2))`. -/
theorem sum_range_recip_three_consecutive (n : ℕ) : ∑ k ∈ Finset.range n, (1 : ℚ) / ((k + 1) * (k + 2) * (k + 3)) = 1 / 4 - 1 / (2 * (n + 1) * (n + 2)) := by
  induction n with
  | zero => norm_num
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    have h1 : (n : ℚ) + 1 ≠ 0 := by positivity
    have h2 : (n : ℚ) + 2 ≠ 0 := by positivity
    have h3 : (n : ℚ) + 3 ≠ 0 := by positivity
    push_cast
    field_simp
    ring
