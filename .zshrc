# mise
eval "$(~/.local/bin/mise activate zsh)"

# Preferred editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi
