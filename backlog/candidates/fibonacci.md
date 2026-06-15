# Fibonacci / Lucas identities — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 20 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sum_range_fib_sq_eq_fib_mul_fib_succ` — The sum of the squares of the first n positive-index Fibonacci numbers equals the product of fib n and fib (n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n with Finset.sum_range_succ; step uses fib(n+1)^2 + fib(n)*fib(n+1) = fib(n+1)*fib(n+2) via fib_add_two and ring · conf: high
- [x] `two_mul_sum_range_fib_triple_eq_fib_pred` — Twice the sum of fib at multiples of three up to 3n is one less than fib(3n-1)
      absence: no-local-match · triviality: non-trivial · intended: Induction with Finset.sum_range_succ; step needs fib(3n+2)=fib(3n-1)+2*fib(3n) (expand via fib_add_two repeatedly) plus an omega guard for the Nat subtraction · conf: med
- [x] `sum_range_fib_two_mul_succ_eq_fib_pred` — The sum of the even-positive-index Fibonacci numbers fib 2, fib 4, ..., fib (2n) equals fib(2n+1) minus one
      absence: no-local-match · triviality: non-trivial · intended: Induction via Finset.sum_range_succ using fib(2n+1)+fib(2n+2)=fib(2n+3); omega discharges the truncated Nat subtraction (fib(2n+1) >= 1) · conf: high
- [x] `fib_add_two_sq_sub_fib_sq_eq_fib_two_mul_add_two` — The difference of the squares fib(n+2)^2 - fib(n)^2 equals fib(2n+2)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite via fib_add (fib(2n+2)=fib(n+1)(2fib n+fib(n+1))) and factor the difference of squares with fib(n+2)=fib(n+1)+fib n; ring after a Nat-subtraction guard · conf: high
- [ ] `fib_succ_sq_add_fib_add_two_sq_eq_fib_two_mul_add_three` — The sum of consecutive Fibonacci squares fib(n+1)^2 + fib(n+2)^2 equals fib(2n+3)
      absence: no-local-match · triviality: non-trivial · intended: Apply fib_two_mul_add_one at index n+1 (fib(2(n+1)+1)=fib(n+2)^2+fib(n+1)^2) and rewrite 2*n+3 = 2*(n+1)+1; ring · conf: high
- [x] `fib_add_three_eq_two_mul_fib_succ_add_fib` — fib(n+3) equals twice fib(n+1) plus fib n
      absence: no-local-match · triviality: non-trivial · intended: Unfold fib(n+3) and fib(n+2) with fib_add_two twice, then ring/omega over fib n and fib(n+1) · conf: high
- [x] `fib_add_four_eq_three_mul_fib_add_two_sub_fib` — fib(n+4) equals three times fib(n+2) minus fib n
      absence: no-local-match · triviality: non-trivial · intended: Expand fib(n+4),fib(n+3) via fib_add_two to express both sides in fib n, fib(n+1); discharge with omega (handles the Nat subtraction) · conf: high
- [x] `fib_add_five_eq_five_mul_fib_succ_add_three_mul_fib` — fib(n+5) equals five times fib(n+1) plus three times fib n
      absence: no-local-match · triviality: non-trivial · intended: Repeatedly rewrite fib(n+k) down to fib n and fib(n+1) using fib_add_two, then omega · conf: high
- [x] `fib_add_six_eq_eight_mul_fib_succ_add_five_mul_fib` — fib(n+6) equals eight times fib(n+1) plus five times fib n
      absence: no-local-match · triviality: non-trivial · intended: Telescope fib(n+6) down to fib n and fib(n+1) with six fib_add_two rewrites, then omega · conf: high
- [x] `three_mul_fib_eq_fib_add_two_add_fib_sub_two` — Three times fib(n+2) equals fib(n+4) plus fib n
      absence: no-local-match · triviality: non-trivial · intended: Express fib(n+4),fib(n+2) via fib_add_two in terms of fib n, fib(n+1); omega closes it (shift avoids Nat subtraction) · conf: high
