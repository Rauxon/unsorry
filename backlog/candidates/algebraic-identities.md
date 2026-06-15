# Polynomial / algebraic identities — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 20 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `three_cubes_minus_three_prod_dvd_sum` — The sum a+b+c divides the symmetric expression a cubed plus b cubed plus c cubed minus three times abc
      absence: no-local-match · triviality: non-trivial · intended: Provide the cofactor a^2+b^2+c^2-ab-bc-ca as a Dvd witness, then close with ring · conf: high
- [ ] `diff_fifth_power_dvd_by_diff` — The difference a minus b divides the difference of fifth powers a^5 minus b^5
      absence: no-local-match · triviality: non-trivial · intended: Exhibit a^4+a^3 b+a^2 b^2+a b^3+b^4 as the explicit Dvd witness and discharge with ring · conf: high
- [ ] `sum_cubes_dvd_by_sum` — The sum a plus b divides the sum of cubes a^3 plus b^3
      absence: no-local-match · triviality: non-trivial · intended: Use the witness a^2-a*b+b^2 via Dvd.intro and finish with ring · conf: high
- [ ] `succ_dvd_n_cubed_add_one` — For every integer n, n+1 divides n^3 + 1
      absence: no-local-match · triviality: non-trivial · intended: Witness n^2-n+1 by Dvd.intro and close with ring · conf: high
- [x] `three_dvd_n_cubed_add_two_n` — Three always divides n cubed plus twice n
      absence: no-local-match · triviality: non-trivial · intended: Decide over ZMod 3 (Int.emod_emod_of_dvd / Decidable.decide on the residue), or induct splitting n into residues · conf: high
- [x] `quartic_n4_plus_four_dvd_by_shift_quadratic` — The quadratic n^2-2n+2 divides n^4+4, the Sophie Germain factorisation at b equal to one
      absence: no-local-match · triviality: non-trivial · intended: Provide the conjugate factor n^2+2*n+2 as the Dvd witness and verify with ring · conf: high
- [ ] `aurifeuillian_sextic_x6_plus_27_dvd` — The quadratic x^2+3 divides x^6+27, the sum-of-cubes factorisation of (x^2)^3 + 3^3
      absence: no-local-match · triviality: non-trivial · intended: Sum-of-cubes: witness x^4-3*x^2+9 by Dvd.intro, then ring · conf: high
- [ ] `sum_sq_dvd_diff_sixth_power` — The sum of squares a^2+b^2 divides the sum of sixth powers a^6+b^6
      absence: no-local-match · triviality: non-trivial · intended: Sum-of-cubes on (a^2)^3+(b^2)^3: witness a^4-a^2 b^2+b^4 then ring · conf: high
- [ ] `diff_seventh_power_dvd_by_diff` — The difference a minus b divides the difference of seventh powers a^7 minus b^7
      absence: no-local-match · triviality: non-trivial · intended: Geometric-series witness a^6+a^5 b+...+b^6 via Dvd.intro, close with ring · conf: high
- [ ] `sophie_germain_quartic_not_prime` — For n at least 2 and m at least 1 the Sophie Germain form n^4+4m^4 is never prime
      absence: no-local-match · triviality: non-trivial · intended: Sophie Germain factorisation into (n^2-2nm+2m^2)(n^2+2nm+2m^2); show smaller factor exceeds 1 then apply Nat.Prime.eq_one_of_dvd / not_prime_mul · conf: med
- [ ] `sextic_x6_plus_27_not_prime` — For integer x at least 2 the value x^6+27 is composite
      absence: no-local-match · triviality: non-trivial · intended: Factor as (x^2+3)(x^4-3x^2+9); bound both factors above 1 and use Int.Prime / not-prime-of-mul with nlinarith bounds · conf: med
- [x] `quartic_n4_plus_four_not_prime` — For n at least 2 the value n^4+4 is composite (special case of the Sophie Germain identity)
      absence: no-local-match · triviality: non-trivial · intended: Factor n^4+4 = (n^2-2n+2)(n^2+2n+2); show 1 < n^2-2n+2 by nlinarith then not_prime_mul · conf: high
