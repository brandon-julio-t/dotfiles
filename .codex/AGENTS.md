## code review loop

after code changes, do code review using the the following subagents:

1. mandatory: code-style/aesthetics,
   maintainability,
   readability,
   dead code,
   inhuman cognitive load / unrealistic overengineering,
   and developer experience (DX)
2. mandatory: security. study Codex Security skill but do not invoke it because it needs my input and i want the reviews to be hands-free
3. situational: correctness, bugs, and regressions
4. situational: OLTP database performance

- spawn the review subagents wisely as needed
- loop until no more issues or findings
- if you reject subagent suggestions, let me know why
- the subagent list mentioned is not a complete list of subagents. so if the task requires additional reviewer subagent that is not within the existing subagent list, feel free to do so
