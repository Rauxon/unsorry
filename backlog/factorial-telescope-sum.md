# factorial-telescope-sum

For every natural n, the sum over i in 0..n of i * (i!) equals (n+1)! - 1.

- **Source:** classic identities
- **Reference:** Classic telescoping identity from i·i! = (i+1)! - i!; exercise in Graham, Knuth & Patashnik, Concrete Mathematics, 2nd ed., Ch. 2 (perturbation/telescoping).
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 2
- **Decomposition sketch:** Key sub-lemma: i * i! = (i+1)! - i! (from Nat.factorial_succ = (i+1)*i!). Then induction with Finset.sum_range_succ telescopes. Manage ℕ truncated subtraction with (i+1)! ≥ 1 so omega/Nat.sub lemmas apply. ~2 sub-steps; a real Post⊆Pre dependency on Nat.factorial_succ.
