# Plan Rust Tool Migration Glossary

- **desired target**: requested architecture endpoint for the migration plan.
- **migration stage**: ordered implementation unit intended to leave the tool in
  a reviewable and preferably buildable state.
- **file movement map**: proposed source-to-target path mapping with reason and
  validation.
- **CLI contract**: commands, flags, exit codes, output format, and side-effect
  behavior visible to users or automation.
- **rollback note**: concise reversal instruction for a migration stage.
- **verification-oriented plan**: post-remediation format focused on confirming
  done-gate satisfaction.
