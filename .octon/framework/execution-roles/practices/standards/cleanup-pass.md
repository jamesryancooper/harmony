# Cleanup Pass

## Purpose

Require AI-assisted implementation to inspect what it added, simplified, or
made obsolete while preserving repo-hygiene deletion safety.

## Required Questions

After implementation, ask:

- What was added but is not necessary?
- What duplicates an existing helper, contract, policy, validator, workflow, or
  generated output?
- What can be simplified without changing behavior?
- What deletion would require ablation evidence?
- What must be retained with rationale?
- What belongs in the retirement register or a future build-to-delete review?

## Deletion Safety

Deletion must obey `.octon/instance/governance/policies/repo-hygiene.yml`.
Detection never authorizes deletion by itself. Ambiguous findings route to
non-destructive retention, registration, or escalation.

## Receipt

Record:

- cleanup scope reviewed;
- simplifications made;
- deletion candidates and routing;
- retained surfaces with rationale;
- ablation or retirement-register requirements;
- remaining cleanup risk or `none`.