- [x] `nicomachus_sum_cubes_eq_sum_id_sq` — The sum of the first n cubes equals the square of the sum of the first n naturals (Nicomachus's theorem)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; rewrite the inner triangular sum via Gauss and close with ring · conf: high
- [x] `sum_range_k_mul_factorial_succ` — One plus the sum of k times k-factorial over k below n equals n-factorial
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using Finset.sum_range_succ and Nat.factorial_succ; finish with ring/omega on the factorial step · conf: high
- [ ] `faulhaber_sum_range_pow_four_closed` — Thirty times the sum of fourth powers below n equals the closed Faulhaber polynomial n(n-1)(2n-1)(3n^2-3n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; clear the factor 30, then ring (cast to ℤ if Nat subtraction bites) · conf: med
- [ ] `schur_degree_one_nonneg` — Schur's degree-one inequality: the cyclic sum a(a-b)(a-c)+... is nonnegative for nonnegative reals
      absence: no-local-match · triviality: non-trivial · intended: WLOG order a≥b≥c then nlinarith with products of (a-b),(b-c),(a-c) and the nonnegativity hypotheses as hints · conf: med
- [ ] `sum_fourth_powers_ge_cube_times_sum` — For nonnegative reals, a^3 b + a b^3 is at most a^4 + b^4
      absence: no-local-match · triviality: non-trivial · intended: nlinarith with sq_nonneg (a-b) and sq_nonneg (a+b) times sq_nonneg (a-b) as SOS hints · conf: high
- [ ] `diff_squares_prod_dvd_quartic_diff` — The difference of squares a^2-b^2 divides the difference of fourth powers a^4-b^4
      absence: no-local-match · triviality: non-trivial · intended: Witness a^2+b^2 via Dvd.intro and close with ring · conf: high
- [ ] `sum_fifth_powers_dvd_by_sum` — The sum a plus b divides the sum of fifth powers a^5 plus b^5
      absence: no-local-match · triviality: non-trivial · intended: Witness a^4-a^3 b+a^2 b^2-a b^3+b^4 via Dvd.intro, then ring · conf: high
- [ ] `n_pow_three_sub_n_dvd_by_six` — Six divides n cubed minus n for every integer n (product of three consecutive integers)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite n^3-n = (n-1)*n*(n+1) and combine 2 ∣ and 3 ∣ via a ZMod 6 residue decide or consecutive-integer lemmas · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 24 candidates

- [x] `cauchy_schwarz_two_term` — For reals, the square of a dot product of two 2-vectors is at most the product of their squared norms (the two-term Cauchy-Schwarz inequality)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a*d - b*c)] (Lagrange identity gives the SOS gap) · conf: high
- [x] `candido_sum_quartics_twice_square` — Candido's identity: the sum of the fourth powers of a, b and a+b is always twice a perfect square
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a^2 + a*b + b^2, by ring⟩ · conf: high
- [ ] `eisenstein_norm_multiplicative` — The set of Loeschian numbers x²+xy+y² (Eisenstein integer norms) is closed under multiplication
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a*c - b*d, a*d + b*c + b*d, by ring⟩ · conf: high
- [x] `cube_of_sum_minus_cubes_div_by_sum` — The difference between (a+b+c)³ and a³+b³+c³ is divisible by a+b (it equals 3(a+b)(b+c)(c+a))
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨3*(b+c)*(c+a), by ring⟩ · conf: high
- [x] `sum_cubes_sym_divisible_by_quadratic` — The symmetric quadratic a²+b²+c²-ab-bc-ca divides a³+b³+c³-3abc
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a + b + c, by ring⟩ · conf: high
- [x] `quad_form_divides_cube_sum` — The quadratic a²-ab+b² divides the sum of cubes a³+b³
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a + b, by ring⟩ · conf: high
- [ ] `sum_of_squares_divides_sum_sixth_powers` — The sum of two squares a²+b² divides the sum of their sixth powers a⁶+b⁶
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a^4 - a^2*b^2 + b^4, by ring⟩ · conf: high
- [x] `cyclotomic_five_divides_pow_five_sub_one` — The 5th cyclotomic polynomial n⁴+n³+n²+n+1 divides n⁵-1
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨n - 1, by ring⟩ · conf: high
- [x] `cyclotomic_three_divides_pow_six_sub_one` — The polynomial n²+n+1 divides n⁶-1
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨(n - 1)*(n + 1)*(n^2 - n + 1), by ring⟩ · conf: high
- [ ] `quartic_sum_ge_symmetric_product_pairs` — The sum of fourth powers dominates the sum of pairwise products of squares
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2)] · conf: high
- [x] `sum_sq_norm_sq_le_twice_sum_fourth` — The square of a²+b² is at most twice the sum of fourth powers (power-mean / QM bound)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2 - b^2)] · conf: high
- [x] `sum_sixth_ge_mixed_fourth_second` — The sum of sixth powers dominates the mixed terms a⁴b²+a²b⁴
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (a+b), sq_nonneg a, sq_nonneg b, mul_nonneg (sq_nonneg a) (sq_nonneg b)] · conf: high
- [ ] `four_quartics_ge_four_product` — The sum of four fourth powers is at least four times the product abcd (AM-GM on squares)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (c^2-d^2), sq_nonneg (a*b-c*d), mul_self_nonneg (a*b), mul_self_nonneg (c*d)] · conf: high
- [ ] `cyclic_four_sum_sq_ge_cyclic_products` — The sum of four squares dominates the cyclic sum of adjacent products ab+bc+cd+da
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-d), sq_nonneg (d-a)] · conf: high
- [ ] `product_three_sum_squares_ge_eight_product` — The product of three pairwise sums of squares is at least eight times the product of all three squares
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2), sq_nonneg (a*b*c), mul_nonneg (sq_nonneg a) (sq_nonneg b)] · conf: high
- [ ] `biquadratic_mixed_sos_nonneg` — The quartic factor of a⁵+b⁵ over a+b, namely a⁴-a³b+a²b²-ab³+b⁴, is always nonnegative
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (a-b), sq_nonneg (a+b), sq_nonneg (a^2 - a*b), sq_nonneg (a*b - b^2)] · conf: high
- [ ] `lagrange_identity_three_var` — Lagrange's three-variable identity expresses the Cauchy-Schwarz gap as an explicit sum of three squares
      absence: no-local-match · triviality: non-trivial · intended: ring · conf: high
