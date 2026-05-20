# Checklist: Project Structure

- [ ] Current shape is classified
- [ ] `main.rs` is thin or has a plan to become thin
- [ ] Modules are named by responsibility
- [ ] `lib.rs` exists if integration tests/shared binaries need it
- [ ] `src/bin/**` is used only for real separate binaries
- [ ] Workspace is recommended only when justified
- [ ] Internal crates have real stable APIs
- [ ] No `utils` junk drawer dominates the architecture
