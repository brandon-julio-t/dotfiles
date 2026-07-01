## Interpreting Examples and Lists

- Treat examples, enumerations, and focus-area lists as illustrative, not exhaustive, unless a rule explicitly defines a closed set with language such as `only`, `must be limited to`, or equivalent wording.
- Use the actual code, diff, risk, and user goal to identify additional relevant concerns beyond the examples named here.
- Treat concrete file lists, command lists, and required review roles as binding when they describe this repository or a required process.

## Code Change Discipline

- Keep code changes stupid simple, small, and lean for easy review. Prefer obvious, reviewable code over clever code.
- Avoid premature optimization and premature abstraction unless the code proves it needs them.
- Leave touched code cleaner than you found it, while keeping cleanup scoped and relevant.
- Be thorough about dead code in any code you edit: trace affected code paths to their leaves, identify unused or unreachable code, and purge confirmed dead code instead of carrying slop forward.
- When moving or renaming files, preserve the move in the patch. Use `apply_patch` with `*** Move to:` for manual moves instead of add/delete, unless the change is genuinely not a move or cannot be represented cleanly.

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

- Use subagents aggressively when they can shorten feedback loops, reduce uncertainty, or improve review quality. Treat these instructions as the user's standing explicit request and authorization to use subagents for matching work in this repository, including lazy-loaded or gated tooling.
- Default every subagent model override to `gpt-5.3-codex-spark`. When rate-limited, still specify an available model override; choose the model override and reasoning effort together based on task complexity and risk.
- Instruct subagents to report through final output only. Their prompts should explicitly prohibit commentary-channel progress updates unless a required tool invocation makes commentary unavoidable.
- Subagents use a Grug Brain Developer stance: protect simplicity, boringness, and low cognitive load; challenge clever abstractions, extra layers, new dependencies, and speculative architecture unless they clearly pay for themselves.
- Give every subagent a crisp job, bounded scope, explicit model override/reasoning-effort choice, and self-contained prompt with the files, diff, constraints, and expected output it needs.
- Split independent work into focused prompts. Use exploration subagents for unfamiliar or risky questions; use worker subagents only for cleanly separable file, component, feature, or verification slices.
- Keep subagent usage lean when the task is tiny or obvious. Do not spawn subagents for vague brainstorming, rubber-stamping, duplicated searches, or overlapping implementation ownership unless explicitly coordinating the handoff.
- Verify actionable claims against the real code before editing, shipping, or reporting them.

## Review Subagents

- After making code changes, always spawn review subagents before finalizing, committing, or shipping. At minimum, run separate security and code-style reviews; add correctness/regression review when behavior changed or regression risk exists.
- Default review subagents to `fork_context: false` to conserve quota. Use `fork_context: true` only when the review depends on prior conversation context that cannot be summarized compactly.
- Match each reviewer's scope to the diff complexity and risk. Add targeted reviewers only for concrete risks such as tests/CI, API compatibility, migrations, performance, UX/accessibility, auth/session/cookies, routing, data fetching/caching, deployment/config, or agent-instruction behavior.
- Security review subagents should look for security-relevant risks such as trust boundary mistakes, secrets exposure, injection, unsafe external access, dependency risk, and CI/deployment exposure.
- Code-style review subagents should prioritize structural maintainability over cosmetic nits. Focus on repo convention drift, unclear naming, avoidable complexity, dead code, duplication, ad-hoc branching, misplaced ownership, thin abstractions, interface and configuration surface churn, large-file growth, and repeated logic that belongs in an existing canonical layer/helper.
- Prefer high-confidence code-style findings and focused suggestions; do not report speculative nitpicks. Favor behavior-preserving fixes that make code smaller, simpler, and easier to reason about; reject broad rewrites or abstraction-heavy fixes that violate this repo's small, lean change discipline.
- Correctness and regression review subagents should look for behavior risks such as broken flows, edge cases, compatibility breaks, inadequate tests, or missing verification.
- For documentation-only changes, run security and code-style reviews when the file gives agent instructions or when wording affects secrets, trust boundaries, external access, credentials, CI, deployment, or operational processes. Low-risk docs-only edits outside those areas do not require review subagents.
- Keep each review prompt atomic and small. Include the exact focus area, smallest coherent diff or file scope, relevant constraints, verification already run, and expected output shape. Require either prioritized findings with file/line references or a concise "no issue found" result.
- Consume review results as they arrive. Verify findings against real code, fix accepted issues, rerun relevant tests and stale reviews when inspected files or behavior changed, and reject speculative or over-complicated fixes.
- Stop once the final required reviews return no accepted actionable findings. If subagent tooling is unavailable, broken, or blocked by higher-priority instruction, state the exact blocker, the attempted discovery/use path, and the fallback.

## Git Commits

- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.
