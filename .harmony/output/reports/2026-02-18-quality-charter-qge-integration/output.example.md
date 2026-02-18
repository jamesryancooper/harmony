# output.example

Context:
`repo=harmony`, `run-mode=ci`, `maturity=beta`, `profile=ci-reliability`

Generated files:

- Effective matrix: `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/effective/repo-harmony__run-mode-ci__maturity-beta__profile-ci-reliability.md`
- Weighted results: `/Users/jamesryancooper/Projects/harmony/.harmony/output/quality/results/repo-harmony__run-mode-ci__maturity-beta__profile-ci-reliability.md`

## Effective Output (excerpt)

```md
# Effective Weights

- Profile: `ci-reliability`
- Repo: `harmony`
- Run mode: `ci`
- Maturity: `beta`

## Charter Metadata

- Charter: `.harmony/quality/CHARTER.md`
- Priority chain: `Trust > Speed of development > Ease of use > Portability > Interoperability`
- Tie-break rule: When weighted priority ties, prioritize items mapped to higher charter outcomes in chain order.

## Trade-off Rules

- Trust is non-negotiable.
- Speed is optimized inside trust constraints.
- Ease of use is protected by progressive disclosure.
- Portability is preserved by contracts and isolation.
- Interoperability is allowed only with versioning + security + tests.
```

## Results Output (excerpt)

```md
# Weighted Quality Results

- Profile: `ci-reliability`
- Repo: `harmony`
- Run mode: `ci`
- Maturity: `beta`
- System score: `76.20%`

## Conflict Resolution

Equal-priority conflicts were resolved by charter chain order.

| Priority | Winner | Loser | Winner Outcome | Loser Outcome |
|---:|---|---|---|---|
| 10 | `scaffolding:observability` | `ideation:maintainability` | `trust` | `speed_of_development` |
```
