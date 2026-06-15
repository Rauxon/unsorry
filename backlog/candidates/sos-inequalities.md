# Classical 2–3 variable SOS inequalities — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 20 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [ ] `schur_inequality_deg_one` — Schur's inequality of degree one: the symmetric sum a(a-b)(a-c)+b(b-c)(b-a)+c(c-a)(c-b) is nonnegative for nonnegative reals
      absence: no-local-match · triviality: non-trivial · intended: WLOG-free nlinarith with sq_nonneg and mul_nonneg products of the (a-b),(b-c),(c-a) differences · conf: med
- [ ] `schur_deg_one_expanded` — Expanded Schur degree-one form: the sum of cubes plus 2abc dominates the cyclic sum ab(a+b)+bc(b+c)+ca(c+a)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b) etc. weighted by a,b,c via mul_nonneg · conf: med
- [ ] `ravi_amgm_product_le` — Under triangle-like nonnegativity of the Ravi substitutions, the product (a+b-c)(b+c-a)(c+a-b) is at most abc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b),(b-c),(c-a) and mul_nonneg of the hypotheses · conf: med
- [x] `sum_recip_times_sum_ge_nine` — For positive reals, (a+b+c)(1/a+1/b+1/c) is at least 9 (Cauchy-Schwarz / AM-HM corollary)
      absence: no-local-match · triviality: non-trivial · intended: clear denominators via field_simp, then nlinarith with sq_nonneg of pairwise differences · conf: high
- [ ] `cyclic_square_times_ge_product_sum` — The product of the sum of squares and the pairwise-product sum dominates 3abc(a+b+c)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg combinations and mul_nonneg a,b,c times sq_nonneg differences · conf: med
- [x] `cyclic_quad_ge_abc_times_sum` — The sum of squared pairwise products dominates abc(a+b+c) for all reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a*b - b*c), sq_nonneg (b*c - c*a), sq_nonneg (c*a - a*b) · conf: high
- [ ] `power_mean_cube_three_var` — For nonnegative reals, the cube of the sum is at most nine times the sum of cubes
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg of a,b,c against sq_nonneg of pairwise differences · conf: med
- [x] `sum_sq_ge_third_sq_sum` — The mean-square form: one third of the squared sum is at most the sum of squares (QM-AM in fractional form)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a) · conf: high
- [x] `amgm_four_cross_three_var` — The sum of fourth powers dominates the sum of squared pairwise products
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2 - b^2), sq_nonneg (b^2 - c^2), sq_nonneg (c^2 - a^2) · conf: high
- [x] `tangent_line_cube_trick` — The tangent-line bound at x=1 for the cube: 3x is at most x cubed plus two for nonnegative x
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (x-1) and mul_nonneg hx (sq_nonneg (x-1)) to capture the (x-1)^2(x+2) factorisation · conf: high
- [x] `amgm_prod_half_sum_le_cubes` — Twice ab(a+b) is at most twice the sum of cubes for nonnegative reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg ha hb and mul_nonneg (add_nonneg ha hb) (sq_nonneg (a-b)) · conf: high
- [ ] `two_var_quartic_mixed_sos` — A mixed quartic SOS bound: 6a^2b^2 is dominated by a^4+b^4 plus twice the mixed cubic cross terms
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (a+b), and sq_nonneg (a^2 - b^2) · conf: med
- [x] `sos_weighted_three_one_two` — A weighted AM-GM cubic: 3a^2b is at most 2a^3 plus 2b^3 for nonnegative reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg and sq_nonneg (a-b) scaled by nonneg a and b · conf: high
- [ ] `amgm_ratio_cycle_ge_three` — For positive reals the cyclic ratio sum a/b+b/c+c/a is at least three
      absence: no-local-match · triviality: non-trivial · intended: field_simp to clear denominators, then nlinarith with sq_nonneg differences and product positivity · conf: med
- [ ] `sum_sq_over_cycle_ge_sum` — The cyclic Engel-form sum a^2/b+b^2/c+c^2/a is at least a+b+c for positive reals
      absence: no-local-match · triviality: non-trivial · intended: field_simp then nlinarith with sq_nonneg (a-b),(b-c),(c-a) times positive denominators · conf: med
