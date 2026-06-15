# Power-residue / modular range facts — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 24 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sq_mod_eight_mem` — Every natural number's square leaves remainder 0, 1, or 4 when divided by 8
      absence: no-local-match · triviality: non-trivial · intended: omega-on (n % 8) after Nat.pow_mod, then decide over the 8 residues · conf: high
- [x] `sq_mod_sixteen_mem` — Every natural number's square is congruent to 0, 1, 4, or 9 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: rewrite n^2%16 via Nat.pow_mod, case-split on n%16 with decide/omega · conf: high
- [x] `sq_mod_eleven_mem` — The quadratic residues modulo 11 are exactly {0,1,3,4,5,9}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..10 · conf: high
- [x] `sq_mod_thirteen_mem` — The quadratic residues modulo 13 are exactly {0,1,3,4,9,10,12}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%13, decide each branch · conf: high
- [x] `sq_mod_twelve_mem` — Every natural number's square is congruent to 0, 1, 4, or 9 modulo 12
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over the 12 residue classes · conf: high
- [x] `sq_mod_twentyfour_mem` — The squares modulo 24 fall in exactly {0,1,4,9,12,16}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%24, decide each of 24 branches · conf: high
- [x] `cube_mod_eighteen_mem` — The cubes modulo 18 are exactly {0,1,8,9,10,17}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..17 · conf: high
- [x] `cube_mod_nineteen_mem` — The cubic residues modulo 19 are exactly {0,1,7,8,11,12,18}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%19, decide each branch · conf: high
- [x] `fourth_power_mod_seventeen_mem` — The fourth-power residues modulo 17 are exactly {0,1,4,13,16}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..16 · conf: high
- [ ] `fourth_power_mod_twentynine_mem` — The fourth-power residues modulo 29 are exactly {0,1,7,16,20,23,24,25}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%29, decide each of 29 branches · conf: med
- [x] `fourth_power_mod_sixteen_mem` — Every natural number's fourth power is congruent to 0 or 1 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..15 (unconditional, unlike the Odd-only version) · conf: high
- [x] `fifth_power_mod_twentyfive_mem` — The fifth-power residues modulo 25 are exactly {0,1,7,18,24}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%25, decide each branch · conf: high
- [ ] `fifth_power_mod_thirtyone_mem` — The fifth-power residues modulo 31 are exactly {0,1,5,6,25,26,30}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%31, decide each of 31 branches · conf: med
- [x] `sixth_power_mod_thirteen_mem` — Every natural number's sixth power is congruent to 0, 1, or 12 modulo 13
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..12 · conf: high
- [x] `sixth_power_mod_nine_mem` — Every natural number's sixth power is congruent to 0 or 1 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..8 · conf: high
- [ ] `seventh_power_mod_twentynine_mem` — The seventh-power residues modulo 29 are exactly {0,1,12,17,28}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%29, decide each of 29 branches · conf: med
- [x] `eighth_power_mod_seventeen_mem` — Every natural number's eighth power is congruent to 0, 1, or 16 modulo 17
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..16 · conf: high
- [x] `sum_two_squares_zmod_four_ne_three` — A sum of two integer squares is never congruent to 3 modulo 4
      absence: no-local-match · triviality: non-trivial · intended: push casts to ZMod 4, then decide over the finite ZMod 4 × ZMod 4 cases · conf: high