- [ ] `lucas_mul_fib_eq_fib_two_mul` — The Lucas number (fib(n+1)+fib(n-1)) times fib(n+1) expands as fib(2n+1) plus fib(n-1)*fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Distribute the product, replace fib(n+1)^2 via fib_two_mul_add_one (fib(2n+1)=fib(n+1)^2+fib n^2) carefully, then ring; the n-1 stays symbolic so no case split needed beyond rewriting · conf: high
- [ ] `fib_succ_add_fib_add_three_eq_three_mul_fib_add_two` — fib(n+1) plus fib(n+3) equals three times fib(n+2): the Lucas-style sum of fib two apart
      absence: no-local-match · triviality: non-trivial · intended: Rewrite fib(n+3)=fib(n+1)+fib(n+2) and fib(n+2)=fib(n)+fib(n+1) with fib_add_two; omega · conf: high
- [ ] `fib_add_two_add_fib_eq_lucas_succ` — The Lucas number at n+1, written fib(n+2)+fib n, equals twice fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: fib(n+2)=fib n+fib(n+1) by fib_add_two, then omega/simp collapses both sides to 2*fib(n+1) · conf: high
- [x] `cassini_nat_fib_int` — Over the integers, fib n times fib(n+2) minus fib(n+1) squared equals (-1)^(n+1) (a Cassini-form identity for Nat.fib)
      absence: no-local-match · triviality: non-trivial · intended: Induction on n: base by decide/norm_num; step rewrites fib(n+3)=fib(n+1)+fib(n+2) and fib(n+2)=fib n+fib(n+1) (cast fib_add_two), then ring_nf and use pow_succ on (-1) · conf: med
- [ ] `catalan_shift_nat_fib_int` — Over the integers, fib(n+1)*fib(n+3) minus fib(n+2) squared equals (-1)^n
      absence: no-local-match · triviality: non-trivial · intended: Reduce to the Cassini-form at shifted index via cassini_nat_fib_int, or induct directly using cast fib_add_two and (-1)^(n+1) bookkeeping with ring · conf: med
