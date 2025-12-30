# DOTFILES KNOWLEDGE BASE

**Generated:** 2025-12-30 14:54
**Commit:** a9828ce
**Branch:** main

## OVERVIEW

Personal development environment configs for AI-assisted coding workflow. Minimal setup focused on Nushell shell, OpenCode AI editor, and container tooling (Colima/Lima).

## STRUCTURE

```
dotfiles/
├── .config/opencode/
│   ├── opencode.json              # OpenCode AI editor main config
│   └── oh-my-opencode.json        # Oh-My-OpenCode agent configuration
├── .local/share/fish/vendor_completions.d/  # Fish shell completions
│   ├── colima.fish                     # Colima container runtime
│   └── limactl.fish                    # Lima VM manager
└── Library/Application Support/        # macOS app support paths
    ├── nushell/config.nu               # Nushell shell config
    └── carapace/bridges.yaml           # Carapace completion bridge
```

## WHERE TO LOOK

| Task              | Location                                              |
| ----------------- | ----------------------------------------------------- |
| Shell setup       | `~/Library/Application Support/nushell/config.nu`     |
| AI editor config  | `~/.config/opencode/opencode.json`                    |
| Agent config      | `~/.config/opencode/oh-my-opencode.json`              |
| Shell completions | `~/.local/share/fish/vendor_completions.d/`           |
| Completion bridge | `~/Library/Application Support/carapace/bridges.yaml` |

## CONVENTIONS

- **macOS paths**: Uses `~/Library/Application Support/` for app configs
- **XDG compliant**: Fish completions at `~/.local/share/fish/vendor_completions.d/`
- **Nushell modules**: Each tool (starship, mise, zoxide, carapace, yazi) gets its own autoload file
- **Version reference**: Nushell config documents version 0.109.1

## ANTI-PATTERNS (THIS PROJECT)

- **No traditional dotfiles**: No .bashrc, .zshrc, .gitconfig, .vimrc
- **No automation**: No symlink scripts, Makefile, or bootstrap mechanism
- **No documentation**: No README, no setup instructions
- **Hardcoded paths**: `/opt/homebrew/bin`, `~/.amp/bin`, `~/.local/bin`

## DEPENDENCIES

Required tools for full functionality:

- Nushell 0.109.1+
- Starship prompt
- Mise version manager
- Zoxide smart cd
- Carapace completion bridge
- Yazi file manager
- OpenCode AI editor
- Colima + Lima (container/VM)
- Fish shell (for completions)

## SYMLINK STRUCTURE

This repo mirrors actual home locations:

- `~/Library/Application Support/nushell/config.nu` → `dotfiles/Library/Application Support/nushell/config.nu`
- `~/Library/Application Support/carapace/bridges.yaml` → `dotfiles/Library/Application Support/carapace/bridges.yaml`
- `~/.config/opencode/opencode.json` → `dotfiles/.config/opencode/opencode.json`
- `~/.config/opencode/oh-my-opencode.json` → `dotfiles/.config/opencode/oh-my-opencode.json`
- `~/.local/share/fish/vendor_completions.d/*` → `dotfiles/.local/share/fish/vendor_completions.d/`

## NOTES

- Manual symlink or copy required for deployment
- 1 commit only - fresh repository
- No version compatibility checks for Nushell upgrades
