import Unsorry.SumFourSqGeTwoCrossS1
import Unsorry.SumFourSqGeTwoCrossS2

theorem sum_four_sq_ge_two_cross (a b c d : ℝ) :
    2 * a * b + 2 * c * d ≤ a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2 := by
  exact add_pairwise_cross_bounds a b c d
    (real_two_mul_le_add_sq a b)
    (real_two_mul_le_add_sq c d)
