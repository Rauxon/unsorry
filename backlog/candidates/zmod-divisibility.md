# Divisibility via ZMod-decide — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 22 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `dvd_504_pow_nine_sub_pow_three` — 504 divides n^9 minus n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: have ∀ x : ZMod 504, x^9 - x^3 = 0 by decide; transfer via ZMod.intCast_zmod_eq_zero_iff_dvd (build-verified) · conf: high
- [x] `dvd_510_pow_seventeen_sub_self` — 510 divides n^17 minus n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 510, x^17 - x = 0 by decide; ZMod.intCast_zmod_eq_zero_iff_dvd. 510 = 2·3·5·17 · conf: high
- [x] `dvd_798_pow_nineteen_sub_self` — 798 divides n^19 minus n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 798, x^19 - x = 0 by decide; transfer lemma. 798 = 2·3·7·19 · conf: high
- [x] `dvd_330_pow_twentyone_sub_self` — 330 divides n^21 minus n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 330, x^21 - x = 0 by decide; transfer lemma. 330 = 2·3·5·11 · conf: high
- [x] `dvd_120_pow_eleven_sub_pow_three` — 120 divides n^11 minus n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 120, x^11 - x^3 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_480_pow_thirteen_sub_pow_five` — 480 divides n^13 minus n^5 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 480, x^13 - x^5 = 0 by decide; transfer lemma. 480 = 2^5·3·5 · conf: high
- [x] `dvd_120_pow_seven_sub_pow_three` — 120 divides n^7 minus n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 120, x^7 - x^3 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_240_pow_nine_sub_pow_five` — 240 divides n^9 minus n^5 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 240, x^9 - x^5 = 0 by decide; transfer lemma. 240 = 2^4·3·5 · conf: high
- [x] `dvd_252_pow_eight_sub_sq` — 252 divides n^8 minus n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 252, x^8 - x^2 = 0 by decide; transfer lemma. 252 = 2^2·3^2·7 · conf: high
- [x] `dvd_240_pow_eight_sub_pow_four` — 240 divides n^8 minus n^4 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 240, x^8 - x^4 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_sixty_pow_six_sub_sq` — 60 divides n^6 minus n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 60, x^6 - x^2 = 0 by decide; transfer lemma. 60 = 2^2·3·5 · conf: high
- [x] `dvd_sixty_pow_ten_sub_sq` — 60 divides n^10 minus n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 60, x^10 - x^2 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_twentyfour_pow_seven_sub_pow_five` — 24 divides n^7 minus n^5 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 24, x^7 - x^5 = 0 by decide; transfer lemma (small modulus, fast decide) · conf: high
- [x] `dvd_twentyfour_pow_six_sub_pow_four` — 24 divides n^6 minus n^4 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 24, x^6 - x^4 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_twentyfour_pow_five_sub_pow_three` — 24 divides n^5 minus n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 24, x^5 - x^3 = 0 by decide; transfer lemma · conf: high
- [x] `dvd_5040_seven_consecutive_product` — 5040 (=7!) divides n·(n^2-1)·(n^2-4)·(n^2-9), the product of seven consecutive integers centred at n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 5040, x*(x^2-1)*(x^2-4)*(x^2-9)=0 by decide (needs set_option maxRecDepth 100000, build-verified); transfer lemma · conf: med
- [ ] `dvd_120_five_consecutive_product` — 120 (=5!) divides n·(n^2-1)·(n^2-4), the product of five consecutive integers centred at n
      absence: no-local-match · triviality: non-trivial · intended: ∀ x : ZMod 120, x*(x^2-1)*(x^2-4)=0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `prime_pow_six_mod_504` — For every prime p greater than 7, p^6 is congruent to 1 modulo 504
      absence: no-local-match · triviality: non-trivial · intended: Reduce mod 504=8·9·7 via CRT/ZMod units; for p coprime to 504, p is a unit whose order divides 6 in each factor (decide over coprime residues of ZMod 504) · conf: med
- [x] `prime_pow_eight_mod_480` — For every prime p greater than 5, p^8 is congruent to 1 modulo 480
      absence: no-local-match · triviality: non-trivial · intended: 480 = 32·3·5; for p coprime to 480 the residue's 8th power is 1 in each unit group; decide over coprime residues / ZMod CRT · conf: med
- [x] `dvd_thirtytwo_odd_pow_eight_sub_one` — For every odd integer n, 32 divides n^8 minus 1
      absence: no-local-match · triviality: non-trivial · intended: obtain ⟨k,rfl⟩ from Odd; ∀ x : ZMod 32, (2*x+1)^8 - 1 = 0 by decide; transfer lemma (build-verified) · conf: high
- [x] `dvd_sixteen_odd_pow_four_sub_one` — For every odd integer n, 16 divides n^4 minus 1
      absence: no-local-match · triviality: non-trivial · intended: obtain ⟨k,rfl⟩ from Odd; ∀ x : ZMod 16, (2*x+1)^4 - 1 = 0 by decide; transfer via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_fortyeight_coprime_six_pow_four_sub_one` — For every integer n divisible by neither 2 nor 3, 48 divides n^4 minus 1
      absence: no-local-match · triviality: non-trivial · intended: n coprime to 6 means its ZMod 48 residue is a unit; ∀ x : ZMod 48 that is a unit, x^4 = 1 (decide over the unit residues), then transfer; coprimality hyps select the unit residues · conf: med

