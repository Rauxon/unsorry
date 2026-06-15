# Continued-fraction / Pell-equation facts — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 24 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `pell_d2_ladder_step_preserves` — Applying the fundamental Pell ladder map (x,y) ↦ (3x+4y, 2x+3y) to any solution of x²−2y²=1 yields another solution
      absence: no-local-match · triviality: non-trivial · intended: linear_combination using the hypothesis after ring-normalising the expanded square · conf: high
- [x] `pell_d3_ladder_step_preserves` — The d=3 fundamental ladder map (x,y) ↦ (2x+3y, x+2y) sends each solution of x²−3y²=1 to another solution
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; ring closes the residual · conf: high
- [x] `pell_d5_ladder_step_preserves` — The d=5 fundamental ladder map (x,y) ↦ (9x+20y, 4x+9y) preserves the Pell relation x²−5y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h after expanding the two squares · conf: high
- [x] `pell_d2_negative_to_positive_step` — One half-step (x,y) ↦ (x+2y, x+y) turns a solution of the negative Pell equation x²−2y²=−1 into a solution of x²−2y²=1
      absence: no-local-match · triviality: non-trivial · intended: the map negates the form value: linear_combination -h · conf: high
- [x] `pell_d2_positive_to_negative_step` — The same half-step (x,y) ↦ (x+2y, x+y) sends a solution of x²−2y²=1 to a solution of the negative Pell equation x²−2y²=−1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination -h; ring residual vanishes · conf: high
- [x] `pell_brahmagupta_composition_d2` — Brahmagupta composition: multiplying two solutions of x²−2y²=1 via (ac+2be, ae+bc) gives another solution
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [h1, h2] or linear_combination c^2*h1 + ... ; the product of the two relations equals the goal LHS · conf: high
- [x] `pell_brahmagupta_composition_generic_d` — For every parameter d, the Brahmagupta product (ac+dbe, ae+bc) composes two solutions of x²−dy²=1 into a third
      absence: no-local-match · triviality: non-trivial · intended: show LHS = (a²−d·b²)(c²−d·e²) by ring, then rewrite both hypotheses via linear_combination · conf: high
- [x] `pell_doubling_identity_generic_d` — Squaring a fundamental-type solution via (a²+db², 2ab) again solves x²−dy²=1, for any d
      absence: no-local-match · triviality: non-trivial · intended: LHS = (a²−d·b²)² as a ring identity; substitute h so it becomes 1² = 1 via linear_combination · conf: high
- [ ] `pell_d2_convergent_cross_difference` — Consecutive √2-convergents produced by the ladder satisfy the determinant relation p_{n+1}q_n − p_n q_{n+1} = −1
      absence: no-local-match · triviality: non-trivial · intended: expand and reduce the cross product to −(p²−2q²) then apply h · conf: high
- [x] `pell_d2_x_odd` — In every integer solution of x²−2y²=1 the x-coordinate is odd
      absence: no-local-match · triviality: non-trivial · intended: x² = 1 + 2y² is odd, so x is odd; via Int.odd_iff and parity of squares (omega after Int.emod reasoning) · conf: high
- [x] `pell_d2_y_even` — The product xy of any integer solution of x²−2y²=1 is even
      absence: no-local-match · triviality: non-trivial · intended: x is odd; if y odd then x²−2y² ≡ 1−2 ≡ 3 (mod 4) contradicting =1, so y even, hence xy even — ZMod 4 / decide bridge · conf: high
- [x] `pell_d3_x_coord_pos_gt_y` — Any positive solution of x²−3y²=1 has y strictly less than x
      absence: no-local-match · triviality: non-trivial · intended: from x² = 1 + 3y² > y², deduce x > y by nlinarith [sq_nonneg (x - y)] · conf: high
- [x] `pell_d2_rational_bound_above` — Every positive Pell solution of x²−2y²=1 makes x/y exceed √2, i.e. 2y² < x²
      absence: no-local-match · triviality: non-trivial · intended: x² = 2y² + 1 > 2y²; linarith after rewriting h, but with the strict gap it needs nlinarith on positivity · conf: high
