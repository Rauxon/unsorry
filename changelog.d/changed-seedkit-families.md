The `tools/seedkit` batch generator now produces three further theorem families
besides divisibility — ZMod residue non-membership (sums of two/three squares,
two cubes), telescoping power-sum closed forms, and geometric/Faulhaber closed
forms — each behind a one-line `run_batch_<family>.sh` wrapper sharing the
generator/writer/gate pipeline. Generators and writers are now import-safe (CLI
guarded behind `__main__`), and batch validation builds only the new modules and
their bindings (`lake build Unsorry.<Mod> Unsorry.<Mod>Binding --wfail`) instead
of the whole library, so a batch no longer times out on a cold runner.
