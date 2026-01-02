# config.nu
#
# Installed by:
# version = "0.109.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.path ++= [
    "/opt/homebrew/bin",
    "~/.amp/bin",
    "~/.local/bin",
    "/usr/local/bin"
]

$env.config.buffer_editor = "zed"

$env.EDITOR = 'zed'

alias b = bun
alias br = bun run
alias bx = bunx
alias c = cursor
alias cat = bat --theme "Catppuccin Mocha"
alias cl = clear
alias code = cursor
alias d = docker
alias dc = docker-cli-plugin-docker-compose
alias g = git
alias gco = git checkout
alias ggl = git pull
alias gp = git push
alias grv = git remote -v
alias gst = git status
alias l = ls -a
alias ld = lazydocker
alias lg = lazygit
alias lss = lazyssh
alias m = mise
alias n = npm
alias oc = opencode
alias p = pnpm

def ssh [...args] {
    # workaround for ghostty nushell ssh problem for now https://github.com/ghostty-org/ghostty/issues/7877
    TERM=xterm-256color ^ssh ...$args
}

def gwipe [] {
  git reset --hard HEAD
  git clean -fd
}

# Create the vendor directory if it doesn't exist
mkdir ($nu.data-dir | path join "vendor/autoload")

# Starship
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
starship preset no-nerd-font -o ~/.config/starship.toml

# Mise
mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")

# Zoxide
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# Atuin
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")
atuin gen-completions --shell nushell | save -f ($nu.data-dir | path join "vendor/autoload/atuin-completions.nu")