- [x] `sum_two_fourth_powers_zmod_sixteen_mem` — A sum of two integer fourth powers is congruent to 0, 1, or 2 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 16, decide over ZMod 16 × ZMod 16 since each fourth power is 0 or 1 · conf: high
- [x] `sum_three_squares_zmod_sixteen_ne_fifteen` — A sum of three integer squares is never congruent to 15 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 16, decide over the finite cube of ZMod 16 · conf: high
- [x] `sum_two_cubes_zmod_seven_mem` — A sum of two integer cubes is never congruent to 3 or 4 modulo 7
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 7, decide over ZMod 7 × ZMod 7 (cubes hit only {0,1,6}) · conf: high
- [x] `diff_two_squares_zmod_four_ne_two` — A difference of two integer squares is never congruent to 2 modulo 4
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 4, decide over the finite ZMod 4 × ZMod 4 cases · conf: high
- [x] `sq_mod_five_ne_two_three` — No natural number's square leaves remainder 2 or 3 when divided by 5
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..4 to rule out both non-residues · conf: high
- [x] `cube_mod_thirtyone_nonresidue_five` — None of 3, 5, 6, 7 is a cubic residue modulo 31
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%31, decide to exclude the four named non-residues · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 24 candidates

- [x] `sq_mod_ten_mem` — The last decimal digit of any perfect square is always one of 0, 1, 4, 5, 6, or 9
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 10, decide each of the 10 residue branches · conf: high
- [x] `sq_mod_ten_ne_two_three_seven_eight` — No perfect square ends in the decimal digit 2, 3, 7, or 8
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then interval_cases / decide over n % 10 to rule out the four non-residue digits · conf: high
- [x] `sq_mod_fifteen_mem` — Every perfect square is congruent to 0, 1, 4, 6, 9, or 10 modulo 15
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 15, decide each of the 15 residue branches · conf: high
- [x] `sq_mod_twenty_mem` — Every perfect square is congruent to 0, 1, 4, 5, 9, or 16 modulo 20
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 20, decide each residue branch · conf: high
- [x] `sq_mod_thirtytwo_mem` — The quadratic residues modulo 32 are exactly 0, 1, 4, 9, 16, 17, and 25
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 32, decide each of the 32 residue branches · conf: high
- [x] `sq_mod_forty_mem` — Every perfect square is congruent to one of 0,1,4,9,16,20,24,25,36 modulo 40
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 40, decide each of the 40 residue branches · conf: high
- [x] `cube_mod_twentyseven_mem` — The cubic residues modulo 27 are exactly 0, 1, 8, 10, 17, 19, and 26
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 27, decide each of the 27 residue branches · conf: high
- [x] `cube_mod_fourteen_mem` — The cubic residues modulo 14 are exactly 0, 1, 6, 7, 8, and 13
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 14, decide each residue branch · conf: high
- [x] `fourth_power_mod_five_mem` — Every natural number's fourth power is congruent to 0 or 1 modulo 5
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 5, decide each of the 5 residue branches (Fermat exponent 4) · conf: high
- [x] `fourth_power_mod_ten_mem` — The last decimal digit of any fourth power is always 0, 1, 5, or 6
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 10, decide each residue branch · conf: high
- [x] `fourth_power_mod_thirtytwo_mem` — Every natural number's fourth power is congruent to 0, 1, 16, or 17 modulo 32
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 32, decide each of the 32 residue branches · conf: high
- [x] `fifth_power_mod_twentytwo_mem` — The fifth-power residues modulo 22 are exactly 0, 1, 10, 11, 12, and 21
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 22, decide each of the 22 residue branches · conf: high
- [x] `sixth_power_mod_fourteen_mem` — Every natural number's sixth power is congruent to 0, 1, 7, or 8 modulo 14
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 14, decide each residue branch · conf: high
- [x] `sixth_power_mod_sixtythree_mem` — Every natural number's sixth power is congruent to 0, 1, 28, or 36 modulo 63
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 63, decide each of the 63 residue branches · conf: high
- [x] `sixth_power_mod_twentyone_mem` — Every natural number's sixth power is congruent to 0, 1, 7, or 15 modulo 21
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 21, decide each residue branch · conf: high
- [x] `fifth_power_mod_sixteen_odd_mem` — A fifth power modulo 16 is either 0 or one of the odd residues, and in fact equals n itself modulo 16 up to even classes
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 16, decide each of the 16 residue branches · conf: high
- [ ] `two_squares_zmod_sixteen_ne_three_seven_eleven` — A sum of two integer squares is never congruent to 3, 7, 11, or 15 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 16 × ZMod 16 domain after splitting the conjunction · conf: high
- [ ] `diff_two_squares_zmod_sixteen_ne_two_six` — A difference of two integer squares is never congruent to 2, 6, 10, or 14 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 16 × ZMod 16 domain · conf: high
- [ ] `two_cubes_zmod_nine_ne_three_four_five_six` — A sum of two integer cubes is never congruent to 3, 4, 5, or 6 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 9 × ZMod 9 domain (cubes hit only {0,1,8} mod 9) · conf: high
- [ ] `diff_two_cubes_zmod_seven_ne_three_four` — A difference of two integer cubes is never congruent to 3 or 4 modulo 7
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 7 × ZMod 7 domain (cubes hit only {0,1,6} mod 7) · conf: high
- [ ] `two_fourth_powers_zmod_five_ne_three_four` — A sum of two integer fourth powers is never congruent to 3 or 4 modulo 5
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 5 × ZMod 5 domain (fourth powers are only 0 or 1 mod 5) · conf: high
- [ ] `three_fourth_powers_zmod_sixteen_mem` — A sum of three integer fourth powers is always congruent to 0, 1, 2, or 3 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 16 cubed domain (each fourth power is 0 or 1 mod 16) · conf: high
- [ ] `three_cubes_zmod_nine_ne_four_five` — A sum of three integer cubes is never congruent to 4 or 5 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: decide over the finite ZMod 9 cubed domain (the classic obstruction to representing 4,5 mod 9 as three cubes) · conf: high
- [x] `cube_mod_twentysix_mem` — The cubic residues modulo 26 are exactly 0,1,5,8,12,13,14,18,21,25
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 26, decide each of the 26 residue branches · conf: high

