# GCD / coprimality / Euclidean identities — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 23 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `coprime_n_sq_n_add_one` — n is coprime to n squared plus n plus one
      absence: no-local-match · triviality: non-trivial · intended: Rewrite n^2+n+1 = n*(n+1)+1 and reduce gcd via Nat.Coprime / gcd_add_mul_right to gcd n 1 = 1 · conf: high
- [x] `coprime_2n1_3n2` — 2n+1 and 3n+2 are always coprime
      absence: no-local-match · triviality: non-trivial · intended: Bezout: 3*(2n+1) - 2*(3n+2) = -1, so any common divisor divides 1; reduce gcd by subtraction · conf: high
- [x] `coprime_2n1_2n3` — Two consecutive odd numbers 2n+1 and 2n+3 are coprime
      absence: no-local-match · triviality: non-trivial · intended: Common divisor divides their difference 2 and an odd number, so divides gcd(2,odd)=1; gcd_rec reduction · conf: high
- [x] `coprime_3n1_4n1` — 3n+1 and 4n+1 are always coprime
      absence: no-local-match · triviality: non-trivial · intended: 4*(3n+1) - 3*(4n+1) = 1, so the gcd divides 1; reduce via Nat.Coprime gcd subtraction lemmas · conf: high
- [x] `coprime_n_cube_add_one` — n is coprime to n cubed plus one
      absence: no-local-match · triviality: non-trivial · intended: n^3+1 = n*n^2 + 1, so gcd n (n*n^2+1) = gcd n 1 = 1 via the add-multiple gcd reduction · conf: high
- [ ] `coprime_nsq1_n1` — If n squared plus one is coprime to n plus one then n is odd
      absence: no-local-match · triviality: non-trivial · intended: n^2+1 ≡ 2 mod (n+1) since n ≡ -1, so coprimality forces n+1 odd; contrapose on parity via ZMod/omega · conf: high
- [x] `coprime_consec_tri` — The odd number 2n+1 is coprime to the product n(n+1)
      absence: no-local-match · triviality: non-trivial · intended: 2n+1 is coprime to n and to n+1 separately (each a Bezout 1-step), then Nat.Coprime.mul_right · conf: high
- [x] `gcd_n2_2n5_eq_one` — The gcd of n+2 and 2n+5 is always one
      absence: no-local-match · triviality: non-trivial · intended: 2n+5 = 2*(n+2) + 1, so gcd reduces to gcd (n+2) 1 = 1 via gcd_add_mul / Nat.gcd_rec · conf: high
- [x] `gcd_3n1_9n4_eq_one` — The gcd of 3n+1 and 9n+4 is always one
      absence: no-local-match · triviality: non-trivial · intended: 9n+4 = 3*(3n+1) + 1, so gcd (3n+1) (9n+4) = gcd (3n+1) 1 = 1 · conf: high
- [x] `gcd_5n2_7n3_eq_one` — The gcd of 5n+2 and 7n+3 is always one
      absence: no-local-match · triviality: non-trivial · intended: 7*(5n+2) - 5*(7n+3) = -1; chase the Euclidean reduction so a common divisor divides 1 · conf: high
- [x] `gcd_4n3_6n5_eq_one` — The gcd of 4n+3 and 6n+5 is always one
      absence: no-local-match · triviality: non-trivial · intended: 3*(4n+3) - 2*(6n+5) = -1; a common divisor divides 1, so the gcd is 1 via subtraction steps · conf: high
- [x] `gcd_2n3_4n5_dvd_two` — The gcd of 2n+3 and 4n+5 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: 4n+5 = 2*(2n+3) - 1, so any common divisor divides 1, hence the gcd divides 2 (in fact equals 1) · conf: high
- [x] `gcd_n2_n4_dvd_two` — The gcd of n+2 and n+4 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: gcd (n+2) (n+4) divides their difference 2, via Nat.dvd_sub and gcd_dvd properties · conf: high
- [x] `gcd_n_add_six_dvd_six` — The gcd of n and n+6 always divides 6
      absence: no-local-match · triviality: non-trivial · intended: gcd n (n+6) divides the difference (n+6)-n = 6; use gcd_dvd_right minus gcd_dvd_left and Nat.dvd_sub · conf: high
