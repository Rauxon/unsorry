# Concrete-Mathematics / OEIS closed forms — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 21 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sum_range_id_mul_three_pow` — Four times the sum of i·3^i over i below n, plus 3^(n+1), equals 2n·3^n + 3
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then ring after rewriting 3^(n+1) · conf: high
- [x] `sum_range_odd_mul_three_pow` — The sum of (2i+1)·3^i over i below n, plus 3^n, equals n·3^n + 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n via Finset.sum_range_succ; close inductive step with ring · conf: high
- [ ] `sum_range_sq_mul_two_pow` — The sum of k^2·2^k over k below n, plus 6, equals 2^n·(n^2 − 4n + 6)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; note n^2-4n+6 stays nonneg, ring/nlinarith on step · conf: high
- [ ] `sum_range_sq_mul_three_pow` — Twice the sum of k^2·3^k over k below n, plus 3, equals 3^n·(n^2 − 3n + 3)
      absence: no-local-match · triviality: non-trivial · intended: Induction via Finset.sum_range_succ; factor 3^(n+1) and finish with ring · conf: high
- [ ] `sum_icc_id_mul_two_pow_pred` — The sum of k·2^(k−1) for k from 1 to n equals (n−1)·2^n + 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top; handle 2^(k-1) shift and ring · conf: high
- [x] `sum_range_succ_mul_factorial_succ` — The sum of (i+1)·(i+1)! over i below n, plus 1, telescopes to (n+1)!
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; use Nat.factorial_succ then ring · conf: high
- [ ] `sum_range_id_mul_fib` — The sum of i·Fib(i) over i below n, plus Fib(n+3), equals n·Fib(n+1) + 2
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; rewrite Fib(n+3) via Nat.fib_add_two, then omega/ring · conf: med
- [ ] `sum_range_fib_three_step` — Twice the sum of Fib(3(i+1)) over i below n, plus 1, equals Fib(3n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; expand Fib(3n+5) via repeated Nat.fib_add_two and simplify with omega · conf: med
- [x] `sum_range_fib_sq_eq_prod` — The sum of the squares of Fib(i) for i from 0 to n equals Fib(n)·Fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; use Fib(n+2)=Fib(n+1)+Fib(n) and ring · conf: high
- [x] `sum_range_id_mul_add_two` — Six times the sum of i·(i+2) over i below n equals n·(n−1)·(2n+5)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; nonneg n-1, finish with ring/nlinarith · conf: high
- [x] `sum_range_four_consecutive_product` — Five times the sum of i(i+1)(i+2)(i+3) over i below n equals (n−1)n(n+1)(n+2)(n+3)
      absence: no-local-match · triviality: non-trivial · intended: Telescoping/induction with Finset.sum_range_succ; ring after handling the n-1 factor · conf: high
- [x] `sum_range_three_mul_add_one` — Twice the sum of 3k+1 over k below n equals n·(3n−1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; close step with ring/nlinarith · conf: high
- [x] `sum_range_four_mul_add_one` — The sum of 4k+1 over k below n equals n·(2n−1), the n-th centered-square-style count
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; finish with ring/nlinarith · conf: high
- [ ] `alternating_sum_range_sq_succ` — The alternating sum of (i+1)^2 over i below n equals (−1)^(n+1)·(n(n+1)/2)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; case-split parity of n via pow_succ, then ring · conf: med
- [x] `sum_range_recip_two_pow` — The partial geometric sum of 1/2^i over i below n equals 2 − 2/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; clear denominators (field_simp) then ring · conf: high
- [x] `sum_range_id_div_two_pow` — The sum of i/2^i for i from 0 to n equals 2 − (n+2)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; field_simp then ring on the rational step · conf: high
- [ ] `sum_range_sq_div_two_pow` — The sum of i^2/2^i for i from 0 to n equals 6 − (n^2 + 4n + 6)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; field_simp and ring on the rational closed form · conf: med
- [x] `sum_range_odd_div_two_pow` — The sum of (2i+1)/2^i for i from 0 to n equals 6 − (2n+5)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; field_simp then ring · conf: high
- [ ] `sum_range_recip_odd_consecutive` — The telescoping sum of 1/((2k+1)(2k+3)) over k below n equals n/(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; partial-fraction step closed by field_simp; ring · conf: high
- [ ] `sum_range_recip_skip_one` — The telescoping sum of 1/((k+1)(k+3)) over k below n equals 3/4 − (2n+3)/(2(n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; field_simp clears denominators, then ring · conf: med
- [x] `sum_range_recip_three_consecutive` — The telescoping sum of 1/((k+1)(k+2)(k+3)) over k below n equals 1/4 − 1/(2(n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; field_simp then ring on the telescoped tail · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 14 candidates

- [ ] `alt_sum_range_sq_eq_signed_pronic` — Twice the alternating sum of the first n+1 squares equals (-1)^n times the n-th pronic number n(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; ring_nf and a parity case-split on (-1)^(n+1) per step · conf: high
- [ ] `sum_icc_k_sq_add_one_mul_factorial_eq_pronic_factorial` — The sum over k from 1 to n of (k^2+1)*k! telescopes to n*(n+1)!
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top; use (k^2+1)k! step against n((n+1)!) telescope, Nat.factorial_succ + ring/omega · conf: high
- [ ] `sum_range_recip_odd_pair_step_two_eq_n_div` — The sum over k<n of 1/((2k+1)(2k+3)) telescopes to n/(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; partial-fraction step 1/((2k+1)(2k+3)) and field_simp + ring; positivity of denominators · conf: high
- [ ] `sum_icc_lucas_sq_via_fib_eq_fib_product` — The sum of the squares of the first n Lucas numbers (written as F(k+1)+F(k-1)) equals L(n)*L(n+1)-2
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top; expand L=F(k+1)+F(k-1) and reduce the step via Nat.fib_add_two recurrences (or omega after substitution) · conf: med
- [ ] `sum_range_fib_mul_lucas_eq_fib_odd_pred` — The sum over k from 0 to n of F(k)*L(k) (Lucas as F(k+1)+F(k-1)) equals F(2n+1)-1
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; pointwise F(k)L(k)=F(2k) via fib double-index, then telescope F(2k) sum to F(2n+1)-1 · conf: med
- [ ] `sum_icc_harmonic_eq_succ_mul_harmonic_sub_n` — The sum of the first n harmonic numbers equals (n+1)*H(n) - n (a Concrete Mathematics summation-by-parts identity)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top on the outer sum; the inner H(k+1)=H(k)+1/(k+1) step, field_simp + ring · conf: med
- [ ] `sum_icc_id_mul_harmonic_closed_form` — Four times the sum of k*H(k) for k up to n equals 2n(n+1)H(n) - n(n-1) (a weighted Concrete Mathematics harmonic identity)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; expand H(k+1)=H(k)+1/(k+1), clear denominators with field_simp and close the step with ring · conf: med
- [ ] `sum_range_three_k_add_one_mul_three_pow_closed` — Four times the sum over k<n of (3k+1)*3^k equals (6n-5)*3^n + 5
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; pow_succ on 3^(n+1) then ring/omega to match the step (work in ℤ or ℕ with care on subtraction) · conf: high
- [ ] `sum_icc_k_mul_two_k_sub_one_closed_form` — Six times the sum of k(2k-1) for k from 1 to n equals n(n+1)(4n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; the step is a cubic identity closed by ring (after clearing the 2k-1 subtraction) or omega · conf: high
- [ ] `sum_icc_recip_id_mul_add_three_gap_telescope` — The sum of 1/(k(k+3)) for k from 1 to n telescopes to (1/3)(11/6 - (1/(n+1)+1/(n+2)+1/(n+3)))
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; gap-3 partial fraction 1/(k(k+3))=(1/3)(1/k-1/(k+3)), field_simp + ring, denominators nonzero · conf: med
- [ ] `sum_icc_recip_step_four_pair_eq_n_div` — The sum of 1/((4k-3)(4k+1)) for k from 1 to n telescopes to n/(4n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; partial fraction (1/4)(1/(4k-3)-1/(4k+1)), field_simp + ring, positivity of denominators · conf: high
- [ ] `sum_icc_three_k_sub_one_mul_two_pow_pred_closed` — The sum of (3k-1)*2^(k-1) for k from 1 to n equals (3n-4)*2^n + 4
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; rewrite 2^(k-1) carefully, pow_succ, and close the step in ℤ via ring (lift to avoid ℕ subtraction) · conf: high
- [ ] `sum_icc_five_k_sub_two_mul_three_pow_pred_closed` — Four times the sum of (5k-2)*3^(k-1) for k from 1 to n equals (10n-9)*3^n + 9
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; pow_succ on 3^(n+1), lift to ℤ to handle 5k-2 and 10n-9 subtractions, close with ring · conf: high
- [ ] `sum_icc_harmonic_div_id_eq_half_sq_plus_second` — Twice the sum of H(k)/k for k up to n equals H(n)^2 plus the second-order harmonic sum (Euler's symmetry identity)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top; expand H(n+1)=H(n)+1/(n+1) in both H(n)^2 and the second-order sum, field_simp + ring on the step · conf: med

### Replenishment round 4 (scoped 2026-06-15) — 18 candidates

- [ ] `sum_range_k_sq_mul_four_pow_closed` — The weighted sum of k squared times four to the k over the first n terms has a closed form scaled by 27
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_k_sq_mul_five_pow_closed` — The weighted sum of k squared times five to the k over the first n terms has a closed form scaled by 32
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_k_cube_mul_three_pow_closed` — The weighted sum of k cubed times three to the k over the first n terms has a cubic-polynomial closed form scaled by 8
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: med
- [ ] `sum_range_k_cube_mul_four_pow_closed` — The weighted sum of k cubed times four to the k over the first n terms has a cubic-polynomial closed form scaled by 27
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: med
- [ ] `sum_range_k_fourth_mul_two_pow_closed` — The weighted sum of k to the fourth times two to the k has a quartic-polynomial-times-power closed form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: med
- [ ] `sum_range_id_mul_neg_two_pow_closed_form` — The weighted sum of k times negative-two to the k has a closed form scaled by 9
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_id_mul_neg_three_pow_closed_form` — The weighted sum of k times negative-three to the k has a closed form scaled by 16
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_k_sq_mul_neg_two_pow_closed` — The weighted sum of k squared times negative-two to the k has a closed form scaled by 27
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_k_sq_mul_neg_three_pow_closed` — The weighted sum of k squared times negative-three to the k has a closed form scaled by 32
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: med
- [ ] `sum_range_k_mul_succ_mul_two_pow_closed_form` — The weighted sum of k times its successor times two to the k has a clean quadratic-times-power closed form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_succ_mul_add_two_mul_two_pow_closed` — The weighted sum of (k+1)(k+2) times two to the k has a clean quadratic-times-power closed form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_three_k_add_one_mul_two_pow_closed` — The weighted sum of (3k+1) times two to the k has a clean linear-times-power closed form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_k_sq_add_one_mul_two_pow_closed_form` — The weighted sum of (k squared plus one) times two to the k has a clean quadratic-times-power closed form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, ring · conf: high
- [ ] `sum_range_id_mul_fib_closed_form` — The sum of k times the kth Fibonacci number plus a Fibonacci correction term equals a closed Fibonacci form
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, Nat.fib_add_two, omega · conf: med
- [ ] `two_mul_sum_range_fib_three_mul_eq_fib_pred` — Twice the sum of every third Fibonacci number (indices divisible by three), plus one, equals a single Fibonacci number
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, Nat.fib_add_two, omega · conf: med
- [ ] `two_mul_sum_range_fib_three_mul_add_one_eq_fib` — Twice the sum of Fibonacci numbers at indices congruent to one mod three equals a single Fibonacci number
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, Nat.fib_add_two, omega · conf: med
- [ ] `two_mul_sum_range_fib_three_mul_add_two_eq_fib` — Twice the sum of Fibonacci numbers at indices congruent to two mod three, plus one, equals a single Fibonacci number
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, Nat.fib_add_two, omega · conf: med
- [ ] `sum_range_fib_four_mul_add_two_eq_fib_sq` — The sum of Fibonacci numbers at indices four-k-plus-two equals the square of the (2n)th Fibonacci number
      absence: no-local-match · triviality: non-trivial · intended: induction on n, Finset.sum_range_succ, Fibonacci product identities, ring · conf: med