### Replenishment round 3 (scoped 2026-06-15) — 25 candidates

- [ ] `sq_mod_fourteen_mem` — Every perfect square is congruent to 0, 1, 2, 4, 7, 8, 9 or 11 modulo 14
      absence: no-local-match · triviality: non-trivial · intended: Reduce via Nat.pow_mod, then decide over the 14 residues of n%14 (interval_cases on n%14) · conf: high
- [ ] `sq_mod_eighteen_mem` — Every perfect square lies in {0,1,4,7,9,10,13,16} modulo 18
      absence: no-local-match · triviality: non-trivial · intended: Rewrite n^2 % 18 with Nat.pow_mod and case-split on n % 18 via decide · conf: high
- [ ] `sq_mod_twentytwo_mem` — Every perfect square modulo 22 is one of the twelve quadratic residues {0,1,3,4,5,9,11,12,14,15,16,20}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod to depend only on n % 22, then decide over all 22 residues · conf: high
- [ ] `sq_mod_twentyfive_mem` — Every perfect square modulo the prime-power 25 lies in {0,1,4,6,9,11,14,16,19,21,24}
      absence: no-local-match · triviality: non-trivial · intended: Reduce to n % 25 via Nat.pow_mod and decide; prime-power modulus gives an asymmetric residue set · conf: high
- [ ] `cube_mod_twentyone_mem` — Every cube is congruent to one of {0,1,6,7,8,13,14,15,20} modulo 21
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod reduces n^3 % 21 to a function of n % 21; decide over the 21 cases · conf: high
- [ ] `cube_mod_thirtyseven_mem` — The cubic residues modulo the prime 37 are exactly {0,1,6,8,10,11,14,23,26,27,29,31,36}
      absence: no-local-match · triviality: non-trivial · intended: Since 3 divides 36, cubes hit only the 13 cubic residues; reduce via Nat.pow_mod and decide over n % 37 (needs raised maxRecDepth) · conf: high
