# mise
eval "$(~/.local/bin/mise activate zsh)"

# Completions installed by mise's native bottle backend.
FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

# Preferred editor
export EDITOR='nano'
