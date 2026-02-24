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
    "/opt/homebrew/opt/libpq/bin",
    "/usr/local/bin"
    "~/.local/bin",
    "~/.opencode/bin",
]

$env.config.buffer_editor = "zed"

$env.EDITOR = 'zed --wait'
$env.OPENCODE_EXPERIMENTAL = 1
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

alias b = bun
alias br = bun run
alias bx = bunx
alias c = cursor
alias cat = bat --theme "vague"
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

def init [] {
    timeit {
        # Create the vendor directory if it doesn't exist
        mkdir ($nu.data-dir | path join "vendor/autoload")

        # Mise
        mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")

        # Starship
        mise x -- starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

        # Zoxide
        mise x -- zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

        # Atuin
        mise x -- atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

        # Carapace
        mise x -- carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

        # OpenCode
        opencode completion | save -f (brew --prefix | path join "share/zsh/site-functions/_opencode")

        # Mise
        mise completion zsh | save -f (brew --prefix | path join "share/zsh/site-functions/_mise")

        # Caddy
        mise x -- caddy completion zsh | save -f (brew --prefix | path join "share/zsh/site-functions/_caddy")

        # Colima
        mise x -- colima completion zsh | save -f (brew --prefix | path join "share/zsh/site-functions/_colima")

        # Limactl
        mise x -- limactl completion zsh | save -f (brew --prefix | path join "share/zsh/site-functions/_limactl")
    }
}

def up [] {
    timeit {
        brew up
        brew upgrade
        brew cleanup
        mise self-update -y
        mise up -y
        mise prune -y
        opencode upgrade
        init
    }
}
