# Dependency Discipline

## Purpose

Prevent AI-assisted work from adding dependency bloat or coupling without a
bounded decision record.

## Rule

An AI-assisted Change must not add, remove, or materially widen dependency
risk without a Dependency Receipt. Dependency updates remain separate from
feature, refactor, formatting, and cleanup changes unless an explicit policy
route authorizes coupling and the receipt explains why.

## Dependency Receipt

Record:

- dependency name and ecosystem;
- problem solved;
- current workspace alternatives considered;
- why local implementation is worse;
- direct call sites;
- transitive risk;
- license posture;
- security posture;
- runtime, CI, host-tool, or developer-only classification;
- removal or retirement path;
- validation run;
- whether this is isolated from feature work.

## Default Outcome

If the receipt is absent or weak, keep the dependency change out of scope or
route it to a separate Change.