- [ ] `cube_mod_fortythree_mem` — The cubic residues modulo the prime 43 are exactly the fifteen values {0,1,2,4,8,11,16,21,22,27,32,35,39,41,42}
      absence: no-local-match · triviality: non-trivial · intended: 3 | 42 so only 15 cubic residues occur; Nat.pow_mod plus decide over n % 43 with raised maxRecDepth · conf: high
- [ ] `fourth_power_mod_nine_mem` — Every fourth power is congruent to 0, 1, 4 or 7 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod reduces n^4 % 9 to n % 9; decide over the 9 residues · conf: high
- [ ] `fourth_power_mod_twentyfive_mem` — Every fourth power modulo 25 lies in the arithmetic-progression set {0,1,6,11,16,21}
      absence: no-local-match · triviality: non-trivial · intended: Reduce to n % 25 via Nat.pow_mod and decide; nonzero residues are exactly 1 mod 5 · conf: high
- [ ] `fourth_power_mod_fortyone_mem` — The fourth-power residues modulo the prime 41 are exactly {0,1,4,10,16,18,23,25,31,37,40}
      absence: no-local-match · triviality: non-trivial · intended: 4 | 40 gives only 11 quartic residues; Nat.pow_mod and decide over n % 41 with raised maxRecDepth · conf: high
- [ ] `fourth_power_mod_fortyeight_mem` — Every fourth power is congruent to only 0, 1, 16 or 33 modulo 48
      absence: no-local-match · triviality: non-trivial · intended: Strong collapse from 48 residues to 4 values; Nat.pow_mod then decide over n % 48 with raised maxRecDepth · conf: high
- [ ] `fourth_power_mod_eighty_mem` — Every fourth power is congruent to only 0, 1, 16 or 65 modulo 80
      absence: no-local-match · triviality: non-trivial · intended: 80 residues collapse to 4 quartic residues; Nat.pow_mod plus decide over n % 80 with raised maxRecDepth · conf: high
- [ ] `fourth_power_mod_hundred_mem` — The last two decimal digits of a fourth power are always one of twelve values {00,01,16,21,25,36,41,56,61,76,81,96}
      absence: no-local-match · triviality: non-trivial · intended: n^4 mod 100 depends only on n % 100; Nat.pow_mod then decide over 100 residues with raised maxRecDepth · conf: high
- [ ] `fifth_power_mod_fortyone_mem` — The fifth-power residues modulo the prime 41 are exactly {0,1,3,9,14,27,32,38,40}
      absence: no-local-match · triviality: non-trivial · intended: 5 | 40 yields only 9 quintic residues; Nat.pow_mod and decide over n % 41 with raised maxRecDepth · conf: high
- [ ] `sixth_power_mod_nineteen_mem` — Every sixth power is congruent to only 0, 1, 7 or 11 modulo the prime 19
      absence: no-local-match · triviality: non-trivial · intended: 6 | 18 so the nonzero sixth powers form the order-3 subgroup; Nat.pow_mod then decide over n % 19 · conf: high
- [ ] `sixth_power_mod_thirtyone_mem` — Every sixth power modulo the prime 31 lies in the order-5 subgroup {1,2,4,8,16} together with 0
      absence: no-local-match · triviality: non-trivial · intended: 6 | 30, so nonzero sixth powers form the 5-element subgroup of powers of 2; Nat.pow_mod then decide over n % 31 · conf: high
- [ ] `sixth_power_mod_fortynine_mem` — Every sixth power modulo the prime-power 49 lies in the eight values {0,1,8,15,22,29,36,43}
      absence: no-local-match · triviality: non-trivial · intended: Nonzero residues are exactly 1 mod 7; Nat.pow_mod then decide over n % 49 with raised maxRecDepth · conf: high
- [ ] `eighth_power_mod_fifteen_mem` — Every eighth power is congruent to only 0, 1, 6 or 10 modulo 15
      absence: no-local-match · triviality: non-trivial · intended: By CRT mod 3 and 5 the eighth powers collapse to four values; Nat.pow_mod then decide over n % 15 · conf: high
