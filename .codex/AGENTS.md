- when doing git commit, prevent clashing work with other concurrent tasks by using git staging, hunk staging, etc.

- after code changes, use review agent and loop until no findings

- when writing for AI agents, it is mandatory to study:
  - writings: https://developers.openai.com/api/docs/guides/latest-model
  - minimize cost: https://developers.openai.com/api/docs/guides/prompt-caching

- aggressively minimize token usage by (including but not limited to):
  - minimize tool loops/calls by batching, running them in parallel, concurrently in one function execution, etc.
  - minimize tool outputs by truncating, filtering, etc.
  - speak & write plain & simple & concise
