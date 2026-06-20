import Unsorry.NesbittInequalityS1
import Unsorry.NesbittInequalityS2
import Unsorry.NesbittInequalityS3
import Unsorry.NesbittInequalityS4

/-- **Nesbitt's inequality.** For positive reals `a`, `b`, `c`,
`3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b)`.

The proof chains the Titu (Cauchy–Schwarz in Engel form) lower bound with the
symmetric estimate `3 (ab + bc + ca) ≤ (a + b + c) ^ 2`. -/
theorem nesbitt_inequality (a b c : ℝ) (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    3 / 2 ≤ a / (b + c) + b / (c + a) + c / (a + b) := by
  have hpos := positive_pairwise_sum a b c ha hb hc
  have hineq := three_pairwise_le_sum_square a b c
  exact le_trans
    (symmetric_bound_implies_three_halves a b c hpos hineq)
    (nesbitt_titu_lower_bound a b c ha hb hc)
