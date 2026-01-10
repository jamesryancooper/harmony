# Installing the Harmony Theme in Cursor

This repo includes a Cursor/VS Code theme extension at `packages/theme-pack/` that provides:

- **Harmony Dark**
- **Harmony Light**

## Recommended install (one command)

From the repository root:

```bash
node scripts/install-cursor-harmony-theme.js
```

Then **fully quit Cursor** (Cmd+Q) and reopen it.

Select the theme via:

- Command Palette → **Preferences: Color Theme** → choose a Harmony theme (e.g. **Harmony Light**)

## Uninstall

From the repository root:

```bash
node scripts/install-cursor-harmony-theme.js --uninstall
```

## Updating theme colors

Edit the theme JSON files in the repo:

- `packages/theme-pack/themes/harmony-dark.json`
- `packages/theme-pack/themes/harmony-light.json`

Inside each file:

- **UI colors** are in the `"colors"` object
- **Syntax highlighting** rules are in the `"tokenColors"` array

After making changes, re-run the installer (it copies the extension into `~/.cursor/extensions/`):

```bash
node scripts/install-cursor-harmony-theme.js
```

Then **fully quit Cursor** (Cmd+Q) and reopen it.

## Terminal themes (iTerm2)

The repo also includes iTerm2 color presets:

- `packages/theme-pack/themes/Harmony Dark.itermcolors`
- `packages/theme-pack/themes/Harmony Light.itermcolors`

Import them in iTerm2 via:

- Preferences → Profiles → Colors → Color Presets… → Import

## Adding additional color schemes (new theme variants)

You can add more “color schemes” by adding additional theme JSON files and registering them in the extension manifest.

### 1) Create a new theme JSON file

Start by copying the closest existing theme:

```bash
cp packages/theme-pack/themes/harmony-dark.json packages/theme-pack/themes/harmony-dim.json
```

Then edit `packages/theme-pack/themes/harmony-dim.json`:

- Change the top-level `"name"` to the new scheme name (e.g. `"Harmony Dim"`)
- Update any `"colors"` and/or `"tokenColors"` values you want

### 2) Register the new theme in the extension `package.json`

Add a new entry to `packages/theme-pack/package.json` under `contributes.themes`:

```json
{
  "label": "Harmony Dim",
  "uiTheme": "vs-dark",
  "path": "./themes/harmony-dim.json"
}
```

Notes:

- `uiTheme` controls how Cursor categorizes the theme:
  - `"vs"` for light
  - `"vs-dark"` for dark
  - `"hc-light"` / `"hc-black"` for high-contrast
- The JSON file itself should include `"name"` so it displays nicely in theme pickers.

### 3) Reinstall + restart Cursor

After adding the file and updating `package.json`:

```bash
node scripts/install-cursor-harmony-theme.js
```

Then **fully quit Cursor** (Cmd+Q) and reopen it. Your new scheme should show up in:

- Command Palette → **Preferences: Color Theme**

## What the installer does

Cursor doesn’t reliably pick up extensions that are only copied into a folder. The installer makes the theme show up by:

- Copying the extension into Cursor’s extensions folder using the required naming convention:
  - `~/.cursor/extensions/<publisher>.<name>-<version>/`
- Registering the extension in Cursor’s extension lists:
  - `~/.cursor/extensions/extensions.json`
  - macOS profiles: `~/Library/Application Support/Cursor/User/profiles/*/extensions.json`
- Removing the extension from `~/.cursor/extensions/.obsolete` if Cursor previously marked it as removed

## Troubleshooting

If the themes don’t appear after restarting Cursor:

- Confirm the extension exists at:
  - `~/.cursor/extensions/harmony.harmony-theme-1.0.0/`
- Check `~/.cursor/extensions/.obsolete` and ensure it does **not** contain:
  - `harmony.harmony-theme-1.0.0`
