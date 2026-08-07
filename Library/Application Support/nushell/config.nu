# config.nu — managed by ~/repos/dotfiles and mise
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
    # mise's native brew backend uses the canonical bottle prefix without
    # requiring the Homebrew CLI. libpq is keg-only, so it needs its opt path.
    "/opt/homebrew/bin",
    "/opt/homebrew/opt/libpq/bin",
    "/usr/local/bin",
    ($nu.home-dir | path join ".local" "bin"),
    # opencode CLI installed and self-updated by T3 Code (not mise-managed).
    ($nu.home-dir | path join ".opencode" "bin"),
]

$env.config.buffer_editor = "zed"
# $env.config.show_banner = false

$env.SHELL = (mise which nu | str trim)
$env.EDITOR = 'zed --wait'
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'

# opencode experimental features.
# Master switch: enables CODE_MODE (MCP tools deferred behind execute/search),
# BACKGROUND_SUBAGENTS, PLAN_MODE, REFERENCES, LSP_TOOL, OXFMT, EVENT_SYSTEM,
# WORKSPACES, ICON_DISCOVERY, and Exa web search.
$env.OPENCODE_EXPERIMENTAL = "true"
# Keep Bun watch output visible for people and agents inspecting tmux scrollback.
if ('TMUX' in $env) {
    $env.BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD = "1"
}
# Fail before an update if GitHub cannot answer every version lookup. Mise can
# otherwise warn on HTTP 403 responses and still exit successfully.
const GITHUB_UPDATE_MIN_REQUESTS = 40 # Current lookups plus ~10 requests of headroom.

def ensure-github-update-budget [] {
    let token = (try { $env.MISE_GITHUB_TOKEN | str trim } catch { '' })
    let base_headers = {
        Accept: "application/vnd.github+json"
        "X-GitHub-Api-Version": "2022-11-28"
    }
    let headers = if $token == '' {
        $base_headers
    } else {
        $base_headers | merge { Authorization: $'Bearer ($token)' }
    }
    let remaining = (
        http get --max-time 10sec --headers $headers https://api.github.com/rate_limit
        | get resources.core.remaining
    )

    if $remaining < $GITHUB_UPDATE_MIN_REQUESTS {
        error make {
            msg: $'GitHub API budget is too low for a complete mise update: ($remaining) requests remain; ($GITHUB_UPDATE_MIN_REQUESTS) required. Wait for the reset or provide a dedicated MISE_GITHUB_TOKEN.'
        }
    }
}

alias b = bun
alias br = bun run
alias bx = bunx
alias c = cursor
alias cat = bat --theme "Pierre Dark Soft"
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

# Create a named tmux session, or attach to it when it already exists.
def tdev [name: string = "dev"] {
    let session_exists = ((^tmux has-session -t $name | complete).exit_code == 0)

    if not $session_exists {
        ^tmux new-session -d -s $name $env.SHELL
    }

    # Keep new windows on Nushell even when the tmux server predates this session.
    ^tmux set-option -g default-shell $env.SHELL
    ^tmux attach-session -t $name
}

# Register mise's Compose binary as a Docker CLI plugin so `docker compose` works.
def ensure-docker-compose-plugin [] {
    let source = (mise which docker-cli-plugin-docker-compose | str trim)

    if ($source == '') or (not ($source | path exists)) {
        error make { msg: $'Docker Compose plugin source is unavailable: ($source)' }
    }

    let plugin_dir = ($nu.home-dir | path join ".docker" "cli-plugins")
    let plugin_path = ($plugin_dir | path join "docker-compose")
    let plugin_is_symlink = ((^test -L $plugin_path | complete).exit_code == 0)

    mkdir $plugin_dir

    if $plugin_is_symlink {
        rm $plugin_path
        ^ln -s $source $plugin_path
    } else if ($plugin_path | path exists) {
        error make { msg: $'Refusing to replace non-symlink Docker Compose plugin: ($plugin_path)' }
    } else {
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
        mise activate nu | save -f ($nu.data-dir | path join "vendor/autoload/mise.nu")

        # Starship
        mise x -- starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

        # Zoxide
        mise x -- zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")

        # Atuin
        mise x -- atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

        # Carapace
        mise x -- carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
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
        ensure-github-update-budget
        timeit { mise self-update -y }
        timeit { mise upgrade -y --bump }
        timeit { mise bootstrap packages upgrade -y }
        timeit { mise bootstrap packages prune -y }
        timeit { ensure-docker-compose-plugin }
        timeit { mise prune -y }
        timeit { mise x -- colima restart }
        timeit { init }
    }
}
