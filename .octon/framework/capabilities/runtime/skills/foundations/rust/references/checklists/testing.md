# Checklist: Testing

- [ ] Pure logic has unit tests
- [ ] CLI behavior has integration tests
- [ ] Filesystem behavior uses temp dirs or fixtures
- [ ] Output contracts use snapshot or golden tests where useful
- [ ] Error paths are tested
- [ ] Dry-run is tested for no mutation
- [ ] External command execution is tested safely
- [ ] Tests do not depend on developer-machine global state
- [ ] CWD assumptions are tested