- [x] `pairwise_product_sum_sq_ge_three_abc_sum` — The square of the pairwise-product sum dominates 3abc(a+b+c)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a*b - b*c), sq_nonneg (b*c - c*a), sq_nonneg (c*a - a*b) · conf: high
- [ ] `cyclic_cube_cross_le_quartic_sum` — For nonnegative reals the cyclic cubic-cross sum is dominated by the sum of fourth powers
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2 - a*b) style hints plus sq_nonneg of differences scaled by nonneg vars · conf: med
- [ ] `cyclic_square_cross_le_cube_sum` — For nonnegative reals the cyclic squared-cross sum is at most the sum of cubes
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg ha (sq_nonneg (a-b)) and the two cyclic analogues · conf: med
- [x] `shifted_sum_sq_ge_twice_sum_three_var` — Each variable's square plus one dominates twice the variable, summed over three variables
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-1), sq_nonneg (b-1), sq_nonneg (c-1) · conf: high
- [ ] `amgm_prod_le_cube_of_third_sum` — The three-variable AM-GM in cube form: 27abc is at most the cube of the sum for nonnegative reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg products of a,b,c against sq_nonneg pairwise differences (Schur-assisted SOS) · conf: med

### Replenishment round 2 (scoped 2026-06-15) — 20 candidates

- [ ] `schur_deg_one_three_var` — Schur's inequality of degree one: for nonnegative reals the cyclic sum a(a-b)(a-c) is nonnegative
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg on (a-b)^2 etc and case structure; supply sq_nonneg (a-b), mul_nonneg ha hb hints · conf: med
- [ ] `sumsq_sq_ge_three_cyclic_cube_cross` — The square of the sum of squares dominates three times the cyclic sum a^3 b + b^3 c + c^3 a (IMO 2006 form)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg of the asymmetric combinations (a^2-b^2-a*b+a*c+...) — the SOS witness is nontrivial · conf: med
- [ ] `sum_sq_div_cyclic_ge_sum` — For positive reals the cyclic sum of a^2/b is at least a+b+c
      absence: no-local-match · triviality: non-trivial · intended: clear denominators via div_add_div and field_simp, then nlinarith with sq_nonneg (a-b) etc · conf: med
- [ ] `prod_pair_sums_ge_eight_ninths` — For nonnegative reals the product of pairwise sums is at least 8/9 of (a+b+c)(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: expand both sides, nlinarith with mul_nonneg hints and sq_nonneg of differences · conf: med
- [ ] `quartic_sum_ge_abc_sum` — The sum of fourth powers dominates abc times the sum a+b+c for all reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (a*b-b*c), sq_nonneg (a^2-a*b) family · conf: med
- [ ] `pair_sum_sq_ge_three_abc_sum` — The square of the elementary symmetric sum ab+bc+ca is at least 3abc(a+b+c) for all reals (Newton/Maclaurin)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a*b-b*c), sq_nonneg (b*c-c*a), sq_nonneg (c*a-a*b) · conf: high
- [x] `sumsq_ge_ab_plus_bc` — The sum of three squares dominates the two adjacent cross terms ab+bc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg b (asymmetric weighting) · conf: high
- [ ] `cheb_cube_ge_third_sum_times_sumsq` — Chebyshev's sum inequality on cubes: 3(a^3+b^3+c^3) is at least (a+b+c)(a^2+b^2+c^2) for nonnegatives
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg (add_nonneg ...) and sq_nonneg (a-b) times (a+b) terms · conf: med
- [ ] `quartic_sum_ge_cyclic_cube_cross` — The sum of fourth powers dominates the cyclic sum a^3 b + b^3 c + c^3 a for all reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-a*b), sq_nonneg (a*b-b^2), and cyclic shifts · conf: med
- [x] `quad_form_ge_three_quarter_sq` — The quadratic form a^2+ab+b^2 is at least three quarters of (a+b)^2
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b); equivalent to (a-b)^2/4 >= 0 · conf: high
- [x] `three_quartic_sum_ge_sumsq_sq` — Three times the sum of fourth powers dominates the square of the sum of squares (QM-AM on squares)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2) · conf: high
- [ ] `sumsq_times_sum_recip_sq_ge_nine` — The product of the sum of squares and the sum of reciprocal squares is at least nine (Cauchy-Schwarz form)
      absence: no-local-match · triviality: non-trivial · intended: field_simp then nlinarith with sq_nonneg (a^2-b^2) over the cleared form, using a^2>0 · conf: med