- [x] `gcd_sq_n_sq_n_one` — n squared is coprime to n squared plus n plus one
      absence: no-local-match · triviality: non-trivial · intended: n^2 coprime to n+1 and to n^2+n+1 (each via add-multiple reduction); combine with Nat.Coprime.pow / mul · conf: high
- [x] `gcd_three_pow_succ_three_pow_add_one` — Three to the n+1 is coprime to three to the n plus one
      absence: no-local-match · triviality: non-trivial · intended: 3^(n+1) is a power of 3; show 3 is coprime to 3^n+1 (it is 1 mod 3), then Nat.Coprime.pow_left · conf: high
- [x] `gcd_two_pow_add_one_sub_one_dvd_two` — The gcd of 2^n+1 and 2^n-1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: Their difference is 2 (for n ≥ 1); a common divisor divides 2; handle n=0 separately, then gcd-divides-difference · conf: high
- [x] `gcd_n_factorial_succ_eq_one` — For positive n, n is coprime to n factorial plus one
      absence: no-local-match · triviality: non-trivial · intended: n divides n! (Nat.dvd_factorial), so gcd n (n!+1) = gcd n 1 = 1 via the add-multiple reduction · conf: high
- [ ] `coprime_le_factorial_succ` — Any k between 1 and n is coprime to n factorial plus one
      absence: no-local-match · triviality: non-trivial · intended: k divides n! (Nat.dvd_factorial h1 h2), so gcd k (n!+1) = gcd k 1 = 1; the key step is the dvd_factorial lemma · conf: med
- [x] `gcd_fib_add_two_eq_gcd_fib_succ` — gcd(F_n, F_{n+2}) equals gcd(F_n, F_{n+1})
      absence: no-local-match · triviality: non-trivial · intended: fib (n+2) = fib (n+1) + fib n; rewrite then use Nat.gcd_add_self_right / add-multiple gcd reduction · conf: high
- [ ] `fib_dvd_fib_two_mul` — F_n divides F_{2n}
      absence: no-local-match · triviality: non-trivial · intended: Apply Nat.fib_dvd with the witness n ∣ 2*n (Dvd.intro 2), discharging the divisibility hypothesis · conf: high
- [x] `bezout_five_seven_eq_one` — There exist integers x, y with 5x + 7y = 1
      absence: no-local-match · triviality: non-trivial · intended: Witness x = 3, y = -2 (5*3 + 7*(-2) = 1); supply via refine ⟨3, -2, ?_⟩ then ring/decide · conf: high
- [x] `bezout_eleven_thirteen_eq_one` — There exist integers x, y with 11x + 13y = 1
      absence: no-local-match · triviality: non-trivial · intended: Witness x = 6, y = -5 (11*6 + 13*(-5) = 1); refine ⟨6, -5, ?_⟩ then ring · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 23 candidates

- [x] `gcd_2n5_3n7_eq_one` — The linear forms 2n+5 and 3n+7 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g | 3*(2n+5)=6n+15 and g | 2*(3n+7)=6n+14; difference is 1, so g | 1 · conf: high
- [x] `gcd_3n2_4n3_eq_one` — The linear forms 3n+2 and 4n+3 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g | 4*(3n+2)=12n+8 and g | 3*(4n+3)=12n+9; difference is 1, so g | 1 · conf: high
- [x] `gcd_6n5_4n3_eq_one` — The linear forms 6n+5 and 4n+3 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g | 2*(6n+5)=12n+10 and g | 3*(4n+3)=12n+9; difference is 1, so g | 1 · conf: high
- [x] `gcd_n3_2n7_eq_one` — The linear forms n+3 and 2n+7 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g | 2*(n+3)=2n+6 and g | 2n+7; difference is 1, so g | 1 · conf: high
- [x] `gcd_3n4_5n7_eq_one` — The linear forms 3n+4 and 5n+7 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g | 5*(3n+4)=15n+20 and g | 3*(5n+7)=15n+21; difference is 1, so g | 1 · conf: high
- [x] `gcd_6n5_6n11_eq_one` — The values 6n+5 and 6n+11 are coprime for every natural number n
      absence: no-local-match · triviality: non-trivial · intended: g divides their difference 6; and 6n+5 is coprime to 6 (it is 5 mod 6), so g | gcd(6n+5,6)=1 · conf: high
