import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
set_option linter.unusedVariables false in
theorem prod_icc_one_add_recip_pronic (n : ℕ) (hn : 1 ≤ n) : ∏ k ∈ Finset.Icc 1 n, ((1 : ℚ) + 1 / ((k : ℚ) ^ 2 + 2 * (k : ℚ))) = (2 * ((n : ℚ) + 1)) / ((n : ℚ) + 2) := by
  induction n, hn using Nat.le_induction with
  | base => first | (norm_num [Finset.Icc_self]) | (simp only [Finset.Icc_self, Finset.sum_singleton, Finset.prod_singleton]; norm_num) | (simp [Finset.Icc_self]; norm_num) | (simp [Finset.Icc_self]; ring) | (simp [Finset.Icc_self]; push_cast; field_simp; ring) | (simp [Finset.Icc_self]; field_simp; ring) | rfl | decide
  | succ n hn ih =>
    rw [Finset.prod_Icc_succ_top (by omega)]
    try have hzb : ((n:ℚ)) ≠ 0 := by exact_mod_cast (by omega : n ≠ 0)
    try have hzc : ((n:ℚ) + 1) ≠ 0 := by positivity
    try have hzd : ((n:ℚ) + 2) ≠ 0 := by positivity
    try have hze : ((n:ℚ) + 3) ≠ 0 := by positivity
    try have hzf : ((n:ℚ) - 1) ≠ 0 := sub_ne_zero.mpr (by exact_mod_cast (by omega : n ≠ 1))
    first
      | (rw [ih]; push_cast; field_simp; ring)
      | (rw [ih]; field_simp; ring)
      | (rw [ih]; push_cast; field_simp; ring_nf; done)
      | (rw [ih]; field_simp; ring_nf; done)
      | (rw [ih]; push_cast; ring)
      | (rw [ih]; ring)
      | (rw [ih]; push_cast [Nat.factorial_succ]; field_simp; ring)
      | (simp only [Nat.factorial_succ]; rw [ih]; push_cast; field_simp; ring)
      | (simp only [ih]; push_cast; field_simp; ring)
