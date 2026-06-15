# Binomial / central-binomial identities — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 20 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sum_range_fall_three_mul_choose` — The sum over k of the third falling factorial of k times C(n,k), scaled by 8, equals n(n-1)(n-2) times 2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ plus Nat.succ_mul_choose_eq absorption; companion to the existing degree-2 falling goal · conf: med
- [x] `sum_range_k_plus_one_mul_choose` — Twice the sum of (k+1)·C(n,k) over k equals (n+2)·2^n
      absence: no-local-match · triviality: non-trivial · intended: Split (k+1)·C(n,k) into k·C(n,k)+C(n,k) and use sum_range_mul_choose and sum_range_choose · conf: high
- [x] `sum_range_shifted_choose_eq_two_pow_sub_one` — The sum of the shifted binomial coefficients C(n+1,k+1) for k from 0 to n equals 2^(n+1) minus 1
      absence: no-local-match · triviality: non-trivial · intended: Reindex against sum_range_choose for n+1, peeling off the C(n+1,0)=1 term · conf: high
- [x] `alternating_sum_k_mul_choose_eq_zero` — For n at least 2 the alternating sum of k·C(n,k) over k is zero
      absence: no-local-match · triviality: non-trivial · intended: Rewrite k·C(n,k)=n·C(n-1,k-1), factor out n, reindex, then apply Int.alternating_sum_range_choose · conf: med
- [ ] `sum_range_adjacent_choose_prod_eq_central_shift` — The sum over k of C(n,k)·C(n,k+1) equals the off-center binomial coefficient C(2n,n-1)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde slice: pair C(n,k) with C(n,n-1-k) via choose_symm and apply add_choose_eq · conf: med
- [x] `sum_range_k_mul_choose_sq_eq_central` — The sum of k·C(n,k)^2 equals n times the binomial coefficient C(2n-1,n-1)
      absence: no-local-match · triviality: non-trivial · intended: Absorb k via n·C(n-1,k-1)·C(n,k), then a Vandermonde convolution; not a single battery tactic · conf: med
- [ ] `succ_mul_central_binom_succ_eq` — The central binomial recurrence: (n+1)·C(2n+2,n+1) equals (4n+2)·C(2n,n)
      absence: no-local-match · triviality: non-trivial · intended: Derive from Nat.succ_mul_centralBinom_succ together with centralBinom_eq_two_mul_choose · conf: high
- [ ] `sum_range_k_sq_mul_choose_sq_eq_central` — The sum of k^2·C(n,k)^2 equals n^2 times the binomial coefficient C(2n-2,n-1)
      absence: no-local-match · triviality: non-trivial · intended: Double absorption k·C(n,k)=n·C(n-1,k-1) on both squared factors, then Vandermonde convolution · conf: med
- [ ] `sum_vandermonde_slice_three_five` — A Vandermonde slice: the convolution of row 3 with row n at total index 5 equals C(n+3,5)
      absence: no-local-match · triviality: non-trivial · intended: Specialize Nat.add_choose_eq (Vandermonde) at m=3, total=5; the fixed small index keeps it non-decidable over n · conf: high
- [ ] `sum_range_central_binom_convolution_eq_four_pow` — The self-convolution of central binomial coefficients summed to n equals 4^n
      absence: no-local-match · triviality: non-trivial · intended: Generating-function identity (Σ C(2k,k)x^k = 1/√(1-4x)); prove by strong induction or a Catalan/centralBinom recurrence · conf: med
- [x] `alternating_sum_shifted_choose_eq_one` — The alternating sum of the shifted binomial coefficients C(n+1,k+1) equals 1
      absence: no-local-match · triviality: non-trivial · intended: Reindex into the full alternating row sum for n+1 (which is 0), isolating the missing k=0 term via Int.alternating_sum_range_choose · conf: med
