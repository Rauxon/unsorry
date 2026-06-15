# Figurate-number closed forms — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 24 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sum_centered_hexagonal_eq_cube` — The sum of the first n centered hexagonal numbers equals n cubed
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then ring · conf: high
- [x] `sum_centered_cube_eq_biquadratic` — Twice the sum over k<n of k^3+(k+1)^3 equals n^2 times (n^2+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring closes the step · conf: high
- [ ] `sum_octahedral_centered_squares` — Three times the sum of the first n centered-square numbers is n times (2n^2+1), the octahedral closed form
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith handling Nat subtraction · conf: high
- [x] `sum_odd_squares_faulhaber` — Three times the sum of the first n odd squares equals n(2n-1)(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; nlinarith to close with the Nat subtraction · conf: high
- [ ] `sum_odd_cubes_eq_biquadratic` — The sum of the first n odd cubes equals n^2 times (2n^2-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith for the (2n^2-1) Nat-subtraction step · conf: high
- [ ] `sum_star_numbers_closed_form` — The sum of the first n star numbers equals n times (2n^2-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction; Finset.sum_range_succ then nlinarith over Nat subtraction terms · conf: high
- [x] `sum_k_sq_mul_succ_closed_form` — Twelve times the sum of k^2(k+1) over k up to n equals n(n+1)(n+2)(3n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring closes the step · conf: high
- [x] `sum_quadruple_product_closed_form` — Five times the sum of four consecutive integer products equals the five-term product n through n+4
      absence: no-local-match · triviality: non-trivial · intended: Telescoping induction via Finset.sum_range_succ; ring · conf: high
- [x] `sum_pentatope_triple_product` — Four times the sum of three consecutive integer products equals n(n+1)(n+2)(n+3), the pentatope closed form
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [ ] `sum_centered_triangular_closed_form` — The sum of the first n centered triangular numbers equals n times (n^2+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith handling 3k^2-3k Nat subtraction · conf: high
- [x] `sum_even_squares_faulhaber` — Three times the sum of the first n even squares equals 2n(n+1)(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [x] `sum_even_cubes_eq_twice_square` — The sum of the first n even cubes equals 2n^2(n+1)^2
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [x] `sum_heptagonal_closed_form` — Six times the sum of the first n heptagonal-gnomon terms equals 2n(n+1)(5n-2)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith over Nat subtractions · conf: high
- [x] `sum_nonagonal_closed_form` — Three times the sum of the first n nonagonal-gnomon terms equals n(n+1)(7n-4)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith over Nat subtractions · conf: high
- [x] `sum_decagonal_closed_form` — Six times the sum of the first n decagonal numbers equals n(n+1)(8n-5)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith over the Nat subtraction 4k-3 · conf: high
- [x] `sum_hexagonal_numbers_closed_form` — Six times the sum of the first n hexagonal numbers equals n(n+1)(4n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith over the Nat subtraction 2k-1 · conf: high
- [x] `sum_triangular_squared_closed_form` — Fifteen times the sum of squares of consecutive products k^2(k+1)^2 equals n(n+1)(n+2)(3n^2+6n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring (no subtraction) · conf: high
- [x] `sum_k_mul_succ_mul_two_k_succ` — Twice the sum of k(k+1)(2k+1) over k up to n equals n(n+1)^2(n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [x] `sum_k_mul_k_add_two_closed_form` — Six times the sum of k(k+2) over k up to n equals n(n+1)(2n+7)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [x] `sum_odd_gnomon_squares_closed_form` — Twice the sum of (3k-2)^2 over k up to n equals n(6n^2-3n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; Finset.sum_range_succ then nlinarith over the Nat subtractions · conf: high
- [ ] `sum_gnomon_cubes_eq_fourth_power` — The sum over k<n of the quartic gnomon 4k^3+6k^2+4k+1 equals n to the fourth
      absence: no-local-match · triviality: non-trivial · intended: Telescoping (k+1)^4-k^4 via Finset.sum_range_succ; ring · conf: high
- [x] `sum_quintic_gnomon_eq_fifth_power` — The sum over k<n of the quintic gnomon equals n to the fifth
      absence: no-local-match · triviality: non-trivial · intended: Telescoping (k+1)^5-k^5 via Finset.sum_range_succ; ring · conf: high
- [x] `sum_octahedral_numbers_closed_form` — Six times the sum of the first n octahedral numbers equals 3n(n+1)(n^2+n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring · conf: high
- [x] `sum_five_consecutive_product_closed_form` — Six times the sum of five consecutive integer products equals the six-term product n through n+5, the 5-simplex closed form
      absence: no-local-match · triviality: non-trivial · intended: Telescoping induction via Finset.sum_range_succ; ring · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 21 candidates

- [ ] `sum_squares_eq_square_pyramidal` — Six times the sum of the first n squares equals the n-th square-pyramidal number n(n+1)(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then ring_nf / omega on the algebra · conf: high
- [ ] `sum_square_pyramidal_eq_hyper` — Twelve times the sum of the first n square-pyramidal numbers equals n(n+1)^2(n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; clear the /6 by Nat.div lemma or recast each term as 2k^3+3k^2+k before summing · conf: high
- [ ] `sum_tetrahedral_eq_pentatope` — Twenty-four times the sum of the first n tetrahedral numbers equals the pentatope number n(n+1)(n+2)(n+3)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the k(k+1)(k+2) terms are divisible by 6 so the /6 stays exact · conf: high
- [ ] `sum_pentatope_eq_five_simplex` — One hundred twenty times the sum of the first n pentatope numbers equals the 5-simplex number n(n+1)(n+2)(n+3)(n+4)
      absence: no-local-match · triviality: non-trivial · intended: Induction; each k(k+1)(k+2)(k+3) is divisible by 24, then degree-5 ring identity on the step · conf: med
- [ ] `sum_triangular_sq_running` — Sixty times the sum of the squares of the first n triangular numbers equals n(n+1)(n+2)(3n^2+6n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction; replace (k(k+1)/2)^2 by k^2(k+1)^2/4 exactly, then close the degree-5 step with ring · conf: med
- [ ] `sum_pronic_sq_closed_form` — Thirty times the sum of the squares of the first n pronic numbers equals the stated quartic-times-linear expression
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; expand (k(k+1))^2 = k^4+2k^3+k^2 and combine the three Faulhaber pieces, ring on the step · conf: med
- [ ] `diff_tetrahedral_eq_triangular` — The difference of two consecutive tetrahedral numbers equals the intervening triangular number
      absence: no-local-match · triviality: non-trivial · intended: Rewrite each Nat division via divisibility (6 ∣ product, 2 ∣ product), then omega / ring on the integers · conf: high
- [ ] `sum_pronic_eq_thrice_tetrahedral` — Three times the sum of the first n pronic numbers k(k+1) equals (n-1)n(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; handle the Nat subtraction by casework or omega on the step · conf: high
- [ ] `sum_id_mul_triangular_closed_form` — Twenty-four times the sum of k times the k-th triangular number equals (n-1)n(n+1)(3n-2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; rewrite k*(k(k+1)/2) = k^2(k+1)/2 exactly, then ring/omega across the Nat subtractions · conf: high
- [ ] `sum_four_consecutive_eq_hyper_tetrahedral` — Five times the sum of products of four consecutive integers equals n(n+1)(n+2)(n+3)(n+4)
      absence: no-local-match · triviality: non-trivial · intended: Telescoping/induction with Finset.sum_range_succ; the step is a degree-5 ring identity (no division) · conf: high
- [ ] `sum_prod_consecutive_triangular` — Ten times the sum of k(k+1)^2(k+2) (four times the product of consecutive triangular numbers) has the stated degree-5 closed form
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; degree-5 ring identity on the inductive step · conf: med
- [ ] `sum_pentagonal_pyramidal_closed_form` — Twelve times the sum of k^2(k+1) (twice the pentagonal-pyramidal terms) equals n(n+1)(3n+1)(n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; expand k^2(k+1)=k^3+k^2 and combine Faulhaber pieces, ring on the step · conf: high
- [ ] `sum_hexagonal_pyramidal_closed_form` — Six times the sum of the first n hexagonal-pyramidal numbers equals n^2(n+1)(n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; k(k+1)(4k-1) is divisible by 6, manage the Nat (4k-1) subtraction termwise then ring · conf: med
- [ ] `sum_hexagonal_running_eq_hex_pyramidal` — Six times the running sum of the first n hexagonal numbers k(2k-1) equals the hexagonal-pyramidal number n(n+1)(4n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; handle the Nat (2k-1) and (4n-1) subtractions by casework/omega · conf: high
- [ ] `sum_stella_octangula_running` — Twice the running sum of stella-octangula numbers k(2k^2-1) equals n^2(n+1)^2 - n(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction; split as 2*sum k^3 - sum k via Nicomachus and Gauss, manage Nat subtraction with omega · conf: med
- [ ] `sum_pentagonal_running_eq_pyramidal` — Twice the running sum of the first n pentagonal numbers k(3k-1)/2 equals the pentagonal-pyramidal number n^2(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction; k(3k-1) is even so /2 is exact, then ring/omega across the Nat (3k-1) subtraction · conf: high
- [ ] `sum_heptagonal_running_closed_form` — Six times the running sum of the first n heptagonal numbers k(5k-3)/2 equals n(n+1)(5n-2)
      absence: no-local-match · triviality: non-trivial · intended: Induction; k(5k-3) is even so /2 is exact, manage Nat subtractions termwise then ring · conf: med
- [ ] `sum_octagonal_running_closed_form` — Twice the running sum of the first n octagonal numbers k(3k-2) equals n(n+1)(2n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; resolve the Nat (3k-2) and (2n-1) subtractions by omega/casework · conf: high
- [ ] `sum_nonagonal_running_closed_form` — Six times the running sum of the first n nonagonal numbers k(7k-5)/2 equals n(n+1)(7n-4)
      absence: no-local-match · triviality: non-trivial · intended: Induction; k(7k-5) is even so /2 is exact, handle Nat subtractions termwise then ring · conf: med
- [ ] `sum_even_index_triangular_closed_form` — Six times the sum of the even-index triangular numbers T_{2k}=k(2k+1) equals n(n+1)(4n+5)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the step is a quadratic ring identity, no division · conf: high
- [ ] `hexagonal_eq_triangular_odd_index` — The n-th hexagonal number n(2n-1) equals the (2n-1)-th triangular number
      absence: no-local-match · triviality: non-trivial · intended: Rewrite the (2n-1)*(2n)/2 division exactly via Nat.mul_div_cancel on the even factor, then ring/omega · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 19 candidates

- [ ] `sum_heptagonal_numbers_closed_form` — Three times the sum of the first n heptagonal numbers (twice each, as k(5k-3)) equals n(n+1)(5n-2)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then ring (Nat subtraction stays nonnegative for k,n ≥ 1) · conf: high
- [ ] `sum_octagonal_numbers_closed_form` — Twice the running sum of the first n octagonal numbers k(3k-2) equals n(n+1)(2n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ then ring; the doubling clears the /2 in the octagonal closed form · conf: high
- [ ] `sum_nonagonal_numbers_closed_form` — Three times the running sum of the first n nonagonal numbers (as k(7k-5)) equals n(n+1)(7n-4)
      absence: no-local-match · triviality: non-trivial · intended: Induction over Finset.range with sum_range_succ; ring closes the step · conf: high
- [ ] `sum_decagonal_numbers_closed_form` — Six times the running sum of the first n decagonal numbers k(4k-3) equals n(n+1)(8n-5)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ then ring; factor of 6 clears the /2 · conf: high
- [ ] `sum_centered_square_numbers_closed_form` — Three times the running sum of centered square numbers 2k(k+1)+1 equals n(2n^2+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction over Finset.range n with sum_range_succ; ring closes after the factor-3 clears denominators · conf: high
- [ ] `sum_stella_octangula_closed_form` — Twice the running sum of stella octangula numbers k(2k^2-1) equals n(n+1)(n^2+n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; reduces to a cubic identity closed by ring (Nat subtraction valid for the indexed terms) · conf: high
- [ ] `sum_centered_octahedral_closed_form` — The running sum of three-times-centered-octahedral terms (2k+1)(2k^2+2k+3) equals n^2(n^2+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction over Finset.range n with sum_range_succ; the quartic step is closed by ring · conf: high
- [ ] `sum_centered_tetrahedral_closed_form` — Twice the running sum of (2k+1)(k^2+k+3) equals n^2(n^2+5), a centered-tetrahedral closed form
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the doubling clears /2 and ring finishes the quartic step · conf: high
- [ ] `sum_centered_triangular_running_closed_form` — The running sum of twice-centered-triangular terms 3k^2+3k+2 equals n(n^2+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction over Finset.range n with sum_range_succ then ring · conf: high
- [ ] `sum_rhombic_dodecahedral_eq_fourth_power` — The running sum of the rhombic-dodecahedral gnomons (2k-1)(2k^2-2k+1) equals n^4 exactly
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the k=0 term vanishes and the gnomon (n+1)^4 - n^4 expansion is closed by ring after Nat-subtraction care · conf: high
- [ ] `sum_consecutive_product_skip_two_closed_form` — Six times the sum of k(k+2) over the first n terms equals n(n+1)(2n+7)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring closes after the factor-6 clears the /6 · conf: high
- [ ] `sum_four_consecutive_product_closed_form` — Five times the sum of products of four consecutive integers telescopes to the product of five consecutive integers
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ (telescoping product); ring closes the degree-5 step · conf: high
- [ ] `sum_product_consecutive_odds_closed_form` — Three times the sum of products of consecutive odd numbers (2k-1)(2k+1) equals n(4n^2+6n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; the summand is 4k^2-1, ring closes after factor-3 · conf: high
- [ ] `sum_k_mul_succ_sq_closed_form` — Twelve times the sum of k(k+1)^2 equals n(n+1)(n+2)(3n+5)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ then ring; factor-12 clears the rational closed form · conf: high
- [ ] `sum_second_hexagonal_closed_form` — Six times the running sum of k(2k-1) equals n(n+1)(4n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; summand 2k^2-k, ring closes after factor-6 · conf: high
- [ ] `sum_k_mul_two_k_add_one_closed_form` — Six times the running sum of k(2k+1) equals n(n+1)(4n+5)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ then ring · conf: high
- [ ] `sum_decagonal_second_kind_closed_form` — Three times the running sum of the second-kind decagonal terms k(5k+1) equals n(n+1)(5n+4)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; summand 5k^2+k, ring closes after factor-3 · conf: high
- [ ] `sum_cube_add_id_closed_form` — Four times the sum of (k^3 + k) equals n(n+1)(n^2+n+2)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ then ring; combines Nicomachus and triangular pieces · conf: high
- [ ] `sum_cube_sub_id_eq_four_consecutive` — Four times the sum of (k^3 - k) equals (n-1)n(n+1)(n+2), a product of four consecutive integers
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; k^3-k = (k-1)k(k+1) telescopes, ring after Nat-subtraction handling · conf: high