- [x] `gcd_2n1_3n4_dvd_five` — The gcd of 2n+1 and 3n+4 always divides 5
      absence: no-local-match · triviality: non-trivial · intended: g | 3*(2n+1)=6n+3 and g | 2*(3n+4)=6n+8; difference is 5, so g | 5 · conf: high
- [ ] `gcd_2n1_nsq_n_one_dvd_three` — The gcd of 2n+1 and n^2+n+1 always divides 3
      absence: no-local-match · triviality: non-trivial · intended: 4*(n^2+n+1) = (2n+1)^2 + 3, so g | (2n+1)^2 and g | 4*(n^2+n+1) gives g | 3 (g is odd) · conf: med
- [x] `gcd_nsq1_n1_dvd_two` — The gcd of n^2+1 and n+1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: n^2+1 = (n+1)(n-1) + 2, so g | (n^2+1) and g | (n+1) forces g | 2 · conf: high
- [x] `gcd_nsq1_nsq3_dvd_two` — The gcd of n^2+1 and n^2+3 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: g divides the difference (n^2+3)-(n^2+1)=2, so g | 2 · conf: high
- [x] `gcd_n2_n8_dvd_six` — The gcd of n+2 and n+8 always divides 6
      absence: no-local-match · triviality: non-trivial · intended: g divides the difference (n+8)-(n+2)=6, so g | 6 via Nat.dvd_sub' on the gcd divisors · conf: high
- [x] `gcd_twon_n5_dvd_ten` — The gcd of 2n and n+5 always divides 10
      absence: no-local-match · triviality: non-trivial · intended: g | 2n and g | 2*(n+5)=2n+10; difference is 10, so g | 10 · conf: high
- [x] `gcd_threen_n7_dvd_twentyone` — The gcd of 3n and n+7 always divides 21
      absence: no-local-match · triviality: non-trivial · intended: g | 3n and g | 3*(n+7)=3n+21; difference is 21, so g | 21 · conf: high
- [ ] `gcd_n3_nsq5_dvd_fourteen` — The gcd of n+3 and n^2+5 always divides 14
      absence: no-local-match · triviality: non-trivial · intended: n^2+5 = (n+3)(n-3) + 14, so g | (n+3) and g | (n^2+5) forces g | 14 · conf: med
- [x] `gcd_quad_factored_n1_eq_n1` — Since n^2+3n+2 = (n+1)(n+2), its gcd with n+1 is exactly n+1
      absence: no-local-match · triviality: non-trivial · intended: Rewrite n^2+3n+2 = (n+1)*(n+2), then Nat.gcd_eq_right via (n+1) | (n+1)(n+2) · conf: high
- [ ] `gcd_factorial_succ_eq_factorial` — The gcd of n! and (n+1)! equals n!, since (n+1)! = (n+1)·n!
      absence: no-local-match · triviality: non-trivial · intended: Nat.factorial_succ gives (n+1)! = (n+1)*n!, so n! | (n+1)! and gcd is n! by Nat.gcd_eq_left · conf: high
- [x] `coprime_nsq2_nsq3` — The consecutive values n^2+2 and n^2+3 are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: They are consecutive (second = first + 1), so Nat.coprime_succ_self_right after rewriting · conf: high
- [x] `coprime_ncube1_ncube2` — The consecutive values n^3+1 and n^3+2 are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: Second = first + 1, so coprimality of consecutive integers (Nat.coprime_succ_self) applies · conf: high
- [ ] `coprime_n1_nsq1` — The gcd of n+1 and n^2+1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: n^2+1 = (n+1)(n-1) + 2; g | n+1 and g | n^2+1 forces g | 2 via Nat.dvd_sub' · conf: high
- [ ] `coprime_twopow_sub_one_two` — For every positive n, 2^n - 1 is odd and hence coprime to 2
      absence: no-local-match · triviality: non-trivial · intended: 2^n is even for n>0, so 2^n-1 is odd; reduce mod 2 (Nat.coprime_two_right_iff_odd or Odd.coprime) · conf: high
- [ ] `coprime_fib_sq_fib_succ` — The square of fib n is coprime to fib (n+1)
      absence: no-local-match · triviality: non-trivial · intended: fib n is coprime to fib (n+1) (Nat.fib_coprime_fib_succ); coprimality is preserved under powers via Nat.Coprime.pow_left · conf: high
