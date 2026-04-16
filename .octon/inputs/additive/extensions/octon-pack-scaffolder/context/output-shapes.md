# Output Shapes

This document is the source of truth for the MVP scaffold outputs created by
`octon-pack-scaffolder`.

## Global Rules

- All writes stay under `/.octon/inputs/additive/extensions/<pack-id>/`.
- Create missing files and directories only.
- Preserve matching existing content.
- Fail closed on conflicting existing content.
- Keep new manifest and registry entries in lexical id order.

## Create Pack

Creates this baseline tree:

```text
<pack-id>/
  pack.yml
  README.md
  commands/
    manifest.fragment.yml
  skills/
    manifest.fragment.yml
    registry.fragment.yml
  context/
    overview.md
  validation/
    compatibility.yml
    scenarios/
    tests/
  templates/
  prompts/
```

`pack.yml` baseline:

```yaml
schema_version: "octon-extension-pack-v4"
pack_id: "<pack-id>"
version: "0.1.0"
origin_class: "first_party_bundled"
compatibility:
  octon_version: "^0.6.25"
  extensions_api_version: "1.0"
  required_contracts: []
  profile_path: "validation/compatibility.yml"
dependencies:
  requires: []
  conflicts: []
provenance:
  source_id: "bundled-first-party"
  imported_from: null
  origin_uri: null
  digest_sha256: null
  attestation_refs: []
trust_hints:
  suggested_action: "allow"
content_entrypoints:
  skills: "skills/"
  commands: "commands/"
  templates: null
  prompts: null
  context: "context/"
  validation: "validation/"
```

`commands/manifest.fragment.yml` baseline:

```yaml
schema_version: "extensions-commands-fragment-v1"
commands: []
```

`skills/manifest.fragment.yml` baseline:

```yaml
schema_version: "extensions-skills-fragment-v1"
skills: []
```

`skills/registry.fragment.yml` baseline:

```yaml
schema_version: "extensions-skills-registry-fragment-v1"
skills: {}
```

## Create Prompt Bundle

Creates or updates:

```text
<pack-id>/
  pack.yml                      # update content_entrypoints.prompts to "prompts/" when null
  prompts/
    <bundle-id>/
      README.md
      manifest.yml
      companions/
        01-align-bundle.md
      stages/
        01-<stage-id>.md
      references/
        bundle-contract.md
```

`manifest.yml` baseline:

```yaml
schema_version: "octon-extension-prompt-set-v1"
prompt_set_id: "<pack-id>-<bundle-id>"
version: "0.1.0"
stages:
  - stage_id: "<stage-id>"
    prompt_id: "<pack-id>-<bundle-id>-<stage-id>"
    path: "stages/01-<stage-id>.md"
    role_class: "stage"
    order: 1
companions:
  - prompt_id: "<pack-id>-<bundle-id>-align-bundle"
    path: "companions/01-align-bundle.md"
    role_class: "maintenance-companion"
references:
  - ref_id: "bundle-contract"
    path: "references/bundle-contract.md"
shared_references: []
required_repo_anchors:
  - ".octon/instance/ingress/AGENTS.md"
alignment_policy:
  default_mode: "auto"
  stale_behavior: "realign_or_fail_closed"
  skip_mode_policy: "degraded-retained-explicit"
  receipt_root: ".octon/state/evidence/validation/extensions/prompt-alignment"
invalidation_conditions:
  - "prompt-manifest-sha-changed"
  - "prompt-asset-sha-changed"
  - "required-anchor-sha-changed"
  - "extension-desired-config-sha-changed"
  - "root-manifest-sha-changed"
artifact_policy:
  internal_artifacts: []
  packet_support_files: []
```

## Create Skill

Creates or updates:

```text
<pack-id>/
  skills/
    manifest.fragment.yml
    registry.fragment.yml
    <skill-id>/
      SKILL.md
      references/
        phases.md
        io-contract.md
        validation.md
```

`skills/manifest.fragment.yml` entry shape:

```yaml
- id: <skill-id>
  display_name: <Display Name>
  group: extensions
  path: <skill-id>/
  skill_class: invocable
  summary: "<summary>"
  status: active
  tags: [<pack-id>, extension-pack, scaffolding]
  triggers:
    - "<skill-id>"
```

`skills/registry.fragment.yml` entry shape:

```yaml
<skill-id>:
  version: "1.0.0"
  commands:
    - /<skill-id>
  parameters: []
  requires:
    context: []
```

## Create Command

Creates or updates:

```text
<pack-id>/
  commands/
    manifest.fragment.yml
    <command-id>.md
```

`commands/manifest.fragment.yml` entry shape:

```yaml
- id: <command-id>
  display_name: <Display Name>
  path: <command-id>.md
  summary: "<summary>"
  access: agent
  argument_hint: "<argument-hint>"
```

## Create Context Doc

Creates:

```text
<pack-id>/
  context/
    <doc-id>.md
```

Minimal document shape:

```markdown
# <Title>

<summary>

## Purpose

- pack-local descriptive guidance only
```

## Create Validation Fixture

Creates:

```text
<pack-id>/
  validation/
    scenarios/
      <fixture-id>.md
```

Minimal fixture shape:

```markdown
# <Fixture Title>

## Target Kind

`<target-kind>`

## Preconditions

- additive pack root exists

## Invocation

- command or skill inputs for the target scaffold

## Expected Outputs

- concrete raw pack paths created or updated

## Forbidden Outputs

- `instance/**`
- `state/**`
- `generated/**`
```
