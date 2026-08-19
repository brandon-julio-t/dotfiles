# mise
eval "$(~/.local/bin/mise activate zsh)"

# Completions installed by mise's native bottle backend.
FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

# Preferred editor
export EDITOR='nano'

# Use the newest OpenCode v2 CLI embedded in the Desktop beta app.
function opencode2 {
  local cli_root="$HOME/Library/Application Support/ai.opencode.desktop.beta/cli"
  local version build newest
  local newest_build=-1

  for version in "$cli_root"/*(/N); do
    build=${version##*-}
    if [[ $build == <-> ]] && (( build > newest_build )); then
      newest=$version
      newest_build=$build
    fi
  done

  if [[ -z $newest ]]; then
    print -u2 "OpenCode Desktop beta CLI not found in $cli_root"
    return 127
  fi

  "$newest/opencode-cli" "$@"
}

alias oc=opencode2