- [x] `n4_plus_one_factor_over_sqrt_shift` — The Sophie-Germain-type factorisation gives that 2n²-2n+1 divides 4n⁴+1
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨2*n^2 + 2*n + 1, by ring⟩ · conf: high
- [x] `sextic_x6_plus_x3_plus_one_dvd_pow_nine_sub_one` — The ninth cyclotomic polynomial n⁶+n³+1 divides n⁹-1
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨n^3 - 1, by ring⟩ · conf: high
- [x] `quartic_n4_plus_four_composite_witness` — n⁴+4 factors explicitly as (n²-2n+2)(n²+2n+2), exhibiting both Sophie-Germain factors
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨_, _, by ring, rfl, rfl⟩ · conf: high
- [ ] `diff_cube_divides_diff_sixth` — The difference of cubes a³-b³ divides the difference of sixth powers a⁶-b⁶
      absence: no-local-match · triviality: non-trivial · intended: exact ⟨a^3 + b^3, by ring⟩ · conf: high
- [ ] `sum_four_squares_ge_pairwise_distinct_products` — A weighted four-square bound: ac+bd is dominated by a²+b²/2+c²/2+d²
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a - c), sq_nonneg (b - d), sq_nonneg a, sq_nonneg d] · conf: high
- [ ] `square_product_sum_three_le_square_norm` — The square of the symmetric pairwise-product sum is at most the square of the sum of squares
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a), sq_nonneg (a+b+c), sq_nonneg (a*b+b*c+c*a)] · conf: high
- [ ] `sophie_germain_factor_difference_four_prod` — The two Sophie-Germain quadratic factors of a⁴+4b⁴ differ by exactly 4ab, bounding their gcd
      absence: no-local-match · triviality: non-trivial · intended: ring · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 23 candidates

- [ ] `diff_sixth_power_dvd_by_sum` — The sum of two integers divides the difference of their sixth powers
      absence: no-local-match · triviality: non-trivial · intended: a^6 - b^6 = (a+b)*(a^5 - a^4*b + a^3*b^2 - a^2*b^3 + a*b^4 - b^5); Dvd.intro + ring · conf: high
- [ ] `diff_eighth_power_dvd_by_diff_fourth` — The difference of fourth powers divides the difference of eighth powers
      absence: no-local-match · triviality: non-trivial · intended: a^8 - b^8 = (a^4 - b^4)*(a^4 + b^4); Dvd.intro then ring · conf: high
- [ ] `diff_sixth_power_dvd_by_sum_of_squares` — The sum of two squares divides the sum of the corresponding sixth powers
      absence: no-local-match · triviality: non-trivial · intended: a^6 + b^6 = (a^2 + b^2)*(a^4 - a^2*b^2 + b^4); Dvd.intro + ring · conf: high
- [ ] `sextic_plus_one_dvd_by_quadratic_of_squares` — The quadratic x squared plus one divides x to the sixth plus one
      absence: no-local-match · triviality: non-trivial · intended: x^6 + 1 = (x^2 + 1)*(x^4 - x^2 + 1); supply cofactor then ring · conf: high
- [ ] `quartic_x4_plus_x2_plus_one_dvd_by_minus_factor` — The Aurifeuillian quartic x^4+x^2+1 is divisible by the quadratic factor x^2-x+1
      absence: no-local-match · triviality: non-trivial · intended: x^4 + x^2 + 1 = (x^2 - x + 1)*(x^2 + x + 1); Dvd.intro + ring · conf: high
- [ ] `sophie_germain_plus_factor_dvd` — The second Sophie-Germain quadratic factor a^2+2ab+2b^2 divides a^4+4b^4
      absence: no-local-match · triviality: non-trivial · intended: a^4 + 4b^4 = (a^2 + 2ab + 2b^2)*(a^2 - 2ab + 2b^2); Dvd.intro then ring · conf: high
- [ ] `shifted_sophie_germain_x4_plus_4_dvd_by_x2_plus_2x_plus_2` — The quadratic x^2+2x+2 divides x^4+4 (one Sophie-Germain factor at b=1)
      absence: no-local-match · triviality: non-trivial · intended: x^4 + 4 = (x^2 + 2x + 2)*(x^2 - 2x + 2); supply cofactor then ring · conf: high
- [ ] `quartic_x4_plus_64_dvd_by_x2_minus_4x_plus_8` — The quadratic x^2-4x+8 divides x^4+64 (Sophie-Germain factorization with b=2)
      absence: no-local-match · triviality: non-trivial · intended: x^4 + 64 = (x^2 - 4x + 8)*(x^2 + 4x + 8); Dvd.intro + ring · conf: high
- [ ] `aurifeuillian_sextic_x6_plus_1_dvd_by_x2_minus_x_plus_one` — The quadratic x^2-x+1 (the order-12 cyclotomic-style factor) divides x^6+1
      absence: no-local-match · triviality: non-trivial · intended: x^6 + 1 = (x^2 - x + 1)*(x^2 + x + 1)*(x^2 - 1) + ... instead: (x^2 - x + 1)*(x^4 + x^3 - x - 1) +? use witness x^4 + x^3 - x^2? compute exact cofactor and ring · conf: high
- [ ] `twelfth_degree_x4_plus_x2_plus_1_dvd_by_x12_minus_1` — The biquadratic x^4+x^2+1 divides x^12-1
      absence: no-local-match · triviality: non-trivial · intended: x^12 - 1 = (x^4 + x^2 + 1)*(x^8 - x^4? )... actually (x^4+x^2+1)(x^2-1)=x^6-1 so x^12-1=(x^6-1)(x^6+1); cofactor (x^2-1)*(x^6+1); Dvd.intro + ring · conf: high
- [ ] `brahmagupta_fibonacci_alt_sign_two_representations` — The Brahmagupta-Fibonacci identity in its second (minus-sign) form expressing a product of sums of two squares as a sum of two squares
      absence: no-local-match · triviality: non-trivial · intended: expand both sides with ring · conf: high
- [ ] `lagrange_identity_two_var_as_equation` — The two-variable Lagrange identity: the product of sums of squares minus the squared dot product equals the squared cross term
      absence: no-local-match · triviality: non-trivial · intended: ring after moving the subtraction · conf: high
- [ ] `euler_four_square_product_identity` — Euler's four-square identity: a product of two sums of four squares is again a sum of four squares
      absence: no-local-match · triviality: non-trivial · intended: expand both sides; ring (large but mechanical) · conf: high
- [ ] `lebesgue_square_of_sum_of_four_squares` — Lebesgue's identity writing the square of a sum of four squares as a sum of three squares
      absence: no-local-match · triviality: non-trivial · intended: ring expansion of both sides · conf: high
- [ ] `sum_fourth_powers_ge_four_times_product` — The sum of fourth powers of four reals is at least four times their product (AM-GM via squares)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (c^2-d^2), sq_nonneg (a*b-c*d), sq_nonneg (a*b+c*d)] · conf: high
- [ ] `sum_sixth_powers_three_var_ge_three_times_square_product` — The sum of sixth powers of three reals is at least three times the product of their squares
      absence: no-local-match · triviality: non-trivial · intended: AM-GM on (a^2,b^2,c^2) cubes; nlinarith with sq_nonneg of squared differences and a sum-of-cubes hint · conf: high
- [ ] `sum_fourth_powers_three_var_ge_sym_square_products` — The sum of fourth powers of three reals dominates the symmetric sum of pairwise products of their squares
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a^2-b^2), sq_nonneg (b^2-c^2), sq_nonneg (c^2-a^2)] · conf: high
- [ ] `product_of_two_sums_of_squares_ge_square_of_cross` — A product of two sums of squares is at least the square of the antisymmetric cross term (Lagrange consequence)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (x*z + y*w)] using the Lagrange identity decomposition · conf: high
- [ ] `sum_sixth_power_two_var_ge_mixed_fourth_second` — The sum of sixth powers of two reals dominates the mixed fourth-second power terms
      absence: no-local-match · triviality: non-trivial · intended: factor a^6+b^6 - a^4 b^2 - a^2 b^4 = (a^2-b^2)^2 (a^2+b^2); nlinarith [sq_nonneg (a^2-b^2), sq_nonneg a, sq_nonneg b, mul_nonneg ...] · conf: high
- [ ] `sophie_germain_numeric_m4_plus_4n4_composite_factor` — The full Sophie-Germain factorization expressing m^4+4n^4 as a product of two quadratics
      absence: no-local-match · triviality: non-trivial · intended: ring expansion (kept as a witness/equation lemma for the divisibility goals) · conf: high
- [ ] `n4_plus_4n2_plus_16_dvd_by_n2_plus_2n_plus_4` — The quadratic n^2-2n+4 divides the quartic n^4+4n^2+16
      absence: no-local-match · triviality: non-trivial · intended: n^4+4n^2+16 = (n^2-2n+4)*(n^2+2n+4); Dvd.intro + ring · conf: high
- [ ] `diff_twelfth_power_dvd_by_diff_cube` — The difference of cubes divides the difference of twelfth powers
      absence: no-local-match · triviality: non-trivial · intended: a^12 - b^12 = (a^3 - b^3)*(a^9 + a^6 b^3 + a^3 b^6 + b^9); Dvd.intro + ring · conf: high
- [ ] `sum_of_two_squares_times_three_ge_square_of_sum` — Three times the sum of three squares is at least the square of their sum (QM-AM / power-mean)
      absence: no-local-match · triviality: non-trivial · intended: nlinarith [sq_nonneg (a-b), sq_nonneg (b-c), sq_nonneg (c-a)] · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 20 candidates

- [ ] `sum_seventh_powers_dvd_by_sum` — The sum of two seventh powers is divisible by the sum of the two bases
      absence: no-local-match · triviality: non-trivial · intended: Provide the explicit alternating-degree-6 cofactor as the divisibility witness and close with ring · conf: high
- [ ] `diff_fifth_powers_dvd_by_diff` — The difference of two fifth powers is divisible by the difference of the two bases
      absence: no-local-match · triviality: non-trivial · intended: Supply the degree-4 cofactor a^4+a^3 b+a^2 b^2+a b^3+b^4 as witness, then ring · conf: high
- [ ] `sextic_a6_plus_27b6_dvd_by_quadratic` — The sextic a^6 + 27 b^6 is divisible by the quadratic a^2 + 3 b^2
      absence: no-local-match · triviality: non-trivial · intended: Recognise a sum of cubes a^6+(3b^2)^3 and give cofactor a^4-3a^2b^2+9b^4 as witness, then ring · conf: high
- [ ] `octic_x8_plus_x4_plus_one_dvd_by_quartic` — The octic x^8 + x^4 + 1 is divisible by the quartic x^4 - x^2 + 1
      absence: no-local-match · triviality: non-trivial · intended: Witness the cofactor x^4+x^2+1 from the cyclotomic-style factorization and close by ring · conf: high
