import Unsorry.NatSqLtTwoPowS2S1
import Unsorry.NatSqLtTwoPowS2S2
import Unsorry.NatSqLtTwoPowS2S3

/-- Induction step for `n ^ 2 < 2 ^ n`: if `5 ≤ n` and `n ^ 2 < 2 ^ n`, then
`(n + 1) ^ 2 < 2 ^ (n + 1)`.

The chain is `(n + 1) ^ 2 ≤ 2 * n ^ 2 < 2 * 2 ^ n = 2 ^ (n + 1)`, assembled from
the three proved component lemmas. -/
theorem sq_lt_two_pow_step_from_five {n : ℕ} (hn : 5 ≤ n) (h : n ^ 2 < 2 ^ n) :
    (n + 1) ^ 2 < 2 ^ (n + 1) := by
  have h1 : (n + 1) ^ 2 ≤ 2 * n ^ 2 := succ_square_le_two_mul_square_of_five hn
  have h2 : 2 * n ^ 2 < 2 * 2 ^ n := two_mul_square_lt_two_mul_pow_of_square_lt h
  have h3 : 2 * 2 ^ n = 2 ^ (n + 1) := two_mul_two_pow_eq_two_pow_succ_nat n
  calc (n + 1) ^ 2 ≤ 2 * n ^ 2 := h1
    _ < 2 * 2 ^ n := h2
    _ = 2 ^ (n + 1) := h3
