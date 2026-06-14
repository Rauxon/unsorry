# Triviality retro-audit (ADR-035, report-only)

Probed **143** goals against the one-shot tactic battery at mathlib `c5ea00351c28e24afc9f0f84379aa41082b1188f`. **Report-only** — nothing is deleted; a `trivial` verdict means a single battery tactic closes the statement (so it is one-shot-provable or already in mathlib under another name) and is flagged for human review (ADR-035).

| verdict | count |
|---|---|
| trivial | 18 |
| probe-error | 0 |
| allowlisted | 0 |
| override | 0 |
| non-trivial | 125 |

## Flagged trivial (review)

| goal | closed by |
|---|---|
| `fourth-power-mod-five-s2` | `trivial` |
| `int-add-neg` | `norm_num` |
| `int-neg-neg` | `norm_num` |
| `list-reverse-reverse` | `norm_num` |
| `nat-add-left-cancel` | `norm_num` |
| `nat-add-zero-thm` | `norm_num` |
| `nat-dvd-refl` | `norm_num` |
| `nat-le-add-right` | `norm_num` |
| `nat-le-succ` | `norm_num` |
| `nat-mul-one-thm` | `norm_num` |
| `nat-mul-zero-thm` | `norm_num` |
| `nat-sq-lt-two-pow-s1` | `trivial` |
| `nat-sq-lt-two-pow-s2-s2` | `norm_num` |
| `nat-zero-le` | `norm_num` |
| `platonic-schlafli-core-s1-s1` | `norm_num` |
| `platonic-schlafli-core-s1-s1-s1` | `norm_num` |
| `platonic-schlafli-core-s1-s1-s2` | `rfl` |
| `platonic-schlafli-core-s1-s3` | `norm_num` |
