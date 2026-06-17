import Mathlib.Data.Nat.Choose.Sum

/-!
# Odd-index row sum of Pascal's triangle

The binomial coefficients sitting at odd positions in row `2 * (n + 1)` of Pascal's
triangle sum to `2 ^ (2 * n + 1)`, exactly half of the full row sum `2 ^ (2 * n + 2)`.

The proof works over `ℤ`.  Splitting the full row of `2 * (n + 1) + 1` entries into its
even- and odd-indexed parts, the row sum `2 ^ (2 * (n + 1))` and the alternating row sum
`0` combine so that the odd-indexed part is exactly half of the row sum.
-/

open Finset

/-- Split a sum over `range (2 * m)` into its even- and odd-indexed parts. -/
private lemma sum_range_two_mul_split (f : ℕ → ℤ) (m : ℕ) :
    ∑ i ∈ range (2 * m), f i
      = (∑ k ∈ range m, f (2 * k)) + ∑ k ∈ range m, f (2 * k + 1) := by
  induction m with
  | zero => simp
  | succ m ih =>
    have e : 2 * (m + 1) = 2 * m + 1 + 1 := by ring
    rw [e]
    simp only [Finset.sum_range_succ]
    rw [ih]
    ring

theorem sum_range_odd_index_choose_eq_two_pow (n : ℕ) :
    ∑ k ∈ Finset.range (n + 1), (2 * (n + 1)).choose (2 * k + 1) = 2 ^ (2 * n + 1) := by
  -- Move to `ℤ`, where the alternating row sum is available.
  have key : (↑(∑ k ∈ Finset.range (n + 1), (2 * (n + 1)).choose (2 * k + 1)) : ℤ)
      = (2 ^ (2 * n + 1) : ℤ) := by
    push_cast
    -- The odd-indexed and even-indexed partial sums.
    set Eodd := ∑ k ∈ range (n + 1), ((2 * (n + 1)).choose (2 * k + 1) : ℤ) with hEodd
    set Eeven := ∑ k ∈ range (n + 1), ((2 * (n + 1)).choose (2 * k) : ℤ) with hEeven
    -- Full row sum equals `2 ^ (2 * (n + 1))`.
    have hF : ∑ m ∈ range (2 * (n + 1) + 1), ((2 * (n + 1)).choose m : ℤ)
        = 2 ^ (2 * (n + 1)) := by
      have := Nat.sum_range_choose (2 * (n + 1))
      exact_mod_cast this
    -- Alternating row sum vanishes.
    have hA : ∑ m ∈ range (2 * (n + 1) + 1),
        ((-1) ^ m * (2 * (n + 1)).choose m : ℤ) = 0 :=
      Int.alternating_sum_range_choose_of_ne (by omega)
    -- Rewrite the full row sum via the even/odd split.
    have hFsplit : ∑ m ∈ range (2 * (n + 1) + 1), ((2 * (n + 1)).choose m : ℤ)
        = Eeven + Eodd + ((2 * (n + 1)).choose (2 * (n + 1)) : ℤ) := by
      rw [Finset.sum_range_succ,
        sum_range_two_mul_split (fun m => ((2 * (n + 1)).choose m : ℤ)) (n + 1)]
    -- Rewrite the alternating row sum via the even/odd split.
    have hge : ∑ k ∈ range (n + 1), ((-1) ^ (2 * k) * (2 * (n + 1)).choose (2 * k) : ℤ)
        = Eeven := by
      rw [hEeven]
      apply Finset.sum_congr rfl
      intro k _
      rw [pow_mul]
      simp
    have hgo : ∑ k ∈ range (n + 1),
        ((-1) ^ (2 * k + 1) * (2 * (n + 1)).choose (2 * k + 1) : ℤ) = -Eodd := by
      rw [hEodd]
      have h1 : ∀ k, ((-1) ^ (2 * k + 1) * (2 * (n + 1)).choose (2 * k + 1) : ℤ)
          = -((2 * (n + 1)).choose (2 * k + 1) : ℤ) := by
        intro k
        rw [pow_succ, pow_mul]
        simp
      rw [Finset.sum_congr rfl (fun k _ => h1 k), Finset.sum_neg_distrib]
    have hAsplit : ∑ m ∈ range (2 * (n + 1) + 1),
        ((-1) ^ m * (2 * (n + 1)).choose m : ℤ)
        = Eeven + (-Eodd) + ((-1) ^ (2 * (n + 1)) * (2 * (n + 1)).choose (2 * (n + 1)) : ℤ) := by
      rw [Finset.sum_range_succ,
        sum_range_two_mul_split (fun m => ((-1) ^ m * (2 * (n + 1)).choose m : ℤ)) (n + 1)]
      rw [hge, hgo]
    -- Evaluate the boundary terms.
    have hself : ((2 * (n + 1)).choose (2 * (n + 1)) : ℤ) = 1 := by
      rw [Nat.choose_self]; norm_num
    have hsign : ((-1 : ℤ)) ^ (2 * (n + 1)) = 1 := by
      rw [pow_mul]; simp
    -- Assemble the two equations and solve for `Eodd`.
    rw [hFsplit, hself] at hF
    rw [hAsplit, hself, hsign] at hA
    have hpow : (2 : ℤ) ^ (2 * (n + 1)) = 2 ^ (2 * n + 1) * 2 := by
      rw [show 2 * (n + 1) = (2 * n + 1) + 1 by ring, pow_succ]
    rw [hpow] at hF
    linarith
  exact_mod_cast key
