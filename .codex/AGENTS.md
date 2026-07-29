- prefer gh cli over github mcp/integration/connector or whatever the harness is offering
- when doing git commit, commit your changes only using git hunk staging to prevent clashing work with other concurrent agents

- after code changes, spawn review agent, cherry pick wisely, fix, and loop until no findings

- when you want to inspect dev server error, try tmux

- when writing for AI agents, it is mandatory to study https://developers.openai.com/api/docs/guides/latest-model first and adjust the writings
- when developing AI agents, it is mandatory to study https://developers.openai.com/api/docs/guides/prompt-caching to minimize cost

- aggressively minimize token consumptions wherever possible and wise, such as:
  - minimize tool loops by running them concurrently in one function execution. lesser turns = lesser token consumption
  - minimize tool outputs by truncating, filtering, etc. lesser output = lesser token consumption
