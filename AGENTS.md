Personal dotfiles repository for machine configuration files. All files are symlinked from this repo to `~`.

Example mappings:

- `.zshrc` → `~/.zshrc`
- `.config/opencode/` → `~/.config/opencode/`
- `Library/Application Support/` → `~/Library/Application Support/`

## Theming

Current custom theme: **Pierre Dark Soft**. When refreshing or replacing a theme, use upstream files as the source of truth instead of hand-editing colors without a source.

### Current Sources

- Themes: `https://github.com/pierrecomputer/theme`
- Icons: `https://github.com/pierrecomputer/vscode-icons`
- Base icon project: `https://github.com/pierrecomputer/icons`

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
mise exec -- bat cache --build
mise exec -- bat --list-themes | rg -x 'Pierre Dark Soft'
mise exec -- delta --list-syntax-themes | rg 'Pierre Dark Soft'
mise exec -- nu -c 'source "Library/Application Support/nushell/config.nu"'
mise exec -- hx --health
ruby -ryaml -e 'YAML.load_file("Library/Application Support/lazygit/config.yml")'
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```
