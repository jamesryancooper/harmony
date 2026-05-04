# Change Lifecycle Routing Hygiene Note

Review follow-up classification for current untracked local state.

- `.octon/.octon/generated/.tmp/**` is nested generated temporary output and is
  ignored by repository hygiene.
- Untracked `.octon/state/continuity/**`, `.octon/state/control/**`, and
  `.octon/state/evidence/**` run/control artifacts are retained-evidence
  candidates. Do not delete them as part of Change Lifecycle Routing validator
  cleanup; they require separate maintainer disposition.
