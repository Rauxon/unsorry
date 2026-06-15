# Power-residue / modular range facts — candidate backlog (Identity Engine)

Theme staging file for the Identity Engine (#400, ADR-043). 24 vetted candidates — each **absence-clean** (no name/content match in pinned mathlib `c5ea00351c` or our goal set) and screened **non-trivial** (ADR-035 battery). The expensive gates (intended proof compiling under `lake env lean` + adversarial skeptic) run at promotion. Scoped 2026-06-15.

- [x] `sq_mod_eight_mem` — Every natural number's square leaves remainder 0, 1, or 4 when divided by 8
      absence: no-local-match · triviality: non-trivial · intended: omega-on (n % 8) after Nat.pow_mod, then decide over the 8 residues · conf: high
- [x] `sq_mod_sixteen_mem` — Every natural number's square is congruent to 0, 1, 4, or 9 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: rewrite n^2%16 via Nat.pow_mod, case-split on n%16 with decide/omega · conf: high
- [x] `sq_mod_eleven_mem` — The quadratic residues modulo 11 are exactly {0,1,3,4,5,9}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..10 · conf: high
- [ ] `sq_mod_thirteen_mem` — The quadratic residues modulo 13 are exactly {0,1,3,4,9,10,12}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%13, decide each branch · conf: high
- [x] `sq_mod_twelve_mem` — Every natural number's square is congruent to 0, 1, 4, or 9 modulo 12
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over the 12 residue classes · conf: high
- [ ] `sq_mod_twentyfour_mem` — The squares modulo 24 fall in exactly {0,1,4,9,12,16}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%24, decide each of 24 branches · conf: high
- [ ] `cube_mod_eighteen_mem` — The cubes modulo 18 are exactly {0,1,8,9,10,17}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..17 · conf: high
- [ ] `cube_mod_nineteen_mem` — The cubic residues modulo 19 are exactly {0,1,7,8,11,12,18}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%19, decide each branch · conf: high
- [ ] `fourth_power_mod_seventeen_mem` — The fourth-power residues modulo 17 are exactly {0,1,4,13,16}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..16 · conf: high
- [ ] `fourth_power_mod_twentynine_mem` — The fourth-power residues modulo 29 are exactly {0,1,7,16,20,23,24,25}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%29, decide each of 29 branches · conf: med
- [x] `fourth_power_mod_sixteen_mem` — Every natural number's fourth power is congruent to 0 or 1 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..15 (unconditional, unlike the Odd-only version) · conf: high
- [ ] `fifth_power_mod_twentyfive_mem` — The fifth-power residues modulo 25 are exactly {0,1,7,18,24}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%25, decide each branch · conf: high
- [ ] `fifth_power_mod_thirtyone_mem` — The fifth-power residues modulo 31 are exactly {0,1,5,6,25,26,30}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%31, decide each of 31 branches · conf: med
- [ ] `sixth_power_mod_thirteen_mem` — Every natural number's sixth power is congruent to 0, 1, or 12 modulo 13
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..12 · conf: high
- [ ] `sixth_power_mod_nine_mem` — Every natural number's sixth power is congruent to 0 or 1 modulo 9
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..8 · conf: high
- [ ] `seventh_power_mod_twentynine_mem` — The seventh-power residues modulo 29 are exactly {0,1,12,17,28}
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%29, decide each of 29 branches · conf: med
- [ ] `eighth_power_mod_seventeen_mem` — Every natural number's eighth power is congruent to 0, 1, or 16 modulo 17
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..16 · conf: high
- [ ] `sum_two_squares_zmod_four_ne_three` — A sum of two integer squares is never congruent to 3 modulo 4
      absence: no-local-match · triviality: non-trivial · intended: push casts to ZMod 4, then decide over the finite ZMod 4 × ZMod 4 cases · conf: high
- [ ] `sum_two_fourth_powers_zmod_sixteen_mem` — A sum of two integer fourth powers is congruent to 0, 1, or 2 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 16, decide over ZMod 16 × ZMod 16 since each fourth power is 0 or 1 · conf: high
- [ ] `sum_three_squares_zmod_sixteen_ne_fifteen` — A sum of three integer squares is never congruent to 15 modulo 16
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 16, decide over the finite cube of ZMod 16 · conf: high
- [ ] `sum_two_cubes_zmod_seven_mem` — A sum of two integer cubes is never congruent to 3 or 4 modulo 7
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 7, decide over ZMod 7 × ZMod 7 (cubes hit only {0,1,6}) · conf: high
- [ ] `diff_two_squares_zmod_four_ne_two` — A difference of two integer squares is never congruent to 2 modulo 4
      absence: no-local-match · triviality: non-trivial · intended: cast to ZMod 4, decide over the finite ZMod 4 × ZMod 4 cases · conf: high
- [ ] `sq_mod_five_ne_two_three` — No natural number's square leaves remainder 2 or 3 when divided by 5
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then decide over residues 0..4 to rule out both non-residues · conf: high
- [ ] `cube_mod_thirtyone_nonresidue_five` — None of 3, 5, 6, 7 is a cubic residue modulo 31
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n%31, decide to exclude the four named non-residues · conf: high

### Replenishment round 2 (scoped 2026-06-15) — 24 candidates

- [ ] `sq_mod_ten_mem` — The last decimal digit of any perfect square is always one of 0, 1, 4, 5, 6, or 9
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 10, decide each of the 10 residue branches · conf: high
- [ ] `sq_mod_ten_ne_two_three_seven_eight` — No perfect square ends in the decimal digit 2, 3, 7, or 8
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod then interval_cases / decide over n % 10 to rule out the four non-residue digits · conf: high
- [ ] `sq_mod_fifteen_mem` — Every perfect square is congruent to 0, 1, 4, 6, 9, or 10 modulo 15
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 15, decide each of the 15 residue branches · conf: high
- [ ] `sq_mod_twenty_mem` — Every perfect square is congruent to 0, 1, 4, 5, 9, or 16 modulo 20
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 20, decide each residue branch · conf: high
- [ ] `sq_mod_thirtytwo_mem` — The quadratic residues modulo 32 are exactly 0, 1, 4, 9, 16, 17, and 25
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 32, decide each of the 32 residue branches · conf: high
- [ ] `sq_mod_forty_mem` — Every perfect square is congruent to one of 0,1,4,9,16,20,24,25,36 modulo 40
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 40, decide each of the 40 residue branches · conf: high
- [ ] `cube_mod_twentyseven_mem` — The cubic residues modulo 27 are exactly 0, 1, 8, 10, 17, 19, and 26
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 27, decide each of the 27 residue branches · conf: high
- [ ] `cube_mod_fourteen_mem` — The cubic residues modulo 14 are exactly 0, 1, 6, 7, 8, and 13
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 14, decide each residue branch · conf: high
- [ ] `fourth_power_mod_five_mem` — Every natural number's fourth power is congruent to 0 or 1 modulo 5
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 5, decide each of the 5 residue branches (Fermat exponent 4) · conf: high
- [ ] `fourth_power_mod_ten_mem` — The last decimal digit of any fourth power is always 0, 1, 5, or 6
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 10, decide each residue branch · conf: high
- [ ] `fourth_power_mod_thirtytwo_mem` — Every natural number's fourth power is congruent to 0, 1, 16, or 17 modulo 32
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 32, decide each of the 32 residue branches · conf: high
- [ ] `fifth_power_mod_twentytwo_mem` — The fifth-power residues modulo 22 are exactly 0, 1, 10, 11, 12, and 21
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 22, decide each of the 22 residue branches · conf: high
- [ ] `sixth_power_mod_fourteen_mem` — Every natural number's sixth power is congruent to 0, 1, 7, or 8 modulo 14
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 14, decide each residue branch · conf: high
- [ ] `sixth_power_mod_sixtythree_mem` — Every natural number's sixth power is congruent to 0, 1, 28, or 36 modulo 63
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 63, decide each of the 63 residue branches · conf: high
- [ ] `sixth_power_mod_twentyone_mem` — Every natural number's sixth power is congruent to 0, 1, 7, or 15 modulo 21
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 21, decide each residue branch · conf: high
- [ ] `fifth_power_mod_sixteen_odd_mem` — A fifth power modulo 16 is either 0 or one of the odd residues, and in fact equals n itself modulo 16 up to even classes
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
- [ ] `cube_mod_twentysix_mem` — The cubic residues modulo 26 are exactly 0,1,5,8,12,13,14,18,21,25
      absence: no-local-match · triviality: non-trivial · intended: Nat.pow_mod, case-split on n % 26, decide each of the 26 residue branches · conf: high