- [ ] `sum_range_choose_mul_three_pow_eq_four_pow` — The sum of C(n,k)·3^k over k equals 4^n
      absence: no-local-match · triviality: non-trivial · intended: Binomial theorem (1+3)^n via Nat.sum_range_choose-style add_pow with x=1, y=3; needs the theorem, not pure ring · conf: high
- [ ] `alternating_sum_choose_mul_two_pow_eq_neg_one_pow` — The alternating sum of C(n,k)·2^k equals (-1)^n
      absence: no-local-match · triviality: non-trivial · intended: Binomial theorem (1-2)^n = (-1)^n via Int sub_pow / add_pow expansion · conf: high
- [x] `sum_range_choose_mul_k_mul_comp_eq` — Four times the sum of C(n,k)·k·(n-k) equals n(n-1)·2^n
      absence: no-local-match · triviality: non-trivial · intended: Absorb both factors via k·C(n,k)=n·C(n-1,k-1) and symmetry, reducing to sum_range_choose; relates to variance of the binomial · conf: med
- [x] `sum_range_choose_mul_choose_three_eq` — Eight times the subset-of-a-subset sum of C(n,k)·C(k,3) equals C(n,3)·2^n
      absence: no-local-match · triviality: non-trivial · intended: Subset-of-subset identity C(n,k)C(k,3)=C(n,3)C(n-3,k-3), factor out C(n,3), then sum the shifted row to 2^(n-3) · conf: med
- [x] `sum_range_even_cols_eq_two_pow` — The sum of the even-indexed entries of row 2n of Pascal's triangle equals 2^(2n-1)
      absence: no-local-match · triviality: non-trivial · intended: Average the full row sum 2^(2n) with the alternating row sum 0 (parity split), via Int.alternating_sum_range_choose · conf: med
- [ ] `sum_range_odd_row_half_eq_four_pow` — The sum of the first n+1 entries of the odd row 2n+1 of Pascal's triangle equals 4^n
      absence: no-local-match · triviality: non-trivial · intended: Symmetry choose_symm pairs the lower half with the upper half of an odd-length row whose total is 2^(2n+1) · conf: high
- [x] `sum_range_cube_sym_choose_sq_eq_zero` — The sum of (n-2k)^3·C(n,k)^2 over k vanishes by the antisymmetry k to n-k
      absence: no-local-match · triviality: non-trivial · intended: Reflection involution k to n-k sends the summand to its negation (odd power times symmetric square); use Finset.sum_involution / sum_range_reflect · conf: med
- [x] `sum_range_pascal_diagonal_eq_choose` — The hockey-stick along a Pascal diagonal: the sum of C(m+k,k) for k from 0 to n equals C(m+n+1,n)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ and Nat.succ_sub_one / choose_succ_succ Pascal step; a parallel-diagonal hockey-stick distinct from the Icc form · conf: high
- [ ] `sum_range_sq_sym_choose_sq_eq_central` — The sum of (n-2k)^2·C(n,k)^2 equals 2n times the binomial coefficient C(2n-2,n-1)
      absence: no-local-match · triviality: non-trivial · intended: Expand (n-2k)^2 and combine sum_range_choose_sq with the k and k^2 weighted convolutions; an SOS-style reduction to Vandermonde · conf: med

### Replenishment round 2 (scoped 2026-06-15) — 38 candidates

- [x] `sum_range_k_sq_mul_choose_eq` — Four times the sum of k squared times C(n,k) over k equals n(n+1) times 2 to the n
      absence: no-local-match · triviality: non-trivial · intended: Split k^2 = k*(k-1) + k, absorb k*C(n,k)=n*C(n-1,k-1) twice, reduce to sum_range_choose; the scaling-by-4 keeps it off norm_num/ring · conf: high
- [x] `sum_range_lower_triangle_choose_eq_two_pow` — The double sum of C(j,k) over the lower-triangular index region with j up to n equals 2 to the (n+1) minus 1
      absence: no-local-match · triviality: non-trivial · intended: Inner sum collapses to 2^j via Nat.sum_range_choose, then a geometric telescoping induction with Finset.sum_range_succ · conf: high
