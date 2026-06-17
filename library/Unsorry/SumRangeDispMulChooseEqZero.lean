import Mathlib

/-- The signed sum `∑_{k=0}^{n} (2k - n) * C(n, k)` vanishes.

The proof uses the reflection symmetry `k ↦ n - k` of `Finset.range (n + 1)`:
the binomial coefficients are symmetric (`n.choose (n - k) = n.choose k`), while
the linear factor flips sign (`2(n - k) - n = -(2k - n)`). Hence each term pairs
with its reflection to cancel, so twice the sum is zero. -/
theorem sum_range_disp_mul_choose_eq_zero (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (2 * (k : ℤ) - n) * (n.choose k : ℤ) = 0 := by
  set f : ℕ → ℤ := fun k => (2 * (k : ℤ) - n) * (n.choose k : ℤ) with hf
  have hreflect := Finset.sum_range_reflect f (n + 1)
  have hpair : ∑ j ∈ Finset.range (n + 1), (f (n + 1 - 1 - j) + f j) = 0 := by
    apply Finset.sum_eq_zero
    intro j hj
    rw [Finset.mem_range, Nat.lt_succ_iff] at hj
    have h1 : n + 1 - 1 - j = n - j := by omega
    rw [h1]
    simp only [hf]
    rw [Nat.choose_symm hj, Nat.cast_sub hj]
    ring
  rw [Finset.sum_add_distrib, hreflect] at hpair
  linarith