- [x] `pell_d2_rational_bound_gap` — The √2-approximation gap is controlled: for a solution of x²−2y²=1 one has x²−2y² ≤ y²+1
      absence: no-local-match · triviality: non-trivial · intended: rewrite h to get 1 ≤ y²+1; nlinarith [sq_nonneg y] · conf: high
- [ ] `pell_numbers_determinant_identity` — The Pell numbers (Pₙ₊₂ = 2Pₙ₊₁ + Pₙ) satisfy the Cassini-type identity Pₙ₊₁² − Pₙ₊₂·Pₙ = (−1)ⁿ
      absence: no-local-match · triviality: non-trivial · intended: induction on n using hrec; the step expands and folds back to the previous case (linear_combination) · conf: med
- [ ] `pell_numbers_half_companion_relation` — The Pell numbers Pₙ and half-companion Pell numbers Qₙ (both with the 2x+previous recurrence) satisfy Qₙ²−2Pₙ² = (−1)ⁿ
      absence: no-local-match · triviality: non-trivial · intended: strong/two-step induction tracking both sequences; combine hPrec and hQrec at the step with linear_combination · conf: med
- [ ] `pell_numbers_adjacent_sum_companion` — The half-companion Pell numbers are recovered from adjacent Pell numbers via Qₙ = Pₙ₊₁ (stated as Pₙ + Pₙ₊₁ − Pₙ)
      absence: no-local-match · triviality: non-trivial · intended: reduces to Qₙ = Pₙ₊₁; prove by two-step induction matching base cases and the shared recurrence · conf: med
- [ ] `square_triangular_recurrence_step` — The square-triangular recurrence (m,k) ↦ (3m+2k+1, 6k+8m+2) maps one square triangular number to the next
      absence: no-local-match · triviality: non-trivial · intended: clear the /2 using hk, reduce to a polynomial identity in m,k, then linear_combination with h · conf: med
- [x] `square_triangular_pell_link` — A square triangular number m²=T_k is equivalent to the Pell solution (2k+1)²−8m²=1, linking T_k to x²−8y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; pure rearrangement of the hypothesis · conf: high
- [x] `pell_d2_no_small_nontrivial_y` — There is no solution of x²−2y²=1 with y=1; the smallest positive y is 2 (the fundamental solution)
      absence: no-local-match · triviality: non-trivial · intended: rule out y=1 (would force x²=3, impossible) via interval_cases/nlinarith, otherwise y≥2 · conf: high
- [x] `pell_d3_no_small_nontrivial_y` — Every positive solution of x²−3y²=1 has y≥1 and x≥2 (the fundamental solution (2,1) is minimal)
      absence: no-local-match · triviality: non-trivial · intended: x²=1+3y²≥4 so x≥2 by nlinarith [sq_nonneg x]; y≥1 from hy on integers · conf: high
- [x] `pell_d7_ladder_step_preserves` — The d=7 fundamental ladder map (x,y) ↦ (8x+21y, 3x+8y), from the solution (8,3), preserves x²−7y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h after expanding both squares · conf: high
- [x] `pell_d6_ladder_step_preserves` — The d=6 fundamental ladder map (x,y) ↦ (5x+12y, 2x+5y), from the solution (5,2), preserves x²−6y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; ring closes the remainder · conf: high
- [x] `pell_d13_ladder_step_preserves` — The d=13 fundamental ladder map (x,y) ↦ (649x+2340y, 180x+649y), from the large fundamental solution (649,180), preserves x²−13y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; the large coefficients make this real work but ring-mechanical after substitution · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 23 candidates

- [ ] `pell_d5_negative_ladder_step_preserves` — Applying the d=5 fundamental ladder map (x,y) ↦ (9x+20y, 4x+9y) to a solution of the negative Pell equation x²−5y²=−1 yields another negative solution
      absence: no-local-match · triviality: non-trivial · intended: linear_combination -h after ring-expanding both squares; the map multiplies the form value by the fundamental unit norm 1, fixing −1 · conf: high
