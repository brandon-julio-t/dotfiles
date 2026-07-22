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
- security
  - study Codex Security skill but do not invoke it because it needs my input and i want the reviews to be hands-free
- verification
  - correctness
  - bugs
  - regressions
- database/OLTP performance
  - pay close attention to the project's database transaction isolation level so that review is factually correct
  - is it postgres default? serializable? convex serializable? etc.

notes:

- all the topics mentioned are situational, so add or remove review topics wisely as needed
- if you reject any review, let me know why
- loop until no more issues or findings

## git commit

when i say commit, you commit your changes only
use git stage hunk, so don't manually edit files as much as possible, to prevent clashing work with other concurrent agents
