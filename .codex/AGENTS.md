## Code Change Discipline

- when making changes, keep them lean and minimal to both save token and time. by doing this, code review and maintenance improves because of readability and clarity, which is the most valuable and important thing, even more than smart code.
- remember Knuth's warning: "premature optimization is the root of all evil." treat premature abstraction as the same failure mode unless the code proves it needs one.
- follow uncle bob martin's boy scout rule from Clean Code: leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- be extremely ruthless against dead code. when encountering or cleaning up code, actively identify dead code in the path and purge the hell out of them too. tolerate no slop.

## Code Review

- after making code changes, always run `/review` before final/commit/ship.
- use `gpt-5.3-codex-spark` by default, choosing enough reasoning effort for the review risk; if rate limited or stalled, fall back to `gpt-5.5` with the same standard.
- keep each `/review` prompt atomic and small. review the smallest coherent diff slice; for broader work, spawn as many focused `/review` subagents as useful across disjoint files/areas.
- treat findings as advisory: verify each against the real code path, fix accepted actionable findings, rerun relevant tests after review-triggered changes, and repeat `/review` until no accepted/actionable findings remain.

## Git Commits

- when writing commit messages, describe both what changed and why the change was made for those who come after.
- never commit changes unless explicitly told to commit in the current request. a prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
