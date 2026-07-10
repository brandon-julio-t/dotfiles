Personal dotfiles repository for machine configuration files. All files are symlinked from this repo to `~`.

Example mappings:

- `.zshrc` → `~/.zshrc`
- `.config/opencode/` → `~/.config/opencode/`
- `Library/Application Support/` → `~/Library/Application Support/`

## Bootstrap

This repository uses mise as the primary entry point for tools, system packages,
and dotfile symlinks. Mise installs macOS bottles and supported casks into
`/opt/homebrew`; the declared bootstrap does not require the Homebrew CLI.
Clone the repo at `~/repos/dotfiles`, then run:

```bash
cd ~/repos/dotfiles
mise trust .config/mise/config.toml
mise bootstrap --dry-run --locked
mise bootstrap --locked --yes
mise bootstrap status --missing
```

If the dry run reports pre-existing dotfiles that should be replaced with
managed symlinks, add `--force-dotfiles` to the apply command after reviewing
the conflicts. The committed mise lockfile pins tool versions and download
checksums; macOS formulae and casks intentionally follow their current package
releases. The `up` command refreshes the lockfile when upgrading tools.

The Nushell `up` command is the explicit maintenance workflow: it updates mise,
upgrades configured tools and bootstrap packages, prunes unused mise versions,
refreshes the Docker Compose plugin link, restarts Colima, and regenerates shell
integrations. It uses unauthenticated GitHub access by default; if rate limited,
provide a dedicated, minimally scoped `MISE_GITHUB_TOKEN` rather than reusing
the token from `gh auth`. A preflight stops `up` before making changes when the
remaining API budget is too small for a complete version check.

## Theming

Current custom theme: **Pierre Dark Soft**. When refreshing or replacing a theme, use upstream files as the source of truth instead of hand-editing colors without a source.

### Current Sources

- Themes: `https://github.com/pierrecomputer/theme`
- Icons: `https://github.com/pierrecomputer/vscode-icons`
- Base icon project: `https://github.com/pierrecomputer/icons`

Last refreshed upstream commits on 2026-07-03:

- Themes: `afbdd447d005a783c2ab97d0c5e0131fb61a4379`
- Icons: `04a9028f0b227aaf820e9e73da2992af86ba0f26`
- Base icon project: `67f6c095220b4f9c77bf997f812aebe3b53e24f5`

### Local Files

- Zed: `.config/zed/settings.json`, `.config/zed/themes/pierre.json`, `.config/zed/extensions/pierre-icons/`
- Helix: `.config/helix/config.toml`, `.config/helix/themes/pierre_dark_soft.toml`
- Ghostty: `Library/Application Support/com.mitchellh.ghostty/config`, `.config/ghostty/themes/Pierre Dark Soft`
- Bat/delta: `.config/bat/themes/Pierre Dark Soft.tmTheme`
- LazyGit: `Library/Application Support/lazygit/config.yml`
- Nushell: `Library/Application Support/nushell/config.nu`
- Btop: `.config/btop/themes/pierre_dark_soft.theme`

### Update Notes

- Replace the Zed theme from the upstream theme file.
- Update Helix from the same upstream TextMate/VS Code theme colors.
- Convert the upstream TextMate/VS Code theme for bat/delta.
- Rebuild icons from the upstream icon pack and refresh the local Zed icon extension.
- Keep Ghostty, LazyGit, and btop on the same palette as the active editor theme.
- Use `mise` when running Node/npm-based icon tooling.

```bash
ruby -rjson -e 'JSON.parse(File.read(".config/zed/themes/pierre.json")); JSON.parse(File.read(".config/zed/extensions/pierre-icons/icon_themes/pierre-icons.json"))'
mise exec -- bat cache --build
mise exec -- bat --list-themes | rg -x 'Pierre Dark Soft'
mise exec -- delta --list-syntax-themes | rg 'Pierre Dark Soft'
mise exec -- nu -c 'source "Library/Application Support/nushell/config.nu"'
mise exec -- hx --health
ruby -ryaml -e 'YAML.load_file("Library/Application Support/lazygit/config.yml")'
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```
