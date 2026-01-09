# Harmony Theme for Cursor

A Cursor color theme extension featuring both light and dark variants.

## Themes

- **Harmony Dark**: Soothing dark theme for extended coding sessions
- **Harmony Light**: Clean light theme with strong contrast
- **Harmony Markdown Light**: Paper-like light variant tuned for markdown readability (headings, quotes, links, code blocks)

## Install in Cursor (recommended)

From the repo root:

```bash
node scripts/install-cursor-harmony-theme.js
```

Then **fully quit Cursor** (Cmd+Q) and reopen it. Select the theme via:

- Command Palette → **Preferences: Color Theme** → **Harmony Dark** / **Harmony Light** / **Harmony Markdown Light**

## Uninstall

From the repo root:

```bash
node scripts/install-cursor-harmony-theme.js --uninstall
```

## Customizing / adding more schemes

See `docs/development/cursor-theme.md` for:

- Updating theme colors (`"colors"` and `"tokenColors"`)
- Adding additional theme variants (registering new JSON files in `package.json`)

## Troubleshooting

If the themes don’t appear after restarting Cursor:

- **Confirm install path**: Cursor expects extensions in `~/.cursor/extensions/<publisher>.<name>-<version>/`.
  - For this repo, that is typically `~/.cursor/extensions/harmony.harmony-theme-1.0.0/`.
- **If you previously tried installing and it was removed**: Cursor may have marked it as obsolete.
  - Check `~/.cursor/extensions/.obsolete` and remove `harmony.harmony-theme-1.0.0` if present.
- **Profiles**: Cursor uses profiles; the installer registers the theme for any profile found under:
  - macOS: `~/Library/Application Support/Cursor/User/profiles/*/extensions.json`

## Files

- **Extension manifest**: `packages/theme-pack/package.json`
- **Theme definitions**: `packages/theme-pack/themes/harmony-dark.json`, `packages/theme-pack/themes/harmony-light.json`, `packages/theme-pack/themes/harmony-markdown-light.json`
