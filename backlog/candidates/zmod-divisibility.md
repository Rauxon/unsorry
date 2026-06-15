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

- [x] `dvd_1365_pow_thirteen_sub_self` — The integer 1365 = 3·5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Reduce to ZMod 1365 via ZMod.intCast_zmod_eq_zero_iff_dvd, push_cast, then `decide` on the finite residue identity (set_option maxRecDepth ~20000) · conf: high
- [x] `dvd_910_pow_thirteen_sub_self` — The integer 910 = 2·5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Bridge ℤ-divisibility to `∀ x : ZMod 910, x^13 - x = 0` by `decide`, lifted with push_cast and intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_455_pow_thirteen_sub_self` — The integer 455 = 5·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 455 decide bridge; each prime factor's (p-1) divides 12 so the residue identity holds and is decidable · conf: high
- [x] `dvd_273_pow_thirteen_sub_self` — The integer 273 = 3·7·13 divides n^13 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 273, prove `x^13 = x` for all residues by `decide`, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_1302_pow_thirtyone_sub_self` — The integer 1302 = 2·3·7·31 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 1302 decide bridge with set_option maxRecDepth ~200000; exponent 31 makes kernel reduction heavier but still terminates (~26s) · conf: high
- [x] `dvd_1023_pow_thirtyone_sub_self` — The integer 1023 = 3·11·31 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Bridge to `∀ x : ZMod 1023, x^31 - x = 0` by `decide` (high maxRecDepth), then lift via push_cast and intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_462_pow_thirtyone_sub_self` — The integer 462 = 2·3·7·11 divides n^31 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 462 decide bridge; λ(462)=30 divides 30 so n^31≡n, decidable over the finite ring · conf: high
- [x] `dvd_399_pow_nineteen_sub_self` — The integer 399 = 3·7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 399, `decide` the residue identity x^19 = x, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_266_pow_nineteen_sub_self` — The integer 266 = 2·7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 266 decide bridge with push_cast; (p-1) for 2,7,19 all divide 18 so n^19≡n · conf: high
- [x] `dvd_133_pow_nineteen_sub_self` — The integer 133 = 7·19 divides n^19 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Reduce to `∀ x : ZMod 133, x^19 - x = 0` by `decide`, lift with intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_1365_pow_fifteen_sub_pow_three` — The integer 1365 = 3·5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 1365 and `decide` that x^15 = x^3 for all residues (set_option maxRecDepth ~100000, ~26s); lift via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_910_pow_fifteen_sub_pow_three` — The integer 910 = 2·5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 910 decide bridge on x^15 - x^3 = 0; the common factor n^3 plus λ(910)=12 dividing 12 gives the identity · conf: high
- [x] `dvd_455_pow_fifteen_sub_pow_three` — The integer 455 = 5·7·13 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 455, `decide` x^15 = x^3 over residues, then intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_210_pow_fifteen_sub_pow_three` — The integer 210 = 2·3·5·7 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 210 decide bridge; λ(210)=12 divides 12 so n^15≡n^3, decidable over the 210 residues · conf: high
- [x] `dvd_840_pow_fifteen_sub_pow_three` — The integer 840 = 2^3·3·5·7 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 840 and `decide` x^15 - x^3 = 0; the 2^3 factor needs the n^3 head so plain n^a-n fails, making this a genuine n^a-n^b fact · conf: high
- [x] `dvd_264_pow_thirteen_sub_pow_three` — The integer 264 = 2^3·3·11 divides n^13 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 264 decide bridge on x^13 - x^3 = 0; 2^3 forces the n^3 factor, λ(odd part)=10 divides 10 for the n^10 lift · conf: high
- [x] `dvd_360_pow_fifteen_sub_pow_three` — The integer 360 = 2^3·3^2·5 divides n^15 - n^3 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 360 and `decide` x^15 = x^3; the 2^3 and 3^2 prime-power factors require the n^3 head, not a bare n^a-n form · conf: high
- [x] `dvd_546_pow_fourteen_sub_sq` — The integer 546 = 2·3·7·13 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 546 decide bridge on x^14 - x^2 = 0; λ(546)=12 divides 12 so n^14≡n^2 after the n^2 head · conf: high
- [x] `dvd_273_pow_fourteen_sub_sq` — The integer 273 = 3·7·13 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Cast to ZMod 273, `decide` x^14 = x^2 over residues, lift via intCast_zmod_eq_zero_iff_dvd · conf: high
- [x] `dvd_630_pow_fourteen_sub_sq` — The integer 630 = 2·3^2·5·7 divides n^14 - n^2 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: ZMod 630 decide bridge on x^14 - x^2 = 0; the 3^2 factor needs the n^2 head, distinguishing it from a squarefree n^a-n fact · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 20 candidates

- [x] `dvd_1806_pow_fortythree_sub_self` — For every integer n, 1806 divides n raised to the 43rd power minus n
      absence: no-local-match · triviality: non-trivial · intended: 1806 = 2·3·7·43; reduce mod each prime via ZMod and decide, combine with Nat.Coprime.mul_dvd · conf: high
- [ ] `dvd_14322_pow_thirtyone_sub_self` — For every integer n, 14322 divides n raised to the 31st power minus n
      absence: no-local-match · triviality: non-trivial · intended: 14322 = 2·3·7·11·31; per-prime ZMod.decide with set_option maxRecDepth, glue via coprime product · conf: med
- [ ] `dvd_13530_pow_fortyone_sub_self` — For every integer n, 13530 divides n raised to the 41st power minus n
      absence: no-local-match · triviality: non-trivial · intended: 13530 = 2·3·5·11·41; reduce to ZMod p for each prime factor and decide, recombine by coprimality · conf: med
- [ ] `dvd_46410_pow_fortynine_sub_self` — For every integer n, 46410 divides n raised to the 49th power minus n
      absence: no-local-match · triviality: non-trivial · intended: 46410 = 2·3·5·7·13·17; per-prime ZMod decide (maxRecDepth), assemble via coprime product dvd · conf: med
- [ ] `dvd_56786730_pow_sixtyone_sub_self` — For every integer n, 56786730 divides n raised to the 61st power minus n
      absence: no-local-match · triviality: non-trivial · intended: 56786730 = 2·3·5·7·11·13·31·61 (the largest such modulus); decide n^61=n in each ZMod p with high maxRecDepth, combine by coprimality · conf: med
- [x] `dvd_903_pow_fortythree_sub_self` — For every integer n, 903 divides n raised to the 43rd power minus n
      absence: no-local-match · triviality: non-trivial · intended: 903 = 3·7·43; reduce mod each prime via ZMod.decide and combine with coprime product divisibility · conf: high
- [x] `dvd_6765_pow_fortyone_sub_self` — For every integer n, 6765 divides n raised to the 41st power minus n
      absence: no-local-match · triviality: non-trivial · intended: 6765 = 3·5·11·41; per-prime ZMod decide of n^41=n, glue via Nat.Coprime.mul_dvd · conf: high
- [x] `dvd_170_pow_seventeen_sub_self` — For every integer n, 170 divides n raised to the 17th power minus n
      absence: no-local-match · triviality: non-trivial · intended: 170 = 2·5·17; reduce to ZMod 2, ZMod 5, ZMod 17 and decide, then combine by coprimality · conf: high
- [x] `dvd_255_pow_seventeen_sub_self` — For every integer n, 255 divides n raised to the 17th power minus n
      absence: no-local-match · triviality: non-trivial · intended: 255 = 3·5·17; per-prime ZMod.decide of n^17=n, recombine via coprime product divisibility · conf: high
- [ ] `dvd_2730_pow_twentyfive_sub_pow_thirteen` — For every integer n, 2730 divides n to the 25th power minus n to the 13th power
      absence: no-local-match · triviality: non-trivial · intended: 2730 = 2·3·5·7·13; factor n^13(n^12-1) and decide n^25=n^13 in each ZMod p, combine by coprimality · conf: med
- [ ] `dvd_2730_pow_nineteen_sub_pow_seven` — For every integer n, 2730 divides n to the 19th power minus n to the 7th power
      absence: no-local-match · triviality: non-trivial · intended: 2730 = 2·3·5·7·13; per-prime ZMod.decide of n^19=n^7, recombine via coprime product dvd · conf: med
- [x] `dvd_510_pow_thirtythree_sub_pow_seventeen` — For every integer n, 510 divides n to the 33rd power minus n to the 17th power
      absence: no-local-match · triviality: non-trivial · intended: 510 = 2·3·5·17; decide n^33=n^17 in each ZMod p and glue with Nat.Coprime.mul_dvd · conf: high
- [x] `dvd_510_pow_twentyone_sub_pow_five` — For every integer n, 510 divides n to the 21st power minus n to the 5th power
      absence: no-local-match · triviality: non-trivial · intended: 510 = 2·3·5·17; per-prime ZMod.decide of n^21=n^5, combine by coprimality · conf: high
- [ ] `dvd_798_pow_fiftyseven_sub_pow_three` — For every integer n, 798 divides n to the 57th power minus n to the 3rd power
      absence: no-local-match · triviality: non-trivial · intended: 798 = 2·3·7·19; decide n^57=n^3 in each ZMod p (maxRecDepth for exponent 57), recombine via coprime dvd · conf: med
- [x] `dvd_66_pow_twentyone_sub_pow_eleven` — For every integer n, 66 divides n to the 21st power minus n to the 11th power
      absence: no-local-match · triviality: non-trivial · intended: 66 = 2·3·11; decide n^21=n^11 in ZMod 2, ZMod 3, ZMod 11, combine by coprimality · conf: high
- [ ] `dvd_330_pow_twentythree_sub_pow_three` — For every integer n, 330 divides n to the 23rd power minus n to the 3rd power
      absence: no-local-match · triviality: non-trivial · intended: 330 = 2·3·5·11; per-prime ZMod.decide of n^23=n^3, recombine via Nat.Coprime.mul_dvd · conf: high
- [ ] `dvd_1806_pow_fortynine_sub_pow_seven` — For every integer n, 1806 divides n to the 49th power minus n to the 7th power
      absence: no-local-match · triviality: non-trivial · intended: 1806 = 2·3·7·43; decide n^49=n^7 in each ZMod p (maxRecDepth), combine by coprimality · conf: med
- [ ] `dvd_910_pow_twentyfive_sub_pow_thirteen` — For every integer n, 910 divides n to the 25th power minus n to the 13th power
      absence: no-local-match · triviality: non-trivial · intended: 910 = 2·5·7·13; per-prime ZMod.decide of n^25=n^13, recombine via coprime product dvd · conf: high
- [ ] `dvd_2730_pow_thirtyseven_sub_pow_thirteen` — For every integer n, 2730 divides n to the 37th power minus n to the 13th power
      absence: no-local-match · triviality: non-trivial · intended: 2730 = 2·3·5·7·13; decide n^37=n^13 in each ZMod p with high maxRecDepth, combine by coprimality · conf: med
- [ ] `dvd_510_pow_nineteen_sub_pow_three` — For every integer n, 510 divides n to the 19th power minus n to the 3rd power
      absence: no-local-match · triviality: non-trivial · intended: 510 = 2·3·5·17; per-prime ZMod.decide of n^19=n^3, recombine via Nat.Coprime.mul_dvd · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 23 candidates

- [ ] `dvd_138_pow_twentythree_sub_self` — 138 divides n^23 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Factor 138 = 2*3*23; reduce mod each prime via ZMod and decide, then combine by coprimality (Int.ModEq / Nat.Coprime.mul_dvd) · conf: high
- [ ] `dvd_870_pow_twentynine_sub_self` — 870 divides n^29 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 870 = 2*3*5*29; for each prime p, (p-1)|28 so n^29≡n mod p by ZMod decide; combine via coprime product divisibility · conf: high
- [ ] `dvd_282_pow_fortyseven_sub_self` — 282 divides n^47 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 282 = 2*3*47; each prime divides n^47-n by Fermat (set maxRecDepth for ZMod 47 decide); CRT-combine the three coprime factors · conf: high
- [ ] `dvd_498_pow_eightythree_sub_self` — 498 divides n^83 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 498 = 2*3*83; reduce mod 2,3,83 via ZMod decide (maxRecDepth for modulus 83) and assemble with coprime multiplicativity of dvd · conf: med
- [ ] `dvd_642_pow_hundredseven_sub_self` — 642 divides n^107 - n for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 642 = 2*3*107; each prime p has (p-1)|106 so n^107≡n by ZMod decide (large maxRecDepth for 107); combine by coprimality · conf: med
- [ ] `dvd_138_pow_fortyfive_sub_pow_twentythree` — 138 divides n^45 - n^23 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: Write n^45-n^23 = n^23(n^22-1); for each prime p|138 reduce mod p with ZMod decide (covering both n coprime and divisible cases), then coprime-combine · conf: high
- [ ] `dvd_870_pow_fiftyseven_sub_pow_twentynine` — 870 divides n^57 - n^29 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 870 = 2*3*5*29; per prime decide n^57≡n^29 over ZMod p (the 28-step exponent gap is a multiple of each p-1), then CRT-combine · conf: med
- [ ] `dvd_510_pow_fortynine_sub_pow_seventeen` — 510 divides n^49 - n^17 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 510 = 2*3*5*17; the exponent gap 32 is divisible by each (p-1) so n^49≡n^17 mod p by ZMod decide; combine coprime factors · conf: high
- [ ] `dvd_798_pow_thirtyseven_sub_pow_nineteen` — 798 divides n^37 - n^19 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 798 = 2*3*7*19; gap 18 is a multiple of each p-1, so decide n^37≡n^19 over each ZMod p and combine by coprimality · conf: high
- [ ] `dvd_66_pow_thirtyone_sub_pow_eleven` — 66 divides n^31 - n^11 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 66 = 2*3*11; n^31-n^11 = n^11(n^20-1), gap 20 divisible by each p-1; ZMod decide per prime then coprime-combine · conf: high
- [ ] `dvd_42_pow_twentyfive_sub_pow_seven` — 42 divides n^25 - n^7 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 42 = 2*3*7; gap 18 is a multiple of each p-1, decide n^25≡n^7 over ZMod 2,3,7 and combine via coprime dvd product · conf: high
- [ ] `dvd_30_pow_twentyone_sub_pow_five` — 30 divides n^21 - n^5 for every integer n
      absence: no-local-match · triviality: non-trivial · intended: 30 = 2*3*5; n^21-n^5 = n^5(n^16-1), gap 16 divisible by each p-1; ZMod decide mod 2,3,5 and coprime-combine · conf: high
- [ ] `dvd_sixtyfour_odd_pow_sixteen_sub_one` — For every odd integer n, 64 divides n^16 - 1
      absence: no-local-match · triviality: non-trivial · intended: Reduce n to its residue mod 64 using the odd hypothesis and decide over the odd classes of ZMod 64 (the multiplicative order of any odd unit divides 16) · conf: high
- [ ] `dvd_onehundredtwentyeight_odd_pow_thirtytwo_sub_one` — For every odd integer n, 128 divides n^32 - 1
      absence: no-local-match · triviality: non-trivial · intended: Cast through ZMod 128 using oddness and decide that every odd unit raised to the 32nd power is 1 (maxRecDepth bumped for the size-128 finite check) · conf: med
- [ ] `dvd_72_coprime_pow_six_sub_one` — If n is divisible by neither 2 nor 3 then 72 divides n^6 - 1
      absence: no-local-match · triviality: non-trivial · intended: 72 = 8*9; from the coprimality hypotheses decide n^6≡1 over the units of ZMod 8 and ZMod 9 (Carmichael lambda(72)=6), then combine the coprime prime-power factors · conf: high
- [ ] `dvd_100_coprime_pow_twenty_sub_one` — If n is divisible by neither 2 nor 5 then 100 divides n^20 - 1
      absence: no-local-match · triviality: non-trivial · intended: 100 = 4*25; under coprimality decide n^20≡1 over the units of ZMod 4 and ZMod 25 (lambda(100)=20) and combine by coprime divisibility · conf: high
- [ ] `dvd_96_coprime_pow_eight_sub_one` — If n is divisible by neither 2 nor 3 then 96 divides n^8 - 1
      absence: no-local-match · triviality: non-trivial · intended: 96 = 32*3; coprimality lets us decide n^8≡1 over the units of ZMod 32 and ZMod 3 (lambda(96)=8), then coprime-combine · conf: high
- [ ] `dvd_126_coprime_pow_six_sub_one` — If n is divisible by none of 2, 3, 7 then 126 divides n^6 - 1
      absence: no-local-match · triviality: non-trivial · intended: 126 = 2*9*7; from the three coprimality hypotheses decide n^6≡1 over units of ZMod 2, ZMod 9, ZMod 7 (lambda(126)=6) and combine · conf: high
- [ ] `prime_pow_four_mod_240_eq_one` — Every prime p greater than 5 satisfies p^4 ≡ 1 (mod 240)
      absence: no-local-match · triviality: non-trivial · intended: 240 = 16*3*5; show p is coprime to 240 from primality and p>5, cast to ZMod 240 and decide p^4=1 on the units (lambda(240)=4) · conf: med
- [ ] `prime_pow_twelve_mod_720_eq_one` — Every prime p greater than 5 satisfies p^12 ≡ 1 (mod 720)
      absence: no-local-match · triviality: non-trivial · intended: 720 = 16*9*5; from primality/p>5 get coprimality, then ZMod 720 decide p^12=1 over units (lambda(720)=12), with maxRecDepth raised · conf: med
- [ ] `dvd_40320_eight_consecutive_product` — 8! = 40320 divides the product of any eight consecutive integers
      absence: no-local-match · triviality: non-trivial · intended: Recognise the product as 8! times a binomial coefficient; use Nat.factorial_dvd_descFactorial / Int.factorial_dvd_prod-style lemma after shifting to a nonneg base, or induct on n · conf: med
- [ ] `dvd_362880_nine_consecutive_product` — 9! = 362880 divides the product of any nine consecutive integers
      absence: no-local-match · triviality: non-trivial · intended: Nine consecutive integers equal 9! * C(n+8,9); apply the factorial-divides-descending-factorial lemma (casework on the sign of n) or strong induction · conf: med
- [ ] `sum_two_squares_zmod_nine_ne_three` — No sum of two squares is congruent to 3 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: Finite ZMod 9: decide over all 81 pairs (x,y) that x^2+y^2 never equals 3 (the quadratic-residue set mod 9 is {0,1,4,7}) · conf: high
