# Octon Drift Triage Remediation Packet

This bundle turns changed paths, diff refs, or an existing triage packet into a
ranked remediation package for Octon maintainers.

## Flow

1. `stages/01-normalize-inputs.md`
2. `stages/02-select-checks.md`
3. `stages/03-run-and-distill.md`
4. `stages/04-build-packet.md`

## Companion

- `companions/01-align-bundle.md`

## Shared Contracts

- `../shared/repository-grounding.md`
- `../shared/alignment-mode-contract.md`
- `../shared/packet-contract.md`

## Output Bias

The bundle stops at non-authoritative triage and packetization. It does not
apply changes, publish outputs, or write to build-to-delete evidence roots.
