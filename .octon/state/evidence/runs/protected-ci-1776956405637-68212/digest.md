# ACP Decision Digest (v2)

- Digest Format: `policy-digest-v2`
- Run ID: `protected-ci-1776956405637-68212`
- Timestamp: `2026-04-23T15:00:06Z`
- Decision: `ALLOW`
- Effective ACP: `ACP-1`
- Operation Class: `execution.authorize`
- Phase: `stage`
- Reason Codes: `ACP_EVIDENCE_INVALID`
- Material Side Effect: `true`
- Telemetry Profile: `full`
- Intent Ref: `workspace-charter://octon/octon-governed-harness@1.3.0`
- Boundary ID: `kernel`
- Boundary Set Version: `v1`
- Workflow Mode: `role-mediated`
- Capability Classification: `role-mediated`
- Mission ID: ``
- Slice ID: ``
- Oversight Mode: ``
- Execution Posture: ``
- Reversibility Class: ``
- Instruction Layers: `provider:upstream:partial:0:0000000000000000000000000000000000000000000000000000000000000000,system:octon-system:partial:0:0000000000000000000000000000000000000000000000000000000000000000,developer:AGENTS.md:full:508:e3cfa0970e341b4b0b6720b126a7f78dd71da432731760147987f9486bc9fe7c,user:execution-request:full:3293:599ed83ea9d9c6ed7ce259b73e402b5752f7feb0720944bf91f0b4fe04018a50`
- Rollback Handle: `rollback-protected-ci-1776956405637-68212`
- Compensation Handle: ``
- Recovery Window: `P14D`
- Autonomy Budget State: ``
- Breaker State: ``
- Support Tier: `repo-consequential`
- Ownership Refs: `operator://octon-maintainers`
- Approval Request Ref: `.octon/state/control/execution/approvals/requests/github-pr-automerge-local-representative-17d.yml`
- Approval Grant Refs: `.octon/state/control/execution/approvals/grants/grant-github-pr-automerge-local-representative-17d.yml`
- Exception Refs: ``
- Revocation Refs: ``
- Network Egress Route: ``
- Remediation Summary: Regenerate and attach complete, hash-bound evidence artifacts for this gate.

## Reason Detail
- `ACP_EVIDENCE_INVALID`: Regenerate and attach complete, hash-bound evidence artifacts for this gate.