- [ ] `coprime_fib_add_two_fib` — fib (n+2) is coprime to fib n
      absence: no-local-match · triviality: non-trivial · intended: fib(n+2)=fib(n+1)+fib(n); gcd(fib(n+2),fib n)=gcd(fib(n+1),fib n)=1 via Nat.gcd identities and fib_coprime_fib_succ · conf: med
- [ ] `gcd_4n1_6n1_dvd_two` — The gcd of 4n+1 and 6n+1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: g | 3*(4n+1)=12n+3 and g | 2*(6n+1)=12n+2; difference is 1, so actually g | 1 (divides 2 holds trivially) · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 21 candidates

- [ ] `gcd_np1_2np1_eq_one` — Consecutive-ratio terms n+1 and 2n+1 are always coprime
      absence: no-local-match · triviality: non-trivial · intended: Euclid step: 2*(n+1)-(2n+1)=1, so gcd divides 1; Nat.Coprime via dvd_sub or omega after gcd_rec · conf: high
- [ ] `gcd_2n3_3n5_eq_one` — The linear forms 2n+3 and 3n+5 (determinant 1) are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: Bezout: 3*(2n+3)-2*(3n+5)=-1; reduce gcd to gcd of a constant 1 · conf: high
- [ ] `gcd_3n1_5n2_eq_one` — The linear forms 3n+1 and 5n+2 (determinant 1) are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: Bezout combination 5*(3n+1)-3*(5n+2)=-1 forces gcd | 1 · conf: high
- [ ] `gcd_4n3_5n4_eq_one` — The linear forms 4n+3 and 5n+4 (determinant 1) are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: Bezout 5*(4n+3)-4*(5n+4)=-1 gives a unit combination, so gcd | 1 · conf: high
- [ ] `gcd_5n3_7n4_eq_one` — The linear forms 5n+3 and 7n+4 (determinant -1) are coprime for every n
      absence: no-local-match · triviality: non-trivial · intended: Bezout 7*(5n+3)-5*(7n+4)=1 yields a unit combination forcing gcd 1 · conf: high
- [ ] `gcd_3n2_5n4_dvd_two` — The gcd of 3n+2 and 5n+4 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: Bezout 5*(3n+2)-3*(5n+4)=-2, so any common divisor divides 2; gcd_dvd via dvd_sub · conf: high
- [ ] `gcd_2n1_2n7_dvd_six` — The gcd of 2n+1 and 2n+7 always divides 6
      absence: no-local-match · triviality: non-trivial · intended: Difference is 6; common divisor divides (2n+7)-(2n+1)=6, so gcd ∣ 6 · conf: high
- [ ] `gcd_np1_n2p1_dvd_two` — The gcd of n+1 and n^2+1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: n^2+1 = (n-1)(n+1) + 2, so gcd(n+1, n^2+1) ∣ 2 via the Euclidean remainder · conf: high
- [ ] `gcd_n2p1_n2p3_dvd_two` — The gcd of n^2+1 and n^2+3 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: Their difference is 2, so any common divisor divides 2; reduce via Nat.dvd_sub' · conf: high
- [ ] `coprime_n2p1_n2p2` — n^2+1 and n^2+2 are consecutive integers, hence coprime
      absence: no-local-match · triviality: non-trivial · intended: They are consecutive (differ by 1); apply Nat.coprime_succ_self after rewriting n^2+2 = (n^2+1)+1 · conf: high
- [ ] `consec_prod_succ_coprime` — Any number n(n+1) is coprime to its successor
      absence: no-local-match · triviality: non-trivial · intended: Direct instance of Nat.coprime_succ_self_right; the n*(n+1) shape blocks a one-line decide · conf: high
- [ ] `gcd_n3p1_np1_eq_np1` — Since n+1 divides n^3+1, the gcd of n^3+1 and n+1 is n+1
      absence: no-local-match · triviality: non-trivial · intended: Show (n+1) ∣ n^3+1 via the factorization n^3+1=(n+1)(n^2-n+1); then Nat.gcd_eq_right · conf: high
- [ ] `gcd_n4p1_n2p1_dvd_two` — The gcd of n^4+1 and n^2+1 always divides 2
      absence: no-local-match · triviality: non-trivial · intended: n^4+1 = (n^2+1)(n^2-1) + 2, so the Euclidean remainder is 2 and gcd ∣ 2 · conf: high
