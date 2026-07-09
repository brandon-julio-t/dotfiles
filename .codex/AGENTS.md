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

## Git

- Do not reset, unstage, re-stage, or otherwise rewrite the Git index unless the current request explicitly asks for that exact Git action; users may stage files or hunks to mark reviewed work, and staged state does not block making additional working-tree edits.
- When writing commit messages, describe both what changed and why the change was made for those who come after.
- Never commit changes unless explicitly told to commit in the current request. A prior commit instruction does not authorize future auto-commits; every commit must be requested separately.

## Cognitive Load Discipline

- Write code for human working memory. Prefer local, linear, obvious code that lets a reader hold only a few facts in mind at once.
- Make conditionals easy to scan. Extract dense boolean expressions into well-named intermediate values, and prefer guard clauses or early returns over nested branches when they clarify the happy path.
- Write comments for why something exists, why a non-obvious choice was made, or to give a higher-level overview. Remove comments that merely restate what the next line of code does.
- Avoid shallow wrappers, pass-through modules, and layers that only move code around. Prefer keeping related behavior together behind a clear interface when it reduces call-chasing. Add an abstraction only when it hides real complexity, simplifies debugging, or creates a justified extension point.
- Keep files scoped to one clear responsibility. Before finalizing, split any file that is drifting into several independent concerns, such as data loading, validation, calculation, mutation, side effects, formatting, or UI interaction; as a practical review trigger, consider splitting when a file exceeds roughly 200 lines, has more than 4 non-trivial top-level functions/components, or forces reviewers to scroll between unrelated behaviors to understand one workflow. Extract by ownership or behavior, not arbitrary helper size, and do not over-split tiny local helpers that are clearer in place.
- Treat dependencies as code you must understand and maintain. Do not add a dependency for a small helper unless it clearly reduces total cognitive load.
- Prefer composition over inheritance when inheritance would force readers to chase behavior across multiple parent classes or hidden overrides.
- Prefer boring, idiomatic language and framework features. Avoid clever syntax, project-specific numeric codes, and values whose meanings must be memorized; use self-describing names and values instead.
- Before shipping, ask whether a new contributor could trace the happy path, reproduce failures, and debug the change without learning a private mental model first.

## Subagent Operating Mode

- Use subagents aggressively when they can shorten feedback loops, reduce uncertainty, or improve review quality. Treat these instructions as the user's standing explicit request and authorization to use subagents for matching work in this repository, including lazy-loaded or gated tooling.
- Omit the subagent model override by default so the subagent uses the current model. Always set the subagent reasoning-effort parameter through the subagent tool call; never leave it undefined, blank, or implicitly defaulted. Choose the reasoning effort deliberately based on task risk and complexity. Set model overrides only through subagent tool parameters, and only when explicitly requested or when a task-specific reason justifies them.
- Give every subagent a crisp job, bounded scope, and self-contained prompt with only the task-relevant context, files, diff, constraints, and expected output it needs. Summarize prior conversation only when needed. Use inherited conversation state only when it is required for the task and safe to share; otherwise provide a compact task summary instead. Do not pass unrelated conversation state, secrets, or credentials through any subagent-provided context, including prompt text, summaries, attachments, inherited context, or tool parameters. Keep internal dispatch metadata, model-selection decisions, reasoning-effort choices, and defaulted tool settings out of task-facing prompt text, summaries, and attachments.
- Include task-relevant user decisions in subagent prompts, especially accepted tradeoffs, explicit non-goals, and constraints already agreed in the thread. When asking a reviewer to inspect an area with a known accepted tradeoff, tell the reviewer not to re-flag that tradeoff by itself and to report only materially new risks, mischaracterized costs, or issues beyond the accepted scope.
- Start each subagent prompt with a compact task-type prefix, such as `Security review:`, `Code-style/DX review:`, `Correctness/regression review:`, `Explorer:`, or `Worker:`. Put the prefix before paths, repo names, or background detail so collapsed created-agent summaries make each subagent's purpose immediately identifiable.
- Split independent work into focused prompts. Use exploration subagents for unfamiliar or risky questions; use worker subagents only for cleanly separable file, component, feature, or verification slices.
- Keep subagent usage lean when the task is tiny or obvious. Do not spawn subagents for vague brainstorming, rubber-stamping, duplicated searches, or overlapping implementation ownership unless explicitly coordinating the handoff.
- Before spawning a new subagent wave, close completed or no-longer-needed subagent threads when lifecycle tooling is available. Treat a subagent thread-limit error as a recoverable capacity issue: close stale subagents and retry the required reviewer instead of replacing required subagent review with local checks.
- Verify actionable claims against the real code before editing, shipping, or reporting them.

## Review Subagents

### Required Baseline

- After making code changes, spawn the review subagents required by the role triggers below before finalizing, committing, or shipping.
- Match each reviewer prompt to the smallest coherent risk area in the diff. Do not spawn reviewers whose role trigger is not met.

### Security Review