- [ ] `sum_range_k_mul_pred_mul_choose_sq_eq` — The sum of k(k-1) times C(n+2,k) squared equals (n+2)(n+1) times the binomial coefficient C(2n+2,n)
      absence: no-local-match · triviality: non-trivial · intended: Double absorption k*C(m,k)=m*C(m-1,k-1) on both squared factors, then a Vandermonde convolution; reindexed on n+2 to keep Nat subtraction safe · conf: med
- [x] `sum_range_two_k_succ_mul_choose_eq` — The sum of (2k+1) times C(n,k) over k equals (n+1) times 2 to the n
      absence: no-local-match · triviality: non-trivial · intended: Split into 2*sum(k*C)=2*n*2^(n-1) and sum(C)=2^n via sum_range_mul_choose and sum_range_choose; combine · conf: high
- [x] `sum_range_disp_mul_choose_sq_eq_zero` — Over the integers the sum of (n-2k) times C(n,k) squared vanishes by the reflection symmetry k to n-k
      absence: no-local-match · triviality: non-trivial · intended: Reflection involution k↦n-k via Finset.sum_range_reflect negates the linear displacement while fixing the symmetric square C(n,k)^2; antisymmetry forces zero · conf: high
- [ ] `sum_range_k_mul_comp_mul_choose_sq_eq` — Over the integers the sum of k(m-k) times C(m,k) squared, with m = n+1, equals m(m-1) times C(2m-2,m-1)
      absence: no-local-match · triviality: non-trivial · intended: Expand k(m-k)=k*m - k^2, reuse the k-weighted and k^2-weighted central convolutions, combine; cast to ℤ avoids truncated subtraction · conf: med
- [x] `sum_range_half_even_row_choose_eq` — Twice the sum of the first n+1 entries of the even row 2n of Pascal's triangle equals 4 to the n plus the central coefficient C(2n,n)
      absence: no-local-match · triviality: non-trivial · intended: Symmetry choose_symm folds the upper half onto the lower half; the full even row sums to 2^(2n)=4^n and the central term is counted once, so doubling the half adds C(2n,n) · conf: high
- [ ] `sum_range_choose_mul_choose_shift_two_eq` — The sum over k of C(n+2,k) times C(n+2,k+2) equals the off-center coefficient C(2n+4,n)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde slice: pair C(m,k) with C(m,m-2-k) via choose_symm and apply Nat.add_choose_eq; reindexed on n+2 for safe shift-by-2 · conf: med
- [x] `sum_vandermonde_diagonal_eq_choose` — The diagonal Vandermonde convolution, summing C(n,k) times C(m,k) over k, equals C(n+m,n)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite C(m,k)=C(m,m-k) via choose_symm to turn the same-index product into the standard Vandermonde shape, then apply Nat.add_choose_eq · conf: high
- [x] `sum_range_comp_mul_choose_sq_eq` — Over the integers the sum of (m-k) times C(m,k) squared, with m = n+1, equals m times C(2m,m) minus m times C(2m-1,m-1)
      absence: no-local-match · triviality: non-trivial · intended: Write (m-k)=m - k, split into m*sum(C^2)=m*C(2m,m) and sum(k*C^2)=m*C(2m-1,m-1) via sum_range_choose_sq and the k-weighted convolution · conf: high
- [x] `sum_range_choose_mul_succ_choose_eq` — The cross-row Vandermonde diagonal summing C(n,k) times C(n+1,k) equals C(2n+1,n)
      absence: no-local-match · triviality: non-trivial · intended: Apply choose_symm to C(n+1,k) and invoke Nat.add_choose_eq (Vandermonde) with rows n and n+1 at total index n · conf: high
