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
    "/usr/local/bin"
    "~/.local/bin",
    "~/.opencode/bin",
]

$env.config.buffer_editor = "zed"

$env.EDITOR = 'zed --wait'
$env.OPENCODE_EXPERIMENTAL = 1

alias b = bun
alias br = bun run
alias bx = bunx
alias c = cursor
alias cat = bat --theme "Catppuccin Mocha"
alias d = docker
alias dc = docker-cli-plugin-docker-compose
alias g = git
alias gcl = git clone
alias gco = git checkout
alias ggl = git pull
alias gp = git push
alias grv = git remote -v
alias gst = git status
alias gw = git worktree
alias gwa = git worktree add
alias gwl = git worktree list
alias gwr = git worktree remove
alias l = ls -a
alias ld = lazydocker
alias lg = lazygit
alias lss = lazyssh
alias oc = opencode
alias p = pnpm

def gwipe [] {
  git reset --hard HEAD
  git clean -fd
}

def rmf [dir: path] {
  let empty = (mktemp -d)
  ^rsync -a --delete $"($empty)/" $"($dir)/"
  ^rmdir $dir
  rm -rf $empty
}

$env.GPG_TTY = (tty | str trim)

# Create the vendor directory if it doesn't exist
# mkdir ($nu.data-dir | path join "vendor/autoload")

# Starship
# starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# Mise
# mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")

# Zoxide
# zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

# Carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
# carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

# Atuin
# atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")
# atuin gen-completions --shell nushell | save -f ($nu.data-dir | path join "vendor/autoload/atuin-completions.nu")
