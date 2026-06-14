"""Generate community proof statistics and leaderboard views.

Usage:
  python3 -m tools.leaderboard [<repo-root>]
  python3 -m tools.leaderboard --json [<repo-root>]
  python3 -m tools.leaderboard --write [<repo-root>]
  python3 -m tools.leaderboard --check [<repo-root>]
"""
from __future__ import annotations

import json
import math
import statistics
import sys
from collections import Counter, defaultdict
from dataclasses import asdict, dataclass
from html import escape as html_escape
from pathlib import Path

from tools.gate_b.records import parse_record


SCORE_POLICY = (
    "rank by verified_proofs desc, difficulty_points desc; "
    "score = difficulty_points * 100 + verified_proofs * 25"
)


@dataclass(frozen=True)
class Goal:
    id: str
    status: str
    difficulty: int


@dataclass(frozen=True)
class Proof:
    goal: str
    date: str
    solver: str | None
    agent: str | None
    provider: str | None
    model: str | None
    effort: str | None
    attempts: int | None
    solve_s: int | None
    difficulty: int


@dataclass(frozen=True)
class Run:
    id: str
    goal: str
    ended: str
    outcome: str
    solver: str
    agent: str
    provider: str
    model: str | None
    effort: str | None
    attempts: int
    solve_s: int
    difficulty: int

    @property
    def succeeded(self) -> bool:
        return self.outcome == "proved"

    @property
    def failed_attempts(self) -> int:
        return self.attempts - 1 if self.succeeded else self.attempts


@dataclass(frozen=True)
class Dataset:
    goals: list[Goal]
    proofs: list[Proof]
    runs: list[Run]


def _optional(value: str | None) -> str | None:
    return None if not value or value == "∅" else value


def _integer(value: str | None) -> int | None:
    return int(value) if value and value.isdigit() else None


def goals(root: Path) -> list[Goal]:
    result = []
    for path in sorted((root / "goals").glob("*.aisp")):
        record = parse_record(path.read_text(encoding="utf-8"))
        raw = record.fields.get("difficulty", "0")
        result.append(
            Goal(
                id=path.stem,
                status=record.fields.get("status", "unknown"),
                difficulty=int(raw) if raw.isdigit() else 0,
            )
        )
    return result


def proofs(root: Path, known_goals: list[Goal] | None = None) -> list[Proof]:
    known_goals = goals(root) if known_goals is None else known_goals
    difficulty = {goal.id: goal.difficulty for goal in known_goals}
    result = []
    for path in sorted((root / "library" / "index").glob("*.aisp")):
        record = parse_record(path.read_text(encoding="utf-8"))
        goal = record.fields.get("goal", path.stem)
        result.append(
            Proof(
                goal=goal,
                date=record.header.date if record.header else "",
                solver=_optional(record.fields.get("solver")),
                agent=_optional(record.fields.get("agent")),
                provider=_optional(record.fields.get("provider")),
                model=_optional(record.fields.get("model")),
                effort=_optional(record.fields.get("effort")),
                attempts=_integer(record.fields.get("attempts")),
                solve_s=_integer(record.fields.get("solve_s")),
                difficulty=difficulty.get(goal, 0),
            )
        )
    return result


def runs(root: Path, known_goals: list[Goal] | None = None) -> list[Run]:
    known_goals = goals(root) if known_goals is None else known_goals
    difficulty = {goal.id: goal.difficulty for goal in known_goals}
    result = []
    for path in sorted((root / "proof-runs").glob("*.aisp")):
        record = parse_record(path.read_text(encoding="utf-8"))
        attempts = _integer(record.fields.get("attempts"))
        solve_s = _integer(record.fields.get("solve_s"))
        if attempts is None or solve_s is None:
            continue
        goal = record.fields.get("goal", "")
        result.append(
            Run(
                id=record.fields.get("id", path.stem),
                goal=goal,
                ended=record.fields.get("ended", ""),
                outcome=record.fields.get("outcome", "unknown"),
                solver=record.fields.get("solver", "unknown"),
                agent=record.fields.get("agent", "unknown"),
                provider=record.fields.get("provider", "unknown"),
                model=_optional(record.fields.get("model")),
                effort=_optional(record.fields.get("effort")),
                attempts=attempts,
                solve_s=solve_s,
                difficulty=difficulty.get(goal, 0),
            )
        )
    return result


