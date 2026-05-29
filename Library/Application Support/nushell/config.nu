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
$env.config.show_banner = false

$env.SHELL = "nu"
$env.EDITOR = 'zed --wait'
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.OPENCODE_EXPERIMENTAL = true

# https://github.com/anomalyco/opencode/releases/tag/v1.15.6
# "Zed editor context now only activates inside Zed terminals."
# workaround of using zed and opencode in ghostty (2 separate apps)
$env.ZED_TERM = true

def with-mise-github-token [body: closure] {
    let existing_token = (try { $env.MISE_GITHUB_TOKEN } catch { null })

    if ($existing_token != null) and (($existing_token | str trim) != '') {
        do $body
    } else {
        let token = (try { gh auth token | str trim } catch { null })

        if ($token == null) or ($token == '') {
            do $body
        } else {
            with-env { MISE_GITHUB_TOKEN: $token } {
                do $body
            }
        }
    }
}

alias b = bun
alias br = bun run
alias bx = bunx
alias c = cursor
alias cat = bat --theme "Catppuccin Mocha"
alias d = docker
alias dc = docker compose
alias docker-compose = docker compose
alias g = git
alias gcl = git clone --depth 1 --single-branch
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

# Register mise's Compose binary as a Docker CLI plugin so `docker compose` works.
def ensure-docker-compose-plugin [] {
    let source = (try { with-mise-github-token { mise which docker-cli-plugin-docker-compose } | str trim } catch { null })

    if ($source == null) {
        return
    }

    if (not ($source | path exists)) {
        return
    }

    let plugin_dir = ($nu.home-dir | path join ".docker" "cli-plugins")
    let plugin_path = ($plugin_dir | path join "docker-compose")
    let plugin_is_symlink = ((^test -L $plugin_path | complete).exit_code == 0)

    mkdir $plugin_dir

    if $plugin_is_symlink {
        rm $plugin_path
        ^ln -s $source $plugin_path
    } else if not ($plugin_path | path exists) {
        ^ln -s $source $plugin_path
    }
}

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
        with-mise-github-token { mise activate nu } | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")

        # Starship
        with-mise-github-token { mise x -- starship init nu } | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

        # Zoxide
        with-mise-github-token { mise x -- zoxide init nushell } | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

        # Atuin
        with-mise-github-token { mise x -- atuin init nu } | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

        # Carapace
        with-mise-github-token { mise x -- carapace _carapace nushell } | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

        # OpenCode
        opencode completion | save -f (brew --prefix | path join "share/zsh/site-functions/_opencode")

        # Mise
        with-mise-github-token { mise completion zsh } | save -f (brew --prefix | path join "share/zsh/site-functions/_mise")

        # Caddy
        with-mise-github-token { mise x -- caddy completion zsh } | save -f (brew --prefix | path join "share/zsh/site-functions/_caddy")

        # Colima
        with-mise-github-token { mise x -- colima completion zsh } | save -f (brew --prefix | path join "share/zsh/site-functions/_colima")

        # Limactl
        with-mise-github-token { mise x -- limactl completion zsh } | save -f (brew --prefix | path join "share/zsh/site-functions/_limactl")
    }
}

def up-repos [] {
    # Pull git repos under ~/repos concurrently without creating merge commits.
    let pulls = (
        glob ~/repos/**/.git
        | sort
        | par-each --threads 8 --keep-order { |gitdir|
            let repo = ($gitdir | path dirname)
            {
                repo: $repo
                result: (^git -C $repo pull --ff-only | complete)
            }
        }
    )

    $pulls
    | each { |pull|
        print $'==> ($pull.repo)'
        if (($pull.result.stdout | str length) > 0) { print $pull.result.stdout }
        if (($pull.result.stderr | str length) > 0) { print $pull.result.stderr }
        if $pull.result.exit_code != 0 {
            print $'pull failed with exit code ($pull.result.exit_code)'
        }
    }
    | ignore
}

def up [] {
    timeit {
        timeit { try { opencode upgrade --print-logs } }
        timeit { try { brew up } }
        timeit { try { brew upgrade } }
        timeit { try { brew cleanup } }
        timeit { try { with-mise-github-token { mise self-update -y } } }
        timeit { try { with-mise-github-token { mise up -y --bump } } }
        timeit { try { ensure-docker-compose-plugin } }
        timeit { try { with-mise-github-token { mise prune -y } } }
        timeit { try { with-mise-github-token { mise x -- colima restart } } }
        timeit { try { init } }
    }
}
