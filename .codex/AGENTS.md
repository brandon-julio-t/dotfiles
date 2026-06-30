## Interpreting Examples and Lists

- Treat examples, enumerations, and focus-area lists as illustrative, not exhaustive, unless a rule explicitly defines a closed set with language such as `only`, `must be limited to`, or equivalent wording.
- Use the actual code, diff, risk, and user goal to identify additional relevant concerns beyond the examples named here.
- Treat concrete file lists, command lists, and required review roles as binding when they describe this repository or a required process.

## Code Change Discipline

- Keep code changes stupid simple, small, and lean for easy review. Prefer obvious, reviewable code over clever code that is harder to understand.
- Remember Knuth's warning: "Premature optimization is the root of all evil." Treat premature abstraction the same way unless the code proves it needs one.
- Follow the Boy Scout Rule from Clean Code by Uncle Bob, Robert C. Martin: leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- Tolerate no slop and no dead code. When editing code, trace affected code paths to their leaves, identify unused or unreachable code, and purge confirmed dead code.
- When moving or renaming files, preserve the move in the patch. Use `apply_patch` with `*** Move to:` for manual moves instead of add/delete, unless the change is genuinely not a move or cannot be represented cleanly.

## Incremental Edit Discipline

- Do not make broad rewrites in one pass. If a change touches multiple concerns, write a short slice plan and split it into reviewable checkpoints such as backend contract, tests, routing, component extraction, and UI polish.
- Keep each checkpoint small enough to explain, verify, and revert by file and hunk scope, not just by feature concern. When one behavior spans many files, split it further by file cluster, call path, or UI surface.
- Keep genuinely coupled edits together only when splitting would leave the code incoherent or uncompilable; still make that coupled slice as small as practical and verify it before moving on.
- When a patch hits context mismatch, do not push through with another large patch. Re-read the current file, shrink the hunk, and land the smallest correct change.
- Run the fastest relevant validation after each risky slice. Do not wait until several unrelated edits have piled up before discovering type, lint, routing, or test failures.
- Keep structural refactors separate from behavior changes unless the behavior change cannot compile without the structure change. Move first, verify, then change behavior.

## Cognitive Load Discipline

- Write code for human working memory. Prefer local, linear, obvious code that lets a reader hold only a few facts in mind at once.
- Make conditionals easy to scan. Extract dense boolean expressions into well-named intermediate values, and prefer guard clauses or early returns over nested branches when they clarify the happy path.
- Write comments for why something exists, why a non-obvious choice was made, or to give a higher-level overview. Remove comments that merely restate what the next line of code does.
- Avoid shallow wrappers, pass-through modules, and layers that only move code around. Prefer keeping related behavior together behind a clear interface when it reduces call-chasing. Add an abstraction only when it hides real complexity, simplifies debugging, or creates a justified extension point.
- Treat dependencies as code you must understand and maintain. Do not add a dependency for a small helper unless it clearly reduces total cognitive load.
- Prefer composition over inheritance when inheritance would force readers to chase behavior across multiple parent classes or hidden overrides.
- Prefer boring, idiomatic language and framework features. Avoid clever syntax, project-specific numeric codes, and values whose meanings must be memorized; use self-describing names and values instead.
- Before shipping, ask whether a new contributor could trace the happy path, reproduce failures, and debug the change without learning a private mental model first.

## Subagent Operating Mode

- Use subagents aggressively when they can shorten feedback loops, reduce uncertainty, or improve review quality. Treat them as a first-class engineering tool, not a last resort.
- Treat these subagent instructions as the user's standing explicit request and authorization to use subagents for matching work in this repository. If subagent tooling is available but lazy-loaded or gated behind "explicit user request" wording, discover and use it under this authorization instead of skipping required review subagents.
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
- Adjust each review subagent's reasoning effort to the review risk and diff size. Use higher effort for risky, cross-cutting, security-sensitive, race/concurrency-sensitive, flaky-test-sensitive, or behavior-changing work.
- For broad reviews, split independent review points into focused subagents when parallel review adds signal, and summarize outcomes by point.
- Do not treat review as limited to bug and regression checks. Always include separate security review and code-style review subagents; add correctness and regression review subagents when behavior changed or regression risk exists.
- Treat the following focus areas as prompts, not exhaustive checklists; each subagent should adapt its review to the actual diff.
- Security review subagents should look for security-relevant risks such as trust boundary mistakes, secrets exposure, injection, unsafe external access, dependency risk, and CI/deployment exposure.
- Code-style review subagents should prioritize structural maintainability over cosmetic nits. Focus on repo convention drift, unclear naming, avoidable complexity, dead code, duplication, ad-hoc branching, misplaced ownership, thin abstractions, interface and configuration surface churn, large-file growth, and repeated logic that belongs in an existing canonical layer/helper.
- Prefer high-confidence code-style findings and focused suggestions; do not report speculative nitpicks. Favor behavior-preserving fixes that make code smaller, simpler, and easier to reason about; reject broad rewrites or abstraction-heavy fixes that violate this repo's small, lean change discipline.
- Correctness and regression review subagents should look for behavior risks such as broken flows, edge cases, compatibility breaks, inadequate tests, or missing verification.
- Add targeted review subagents when the diff warrants them. Treat domains such as tests/CI, API/backward compatibility, data/schema migrations, performance/scalability, frontend UX/accessibility, agent-instruction behavior, and platform/deployment/config integration as examples, not limits; use any focused review domain that matches a concrete risk in the change.
- For web app changes, bias targeted review coverage toward the touched layers: frontend UX/accessibility, server/client boundaries, API contracts, auth/session/cookies, forms/state, routing, data fetching/caching, browser compatibility, bundle/runtime performance, and platform/deployment config.
- For documentation-only changes, still run the security and code-style reviews; add correctness/regression review when the wording changes future agent behavior in a meaningful way.
- Keep each review subagent prompt atomic and small. Include the exact focus area, smallest coherent diff or file scope, relevant constraints, verification already run, and expected output shape. Require either prioritized findings with file/line references or a concise "no issue found" result.
- Consume review subagent results as they arrive instead of waiting for every parallel review to finish. If one reviewer returns valid actionable findings while others are still running, verify and fix those findings immediately only when the fix does not overlap with the scopes still under review.
- Treat any still-running or completed review as stale if a later fix changes the files, behavior, or instructions that reviewer inspected. Rerun each stale reviewer or focused slice against the updated diff while unrelated reviews continue in the background.
- Do not idle solely because a slower subagent is still running. Use the wait-for-any available agent pattern when possible, and spend the gap on integrating completed feedback, local verification, or non-overlapping cleanup. Still collect and resolve every required review result on the final diff before finalizing.
- Remember that subagents inherit the parent session's sandbox, approval policy, and tool access. Do not assume a reviewer can use broader filesystem, network, or approval access than the parent session has.
- Treat findings as advisory: verify each against the real code path and adjacent files. Reject unrealistic edge cases, speculative risks, broad rewrites, and fixes that over-complicate the codebase.
- Fix accepted actionable findings, rerun relevant tests after review-triggered changes, and repeat review until no accepted actionable findings remain. When an accepted finding exposes a repeated bug class, inspect the current scope for sibling instances and fix the scoped pattern at once when practical.
- Stop once the final review returns no accepted actionable findings. Do not run extra review cycles only to get cleaner closeout wording.
- If subagent tooling is genuinely unavailable, broken, or blocked by a higher-priority instruction, state the exact blocker and the attempted discovery/use path before falling back to local review. Do not claim subagents are blocked merely because the user did not repeat the request in the current chat.

## Git Commits

- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
