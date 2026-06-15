import Mathlib

-- | Theorem stating that if we have two pairwise cross bounds, their sum is also bounded by the sum of squares.
-- | This is a direct consequence of adding the two inequalities.
-- |
-- | For real numbers a, b, c, d, if 2ab ≤ a² + b² and 2cd ≤ c² + d², then
-- | 2ab + 2cd ≤ a² + b² + c² + d².
-- |
-- | The proof uses the `add_le_add` lemma to add the two inequalities.
theorem add_pairwise_cross_bounds (a b c d : ℝ) :
    2 * a * b ≤ a ^ 2 + b ^ 2 → 2 * c * d ≤ c ^ 2 + d ^ 2 → 2 * a * b + 2 * c * d ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 :=
  fun h1 h2 => by
    have h3 : 2 * a * b + 2 * c * d ≤ (a ^ 2 + b ^ 2) + (c ^ 2 + d ^ 2) := add_le_add h1 h2
    linarith