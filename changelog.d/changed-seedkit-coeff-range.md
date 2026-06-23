The seedkit number-word table (`tools/seedkit/_words.py`) now spans 1..60 instead
of 1..30, and the telescoping/Faulhaber generators default to the full table, so
their coefficient/value sweeps can continue past 30 once the lower range is
exhausted by earlier batches. Additive only — existing goal ids are unchanged.
