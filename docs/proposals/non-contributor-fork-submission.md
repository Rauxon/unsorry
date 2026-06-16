# Non-contributor proof submission via forks

| Field | Value |
|-------|-------|
| **Type** | Research proposal / investigation |
| **Issue** | [#1206](https://github.com/agenticsnz/unsorry/issues/1206) |
| **Date** | 2026-06-16 |
| **Status** | Draft for review |

## Question

The pitch for unsorry is "clone the repo and say *solve the next problem*." That
loop has only ever been exercised by **contributors with write access** pushing
branches through the automated process (ADR-004/005). It has **not** been tried
by a **non-contributor submitting proofs from a fork**. Will the current system
support that? If not, what changes are needed?

## TL;DR

- **Not via the automated `--prove` loop, as wired today.** That loop assumes
  push/write access to the canonical repo at four points (claim, feature-branch
  push, PR creation, auto-merge) and a verification gate that runs on
  project-credentialed runners. A fork has none of these.
- **But the hard part — soundness — is already solved.** ADR-049 (Accepted)
  established that acceptance is decided *only* by a mandatory central re-check
  that **never trusts a client-supplied artifact**; it re-derives the statement
  from canonical goal source and re-elaborates from source. Under that model a
  proof from a fully-untrusted contributor is exactly as safe as one from a
  trusted agent. The remaining work is **plumbing and trust-governance, not the
  kernel boundary.**
- **The design direction already exists but is unimplemented.** ADR-053
  (volunteer-scale claim substrate) and ADR-054 (agent identity, quotas,
  reputation) are *Proposed* and target precisely this scale. They are not yet
  accepted or built.
- **A non-contributor can already prove and submit *manually* today** with
  `--prove-local` + a hand-opened PR that a maintainer verifies and merges. What
  is missing is the *autonomous, fork-native* path.

## Current reality: where the automated loop assumes write access

The coordinated loop lives in `swarm/agent.sh`. Four steps structurally require
push/write access to the **canonical** repository, which a fork contributor does
not have:

| Step | Operation | Location |
|------|-----------|----------|
| Claim | `git push -q origin claims` (first-push-wins lease, ADR-004) | `swarm/agent.sh:1418` |
| Submit | `git push -q origin "$branch"` (feature branch) | `swarm/agent.sh:1346` |
| Open PR | `gh pr create --base main --head "$branch"` | `swarm/agent.sh:1349` |
| Merge | `gh pr merge --auto --squash "$branch"` (ADR-005 autonomy) | `swarm/agent.sh:1350` |
| Release | `git push -q origin claims` (lease release) | `swarm/agent.sh:2553` |

A fifth, less obvious blocker is **verification itself**:

- Gate A runs on **project-credentialed namespace.so ephemeral runners**
  (`runs-on: ${{ needs.detect.outputs.profile }}` → `namespace-profile-unsorry-1/2`,
  `.github/workflows/gate-a.yml:121`) and restores a credentialed build cache
  (`namespacelabs/nscloud-cache-action`, `gate-a.yml:155`).
- It is wired `on: pull_request` (`gate-a.yml:4`). A fork PR from a
  non-member therefore (a) needs a maintainer to click *Approve and run*, and
  (b) runs **without repository secrets** — so the credentialed runner/cache
  path is not available to a fork PR as-is.

The project already tells forks to stay local. `CONTRIBUTING.md:67-70`:

> Coordinated `--prove` pushes claims, feature branches, and PRs through
> `origin`, so it requires write access to the shared repository. From a fork
> without that access, use `--prove-local`; it works from committed local `HEAD`
> and performs no remote operations.

`--prove-local` (`swarm/agent.sh:1979 prove_local_verify`, `2311 prove_local_goal`)
runs the full local verification (`lake build UnsorryLibrary --wfail` + axiom
audit + option check) and **deliberately performs no fetch/claim/push/PR**. It
proves capability; it does not submit.

## The soundness boundary is already fork-safe (ADR-049)

This is the load-bearing finding, and it is good news. ADR-049 ("Decentralised
CI Runner Architecture", **Accepted**) anticipated untrusted contributors and
fixed the trust model so the kernel verdict never depends on the contributor:

- **Acceptance is decided only by the central re-check** on a project-controlled
  surface "the adversary never touches" (ADR-049 §Soundness argument, point 1).
- The re-check **consumes no client artifact as a trusted input**: it re-derives
  the statement from canonical goal source (ADR-018/011) and re-elaborates the
  changed-module closure **from source** (point 3). A tampered or malicious
  contributor "can at worst produce something the central kernel rejects"
  (§WH(Y)).
- ADR-049 **explicitly rejected** BYO self-hosted runners (Option 4) precisely
  because "a fork PR on a public repo would run the PR head's own gate on
  contributor-controlled hardware — a forged green Gate A." The accepted design
  sidesteps that by keeping the verdict central.

**Implication:** accepting a proof from a fork is *not* a soundness risk under
the ADR-049 model. The blockers above are coordination, CI-plumbing, and
abuse-control concerns — i.e. **hygiene** (ADR-007), never soundness. Identity
"is hygiene, never soundness." This narrows the problem dramatically: we do not
have to invent a trust mechanism, only a *delivery and governance* mechanism.

## What "support this" means — three tiers

### Tier 0 — manual fork submission (works today, undocumented)

A motivated non-contributor can, right now:

1. Fork, `git clone`, run `./swarm/agent.sh --prove-local` to produce and
   locally verify a proof of an open goal.
2. Commit the proof module + library index entry on a branch in their fork and
   open a PR against `agenticsnz/unsorry:main` by hand.
3. A maintainer clicks *Approve and run* (so Gate A/B execute), reviews, and
   merges.

**Gaps that make this rough, not smooth:** no claim coordination (two fork
contributors can duplicate work — though dedup is also enforceable at merge); a
human must approve the workflow run and the merge; the contributor must
hand-assemble the PR tree (module path, index entry, goal edit) that the agent
normally builds. It works, but it is a maintainer-mediated, manual path — not
"clone and say solve the next problem."

### Tier 1 — autonomous fork submission (single contributor, not yet built)

Make the `--prove` loop itself fork-aware so the contributor's agent runs the
full loop end-to-end against their fork, with a trusted mediator handling claim,
gate, and merge. This needs the three changes in the gap analysis below.

### Tier 2 — volunteer scale (many uncoordinated fleets)

Hundreds of independent nodes. This is exactly the scope of the *Proposed*
ADR-053 (pluggable claim substrate to escape branch write-contention) and
ADR-054 (identity, quota tiers, reputation, revocation to contain Sybil/abuse).
Tier 1 is a prerequisite and a forcing function for these.

## Gap analysis: designed vs. missing

| Gap | Status of the design | What is missing to support forks |
|-----|----------------------|----------------------------------|
| **Claiming without write access** | ADR-053 (*Proposed*) defines a substrate contract (atomic acquire/renew/release/expire/inspect) but its only implementation is today's `claims`-branch push, which a fork cannot do. | A fork-reachable claim path: e.g. claim by API/issue/PR-comment to a trusted mediator, a sharded/service lease per ADR-053, **or** drop pre-claiming for fork work and rely on merge-time dedup (first valid proof wins; duplicates are cheap to reject). |
| **Verifying a fork PR on trusted infra** | ADR-049 (*Accepted*) already specifies a central re-check that never trusts client input — the correct and safe gate for fork PRs. | A workflow that runs that gate for fork PRs on project-credentialed runners. The natural shape is a `pull_request_target`/dispatch-style trusted job that **re-derives the statement from canonical source and re-elaborates from source** (per ADR-049), never checking out and trusting the PR head's oleans. Plus a workflow-approval policy for first-time forks. Note the standing CI supply-chain guard: `gate-a.yml` is a CODEOWNERS-gated TCB surface (ADR-019), so this is a reviewed change, not an autonomous one. |
| **Merging a fork PR autonomously** | ADR-005 keys auto-merge on green required checks; GitHub permits auto-merge of fork PRs only when a **write-capable actor** enables it. | A trusted mediating actor — a maintainer, or a write-scoped bot governed by ADR-054 trust tiers — that enables auto-merge once the trusted gate is green. The contributor's own `gh pr merge --auto` (`agent.sh:1350`) cannot do this from a fork. |
| **Abuse / Sybil / quota control** | ADR-054 (*Proposed*) — identity tiers, per-agent caps, reputation, revocation. | Acceptance + implementation. Without it, an open fork path is a CI-flooding and queue-starvation surface (every fork PR can demand a paid namespace.so run). |

## Recommendation

1. **Record the headline finding:** supporting non-contributor forks is a
   *coordination + governance* problem, **not** a soundness problem — ADR-049
   already makes accepting an untrusted proof safe. This should be stated
   explicitly so the work is not over-scoped into re-deriving trust.
2. **Smooth Tier 0 now (cheap, high-leverage):** document the manual fork path
   in `CONTRIBUTING.md` (fork → `--prove-local` → open PR → maintainer verifies
   and merges), and confirm `--prove-local` emits a ready-to-PR tree (module +
   index entry + goal edit) so the contributor is not hand-assembling it. This
   lets real non-contributors participate immediately and surfaces the friction
   that Tier 1 must remove.
3. **Pick the Tier-1 claim model deliberately:** decide between (a) a
   fork-reachable claim mediator and (b) **no pre-claim + merge-time dedup** for
   fork work. Option (b) is the smallest change and is sound (a duplicate proof
   is simply rejected at merge), at the cost of some wasted contributor compute.
   This decision should land as the first concrete step of ADR-053's rollout.
4. **Specify the fork-PR trusted gate** as the concrete instantiation of
   ADR-049 for fork PRs (trusted-runner job, statement re-derived from canonical
   source, source re-elaboration, never trusting PR-head oleans), plus the
   workflow-approval and mediated-merge actor. Gate this behind ADR-054 trust
   tiers before opening it widely.
5. **Advance ADR-053 and ADR-054 from *Proposed* to a decision.** They are the
   right vehicles; this investigation is the concrete use-case that motivates
   accepting them. Tier 2 (volunteer scale) should not open without ADR-054's
   abuse controls in place.

**Smallest next step:** ship Tier 0 documentation + the merge-time-dedup decision
(recommendation 2 + 3a/3b) — that delivers a real, if maintainer-mediated,
non-contributor path without touching the soundness TCB, and de-risks the
larger ADR-053/054 build.

## References

| Ref | Title | Location |
|-----|-------|----------|
| Issue | Investigate: non-contributors solving problems in unsorry | [#1206](https://github.com/agenticsnz/unsorry/issues/1206) |
| ADR-004 | Claims branch, first-push-wins | `docs/adrs/ADR-004-Claims-Branch-First-Push-Wins.md` |
| ADR-005 | Autonomous merge policy | `docs/adrs/ADR-005-Autonomous-Merge-Policy.md` |
| ADR-007 | Agent identity & budgets (identity is hygiene, not soundness) | `docs/adrs/ADR-007-Agent-Identity-and-Budgets.md` |
| ADR-019 | CI supply-chain protection (gate TCB, CODEOWNERS) | `docs/adrs/ADR-019-CI-Supply-Chain-Protection.md` |
| ADR-049 | Decentralised CI runner architecture (central re-check; fork-PR threat) | `docs/adrs/ADR-049-Decentralised-CI-Runner-Architecture.md` |
| ADR-053 | Volunteer-scale claim substrate (*Proposed*) | `docs/adrs/ADR-053-Volunteer-Scale-Claim-Substrate.md` |
| ADR-054 | Agent identity, quotas, reputation (*Proposed*) | `docs/adrs/ADR-054-Agent-Identity-Quotas-And-Reputation.md` |
| Code | Coordinated loop write points | `swarm/agent.sh:1346,1349,1350,1418,2553` |
| Code | Local-only proving | `swarm/agent.sh:1979,2311`; `CONTRIBUTING.md:67-70` |
| CI | Gate A on credentialed namespace.so runners | `.github/workflows/gate-a.yml:4,121,155` |