def load_dataset(root: Path) -> Dataset:
    goal_data = goals(root)
    return Dataset(goal_data, proofs(root, goal_data), runs(root, goal_data))


def _rate(numerator: int, denominator: int) -> float | None:
    return round(numerator / denominator, 4) if denominator else None


def _median(values: list[int]) -> int | None:
    return int(statistics.median(values)) if values else None


def _p90(values: list[int]) -> int | None:
    if not values:
        return None
    ordered = sorted(values)
    return ordered[max(0, math.ceil(0.9 * len(ordered)) - 1)]


def _group_stats(items: list[Run]) -> dict[str, int | float | None]:
    successes = sum(item.succeeded for item in items)
    attempts = sum(item.attempts for item in items)
    seconds = sum(item.solve_s for item in items)
    return {
        "runs": len(items),
        "successes": successes,
        "failures": len(items) - successes,
        "run_success_rate": _rate(successes, len(items)),
        "attempts": attempts,
        "failed_attempts": sum(item.failed_attempts for item in items),
        "attempt_yield": _rate(successes, attempts),
        "total_solve_s": seconds,
        "median_solve_s": _median([item.solve_s for item in items]),
        "p90_solve_s": _p90([item.solve_s for item in items]),
        "successes_per_recorded_hour": (
            round(successes * 3600 / seconds, 3) if seconds else None
        ),
    }


def base_stats(root: Path) -> dict:
    data = load_dataset(root)
    attributed = [
        proof for proof in data.proofs if proof.solver and proof.provider
    ]
    successful_run_goals = {run.goal for run in data.runs if run.succeeded}
    queue = Counter(goal.status for goal in data.goals)

    contributor_runs: dict[str, list[Run]] = defaultdict(list)
    contributor_proofs: dict[str, list[Proof]] = defaultdict(list)
    model_runs: dict[str, list[Run]] = defaultdict(list)
    model_proofs: dict[str, list[Proof]] = defaultdict(list)
    difficulty_runs: dict[int, list[Run]] = defaultdict(list)
    effort_runs: dict[str, list[Run]] = defaultdict(list)
    daily_runs: dict[str, list[Run]] = defaultdict(list)
    goal_runs: dict[str, list[Run]] = defaultdict(list)
    for run in data.runs:
        contributor_runs[run.solver].append(run)
        model_runs[f"{run.provider} / {run.model or 'unknown'}"].append(run)
        difficulty_runs[run.difficulty].append(run)
        effort_runs[run.effort or "unknown"].append(run)
        daily_runs[run.ended[:10] or "unknown"].append(run)
        goal_runs[run.goal].append(run)
    for proof in attributed:
        assert proof.solver and proof.provider
        contributor_proofs[proof.solver].append(proof)
        model_proofs[f"{proof.provider} / {proof.model or 'unknown'}"].append(proof)

    contributors = []
    for solver in sorted(set(contributor_runs) | set(contributor_proofs)):
        run_stats = _group_stats(contributor_runs[solver])
        proof_items = contributor_proofs[solver]
        contributors.append(
            {
                "solver": solver,
                "verified_proofs": len(proof_items),
                "difficulty_points": sum(item.difficulty for item in proof_items),
                **run_stats,
            }
        )
    contributors.sort(
        key=lambda row: (
            -int(row["verified_proofs"]),
            -int(row["difficulty_points"]),
            str(row["solver"]).lower(),
        )
    )

    models = []
    for label in sorted(set(model_runs) | set(model_proofs)):
        run_items = model_runs[label]
        proof_items = model_proofs[label]
        models.append(
            {
                "provider_model": label,
                "verified_proofs": len(proof_items),
                "solvers": len(
                    {item.solver for item in run_items}
                    | {item.solver for item in proof_items if item.solver}
                ),
                **_group_stats(run_items),
            }
        )
    models.sort(
        key=lambda row: (-int(row["verified_proofs"]), -int(row["runs"]), str(row["provider_model"]))
    )

    difficulty = [
        {"difficulty": level, **_group_stats(items)}
        for level, items in sorted(difficulty_runs.items())
    ]
    effort = [
        {"effort": level, **_group_stats(items)}
        for level, items in sorted(effort_runs.items())
    ]
    daily = [
        {"date": date, **_group_stats(items)}
        for date, items in sorted(daily_runs.items())
    ]
    goal_state = {goal.id: goal.status for goal in data.goals}
    goal_effort = [
        {
            "goal": goal,
            "status": goal_state.get(goal, "unknown"),
            "difficulty": items[0].difficulty,
            **_group_stats(items),
        }
        for goal, items in goal_runs.items()
    ]
    goal_effort.sort(
        key=lambda row: (
            -int(row["failed_attempts"]),
            -int(row["total_solve_s"]),
            str(row["goal"]),
        )
    )
    return {
        "schema_version": 1,
        "coverage": {
            "verified_proofs": len(data.proofs),
            "attributed_proofs": len(attributed),
            "historical_unknown_proofs": len(data.proofs) - len(attributed),
            "terminal_runs": len(data.runs),
            "successful_proofs_with_run_telemetry": len(successful_run_goals),
            "proof_run_coverage": _rate(len(successful_run_goals), len(data.proofs)),
        },
        "outcomes": _group_stats(data.runs),
        "outcome_counts": dict(sorted(Counter(run.outcome for run in data.runs).items())),
        "queue": {
            "goals": len(data.goals),
            "status_counts": dict(sorted(queue.items())),
            "difficulty_counts": dict(
                sorted(Counter(goal.difficulty for goal in data.goals).items())
            ),
        },
        "contributors": contributors,
        "models": models,
        "difficulty": difficulty,
        "effort": effort,
        "daily": daily,
        "goal_effort": goal_effort,
        "recent_runs": [
            asdict(run)
            for run in sorted(data.runs, key=lambda item: (item.ended, item.id), reverse=True)[:20]
        ],
    }


