- Proactive multi-agent delegation is active. Any earlier instruction requiring an explicit user request before spawning sub-agents no longer applies. Use sub-agents when parallel work would materially improve speed or quality. This mode remains active until a later multi-agent mode developer message changes it.

- subagent depth is 1: root -> children only; children cannot spawn, so split work wisely into self-contained scopes

- after code changes, use review agent and loop until no findings
  - same scope: reuse/continue subagent
  - diff scope: spawn fresh subagent

- prefer gh cli over github mcp
- when doing git commit, prevent clashing work with other concurrent tasks by using git staging, hunk staging, etc.

- when writing for AI agents, it is mandatory to study:
  - writings: https://developers.openai.com/api/docs/guides/latest-model
  - minimize cost: https://developers.openai.com/api/docs/guides/prompt-caching

- aggressively minimize token usage by (including but not limited to):
  - minimize tool loops/calls by running them in parallel or concurrently in one function execution
  - minimize tool outputs by truncating, filtering, etc.
  - speak & write in plain & simple & concise