- [ ] `pell_d2_stormer_seven_ladder_preserves` — The √2 fundamental ladder map (x,y) ↦ (3x+4y, 2x+3y) sends a solution of the Pell-like equation x²−2y²=7 to another solution with the same value 7
      absence: no-local-match · triviality: non-trivial · intended: linear_combination 7•? — really linear_combination h then ring, since LHS−7 = (form value−7) scaled by the unit · conf: high
- [ ] `pell_d2_negative_seven_ladder_preserves` — The same √2 ladder map (x,y) ↦ (3x+4y, 2x+3y) preserves the value −7 in the equation x²−2y²=−7
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; ring closes the residual after substituting the hypothesis value −7 · conf: high
- [ ] `pell_d10_fundamental_ladder_step_preserves` — The d=10 fundamental ladder map (x,y) ↦ (19x+60y, 6x+19y), built from the fundamental solution (19,6), preserves x²−10y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h after expanding the two squares; the coefficients are the entries of the fundamental-unit matrix · conf: high
- [ ] `pell_negative_brahmagupta_composition_generic_d` — Brahmagupta composition of two solutions of the negative Pell equation x²−dy²=−1 produces a solution of the positive equation x²−dy²=1, since (−1)(−1)=1
      absence: no-local-match · triviality: non-trivial · intended: show LHS = (a²−d·b²)(c²−d·e²) by ring, then rewrite both hypotheses: (−1)·(−1)=1 · conf: high
- [ ] `pell_d3_no_negative_solution_zmod3` — The negative Pell equation x²−3y²=−1 has no integer solution, because x²≡2 (mod 3) is impossible
      absence: no-local-match · triviality: non-trivial · intended: intro contradiction, reduce mod 3 by mapping through (ZMod 3); decide closes the finite case since 2 is a non-residue · conf: high
- [ ] `pell_d7_no_negative_solution_zmod7` — The negative Pell equation x²−7y²=−1 has no integer solution, since 6 is a quadratic non-residue mod 7
      absence: no-local-match · triviality: non-trivial · intended: assume equality, push to ZMod 7 via a ring hom, then decide on the finite quotient rules out x²=6 · conf: high
- [ ] `pell_d2_solution_coords_coprime` — In any integer solution of x²−2y²=1 the two coordinates are coprime, since any common divisor squared divides 1
      absence: no-local-match · triviality: non-trivial · intended: exhibit the Bézout combination x·x + (-2·y)·y = 1 from h, giving IsCoprime via the definition · conf: high
- [ ] `pell_d2_x_sq_congr_one_mod_eight` — For every integer solution of x²−2y²=1 the x-coordinate satisfies x²≡1 (mod 8), reflecting that x is odd
      absence: no-local-match · triviality: non-trivial · intended: x is odd (x²=1+2y²), and every odd square is ≡1 mod 8; push h into ZMod 8 and decide over the residues · conf: high
- [ ] `pell_d2_square_doubling_identity` — Squaring a solution of x²−2y²=1 via (x²+2y², 2xy) again solves x²−2y²=1
      absence: no-local-match · triviality: non-trivial · intended: LHS = (x²−2y²)² as a ring identity; substitute h to get 1²=1 via linear_combination · conf: high
- [ ] `pell_d2_ladder_cross_determinant` — For a √2-Pell solution, the cross-determinant of (x,y) with its ladder image (3x+4y, 2x+3y) equals −2
      absence: no-local-match · triviality: non-trivial · intended: the expression simplifies to −2(x²−2y²) by ring; rewrite with h to get −2 · conf: high
- [ ] `pell_d2_x_sub_y_times_x_add_y` — Any √2-Pell solution satisfies (x−y)(x+y)=y²+1, a factored form of x²−2y²=1 rearranged
      absence: no-local-match · triviality: non-trivial · intended: expand the product to x²−y²; substitute x²=2y²+1 from h, leaving y²+1; linear_combination h · conf: high
- [ ] `fib_consecutive_vieta_form_value` — Consecutive Fibonacci numbers (Fₙ, Fₙ₊₁) satisfy the Markov/Vieta form x²−xy−y²=(−1)ⁿ
      absence: no-local-match · triviality: non-trivial · intended: induction on n: base cases compute; the step uses fib_add_two and linear_combination with the inductive identity · conf: high