- [ ] `quartic_four_var_ge_four_prod` — The sum of four fourth powers dominates 4abcd, the four-variable AM-GM on fourth powers
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (c^2-d^2), sq_nonneg (a*b-c*d) · conf: med
- [x] `sym_grouped_deg_three_ge_six_abc` — For nonnegatives the grouped symmetric degree-three form a^2(b+c)+... is at least 6abc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg ha (sq_nonneg (b-c)) and cyclic AM-GM pair hints · conf: high
- [x] `five_var_qm_am` — The square of a five-term sum is at most five times the sum of the five squares (QM-AM, five variables)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg of all ten pairwise differences (a-b),(a-c),...,(d-e) · conf: high
- [x] `two_cube_sum_ge_sum_times_sumsq` — For nonnegative reals twice the sum of cubes dominates (a+b)(a^2+b^2)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg (add_nonneg ha hb) (sq_nonneg (a-b)); it is (a+b)(a-b)^2 >= 0 · conf: high
- [x] `abc_nine_le_sum_times_pairsum` — For nonnegative reals nine times abc is at most (a+b+c)(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg hc (sq_nonneg (a-b)) and cyclic Schur-style hints · conf: high
- [ ] `sum_sq_over_pair_ge_half_sum` — For positive reals the sum of a^2/(b+c) is at least half of a+b+c (Engel/Titu form)
      absence: no-local-match · triviality: non-trivial · intended: clear denominators with field_simp using b+c>0 etc, then nlinarith with sq_nonneg (a-b) products · conf: med
- [ ] `sumsq_plus_two_abc_plus_one_ge_two_pairsum` — For nonnegative reals a^2+b^2+c^2+2abc+1 is at least 2(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), mul_nonneg, and the known a^2+b^2+c^2+2abc+1>=2(ab+bc+ca) SOS-with-constraint witness · conf: med
- [ ] `apmo_product_ge_nine_pairsum` — For all reals the product (a^2+2)(b^2+2)(c^2+2) is at least 9(ab+bc+ca) (APMO 2004)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a*b-1), sq_nonneg (a-b), sq_nonneg (a*b*c-...) and degree-6 SOS hints · conf: med

### Replenishment round 3 (scoped 2026-06-15) — 20 candidates

- [ ] `sumsq_products_ge_abc_times_sum` — The sum of squared pairwise products of three reals is at least the product abc times their sum
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a*b-b*c), sq_nonneg (b*c-c*a), sq_nonneg (c*a-a*b)] · conf: high
- [ ] `pairsum_sq_ge_three_abc_sum` — The square of the sum of pairwise products is at least three times abc times the sum a+b+c
      absence: no-local-match · triviality: non-trivial · intended: expand and reduce to a*b*c*(a+b+c) ≤ sum of squared products; nlinarith with sq_nonneg of product differences · conf: high
- [ ] `three_quartic_sum_ge_sumsq_squared` — The square of the sum of three squares is at most three times the sum of their fourth powers
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2)] · conf: high
- [ ] `quartic_sum_ge_abc_times_sum` — The sum of fourth powers of three reals dominates abc times their sum a+b+c
      absence: no-local-match · triviality: non-trivial · intended: chain a^4+b^4+c^4 ≥ a^2b^2+b^2c^2+c^2a^2 ≥ abc(a+b+c); nlinarith with sq_nonneg of squared differences and product differences · conf: high
- [ ] `cyclic_cube_sum_ge_asym_quad_cubic` — For nonnegative reals the sum of cubes dominates the cyclic sum a^2 b + b^2 c + c^2 a
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg products and sq_nonneg (a-b),(b-c),(c-a) weighted by the variables · conf: high
- [ ] `cyclic_quartic_ge_asym_cubic_cross` — For nonnegative reals the sum of fourth powers dominates the cyclic sum a^3 b + b^3 c + c^3 a
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg products and sq_nonneg of squared differences scaled appropriately · conf: high
- [ ] `amgm_three_cube_twentyseven` — For nonnegative reals the cube of the sum a+b+c is at least 27 times the product abc (AM-GM)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [mul_nonneg ha (sq_nonneg (b-c)), mul_nonneg hb (sq_nonneg (c-a)), mul_nonneg hc (sq_nonneg (a-b)), mul_nonneg (mul_nonneg ha hb) hc] · conf: high
- [ ] `schur_deg_two_three_var` — The degree-one Schur inequality: the sum of cubes plus 3abc dominates the symmetric sum of ab(a+b) terms
      absence: no-local-match · triviality: non-trivial · intended: WLOG-free nlinarith using mul_nonneg of each variable with the square of the difference of the other two, plus sq_nonneg hints · conf: med
- [ ] `constrained_sum_le_sumsq_prod_one` — If three positive reals have product 1 then their sum of squares is at least their sum
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a), sq_nonneg (a+b+c-3), mul_pos hb hc, ...] using a+b+c ≥ 3 from AM-GM · conf: high
- [x] `constrained_pairsum_le_three_sum_three` — If three reals sum to 3 then their pairwise product sum is at most 3
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a)] using (a+b+c)^2 ≥ 3(ab+bc+ca) · conf: high
- [ ] `constrained_prod_le_sum_cubes_third` — Among nonnegative reals summing to 1 the product abc is at most 1/27
      absence: no-local-match · triviality: non-trivial · intended: reduce to 27abc ≤ (a+b+c)^3 = 1; nlinarith with mul_nonneg of each variable times square of difference of the others · conf: high