- [ ] `sum_range_disp_sq_mul_choose_eq` — The binomial variance identity: over the integers the sum of (2k-n) squared times C(n,k) equals n times 2 to the n
      absence: no-local-match · triviality: non-trivial · intended: Expand (2k-n)^2=4k^2-4kn+n^2, plug in sum(C)=2^n, sum(k*C)=n*2^(n-1), sum(k^2*C)=n(n+1)2^(n-2); the cross terms collapse to n*2^n · conf: high
- [x] `sum_range_disp_mul_choose_eq_zero` — Over the integers the mean-centered sum of (2k-n) times C(n,k) vanishes
      absence: no-local-match · triviality: non-trivial · intended: Split 2*sum(k*C)=n*2^n and n*sum(C)=n*2^n and cancel; or use the reflection k↦n-k that negates 2k-n while fixing C(n,k) · conf: high
- [ ] `alt_sum_range_half_choose_eq` — The signed partial sum of the first n+2 entries of the even row 2(n+1) equals (-1)^(n+1) times C(2n+1,n+1)
      absence: no-local-match · triviality: non-trivial · intended: Telescope the alternating partial row using the Pascal identity so consecutive signed terms cancel, leaving the single boundary coefficient · conf: med
- [ ] `sum_range_shifted_choose_mul_choose_eq` — The convolution of the shifted upper row with the lower row, summing C(n+1,k+1) times C(n,k), equals C(2n+1,n)
      absence: no-local-match · triviality: non-trivial · intended: Apply choose_symm to C(n,k) and recognise a Vandermonde slice of rows n+1 and n at a shifted total via Nat.add_choose_eq · conf: med
- [x] `sum_range_odd_index_choose_eq_two_pow` — The sum of the odd-indexed entries of the even row 2(n+1) of Pascal's triangle equals 2 to the (2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Average the full row sum 2^(2(n+1)) against the alternating row sum 0 (parity split) via Int.alternating_sum_range_choose to isolate the odd-index half · conf: high
- [ ] `sum_range_choose_mul_choose_shift_three_eq` — The sum over k of C(n+3,k) times C(n+3,k+3) equals the off-center coefficient C(2n+6,n)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde slice: pair C(m,k) with C(m,m-3-k) via choose_symm and apply Nat.add_choose_eq; reindexed on n+3 for a safe shift-by-3 · conf: med
- [x] `sum_range_succ_mul_choose_sq_eq` — Twice the sum of (k+1) times C(n,k) squared equals (n+2) times the central coefficient C(2n,n)
      absence: no-local-match · triviality: non-trivial · intended: Split (k+1)*C^2 into k*C^2 and C^2, then combine sum_range_choose_sq=C(2n,n) with the k-weighted central convolution 2*sum(k*C^2)=n*C(2n,n) · conf: high