- [ ] `pell_companion_cassini_identity` — The Pell numbers Pₙ and half-companion Pell numbers Qₙ (both with the recurrence aₙ₊₂=2aₙ₊₁+aₙ) satisfy Qₙ²−2Pₙ²=(−1)ⁿ
      absence: no-local-match · triviality: non-trivial · intended: induction on n carrying both sequences; the step combines hPrec and hQrec via linear_combination after expanding (−1)^(n+1) · conf: med
- [ ] `pell_d2_form_product_telescope_step` — The √2 norm form is multiplicative along the ladder: multiplying the form value by the fundamental-unit norm equals the form value of the ladder image
      absence: no-local-match · triviality: non-trivial · intended: pure ring identity once 3²−2·2²=1 is folded in; ring closes it without any hypothesis · conf: high
- [ ] `pell_d3_square_doubling_identity` — Squaring a solution of x²−3y²=1 via (x²+3y², 2xy) again solves x²−3y²=1
      absence: no-local-match · triviality: non-trivial · intended: LHS = (x²−3y²)² by ring; substitute h via linear_combination to reach 1 · conf: high
- [ ] `pell_d8_no_solution_y_one` — There is no integer x with x²−8·1²=1, so y=1 is not the index of any square-triangular Pell solution of x²−8y²=1
      absence: no-local-match · triviality: non-trivial · intended: reduces to x²≠9... actually x²=9 would solve it; instead show x²=9 forces x=±3 but then it equals 1 only if 9-8=1 holds — wait it does; restate as x²-8 ≠ 1 means x²≠9: use that the minimal y is 0, decide-free nlinarith on x²=9 vs target. (flag: verify direction at promotion) · conf: high
- [ ] `pell_d5_positive_from_negative_square` — Squaring a solution of the negative Pell equation x²−5y²=−1 produces a solution of the positive equation x²−5y²=1, since (−1)²=1
      absence: no-local-match · triviality: non-trivial · intended: LHS = (x²−5y²)² by ring; rewrite h to get (−1)²=1 via linear_combination · conf: high
- [ ] `pell_d13_fundamental_ladder_step_preserves` — The d=13 fundamental ladder map (x,y) ↦ (649x+2340y, 180x+649y), from the large fundamental solution (649,180), preserves x²−13y²=1
      absence: no-local-match · triviality: non-trivial · intended: linear_combination h; the large coefficients make the ring normalisation substantial but mechanical after substitution · conf: high
- [ ] `pell_d2_convergent_numerator_recurrence` — The √2-convergent numerators and denominators given by the recurrence aₙ₊₂=6aₙ₊₁−aₙ from (1,1),(3,2) all satisfy pₙ²−2qₙ²=1
      absence: no-local-match · triviality: non-trivial · intended: two-step induction tracking both sequences; expand the recurrences and reduce the step to the previous case via linear_combination · conf: med
- [ ] `pell_d2_y_lt_x_of_pos` — Every positive solution of x²−2y²=1 has y strictly less than x
      absence: no-local-match · triviality: non-trivial · intended: from x² = 2y²+1 > y² and positivity, nlinarith [sq_nonneg (x - y), hx, hy] gives x > y · conf: high
- [ ] `pell_d2_norm_multiplicative_generic` — The √2 norm form is multiplicative: the product of two form values equals the form value of the Brahmagupta composite, an unconditional ring identity underlying Pell composition
      absence: no-local-match · triviality: non-trivial · intended: pure ring identity; both sides expand to the same degree-4 polynomial, closed by ring · conf: high
- [ ] `pell_d3_form_value_ne_two_zmod3` — The form x²−3y² never takes a value congruent to 2 (mod 3), so x²−3y²=2 (and =−1) are unsolvable
      absence: no-local-match · triviality: non-trivial · intended: push the form into ZMod 3 where it equals x²; decide that x²∈{0,1} over the three residues, never 2 · conf: high
