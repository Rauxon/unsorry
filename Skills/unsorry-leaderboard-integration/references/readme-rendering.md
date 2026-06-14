# README Leaderboard Rendering

GitHub README markdown cannot execute JavaScript, so the interactive HTML page cannot be embedded directly.

## Option 1: Link Only

Link README to:

- `docs/leaderboard.md`
- `docs/leaderboard.html`

Lowest risk and no new dependencies.

## Option 2: Generated SVG

Generate `docs/leaderboard.svg` from the same UI JSON or core stats.

Pros:

- can be pure Python;
- deterministic;
- easy to embed and link.

Cons:

- less visually rich than HTML;
- external avatar images inside SVG may be fragile;
- GitHub sanitization can restrict advanced SVG.

Recommended SVG content: top five contributors, rank, handle, proof count, difficulty points, and score.

## Option 3: Generated PNG

Use a headless browser to screenshot `docs/leaderboard.html`.

Pros:

- closest to the HTML design;
- supports avatars and full styling.

Cons:

- adds browser tooling and CI runtime;
- can be flaky if fonts or avatars load from the network;
- requires screenshot-specific tests or pixel sanity checks.

## Recommendation

Ship data-backed HTML first. Add SVG as the first README preview if needed. Use PNG only if the project accepts a headless-browser dependency.