def _duration(seconds: int | None) -> str:
    if seconds is None:
        return "—"
    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    if hours:
        return f"{hours}h {minutes}m"
    if minutes:
        return f"{minutes}m {seconds}s"
    return f"{seconds}s"


def _percent(value: float | None) -> str:
    return "—" if value is None else f"{100 * value:.1f}%"


def _number(value: float | None) -> str:
    return "—" if value is None else f"{value:.2f}"


def render(root: Path) -> str:
    data = load_dataset(root)
    stats = base_stats(root)
    coverage = stats["coverage"]
    outcomes = stats["outcomes"]
    queue = stats["queue"]
    status_text = " · ".join(
        f"{count} {status}" for status, count in queue["status_counts"].items()
    )

    lines = [
        "# Community Proof Statistics",
        "",
        "<!-- generated by tools/leaderboard/generate.py — do not edit by hand -->",
        "",
        "Verified output comes from `library/index`; append-only terminal-run telemetry "
        "comes from `proof-runs/`. Rates cover only logged runs and never guess historical "
        "failures from Git history. Timing is contributor-reported local proof plus verification time.",
        "",
        f"**{coverage['verified_proofs']} verified proofs · "
        f"{coverage['attributed_proofs']} attributed · "
        f"{coverage['historical_unknown_proofs']} historical/unknown · "
        f"{coverage['terminal_runs']} logged terminal runs.**",
        "",
        "## Efficiency Baseline",
        "",
        "| Metric | Value |",
        "|--------|------:|",
        f"| Successful terminal runs | {outcomes['successes']} |",
        f"| Failed terminal runs | {outcomes['failures']} |",
        f"| Decomposed after failure | {stats['outcome_counts'].get('decomposed', 0)} |",
        f"| Failed without decomposition | {stats['outcome_counts'].get('failed', 0)} |",
        f"| Run success rate | {_percent(outcomes['run_success_rate'])} |",
        f"| Provider attempts | {outcomes['attempts']} |",
        f"| Failed attempts | {outcomes['failed_attempts']} |",
        f"| Attempt yield | {_percent(outcomes['attempt_yield'])} |",
        f"| Recorded run time | {_duration(outcomes['total_solve_s'])} |",
        f"| Median / p90 run time | {_duration(outcomes['median_solve_s'])} / "
        f"{_duration(outcomes['p90_solve_s'])} |",
        f"| Verified successes per recorded hour | "
        f"{_number(outcomes['successes_per_recorded_hour'])} |",
        f"| Proofs with run telemetry | "
        f"{coverage['successful_proofs_with_run_telemetry']} "
        f"({_percent(coverage['proof_run_coverage'])}) |",
        "",
        "## Work Queue",
        "",
        f"**{queue['goals']} goals · {status_text or 'no status data'}.**",
        "",
        "## Efficiency by Difficulty",
        "",
        "| Difficulty | Runs | Successes | Run success | Failed attempts | Median time |",
        "|-----------:|-----:|----------:|------------:|----------------:|------------:|",
    ]
    if not stats["difficulty"]:
        lines.append("| — | No logged runs yet | — | — | — | — |")
    for row in stats["difficulty"]:
        lines.append(
            f"| {row['difficulty']} | {row['runs']} | {row['successes']} | "
            f"{_percent(row['run_success_rate'])} | {row['failed_attempts']} | "
            f"{_duration(row['median_solve_s'])} |"
        )

    unresolved = [
        row for row in stats["goal_effort"] if row["status"] != "proved"
    ][:10]
    lines.extend([
        "",
        "## Unresolved Effort",
        "",
        "| Goal | Status | Difficulty | Runs | Failed attempts | Recorded time |",
        "|------|--------|-----------:|-----:|----------------:|--------------:|",
    ])
    if not unresolved:
        lines.append("| No logged unresolved effort yet | — | — | — | — | — |")
    for row in unresolved:
        lines.append(
            f"| `{row['goal']}` | `{row['status']}` | {row['difficulty']} | "
            f"{row['runs']} | {row['failed_attempts']} | "
            f"{_duration(row['total_solve_s'])} |"
        )

    lines.extend([
        "",
        "## Contributors",
        "",
        "| Rank | GitHub solver | Verified proofs | Runs | Run success | Failed attempts | Difficulty points | Median time |",
        "|-----:|---------------|----------------:|-----:|------------:|----------------:|------------------:|------------:|",
    ])
    if not stats["contributors"]:
        lines.append("| — | No attributed work yet | — | — | — | — | — | — |")
    for rank, row in enumerate(stats["contributors"], 1):
        lines.append(
            f"| {rank} | [@{row['solver']}](https://github.com/{row['solver']}) | "
            f"{row['verified_proofs']} | {row['runs']} | "
            f"{_percent(row['run_success_rate'])} | {row['failed_attempts']} | "
            f"{row['difficulty_points']} | {_duration(row['median_solve_s'])} |"
        )

    lines.extend([
        "",
        "## Providers and Models",
        "",
        "| Provider / model | Verified proofs | Runs | Run success | Failed attempts | Solvers | Median time | Successes / recorded hour |",
        "|------------------|----------------:|-----:|------------:|----------------:|--------:|------------:|-------------------------:|",
    ])
    if not stats["models"]:
        lines.append("| No attributed work yet | — | — | — | — | — | — | — |")
    for row in stats["models"]:
        lines.append(
            f"| `{row['provider_model']}` | {row['verified_proofs']} | {row['runs']} | "
            f"{_percent(row['run_success_rate'])} | {row['failed_attempts']} | "
            f"{row['solvers']} | {_duration(row['median_solve_s'])} | "
            f"{_number(row['successes_per_recorded_hour'])} |"
        )

    lines.extend([
        "",
        "## Recent Terminal Runs",
        "",
        "| Ended (UTC) | Goal | Solver | Provider / model | Outcome | Attempts | Failed attempts | Time |",
        "|-------------|------|--------|------------------|---------|---------:|----------------:|-----:|",
    ])
    if not data.runs:
        lines.append("| No logged runs yet | — | — | — | — | — | — | — |")
    for run in sorted(data.runs, key=lambda item: (item.ended, item.id), reverse=True)[:20]:
        lines.append(
            f"| `{run.ended}` | `{run.goal}` | "
            f"[@{run.solver}](https://github.com/{run.solver}) | "
            f"`{run.provider} / {run.model or 'unknown'}` | `{run.outcome}` | "
            f"{run.attempts} | {run.failed_attempts} | {_duration(run.solve_s)} |"
        )

    lines.extend([
        "",
        "## Interpretation",
        "",
        "- Leaderboard rank is based on verified proofs, then difficulty points; failures are credited as effort but do not improve rank.",
        "- Run and attempt rates are descriptive, not causal model comparisons. Stratify by difficulty and wait for useful sample sizes.",
        "- Infrastructure failures are excluded because they provide no evidence about mathematical or model performance.",
        "- Historical proofs and failed attempts before this telemetry existed remain unknown rather than reconstructed.",
        "",
    ])
    return "\n".join(lines)