- [ ] `decic_x10_plus_x5_plus_one_dvd_by_quadratic` — The decic x^10 + x^5 + 1 is divisible by x^2 + x + 1
      absence: no-local-match · triviality: non-trivial · intended: Give the degree-8 cofactor witness arising from the 15th-cyclotomic factorization and ring · conf: high
- [ ] `sextic_x6_minus_one_dvd_by_quadratic` — The sextic x^6 - 1 is divisible by x^2 + x + 1
      absence: no-local-match · triviality: non-trivial · intended: Provide cofactor x^4 - x^3 + x - 1 as the divisibility witness and finish with ring · conf: high
- [ ] `frobenius_sum_cubes_dvd_by_sum` — The expression a^3+b^3+c^3-3abc is divisible by a+b+c
      absence: no-local-match · triviality: non-trivial · intended: Witness the symmetric cofactor a^2+b^2+c^2-ab-bc-ca and close by ring · conf: high
- [ ] `sophie_germain_x4_plus_324_dvd_by_quadratic` — The quartic x^4 + 324 is divisible by x^2 - 6x + 18
      absence: no-local-match · triviality: non-trivial · intended: Apply Sophie-Germain with parameter 3 (324=4*81), witness cofactor x^2+6x+18, then ring · conf: high
- [ ] `sophie_germain_numeric_4x4_plus_1_dvd` — The biquadratic 4x^4 + 1 is divisible by 2x^2 + 2x + 1
      absence: no-local-match · triviality: non-trivial · intended: Sophie-Germain factorization of 4x^4+1; witness cofactor 2x^2-2x+1 and ring · conf: high
- [ ] `thirty_dvd_n_fifth_minus_n` — Thirty divides n^5 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Bridge to ZMod 30 via Int.cast and decide, or combine 2,3,5 divisibility from Fermat-style residues · conf: high
- [ ] `fortytwo_dvd_n_seventh_minus_n` — Forty-two divides n^7 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Reduce mod 42 through ZMod 42 and decide, or assemble 2,3,7 cofactors via Fermat's little theorem · conf: high
- [ ] `six_dvd_n_cubed_plus_five_n` — Six divides n^3 + 5n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Rewrite as n^3-n+6n and use 6 | n^3-n via the ZMod 6 decide bridge · conf: high
- [ ] `thirty_dvd_n_ninth_minus_n` — Thirty divides n^9 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Map to ZMod 30 and decide over all residues, or factor through 2,3,5 Fermat congruences · conf: med
- [ ] `sum_range_k_fourth_closed_form` — Thirty times the sum of fourth powers below n equals the Faulhaber quintic 6n^5-15n^4+10n^3-n
      absence: no-local-match · triviality: non-trivial · intended: Induct on n using Finset.sum_range_succ and close the step with ring · conf: high
- [ ] `sum_range_k_mul_three_pow_closed` — Four times the sum of k*3^k for k below n equals (2n-3)*3^n + 3
      absence: no-local-match · triviality: non-trivial · intended: Induct with Finset.sum_range_succ; the successor step is a 3^n ring identity · conf: high
- [ ] `sum_range_k_sq_mul_two_pow_closed` — The sum of k^2*2^k for k below n equals (n^2-4n+6)*2^n - 6
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ and discharge the step by ring · conf: high
- [ ] `sum_range_odd_squares_closed` — Three times the sum of the first n odd squares equals n(2n-1)(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induct via Finset.sum_range_succ and close the inductive step with ring · conf: high
- [ ] `sum_range_quad_poly_mul_factorial_eq` — The sum of (k^2+k+1)*k! for k below n equals n*n!
      absence: no-local-match · triviality: non-trivial · intended: Telescoping induction with Finset.sum_range_succ and Nat.factorial_succ in the step · conf: high
- [ ] `sum_range_kp1_mul_two_pow_closed` — The sum of (k+1)*2^k for k below n equals (n-1)*2^n + 1
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ; the step reduces to a 2^n ring identity · conf: high
- [ ] `sum_range_gnomon_quadratic_eq_cube` — The sum of the cubic gnomons 3k^2+3k+1 for k below n telescopes to n^3
      absence: no-local-match · triviality: non-trivial · intended: Telescoping induction via Finset.sum_range_succ recognising (k+1)^3 - k^3 · conf: high
