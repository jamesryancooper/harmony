# Assurance

Assurance is Octon's legitimacy layer. It formalizes how quality, governance,
and trust combine into enforceable policy and auditable outcomes.

## Purpose

The Assurance subsystem defines and enforces:

- standards and measurable quality attributes
- policy precedence and override governance
- gate execution for local and CI enforcement
- auditability through evidence, attestations, and logs

Quality remains a measured dimension. Assurance is the system that governs and
proves legitimacy.

## Bounded Surfaces

Assurance follows bounded surfaces with three canonical authorities:

- `runtime/` - executable assurance engine entrypoints and trust artifact
  runtime surfaces.
- `governance/` - normative assurance contracts, policy weights/scores, and
  override governance.
- `practices/` - operating checklists and assurance standards for human/agent
  execution discipline.

## Proof Planes

Wave 4 keeps the existing structural and governance gates intact and adds new
first-class proof planes:

- `structural/` - blocking topology and placement proof
- `functional/` - deterministic run-behavior proof
- `behavioral/` - replay, scenario, and lab-backed behavior proof
- `maintainability/` - architecture-health and change-safety proof
- `governance/` - policy, weighting, and override proof
- `recovery/` - checkpoint, replay, rollback, and resumability proof
- `evaluators/` - independent review where deterministic proof is insufficient

The lab and observability domains feed assurance, but they do not replace it:

- `/.octon/framework/lab/**` authors scenario and replay contracts
- `/.octon/framework/observability/**` authors measurement and intervention contracts

## Convention Authority

- Domain-local naming, authoring, and operating conventions belong in `practices/`.
- `_meta/architecture/` is reference architecture, not the canonical conventions surface.
- Cross-domain baseline conventions come from `/.octon/instance/bootstrap/conventions.md`.

## Enforcement Engine

The local resolver and gate tooling is the authoritative assurance engine:

- policy source: `governance/weights/weights.yml`
- measurement source: `governance/scores/scores.yml`
- governance controls: `governance/*`
- execution entrypoints:
  `runtime/_ops/scripts/compute-assurance-score.sh` and
  `runtime/_ops/scripts/assurance-gate.sh`
- retained evidence: `.octon/state/evidence/validation/assurance/`
- ephemeral rebuild intermediates: `.octon/generated/.tmp/assurance/`

## Charter-Driven Flow

1. `governance/CHARTER.md` defines priority and trade-off intent.
2. `governance/weights/weights.yml` defines policy weights.
3. `governance/scores/scores.yml` defines measured subsystem scores.
4. `runtime/_ops/scripts/compute-assurance-score.sh` resolves effective policy.
5. `runtime/_ops/scripts/assurance-gate.sh` enforces gates and drift checks.
6. Retained assurance outputs are written under
   `.octon/state/evidence/validation/assurance/`, with temporary rebuild
   intermediates under `.octon/generated/.tmp/assurance/`.

Active umbrella chain:

`Assurance > Productivity > Integration`

Breaking-change note:

The legacy chain (`Trust > Speed of development > Ease of use > Portability >
Interoperability`) is no longer supported.

## Contents

| Path | Purpose |
|---|---|
| `runtime/` | Runtime assurance execution surfaces and trust artifacts |
| `structural/` | Structural proof-plane docs and blocking gate definition |
| `functional/` | Functional proof-plane guidance and canonical retained outputs |
| `behavioral/` | Behavioral proof-plane guidance and lab/replay evidence contract |
| `maintainability/` | Maintainability and architecture-health proof guidance |
| `runtime/_ops/scripts/` | Assurance engine and alignment validator entrypoints |
| `runtime/trust/` | Attestations, evidence, and audit artifact surfaces |
| `governance/` | Charter, doctrine, changelog, precedence, and override contracts |
| `recovery/` | Recovery proof-plane guidance for checkpoints and rollback proof |
| `evaluators/` | Independent evaluator review guidance |
| `governance/weights/` | Policy weights and context contract |
| `governance/scores/` | Measured score inputs and evidence mapping |
| `governance/precedence.md` | Canonical precedence and merge-order contract |
| `practices/` | Completion/exit gates and operating standards |
| `practices/complete.md` | Definition of done checklist |
| `practices/session-exit.md` | Session exit checklist |

## Contract

- Read `practices/complete.md` before marking work complete.
- Read `practices/session-exit.md` before ending session or handoff.
- Treat Assurance artifacts as contract surfaces, not optional guidance.
