# Bundle Contract

Program verification checks both parent and child levels. It cannot let parent
status replace child validation verdicts.

Aggregate verification receipts are parent-local summaries only. They may cite
child receipt state, but they never satisfy child receipts or child validation
verdicts.