- [x] `consecutive_fib_product_diff_nat_int` — Over the integers, fib n times fib(n+3) minus fib(n+1) times fib(n+2) equals (-1)^(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand fib(n+3)=fib(n+1)+fib(n+2) and fib(n+2)=fib n+fib(n+1) (cast), reduce to Cassini fib n*fib(n+2)-fib(n+1)^2, then ring · conf: med
- [ ] `lucas_sq_sub_five_fib_sq_eq_four_neg_one_pow` — The Lucas number squared minus five times fib n squared equals 4*(-1)^n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, expand the Lucas square, and reduce to Cassini (fib(n-1)*fib(n+1)-fib n^2 = (-1)^n) after rewriting fib(n+1)=fib n+fib(n-1); requires a Nat.fib n>=1 / index bridge and ring · conf: med
- [ ] `lucas_two_mul_eq_lucas_sq_sub_two_neg_one_pow` — The Lucas number at 2n equals the square of the Lucas number at n minus 2*(-1)^n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, rewrite both Lucas numbers in fib, use fib_two_mul / fib_two_mul_add_one to express fib(2n±1) and reduce via Cassini for the (-1)^n term; ring · conf: med
- [ ] `lucas_succ_add_lucas_pred_eq_five_mul_fib` — The sum of the Lucas numbers at n+2 and n equals five times fib(n+1) (stated with a +1 index shift to keep terms in Nat)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite fib(n+3)=fib(n+1)+fib(n+2), fib(n+2)=fib n+fib(n+1), and fib(n+1)=fib n+fib(n-1) via fib_add_two; omega collapses to 5*fib(n+1) · conf: high
- [ ] `fib_two_mul_eq_fib_mul_lucas` — fib(2(n+1)) equals fib(n+1) times the Lucas number (fib(n+2)+fib n), shifted to stay in Nat
      absence: no-local-match · triviality: non-trivial · intended: Use fib_two_mul_add_two (fib(2n+2)=fib(n+1)(2 fib n+fib(n+1))) and rewrite fib(n+2)+fib n = 2 fib n + fib(n+1) via fib_add_two; ring · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 22 candidates

- [ ] `docagne_int_fib_identity` — d'Ocagne's identity: fib(m)·fib(n+1) − fib(m+1)·fib(n) equals (−1)^n·fib(m−n)
      absence: no-local-match · triviality: non-trivial · intended: Induct on n using Int.fib_add and the recurrence; or reduce to Int.fib_add and a Cassini-type lemma · conf: med
- [ ] `catalan_r2_int_fib` — Catalan's identity at offset 2: fib(n)² − fib(n−2)·fib(n+2) = (−1)^n
      absence: no-local-match · triviality: non-trivial · intended: Expand fib(n±2) via Int.fib_add_two and reduce to Cassini fib_succ_mul_fib_pred_sub_fib_sq with ring · conf: high
- [ ] `catalan_r3_int_fib` — Catalan's identity at offset 3: fib(n)² − fib(n−3)·fib(n+3) = 4·(−1)^(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand fib(n±3) via repeated Int.fib_add_two, reduce to Cassini, ring_nf with the (-1)^n parity · conf: med
- [x] `fib_add_four_recurrence_nat` — fib(n+4) + fib(n) = 3·fib(n+2), the second-order Fibonacci recurrence
      absence: no-local-match · triviality: non-trivial · intended: Unfold fib(n+4) and fib(n+2) twice with Nat.fib_add_two and close by omega · conf: high
- [ ] `fib_add_three_double_nat` — fib(n+3) = 2·fib(n+1) + fib(n)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite with Nat.fib_add_two twice and finish with omega · conf: high
- [ ] `fib_three_mul_cubes_int` — fib(3n) = fib(n+1)³ + fib(n)³ − fib(n−1)³
      absence: no-local-match · triviality: non-trivial · intended: Express fib(3n) via Int.fib_add of 2n and n, substitute fib(2n) closed forms, then ring after collecting cubes · conf: med
- [ ] `sum_range_fib_prod_consec_even_nat` — The sum of fib(i+1)·fib(i+2) over the first 2n indices equals fib(2n+1)² − 1
      absence: no-local-match · triviality: non-trivial · intended: Induct on n, using Finset.sum_range_succ twice and the fib(2n) doubling identities, simplify with ring/omega · conf: med
- [x] `sum_range_fib_prod_shift_even_nat` — The sum of fib(i)·fib(i+1) over the first 2n indices equals fib(2n)²
      absence: no-local-match · triviality: non-trivial · intended: Induct on n via Finset.sum_range_succ (two terms per step) and reduce using fib doubling identities and ring · conf: high
- [x] `fib_two_mul_sq_diff_int` — fib(2n) = fib(n+1)² − fib(n−1)², a difference-of-squares doubling formula
      absence: no-local-match · triviality: non-trivial · intended: Start from Int.fib_two_mul, rewrite fib(n+1) and fib(n-1) via fib_add_two, and close with ring · conf: high
- [ ] `fib_sq_diff_telescope_nat` — fib(n+2)² − fib(n)² = fib(2n+2), linking a square difference to a doubled index
      absence: no-local-match · triviality: non-trivial · intended: Use Nat.fib_two_mul_add_two / factor as (fib(n+2)-fib n)(fib(n+2)+fib n)=fib(n+1)·L and rewrite to fib(2n+2) · conf: high
- [ ] `lucas_fib_mn_sum_int` — fib(m+n) + (−1)^n·fib(m−n) = L(n)·fib(m), with L(n)=fib(n−1)+fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Apply Int.fib_add to fib(m+n) and fib(m-n), expand L(n), and combine with ring and parity of (-1)^n · conf: med
- [x] `two_fib_add_int` — 2·fib(m+n) = fib(m)·L(n) + L(m)·fib(n), the symmetric Fibonacci addition law
      absence: no-local-match · triviality: non-trivial · intended: Expand both Lucas terms as fib sums, apply Int.fib_add, and finish with ring · conf: high
- [ ] `two_lucas_add_int` — 2·L(m+n) = L(m)·L(n) + 5·fib(m)·fib(n), the Lucas addition law
      absence: no-local-match · triviality: non-trivial · intended: Rewrite each Lucas number as a fib sum, apply Int.fib_add to all three composite indices, then ring · conf: med
- [ ] `five_fib_sq_eq_lucas_sq_int` — 5·fib(n)² = L(n)² − 4·(−1)^n, relating Fibonacci and Lucas squares
      absence: no-local-match · triviality: non-trivial · intended: Expand L(n) via fib_add_two, square, and reduce using Cassini's identity and ring with parity · conf: med
- [ ] `lucas_sq_add_succ_sq_int` — L(n)² + L(n+1)² = 5·fib(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand both Lucas squares to fib terms, use Int.fib_two_mul_add_one, and close with ring · conf: med
- [ ] `lucas_succ_via_fib_sum_nat` — fib(n) + 2·fib(n+1) = fib(n) + fib(n+2), expressing L(n+1) two equivalent ways
      absence: no-local-match · triviality: non-trivial · intended: Rewrite fib(n+2) with Nat.fib_add_two and finish by omega · conf: high
- [x] `sum_range_lucas_shift_nat` — The sum of L(i+1)=fib(i)+fib(i+2) over the first n indices equals fib(n+1)+fib(n+3)−3
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ, using the partial-sum identity sum fib = fib(n+1)-1 twice, then omega · conf: high
- [ ] `fib_dvd_three_mul_four_nat` — 3 divides fib(4n), since fib(4)=3 divides fib of every multiple of 4
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with 4 ∣ 4*n and rewrite Nat.fib 4 = 3 · conf: high
- [ ] `fib_dvd_eight_mul_six_nat` — 8 divides fib(6n), since fib(6)=8 divides fib of every multiple of 6
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with 6 ∣ 6*n and rewrite Nat.fib 6 = 8 · conf: high
- [ ] `fib_dvd_five_mul_five_nat` — 5 divides fib(5n), since fib(5)=5 divides fib of every multiple of 5
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with 5 ∣ 5*n and rewrite Nat.fib 5 = 5 · conf: high
- [ ] `fib_prod_skip_three_int` — fib(n)·fib(n+3) − fib(n+1)·fib(n+2) = (−1)^(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand fib(n+2),fib(n+3) via Int.fib_add_two, reduce to Cassini, and finish with ring and parity · conf: high
- [ ] `cassini_odd_index_nat` — fib(2n+1)·fib(2n−1) = fib(2n)² + 1, the even-index Cassini identity in Nat form
      absence: no-local-match · triviality: non-trivial · intended: Cast to Int via Cassini fib_succ_mul_fib_pred_sub_fib_sq at an even index where the sign is +1, then descend to Nat · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 21 candidates

- [x] `catalan_r2_shift_nat_fib_int` — Over the integers, the square of fib(n+2) minus fib(n) times fib(n+4) equals (-1)^n, a Catalan identity at offset two shifted to stay in the naturals
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, expand fib(n+4),fib(n+3) via Int.fib_add_two down to fib(n),fib(n+1), reduce to Cassini, then ring with parity of (-1)^n · conf: high
- [x] `catalan_r3_shift_nat_fib_int` — Over the integers, the square of fib(n+3) minus fib(n) times fib(n+6) equals four times (-1)^n, a Catalan identity at offset three
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, repeatedly expand fib(n+k) via Int.fib_add_two to fib(n),fib(n+1), reduce to Cassini, ring_nf with the (-1)^n parity term (fib(3)^2 = 4) · conf: high
- [ ] `catalan_r4_shift_nat_fib_int` — Over the integers, the square of fib(n+4) minus fib(n) times fib(n+8) equals nine times (-1)^n, a Catalan identity at offset four
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, telescope fib(n+8),fib(n+4) via Int.fib_add_two to fib(n),fib(n+1), reduce to Cassini, ring with parity (fib(4)^2 = 9) · conf: med
- [ ] `catalan_r5_shift_nat_fib_int` — Over the integers, the square of fib(n+5) minus fib(n) times fib(n+10) equals twenty-five times (-1)^n, a Catalan identity at offset five
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, expand fib(n+10),fib(n+5) via repeated Int.fib_add_two to fib(n),fib(n+1), reduce to Cassini, ring_nf with parity (fib(5)^2 = 25) · conf: med
- [x] `fib_prod_cross_shift_nat_int` — Over the integers, fib(n+1) times fib(n+2) minus fib(n) times fib(n+3) equals (-1)^n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ℤ, rewrite fib(n+3)=fib(n+1)+fib(n+2) and fib(n+2)=fib(n)+fib(n+1) via Int.fib_add_two, reduce to Cassini fib(n)*fib(n+2)-fib(n+1)^2, ring with parity · conf: high
- [ ] `fib_sq_diff_eq_fib_prod_skip_nat` — The difference of the squares fib(n+2)^2 and fib(n+1)^2 equals fib(n) times fib(n+3)
      absence: no-local-match · triviality: non-trivial · intended: Factor the LHS as (fib(n+2)-fib(n+1))(fib(n+2)+fib(n+1)) = fib(n)*fib(n+3) using Nat.fib_add_two twice; discharge the Nat subtraction with omega / Nat.fib monotonicity guard · conf: high
- [ ] `fib_sq_add_fib_three_sq_eq_two_fib_two_mul_add_three` — The sum of fib(n) squared and fib(n+3) squared equals twice fib(2n+3)
      absence: no-local-match · triviality: non-trivial · intended: Rewrite fib(n+3)=fib(n+1)+fib(n+2) via fib_add_two, expand, and use Nat.fib_two_mul_add_one (fib(2n+1)=fib(n+1)^2+fib(n)^2) at shifted indices; ring · conf: high
- [ ] `two_dvd_fib_three_mul_nat` — Two divides fib(3n), since fib(3)=2 divides fib of every multiple of three
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with (3 : ℕ) ∣ 3 * n and rewrite Nat.fib 3 = 2 to get 2 ∣ fib(3n) · conf: high
- [ ] `fib_dvd_fib_three_mul_nat` — Fib(n) divides fib(3n), since n divides 3n
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with n ∣ 3 * n (Dvd.intro / dvd_mul_left) · conf: high
- [ ] `seven_dvd_fib_eight_mul_nat` — Seven divides fib(8n), since fib(8)=21 is a multiple of seven and divides fib of every multiple of eight
      absence: no-local-match · triviality: non-trivial · intended: Use Nat.fib_dvd to get fib(8) ∣ fib(8n), rewrite Nat.fib 8 = 21, and chain 7 ∣ 21 by dvd_trans · conf: high
- [ ] `four_dvd_fib_six_mul_nat` — Four divides fib(6n), since fib(6)=8 is a multiple of four and divides fib of every multiple of six
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(6) ∣ fib(6n); rewrite Nat.fib 6 = 8 and chain 4 ∣ 8 by dvd_trans · conf: high
- [ ] `eleven_dvd_fib_ten_mul_nat` — Eleven divides fib(10n), since fib(10)=55 is a multiple of eleven and divides fib of every multiple of ten
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(10) ∣ fib(10n); rewrite Nat.fib 10 = 55 and chain 11 ∣ 55 by dvd_trans · conf: high
- [ ] `thirteen_dvd_fib_seven_mul_nat` — Thirteen divides fib(7n), since fib(7)=13 divides fib of every multiple of seven
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(7) ∣ fib(7n); rewrite Nat.fib 7 = 13 · conf: high
- [ ] `six_dvd_fib_twelve_mul_nat` — Six divides fib(12n), since fib(12)=144 is a multiple of six and divides fib of every multiple of twelve
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(12) ∣ fib(12n); rewrite Nat.fib 12 = 144 and chain 6 ∣ 144 by dvd_trans · conf: high
- [ ] `nine_dvd_fib_twelve_mul_nat` — Nine divides fib(12n), since fib(12)=144 is a multiple of nine and divides fib of every multiple of twelve
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(12) ∣ fib(12n); rewrite Nat.fib 12 = 144 and chain 9 ∣ 144 by dvd_trans · conf: high
- [ ] `seventeen_dvd_fib_nine_mul_nat` — Seventeen divides fib(9n), since fib(9)=34 is a multiple of seventeen and divides fib of every multiple of nine
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(9) ∣ fib(9n); rewrite Nat.fib 9 = 34 and chain 17 ∣ 34 by dvd_trans · conf: high
- [ ] `twenty_nine_dvd_fib_fourteen_mul_nat` — Twenty-nine divides fib(14n), since fib(14)=377 is a multiple of twenty-nine and divides fib of every multiple of fourteen
      absence: no-local-match · triviality: non-trivial · intended: Nat.fib_dvd gives fib(14) ∣ fib(14n); rewrite Nat.fib 14 = 377 and chain 29 ∣ 377 by dvd_trans · conf: high
- [ ] `coprime_fib_two_mul_fib_two_mul_add_two_nat` — Fib(2n) and fib(2n+2) are coprime, because the gcd of their indices is two and fib(2)=1
      absence: no-local-match · triviality: non-trivial · intended: Unfold Nat.Coprime to gcd; use Nat.fib_gcd to turn gcd(fib(2n),fib(2n+2)) into fib(gcd(2n,2n+2)), show gcd(2n,2n+2)=2 (omega/Nat.Coprime), and Nat.fib 2 = 1 · conf: high
- [x] `sum_range_window_five_fib_eq_fib_diff_nat` — The sum of five consecutive Fibonacci numbers starting at fib(n) equals fib(n+6) minus fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand the fixed-size Finset.range 5 sum with Finset.sum_range_succ (or decide/simp on the literal), rewrite the fib(n+k) via fib_add_two, and close with omega over the Nat subtraction (fib monotone) · conf: high
- [x] `sum_range_window_four_fib_eq_fib_diff_nat` — The sum of four consecutive Fibonacci numbers starting at fib(n) equals fib(n+5) minus fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Expand the Finset.range 4 sum with Finset.sum_range_succ, rewrite fib(n+k) via fib_add_two, and discharge the Nat subtraction with omega (fib monotone) · conf: high
- [ ] `sum_range_fib_prod_two_apart_even_nat` — The sum of fib(i) times fib(i+2) over the first 2n indices equals fib(2n) times fib(2n+1)
      absence: no-local-match · triviality: non-trivial · intended: Induct on n, peeling two terms per step with Finset.sum_range_succ at indices 2n and 2n+1, then reduce using fib_add_two and the fib doubling identities (fib_two_mul, fib_two_mul_add_one) with ring/omega · conf: med

### Replenishment round 4 (scoped 2026-06-15) — 20 candidates

- [ ] `fib_add_formula_m_n_succ_nat` — The Fibonacci addition formula: fib(m+n+1) equals fib(m+1)*fib(n+1) + fib(m)*fib(n)
      absence: no-local-match · triviality: non-trivial · intended: Induct on n (or m) using Nat.fib_add_two and the recurrence; mathlib may have Nat.fib_add as a lemma to rewrite with · conf: high
- [ ] `fib_two_mul_add_two_eq_fib_succ_mul_nat` — fib(2n+2) equals fib(n+1) times (2*fib(n) + fib(n+1))
      absence: no-local-match · triviality: non-trivial · intended: Specialize the addition formula at m=n+1 (so 2n+2 = (n+1)+(n+1)) then simp/ring; or induct · conf: high
- [ ] `fib_sq_add_fib_add_three_sq_eq_two_fib_two_mul_add_three` — The sum of the squares of fib(n) and fib(n+3) equals twice fib(2n+3)
      absence: no-local-match · triviality: non-trivial · intended: Reduce to the fib(2k+1)=fib(k)^2+fib(k+1)^2 lemma applied at suitable k plus fib recurrence; induction or addition formula + ring · conf: high
- [ ] `fib_two_mul_eq_fib_succ_sq_sub_fib_pred_sq_int` — For n ≥ 1, fib(2n) equals fib(n+1)^2 minus fib(n-1)^2 over the integers
      absence: no-local-match · triviality: non-trivial · intended: Write n = k+1, cast to ℤ, expand both squares via the addition/double-angle fib identities and ring · conf: high
- [ ] `fib_cubes_window_eq_fib_three_mul_int` — For n ≥ 1, fib(n+1)^3 + fib(n)^3 - fib(n-1)^3 equals fib(3n) over the integers
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, cast to ℤ; expand fib(3k+3) via the addition formula in terms of fib k, fib(k+1) and verify the cubic identity by ring (nlinarith fallback) · conf: med
- [ ] `fib_pred_mul_fib_add_two_sub_fib_mul_fib_succ_eq_neg_one_pow` — For n ≥ 1, fib(n-1)*fib(n+2) − fib(n)*fib(n+1) equals (−1)^n over the integers
      absence: no-local-match · triviality: non-trivial · intended: Substitute n=k+1, reduce to Cassini fib(k)fib(k+2)-fib(k+1)^2 = (-1)^(k+1) plus fib recurrence and ring · conf: high
- [ ] `fib_succ_sq_sub_fib_sq_eq_fib_pred_mul_fib_add_two_int` — For n ≥ 1, fib(n+1)^2 − fib(n)^2 equals fib(n-1)*fib(n+2) over the integers
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, expand fib(k+2)=fib(k+1)+fib(k) and fib(n-1)=fib(k), then factor the difference of squares and ring · conf: high
- [ ] `five_fib_mul_fib_succ_eq_lucas_two_mul_add_one_sub_neg_one_pow` — Five times fib(n)*fib(n+1) equals the Lucas number L(2n+1) (written fib(2n)+fib(2n+2)) minus (−1)^n
      absence: no-local-match · triviality: non-trivial · intended: Use fib(2n)+fib(2n+2)=L(2n+1) and the product-to-Lucas identity; cast to ℤ and induct, or reduce via fib addition formula + ring · conf: med
- [ ] `lucas_two_mul_eq_lucas_sq_sub_two_neg_one_pow_fib_form` — For n ≥ 1, the Lucas number L(2n) equals L(n)^2 − 2(−1)^n, with all Lucas numbers written as fib(k-1)+fib(k+1)
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, cast to ℤ, rewrite both Lucas-as-fib forms, expand via fib addition/double formulas and ring (nlinarith if needed) · conf: med
- [ ] `lucas_sq_eq_five_fib_sq_add_four_neg_one_pow_fib_form` — For n ≥ 1, L(n)^2 = 5*fib(n)^2 + 4(−1)^n, with L(n) written as fib(n-1)+fib(n+1)
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, cast, expand the Lucas-as-fib square and use Cassini fib(k)fib(k+2)-fib(k+1)^2=(-1)^(k+1) with ring · conf: high
- [ ] `lucas_cassini_fib_form_int` — The Cassini identity for Lucas numbers: L(n-1)*L(n+1) − L(n)^2 = 5(−1)^(n+1), with Lucas numbers in fib form
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+2, cast to ℤ, expand all Lucas-as-fib terms via fib recurrence and reduce to fib Cassini, then ring · conf: med
- [ ] `docagne_lucas_fib_cross_diff_eq_two_neg_one_pow` — A d'Ocagne-type Lucas identity: fib(n)*L(n+1) − fib(n+1)*L(n) = 2(−1)^(n+1), with Lucas numbers in fib form
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, cast, expand L(n+1)=fib n + fib(n+2) and L(n)=fib(n-1)+fib(n+1), reduce to Cassini and ring · conf: med
- [ ] `fib_mul_lucas_cross_sum_eq_two_fib_two_mul_succ` — fib(n)*L(n+1) + fib(n+1)*L(n) = 2*fib(2n+1), with Lucas numbers written in fib form
      absence: no-local-match · triviality: non-trivial · intended: Set n=k+1, expand the Lucas-as-fib factors, and use fib(2k+1)=fib(k)^2+fib(k+1)^2 plus the recurrence; ring · conf: high
- [ ] `two_mul_sum_range_fib_three_mul_eq_fib_three_mul_pred_sub_one` — For n ≥ 1, twice the sum of fib(3i) for i < n equals fib(3n-1) − 1
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ; the step reduces to a fib recurrence identity provable by simp/omega/ring after fib_add_two rewrites · conf: med
- [ ] `two_mul_sum_range_fib_three_mul_add_one_eq_fib_three_mul` — Twice the sum of fib(3i+1) for i < n equals fib(3n)
      absence: no-local-match · triviality: non-trivial · intended: Induct on n via Finset.sum_range_succ; the inductive step is a fib recurrence among fib(3n), fib(3n+1), fib(3n+3) closed by repeated fib_add_two and ring/omega · conf: med
- [ ] `sum_range_fib_succ_mul_lucas_succ_eq_fib_two_mul_succ_sub_one` — The sum over i < n of fib(i+1)*L(i+1) (Lucas in fib form) equals fib(2n+1) − 1
      absence: no-local-match · triviality: non-trivial · intended: Each term equals fib(2i+2) since fib(k)L(k)=fib(2k); reduce to a telescoping/standard even-index fib sum, induct with sum_range_succ · conf: med
- [ ] `sum_range_lucas_succ_sq_eq_lucas_mul_lucas_succ_sub_two_fib_form` — For n ≥ 1, the sum of L(i+1)^2 for i < n equals L(n)*L(n+1) − 2, with Lucas numbers in fib form
      absence: no-local-match · triviality: non-trivial · intended: Induct on n with Finset.sum_range_succ; the step is the Lucas telescoping L(k+1)^2 = L(k+1)L(k+2)-L(k)L(k+1) provable via fib recurrence + ring · conf: med
- [ ] `coprime_fib_succ_fib_add_two_nat` — Consecutive Fibonacci numbers fib(n+1) and fib(n+2) are coprime
      absence: no-local-match · triviality: non-trivial · intended: Unfold Nat.Coprime to gcd = 1; use Nat.fib_add_two and Nat.gcd recurrence (or induction with Nat.coprime_add_self) to reduce to gcd(fib 1, fib 2)=1 · conf: high
- [ ] `coprime_fib_add_two_fib_nat` — fib(n+2) and fib(n) are coprime for all n
      absence: no-local-match · triviality: non-trivial · intended: Rewrite fib(n+2)=fib(n+1)+fib(n); gcd(fib(n+1)+fib n, fib n)=gcd(fib(n+1),fib n)=1 via consecutive-coprime · conf: high
- [ ] `fib_two_mul_add_three_eq_cross_prod_sum_nat` — fib(2n+3) equals fib(n+1)*fib(n+2) + fib(n+2)*fib(n+3)
      absence: no-local-match · triviality: non-trivial · intended: Apply the fib addition formula fib(a+b+1)=fib(a+1)fib(b+1)+fib(a)fib(b) with a=n+1, b=n+1 shifted, then simp/ring · conf: high
