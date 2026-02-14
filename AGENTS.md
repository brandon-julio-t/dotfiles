# AGENTS.md

Guidelines for agentic coding agents working in this dotfiles repository.

## Overview

Personal dotfiles repository for machine configuration files. All files are symlinked from this repo to `~`.

**Structure mapping:**
- `.zshrc` → `~/.zshrc`
- `.config/opencode/` → `~/.config/opencode/`
- `Library/Application Support/` → `~/Library/Application Support/`

## File Structure

```
.
├── .config/
│   ├── opencode/
│   │   ├── opencode.json          # Main opencode config
│   │   └── plugin/
│   │       ├── notification.js    # Desktop notifications
│   │       └── env-protection.js  # Prevents reading .env files
│   └── ghostty/
│       ├── config
│       └── shaders/cursor_blaze.glsl
├── .local/share/fish/vendor_completions.d/
├── Library/Application Support/
│   ├── lazygit/config.yml
│   ├── nushell/
│   │   ├── config.nu
│   │   └── vendor/autoload/       # Symlinked: atuin.nu, fish.nu, mise.nu, starship.nu, zoxide.nu
│   └── com.mitchellh.ghostty/config
├── .gitconfig
├── .zshrc
└── README.md -> AGENTS.md
```

## Build/Lint/Test Commands

**No build system, tests, or linting exists.** This is a configuration-only repository.

### Testing Changes

**Shell configs:**
```bash
source ~/.zshrc        # Zsh: reload config
exec nu                # Nushell: restart shell
```

**Syntax validation:**
```bash
# Nushell
nu -c 'source config.nu'

# YAML
yamllint file.yml

# JavaScript - use editor linting
```

### Running Tests

**Not applicable** - This repository contains no test suite. Changes are validated manually by:
1. Applying the change
2. Reloading/restarting the affected application
3. Verifying expected behavior

## Code Style Guidelines

### General Principles

1. **Minimal configs**: Only essential settings
2. **Comment purpose**: Explain non-obvious choices
3. **No machine-specific paths**: Use `~` or `$HOME`
4. **No secrets**: Never commit API keys, tokens, or passwords

### JavaScript (Opencode Plugins)

- ES modules with `export const`
- Async/await for async operations
- Destructure parameters for clarity
- Keep plugins focused (single responsibility)

```javascript
export const PluginName = async ({ project, client, $ }) => {
  return {
    event: async ({ event }) => {
      // Handler logic
    },
  };
};
```

### Nushell (.nu files)

- 4-space indentation
- Prefer `$env.config` over `config` command
- Kebab-case for custom commands
- Single quotes for strings

```nushell
$env.config.buffer_editor = "zed"
$env.path ++= ["/opt/homebrew/bin", "~/.local/bin"]

alias gst = git status

def rmf [dir: path] {
  let empty = (mktemp -d)
  ^rsync -a --delete $"($empty)/" $"($dir)/"
  ^rmdir $dir
  rm -rf $empty
}
```

### YAML

- 2-space indentation, no tabs
- Quote strings with special characters
- Group related settings

```yaml
gui:
  theme:
    activeBorderColor:
      - "#89b4fa"
      - bold
```

### Shell Scripts (.zshrc)

- Use `[[ ]]` for conditionals
- Quote variables: `"$VAR"`
- Export environment variables explicitly

```bash
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
fi

eval "$(~/.local/bin/mise activate zsh)"
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | lowercase-hyphens | `env-protection.js` |
| Aliases | Short, memorable | `gst` = `git status` |
| Env vars | UPPER_SNAKE_CASE | `$env.EDITOR` |
| Commands | kebab-case | `rmf`, `gwipe` |

## Error Handling

- **Nushell**: Use `try/catch` for fallible operations
- **JavaScript**: Handle async errors with try/catch
- **Shell**: Use `set -e` or explicit checks

## Security

- **No .env files**: EnvProtection plugin blocks reads
- **No secrets in git**: Review changes before committing
- **Use placeholders**: Replace personal paths with variables

## Git Workflow

1. Make configuration changes
2. Test locally (reload shell/restart app)
3. Commit with descriptive prefix:
   - `nushell: add git worktree aliases`
   - `opencode: enable scroll acceleration`
   - `ghostty: add cursor shader`
4. Push to backup

## macOS Notes

- Quote paths with spaces: `"Library/Application Support/"`
- Use `~/Library` shorthand
- Some apps need full paths: `/Users/$USER/Library/...`

## Creating Symlinks

```bash
# Remove existing file/dir first
rm -rf "~/path/to/target"

# Create symlink
ln -s "$(pwd)/path/in/repo" "~/path/to/target"
```

## Adding New Configurations

**Shell alias:**
```nushell
# In Library/Application Support/nushell/config.nu
alias myalias = 'command here'
```

**Opencode plugin:**
```javascript
// In .config/opencode/plugin/my-plugin.js
export const MyPlugin = async ({ $ }) => ({
  event: async ({ event }) => { /* logic */ },
});
```

## Cursor/Copilot Rules

**None found.** No `.cursorrules`, `.cursor/rules/`, or `.github/copilot-instructions.md` files exist in this repository.
