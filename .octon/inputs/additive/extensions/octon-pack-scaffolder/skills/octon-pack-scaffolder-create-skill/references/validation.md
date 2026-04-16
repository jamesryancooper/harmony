# Validation

Success means:

- the new skill directory contains the MVP reference files
- the manifest fragment uses `group: extensions` and `skill_class: invocable`
- the registry fragment binds `/skill-id`
- fragment ordering remains lexical
- rerunning is idempotent and conflicts block
