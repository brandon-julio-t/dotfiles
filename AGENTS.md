# AGENTS.md - Dotfiles Development Guidelines

**Purpose:** Personal macOS development environment configs (Nushell, OpenCode AI editor, container tooling).

## WHERE TO LOOK

| Task                          | Location                                              |
|-------------------------------|-------------------------------------------------------|
| Shell setup                   | `~/Library/Application Support/nushell/config.nu`     |
| AI editor config              | `~/.config/opencode/opencode.json`                    |
| Agent configuration           | `~/.config/opencode/oh-my-opencode.json`              |
| Terminal config               | `~/Library/Application Support/com.mitchellh.ghostty/config` |
| Shell completions             | `~/.local/share/fish/vendor_completions.d/`           |
| Completion bridge             | `~/Library/Application Support/carapace/bridges.yaml` |

## Repository Structure

```
dotfiles/
├── .config/opencode/
│   ├── opencode.json              # OpenCode AI editor configuration
│   └── oh-my-opencode.json        # Oh-My-OpenCode agent settings
├── .local/share/fish/vendor_completions.d/
│   ├── colima.fish                # Fish completion for Colima
│   └── limactl.fish               # Fish completion for Lima
└── Library/Application Support/
    ├── nushell/config.nu          # Nushell shell configuration
    ├── carapace/bridges.yaml      # Carapace completion bridge config
    └── com.mitchellh.ghostty/config # Ghostty terminal configuration
```

## Build/Validation Commands

### JSON Files (opencode.json)
- **Validate JSON syntax:** `cat ~/.config/opencode/opencode.json | jq empty && echo "Valid JSON"`
- **Format JSON:** `jq . ~/.config/opencode/opencode.json > tmp.json && mv tmp.json ~/.config/opencode/opencode.json`

### Nushell Config (config.nu)
- **Check for syntax errors:** `nu -c "source ~/.config/nushell/config.nu"`
- **Validate module loading:** `nu -c "ls ($nu.data-dir | path join 'vendor/autoload/*.nu') | each { |f| nu -c \$'source ($f.path)' }"`

### Fish Completions (colima.fish, limactl.fish)
- **Lint Fish syntax:** `fish -n ~/.local/share/fish/vendor_completions.d/colima.fish`
- **Check completion loading:** `fish -c "complete -C 'colima '"`

### YAML Files (bridges.yaml)
- **Validate YAML syntax:** `yamllint ~/.Library/Application Support/carapace/bridges.yaml` (requires yamllint)
- **Check YAML syntax:** `python3 -c "import yaml; yaml.safe_load(open('~/.Library/Application Support/carapace/bridges.yaml'))"`

### Ghostty Config (config)
- **Validate syntax:** Ghostty will report errors on startup if the config is invalid
- **Check config location:** Verify symlink with `ls -la ~/Library/Application\ Support/com.mitchellh.ghostty/config`

## Code Style Guidelines

### General Principles
- Keep configurations minimal and focused
- Use comments to document non-obvious settings
- Prefer explicit over implicit configurations
- Mirror actual home directory paths (use ~ where appropriate)

### Nushell (config.nu)
- **Naming:** Lowercase with underscores for variables, hyphens for command names
- **Comments:** Use `#` for comments; include headers for major sections
- **Spacing:** Single space after `#` in comments
- **Line length:** Wrap at 100 characters where reasonable
- **Aliases:** Single-letter aliases for frequently used commands (e.g., `g` for git, `n` for npm)
- **Path handling:** Use `path join` for constructing paths, avoid hardcoded separators

Example:
```nushell
# Environment setup
$env.path ++= [
    "/opt/homebrew/bin",
    "~/.amp/bin",
    "~/.local/bin"
]

# Create the vendor directory if it doesn't exist
mkdir ($nu.data-dir | path join "vendor/autoload")
```

### JSON (opencode.json)
- **Formatting:** 2-space indentation, sorted keys
- **Naming:** camelCase for keys
- **Comments:** Not supported in JSON; use descriptive key names instead
- **Schema:** Include `$schema` for configuration files when available

### Fish Completions (*.fish)
- **Naming:** Prefix private functions with `__<program>_` (e.g., `__colima_debug`)
- **Comments:** Use `#` with a space after; describe function purpose
- **Functions:** Define helper functions before they're used
- **Error handling:** Use `2> /dev/null` to suppress expected errors in completions
- **Debugging:** Include debug functions (`__<program>_debug`) that write to `$BASH_COMP_DEBUG_FILE`

### YAML (bridges.yaml)
- **Formatting:** 2-space indentation, no trailing spaces
- **Comments:** Use `#` for comments
- **Structure:** Simple key-value pairs, avoid complex nesting

## Deployment

This repo mirrors actual home directory locations. Symlink files to enable automatic updates across devices.

### Symlink Installation

Run from the dotfiles repository root:

```bash
# OpenCode configuration
mkdir -p ~/.config/opencode
ln -sf "$(pwd)/.config/opencode/opencode.json" ~/.config/opencode/opencode.json
ln -sf "$(pwd)/.config/opencode/oh-my-opencode.json" ~/.config/opencode/oh-my-opencode.json

# Nushell configuration
mkdir -p ~/Library/Application\ Support/nushell
ln -sf "$(pwd)/Library/Application Support/nushell/config.nu" ~/Library/Application\ Support/nushell/config.nu

# Ghostty configuration
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
ln -sf "$(pwd)/Library/Application Support/com.mitchellh.ghostty/config" ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Carapace configuration
mkdir -p ~/Library/Application\ Support/carapace
ln -sf "$(pwd)/Library/Application Support/carapace/bridges.yaml" ~/Library/Application\ Support/carapace/bridges.yaml

# Fish shell completions
mkdir -p ~/.local/share/fish/vendor_completions.d
ln -sf "$(pwd)/.local/share/fish/vendor_completions.d/colima.fish" ~/.local/share/fish/vendor_completions.d/colima.fish
ln -sf "$(pwd)/.local/share/fish/vendor_completions.d/limactl.fish" ~/.local/share/fish/vendor_completions.d/limactl.fish
```

### Update Workflow

After making changes:
1. Commit and push from the dotfiles repo
2. On other machines: `cd /path/to/dotfiles && git pull`
3. Changes apply immediately (symlinks point to repo files)

## CONVENTIONS

- **macOS paths**: Uses `~/Library/Application Support/` for app configs
- **XDG compliant**: Fish completions at `~/.local/share/fish/vendor_completions.d/`
- **Terminal configs**: Ghostty at `~/Library/Application Support/com.mitchellh.ghostty/`
- **Nushell modules**: Each tool (starship, mise, zoxide, carapace, yazi) gets its own autoload file
- **Version reference**: Nushell config documents version 0.109.1

## ANTI-PATTERNS (THIS PROJECT)

- **No traditional dotfiles**: No .bashrc, .zshrc, .gitconfig, .vimrc
- **Hardcoded paths**: `/opt/homebrew/bin`, `~/.amp/bin`, `~/.local/bin`
- **No symlink automation**: Manual `ln -sf` commands only

## Important Notes

- No traditional build system (Makefile, npm scripts, etc.)
- No automated tests or CI/CD
- All configurations are manually maintained
- Nushell version reference: 0.109.1
