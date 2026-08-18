## Goal

Every Monday, update the Farmio Portal Product Update Logs in Notion with the previous calendar week's substantiated product-facing code changes from Farmio Service.

Notion page:
https://www.notion.so/farmio/Farmio-Portal-Product-Update-Logs-3a28efbef0d380148f95d5066e7ee02f

This is a documentation automation. Treat the repository as read-only: do not modify code or documentation files, create branches, commit, push, open pull requests, deploy, or send Slack messages.

## Weekly window and evidence

- Calculate the immediately preceding Monday through Sunday in Asia/Jakarta.
- Fetch current remote metadata safely without changing branches or the working tree.
- Audit only commits on the `origin/master` lineage whose committer/landing timestamps fall within that window.
- Exclude uncommitted work, commits only on snapshots or non-master branches, and duplicate patches.
- Use code and tests as evidence; do not infer product behavior from commit subjects alone.
- A bullet's displayed date is its substantiated code-landing date. If grouped work spans multiple landing dates, show the honest date range.
- Add a date only when supported by evidence. Leave existing undated bullets alone when their date is unknown.
- Do not claim a change was released or deployed unless production deployment evidence is available and verified.

## What belongs in the product log

Include cohesive, user- or operations-visible behavior such as:
- Farmio Portal workflows and UI;
- supplier-scoped Sales, ordering, invoicing, payments, collections, retailer, store, product, and inventory workflows;
- Ordering AI or onboarding behavior that materially changes customer or operator outcomes;
- backend authorization or correctness changes that materially alter what a portal role can do or see.

Exclude:
- dependency, lockfile, toolchain, infrastructure, generated-code, telemetry, and routine security maintenance;
- tests-only changes, TODOs, audits, docs, repository cleanup, and behavior-preserving refactors;
- placeholders or incomplete scaffolding that users cannot meaningfully use;
- noisy commit-by-commit narration.

Group related commits into a small number of clear product updates. Describe the user impact, not implementation details. Preserve Farmio terminology: user-facing copy says Product; store means RetailLocation; warehouse means SupplierLocation.

## Editorial standard: business points only

- Never copy, dump, or comprehensively paraphrase PR descriptions, PR notes, commit messages, or a list of technical changes into the product log. Treat them only as leads for code-backed investigation.
- Every published update must state, in plain business language, what changed for a customer, portal user, or operations workflow and why it matters.
- Combine all technical work supporting the same business outcome into one cohesive update.
- Omit implementation details such as file names, functions, endpoints, migrations, schemas, and refactors unless one is strictly necessary to explain observable behavior.
- Exclude any candidate that cannot be substantiated and expressed as a concrete user or business outcome. When in doubt, leave it out and mention it only in the run report.
- Keep the final log selective and concise; it is a curated product changelog, not an engineering activity report.

## Attribution

- Attribute every published top-level update to the human author or authors whose qualifying commits substantively implemented that business outcome.
- Use the Git author identity plus relevant `Co-authored-by:` trailers. Do not attribute work to a committer, merger, reviewer, reporter, or PR author unless that person is also a substantive commit author or co-author for the outcome.
- Canonicalize Brandon's known Git identity to exactly `Brandon Julio Thenaro`. If a repository `.mailmap` exists, use it for all contributors; otherwise preserve each contributor's established full Git author name.
- For a grouped update backed by multiple contributors, list each distinct substantive author once, ordered by their first qualifying contribution to that outcome. Exclude bots and maintenance-only authors.
- If authorship is ambiguous or unsupported, do not guess, do not add a name, and call out the uncertainty in the run report.
- Leave existing unattributed bullets unchanged when their author cannot be substantiated.

## Notion structure and editing safety

- Fetch the page immediately before editing.
- Preserve all unrelated weeks and user-authored content.
- Use the page's existing reverse-chronological weekly toggle structure and product-area headings.
- For each top-level update with known attribution and date, use the “what — who · when” format:
  `- **Concise update title** — Author Name · D Month YYYY`
  or, for evidence-backed grouped work:
  `- **Concise update title** — Author One, Author Two · D–D Month YYYY`
- Add a name or date only when supported by evidence. Leave existing unknown attribution or dates untouched rather than guessing.
- Add one or two nested bullets explaining the behavior and impact.
- If the previous week's section already exists, merge or refine without duplicating entries. Do not overwrite unrelated or manually added bullets.
- If the section does not exist and qualifying changes exist, insert it in the correct reverse-chronological position.
- If no qualifying changes exist, do not add an empty section.
- If strong evidence shows an existing update is filed under the wrong week, move it losslessly rather than rewriting its wording.
- Use targeted Notion search-and-replace updates, never a whole-page replacement.
- Re-fetch the page after writing and verify the intended content and dates exactly.
- If Notion access fails, the target text is ambiguous, or evidence is insufficient, make no speculative edit and report the blocker.

## Run report

Return a concise summary containing:
- weekly window audited;
- Notion section created or updated;
- update titles, attributed authors, and dates added;
- notable candidates intentionally excluded;
- any blocker or uncertainty.
