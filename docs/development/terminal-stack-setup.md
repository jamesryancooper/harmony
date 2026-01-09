# Harmony Terminal Stack Setup Guide (macOS + zsh + iTerm2 + tmux + Cursor)

## What you get

After completing this guide, a developer can:

- Open iTerm2 → “Harmony (tmux)” profile → instantly attach to **persistent tmux session** `harmony`
- Use **tmux panes/windows** for long-running Claude Code runs
- **Cmd-click** `src/foo.ts:12:3` in iTerm2 → Cursor opens at the right location
- Use `rgv` to print clickable `file:line:col` results in Cursor terminal
- Use **yazi** for file navigation/management and open files in Cursor
- Use `delta` for nice diffs, `difftastic` for structural diffs, `lazygit` for TUI git

---

## Prerequisites

- macOS
- zsh (default on macOS)
- Homebrew installed
- Cursor installed
- iTerm2 installed

---

# 1) Install packages

## 1.1 Homebrew packages

Run:

```bash
brew install tmux fzf ripgrep fd yazi bat eza lazygit git-delta difftastic
```

Notes:

- `bat/eza` are optional but nice (previews + listings).
- `lazygit` is optional but recommended.

---

# 2) Enable Cursor CLI commands (critical)

In **Cursor**, open the Command Palette and install shell commands:

- **Install `cursor` to shell**
- **Install `code` to shell** (VS Code-compatible)

Verify in a terminal:

```bash
which cursor
which code
cursor --help | head -n 1
code --help | head -n 1
```

If either `which` returns nothing, re-run the install-from-Cursor step.

---

# 3) tmux configuration (persistence + multi-pane)

## 3.1 Install TPM (tmux plugin manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 3.2 Create `~/.tmux.conf`

Create/edit:

```bash
cursor ~/.tmux.conf
```

Paste this (works well; includes pane keys and mouse toggle message):

```tmux
# --- basics ---
set -g mouse on
set -g history-limit 200000
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on

# Splits
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Pane navigation (vim-ish)
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Reload config
bind r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded"

# Mouse toggle (shows ON/OFF message)
bind m if -F '#{==:#{mouse},on}' \
  'set -g mouse off \; display-message "tmux mouse: OFF"' \
  'set -g mouse on  \; display-message "tmux mouse: ON"'

# --- plugins (TPM) ---
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Persistence
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'

# Keep this line last
run '~/.tmux/plugins/tpm/tpm'
```

## 3.3 Start tmux + install plugins

Start tmux:

```bash
tmux
```

Then inside tmux press:

- **prefix + I** (capital i) to install plugins

Default tmux prefix is **Ctrl-b** unless the user changed it.

### Verify persistence keys

tmux-resurrect defaults:

- Save: **prefix + Ctrl-s**
- Restore: **prefix + Ctrl-r**

---

# 4) zsh setup (`~/.zshrc` helpers)

Edit:

```bash
cursor ~/.zshrc
```

Add these:

```zsh
# ripgrep output with file:line:col (very clickable)
alias rgv='rg --vimgrep'

# attach/create the persistent session
alias th='tmux new -As harmony'

# yazi wrapper: cd follows yazi on exit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi --cwd-file="$tmp" "$@"
  if [[ -f "$tmp" ]]; then
    local cwd
    cwd="$(cat -- "$tmp")"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd -- "$cwd"
    rm -f -- "$tmp"
  fi
}
```

Reload shell config:

```bash
source ~/.zshrc
```

> Important: **Do not** paste yazi TOML config (`[opener]`, `[open]`) into `.zshrc`. That belongs in `~/.config/yazi/yazi.toml`.

---

# 5) iTerm2 profile: “Harmony (tmux)”

## 5.1 Create the profile

In iTerm2:

- Settings → Profiles → **+**
- Name: **Harmony (tmux)**

Set:

- **Command**: ✅ “Command”
- Value:

```bash
/bin/zsh -lc "exec tmux new-session -A -s harmony"
```

This ensures every new tab/window immediately attaches to the same persistent tmux session.

---

# 6) iTerm2 Cmd-click → open in Cursor at file:line

## 6.1 Create the opener script

Run:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/iterm-open-cursor <<'SH'
#!/usr/bin/env bash
set -u  # (do not use -e; we always want exit 0 so iTerm doesn't pop errors)

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

raw="${1:-}"
line_arg="${2:-}"
cwd="${3:-$PWD}"

file="$raw"
line=""
col=""

# If iTerm didn't provide a line number, parse common patterns:
#  - file:123
#  - file:123:45
#  - file(123)
if [[ -z "$line_arg" ]]; then
  if [[ "$raw" =~ ^(.+):([0-9]+)(:([0-9]+))?$ ]]; then
    file="${BASH_REMATCH[1]}"
    line="${BASH_REMATCH[2]}"
    col="${BASH_REMATCH[4]:-}"
  elif [[ "$raw" =~ ^(.+)\(([0-9]+)\)$ ]]; then
    file="${BASH_REMATCH[1]}"
    line="${BASH_REMATCH[2]}"
  fi