### Replenishment round 2 (scoped 2026-06-15) — 20 candidates

- [ ] `dvd_1365_pow_thirteen_sub_self` — The integer 1365 = 3·5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Reduce to ZMod 1365 via ZMod.intCast_zmod_eq_zero_iff_dvd, push_cast, then `decide` on the finite residue identity (set_option maxRecDepth ~20000) · conf: high
- [ ] `dvd_910_pow_thirteen_sub_self` — The integer 910 = 2·5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Bridge ℤ-divisibility to `∀ x : ZMod 910, x^13 - x = 0` by `decide`, lifted with push_cast and intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_455_pow_thirteen_sub_self` — The integer 455 = 5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 455 decide bridge; each prime factor's (p-1) divides 12 so the residue identity holds and is decidable · conf: high
- [ ] `dvd_273_pow_thirteen_sub_self` — The integer 273 = 3·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 273, prove `x^13 = x` for all residues by `decide`, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_1302_pow_thirtyone_sub_self` — The integer 1302 = 2·3·7·31 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 1302 decide bridge with set_option maxRecDepth ~200000; exponent 31 makes kernel reduction heavier but still terminates (~26s) · conf: high
- [ ] `dvd_1023_pow_thirtyone_sub_self` — The integer 1023 = 3·11·31 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Bridge to `∀ x : ZMod 1023, x^31 - x = 0` by `decide` (high maxRecDepth), then lift via push_cast and intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_462_pow_thirtyone_sub_self` — The integer 462 = 2·3·7·11 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 462 decide bridge; λ(462)=30 divides 30 so n^31≡n, decidable over the finite ring · conf: high
- [ ] `dvd_399_pow_nineteen_sub_self` — The integer 399 = 3·7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 399, `decide` the residue identity x^19 = x, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_266_pow_nineteen_sub_self` — The integer 266 = 2·7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 266 decide bridge with push_cast; (p-1) for 2,7,19 all divide 18 so n^19≡n · conf: high
- [ ] `dvd_133_pow_nineteen_sub_self` — The integer 133 = 7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Reduce to `∀ x : ZMod 133, x^19 - x = 0` by `decide`, lift with intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_1365_pow_fifteen_sub_pow_three` — The integer 1365 = 3·5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 1365 and `decide` that x^15 = x^3 for all residues (set_option maxRecDepth ~100000, ~26s); lift via intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_910_pow_fifteen_sub_pow_three` — The integer 910 = 2·5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 910 decide bridge on x^15 - x^3 = 0; the common factor n^3 plus λ(910)=12 dividing 12 gives the identity · conf: high
- [ ] `dvd_455_pow_fifteen_sub_pow_three` — The integer 455 = 5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 455, `decide` x^15 = x^3 over residues, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_210_pow_fifteen_sub_pow_three` — The integer 210 = 2·3·5·7 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 210 decide bridge; λ(210)=12 divides 12 so n^15≡n^3, decidable over the 210 residues · conf: high
- [ ] `dvd_840_pow_fifteen_sub_pow_three` — The integer 840 = 2^3·3·5·7 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 840 and `decide` x^15 - x^3 = 0; the 2^3 factor needs the n^3 head so plain n^a-n fails, making this a genuine n^a-n^b fact · conf: high
- [ ] `dvd_264_pow_thirteen_sub_pow_three` — The integer 264 = 2^3·3·11 divides n^13 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 264 decide bridge on x^13 - x^3 = 0; 2^3 forces the n^3 factor, λ(odd part)=10 divides 10 for the n^10 lift · conf: high
- [ ] `dvd_360_pow_fifteen_sub_pow_three` — The integer 360 = 2^3·3^2·5 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 360 and `decide` x^15 = x^3; the 2^3 and 3^2 prime-power factors require the n^3 head, not a bare n^a-n form · conf: high
- [ ] `dvd_546_pow_fourteen_sub_sq` — The integer 546 = 2·3·7·13 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 546 decide bridge on x^14 - x^2 = 0; λ(546)=12 divides 12 so n^14≡n^2 after the n^2 head · conf: high
- [ ] `dvd_273_pow_fourteen_sub_sq` — The integer 273 = 3·7·13 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 273, `decide` x^14 = x^2 over residues, lift via intCast_zmod_eq_zero_iff_dvd · conf: high
- [ ] `dvd_630_pow_fourteen_sub_sq` — The integer 630 = 2·3^2·5·7 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 630 decide bridge on x^14 - x^2 = 0; the 3^2 factor needs the n^2 head, distinguishing it from a squarefree n^a-n fact · conf: high
