# Checklist: Error Handling

- [ ] Domain/library errors are typed
- [ ] `thiserror` is used when callers/tests need variants
- [ ] `anyhow` is limited to glue/app edge where appropriate
- [ ] I/O errors include path context
- [ ] Config errors include source context
- [ ] External command errors include program/status/stderr
- [ ] Expected user errors are distinguished from internal failures
- [ ] Exit codes are intentional
- [ ] No broad string-only error hiding
