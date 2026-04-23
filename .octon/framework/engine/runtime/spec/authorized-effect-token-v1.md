# Authorized Effect Token v1

This contract defines the typed authorization product required by material
side-effect APIs.

## Purpose

`authorize_execution` remains the engine-owned authorization boundary.
Material side-effecting runtime APIs must consume typed effect tokens derived
from that boundary instead of relying on ambient `GrantBundle` access, raw
path inputs, or generated/read-model projections.

## Token model

The transport artifact is:

```text
AuthorizedEffect<T>
```

Actual mutation must require a verifier-produced internal guard:

```text
VerifiedEffect<T>
```

Where `T` is one of the material effect classes:

- `RepoMutation`
- `GeneratedEffectivePublication`
- `StateControlMutation`
- `EvidenceMutation`
- `ExecutorLaunch`
- `ServiceInvocation`
- `ProtectedCiCheck`
- `ExtensionActivation`
- `CapabilityPackActivation`

The executable token contract is:

- `authorized-effect-token-v2.schema.json`

The executable consumption receipt contract is:

- `authorized-effect-token-consumption-v1.schema.json`

## Required token metadata

Every token must carry at minimum:

- `schema_version`
- `token_id`
- `token_type`
- `effect_kind`
- `run_id`
- `request_id`
- `grant_id`
- decision and grant artifact refs
- canonical run control and evidence roots
- support-target tuple ref when applicable
- allowed capability packs
- scope ref plus scope envelope
- rollback or approval refs when the effect depends on them
- issued timestamp
- expiry timestamp when bounded by time
- single-use or scope-bounded validity semantics
- issuer ref
- revocation refs
- canonical token-record ref
- journal ref when minted under a bound run
- digest over the canonical token payload

## Construction rules

- Tokens are created only from the authorization boundary or an engine-owned
  projection of a successful grant.
- Arbitrary runtime callers must not be able to mint tokens.
- Public serialization/deserialization must not be sufficient to fabricate a
  valid token; verification must resolve a canonical token record.
- A token may be single-use or explicitly scope-bounded, but the scope must be
  encoded and enforced.

## Verification rules

- `AuthorizedEffect<T>` is only a transport artifact.
- Material APIs must verify the token against canonical control/evidence state
  before mutation.
- Verification must fail closed when the canonical token record is missing,
  mismatched, expired, revoked, already consumed, outside scope, outside the
  active support/capability envelope, or when receipt/journal persistence
  cannot be completed before or at effect attempt.
- Verification must retain an
  `authorized-effect-token-consumption-v1` receipt for both successful
  verification and rejection.

## Acceptance rule

Material side-effect APIs are not target-state complete until they require the
relevant token type as input and verify it into `VerifiedEffect<T>` before
mutation.
