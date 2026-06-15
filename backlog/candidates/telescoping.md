# Telescoping sums & products — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 22 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sum_range_succ_mul_factorial_eq` — The sum over k from 0 to n-1 of (k+1)·(k+1)! equals (n+1)! − 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; rewrite (k+2)! = (k+2)·(k+1)! and close with Nat arithmetic · conf: high
- [x] `sum_range_k_div_succ_factorial_eq` — The rational sum of k/(k+1)! for k from 0 to n-1 equals 1 − 1/n!
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; per-term identity k/(k+1)! = 1/k! − 1/(k+1)! via field_simp and factorial recurrence · conf: high
- [x] `sum_range_recip_triple_consecutive` — The sum of 1/((k+1)(k+2)(k+3)) for k from 0 to n-1 equals 1/4 − 1/(2(n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term partial fraction 1/((k+1)(k+2)(k+3)) = ½[1/((k+1)(k+2)) − 1/((k+2)(k+3))], field_simp then ring · conf: high
- [x] `sum_range_recip_odd_pair_consecutive` — The sum of 1/((2k+1)(2k+3)) for k from 0 to n-1 equals n/(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; per-term ½[1/(2k+1) − 1/(2k+3)], field_simp and ring · conf: high
- [x] `sum_range_odd_num_sq_succ_sq_telescope` — The sum of (2k+3)/((k+1)²(k+2)²) for k from 0 to n-1 equals 1 − 1/(n+1)²
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term identity (2k+3)/((k+1)²(k+2)²) = 1/(k+1)² − 1/(k+2)², field_simp then ring · conf: high
- [ ] `sum_range_recip_odd_triple_consecutive` — The sum of 1/((2k+1)(2k+3)(2k+5)) for k from 0 to n-1 equals 1/12 − 1/(4(2n+1)(2n+3))
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term ¼[1/((2k+1)(2k+3)) − 1/((2k+3)(2k+5))], field_simp then ring · conf: med
- [ ] `sum_range_fib_div_fib_fib_telescope` — The sum of F(k+1)/(F(k+2)·F(k+3)) for k from 0 to n-1 equals 1 − 1/F(n+2), where F is Fibonacci
      absence: no-local-match · triviality: non-trivial · intended: Induction using Nat.fib_add_two (F(k+3)=F(k+2)+F(k+1)) so each term = 1/F(k+2) − 1/F(k+3); needs fib positivity for field_simp · conf: med
- [ ] `prod_icc_cube_sub_one_div_cube_add_one` — The product of (k³−1)/(k³+1) for k from 2 to n equals 2(n²+n+1)/(3n(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Induction from base n=2; factor k³±1 = (k±1)(k²∓k+1) and telescope the two cubic-factor chains, field_simp + ring · conf: med
- [x] `prod_icc_one_sub_two_div_pronic` — The product of (1 − 2/(k(k+1))) for k from 2 to n equals (n+2)/(3n)
      absence: no-local-match · triviality: non-trivial · intended: Induction; rewrite 1 − 2/(k(k+1)) = (k−1)(k+2)/(k(k+1)) and telescope both linear chains, field_simp + ring · conf: high
- [x] `prod_icc_one_add_recip_pronic` — The product of (1 + 1/(k²+2k)) for k from 1 to n equals 2(n+1)/(n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; rewrite 1 + 1/(k²+2k) = (k+1)²/(k(k+2)) and telescope, field_simp + ring · conf: high
- [x] `prod_range_one_sub_recip_succ_sq` — The product of (1 − 1/(k+1)²) for k from 1 to n equals (n+2)/(2(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Induction; rewrite 1 − 1/(k+1)² = k(k+2)/(k+1)² and telescope, field_simp + ring · conf: high
- [ ] `prod_icc_one_sub_recip_triangular` — The product of (1 − 1/C(k+1,2)) (one minus reciprocal triangular number) for k from 2 to n equals (n+2)/(3n)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite Nat.choose (k+1) 2 = k(k+1)/2 (Nat.choose_two_right), reduce to the pronic product and telescope by induction · conf: med
- [ ] `sum_range_cube_diff_eq_cube` — The sum of (3k²+3k+1) for k from 0 to n-1 equals n³
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the per-term is (k+1)³−k³, close with ring · conf: high
- [x] `sum_range_four_cube_diff_eq` — The sum of (4k³+6k²+4k+1) for k from 0 to n-1 equals n⁴
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; per-term is (k+1)⁴−k⁴, close with ring · conf: high
- [ ] `sum_range_k_mul_two_pow_eq` — The sum of k·2^k for k from 0 to n-1 equals (n−2)·2ⁿ + 2
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; handle Nat subtraction by stating over ℤ or proving 2 ≤ result; ring_nf after expanding 2^(n+1) · conf: high
- [ ] `sum_range_recip_fib_prod_consecutive` — The sum of 1/(F(k+2)·F(k+3)) for k from 0 to n-1 equals F(n+1)/F(n+2), where F is Fibonacci
      absence: no-local-match · triviality: non-trivial · intended: Induction using the Fibonacci recurrence and fib positivity; combine fractions with field_simp and apply fib_add_two · conf: med
- [x] `sum_range_recip_four_step_product` — The sum of 1/((4k+1)(4k+5)) for k from 0 to n-1 equals n/(4n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term ¼[1/(4k+1) − 1/(4k+5)], field_simp then ring · conf: high
- [ ] `sum_range_two_k_add_three_div_prod_sq` — The sum of (2k+1)/((k+1)²(k+2)) for k from 0 to n-1 telescopes to 1 − (n+1)/((n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term decomposes as a difference of 1/(k+1) and (k+1)/((k+1)(k+2)) style terms, field_simp + ring · conf: high
- [x] `prod_icc_one_sub_recip_sq_eq_frac` — The product of (k²−1)/k² for k from 2 to n equals (n+1)/(2n)
      absence: no-local-match · triviality: non-trivial · intended: Induction; factor k²−1 = (k−1)(k+1) and telescope the two linear chains, field_simp + ring · conf: high
- [x] `sum_range_recip_five_step_product` — The sum of 1/((5k+2)(5k+7)) for k from 0 to n-1 equals n/(2(5n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term ⅕[1/(5k+2) − 1/(5k+7)], field_simp then ring · conf: high
- [x] `prod_icc_one_add_recip_eq_succ` — The product of (2k+1)/(2k−1) for k from 1 to n equals 2n+1
      absence: no-local-match · triviality: non-trivial · intended: Induction from n=1; the numerator/denominator chain telescopes leaving the final numerator 2n+1, field_simp + ring · conf: high
- [ ] `sum_range_recip_prod_step_three_offset` — The sum of 3/((k+1)(k+4)) for k from 0 to n-1 equals (1+½+⅓) minus (1/(n+1)+1/(n+2)+1/(n+3))
      absence: no-local-match · triviality: non-trivial · intended: Induction; per-term 3/((k+1)(k+4)) = 1/(k+1) − 1/(k+4), a three-step telescope, field_simp + ring on the residual · conf: med

### Replenishment round 2 (scoped 2026-06-15) — 21 candidates

- [ ] `sum_range_recip_three_consec_shifted` — The sum of 1/((k+1)(k+2)(k+3)) over the first n terms equals n(n+3)/(4(n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then clear denominators and ring (partial-fraction telescope 1/2[1/((k+1)(k+2)) - 1/((k+2)(k+3))]) · conf: high
- [ ] `sum_range_recip_four_consec_product` — The sum of 1/((k+1)(k+2)(k+3)(k+4)) over the first n terms equals 1/18 minus 1/(3(n+1)(n+2)(n+3))
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; the summand is the difference 1/3[1/((k+1)(k+2)(k+3)) - 1/((k+2)(k+3)(k+4))], finish with field_simp and ring · conf: high
- [ ] `sum_range_k_div_succ_factorial_telescope` — The sum of k/(k+1)! over the first n terms equals 1 minus 1/n!
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; summand k/(k+1)! = 1/k! - 1/(k+1)!, use Nat.factorial_succ and the cast of factorials being positive, then field_simp/ring · conf: high
- [ ] `sum_range_k_sub_one_div_factorial_telescope` — Reserved-shape variant: a factorial telescope whose summand (k-1)/(k+1)! collapses to a boundary term
      absence: no-local-match · triviality: non-trivial · intended: Induction; rewrite (k-1)/(k+1)! as 1/(k+1)! difference shifted, but state via Icc 1 n form below; keep as factorial telescope distinct from k/(k+1)! · conf: high
- [ ] `sum_icc_k_sub_one_div_factorial_eq_one_sub` — For n at least 1, the sum of (k-1)/k! for k from 1 to n equals 1 minus 1/n!
      absence: no-local-match · triviality: non-trivial · intended: Induction on n from base 1 using Finset.sum_Icc_succ_top; summand (k-1)/k! = 1/(k-1)! - 1/k!, telescopes; field_simp with factorial positivity then ring · conf: high
- [ ] `sum_icc_k_sq_add_one_mul_factorial_eq_prod` — The sum of (k^2+1)·k! for k from 1 to n equals n·(n+1)!
      absence: no-local-match · triviality: non-trivial · intended: Induction on n via Finset.sum_Icc_succ_top; use (k^2+1)k! = k(k+1)! - (k-1)k! telescope, or directly expand Nat.factorial_succ and ring_nf on naturals (Nat.succ arithmetic) · conf: high
- [ ] `sum_range_k_mul_succ_mul_two_pow_closed` — The sum of k(k+1)2^k over the first n terms equals (n^2-3n+4)2^n minus 4
      absence: no-local-match · triviality: non-trivial · intended: Work in ℤ to avoid Nat subtraction (state with integer coercions); induction on n with Finset.sum_range_succ, expand pow_succ, ring. NOTE: cast to ℤ in actual sig · conf: med
- [ ] `sum_range_k_mul_succ_mul_three_pow_closed` — Four times the sum of k(k+1)3^k over the first n terms equals (2n^2-4n+3)3^n minus 3
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ in ℤ, rewrite 3^(k+1)=3·3^k via pow_succ, then ring closes the inductive step · conf: med
- [ ] `sum_range_two_k_add_one_div_two_pow_closed` — The sum of (2k+1)/2^k over the first n terms equals 6 minus (4n+6)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; rewrite 2^(k+1)=2·2^k (pow_succ), field_simp using 2^k ≠ 0, then ring · conf: high
- [ ] `sum_range_two_pow_div_fermat_product_telescope` — The sum of 2^k/((2^k+1)(2^{k+1}+1)) over the first n terms equals 1/2 minus 1/(2^n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; summand equals 1/(2^k+1) - 1/(2^{k+1}+1) via 2^{k+1}=2·2^k, field_simp with positivity of 2^k+1, then ring · conf: med
- [ ] `sum_range_three_pow_div_product_telescope` — The sum of 3^k/((3^k+1)(3^{k+1}+1)) over the first n terms equals 1/4 minus 1/(2(3^n+1))
      absence: no-local-match · triviality: non-trivial · intended: Induction; summand = 1/2[1/(3^k+1) - 1/(3^{k+1}+1)] using 3^{k+1}=3·3^k; field_simp with 3^k+1 > 0 then ring · conf: med
- [ ] `sum_icc_k_div_quartic_sophie_germain_telescope` — For n at least 1, the sum of k/(k^4+k^2+1) for k from 1 to n equals n(n+1)/(2(n^2+n+1))
      absence: no-local-match · triviality: non-trivial · intended: Use the Sophie-Germain factorization k^4+k^2+1=(k^2-k+1)(k^2+k+1) so the summand telescopes as 1/2[1/(k^2-k+1) - 1/(k^2+k+1)]; induction on n with field_simp and ring · conf: med
- [ ] `sum_icc_recip_k_sq_sub_one_telescope` — For n at least 2, the sum of 1/(k^2-1) for k from 2 to n equals 3/4 minus (2n+1)/(2n(n+1))
      absence: no-local-match · triviality: non-trivial · intended: k^2-1=(k-1)(k+1) so summand = 1/2[1/(k-1) - 1/(k+1)]; induction from base 2 with Finset.sum_Icc_succ_top, field_simp, ring · conf: high
- [ ] `sum_range_recip_three_consec_odd_telescope` — The sum of 1/((2k+1)(2k+3)(2k+5)) over the first n terms equals 1/12 minus 1/(4(2n+1)(2n+3))
      absence: no-local-match · triviality: non-trivial · intended: Summand = 1/4[1/((2k+1)(2k+3)) - 1/((2k+3)(2k+5))]; induction with Finset.sum_range_succ, field_simp on positive odd factors, ring · conf: high
- [ ] `sum_icc_cube_diff_recip_telescope` — For n at least 1, the sum of (3k^2+3k+1)/(k^3(k+1)^3) for k from 1 to n equals 1 minus 1/(n+1)^3
      absence: no-local-match · triviality: non-trivial · intended: Summand = 1/k^3 - 1/(k+1)^3 since (k+1)^3-k^3 = 3k^2+3k+1; induction from base 1, field_simp with k>0, ring · conf: high
- [ ] `prod_icc_cube_sub_one_div_cube_add_one_telescope` — For n at least 2, the product of (k^3-1)/(k^3+1) for k from 2 to n equals 2(n^2+n+1)/(3n(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Factor k^3-1=(k-1)(k^2+k+1) and k^3+1=(k+1)(k^2-k+1); since k^2+k+1=(k+1)^2-(k+1)+1 the quadratic factors telescope. Induction from base 2 with Finset.prod_Icc_succ_top, field_simp, ring · conf: med
- [ ] `prod_icc_one_add_recip_k_sq_add_two_k_telescope` — For n at least 1, the product of (1 + 1/(k^2+2k)) for k from 1 to n equals 2(n+1)/(n+2)
      absence: no-local-match · triviality: non-trivial · intended: 1+1/(k(k+2)) = (k+1)^2/(k(k+2)); the squares telescope as a ratio. Induction from base 1 with Finset.prod_Icc_succ_top, field_simp with k>0, ring · conf: high
- [ ] `sum_range_succ_div_factorial_add_two_telescope` — The sum of (k+1)/(k+2)! over the first n terms equals 1 minus 1/(n+1)!
      absence: no-local-match · triviality: non-trivial · intended: Summand (k+1)/(k+2)! = 1/(k+1)! - 1/(k+2)!; induction with Finset.sum_range_succ, Nat.factorial_succ rewrites, field_simp on positive factorials, ring · conf: high
- [ ] `prod_icc_k_mul_add_two_div_succ_sq_telescope` — For n at least 1, the product of k(k+2)/(k+1)^2 for k from 1 to n equals (n+2)/(2(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Write k(k+2)/(k+1)^2 = (k/(k+1))·((k+2)/(k+1)); the two telescoping ratios collapse. Induction from base 1 with Finset.prod_Icc_succ_top, field_simp, ring · conf: high
- [ ] `sum_icc_recip_km1_k_kp1_telescope` — For n at least 2, the sum of 1/((k-1)k(k+1)) for k from 2 to n equals 1/4 minus 1/(2n(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Summand = 1/2[1/((k-1)k) - 1/(k(k+1))]; induction from base 2 with Finset.sum_Icc_succ_top, field_simp with k≥2, ring · conf: high
- [ ] `prod_icc_one_add_recip_k_sq_sub_one_telescope` — For n at least 2, the product of (1 + 1/(k^2-1)) for k from 2 to n equals 2n/(n+1)
      absence: no-local-match · triviality: non-trivial · intended: 1+1/(k^2-1) = k^2/((k-1)(k+1)); writing it as (k/(k-1))·(k/(k+1)) the ratios telescope. Induction from base 2 with Finset.prod_Icc_succ_top, field_simp, ring · conf: high
