# Instance Governance Contract Overlays

This directory contains the repo-owned governance overlays that complete the
final execution constitution model for this repository.

## Canonical Overlays

- `retirement-policy.yml`: build-to-delete retirement governance for transitional
  helpers, legacy authority families, and placeholder overlays
- `closeout-reviews.yml`: release-closeout review obligations for drift,
  support-target posture, adapter posture, and deletion readiness
- `disclosure-retention.yml`: repo-owned disclosure and replay retention
  posture for release-grade claims

These overlays remain subordinate to `framework/constitution/**`, but they are
the repo-local contract surfaces that make retirement and closeout enforceable
instead of merely advisory.