- [x] `sum_range_cube_mul_two_pow_closed` — The sum of k-cubed times two-to-the-k over k below n has the closed form (n^3-6n^2+18n-26)2^n+26
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, then ring on the cubic-polynomial coefficient identity · conf: high
- [x] `sum_range_id_mul_three_pow_closed` — Four times the sum of k times three-to-the-k over k below n equals (2n-3)3^n+3
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; clear the factor 4 and close the step with ring · conf: high
- [x] `sum_range_sq_mul_three_pow_closed` — Twice the sum of k-squared times three-to-the-k over k below n equals (n^2-3n+3)3^n-3
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ, ring on the quadratic coefficient identity after clearing the 2 · conf: high
- [x] `sum_range_cube_mul_three_pow_closed` — Eight times the sum of k-cubed times three-to-the-k over k below n equals (4n^3-18n^2+36n-33)3^n+33
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring discharges the cubic step after clearing the 8 · conf: high
- [x] `sum_range_id_mul_four_pow_closed` — Nine times the sum of k times four-to-the-k over k below n equals (3n-4)4^n+4
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring on the linear step after clearing the 9 · conf: high
- [x] `sum_range_sq_mul_four_pow_closed` — Twenty-seven times the sum of k-squared times four-to-the-k over k below n equals (9n^2-24n+20)4^n-20
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring on the quadratic step after clearing the 27 · conf: high
- [x] `sum_range_two_k_sub_one_mul_three_pow_closed` — The sum of (2k-1) times three-to-the-k over k below n has the clean closed form (n-2)3^n+2
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring closes the linear step · conf: high
- [x] `sum_range_three_k_add_two_mul_two_pow_closed` — The sum of (3k+2) times two-to-the-k over k below n equals (3n-4)2^n+4
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring closes the linear step · conf: high
- [ ] `sum_range_succ_sq_mul_two_pow_closed` — The sum of (k+1)-squared times two-to-the-k over k below n equals (n^2-2n+3)2^n-3
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring on the quadratic coefficient step · conf: high
- [ ] `sum_range_id_mul_succ_mul_two_pow_closed` — The sum of k(k+1) times two-to-the-k over k below n equals (n^2-3n+4)2^n-4
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring on the quadratic step · conf: high
- [ ] `sum_range_sq_add_one_mul_two_pow_closed` — The sum of (k^2+1) times two-to-the-k over k below n equals (n^2-4n+7)2^n-7
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring on the quadratic coefficient step · conf: high
- [ ] `sum_range_id_mul_neg_two_pow_closed` — Nine times the sum of k times negative-two-to-the-k over k below n equals (2n-3)(-2)^n-2
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; ring handles the signed base (-2)^(k+1) step · conf: high
- [ ] `sum_range_fib_mul_two_pow_eq_lucas` — Five times the sum of Fibonacci-k times two-to-the-k over k below n equals two-to-the-n times the n-th Lucas number (fib(n+1)+fib(n-1)) minus two
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ using Nat.fib_add_two and case-splitting fib(n-1); ring on the resulting Fibonacci-recurrence identity · conf: med
- [ ] `sum_range_lucas_eq_lucas_add_two_sub_three` — The sum of the first n Lucas numbers (each written as fib(k+1)+fib(k-1)) equals fib(n+2)+fib(n)-1
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; unfold fib recurrence and discharge with omega/simp on the Nat subtraction edge cases · conf: med
- [ ] `sum_range_sq_mul_choose_eq_quarter` — Four times the sum over k of k-squared times n-choose-k equals n(n+1)2^n
      absence: no-local-match · triviality: non-trivial · intended: Differentiate the binomial identity twice (absorption Nat.succ_mul_choose_eq) or induct via Pascal; reduce to known k*C(n,k) and C(n,k) sums · conf: med
- [ ] `sum_range_id_mul_choose_eq_half` — Twice the sum over k of k times n-choose-k equals n times two-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Use the absorption identity k*C(n,k)=n*C(n-1,k-1) (Nat.succ_mul_choose_eq) and Nat.sum_range_choose · conf: high
- [ ] `sum_range_succ_div_two_pow_eq_four_sub` — The sum of (k+1) over two-to-the-k for k below n equals four minus (2n+4)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ over ℚ; field_simp then ring on the 2^(k+1) denominators · conf: high
- [ ] `sum_range_id_div_two_pow_eq_two_sub` — The sum of k over two-to-the-k for k below n equals two minus (2n+2)/2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ over ℚ; field_simp and ring on the doubling denominator · conf: high
- [ ] `sum_range_recip_triple_consecutive_shifted_telescope` — The sum of 1/((k+1)(k+2)(k+3)) for k below n telescopes to 1/4 minus 1/(2(n+1)(n+2))
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ over ℚ; field_simp then ring to verify the partial-fraction telescoping step · conf: high
- [x] `alt_sum_range_two_k_add_one_eq_signed_n` — The alternating sum of the odd numbers (2k+1) over k below n equals (-1)^(n+1) times n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; case on parity via pow_succ and close with ring · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 21 candidates

