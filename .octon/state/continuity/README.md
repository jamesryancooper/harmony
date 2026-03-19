# State Continuity

`state/continuity/**` stores active resumable work state for the live
repository.

## Canonical Continuity Surfaces

| Path | Purpose |
| --- | --- |
| `state/continuity/repo/**` | Repo-wide and cross-scope active work state |
| `state/continuity/scopes/<scope-id>/**` | Stable single-scope active work state |

Detailed work state has one primary home. Cross-scope work belongs in repo
continuity. Stable single-scope work belongs in the matching scope continuity
surface.