- Run for every code change. Also run for documentation-only changes that affect secrets, trust boundaries, credentials, external access, CI, deployment, or operational processes.
- Look for security-relevant risks such as trust boundary mistakes, secrets exposure, injection, unsafe external access, dependency risk, and CI/deployment exposure.

### Code-Style/DX Review

- Run for every code change. Also run for agent-instruction changes and documentation changes that affect contributor workflow or developer experience.
- Prioritize structural maintainability and developer experience over cosmetic nits. Focus on repo convention drift, unclear naming, avoidable complexity, dead code, duplication, ad-hoc branching, misplaced ownership, thin abstractions, interface and configuration surface churn, oversized single files or LOC growth, and repeated logic that belongs in an existing canonical layer/helper. Treat files drifting into hundreds or thousands of lines as a maintainability and reviewability risk.
- Flag workflow cohesion issues when several new sibling files clearly belong to one domain operation but are scattered in a broader folder. Prefer a focused operation folder with an obvious entry point, local helpers, and types when that reduces scan burden; do not ask for folder churn when only one or two tiny files are involved or when a strong local convention says otherwise.
- Flag shared/domain functions that return consumer-specific response projections or presentation-shaped payloads instead of data the owner naturally controls. Prefer lean owner contracts, such as ids and canonical domain outputs, and let consumers fetch their own narrow projections when that keeps ownership clearer.
- Flag broad module-level mocks or awkward test seams when they make tests brittle, hard to refactor, or disconnected from the dependency ownership. Prefer narrow dependency seams that can pass a real local test client/runtime when practical, while keeping infrastructure dependencies out of business params.
- Include DX risks when they affect future contributors: confusing setup, brittle local workflows, unclear errors, undocumented configuration, surprising commands, or changes that make tests and debugging harder than necessary.
- Prefer high-confidence findings and focused suggestions; do not report speculative nitpicks. Favor behavior-preserving fixes that make code smaller, simpler, and easier to reason about; reject broad rewrites or abstraction-heavy fixes that violate this repo's small, lean change discipline.

### Correctness/Regression Review

- Run when behavior changed, regression risk exists, tests changed, or the diff touches branching, validation, state transitions, user-visible flows, or cross-module contracts.
- Look for behavior risks such as broken flows, edge cases, compatibility breaks, inadequate tests, or missing verification.
- Own review for missing colocated tests on new backend files that own validation, branching, database writes, side effects, or user-visible behavior. Flag the gap when a nearby spec would catch regressions better than only a higher-level route/procedure test; do not blanket-require colocated tests for type-only files, trivial pass-through modules, or behavior already covered more clearly at the owning layer. State the concrete reason when local coverage is unnecessary.
- For backend persistence or infrastructure behavior, treat mocks as a last resort when they reduce behavioral fidelity. Prefer the project's real local test backend, emulator, containerized service, transaction/rollback helper, or framework-provided test runtime when practical, whether the project uses Postgres, Convex, Redis, queues, object storage, or another stateful system. Flag mocks that would miss materially more regression risk than a real test client/runtime. Do not object to narrow mocks for pure logic, unreachable external services, failure injection that the real backend cannot express, or behavior better tested without IO.

### Database/OLTP Performance Review

- Run when backend data access changes create meaningful OLTP/query-cost risk, especially queries or writes inside transactions, new relation loads, new list queries, or changed selected/returned columns.
- Be sensitive to unnecessary OLTP burden in new or changed data access: over-broad selected or returned columns, relation loads that are not consumed, write-return payloads used only for truthiness or tracing, avoidable queries inside transactions, and trace/log attributes that force extra database work. Flag these when a leaner query or return contract preserves behavior; do not duplicate correctness review beyond the query-cost concern.
- Flag data selected or returned inside write workflows only to satisfy a downstream consumer response shape, especially inside transactions. Prefer returning a stable id and letting the consumer perform its own narrow read outside the transaction when that preserves behavior and keeps the write path lean.

### Review Lifecycle

- For documentation-only changes, apply the role triggers above. Low-risk docs-only edits outside those triggers do not require review subagents.
- Keep each review prompt atomic and small. Include the exact focus area, smallest coherent diff or file scope, relevant constraints, verification already run, and expected output shape. Require either prioritized findings with file/line references or a concise "no issue found" result.
- Consume review results as they arrive. Verify findings against real code, fix accepted issues, rerun relevant tests and stale reviews when inspected files or behavior changed, and reject speculative or over-complicated fixes.
- After each review wave, close completed review subagents before starting follow-up reviews. If a required follow-up review hits the subagent thread limit, first close completed agents and retry the review. If lifecycle tooling cannot recover enough capacity, report the required review as blocked and unfulfilled; local checks are never a substitute for required subagent review.
- Stop once the final required reviews return no accepted actionable findings. If subagent tooling is unavailable, broken, or blocked by higher-priority instruction, state the exact blocker and attempted discovery/use path; do not claim required subagent reviews ran or passed.