- [ ] `tangent_line_cyclic_fraction_ge_sum` — For positive reals the cyclic sum a^2/b + b^2/c + c^2/a is at least a+b+c
      absence: no-local-match · triviality: non-trivial · intended: tangent-line bound a^2/b ≥ 2a-b via le_div_iff₀ and sq_nonneg (a-b), summed cyclically with linarith · conf: med
- [x] `two_var_sq_add_one_ge_cross_plus_sum` — For any two reals a^2+b^2+1 is at least ab + a + b
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (a-1), sq_nonneg (b-1)] · conf: high
- [ ] `cauchy_schwarz_three_var_product` — The three-variable Cauchy-Schwarz inequality in product form
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a*y-b*x), sq_nonneg (b*z-c*y), sq_nonneg (a*z-c*x)] (Lagrange identity SOS) · conf: high
- [ ] `two_var_sixth_ge_mixed_fourth_second` — For any two reals the sum of sixth powers dominates the mixed terms a^4 b^2 + a^2 b^4
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [mul_nonneg (sq_nonneg a) (mul_nonneg (sq_nonneg (a-b)) ...)] ; sq_nonneg (a-b) scaled by a^2,b^2 and sq_nonneg (a^2-b^2)*? · conf: high
- [ ] `four_var_cyclic_cross_le_sumsq` — The sum of four squares dominates the cyclic cross sum ab+bc+cd+da
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-d), sq_nonneg (d-a)] · conf: high
- [ ] `prod_pair_sums_ge_eight_ninths_sum_prod` — For nonnegative reals the product (a+b)(b+c)(c+a) is at least 8/9 times (a+b+c)(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: expand both sides; nlinarith with mul_nonneg of each variable times square of difference of other two (Schur-like SOS) · conf: med
- [ ] `weighted_sos_two_var_three_one` — For any two reals 4 a^3 b is at most 3 a^4 + b^4 (weighted AM-GM as SOS)
      absence: no-local-match · triviality: non-trivial · intended: le_div_iff₀ then nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (a^2-a*b), mul_nonneg (sq_nonneg a) (sq_nonneg (a-b))] · conf: high
- [ ] `sumsq_product_ge_cube_cross_three_var` — A symmetric degree-four inequality bounding the sum of a^3 b style cross terms
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg products and sq_nonneg (a^2-b^2),(b^2-c^2),(c^2-a^2) plus squares of (a-b) scaled by squares · conf: med
- [x] `constrained_sum_sq_ge_one_third` — If three reals sum to 1 then their sum of squares is at least 1/3
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a)] using QM-AM with the constraint substituted · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 20 candidates

- [ ] `sum_fourth_ge_abc_times_sum` — For all reals, the sum of fourth powers is at least the product of the three numbers times their sum
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2), sq_nonneg (a*b-b*c), etc · conf: high
- [ ] `pairsum_sq_le_three_sum_sq_products` — The square of the sum of pairwise products is at most three times the sum of squared pairwise products
      absence: no-local-match · triviality: non-trivial · intended: Cauchy–Schwarz / SOS: nlinarith with sq_nonneg (a*b-b*c), sq_nonneg (b*c-c*a), sq_nonneg (c*a-a*b) · conf: high
- [ ] `sum_cubes_sq_le_three_sum_sixth` — The square of the sum of cubes is at most three times the sum of sixth powers
      absence: no-local-match · triviality: non-trivial · intended: power-mean/Cauchy–Schwarz: nlinarith with sq_nonneg (a^3-b^3), sq_nonneg (b^3-c^3), sq_nonneg (c^3-a^3) · conf: high
- [ ] `sum_cubes_ge_cyclic_mixed` — For nonnegative reals, the sum of cubes dominates the cyclic sum a·b²+b·c²+c·a²
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg of each variable against sq_nonneg of the relevant difference, e.g. a*(a-b)^2 ≥ 0 · conf: high
- [ ] `sum_sq_products_ge_abc_times_sum` — The sum of squared pairwise products is at least the product abc times the sum a+b+c
      absence: no-local-match · triviality: non-trivial · intended: SOS: nlinarith with sq_nonneg (a*b-b*c), sq_nonneg (b*c-c*a), sq_nonneg (c*a-a*b) · conf: high
