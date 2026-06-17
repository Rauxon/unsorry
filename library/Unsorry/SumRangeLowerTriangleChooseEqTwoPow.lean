import Mathlib.Data.Nat.Choose.Sum

/-- The sum over the lower-triangular array of binomial coefficients up to row `n`
equals `2 ^ (n + 1) - 1`. The inner row sum collapses to `2 ^ j`, and the outer
geometric sum telescopes. -/
theorem sum_range_lower_triangle_choose_eq_two_pow (n : ℕ) :
    ∑ j ∈ Finset.range (n + 1), ∑ k ∈ Finset.range (j + 1), j.choose k = 2 ^ (n + 1) - 1 := by
  have hinner : ∀ j : ℕ, ∑ k ∈ Finset.range (j + 1), j.choose k = 2 ^ j := fun j =>
    Nat.sum_range_choose j
  simp_rw [hinner]
  induction n with
  | zero => simp
  | succ m ih =>
    rw [Finset.sum_range_succ, ih]
    have hpos : 0 < 2 ^ (m + 1) := pow_pos (by norm_num) _
    have hstep : 2 ^ (m + 1 + 1) = 2 ^ (m + 1) + 2 ^ (m + 1) := by ring
    rw [hstep]
    omega
