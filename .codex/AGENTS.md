## code review loop

after code changes, do code review using the the following subagents:

1. code-style/aesthetics,
   maintainability,
   readability,
   dead code,
   inhuman cognitive load / unrealistic overengineering,
   violation of KISS/YAGNI,
   premature optimization,
   deprecated APIs,
   developer experience (DX),
   etc.
2. security. study Codex Security skill but do not invoke it because it needs my input and i want the reviews to be hands-free
3. correctness, bugs, regressions, etc.
4. OLTP database performance

- all the subagents mentioned are situational, so spawn the review subagents wisely as needed
- loop until no more issues or findings
- if you reject subagent suggestions, let me know why
- the subagent list mentioned is not a complete list of subagents. so if the task requires additional reviewer subagent that is not within the existing subagent list, feel free to do so

## git commit

when i say commit, you commit your changes only
use git stage hunk, so don't manually edit files as much as possible, to prevent clashing work with other concurrent agents
