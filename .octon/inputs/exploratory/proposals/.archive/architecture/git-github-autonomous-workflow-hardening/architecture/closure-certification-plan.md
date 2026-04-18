# Closure Certification Plan

## Closure standard

This packet closes only after a **two-pass hardening proof**.

## Pass 1 — Contract coherence

Required evidence:

- workflow contract exists and is populated
- ingress manifest and ingress `AGENTS.md` stay in parity
- remediation policy surfaces agree
- helper semantics are explicit and non-authoritative
- companion `.github/**` surfaces are aligned

Failure in Pass 1 keeps the packet open even if implementation code exists.

## Pass 2 — Execution realism

Required evidence:

- plain Git + GitHub scenario passes
- Octon helper-lane scenario passes
- ready PR status/suppression scenarios pass
- review-remediation scenario passes without history rewrite
- drift validator passes on the live branch

Failure in Pass 2 reopens the packet even if Pass 1 succeeded.

## Reopen conditions

Reopen the packet if any of the following are observed after nominal
implementation:

- `ready_pr` regresses back to implied rather than explicit behavior
- a doc or helper reintroduces force-push or rebase remediation guidance
- the remediation skill again promises actions it cannot perform
- helper defaults become easier to misuse than the durable policy allows
- workflow validation proves only the helper lane and not the plain Git lane
