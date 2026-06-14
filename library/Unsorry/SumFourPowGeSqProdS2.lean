import Mathlib

-- | Theorem: The cyclic half sum of fourth powers equals the sum of fourth powers.
-- | For any real numbers a, b, c, the following holds:
-- | (a^4 + b^4) / 2 + (b^4 + c^4) / 2 + (c^4 + a^4) / 2 = a^4 + b^4 + c^4
-- | 
-- | This is proven by algebraic manipulation.
-- | The left-hand side simplifies to the right-hand side when expanded and combined like terms.
-- | 
-- | @param a First real number
-- | @param b Second real number
-- | @param c Third real number
-- | @return Proof that the cyclic half sum of fourth powers equals the sum of fourth powers
-- |
theorem cyclic_half_sum_fourth_eq_sum_fourth (a b c : ℝ) : 
    (a^4 + b^4) / 2 + (b^4 + c^4) / 2 + (c^4 + a^4) / 2 = a^4 + b^4 + c^4 := by
  ring