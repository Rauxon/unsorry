import Unsorry.FourConsecutiveProductAddOneSquareS1
import Unsorry.FourConsecutiveProductAddOneSquareS2
import Unsorry.FourConsecutiveProductAddOneSquareS3

theorem four_consecutive_product_add_one_square (n : ℕ) :
    ∃ m : ℕ, n * (n + 1) * (n + 2) * (n + 3) + 1 = m ^ 2 := by
  refine ⟨n * (n + 3) + 1, ?_⟩
  rw [four_consecutive_product_rearrange n]
  rw [adjacent_middle_product_eq_outer_product_add_two n]
  exact product_with_two_more_add_one_is_square (n * (n + 3))
