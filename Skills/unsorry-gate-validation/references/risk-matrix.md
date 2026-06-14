# Validation Risk Matrix

| Touched path | Risk | Minimum checks |
|---|---|---|
| `library/**` | Proof admission | `lake build UnsorryLibrary --wfail`; Gate A checks |
| `goals/**/*.lean` | Statement binding and goal build | `lake build UnsorryGoals`; goal immutability check in PR context |
| `goals/*.aisp` | Queue consistency | `python3 -m tools.gate_b validate .`; targets board check |
| `library/index/*.aisp` | Proved-goal linkage and stats | Gate B; leaderboard check; targets board check |
| `proof-runs/*.aisp` | Telemetry | Gate B; leaderboard check; visualiser check |
| `decompositions/*.aisp` | Dependency lineage | Gate B; visualiser check |
| `tools/gate_a/**` | Trust boundary | relevant unit tests; Gate A local equivalents; audit self-test |
| `tools/gate_b/**` | Queue hygiene | `pytest tools/gate_b -q`; Gate B validate |
| `.github/workflows/**` | CI enforcement | inspect permissions/pins; run closest local equivalents |
| `tools/leaderboard/**` | Generated metrics | generator unit tests if present; `--check`/`--write` comparison |
| `tools/sourcing/**` | Targets and absence pipeline | targets board check; sourcing tests |
| `tools/llm_providers/**` | Agent provider behavior | `pytest tools/llm_providers -q`; agent self-test when applicable |

For mixed changes, union the checks. If a check is too expensive locally, state that explicitly in the final report.