- [ ] `weighted_amgm_two_cubes_ge_sq` — For nonnegative reals, twice a-cubed plus b-cubed is at least three times a²b (weighted AM-GM)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg ha (sq_nonneg (a-b)), mul_nonneg hb (sq_nonneg (a-b)) · conf: high
- [ ] `sum_cubes_ge_cyclic_sq_prod` — For nonnegative reals, the sum of cubes dominates the cyclic sum a²·b+b²·c+c²·a
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg b (sq_nonneg (a-b)) style terms plus the AM-GM weighted hints · conf: high
- [ ] `engel_cyclic_sq_div_ge_sum` — For positive reals, the cyclic sum a²/b+b²/c+c²/a is at least a+b+c (Engel/Cauchy–Schwarz form)
      absence: no-local-match · triviality: non-trivial · intended: clear denominators via div_add_div and rw [ge_iff_le, div_le_iff]; then nlinarith with sq_nonneg (a-b) etc. weighted by positivity · conf: high
- [ ] `quad_diff_form_ge_half_sumsq` — For all reals, a²−ab+b² is at least half the sum of the two squares
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b); rewrite as a^2 - 2ab + b^2 ≥ 0 scaled · conf: high
- [ ] `three_sum_quartic_ge_sum_times_cubes` — For nonnegative reals, three times the sum of fourth powers dominates (a+b+c) times the sum of cubes (Chebyshev sum inequality)
      absence: no-local-match · triviality: non-trivial · intended: Chebyshev: nlinarith with mul_nonneg over (a-b)*(a^3-b^3) ≥ 0 pairs and sq_nonneg hints · conf: high
- [ ] `asym_weighted_sumsq_ge_cross` — The asymmetric weighted sum a²+2b²+2c² dominates 2ab+2bc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg c · conf: high
- [ ] `sum_sixth_ge_cyclic_quartic_sq` — For all reals, the sum of sixth powers dominates the cyclic sum a⁴b²+b⁴c²+c⁴a²
      absence: no-local-match · triviality: non-trivial · intended: AM-GM on squares: nlinarith with sq_nonneg (a^3-a*b^2) family, or treat as cyclic a^2,b^2,c^2 rearrangement with sq_nonneg hints on a^2*(a^2-b^2) · conf: high
- [ ] `sum_cube_le_nine_sum_cubes` — For nonnegative reals, the cube of the sum is at most nine times the sum of cubes (power-mean)
      absence: no-local-match · triviality: non-trivial · intended: power-mean: nlinarith with mul_nonneg over a*(a-b)^2, b*(b-c)^2, c*(c-a)^2 and symmetric terms · conf: high
- [ ] `abc_le_third_sum_cubes` — For nonnegative reals, the product abc is at most one third the sum of cubes (AM-GM on cubes)
      absence: no-local-match · triviality: non-trivial · intended: AM-GM: nlinarith with mul_nonneg-weighted sq_nonneg hints, e.g. (a+b+c)*((a-b)^2+(b-c)^2+(c-a)^2) ≥ 0 · conf: high
- [ ] `sumsq_sq_ge_three_cyclic_cube_cross_rev` — For all reals, the square of the sum of squares is at least three times the reverse-cyclic sum a³c+b³a+c³b
      absence: no-local-match · triviality: non-trivial · intended: mirror SOS of the forward case: nlinarith with sq_nonneg (a^2 - a*c + b*c - b^2)-style cyclic hint vectors · conf: med
- [ ] `quad_diff_form_ge_quarter_sq_sum` — For all reals, a²−ab+b² is at least one quarter of (a+b)²
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b); note a^2-ab+b^2 - (a+b)^2/4 = 3/4 (a-b)^2 · conf: high
- [ ] `asym_sumsq_ge_two_cross` — For all reals, the sum of three squares dominates ab+bc (a non-cyclic two-term cross sum)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg c — the missing c² slack term is essential · conf: high
- [ ] `sumsq_plus_sq_sum_ge_four_pairsum` — For all reals, the sum of squares plus the square of the sum is at least four times the sum of pairwise products
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a) after expanding (a+b+c)^2 · conf: high
- [ ] `weighted_five_sumsq_ge_eight_cross` — For all reals, five times the sum of the two squares is at least eight times their product
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b) and sq_nonneg (a+b); 5a^2-8ab+5b^2 = 4(a-b)^2 + (a-... ) · conf: high
- [ ] `sum_quartic_ge_sum_sq_products` — For all reals, the sum of fourth powers dominates the sum of squared pairwise products
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2) · conf: high
