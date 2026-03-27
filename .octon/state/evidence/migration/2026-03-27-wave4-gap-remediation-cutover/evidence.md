# Wave 4 Remediation Evidence

This bundle captures the second-pass remediation that closes the remaining
Wave 4 gaps.

Wave 4 is complete after this remediation bundle. The promoted Wave 4 state
now satisfies the scoped Wave 4 exit gate:

- consequential runs can emit RunCards
- support and benchmark claims can emit HarnessCards
- behavioral claims require explicit lab or replay evidence
- structural conformance is no longer the only blocking proof plane

Key proof points:

- maintainability is now a first-class retained proof plane and appears in
  RunCards
- evaluator routing is explicit and benchmark disclosure has approved retained
  evaluator review
- a second canonical benchmark run demonstrates the richer Wave 4 path
- Wave 4 backfill now exists for already-bound canonical run roots without
  fabricating authority for historical evidence-only directories
