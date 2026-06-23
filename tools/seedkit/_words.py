#!/usr/bin/env python3
"""Number-word table shared across the seedkit generators and writers.

Goal ids use the grammar ``[a-z0-9][a-z0-9-]*`` and, by convention, spell small
integer parameters as English words (``gzmod-156-pow-seven-sub-pow-three``,
``telescoping-cube-sum-coeff-twelve``). Every generator/writer needs the same
``int -> word`` map; keeping the single copy here is the DRY source (ADR/CLAUDE
"DRY") and means a goal id minted by a generator and one minted by its writer
can never disagree on spelling.

``WORDS`` covers ``1..30`` — the widest range any current family enumerates.
Import the slice you need; do not redefine the table locally.
"""
from __future__ import annotations

WORDS: dict[int, str] = {
    1: "one", 2: "two", 3: "three", 4: "four", 5: "five", 6: "six",
    7: "seven", 8: "eight", 9: "nine", 10: "ten", 11: "eleven", 12: "twelve",
    13: "thirteen", 14: "fourteen", 15: "fifteen", 16: "sixteen",
    17: "seventeen", 18: "eighteen", 19: "nineteen", 20: "twenty",
    21: "twentyone", 22: "twentytwo", 23: "twentythree", 24: "twentyfour",
    25: "twentyfive", 26: "twentysix", 27: "twentyseven", 28: "twentyeight",
    29: "twentynine", 30: "thirty",
}
