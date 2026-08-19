# mise
eval "$(~/.local/bin/mise activate zsh)"

# Completions installed by mise's native bottle backend.
FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

# Preferred editor
export EDITOR='nano'

# Use the OpenCode v2 CLI embedded in the Desktop beta app.
function opencode {
  local bin="/Applications/OpenCode Beta.app/Contents/Resources/opencode-cli"

  if [[ ! -x $bin ]]; then
    print -u2 "OpenCode Desktop beta CLI not found at $bin"
    return 127
  fi

  "$bin" "$@"
}

alias oc=opencode
alias opencode2=opencode
