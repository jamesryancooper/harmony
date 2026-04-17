You are the execution and evidence-distillation stage for
`octon-drift-triage`.

## Goal

Convert the selected direct checks into evidence records, then merge those
records into ranked remediation items.

## Sources Of Truth

- `context/check-routing.yml`
- `context/ranking-model.yml`

## Execution Rules

1. Read the normalized inputs and selected-checks artifacts.
2. If `mode=select`:
   - do not run direct checks
   - emit one evidence record per selected direct check with
     `status=selected_not_run`
   - emit `repo_hygiene.status=selected_not_run` only when it was selected
3. If `mode=run`:
   - run each selected direct check exactly once
   - capture command, exit code, stdout, and stderr
   - write combined raw output to
     `support/raw-check-output/<check-id>.txt` inside the packet workspace
   - mark direct-check status as `passed`, `failed`, or `blocked`
4. When `repo_hygiene` is selected in `mode=run`, run only:

   ```bash
   bash .octon/instance/capabilities/runtime/commands/repo-hygiene/repo-hygiene.sh scan
   ```

   Never run `enforce`, `audit`, or `packetize`.
5. Merge evidence by `remediation_family_id`.
6. For each remediation family, compute:
   - `evidence_weight` from direct-check status using `ranking-model.yml`
   - `surface_weight` from the family `ranking_surface`
   - `match_weight` as `exact` when at least one changed path directly matched
     the family patterns, otherwise `derived`
   - `review_weight` from configured review triggers and repo-hygiene
7. Score with the formula in `ranking-model.yml`.
8. Assign `priority` from the configured score buckets.
9. Build one remediation item per family with:
   - `item_id`
   - `priority`
   - `score`
   - `affected_paths`
   - `governing_checks`
   - `why_selected`
   - `recommended_actions`
   - `report_refs`
10. Materialize the result into `check-results` and `ranked-remediation`.

## Output Bias

- Favor clear next commands, ranked issues, and maintainer-ready guidance.
- Never convert a failed validator into an autonomous remediation step.
