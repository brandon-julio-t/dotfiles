## Code Change Discipline

- Keep code changes stupid simple, small, and lean for easy review. Prefer obvious, reviewable code over clever code that is harder to understand.
- Remember Knuth's warning: "Premature optimization is the root of all evil." Treat premature abstraction the same way unless the code proves it needs one.
- Follow the Boy Scout Rule from Clean Code by Uncle Bob, Robert C. Martin: leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- Tolerate no slop and no dead code. When editing code, trace affected code paths to their leaves, identify unused or unreachable code, and purge confirmed dead code.
- When moving or renaming files, preserve the move in the patch. Use `apply_patch` with `*** Move to:` for manual moves instead of add/delete, unless the change is genuinely not a move or cannot be represented cleanly.

## Subagent Operating Mode

- Use subagents aggressively when they can shorten feedback loops, reduce uncertainty, or improve review quality. Treat them as a first-class engineering tool, not a last resort.
- Default every subagent model override to `gpt-5.3-codex-spark`; when rate-limited, rerun without the model override.
- Be aggressive with parallelism, but wise about purpose. Every subagent must have a crisp job, bounded scope, and a self-contained prompt with the files, diff, constraints, and expected output it needs.
- Prefer spawning focused exploration subagents early for unfamiliar code paths, risky dependencies, cross-file ownership questions, or searches that can run independently while implementation proceeds.
- Prefer worker subagents only when the work can be split cleanly by file, component, feature slice, or verification target. Do not assign overlapping implementation ownership unless explicitly coordinating the handoff.
- Split broad work into small, independent subagent prompts instead of one vague delegation. Ask each subagent to return concrete findings, proposed edits, test results, or a concise "no issue found" result.
- Keep subagent usage lean when the task is tiny or the answer is already obvious. Aggressive does not mean wasteful, duplicative, or performative.
- Do not spawn subagents for vague brainstorming, rubber-stamping, or duplicated searches. If two agents would inspect the same facts in the same way, combine or redirect the work.
- Verify actionable claims against the real code before editing, shipping, or reporting them.

## Review Subagents

- After making code changes, always spawn review subagents before finalizing, committing, or shipping.
- Review subagents follow the general subagent model default.
- Default review subagents to `fork_context: false` to conserve quota. Use `fork_context: true` only when the review depends on prior conversation context that cannot be summarized compactly, and keep each review prompt self-contained with the relevant files, diff, constraints, and verification notes.
- Adjust each review subagent's reasoning effort to the review risk and diff size. Use higher effort for risky, cross-cutting, security-sensitive, or behavior-changing work.
- Do not treat review as limited to bug and regression checks. Always include separate security review and code-style review subagents; add correctness and regression review subagents when behavior changed or regression risk exists.
- Treat the following focus areas as prompts, not exhaustive checklists; each subagent should adapt its review to the actual diff.
- Security review subagents should look for security-relevant risks such as trust boundary mistakes, secrets exposure, injection, unsafe external access, dependency risk, and CI/deployment exposure.
- Code-style review subagents should prioritize structural maintainability over cosmetic nits. Focus on repo convention drift, unclear naming, avoidable complexity, dead code, duplication, ad-hoc branching, misplaced ownership, thin abstractions, interface and configuration surface churn, large-file growth, and repeated logic that belongs in an existing canonical layer/helper.
- Prefer high-confidence code-style findings and focused suggestions; do not report speculative nitpicks. Favor behavior-preserving fixes that make code smaller, simpler, and easier to reason about; reject broad rewrites or abstraction-heavy fixes that violate this repo's small, lean change discipline.
- Correctness and regression review subagents should look for behavior risks such as broken flows, edge cases, compatibility breaks, inadequate tests, or missing verification.
- Add targeted review subagents when the diff warrants them. Treat domains such as tests/CI, API/backward compatibility, data/schema migrations, performance/scalability, frontend UX/accessibility, agent-instruction behavior, and platform/deployment/config integration as examples, not limits; use any focused review domain that matches a concrete risk in the change.
- For web app changes, bias targeted review coverage toward the touched layers: frontend UX/accessibility, server/client boundaries, API contracts, auth/session/cookies, forms/state, routing, data fetching/caching, browser compatibility, bundle/runtime performance, and platform/deployment config.
- For documentation-only changes, still run the security and code-style reviews; add correctness/regression review when the wording changes future agent behavior in a meaningful way.
- Keep each review subagent prompt atomic and small. Review the smallest coherent diff slice; for broader work, split the diff aggressively and spawn as many focused review subagents as practical across disjoint files, concerns, or risk areas.
- Treat findings as advisory: verify each against the real code path and adjacent files. Reject unrealistic edge cases, speculative risks, broad rewrites, and fixes that over-complicate the codebase.
- Fix accepted actionable findings, rerun relevant tests after review-triggered changes, and repeat review until no accepted actionable findings remain. When an accepted finding exposes a repeated bug class, inspect the current scope for sibling instances and fix the scoped pattern at once when practical.
- Stop once the final review returns no accepted actionable findings. Do not run extra review cycles only to get cleaner closeout wording.

## Git Commits

- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