def render_json(root: Path) -> str:
    return json.dumps(base_stats(root), ensure_ascii=False, indent=2, sort_keys=True) + "\n"


def _score(row: dict) -> int:
    return int(row["difficulty_points"]) * 100 + int(row["verified_proofs"]) * 25


def _success_rate_percent(value: float | None) -> float | None:
    return None if value is None else round(value * 100, 2)


def ui_payload(root: Path) -> dict:
    stats = base_stats(root)
    coverage = stats["coverage"]
    contributors = []
    for rank, row in enumerate(stats["contributors"], 1):
        solver = str(row["solver"])
        contributors.append(
            {
                "rank": rank,
                "solver": solver,
                "display_name": f"@{solver}",
                "profile_url": f"https://github.com/{solver}",
                "avatar_url": f"https://github.com/{solver}.png?size=96",
                "score": _score(row),
                "verified_proofs": row["verified_proofs"],
                "difficulty_points": row["difficulty_points"],
                "runs": row["runs"],
                "successes": row["successes"],
                "run_success_rate": row["run_success_rate"],
                "attempt_yield": row["attempt_yield"],
                "failed_attempts": row["failed_attempts"],
                "median_solve_s": row["median_solve_s"],
                "badges": {
                    "proofs": row["verified_proofs"],
                    "difficulty": row["difficulty_points"],
                    "success_rate_percent": _success_rate_percent(row["run_success_rate"]),
                },
            }
        )
    return {
        "schema_version": 1,
        "generated_from": "docs/metrics/community-stats.json",
        # Deterministic by design: this is the latest recorded terminal-run
        # timestamp, not wall-clock generation time.
        "generated_at": (
            stats["recent_runs"][0]["ended"] if stats["recent_runs"] else None
        ),
        "score_policy": SCORE_POLICY,
        "summary": {
            "verified_proofs": coverage["verified_proofs"],
            "attributed_proofs": coverage["attributed_proofs"],
            "historical_unknown_proofs": coverage["historical_unknown_proofs"],
            "terminal_runs": coverage["terminal_runs"],
            "proof_run_coverage": coverage["proof_run_coverage"],
        },
        "contributors": contributors,
    }