else
  line="$line_arg"
fi

line="${line:-1}"
col="${col:-1}"

# Expand ~
file="${file/#\~/$HOME}"

# Resolve relative paths against iTerm's recorded cwd when available
if [[ "$file" != /* && -n "$cwd" ]]; then
  file="$cwd/$file"
fi

# Try VS Code-compatible goto first, then cursor, then open app
if command -v code >/dev/null 2>&1; then
  code -g "$file:$line:$col" >/dev/null 2>&1 && exit 0
fi
if command -v cursor >/dev/null 2>&1; then
  cursor "$file" >/dev/null 2>&1 && exit 0
fi

open -a "Cursor" "$file" >/dev/null 2>&1
exit 0
SH

chmod +x ~/.local/bin/iterm-open-cursor
```

## 6.2 Enable Cmd-click behavior in iTerm2

iTerm2 Settings → Pointer (or Pointer → General):

- Enable **Cmd-click opens filename/URL** (wording varies slightly by version)

## 6.3 Set Semantic History for the Harmony profile

iTerm2 Settings → Profiles → **Harmony (tmux)** → Advanced → **Semantic History**

Set to:

- **Always run command…**
- Command:

```bash
~/.local/bin/iterm-open-cursor "\1" "\2" "\5"
```

## 6.4 Recommended: Install iTerm2 Shell Integration

This improves iTerm’s working-directory tracking (helps relative paths like `src/a.ts:12`).
In iTerm2 menu: **Install Shell Integration**, then open a new tab.

---

# 7) yazi config: open in Cursor / nvim

Create:

```bash
mkdir -p ~/.config/yazi
cursor ~/.config/yazi/yazi.toml
```

Paste:

```toml
[opener]
edit_in_cursor = [
  { run = 'cursor "$@"', orphan = true, desc = "Open in Cursor" }
]
edit_in_nvim = [
  { run = 'nvim "$@"', block = true, desc = "Edit in nvim" }
]

[open]
rules = [
  { name = "*", use = [ "edit_in_cursor", "edit_in_nvim" ] },
]
```

Usage in yazi:

- `y` to launch
- Press `O` (open with) → choose Cursor

---

# 8) Diffing + git tools

## 8.1 delta as git pager

```bash
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
```

## 8.2 difftastic as a git difftool

Add to `~/.gitconfig`:

```ini
[difftool "difftastic"]
    cmd = difft "$LOCAL" "$REMOTE"
[diff]
    tool = difftastic
[difftool]
    prompt = false
```

Use:

```bash
git difftool
```

## 8.3 lazygit

Run:

```bash
lazygit
```

---

# 9) Verification checklist (do these tests)

## 9.1 tmux persistence

Open iTerm2 “Harmony (tmux)” → you should be in tmux.

Detach:

- **prefix + d**

Reopen profile → should reattach to same session.

## 9.2 iTerm2 Cmd-click opens Cursor at line

Run in iTerm2:

```bash
echo "$HOME/.zshrc:1"
```

Cmd-click it → Cursor opens at line 1.

Then test relative path (from a repo root that has this file):

```bash
echo "src/main.ts:12:3"
```

Cmd-click → Cursor opens at location (requires `\5` cwd tracking to be correct).

## 9.3 Cursor terminal click-to-open from ripgrep

In Cursor terminal:

```bash
rgv "TODO"
```

Cmd-click a `file:line:col` match → Cursor opens there.

## 9.4 yazi opener

```bash
y
```

Select a file → press `O` → “Open in Cursor”.

---

# 10) Daily usage cheat commands

- Attach/create persistent session:

  ```bash
  th
  ```

- Toggle tmux mouse (if clicks get “eaten” by tmux):

  - **prefix + m**  (shows “tmux mouse: ON/OFF”)

- Split panes:

  - **prefix + |** (left/right)
  - **prefix + -** (top/bottom)

- Move panes:

  - **prefix + h/j/k/l**

- Search clickable results:

  ```bash
  rgv "pattern"
  ```

- File manager:

  ```bash
  y
  ```

- Pretty diff:

  ```bash
  git diff
  ```

- Structural diffs:

  ```bash
  git difftool
  ```

- Git UI:

  ```bash
  lazygit
  ```

---

## Troubleshooting

### iTerm2 shows “Semantic History Command Failed”

- Ensure the script is executable:

  ```bash
  ls -l ~/.local/bin/iterm-open-cursor
  ```

* Ensure Cursor CLI commands exist:

  ```bash
  which code cursor
  ```

* Ensure Semantic History is set to **Always run command…**

### Cmd-click does nothing

- Enable iTerm2 pointer setting: Cmd-click opens filename/URL
- In tmux with mouse on, try **Option+Cmd-click**
- Or toggle tmux mouse off: **prefix + m**

### `source ~/.zshrc` error mentioning `[opener]`

- You accidentally pasted TOML into `.zshrc`. Move that config into `~/.config/yazi/yazi.toml`.
