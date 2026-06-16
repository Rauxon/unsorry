import Mathlib

open Finset in
theorem alt_sum_range_choose_sq_eq_zero_odd (n : ℕ) (hn : Odd n) : ∑ k ∈ Finset.range (n + 1), ((-1 : ℤ)) ^ k * (n.choose k : ℤ) ^ 2 = 0 := by
  set f : ℕ → ℤ := fun k => ((-1 : ℤ)) ^ k * (n.choose k : ℤ) ^ 2 with hf
  set S : ℤ := ∑ k ∈ Finset.range (n + 1), f k with hS
  -- Reflect the sum: ∑ f ((n+1)-1-k) = ∑ f k
  have hrefl : ∑ k ∈ Finset.range (n + 1), f (n + 1 - 1 - k) = S := by
    rw [hS]; exact Finset.sum_range_reflect f (n + 1)
  -- Show the reflected summand equals - f k for each k in range (n+1)
  have hpoint : ∀ k ∈ Finset.range (n + 1), f (n + 1 - 1 - k) = - f k := by
    intro k hk
    rw [Finset.mem_range, Nat.lt_succ_iff] at hk
    simp only [Nat.add_sub_cancel, hf]
    -- choose symmetry: n.choose (n - k) = n.choose k
    rw [Nat.choose_symm hk]
    -- (-1)^(n-k) = - (-1)^k  when n odd, k ≤ n
    have hsign : ((-1 : ℤ)) ^ (n - k) = - ((-1 : ℤ)) ^ k := by
      have : ((-1 : ℤ)) ^ (n - k) * ((-1 : ℤ)) ^ k = ((-1 : ℤ)) ^ n := by
        rw [← pow_add]
        congr 1
        omega
      have hpk : ((-1 : ℤ)) ^ k * ((-1 : ℤ)) ^ k = 1 := by
        rw [← pow_add, ← two_mul, pow_mul]
        norm_num
      obtain ⟨m, hm⟩ := hn
      have hnodd : ((-1 : ℤ)) ^ n = -1 := by
        rw [hm]; rw [pow_add, pow_mul]; norm_num
      -- from this and hnodd: (-1)^(n-k) * (-1)^k = -1
      have h2 : ((-1 : ℤ)) ^ (n - k) * ((-1 : ℤ)) ^ k = -1 := by rw [this, hnodd]
      -- multiply both sides by (-1)^k
      have := congrArg (· * ((-1 : ℤ)) ^ k) h2
      simp only at this
      rw [mul_assoc, hpk, mul_one] at this
      rw [this]; ring
    rw [hsign]; ring
  -- Therefore S = -S
  have : S = - S := by
    calc S = ∑ k ∈ Finset.range (n + 1), f (n + 1 - 1 - k) := hrefl.symm
    _ = ∑ k ∈ Finset.range (n + 1), - f k := by
          apply Finset.sum_congr rfl hpoint
    _ = - ∑ k ∈ Finset.range (n + 1), f k := by rw [Finset.sum_neg_distrib]
    _ = - S := by rw [hS]
  linarith