- [ ] `gcd_2pow_3pow_eq_one` — Powers of 2 and powers of 3 with the same exponent are coprime
      absence: no-local-match · triviality: non-trivial · intended: From Nat.Coprime 2 3 use Nat.Coprime.pow to get coprimality of the powers, then unfold gcd · conf: high
- [ ] `gcd_fib_2n_eq_fib_n` — Because fib n divides fib (2n), the gcd of fib(2n) and fib n is fib n
      absence: no-local-match · triviality: non-trivial · intended: Use Nat.fib_dvd (n ∣ 2n ⇒ fib n ∣ fib (2n)) then Nat.gcd_eq_right · conf: high
- [ ] `gcd_fib_n_fib_n3_dvd_two` — The gcd of fib n and fib (n+3) always divides 2
      absence: no-local-match · triviality: non-trivial · intended: gcd(fib n, fib(n+3)) = fib(gcd n (n+3)) = fib(gcd n 3) ∈ {fib 1, fib 3} = {1,2}; bound via Nat.fib_gcd · conf: med
- [ ] `coprime_4n1_4n3` — The forms 4n+1 and 4n+3 differ by 2 and, both being odd, are coprime
      absence: no-local-match · triviality: non-trivial · intended: Common divisor divides their difference 2 and divides the odd 4n+1, so it is 1 · conf: high
- [ ] `coprime_6n1_6n5` — The forms 6n+1 and 6n+5 differ by 4 yet remain coprime for all n
      absence: no-local-match · triviality: non-trivial · intended: A common divisor divides the difference 4 and the odd, non-multiple-of-2 6n+1, forcing gcd 1 · conf: high
- [ ] `gcd_2n1_2n5_dvd_four` — The gcd of 2n+1 and 2n+5 always divides 4
      absence: no-local-match · triviality: non-trivial · intended: Difference is 4, so any common divisor divides 4; conclude via Nat.dvd_sub' · conf: high
- [ ] `gcd_n2_n6_dvd_four` — The gcd of n+2 and n+6 always divides 4
      absence: no-local-match · triviality: non-trivial · intended: (n+6)-(n+2)=4, so common divisors divide 4; gcd_dvd_left/right plus Nat.dvd_sub' · conf: high
- [ ] `gcd_n1_n7_dvd_six` — The gcd of n+1 and n+7 always divides 6
      absence: no-local-match · triviality: non-trivial · intended: Their difference is 6, so the gcd divides 6 by dvd_sub on the two gcd divisibilities · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 19 candidates

- [ ] `gcd_nsq_add_two_nsq_add_five_dvd_three` — The gcd of n squared plus two and n squared plus five always divides three
      absence: no-local-match · triviality: non-trivial · intended: gcd divides the difference (n^2+5)-(n^2+2)=3 via Nat.dvd_sub' and Nat.dvd_gcd reasoning · conf: high
- [ ] `gcd_ncube_add_one_n_add_one_eq` — The gcd of n cubed plus one and n plus one equals n plus one
      absence: no-local-match · triviality: non-trivial · intended: show (n+1) ∣ (n^3+1) since n^3+1=(n+1)(n^2-n+1), then Nat.gcd_eq_right · conf: high
- [ ] `gcd_nsq_sub_one_n_sub_one_eq` — Over the naturals, the gcd of n squared minus one and n minus one equals n minus one
      absence: no-local-match · triviality: non-trivial · intended: (n-1) ∣ (n^2-1) via the factorisation (n-1)(n+1); handle Nat truncated subtraction then Nat.gcd_eq_right · conf: high
- [ ] `coprime_nsq_add_one_n` — n squared plus one is coprime to n
      absence: no-local-match · triviality: non-trivial · intended: n ∣ n^2 so gcd(n^2+1,n)=gcd(1,n)=1 via Nat.Coprime and add_mul_gcd-style simp · conf: high
- [ ] `coprime_fermat_numbers` — Distinct Fermat numbers are coprime
      absence: no-local-match · triviality: non-trivial · intended: WLOG m<n; show F_m ∣ F_n - 2 via telescoping product F_0..F_{n-1}=F_n-2, then any common divisor divides 2 but Fermat numbers are odd · conf: med
- [ ] `coprime_n_mul_add_one` — n is coprime to any multiple of n plus one
      absence: no-local-match · triviality: non-trivial · intended: gcd(n, n*k+1)=gcd(n,1)=1 using Nat.add_mul_mod-style / Nat.coprime_mul_right_add reasoning · conf: high
