# Effective Weights

- Profile: `ci-reliability`
- Repo: `harmony`
- Run mode: `ci`
- Maturity: `prod`

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

## Conflict Resolution

Priority ties were resolved using the charter chain (higher-ranked outcomes win).

| Priority | Winner | Loser | Winner Outcome | Loser Outcome |
|---:|---|---|---|---|
| 10 | `quality:observability` | `continuity:deployability` | `trust` | `speed_of_development` |
| 10 | `runtime:deployability` | `continuity:operability` | `speed_of_development` | `ease_of_use` |
| 6 | `quality:performance` | `continuity:accessibility` | `speed_of_development` | `ease_of_use` |

## Matrix

| Attribute | `continuity` | `quality` | `runtime` |
|---|---:|---:|---:|
| `Performance` (`performance`) | 3 | 3 | 3 |
| `Scalability` (`scalability`) | 4 | 4 | 4 |
| `Reliability` (`reliability`) | 5 | 5 | 5 |
| `Availability` (`availability`) | 5 | 5 | 5 |
| `Robustness` (`robustness`) | 4 | 4 | 4 |
| `Recoverability` (`recoverability`) | 5 | 5 | 5 |
| `Dependability` (`dependability`) | 4 | 4 | 4 |
| `Safety` (`safety`) | 5 | 5 | 5 |
| `Autonomy` (`autonomy`) | 4 | 4 | 4 |
| `Security` (`security`) | 5 | 5 | 5 |
| `Simplicity` (`simplicity`) | 5 | 5 | 5 |
| `Evolvability` (`evolvability`) | 4 | 4 | 4 |
| `Long-term Maintainability` (`maintainability`) | 5 | 5 | 5 |
| `Portability` (`portability`) | 5 | 5 | 5 |
| `Functional Suitability` (`functional_suitability`) | 5 | 5 | 5 |
| `Completeness` (`completeness`) | 4 | 4 | 4 |
| `Operability` (`operability`) | 5 | 5 | 5 |
| `Observability` (`observability`) | 5 | 5 | 5 |
| `Testability` (`testability`) | 5 | 5 | 5 |
| `Auditability` (`auditability`) | 5 | 5 | 5 |
| `Deployability` (`deployability`) | 5 | 5 | 5 |
| `Usability` (`usability`) | 3 | 3 | 3 |
| `Accessibility` (`accessibility`) | 3 | 3 | 3 |
| `Interoperability` (`interoperability`) | 4 | 4 | 4 |
| `Compatibility` (`compatibility`) | 3 | 3 | 3 |
| `Configurability` (`configurability`) | 3 | 3 | 3 |
| `Sustainability` (`sustainability`) | 2 | 2 | 2 |
