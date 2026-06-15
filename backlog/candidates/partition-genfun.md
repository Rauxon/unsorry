# Partition / generating-function coefficient facts — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 18 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [ ] `sum_range_choose_mul_fib_eq_fib_two_mul` — The binomial transform of the Fibonacci numbers gives every second Fibonacci number: the sum over k of C(n,k)·F(k) equals F(2n)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using Pascal's rule and fib_add / the doubling identity; or a generating-function/binomial-transform lemma · conf: med
- [ ] `sum_range_choose_mul_fib_succ_eq_fib` — The shifted binomial transform of the Fibonacci numbers gives the odd-index Fibonacci numbers: the sum over k of C(n,k)·F(k+1) equals F(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Pascal's rule, paired with the companion C(n,k)·F(k)=F(2n) identity and fib_add_two · conf: med
- [ ] `fib_sq_add_fib_succ_sq_eq_fib_two_mul_succ` — The sum of the squares of two consecutive Fibonacci numbers is the Fibonacci number of odd index 2n+1
      absence: no-local-match · triviality: non-trivial · intended: Specialise fib_add with m=n (so fib(2n+1)=fib n^2 + fib(n+1)^2), or induct with fib_add_two · conf: high
- [ ] `alt_sum_range_fib_eq_signed_fib_pred` — The alternating sum of the first n+1 Fibonacci numbers has the signed closed form (-1)^n·F(n+1) - F(n)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; collapse the step using fib_add_two and push_cast/ring over ℤ · conf: high
- [ ] `sum_range_choose_mul_four_pow_eq_five_pow` — Weighting the binomial coefficients of row n by powers of 4 sums to 5^n
      absence: no-local-match · triviality: non-trivial · intended: Instantiate the binomial theorem with 1 and 4, rewriting 1+4=5; the Finset sum is not closed by a single battery tactic · conf: high
- [ ] `sum_range_choose_mul_succ_eq_add_two_mul_two_pow` — Weighting row n of Pascal's triangle by (k+1) sums to (n+2)·2^(n-1)
      absence: no-local-match · triviality: non-trivial · intended: Split (k+1)·C(n,k) = k·C(n,k) + C(n,k), then use sum_range_mul_choose and Nat.sum_range_choose; handle n=0 separately · conf: high
- [ ] `alt_sum_range_k_mul_choose_eq_zero` — For row index at least two, the alternating sum of k·C(n,k) vanishes
      absence: no-local-match · triviality: non-trivial · intended: Use k·C(m,k)=m·C(m-1,k-1) to reduce to the alternating row sum Int.alternating_sum_range_choose, which is zero for m≥1 · conf: med
- [ ] `sum_range_choose_mul_choose_succ_eq_central` — Summing the products of horizontally adjacent entries in row n of Pascal's triangle gives the central-adjacent binomial coefficient C(2n, n+1)
      absence: no-local-match · triviality: non-trivial · intended: Vandermonde/Cauchy convolution: rewrite C(n,k+1)=C(n,n-1-k) and apply Nat.add_pow_le / choose_symm with Nat.choose_sum_pow style Vandermonde · conf: med
- [x] `sum_range_k_mul_factorial_eq_factorial_succ_sub_one` — The sum of k·k! for k up to n telescopes to (n+1)! - 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; the step uses k·k! = (k+1)! - k! and Nat.factorial_succ, watching Nat subtraction · conf: high
- [x] `sum_range_two_k_add_one_mul_two_pow_closed` — The sum of (2k+1)·2^k for k up to n has the closed form (2n-1)·2^(n+1) + 3 over the integers
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ over ℤ; close each step with ring after push_cast · conf: high
- [ ] `sum_range_choose_div_succ_eq_two_pow_sub_one_div` — The sum of C(n,k)/(k+1) over a row equals (2^(n+1) - 1)/(n+1) as a rational
      absence: no-local-match · triviality: non-trivial · intended: Use C(n,k)/(k+1) = C(n+1,k+1)/(n+1) (succ_mul_choose_eq) to reindex into a partial row sum, then Nat.sum_range_choose over ℚ · conf: med
- [ ] `alt_sum_range_choose_sq_odd_eq_zero` — For an odd row, the alternating sum of the squares of the binomial coefficients vanishes
      absence: no-local-match · triviality: non-trivial · intended: Pair term k with term (m-k) using choose_symm and the parity of (-1)^k over an odd-length row; the involution cancels in pairs · conf: med
- [x] `sum_range_recip_choose_two_eq_two_n_div_succ` — The sum of the reciprocals of the binomial coefficients C(k+2,2) telescopes to 2n/(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite 1/C(k+2,2) = 2·(1/(k+1) - 1/(k+2)) and telescope via Finset.sum_range_succ over ℚ · conf: high
- [ ] `central_binom_eq_sum_range_choose_mul_choose` — The central binomial coefficient C(2n,n) is the Vandermonde self-convolution of row n of Pascal's triangle
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.add_pow_le-free Vandermonde (Nat.choose_symm to fold one factor, then the Cauchy/Vandermonde convolution identity) · conf: high
- [x] `fib_two_mul_eq_fib_mul_two_mul_fib_succ_sub_fib` — The Fibonacci doubling identity in additive form: F(2n) + F(n)^2 equals F(n)·2F(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Derive from fib_add with m=n minus one, i.e. F(2n)=F(n)(2F(n+1)-F(n)); rearrange over ℕ avoiding subtraction by moving F(n)^2 to the left · conf: high
- [ ] `sum_range_fib_mul_choose_two_eq` — A weighted Fibonacci partial sum: twice the sum of (k+1)·F(k) over a range equals (n+1)·F(n+2) - F(n+3) + 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ, combining the known sum F(k)=F(n+2)-1 with the index-weighted Abel summation; track Nat subtraction carefully · conf: med
- [ ] `sum_range_two_pow_mul_fib_succ_sub_fib` — A 2^k-weighted telescoping sum of consecutive Fibonacci differences collapses to 2^(n+1)·F(n+1) - 1
      absence: no-local-match · triviality: non-trivial · intended: Note F(k+2)-F(k)=F(k+1); then induct over ℤ with Finset.sum_range_succ, closing the step with fib_add_two and ring · conf: med
- [x] `sum_range_catalan_mul_catalan_eq_catalan_succ` — The Catalan numbers satisfy the convolution recurrence: the self-convolution of the first n+1 Catalan numbers gives C(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite catalan_succ (a Fin-indexed convolution) as a Finset.range sum via Fin.sum_univ_eq_sum_range and Nat.sub bookkeeping · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 18 candidates

- [x] `sum_range_compositions_count_eq_two_pow` — Summing the number of compositions of n+1 into k parts (binom(n, k-1)) over all part counts gives 2^n, the total number of compositions
      absence: no-local-match · triviality: non-trivial · intended: Reindex to ∑ binom(n,j) over j and apply Nat.sum_range_choose; or induct with Pascal · conf: high
- [ ] `sum_range_compositions_parts_total_eq` — The total number of parts across all compositions of n+2 equals (n+3)·2^n
      absence: no-local-match · triviality: non-trivial · intended: Split j·C = C + (j-1)·C, reindex, use sum_range_choose and ∑ k·C(m,k)=m·2^(m-1) · conf: med
- [x] `sum_range_vandermonde_self_eq_central_choose` — The self-convolution of binomial coefficients of n at total degree r equals binom(2n, r), a Vandermonde/generating-function product identity
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.add_choose_le / Nat.choose_symm_diff via Nat.add_pow_le; really use Nat.sum_range_choose_mul_pow style: invoke Nat.add_choose_le or Finset.sum_range_choose_mul through Vandermonde (Nat.add_choose_eq) · conf: high
- [ ] `sum_range_neg_binom_half_eq_two_pow` — The truncated negative-binomial generating sum of binom(n+k, k)/2^k from k=0 to n equals 2^n
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using the hockey-stick/Pascal recurrence binom(n+1+k,k)=binom(n+k,k)+binom(n+k,k-1) and field_simp · conf: med
- [ ] `sum_range_k_mul_choose_mul_two_pow_eq` — The weighted binomial sum of k·binom(n,k)·2^k equals 2n·3^(n-1), the derivative of (1+2x)^n evaluated at x=1
      absence: no-local-match · triviality: non-trivial · intended: Use k·C(n,k)=n·C(n-1,k-1), reindex, then ∑ C(n-1,j)2^(j+1)=2·3^(n-1) · conf: med
- [ ] `sum_range_choose_mul_k_mul_k_pred_eq` — The second-falling-factorial weighted binomial sum ∑ binom(n+2,k)·k(k-1) equals (n+2)(n+1)·2^n
      absence: no-local-match · triviality: non-trivial · intended: Use k(k-1)·C(m,k)=m(m-1)·C(m-2,k-2), reindex twice, then ∑ C(m-2,j)=2^(m-2) · conf: med
- [ ] `alt_sum_range_choose_div_succ_eq_recip_succ` — The alternating binomial sum ∑ (-1)^k·binom(n,k)/(k+1) telescopes to 1/(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite C(n,k)/(k+1)=C(n+1,k+1)/(n+1), reindex, apply alternating-row-sum vanishing · conf: med
- [ ] `sum_range_choose_diag_eq_fib_succ` — Summing binom(n-k, k) along a shallow diagonal of Pascal's triangle counts compositions of n into 1s and 2s, giving the Fibonacci number F(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Strong/two-step induction matching the Fibonacci recurrence, splitting the top diagonal term via Pascal · conf: med
- [x] `sum_range_fib_mul_two_pow_rev_eq` — The generating-function-weighted sum of Fibonacci numbers ∑ F(k)·2^(n-k) plus F(n+3) equals 2^(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using Nat.fib_add_two and 2^(n+1-k)=2·2^(n-k); additive form avoids Nat subtraction · conf: high
- [ ] `sum_range_inclusion_exclusion_surjections_eq_factorial` — The inclusion–exclusion alternating sum ∑ (-1)^k·binom(n,k)·(n-k)^n counts surjections of an n-set onto itself and equals n!
      absence: no-local-match · triviality: non-trivial · intended: Relate to Stirling numbers of the second kind / finite differences of x^n; use Int.alternating_sum_range_choose with the n-th forward difference of the monomial · conf: med
- [x] `sum_icc_k_mul_three_k_sub_one_eq` — The sum of k(3k-1) for k from 1 to n, twice the generalized pentagonal numbers, equals n²(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top, then ring/omega on the step · conf: high
- [x] `sum_icc_k_mul_three_k_add_one_eq` — The sum of k(3k+1) for k from 1 to n, twice the negative-index generalized pentagonal numbers, equals n(n+1)²
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top and ring · conf: high
- [x] `two_mul_sum_icc_three_k_sub_two_eq_pentagonal` — Twice the sum of (3k-2) for k from 1 to n equals n(3n-1), making the n-th partial sum the pentagonal number P_n
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_Icc_succ_top, clearing Nat subtraction via the doubled form and omega · conf: high
- [x] `sum_range_succ_mul_two_pow_eq_closed` — The derivative-of-geometric-series sum ∑ (k+1)·2^k from k=0 to n has closed form n·2^(n+1)+1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ and ring · conf: high
- [ ] `sum_range_choose_mul_pow_three_eq_two_pow_two_n` — The binomial expansion ∑ binom(n,k)·3^(n-k) equals 4^n = (1+3)^n
      absence: no-local-match · triviality: non-trivial · intended: Rewrite as 1^k·3^(n-k) and apply add_pow / Nat.sum_range_choose_mul_pow (binomial theorem) · conf: high
- [x] `sum_range_fib_sq_mul_two_eq` — Twice the running sum of squared Fibonacci numbers relates the telescoping products F(n)F(n+1) and F(n+1)F(n+2) minus F(n+1)²
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ and Nat.fib_add_two; doubled form keeps everything in ℕ · conf: high
- [ ] `sum_range_two_pow_mul_fib_succ_eq` — The reversed convolution ∑ 2^k·F(n-k) plus F(n+3) equals 2^(n+1), a generating-function product fact
      absence: no-local-match · triviality: non-trivial · intended: Induction reindexing the convolution; additive form avoids Nat subtraction in the target · conf: med
- [ ] `sum_range_choose_mul_four_pow_rev_eq_five_pow` — The binomial expansion ∑ binom(n,k)·4^(n-k) equals 5^n = (1+4)^n
      absence: no-local-match · triviality: non-trivial · intended: Apply the binomial theorem add_pow with the 1^k·4^(n-k) split and Nat.sum_range_choose_mul_pow · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 22 candidates

- [ ] `sum_range_stirling_second_row_eq_bell_succ` — The Bell number (row sum of Stirling numbers of the second kind) satisfies the Bell recurrence B(n+1) = sum over j of C(n,j)·B(j), here phrased so the n-th row sum equals the binomial-transform of the smaller row sums
      absence: no-local-match · triviality: non-trivial · intended: Identify both sides as Bell numbers; prove the Bell recurrence by counting set partitions via the block containing the last element, using stirlingSecond_succ_succ and Vandermonde/Pascal reindexing · conf: med
- [x] `sum_range_stirling_first_row_eq_factorial` — The sum of the unsigned Stirling numbers of the first kind across a full row equals n factorial, since every permutation of an n-set decomposes into some number of cycles
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with stirlingFirst_succ_succ; the step Finset.sum splits via the recurrence stirlingFirst (n+1) k = n·stirlingFirst n k + stirlingFirst n (k-1) and collapses to n·n! + n! = (n+1)! · conf: high
- [ ] `stirling_second_col_two_eq_two_pow_sub_one` — The number of ways to partition an (n+2)-element set into exactly two non-empty blocks is 2^(n+1) - 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using stirlingSecond_succ_left / stirlingSecond_succ_succ with stirlingSecond_one_right = 1; the recurrence S(m+1,2)=2·S(m,2)+1 gives 2·(2^k-1)+1 = 2^(k+1)-1, handling Nat subtraction with omega · conf: high
- [ ] `stirling_second_col_three_closed` — Twice the number of partitions of an (n+3)-set into exactly three non-empty blocks equals 3^(n+2) - 2^(n+3) + 1
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with stirlingSecond_succ_left and the column-2 closed form; the doubled form keeps everything in ℕ, closing the step with omega after substituting S(m,2)=2^(m-1)-1 · conf: med
- [ ] `stirling_second_succ_succ_recurrence_nat` — The Stirling-number-of-the-second-kind triangle obeys S(n+2,k+1) = (k+1)·S(n+1,k+1) + S(n+1,k), the partition-into-blocks recurrence at a shifted index
      absence: no-local-match · triviality: non-trivial · intended: Unfold via stirlingSecond_succ_succ (which gives S(m+1,j+1)=(j+1)·S(m,j+1)+S(m,j)) at m=n+1; not closed by a single battery tactic because stirlingSecond is not a decide-friendly closed form · conf: high
- [ ] `numderangements_four_eq_nine` — There are exactly 9 derangements (fixed-point-free permutations) of a four-element set
      absence: no-local-match · triviality: non-trivial · intended: Unfold numDerangements via numDerangements_add_two twice down to numDerangements_zero and numDerangements_one; decide does not reduce the recursive definition without the rewrite lemmas, so a real unfold chain is needed · conf: high
- [ ] `numderangements_mul_recurrence` — The number of derangements obeys the single-step recurrence D(n+1) = (n+1)·D(n) + (-1)^(n+1) over the integers
      absence: no-local-match · triviality: non-trivial · intended: Induction on n using numDerangements_add_two (D(m+2)=(m+1)(D(m+1)+D(m))); substitute the inductive form of D(m+1) and simplify the sign powers with ring over ℤ · conf: med
- [x] `numderangements_add_two_int_form` — The derangement count of an (n+2)-set is (n+1) times the sum of the derangement counts of the (n+1)- and n-element sets, stated over the integers
      absence: no-local-match · triviality: non-trivial · intended: Push numDerangements_add_two through the integer cast with push_cast / Nat.cast_add; needs the defining recurrence rewrite rather than any battery tactic · conf: high
- [ ] `sum_range_multichoose_succ_eq_choose` — The cumulative stars-and-bars hockey-stick: summing multichoose(n+1, j) = C(n+j, j) over j from 0 to m gives C(n+m+1, m)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite multichoose_eq to C(n+j,j), then induct on m with Finset.sum_range_succ and Pascal's rule (Nat.succ_sub_one / Nat.choose_succ_succ) for the hockey-stick collapse · conf: high
- [ ] `multichoose_two_eq_choose_succ_two` — The number of size-2 multisets from an n-element set equals C(n+1, 2), the number of unordered pairs with repetition
      absence: no-local-match · triviality: non-trivial · intended: Rewrite multichoose_eq giving (n+1).choose 2; for n=0 both are 0, otherwise it is definitional after Nat.add_sub_cancel — a real index-bookkeeping rewrite, not a single battery tactic · conf: high
- [x] `sum_range_multichoose_two_eq_choose_succ_two` — Summing the size-j multiset counts from a two-element set over j up to m gives the triangular number C(m+2, 2)
      absence: no-local-match · triviality: non-trivial · intended: Use multichoose_two (= j+1) to turn the sum into ∑ (j+1) = (m+1)(m+2)/2; then identify with choose_two_right and close with omega/ring after Gauss summation · conf: high
- [ ] `sum_range_multichoose_vandermonde` — The multiset coefficients satisfy a Vandermonde-type convolution: the self-convolution of multichoose(a+1,·) and multichoose(b+1,·) at degree m equals multichoose(a+b+2, m)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite each multichoose via multichoose_eq into ordinary binomials C(a+j,j)·C(b+m-j,m-j) and apply Nat.add_choose_le / Vandermonde (Nat.choose_symm plus the Cauchy convolution) reindexed over the range · conf: med
- [ ] `ascfactorial_eq_factorial_mul_choose_shift` — The rising factorial (n+1)^(k rising) equals k! times C(n+k, k), the standard rising-factorial / binomial bridge
      absence: no-local-match · triviality: non-trivial · intended: Direct from ascFactorial_eq_factorial_mul_choose, or induct on k with ascFactorial_succ and Nat.succ_mul_choose_eq; the multiplicative structure resists any single battery tactic · conf: high
- [ ] `sum_range_ascfactorial_telescope` — The partial sums of the rising factorials 2^(k rising) telescope: their running sum up to n equals 2^(n rising) minus one
      absence: no-local-match · triviality: non-trivial · intended: Establish ascFactorial 2 (k+1) - ascFactorial 2 k = (k+1)·ascFactorial 2 k via ascFactorial_succ, identify the telescoping difference, then induct with Finset.sum_range_succ guarding Nat subtraction with omega · conf: med
- [ ] `sum_icc_three_k_sub_one_eq_second_pentagonal` — Twice the sum of (3k-1) for k from 1 to n equals n(3n+1), so the n-th partial sum is the second (negative-index) generalized pentagonal number
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top; the doubled form clears the 3k-1 Nat subtraction so each step closes with omega · conf: high
- [ ] `sum_icc_four_k_sub_three_eq_octagonal` — The sum of (4k-3) for k from 1 to n equals n(2n-1), the n-th octagonal number
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top; track the 4k-3 and 2n-1 Nat subtractions and close each step with omega · conf: high
- [ ] `sum_icc_five_k_sub_four_eq_heptagonal` — Twice the sum of (5k-4) for k from 1 to n equals n(5n-3), making the n-th partial sum the heptagonal number
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_Icc_succ_top in doubled form so the 5k-4 Nat subtraction stays nonnegative; close with omega · conf: high
- [ ] `sum_range_k_mul_factorial_add_one_eq_factorial` — The factorial-number-system identity: summing k·k! over k below n and adding one gives n!, since each k·k! telescopes to (k+1)! − k!
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; the step uses k·k! = (k+1)! − k! (Nat.factorial_succ) and the additive +1 form sidesteps Nat subtraction, finishing with ring/omega · conf: high
- [ ] `sum_range_choose_shallow_diag_eq_fib` — Summing C(n-k, k) along a shallow diagonal of Pascal's triangle counts compositions of n into parts 1 and 2 and equals the Fibonacci number F(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Two-step (strong) induction matching the Fibonacci recurrence: split the diagonal sum into the k=0 term plus a Pascal-shifted sum, aligning F(n+1)=F(n)+F(n-1); careful Nat.sub bookkeeping · conf: med
- [ ] `sum_range_stirling_second_mul_descfactorial_eq_pow` — The fundamental Stirling expansion of the monomial: x^n equals the sum over k of S(n,k) times the falling factorial x·(x-1)···(x-k+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n; use x·descFactorial x k = descFactorial x (k+1) + k·descFactorial x k and stirlingSecond_succ_succ to push x^(n+1)=x·x^n through, reindexing the Finset sum and matching the (k+1)-shift · conf: med
- [ ] `sum_range_stirling_second_two_mul_choose_eq` — The number of partitions of an (n+1)-set into two blocks equals the sum of the binomial coefficients C(n, j+1) over j, i.e. half the count of non-trivial ordered splits
      absence: no-local-match · triviality: non-trivial · intended: Show both sides equal 2^n - 1: the left by the column-2 closed form, the right by Nat.sum_range_choose minus the j=0 term (C(n,0)=1); reconcile with omega and reindexing · conf: med
- [ ] `sum_range_multichoose_three_eq_choose_cube_pos` — Summing the size-j multiset counts from a three-element set over j up to m gives the tetrahedral number C(m+3, 3)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite multichoose 3 j via multichoose_eq to C(j+2,2), then telescope the hockey-stick sum of C(j+2,2) into C(m+3,3) by induction with Finset.sum_range_succ and Pascal's rule · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 21 candidates

- [ ] `sum_range_k_sq_mul_choose_eq_n_succ_mul_two_pow` — Four times the binomial-weighted sum of k-squared over the n-th Pascal row equals n(n+1)2^n
      absence: no-local-match · triviality: non-trivial · intended: Second-derivative of (1+x)^n at x=1; induction on n with Finset.sum_range_succ and Nat.succ_mul_choose_eq, or differentiate the binomial generating function twice · conf: high
- [ ] `sum_range_k_cube_mul_choose_eq_n_sq_mul_three_add_mul_two_pow` — Eight times the binomial-weighted sum of k-cubed over the n-th Pascal row equals n^2(n+3)2^n
      absence: no-local-match · triviality: non-trivial · intended: Third-order operator x d/dx applied to (1+x)^n at x=1; induction reducing to the k^2 and k^1 weighted-row sums, k*C(n,k)=n*C(n-1,k-1) · conf: med
- [ ] `sum_range_k_mul_choose_mul_two_pow_eq_two_n_mul_three_pow` — Three times the sum of k·C(n,k)·2^k over the n-th row equals 2n·3^n
      absence: no-local-match · triviality: non-trivial · intended: x d/dx of (1+x)^n at x=2; rewrite k*C(n,k)=n*C(n-1,k-1) then re-index to n*sum C(n-1,j)2^(j+1)=2n*3^(n-1) · conf: high
- [ ] `sum_range_k_mul_choose_mul_three_pow_eq_three_n_mul_four_pow` — Four times the sum of k·C(n,k)·3^k over the n-th row equals 3n·4^n
      absence: no-local-match · triviality: non-trivial · intended: x d/dx of (1+x)^n at x=3; k*C(n,k)=n*C(n-1,k-1) plus re-index to n*3*sum C(n-1,j)3^j = 3n*4^(n-1) · conf: high
- [ ] `sum_range_k_mul_choose_sq_eq_n_mul_central_binom_pred` — The sum of k·C(n,k)^2 over the n-th row equals n·C(2n-1,n-1)
      absence: no-local-match · triviality: non-trivial · intended: k*C(n,k)=n*C(n-1,k-1), turn into n*∑ C(n-1,k-1)C(n,k) and apply Vandermonde to collapse to a single central binomial coefficient · conf: med
- [ ] `sum_range_choose_mul_fib_succ_eq_fib_two_n_succ` — The binomial transform of the shifted Fibonacci numbers F(k+1) gives F(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Binomial transform via Fibonacci doubling F(2n+1)=F(n)^2+F(n+1)^2; induct on n using Nat.fib_add and the Pascal recurrence to split the row · conf: med
- [ ] `sum_range_choose_mul_lucas_succ_eq_lucas_two_n_succ` — The binomial transform of the shifted Lucas numbers L(k+1) equals L(2n+1) (Lucas written via Fibonacci as 2F(m+1)-F(m))
      absence: no-local-match · triviality: non-trivial · intended: Express Lucas as 2*fib(m+1)-fib(m), split the binomial sum into two shifted-Fibonacci binomial transforms, each evaluating by the Fibonacci doubling identity · conf: med
- [ ] `alt_sum_range_choose_mul_fib_eq_neg_fib` — The signed binomial transform of the Fibonacci numbers gives minus F(n)
      absence: no-local-match · triviality: non-trivial · intended: Binet/golden-ratio: (1-phi)^n and (1-psi)^n give -F(n) by phi+psi shift; in Lean induct on n with Nat.fib_add and the alternating Pascal split · conf: med
- [ ] `alt_sum_range_choose_mul_lucas_eq_lucas` — The signed binomial transform of the Lucas numbers L(k) reproduces L(n) itself
      absence: no-local-match · triviality: non-trivial · intended: Write Lucas as 2*fib(k+1)-fib(k); reduce to the signed-Fibonacci binomial transform identities and combine, using the n=0 base case L(0)=2 · conf: med
- [ ] `alt_sum_range_choose_mul_k_pow_eq_neg_one_pow_factorial` — The n-th finite difference of the monomial x^n evaluated at 0 equals (-1)^n n! (top-degree finite-difference identity)
      absence: no-local-match · triviality: non-trivial · intended: n-th forward difference of x^n is n!; relate via Stirling numbers (Nat.stirling / surjections) or induct using the difference operator Δ lowering degree, base on factorial · conf: med
- [ ] `alt_sum_range_choose_mul_k_pow_pred_eq_zero` — The n-th finite difference of a polynomial of degree below n vanishes, shown for the monomial x^(n-1)
      absence: no-local-match · triviality: non-trivial · intended: Finite-difference operator Δ^n kills any polynomial of degree < n; reduce x^(n-1) over Stirling-number expansion where every term has degree < n and applies the Δ^n-annihilation lemma · conf: med
- [ ] `central_binom_sub_central_binom_succ_eq_catalan` — The difference of two adjacent central-row binomials equals the n-th Catalan number
      absence: no-local-match · triviality: non-trivial · intended: Rewrite both binomials with Nat.choose_symm_diff / succ_sub_one and Nat.centralBinom, then use catalan = centralBinom/(n+1) and the C(2n,n)-C(2n,n+1) ballot identity · conf: high
- [ ] `sum_range_central_trinomial_row_eq_trinomial_coeff` — The central trinomial coefficient counted as a diagonal of products of binomials equals the even-index-row form summing C(n,2k)C(2k,k)
      absence: no-local-match · triviality: non-trivial · intended: Both sides equal the constant term of (x + 1 + 1/x)^n; reindex C(n,k)C(n-k,k) = C(n,2k)C(2k,k) termwise via a choose-mul-choose subset-of-subset identity and cancel · conf: med
- [ ] `sum_icc_three_k_add_one_eq_n_mul_succ_sq` — The running sum of twice the second generalized pentagonal numbers k(3k+1) equals n(n+1)^2
      absence: no-local-match · triviality: non-trivial · intended: Induction on n via Finset.sum_Icc_succ_top, then ring; or convert to range and combine Gauss and square-pyramidal closed forms · conf: high
- [ ] `sum_range_second_pentagonal_double_eq_cube_form` — Twice the partial sum over the second-pentagonal weights k(3k+1) telescopes to (n-1)n(n+1)+(n-1)n
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ; handle the Nat predecessor by casing on n then ring; alternatively recognize k(3k+1)=(k+1)^3-k^3-... telescoping cubes · conf: high
- [ ] `card_filter_two_mul_le_eq_div_two_succ` — The number of partitions of n into parts of size at most 2 (counting 2's used) is floor(n/2)+1
      absence: no-local-match · triviality: non-trivial · intended: Show the filtered set equals Finset.range (n/2 + 1) by an antisymmetry on 2*b ≤ n ↔ b ≤ n/2 (Nat.le_div_iff_mul_le), then Finset.card_range · conf: high
- [ ] `card_filter_add_eq_two_part_partition_eq_div_two` — The number of partitions of n into exactly two positive parts equals floor(n/2)
      absence: no-local-match · triviality: non-trivial · intended: Map a smaller part a (1 ≤ a ≤ n/2) bijectively to the partition (a, n-a); show the filter equals Finset.Icc 1 (n/2) via Nat.le_div_iff_mul_le and Finset.card_Icc · conf: high
- [ ] `stars_bars_triples_card_eq_choose_add_two` — The number of ordered triples of nonnegative integers summing to n (stars and bars) is C(n+2,2)
      absence: no-local-match · triviality: non-trivial · intended: Stars-and-bars for three parts; induct on n peeling off the first coordinate so the count is ∑_{a≤n}(n-a+1) = ∑ (j+1) = C(n+2,2), or build the multiset bijection · conf: high
- [ ] `sum_range_fib_mul_two_pow_rev_eq_fib_two_mul` — The binomial transform of the even-index Fibonacci numbers F(2k) equals F(n)·L(n) = F(2n)
      absence: no-local-match · triviality: non-trivial · intended: Use F(2k)=F(k)L(k) and the generating-function identity ∑ C(n,k)F(2k) = F(2n)=F(n)L(n); induct via Nat.fib_two_mul and the binomial-transform doubling already established for F(k+1) · conf: med
- [ ] `sum_range_choose_mul_pow_five_eq_neg_four_pow_signed` — Evaluating the signed n-th Pascal row generating polynomial at x=5 gives (-4)^n
      absence: no-local-match · triviality: non-trivial · intended: Recognize ∑ C(n,k)(-5)^k = (1-5)^n = (-4)^n via Commute.add_pow / Int.add_pow over Finset.range (n+1) · conf: high
- [ ] `sum_range_k_mul_pred_mul_choose_eq_n_mul_pred_two_pow` — Four times the falling-factorial-weighted Pascal-row sum k(k-1)C(n,k) equals n(n-1)2^n
      absence: no-local-match · triviality: non-trivial · intended: Second forward derivative: k(k-1)C(n,k)=n(n-1)C(n-2,k-2); reindex to n(n-1)∑ C(n-2,j) = n(n-1)2^(n-2), then clear the factor of 4 · conf: high
