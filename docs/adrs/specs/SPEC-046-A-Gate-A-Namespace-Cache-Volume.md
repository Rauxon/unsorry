# SPEC-046-A: Namespace `.lake` Cache Volume

Implements: [ADR-046](../ADR-046-Gate-A-Namespace-Cache-Volume.md) · Status: Living · Updated: 2026-06-15

## Behaviour

On Namespace runner profiles, Gate A's three Lean jobs mount a persistent cache volume at
`${GITHUB_WORKSPACE}/.lake`, so mathlib oleans and the local `UnsorryLibrary`/`UnsorryGoals` build
survive across jobs and runs. `lean-action`'s GitHub mathlib cache is disabled there (the volume
supplies mathlib). On any non-Namespace profile, or if no volume is attached, the gate falls back
to the existing GitHub caches with no behavioural change.

## Implementation (`.github/workflows/gate-a.yml`)

- **`detect.volume` flag.** The `profile` step computes the runner profile name, then sets
  `volume=true` iff the name matches `namespace-*`, else `volume=false`; exposed as the
  `detect.volume` job output.
- **Mount step** (in `gate-a-prepare`, `gate-a-audit`, `gate-a-replay`, after checkout, before the
  build):
  ```yaml
  - name: Namespace .lake cache volume
    if: needs.detect.outputs.volume == 'true'
    continue-on-error: true
    uses: namespacelabs/nscloud-cache-action@15799a6b54e5765f85b2aac25b3f0df43ed571c0 # v1.4.3
    with:
      path: ${{ github.workspace }}/.lake
  ```
  The action is keyless (volume-backed bind-mount). The absolute `${{ github.workspace }}/.lake`
  path is required — a relative `.lake` mounts the wrong directory.
- **GitHub-cache fallback gated off on Namespace.** The ADR-045 `.lake/build` `actions/cache` step
  now carries `if: needs.detect.outputs.volume != 'true'`, and the build `lean-action` step uses
  `use-github-cache: ${{ needs.detect.outputs.volume != 'true' }}`.
- **Build-skip interaction (ADR-045).** With the `.lake/build` cache step skipped on Namespace,
  `steps.lake_build_cache.outputs.cache-hit` is empty, so the audit/replay build guard
  (`!= 'true'`) lets the build run — correct, because the volume keeps mathlib stable so that build
  is a fast Lake-incremental, not a cold rebuild.

## Safety

The volume is advisory build state, never a trust input. `leanchecker` re-checks every olean it
loads against the kernel irrespective of origin; the axiom audit inspects the same oleans; `--wfail`
runs in prepare; and the push-to-`main` full audit + replay re-verify the active library
post-merge. The only failure modes the volume can introduce are a rebuild or a load failure — a red
gate (false negative), never a false PASS.

## Failsafe

- Non-Namespace profile → `volume=false` → mount step skipped, GitHub caches active (today's path).
- Namespace profile, no volume attached / action error → `continue-on-error` keeps the job running;
  mathlib is provisioned from the reservoir (one-time on a cold volume).

## Operator note

Attach a cache volume (~20 GB is ample) to `namespace-profile-unsorry-1` and
`namespace-profile-unsorry-2` so `${GITHUB_WORKSPACE}/.lake` persists. No code change is needed to
adopt or to revert.

## Acceptance criteria

- `detect.volume` is `true` for `namespace-*` profiles and `false` otherwise.
- On a Namespace profile, the mount step runs, `use-github-cache` resolves to `false`, and the
  `.lake/build` `actions/cache` step is skipped.
- On a non-Namespace profile, the mount step is skipped, `use-github-cache` resolves to `true`, and
  the `.lake/build` cache step runs (ADR-045 behaviour).
- A cold volume run completes within the 45-min prepare/audit and 120-min replay timeouts.
- `gate-a.yml` parses; the three jobs each contain exactly one `nscloud-cache-action` step.
