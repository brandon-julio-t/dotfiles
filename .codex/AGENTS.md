## Code Change Discipline

- Keep code changes stupid simple, small, and lean for easy review. Prefer obvious, reviewable code over clever code that is harder to understand.
- Remember Knuth's warning: "Premature optimization is the root of all evil." Treat premature abstraction the same way unless the code proves it needs one.
- Follow the Boy Scout Rule from Clean Code by Uncle Bob, Robert C. Martin: leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- Tolerate no slop and no dead code. When editing code, trace affected code paths to their leaves, identify unused or unreachable code, and purge confirmed dead code.

## Review Subagents

- After making code changes, always spawn review subagents before finalizing, committing, or shipping.
- Default the review subagent model override to `gpt-5.3-codex-spark`; when rate-limited, rerun without the model override.
- Default review subagents to `fork_context: false` to conserve quota. Use `fork_context: true` only when the review depends on prior conversation context that cannot be summarized compactly, and keep each review prompt self-contained with the relevant files, diff, constraints, and verification notes.
- Adjust each review subagent's reasoning effort to the review risk and diff size. Use higher effort for risky, cross-cutting, security-sensitive, or behavior-changing work.
- Do not treat review as limited to bug and regression checks. Always include separate security review and code-style review subagents; add correctness and regression review subagents when behavior changed or regression risk exists.
- Treat the following focus areas as prompts, not exhaustive checklists; each subagent should adapt its review to the actual diff.
- Security review subagents should look for security-relevant risks such as trust boundary mistakes, secrets exposure, injection, unsafe external access, dependency risk, and CI/deployment exposure.
- Code-style review subagents should look for maintainability issues such as repo convention drift, unclear naming, avoidable complexity, dead code, duplication, or unnecessary churn.
- Correctness and regression review subagents should look for behavior risks such as broken flows, edge cases, compatibility breaks, inadequate tests, or missing verification.
- Keep each review subagent prompt atomic and small. Review the smallest coherent diff slice; for broader work, split the diff aggressively and spawn as many focused review subagents as practical across disjoint files, concerns, or risk areas.
- Treat findings as advisory: verify each against the real code path and adjacent files. Reject unrealistic edge cases, speculative risks, broad rewrites, and fixes that over-complicate the codebase.
- Fix accepted actionable findings, rerun relevant tests after review-triggered changes, and repeat review until no accepted actionable findings remain. When an accepted finding exposes a repeated bug class, inspect the current scope for sibling instances and fix the scoped pattern at once when practical.
- Stop once the final review returns no accepted actionable findings. Do not run extra review cycles only to get cleaner closeout wording.
- Close each review subagent once its work is complete and any accepted findings are handled.

## Git Commits

- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
