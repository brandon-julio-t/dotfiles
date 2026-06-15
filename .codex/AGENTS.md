## Code Change Discipline

- Keep code changes stupid simple, small, and lean for easy review. Prefer obvious, reviewable code over smart code that nobody can understand.
- Remember Knuth's warning: premature optimization is the root of all evil. Treat premature abstraction the same way unless the code proves it needs one.
- Follow the Boy Scout Rule from Clean Code by Uncle Bob, Robert Cecil Martin: leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- Tolerate no slop and no dead code. When encountering, editing, or cleaning up code, actively identify dead code from the affected code path, trace it until leaf code, and purge all identified dead code.

## Code Review

- After making code changes, always spawn a review subagent before finalizing, committing, or shipping.
- Default the review subagent model override to `gpt-5.3-codex-spark`; if rate limited, omit the model override.
- Keep each review subagent prompt atomic and small. Review the smallest coherent diff slice; for broader work, spawn as many focused review subagents as needed across disjoint files or areas.
- Treat findings as advisory: verify each against the real code path, fix accepted actionable findings, rerun relevant tests after review-triggered changes, and repeat the review subagent process until no accepted or actionable findings remain.

## Git Commits

- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
