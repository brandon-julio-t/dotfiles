## subagent

although the default is `fork_turns` all, never use it because you can and must always choose the `model` and `reasoning_effort` wisely
unless somehow in the future `fork_turns` all supports overriding `model` and `reasoning_effort` then feel free to do so as wisely

## code review loop

after code changes, use review subagent(s) to do code review

review starting points based on topics i care very much about:

- maintainability
  - aesthetics
  - code-style
  - readability
  - useless/unreachable/dead code
  - inhuman cognitive load
  - unrealistic overengineering
  - violation of KISS/YAGNI
  - premature optimization
  - deprecated APIs
  - developer experience (DX)
  - bus factor
  - long/God file/class/function
  - unsafe typed code like `any` or `as` in typescript
  - study:
    - https://github.com/cursor/plugins/blob/main/cursor-team-kit/skills/thermo-nuclear-code-quality-review/SKILL.md
- security
  - study Codex Security skill but do not invoke it because it needs my input and i want the reviews to be hands-free
- verification
  - correctness
  - bugs
  - regressions
  - study:
    - https://github.com/cursor/plugins/blob/main/thermos/skills/thermo-nuclear-review/SKILL.md
- database/OLTP performance
  - pay close attention to the project's database transaction isolation level so that review is factually correct
  - is it postgres default? serializable? convex serializable? etc.
  - study:
    - https://github.com/planetscale/database-skills
- o11y
  - basically whether logs/otel code are good enough to help when doing investigation or root cause analysis when production incidents happen
  - study:
    - https://loggingsucks.com/
    - https://github.com/boristane/agent-skills
- frontend
  - horizontal and alignment visual alignments, like whether the edges/texts of UI elements align the others, creating symmetrical and harmonical UI. if they are not aligned then it's messy to the human eyes
  - empty space = unused screen estate = waste of space, and that's a bad thing
  - study:
    - https://github.com/vercel-labs/agent-skills

notes:

- all the topics mentioned are situational, so add or remove review topics wisely as needed
- if you reject any review, let me know why
- loop until no more issues or findings
- the listed URL agent skills are for study only, do not install them

## git

- prefer gh cli over github mcp/integration/connector or whatever the harness is offering
- if any cli cmd errors about network thing, it's codex sandbox
- when i say commit, you commit your changes only
- use git stage hunk, so don't manually edit files as much as possible, to prevent clashing work with other concurrent agents
