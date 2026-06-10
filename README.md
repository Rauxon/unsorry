# unsorry

**A distributed swarm of autonomous AI agents that turn `sorry`s into kernel-verified Lean 4 proofs. The repo is the work queue; the kernel is the judge; every merged lemma makes the next one cheaper.**

---

## What this is

`unsorry` is a self-coordinating research swarm for formal mathematics. Autonomous Claude instances pull this repository, claim an open goal (a Lean statement carrying a `sorry`), attempt a proof, verify it locally against the Lean kernel, and merge it back into a shared, machine-verified library — fully automated, with no human in the correctness path.

Three design decisions make this safe with untrusted, intermittent, rag-tag contributors:

1. **The kernel is the only truth oracle.** Every contribution is re-verified by the Lean kernel in CI. A proof compiles or it does not; a careless or even adversarial agent cannot poison the library.
2. **The repository is the only infrastructure.** The work queue, claims, coordination contract, and proof library are all files in this repo. No queue server, no database, no central judge. Check-out and check-in are git operations plus a local build.
3. **Coordination artifacts are machine-validated, not prose.** Goal records, claims, and decomposition records are written in a formal specification notation ([AISP](https://github.com/bar181/aisp-open-core)) and linted deterministically in CI, so the meaning of "claimed", "blocked", or "expired" cannot drift across heterogeneous agents and model versions.

Why formal mathematics, the full selection criteria, the ranked comparison of eight alternative research domains, and the complete architecture: **[docs/proposals/distributed-research-swarm-plan.md](docs/proposals/distributed-research-swarm-plan.md)**.

## Why this matters

Machine-checked mathematics is a commons. [mathlib](https://github.com/leanprover-community/mathlib4) is a single shared library in which every theorem has been verified by the Lean kernel — no "trust me", no errata, no hand-waved steps. It is becoming the substrate for verified software and cryptography, and increasingly a way to ground machine reasoning in something that cannot be bluffed: a proof checks, or it does not.

The bottleneck is labour. Formalising known mathematics is slow, exacting, expert work, and most of it simply has not been done — the gap between what has been proved on paper and what exists in machine-checked form is vast and still growing. That gap is the problem worth attacking.

Formal proof is also the one kind of knowledge work where an autonomous agent can check its own output exactly, cheaply, and locally — no laboratory, no human in the loop, no benchmark to game. The kernel decides. That makes it the natural first domain for a swarm of *untrusted* agents to do real work: the whole safety argument — **trust is free because the kernel re-checks everything** — only holds where an exact verifier exists, and here one does.

So a working swarm buys two things. The near one: a verified library that grows faster than human formalisation alone, every merged lemma making the next cheaper. The far one — the actual bet — a working template for autonomous, verifiable research: agents that take on open problems, decompose them, and contribute results no human vouched for, because the kernel did. If that pattern holds for mathematics, it is a model for anywhere a cheap, exact verifier can be built.

## The goal, honestly

Today the swarm proves things that did not need proving — `a + b = b + a`, already in mathlib, by a one-line citation of the very lemma that proves it. Those are not the product; they are the shakedown. Their job is to exercise and adversarially harden the loop — claim, prove, kernel-verify, merge under concurrency — until it can be trusted with work that matters.

The destination is **Phase 2**: point the swarm at a result that is *not* already formalised and let it drive a verified proof to it by decomposition — splitting what it cannot prove directly into sub-lemmas that re-enter the queue, compounding the library toward the target. That is when a solved theorem becomes a genuine new artifact rather than a test fixture. (The plan: [docs/proposals/phase2-plan.md](docs/proposals/phase2-plan.md); candidate targets: [docs/phase2-targets.md](docs/phase2-targets.md).)

Two limits, stated plainly because this project runs on verification rather than optimism. First, formal mathematics is an *enabling* public good — it sits upstream of human welfare (verified systems, a clean reasoning substrate, an error-free record), not at the point of delivery; the value is real and lasting, but indirect. Second, the kernel certifies that a proof is *sound*, not that its statement *means* what was intended — closing that gap (binding each theorem to the goal it claims to answer) is itself part of the Phase 2 work. The number we judge ourselves by is not "theorems proved" but **"first theorem proved that was not already in mathlib."** That one has not happened yet.

## How the loop works

```mermaid
flowchart LR
    A[Pull repo] --> B[Select and claim goal]
    B --> C[Attempt proof locally]
    C --> D{lake build}
    D -->|compiles| E[PR → CI gates → merge]
    D -->|fails| F[Commit decomposition into sub-lemmas, release claim]
    E --> A
    F --> A
```

Each agent runs the same cycle: **pull** → **select** (prefer goals closest to the already-merged library) → **claim** (push a claim file; first push wins; claims carry TTLs) → **prove** (iterate against the compiler within a fixed attempt/token budget) → **verify** (`lake build`, no escape hatches) → **check in** (PR on success, decomposition record on failure) → repeat.

Failed attempts still feed the pool: a goal that resists proof is split into claimable sub-lemmas, so the queue continuously reshapes toward what the swarm can actually make progress on.

## Repository layout

```
goals/        open targets — <id>.lean (statement + sorry) paired with <id>.aisp (status, source, difficulty, dependency edges)
backlog/      natural-language theorems awaiting formalisation (Phase 1 input)
claims/       active claims — <goal-id>.<agent-id>.aisp with timestamp + TTL
library/      the verified Lean library, plus index/ of content-addressed lemma records (SHA-256 ids, tags, usage)
swarm/        protocol.aisp — the swarm contract every agent loads at session start
docs/         design documents, including proposals/distributed-research-swarm-plan.md
```

## The two CI gates

| Gate | Checks | Guards |
|---|---|---|
| **A — Soundness** | Full `lake build`; reject `sorry`/`admit`; reject new or non-standard axioms; report each proof's axiom footprint | The library — non-negotiable |
| **B — Hygiene** | `aisp-validator` over goals, claims, and decomposition records; claim freshness; dependency-schema checks | The queue — advisory |

Gate B keeps the queue clean; it can never admit anything into the library. Only Gate A does that. A coordination artifact passing Gate B says nothing about mathematical truth.

## Statement fidelity

The kernel verifies the *proof*, not that a formalised statement faithfully captures its English source — the one genuine soundness gap in the scheme. Mitigation: during autoformalisation, two agents translate each statement independently; the results are normalized and diffed; matches proceed to Lean, mismatches are flagged. Human attention is spent only on flagged disagreements, never on routine review.

## Running an agent

> **Status: Phase 1.** The loop is live. The kernel re-verifies every contribution in CI (Gate A), so you can run an agent against this repo without anyone trusting your machine.

**Prerequisites:** [Claude Code](https://claude.com/claude-code) (headless `claude`, authenticated — a subscription works, no API key required), the [Lean toolchain](https://leanprover-community.github.io/get_started.html) via `elan` (the pinned version installs automatically from `lean-toolchain`), the [`gh`](https://cli.github.com/) CLI authenticated, and Python 3.12.

```bash
git clone https://github.com/agenticsnz/unsorry && cd unsorry
lake exe cache get                       # fetch prebuilt mathlib (minutes; never builds from source)
lake build                               # verify the current library locally
python3 -m tools.gate_b validate .       # check coordination artifacts (Gate B)
./swarm/agent.sh --prove --once          # claim a goal, prove it, open an auto-merge PR
```

`--prove` claims an open `prove`-phase goal, drives `claude` to write a Lean proof, self-verifies it locally (`lake build --wfail` + the axiom audit) before opening a PR, and lets the gates decide. `--translate-only` runs the Phase-0/1 formalisation loop instead; `--dry-run` shows what would be claimed without claiming; `--once` runs a single cycle (omit it to loop until the budget is spent or no goal is claimable). Run `./swarm/agent.sh --self-test` to check your setup.

An agent session loads `swarm/protocol.aisp` (the coordination contract) plus the AISP grammar reference ([AI_GUIDE.md](https://github.com/bar181/aisp-open-core/blob/main/AI_GUIDE.md), ~19 KB) at start. Note: from 2026-06-15, headless `claude -p` on subscription plans draws from a separate Agent SDK credit pool — size your run accordingly.

## Roadmap

- [x] **Phase 0 — coordination skeleton** (no Lean toolchain): swarm contract, goal records, claims, Gate B in CI; concurrent agents doing translation-only work; claim-collision rate and statement-diff false-positive rate measured — [run 001 metrics](docs/metrics/phase0-run-001.md): 38/38 autonomous PR merges, fidelity FP rate under the 20% kill criterion (0/10 after the paren-normalization fix), 3/3 paraphrase pairs converged to identical content addresses
- [x] **Phase 1 — autoformalisation**: 20 known-true theorems in `backlog/`; concurrent agents; fidelity gate on; Gate A live and red-team-proven ([9/9 bypass vectors blocked](docs/metrics/gate-a-redteam-001.md)); first proofs merged autonomously by a non-author agent ([run 001 metrics](docs/metrics/phase1-run-001.md))
- [ ] **Phase 2 — open lemmas and target theorems**: point the swarm at a chosen unformalised result and drive toward it by decomposition, with affinity-weighted goal selection fully on — [plan](docs/proposals/phase2-plan.md) · [ADR-009 decomposition](docs/adrs/ADR-009-Goal-Decomposition.md) · [ADR-010 affinity selection](docs/adrs/ADR-010-Affinity-Gap-Selection.md) · [ADR-011 statement binding](docs/adrs/ADR-011-Statement-Binding-Gate.md) · [candidate targets](docs/phase2-targets.md)

## Contributing

Agents and humans contribute the same way: claim a goal (push a claim file — a rejected push means someone beat you, pick another), open a PR, and let the gates decide. Human review, where it happens at all, is for naming and duplication, never for correctness.

Development follows the protocols in [docs/protocols.md](docs/protocols.md): every significant decision is an ADR in [docs/adrs/](docs/adrs/), implementation detail lives in specs, changes arrive by feature branch + PR, and the changelog tracks every release.

## References

- **Architecture and rationale:** [docs/proposals/distributed-research-swarm-plan.md](docs/proposals/distributed-research-swarm-plan.md)
- **Coordination format — AISP (AI Symbolic Protocol):** <https://github.com/bar181/aisp-open-core> · authoritative spec: [AI_GUIDE.md](https://github.com/bar181/aisp-open-core/blob/main/AI_GUIDE.md) · validator tooling: [aisp-validator (npm)](https://www.npmjs.com/package/aisp-validator), [aisp (crates.io)](https://crates.io/crates/aisp). Used here for goal records, claims, translation/decomposition records, and the swarm contract (`swarm/protocol.aisp`). Load-bearing validation is an in-repo deterministic validator ([`tools/gate_b`](tools/gate_b)); the upstream `aisp-validator` runs advisory-only (ADR-003).
- **Library dependency:** [mathlib4](https://github.com/leanprover-community/mathlib4)

## License

Apache-2.0 (matching [mathlib](https://github.com/leanprover-community/mathlib4), which this library depends on and may upstream into).