def render_ui_json(root: Path) -> str:
    return json.dumps(ui_payload(root), ensure_ascii=False, indent=2, sort_keys=True) + "\n"


def render_svg(root: Path) -> str:
    payload = ui_payload(root)
    contributors = payload["contributors"][:5]
    width = 900
    row_h = 62
    top = 104
    height = top + max(1, len(contributors)) * row_h + 42
    max_score = max([int(row["score"]) for row in contributors] + [100])
    summary = payload["summary"]
    lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}" role="img" aria-labelledby="title desc">',
        "<title id=\"title\">Unsorry leaderboard</title>",
        "<desc id=\"desc\">Top verified Unsorry contributors ranked by proof count and difficulty points.</desc>",
        "<rect width=\"900\" height=\"100%\" rx=\"18\" fill=\"#ffffff\"/>",
        "<rect x=\"0.5\" y=\"0.5\" width=\"899\" height=\"{h}\" rx=\"18\" fill=\"none\" stroke=\"#e2e8f0\"/>".format(h=height - 1),
        "<text x=\"32\" y=\"44\" font-family=\"Inter, system-ui, sans-serif\" font-size=\"28\" font-weight=\"700\" fill=\"#334155\">Unsorry Leaderboard</text>",
        (
            "<text x=\"32\" y=\"72\" font-family=\"Inter, system-ui, sans-serif\" "
            "font-size=\"13\" fill=\"#64748b\">"
            f"{summary['verified_proofs']} verified proofs · "
            f"{summary['attributed_proofs']} attributed · "
            f"{summary['terminal_runs']} terminal runs"
            "</text>"
        ),
    ]
    if not contributors:
        lines.extend([
            "<rect x=\"32\" y=\"104\" width=\"836\" height=\"58\" rx=\"10\" fill=\"#f8fafc\" stroke=\"#cbd5e1\" stroke-dasharray=\"4 4\"/>",
            "<text x=\"56\" y=\"140\" font-family=\"Inter, system-ui, sans-serif\" font-size=\"16\" fill=\"#64748b\">No attributed proofs yet.</text>",
        ])
    for index, row in enumerate(contributors):
        y = top + index * row_h
        bar_w = max(6, int(390 * int(row["score"]) / max_score))
        rank_color = "#fbbf24" if row["rank"] == 1 else "#94a3b8" if row["rank"] == 2 else "#b45309" if row["rank"] == 3 else "#cbd5e1"
        solver = html_escape(str(row["display_name"]))
        profile = html_escape(str(row["profile_url"]))
        lines.extend([
            f"<text x=\"34\" y=\"{y + 36}\" font-family=\"Georgia, serif\" font-size=\"24\" font-style=\"italic\" font-weight=\"700\" fill=\"{rank_color}\">{row['rank']}</text>",
            f"<a href=\"{profile}\">",
            f"<text x=\"82\" y=\"{y + 28}\" font-family=\"Inter, system-ui, sans-serif\" font-size=\"17\" font-weight=\"650\" fill=\"#334155\">{solver}</text>",
            "</a>",
            (
                f"<text x=\"82\" y=\"{y + 48}\" font-family=\"Inter, system-ui, sans-serif\" "
                f"font-size=\"12\" fill=\"#64748b\">{row['verified_proofs']} proofs · "
                f"{row['difficulty_points']} difficulty · {row['runs']} runs</text>"
            ),
            f"<rect x=\"320\" y=\"{y + 15}\" width=\"420\" height=\"26\" rx=\"13\" fill=\"#f1f5f9\"/>",
            f"<rect x=\"320\" y=\"{y + 15}\" width=\"{bar_w}\" height=\"26\" rx=\"13\" fill=\"#e0f2fe\"/>",
            f"<text x=\"760\" y=\"{y + 34}\" font-family=\"Inter, system-ui, sans-serif\" font-size=\"14\" font-weight=\"700\" fill=\"#334155\">{row['score']} pts</text>",
        ])
    lines.append("</svg>")
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    argv = sys.argv[1:] if argv is None else argv
    modes = [flag for flag in ("--check", "--write", "--json") if flag in argv]
    if len(modes) > 1:
        print("--check, --write, and --json are mutually exclusive", file=sys.stderr)
        return 2
    mode = modes[0] if modes else ""
    rest = [arg for arg in argv if arg not in ("--check", "--write", "--json")]
    root = Path(rest[0]) if rest else Path.cwd()
    markdown = render(root)
    payload = render_json(root)
    ui_payload_json = render_ui_json(root)
    svg = render_svg(root)
    markdown_path = root / "docs" / "leaderboard.md"
    json_path = root / "docs" / "metrics" / "community-stats.json"
    ui_json_path = root / "docs" / "metrics" / "leaderboard-ui.json"
    svg_path = root / "docs" / "leaderboard.svg"
    if mode == "--check":
        stale = []
        if not markdown_path.is_file() or markdown_path.read_text(encoding="utf-8") != markdown:
            stale.append(markdown_path.relative_to(root).as_posix())
        if not json_path.is_file() or json_path.read_text(encoding="utf-8") != payload:
            stale.append(json_path.relative_to(root).as_posix())
        if not ui_json_path.is_file() or ui_json_path.read_text(encoding="utf-8") != ui_payload_json:
            stale.append(ui_json_path.relative_to(root).as_posix())
        if not svg_path.is_file() or svg_path.read_text(encoding="utf-8") != svg:
            stale.append(svg_path.relative_to(root).as_posix())
        if stale:
            print(
                f"{', '.join(stale)} stale — regenerate with "
                "`python3 -m tools.leaderboard --write`",
                file=sys.stderr,
            )
            return 1
        return 0
    if mode == "--write":
        markdown_path.parent.mkdir(parents=True, exist_ok=True)
        json_path.parent.mkdir(parents=True, exist_ok=True)
        markdown_path.write_text(markdown, encoding="utf-8")
        json_path.write_text(payload, encoding="utf-8")
        ui_json_path.write_text(ui_payload_json, encoding="utf-8")
        svg_path.write_text(svg, encoding="utf-8")
        return 0
    sys.stdout.write(payload if mode == "--json" else markdown)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
