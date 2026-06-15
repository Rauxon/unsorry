# ADR-046: Namespace `.lake` Cache Volume for Gate A

| Field | Value |
|-------|-------|
| **Decision ID** | ADR-046 |
| **Initiative** | unsorry — Gate A performance |
| **Proposed By** | unsorry maintainers |
| **Date** | 2026-06-15 |
| **Status** | Accepted |

## Context

After ADR-045 (library-build cache) and its amendment (skip the redundant build in audit/replay),
the remaining **constant** cost of every active-PR gate run is the **mathlib binary restore**:
`lean-action`'s `use-github-cache` pulls the mathlib oleans from the GitHub Actions cache on each
of the three Lean jobs — measured at **~2–3.5 min per job** (run 27536559685: the "Build
(lean-action)" step was 129 s in audit, 92 s in prepare). It is paid on every job of every run
because GitHub-cache state is per-run ephemeral storage, not a persistent disk.

ADR-045's amendment also showed *why* GitHub-cache restore of the local oleans does not yield
Lake incrementality: `lean-action` re-provisions mathlib **after** the restore, so the restored
library oleans look stale to Lake and it re-elaborates them. A **persistent runner-local volume**
that holds the *whole* `.lake` (mathlib packages **and** local build) across jobs and runs avoids
both problems at once: mathlib is already on disk (no restore, no re-provisioning), so
`lake exe cache get` is a near-no-op and the local oleans Lake produced last run are trusted.

Namespace runners (the gate's `namespace-profile-unsorry-1/2`) support exactly this via
[`nscloud-cache-action`](https://github.com/namespacelabs/nscloud-cache-action): a keyless,
volume-backed bind-mount of a path, attached to the runner profile. It is **Namespace-specific**
— it does nothing useful on a GitHub-hosted runner — so it must be wired so the gate still works
when Namespace is not in use.

## WH(Y) Decision Statement

**In the context of** Gate A's three Lean jobs each restoring the mathlib olean cache (~2–3.5 min)
on every run, the last constant cost after ADR-045, and of GitHub-cache restore being unable to
give Lake incrementality because mathlib is re-provisioned after it,

**facing** the fact that GitHub Actions cache is per-run ephemeral storage — there is no way to
keep `.lake` warm on it across runs without paying a restore — while the Namespace runner profiles
can attach a **persistent cache volume**,

**we decided for** mounting a Namespace cache volume at **`${{ github.workspace }}/.lake`** with
`namespacelabs/nscloud-cache-action` (pinned v1.4.3) in `gate-a-prepare`, `gate-a-audit`, and
`gate-a-replay`, **and turning `lean-action`'s `use-github-cache` off when the volume is in play**
so mathlib is read from the warm volume instead of re-restored; the volume is gated on a
**`detect.volume` flag derived from the profile name** (`namespace-*` → `true`, anything else →
`false`) and the step is **`continue-on-error`**, so a non-Namespace runner or a profile with no
volume attached simply skips it and falls back to the GitHub mathlib cache (`use-github-cache`) and
the ADR-045 `.lake/build` cache, which are themselves gated to the non-volume path,

**and neglected** a Namespace `nsc artifact` upload/download (heavier, key-managed, and we want a
*persistent* mount not a per-run artifact), caching only mathlib while keeping the ADR-045
GitHub-cache for local oleans (two mechanisms fighting over `.lake`; the volume subsumes both on
Namespace), and keeping `use-github-cache: true` alongside the volume (it would re-restore mathlib
every run, erasing the win),

**to achieve** warm-volume runs where mathlib is already resident (no ~2–3.5-min restore × 3 jobs)
and Lake incrementality actually holds (stable mathlib ⇒ trusted local oleans), cutting the gate's
last constant cost,

**accepting that** the **first** run against a cold (empty) volume pays a one-time mathlib
provisioning from the reservoir (covered by the 45-min prepare/audit and 120-min replay timeouts),
that the volume must be **attached to both runner profiles** at the Namespace control plane (an
operator step, below), and that the volume is advisory state — never trust-bearing (see Soundness).

## Soundness

The volume is a build cache, not a trust input. `leanchecker` re-checks every olean it loads
against the kernel regardless of whether the olean came from a volume, a download, or a fresh
build; the axiom audit inspects the same oleans; the `--wfail` bar is enforced in `gate-a-prepare`;
and the **push-to-`main` full audit + replay** (no `BASE_SHA`) re-verify the entire active library
post-merge. A stale or corrupt volume can only cause a *rebuild* or a *load failure* (a red gate —
a false negative), never a false PASS. The volume is keyed by nothing and shared across commits by
design: that is safe precisely because correctness comes from the kernel replay, not the cache.

## Failsafe (explicit)

1. **Profile-derived flag.** `detect` emits `volume=true` only when the chosen profile is
   `namespace-*`. Change the runner to a non-Namespace one and `volume=false` automatically — no
   reference to `nscloud-cache-action` executes.
2. **Soft-fail.** The mount step is `continue-on-error: true`: if the profile is Namespace but no
   volume is attached (or the action errors), the job continues.
3. **Live fallbacks.** When `volume != 'true'`, `lean-action`'s `use-github-cache` is on and the
   ADR-045 `.lake/build` cache runs, i.e. exactly today's behaviour. The volume is purely additive.

## Operator note

Attach a cache volume to **both** runner profiles (`namespace-profile-unsorry-1` and
`namespace-profile-unsorry-2`) at cloud.namespace.so so `${GITHUB_WORKSPACE}/.lake` persists.
mathlib (~2–3 GB) plus the local oleans fit comfortably in a ~20 GB volume. Until a volume is
attached the gate runs on the GitHub-cache fallback (slower, but correct) — adopting the volume
needs no further code change.

## References

| Reference ID | Title | Type | Location |
|--------------|-------|------|----------|
| REF-1 | Cache-volume implementation spec | Specification | specs/SPEC-046-A-Gate-A-Namespace-Cache-Volume.md |
| REF-2 | Library-build cache (fallback + amendment) | Decision | ADR-045-Gate-A-Library-Build-Cache.md |
| REF-3 | Pinned mathlib binary cache | Decision | ADR-002-Mathlib-Pinning.md |
| REF-4 | Incremental kernel replay (full-replay scope) | Decision | ADR-033-Incremental-Kernel-Replay.md |
| REF-5 | Gate A soundness enforcement | Decision | ADR-006-Gate-A-Soundness-Enforcement.md |

## Status History

| Status | Approver | Date |
|--------|----------|------|
| Proposed | unsorry maintainers | 2026-06-15 |
| Accepted | unsorry maintainers | 2026-06-15 |
