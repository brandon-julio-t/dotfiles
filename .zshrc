export PATH=/opt/homebrew/bin:$PATH

if [[ "${CODEX_SHELL:-}" == "1" ]]; then
  unset CODEX_SHELL
  exec nu
fi

# mise
eval "$(~/.local/bin/mise activate zsh)"

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# opencode
export PATH=/Users/brandonthenaro/.opencode/bin:$PATH
