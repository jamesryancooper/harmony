# Checklist: Filesystem and External Commands

- [ ] Paths use `Path`/`PathBuf`
- [ ] Root path is resolved once
- [ ] Recursive traversal excludes generated/build directories
- [ ] Mutations are represented as a plan before execution
- [ ] Dry-run displays planned mutations
- [ ] Important writes are atomic
- [ ] Destructive changes have backups or rollback posture
- [ ] External commands use `Command::new(...).arg(...)`
- [ ] `sh -c` is avoided unless justified
- [ ] stdout/stderr are captured intentionally
- [ ] Command failures are contextual
