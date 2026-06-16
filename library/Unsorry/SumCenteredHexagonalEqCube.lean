import Mathlib

set_option linter.unusedTactic false in
set_option linter.unreachableTactic false in
theorem sum_centered_hexagonal_eq_cube (n : ℕ) : ∑ k ∈ Finset.range n, (3 * k ^ 2 + 3 * k + 1) = n ^ 3 := by
  induction n with
  | zero => first | rfl | simp | norm_num | decide | (simp [Finset.sum_range_zero, Finset.prod_range_zero])
  | succ n ih =>
    first
      | (rw [Finset.sum_range_succ, ih]; ring)
      | (rw [Finset.sum_range_succ, ih]; ring_nf)
      | (rw [Finset.sum_range_succ, ih]; ring_nf; omega)
      | (rw [Finset.sum_range_succ]; rw [ih]; omega)
      | (rw [Finset.sum_range_succ, ih]; omega)
      | (simp only [Finset.sum_range_succ]; rw [ih]; ring)
      | (simp [Finset.sum_range_succ, ih]; ring)
      | (simp [Finset.sum_range_succ, ih]; ring_nf; omega)
      | (rw [Finset.prod_range_succ, ih]; ring)
      | (simp [Finset.prod_range_succ, ih]; ring)
      | (rw [Finset.sum_range_succ, ih]; push_cast; ring)
      | (rw [Finset.sum_range_succ, ih]; field_simp; ring)
      | (simp [Finset.sum_range_succ, Nat.fib_add_two, ih]; ring)
      | (rw [Finset.sum_range_succ, ih]; nlinarith [ih])
      | (simp [Finset.sum_range_succ] at *; omega)
      | (simp [Finset.sum_range_succ] at *; ring_nf; omega)
      | (push_cast [Finset.sum_range_succ, Nat.fib_add_two] at *; nlinarith [ih])
      | (simp [Nat.fib_add_two] at *; ring_nf)
      | (push_cast [Nat.fib_add_two] at *; linear_combination -ih)
      | (push_cast [Nat.fib_add_two] at *; linear_combination ih)
