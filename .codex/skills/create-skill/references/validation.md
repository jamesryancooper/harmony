---
title: Validation Reference
description: Acceptance checks for the create-skill skill.
---

# Create Skill Validation

## Required Pass Conditions

- New directory exists at `.octon/framework/capabilities/runtime/skills/<group>/<skill_name>/`.
- `SKILL.md` `name` matches `skill_name`.
- `manifest.yml` entry exists and includes `skill_class`.
- `registry.yml` entry exists and contains no `depends_on`.
- Any generated placeholders are standard placeholders or declared parameters only.
- `.octon/framework/capabilities/runtime/skills/_ops/scripts/validate-skills.sh <skill_name>` passes.
- Run log exists and skill-level/top-level log indexes are updated.

## Optional/Conditional Checks

- `composition` exists only when the new skill actually bundles prerequisite or invoke steps.
- `allowed-services` is blank unless the skill composes services.
- Host adapter projections are refreshed with `publish-host-projections.sh`
  after the routing publication is regenerated.

## Failure Reporting

- Report the exact contract field that failed.
- Do not report success when validation is red.
- If the only failure is link refresh, mark the skill artifacts valid but the setup incomplete.
