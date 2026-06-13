# ADR-023: Optional Proof Provenance and Leaderboard

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-023 |
| **Initiative** | distributed proof-work attribution |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-13 |
| **Status** | Accepted |

## WH(Y) Decision Statement
**In the context of** a distributed swarm whose verified outputs may be produced by different people, machines, providers, and models, and whose coordination pattern may later generalise beyond theorem proving,
**facing** the need to credit contributors and measure which tools produce useful verified work without rewriting or guessing the provenance of historical proofs,
**we decided for** optional proof provenance stored beside each successful content-addressed library index entry, recording the GitHub solver, swarm agent, provider, effective model when known, final effort, attempts, and local solve duration, with a deterministic leaderboard generated only from those verified index records,
**and neglected** Git commit authorship (squash and auto-merge identify the merger rather than reliably identifying the solver), mandatory backfilling (historical data is incomplete), and using leaderboard values in proof admission or work selection (self-reported metadata must not become a trust input),
**to achieve** durable attribution and basic provider/model usage statistics that can evolve toward a general distributed-work accounting layer,
**accepting that** early proofs remain grouped as historical/unknown, timing currently measures local proof generation plus verification rather than CI or wall-clock claim latency, and success-only index records cannot by themselves measure true attempt success rates.

## References
| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Proof provenance and leaderboard specification | Specification | specs/SPEC-023-A-Proof-Provenance-Leaderboard.md |

## Status History
| Status | Approver | Date |
|--------|----------|------|
| Accepted | unsorry maintainers | 2026-06-13 |
