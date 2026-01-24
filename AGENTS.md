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

## File Structure

```
.
├── .config/
│   ├── opencode/                   # opencode configuration and plugins
│   └── ghostty/
│       └── shaders/               # Ghostty terminal shaders
├── .local/
│   └── share/                     # Local shared configuration
├── Library/
│   └── Application Support/       # macOS application configurations
├── .gitconfig                     # Git global configuration
├── .zshrc                         # Zsh shell configuration
└── README.md -> AGENTS.md         # Repository documentation
```

## Key Configurations

- **Shell**: Zsh with mise activation
- **Git**: Global git configuration with LFS support
- **Development Tools**: opencode (AI coding assistant), ghostty (terminal), lazygit (git UI), carapace (shell completion)
- **Custom Scripts**: opencode plugins for notifications and environment protection

## Security Notes

- The EnvProtection opencode plugin prevents reading `.env` files
- No secrets should be committed to this repository
- Git LFS is configured for large binary files