- [ ] `gcd_nsq_add_n_coprime_succ` — n squared plus n is coprime to its successor
      absence: no-local-match · triviality: non-trivial · intended: Nat.coprime_succ_self_right applied to the value n^2+n · conf: high
- [ ] `coprime_two_pow_n_three_pow_n` — Powers of two and powers of three with the same exponent are coprime
      absence: no-local-match · triviality: non-trivial · intended: Nat.Coprime.pow applied to the base coprimality Coprime 2 3 (decide) · conf: high
- [ ] `gcd_two_pow_add_one_sub_one_eq_one` — Two to the n plus one and two to the n minus one are coprime for positive n
      absence: no-local-match · triviality: non-trivial · intended: their difference is 2, common divisor divides 2, but both are odd so the gcd is 1 · conf: high
- [ ] `gcd_six_n_four_six_n_nine_dvd_five` — The gcd of six n plus four and six n plus nine always divides five
      absence: no-local-match · triviality: non-trivial · intended: gcd divides the difference (6n+9)-(6n+4)=5 via Nat.dvd_sub' and gcd_dvd · conf: high
- [ ] `coprime_n_ncube_add_one` — n is coprime to n cubed plus one
      absence: no-local-match · triviality: non-trivial · intended: n ∣ n^3 so gcd(n, n^3+1)=gcd(n,1)=1 via Nat.coprime_mul_right_add / add reasoning · conf: high
- [ ] `gcd_nfourth_sub_one_nsq_sub_one_eq` — The gcd of n to the fourth minus one and n squared minus one equals n squared minus one
      absence: no-local-match · triviality: non-trivial · intended: (n^2-1) ∣ (n^4-1) since n^4-1=(n^2-1)(n^2+1); handle Nat subtraction then Nat.gcd_eq_right · conf: high
- [ ] `coprime_nsq_add_n_add_one_nsq_sub_n_add_one` — The two cyclotomic-like quadratics n squared plus n plus one and n squared minus n plus one are coprime
      absence: no-local-match · triviality: non-trivial · intended: their difference is 2n, a common divisor divides 2n and the odd value n^2+n+1; combine to force the gcd to 1 · conf: med
- [ ] `coprime_factorial_add_one_n` — One more than n factorial is coprime to n
      absence: no-local-match · triviality: non-trivial · intended: n ∣ n! so gcd(n!+1,n)=gcd(1,n)=1 via Nat.dvd_factorial and coprime-of-add reasoning · conf: high
- [ ] `gcd_two_n_two_n_add_two_eq_two` — The gcd of two consecutive even numbers two n and two n plus two equals two
      absence: no-local-match · triviality: non-trivial · intended: factor out 2 via Nat.gcd_mul_left then gcd(n,n+1)=1 (Nat.coprime_succ_self) · conf: high
- [ ] `gcd_nsq_add_three_n_add_two_n_add_one_eq` — The gcd of n squared plus three n plus two and n plus one equals n plus one
      absence: no-local-match · triviality: non-trivial · intended: (n+1) ∣ (n^2+3n+2) since it factors as (n+1)(n+2), then Nat.gcd_eq_right · conf: high
- [ ] `gcd_mersenne_eq_pow_gcd_sub_one` — The gcd of two Mersenne-type numbers equals two raised to the gcd of the exponents, minus one
      absence: no-local-match · triviality: non-trivial · intended: Euclidean induction on the exponents using 2^m-1 ≡ 2^(m mod n)-1 modulo 2^n-1, mirroring the gcd recursion · conf: med
- [ ] `bezout_nsq_nsqp1_int` — There is an integer Bezout combination of n squared and n squared plus one giving one
      absence: no-local-match · triviality: non-trivial · intended: witness x=-1, y=1 then ring closes -n^2+(n^2+1)=1 · conf: high
- [ ] `bezout_fib_consec_int` — Consecutive Fibonacci numbers admit an integer Bezout combination equal to one
      absence: no-local-match · triviality: non-trivial · intended: use Cassini-style identity fib(n)*fib(n+1)... or derive from Nat.fib_coprime_fib_succ via Nat.Coprime.gcd_eq_one and Int.gcd Bezout · conf: med
