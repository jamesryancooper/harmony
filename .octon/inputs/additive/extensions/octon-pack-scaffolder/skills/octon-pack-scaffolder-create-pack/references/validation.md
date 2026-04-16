# Validation

Success means:

- the new root matches the v4 extension-pack layout
- `pack.yml` points `compatibility.profile_path` at
  `validation/compatibility.yml`
- the generated fragments parse as valid YAML
- rerunning does not duplicate or reorder matching content
- conflicting content blocks the scaffold
