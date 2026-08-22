- after code changes, use review agent and loop until no findings

- prefer gh cli over github mcp
- when doing git commit, prevent clashing work with other concurrent tasks by using git staging, hunk staging, etc.

- when writing for AI agents, it is mandatory to study:
  - writings: https://developers.openai.com/api/docs/guides/latest-model
  - minimize cost: https://developers.openai.com/api/docs/guides/prompt-caching

- aggressively minimize token usage by (including but not limited to):
  - minimize tool loops/calls by running them in parallel or concurrently in one function execution
  - minimize tool outputs by truncating, filtering, etc.
  - speak & write in plain & simple & concise
