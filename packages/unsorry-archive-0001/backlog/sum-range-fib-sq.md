# sum-range-fib-sq

For every natural n, the sum over i in 0..n of (fib i)^2 equals fib n * fib (n+1) (the telescoping identity F_0^2+...+F_n^2 = F_n F_{n+1}).

- **Source:** classic identities
- **Reference:** Standard Fibonacci telescoping identity; Koshy, Fibonacci and Lucas Numbers with Applications, §5; Vajda, Fibonacci & Lucas Numbers, and the Golden Section.
- **Absence:** machine-checked no-local-match (grep of pinned mathlib rev c5ea00351c28, 2026-06-10); related lemmas exist but are different identities
- **Difficulty:** 2
- **Decomposition sketch:** Induction on n with Finset.sum_range_succ; step adds F_{n+1}^2: F_n F_{n+1} + F_{n+1}^2 = F_{n+1}(F_n + F_{n+1}) = F_{n+1} F_{n+2}, using Nat.fib_add_two : fib(n+2)=fib(n)+fib(n+1). One supporting rewrite (fib_add_two), no separate lemma.