- [ ] `eighth_power_mod_sixteen_mem` — Every eighth power is congruent to only 0 or 1 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: Odd^8 ≡ 1 and even^8 ≡ 0 mod 16; Nat.pow_mod then decide over n % 16 · conf: high
- [ ] `eighth_power_mod_thirtytwo_mem` — Every eighth power is congruent to only 0 or 1 modulo 32
      absence: no-local-match · triviality: non-trivial · intended: Odd eighth powers are ≡1 mod 32 (since the multiplicative exponent of (Z/32)* divides 8); Nat.pow_mod then decide over n % 32 · conf: high
- [ ] `ninth_power_mod_nineteen_mem` — Every ninth power is congruent to only 0, 1 or 18 modulo the prime 19
      absence: no-local-match · triviality: non-trivial · intended: 9 | 18, so nonzero ninth powers are exactly ±1 mod 19; Nat.pow_mod then decide over n % 19 · conf: high
- [ ] `tenth_power_mod_eleven_mem` — Every tenth power is congruent to only 0 or 1 modulo the prime 11 (Fermat's little theorem boundary case)
      absence: no-local-match · triviality: non-trivial · intended: Fermat: nonzero n^10 ≡ 1 mod 11; Nat.pow_mod then decide over n % 11 · conf: high
- [ ] `eleventh_power_mod_twentythree_mem` — Every eleventh power is congruent to only 0, 1 or 22 modulo the prime 23
      absence: no-local-match · triviality: non-trivial · intended: 11 | 22 so nonzero eleventh powers are ±1 (the quadratic-residue Euler criterion); Nat.pow_mod then decide over n % 23 · conf: high
- [ ] `twelfth_power_mod_thirteen_mem` — Every twelfth power is congruent to only 0 or 1 modulo the prime 13 (Fermat's little theorem boundary case)
      absence: no-local-match · triviality: non-trivial · intended: Fermat: nonzero n^12 ≡ 1 mod 13; Nat.pow_mod then decide over n % 13 · conf: high
- [ ] `sixteenth_power_mod_seventeen_mem` — Every sixteenth power is congruent to only 0 or 1 modulo the prime 17 (Fermat's little theorem boundary case)
      absence: no-local-match · triviality: non-trivial · intended: Fermat: nonzero n^16 ≡ 1 mod 17; Nat.pow_mod then decide over n % 17 · conf: high

### Replenishment round 4 (scoped 2026-06-15) — 22 candidates

- [ ] `ninth_power_mod_twentyseven_mem` — Every ninth power of a natural number leaves remainder 0, 1, or 26 when divided by 27
      absence: no-local-match · triviality: non-trivial · intended: Rewrite via Nat.pow_mod then decide over the 27 residue classes of n % 27 (omega/interval_cases bridge) · conf: high
- [ ] `tenth_power_mod_twentyfive_mem` — Every tenth power of a natural number is congruent to 0, 1, or 24 modulo 25
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod reduction then decide on n % 25 (prime-power modulus, Euler-phi=20 forces tiny image) · conf: high
- [ ] `fourth_power_mod_fifteen_mem` — Every fourth power of a natural number leaves remainder 0, 1, 6, or 10 modulo 15
      absence: no-local-match · triviality: non-trivial · intended: CRT-flavoured: reduce mod 15 via Nat.pow_mod and decide over n % 15 · conf: high
- [ ] `sixth_power_mod_twentyeight_mem` — Every sixth power of a natural number leaves remainder 0, 1, 8, or 21 modulo 28
      absence: no-local-match · triviality: non-trivial · intended: Reduce with Nat.pow_mod and decide on n % 28 (composite 4*7 modulus) · conf: high
- [ ] `twelfth_power_mod_thirtyfive_mem` — Every twelfth power of a natural number is congruent to 0, 1, 15, or 21 modulo 35
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 35; lcm(phi(5),phi(7))=12 makes the image four idempotent-like classes · conf: high
- [ ] `cube_mod_sixtythree_mem` — Every cube of a natural number leaves one of nine specific remainders modulo 63
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod reduction then decide over the 63 classes of n % 63 (cubic residues mod 9*7) · conf: high
- [ ] `seventh_power_mod_fortythree_mem` — Every seventh power of a natural number is congruent to one of seven specific values modulo the prime 43
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide on n % 43; since 7 divides 42=phi(43) the seventh powers form a size-7 subgroup plus zero · conf: high
- [ ] `eighth_power_mod_fortyone_mem` — Every eighth power of a natural number leaves one of six specific remainders modulo the prime 41
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 41; eighth powers form the size-5 subgroup (40/8) of the multiplicative group, plus zero · conf: high
- [ ] `twelfth_power_mod_ninetyone_mem` — Every twelfth power of a natural number is congruent to 0, 1, 14, or 78 modulo 91
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 91 (=7*13); needs maxRecDepth bump given the 91 cases · conf: med
- [ ] `eighth_power_mod_fortyeight_mem` — Every eighth power of a natural number leaves remainder 0, 1, 16, or 33 modulo 48
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 48 (modulus 16*3) · conf: high
- [ ] `sixth_power_mod_seventytwo_mem` — Every sixth power of a natural number is congruent to 0, 1, 9, or 64 modulo 72
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 72 (=8*9); larger modulus needs maxRecDepth increase · conf: med
- [ ] `fourth_power_mod_eighty_mem_deeper` — Every fourth power of a natural number leaves remainder 0, 1, 16, or 65 modulo 80
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 80 (=16*5) · conf: high
- [ ] `eighth_power_mod_eighty_mem` — Every eighth power of a natural number is congruent to 0, 1, 16, or 65 modulo 80
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 80; eighth powers collapse to the same image as fourth powers here · conf: med
- [ ] `fifth_power_mod_fortyfour_mem` — Every fifth power of a natural number leaves one of nine specific remainders modulo 44
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 44 (=4*11) · conf: high
- [ ] `tenth_power_mod_twentytwo_mem` — Every tenth power of a natural number is congruent to 0, 1, 11, or 12 modulo 22
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 22 (=2*11); Fermat collapses the mod-11 part to {0,1,10} · conf: high
- [ ] `fourth_power_mod_twohundredforty_mem` — Every fourth power of a natural number leaves one of eight specific remainders modulo 240
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over the 240 classes of n % 240 (=16*3*5); needs a substantial maxRecDepth bump · conf: med
- [ ] `square_mod_nineteen_mem` — Every square of a natural number is a quadratic residue from the explicit set of ten values modulo the prime 19
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 19 (the (19-1)/2+1 = 10 quadratic residues including zero) · conf: high
- [ ] `square_mod_twentythree_mem` — Every square of a natural number is a quadratic residue from the explicit set of twelve values modulo the prime 23
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 23 (the eleven nonzero quadratic residues plus zero) · conf: high
- [ ] `square_mod_twentyeight_mem` — Every square of a natural number leaves one of eight specific remainders modulo 28
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 28 (=4*7 composite modulus) · conf: high
- [ ] `fourth_power_mod_thirtyseven_mem` — Every fourth power of a natural number leaves one of ten specific remainders modulo the prime 37
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 37; since 4 divides 36 the fourth powers form the size-9 subgroup plus zero · conf: high
- [ ] `sixth_power_mod_twentysix_mem` — Every sixth power of a natural number is congruent to one of six specific values modulo 26
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 26 (=2*13) · conf: high
- [ ] `fourth_power_mod_fiftyone_mem` — Every fourth power of a natural number leaves one of ten specific remainders modulo 51
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over n % 51 (=3*17 composite modulus) · conf: high
