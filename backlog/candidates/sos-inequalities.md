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
- [ ] `sumsq_ge_ab_plus_bc` — The sum of three squares dominates the two adjacent cross terms ab+bc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg b (asymmetric weighting) · conf: high
- [ ] `cheb_cube_ge_third_sum_times_sumsq` — Chebyshev's sum inequality on cubes: 3(a^3+b^3+c^3) is at least (a+b+c)(a^2+b^2+c^2) for nonnegatives
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg (add_nonneg ...) and sq_nonneg (a-b) times (a+b) terms · conf: med
- [ ] `quartic_sum_ge_cyclic_cube_cross` — The sum of fourth powers dominates the cyclic sum a^3 b + b^3 c + c^3 a for all reals
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-a*b), sq_nonneg (a*b-b^2), and cyclic shifts · conf: med
- [ ] `quad_form_ge_three_quarter_sq` — The quadratic form a^2+ab+b^2 is at least three quarters of (a+b)^2
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b); equivalent to (a-b)^2/4 >= 0 · conf: high
- [ ] `three_quartic_sum_ge_sumsq_sq` — Three times the sum of fourth powers dominates the square of the sum of squares (QM-AM on squares)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2) · conf: high
- [ ] `sumsq_times_sum_recip_sq_ge_nine` — The product of the sum of squares and the sum of reciprocal squares is at least nine (Cauchy-Schwarz form)
      absence: no-local-match · triviality: non-trivial · intended: field_simp then nlinarith with sq_nonneg (a^2-b^2) over the cleared form, using a^2>0 · conf: med
- [ ] `quartic_four_var_ge_four_prod` — The sum of four fourth powers dominates 4abcd, the four-variable AM-GM on fourth powers
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a^2-b^2), sq_nonneg (c^2-d^2), sq_nonneg (a*b-c*d) · conf: med
- [ ] `sym_grouped_deg_three_ge_six_abc` — For nonnegatives the grouped symmetric degree-three form a^2(b+c)+... is at least 6abc
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg ha (sq_nonneg (b-c)) and cyclic AM-GM pair hints · conf: high
- [ ] `five_var_qm_am` — The square of a five-term sum is at most five times the sum of the five squares (QM-AM, five variables)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg of all ten pairwise differences (a-b),(a-c),...,(d-e) · conf: high
- [ ] `two_cube_sum_ge_sum_times_sumsq` — For nonnegative reals twice the sum of cubes dominates (a+b)(a^2+b^2)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg (add_nonneg ha hb) (sq_nonneg (a-b)); it is (a+b)(a-b)^2 >= 0 · conf: high
- [ ] `abc_nine_le_sum_times_pairsum` — For nonnegative reals nine times abc is at most (a+b+c)(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with mul_nonneg hc (sq_nonneg (a-b)) and cyclic Schur-style hints · conf: high
- [ ] `sum_sq_over_pair_ge_half_sum` — For positive reals the sum of a^2/(b+c) is at least half of a+b+c (Engel/Titu form)
      absence: no-local-match · triviality: non-trivial · intended: clear denominators with field_simp using b+c>0 etc, then nlinarith with sq_nonneg (a-b) products · conf: med
- [ ] `sumsq_plus_two_abc_plus_one_ge_two_pairsum` — For nonnegative reals a^2+b^2+c^2+2abc+1 is at least 2(ab+bc+ca)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b), mul_nonneg, and the known a^2+b^2+c^2+2abc+1>=2(ab+bc+ca) SOS-with-constraint witness · conf: med
- [ ] `apmo_product_ge_nine_pairsum` — For all reals the product (a^2+2)(b^2+2)(c^2+2) is at least 9(ab+bc+ca) (APMO 2004)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a*b-1), sq_nonneg (a-b), sq_nonneg (a*b*c-...) and degree-6 SOS hints · conf: med