- [ ] `sum_range_k_sq_mul_choose_mul_two_pow_closed` — Nine times the sum over k of k squared times n-choose-k times two-to-the-k equals (4n^2+2n) times three-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Differentiate the binomial theorem twice (k^2 second moment) or induct with Finset.sum_range_succ and Pascal; multiply out to avoid division · conf: med
- [ ] `sum_range_k_mul_choose_mul_two_pow_eq_two_n_three_pow` — Three times the sum of k times n-choose-k times two-to-the-k equals two-n times three-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Use k*C(n,k)=n*C(n-1,k-1) reindexing then binomial theorem (1+2)^(n-1), or induct with Finset.sum_range_succ · conf: high
- [ ] `sum_range_succ_k_mul_choose_mul_two_pow_closed` — Three times the sum of (k+1) times n-choose-k times two-to-the-k equals (2n+3) times three-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Split (k+1)=k+1 into the k-weighted moment plus the plain binomial sum 3^n, combine closed forms · conf: high
- [ ] `sum_range_k_mul_choose_mul_three_pow_closed` — Four times the sum of k times n-choose-k times three-to-the-k equals three-n times four-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Reindex k*C(n,k)=n*C(n-1,k-1), apply binomial theorem (1+3)^(n-1)=4^(n-1); or induct over n · conf: high
- [ ] `sum_range_k_mul_choose_mul_four_pow_closed` — Five times the sum of k times n-choose-k times four-to-the-k equals four-n times five-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Same k*C(n,k)=n*C(n-1,k-1) reindex with binomial theorem (1+4)^(n-1), or induction with Finset.sum_range_succ · conf: high
- [ ] `sum_range_two_k_add_one_mul_choose_eq_succ_two_pow` — The sum of (2k+1) times n-choose-k equals (n+1) times two-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Split into 2*(sum k*C(n,k)=n*2^(n-1)) plus (sum C(n,k)=2^n); combine. Induction also works · conf: high
- [ ] `sum_range_k_fourth_mul_choose_closed` — Sixteen times the sum of k-to-the-fourth times n-choose-k equals n(n+1)(n^2+5n-2) times two-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Touchard/Stirling expansion of k^4 into falling factorials, each k^(j)*C(n,k) summing to n^(j)2^(n-j); assemble; or strong induction. Note n^2+5n-2 over ℕ needs care (true for n>=1, term vanishes at n=0) · conf: med
- [ ] `sum_range_fall_four_mul_choose_mul_two_pow_closed` — Eighty-one times the sum of the falling factorial k(k-1)(k-2)(k-3) times n-choose-k times two-to-the-k equals sixteen times the falling factorial of n times three-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Falling factorial k^(4)*C(n,k)=n^(4)*C(n-4,k-4) reindex, then binomial theorem with x=2 giving 2^4(1+2)^(n-4); clear powers of 3 by the 81 factor · conf: med
- [ ] `sum_range_k_mul_n_sub_k_mul_choose_closed` — Four times the sum of k times (n-k) times n-choose-k equals n(n-1) times two-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Use symmetry k<->n-k of C(n,k) and the identity k(n-k)C(n,k)=n(n-1)C(n-2,k-1); sum to n(n-1)2^(n-2). Mind ℕ subtraction · conf: med
- [ ] `sum_range_choose_mul_choose_shift_two_eq_central_sub_two` — For n at least two, the sum of n-choose-k times n-choose-(k+2) equals the central binomial C(2n, n-2)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde convolution with symmetry C(n,k+2)=C(n,n-k-2); apply Nat.add_choose_le / Vandermonde to collapse to C(2n,n-2) · conf: med
- [ ] `sum_range_choose_mul_choose_shift_three_eq_central_sub_three` — For n at least three, the sum of n-choose-k times n-choose-(k+3) equals the central binomial C(2n, n-3)
      absence: no-local-match · triviality: non-trivial · intended: Same Vandermonde-convolution-with-symmetry pattern as the shift-two case; reflect index and apply Vandermonde · conf: med
