# Gate Change Checklist

- [ ] Identified whether the change affects Gate A, Gate B, generated artifacts, provider tests, or PR protocol.
- [ ] Read the ADR/spec referenced by the touched code or workflow.
- [ ] Added or updated a failing test/fixture before changing gate behavior.
- [ ] Preserved Gate A/Gate B authority boundaries.
- [ ] Preserved pinned workflow actions and minimum permissions, or documented why they changed.
- [ ] Ran narrow tests for the touched surface.
- [ ] Ran generated artifact checks where source data changed.
- [ ] Reported skipped expensive checks explicitly.
