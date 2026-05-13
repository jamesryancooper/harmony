# Bundle Contract

The parent program packet coordinates child packets. It does not absorb child
identity, validation, authority, promotion targets, or archival state.

Program creation must leave parent-local `support/program-creation.md` evidence
with `child_authority_preserved: yes` only when every child remains a canonical
sibling packet outside the parent package.