- [ ] `sum_range_choose_mul_succ_choose_eq_central_shift_half` — The sum of n-choose-k times (n+1)-choose-k equals C(2n+1, n)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde: rewrite (n+1).choose k = (n+1).choose ((n+1)-k) and apply Nat.add_choose_le / sum_range_choose_mul_choose · conf: high
- [ ] `sum_range_choose_mul_succ_choose_succ_eq_central_shift` — The sum of n-choose-k times (n+1)-choose-(k+1) equals C(2n+1, n+1)
      absence: no-local-match · triviality: non-trivial · intended: Reflect the (n+1) factor via symmetry and apply Vandermonde's convolution to land on C(2n+1,n+1) · conf: high
- [ ] `sum_range_three_choose_mul_choose_rev_eq_central_two` — The three-term Vandermonde slice summing n-choose-k times n-choose-(2-k) for k under three equals C(2n, 2)
      absence: no-local-match · triviality: non-trivial · intended: Expand the fixed-length range-3 sum into three terms, then prove the polynomial identity in n with ring after rewriting choose 2 and choose 1; or apply Vandermonde at r=2 · conf: high
- [ ] `alt_sum_range_k_sq_mul_choose_eq_zero` — For n at least three, the alternating sum of (-1)^k times k squared times n-choose-k vanishes
      absence: no-local-match · triviality: non-trivial · intended: Finite-difference/falling-factorial: write k^2 = k(k-1)+k, each alternating moment is a high-order difference of (1+x)^n at x=-1, zero for n>degree. Reindex and use binomial-theorem over ℤ · conf: med
- [ ] `alt_sum_range_k_cube_mul_choose_eq_zero` — For n at least four, the alternating sum of (-1)^k times k cubed times n-choose-k vanishes
      absence: no-local-match · triviality: non-trivial · intended: Decompose k^3 into falling factorials k(k-1)(k-2)+3k(k-1)+k; each alternating falling-factorial moment is a finite difference vanishing once n exceeds the degree · conf: med
- [ ] `alt_sum_range_choose_sq_eq_zero_odd` — For odd n, the alternating sum of (-1)^k times the square of n-choose-k vanishes
      absence: no-local-match · triviality: non-trivial · intended: Pair the term k with n-k: their signs differ (n odd) while C(n,k)^2 are equal, so they cancel via Finset.sum_involution / reflection over range · conf: high
- [ ] `sum_range_choose_mul_neg_two_pow_eq_neg_one_pow` — The sum of n-choose-k times (-2)-to-the-k equals (-1)-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Apply the integer binomial theorem add_pow / Commute.add_pow to (1 + (-2))^n = (-1)^n over ℤ · conf: high
- [ ] `sum_range_shifted_choose_succ_eq_two_pow_succ_sub_one` — The sum of (n+1)-choose-(k+1) over k up to n equals two-to-the-(n+1) minus one
      absence: no-local-match · triviality: non-trivial · intended: Reindex to the full row sum of (n+1) minus the k=0 term: Nat.sum_range_choose gives 2^(n+1), subtract the missing C(n+1,0)=1 · conf: high
- [ ] `sum_range_two_k_sub_n_mul_choose_sq_eq_zero` — The weighted sum of (2k-n) times the square of n-choose-k vanishes
      absence: no-local-match · triviality: non-trivial · intended: Reflection k<->n-k sends (2k-n) to -(2k-n) while fixing C(n,k)^2; the sum equals its own negation via Finset.sum_involution, hence zero · conf: high
- [ ] `sum_range_succ_choose_eq_half_succ_two_mul_two_pow` — Twice the sum of (k+1) times n-choose-k equals (n+2) times two-to-the-n
      absence: no-local-match · triviality: non-trivial · intended: Split (k+1)C(n,k) into k*C(n,k) (=n*2^(n-1)) plus C(n,k) (=2^n) and combine the closed forms; or induct with Finset.sum_range_succ and Pascal · conf: high
