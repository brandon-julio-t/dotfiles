# AGENTS.md

This file contains guidelines for agentic coding agents working in this dotfiles repository.

## Repository Overview

This is a personal dotfiles repository that serves as a backup and version control for machine configuration files. All files in this repository are intended to be symlinked to their corresponding locations in the home directory (`~`).

**Important:** The folder structure is relative to `~`, so:
- `.zshrc` in this repo → `~/.zshrc`
- `.config/opencode/` → `~/.config/opencode/`
- `Library/Application Support/` → `~/Library/Application Support/`

## Installation/Setup

Files are installed by creating symlinks from the repository to the home directory. This repository does not contain any build scripts, tests, or development tooling - it's purely a configuration backup.

### Creating Symlinks

To symlink a file or directory from this repo to the home directory:

```bash
# Remove existing file/dir if present
rm -rf "~/path/to/target"

# Create symlink
ln -s "$(pwd)/path/in/repo" "~/path/to/target"
```

## File Structure

```
.
├── .config/
│   ├── opencode/                   # opencode configuration and plugins
│   │   ├── opencode.json           # Main opencode config
│   │   └── plugin/                 # Custom opencode plugins
│   │       ├── notification.js     # Desktop notifications on session complete
│   │       └── env-protection.js   # Prevents reading .env files
│   └── ghostty/
│       ├── config                  # Ghostty terminal config
│       └── shaders/               # Ghostty terminal shaders
│           └── cursor_blaze.glsl
├── .local/
│   └── share/
│       └── fish/
│           └── vendor_completions.d/  # Fish shell completions
├── Library/
│   └── Application Support/       # macOS application configurations
│       ├── lazygit/config.yml     # Lazygit UI configuration
│       ├── nushell/               # Nushell shell configuration
│       │   ├── config.nu          # Main nushell config
│       │   └── vendor/autoload/   # Auto-loaded scripts (symlinked)
│       │       ├── atuin.nu
│       │       ├── atuin-completions.nu
│       │       ├── fish.nu
│       │       ├── mise.nu
│       │       ├── starship.nu
│       │       └── zoxide.nu
│       └── com.mitchellh.ghostty/config  # Ghostty macOS config
├── .gitconfig                     # Git global configuration
├── .zshrc                         # Zsh shell configuration
├── .gitattributes                 # Git LFS configuration
└── README.md -> AGENTS.md         # Repository documentation
```

## Key Configurations

- **Shell**: Zsh with mise activation, Nushell as alternative
- **Git**: Global git configuration with LFS support
- **Development Tools**: opencode (AI coding assistant), ghostty (terminal), lazygit (git UI), mise (version manager)
- **Custom Scripts**: opencode plugins for notifications and environment protection

## Build/Lint/Test Commands

**This repository contains no build system, tests, or linting.**

As a dotfiles repository, changes are configuration-only. To "test" changes:

1. **Shell configs** (`.zshrc`, `*.nu`): Source or restart the shell
   ```bash
   source ~/.zshrc        # For zsh
   exec nu                # For nushell (restart)
   ```

2. **Application configs**: Reload or restart the application

3. **Validate syntax** before committing:
   - Nushell: `nu -c 'source config.nu'` (or just try to load it)
   - JavaScript: Use your editor's linting
   - YAML: Use `yamllint` if available

## Code Style Guidelines

### General Principles

1. **Keep it minimal**: Only include essential configurations
2. **Comment purpose**: Add comments explaining non-obvious settings
3. **Version control friendly**: No machine-specific paths or secrets
4. **Cross-platform aware**: Consider macOS vs Linux differences

### JavaScript (Opencode Plugins)

- Use ES modules (`export const`)
- Async/await for asynchronous operations
- Destructure parameters for clarity
- Keep plugins focused and small

Example:
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

- Use 4-space indentation
- Prefer `$env.config` over `config` command
- Group related settings together
- Use kebab-case for custom commands
- Quote strings consistently with single quotes

Example:
```nushell
$env.config.buffer_editor = "zed"
$env.path ++= [
    "/opt/homebrew/bin",
    "~/.local/bin",
]

alias gst = git status
```

### YAML Configurations

- 2-space indentation
- No tabs
- Quote strings when they contain special characters
- Group related settings under common keys

### Naming Conventions

- **Files**: Use lowercase with hyphens (`env-protection.js`)
- **Aliases**: Short, memorable abbreviations (`gst` for `git status`)
- **Environment variables**: UPPER_CASE with underscores (`$env.EDITOR`)
- **Custom commands**: Descriptive, lowercase with hyphens (`rmf` for "remove force")

### Error Handling

- Nushell: Use `try/catch` for operations that might fail
- JavaScript: Always handle async errors appropriately
- Shell scripts: Use `set -e` or explicit error checking

### Security Guidelines

- **Never commit secrets**: No API keys, passwords, or tokens
- **No .env files**: The EnvProtection plugin prevents this
- **No sensitive paths**: Avoid hardcoding personal directories
- **Check before committing**: Review all changes for accidental secrets

## Git Workflow

1. Make configuration changes
2. Test locally by reloading/sourcing
3. Commit with descriptive messages:
   - `nushell: add new alias for git worktree`
   - `opencode: enable scroll acceleration`
4. Push to remote for backup

## macOS-Specific Notes

- `Library/Application Support/` paths have spaces - always quote them
- Use `~/Library` shorthand when possible
- Some configs may need full path: `/Users/$USER/Library/...`

## Testing Configurations

Since there's no automated test suite:

1. **Manual testing**: Apply changes and verify behavior
2. **Backup first**: Git provides version history
3. **Incremental changes**: Don't batch too many changes at once
4. **Document breaking changes**: Update comments if removing/changing significant settings

## Common Tasks

### Adding a new shell alias

Edit `Library/Application Support/nushell/config.nu` or `.zshrc`:
```nushell
alias myalias = 'full command here'
```

### Adding a new opencode plugin

Create file in `.config/opencode/plugin/`:
```javascript
export const MyPlugin = async ({ project, client, $ }) => {
  return {
    // Plugin hooks
  };
};
```

### Symlinking a new config file

```bash
# From repo root
ln -sf "$(pwd)/path/to/file" "$HOME/path/to/file"
```
