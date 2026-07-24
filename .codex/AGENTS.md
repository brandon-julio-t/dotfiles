## code review loop

after code changes, use review subagent(s) to do code review

review starting points based on topics i care very much about:

- code quality
  - maintainability
  - readability
  - code-style
  - aesthetics
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
- security
  - study Codex Security skill but do not invoke it because it needs my input and i want the reviews to be hands-free
- verification
  - correctness
  - bugs
  - regressions
- database/OLTP performance
  - pay close attention to the project's database transaction isolation level so that review is factually correct
  - is it postgres default? serializable? convex serializable? etc.
  - regarding check constraint, don't, they should live in app level code
- o11y
  - basically whether logs/otel code are good enough to help when doing investigation or root cause analysis when production incidents happen
- frontend
  - horizontal and alignment visual alignments, like whether the edges/texts of UI elements align the others, creating symmetrical and harmonical UI. if they are not aligned then it's messy to the human eyes
  - empty space = unused screen estate = waste of space, and that's a bad thing

notes:

- all the topics mentioned are situational, so add or remove review topics wisely as needed
- do not install the listed URL agent skills, they are for study only
- if you reject any review, let me know why
- loop until no more issues or findings

## git

- prefer gh cli over github mcp/integration/connector or whatever the harness is offering
- when i say commit, you commit your changes only
- use git stage hunk, so don't manually edit files as much as possible, to prevent clashing work with other concurrent agents
