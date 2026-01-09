# Harmony Stack Cheatsheet (macOS + zsh + iTerm2 + tmux + Cursor)

Here’s a **quick, practical cheatsheet** for a full terminal setup (**iTerm2 + tmux (Harmony session) + Cursor + Semantic History opener + yazi + rgv + diffs + git TUIs**) with **commands + keystrokes**.

## Legend

- **⌘** = Command, **⌥** = Option/Alt, **⌃** = Control
- **tmux prefix** = whatever you use (most common):
  - Default: **⌃b**
  - If you switched to Ctrl-a: **⌃a**
- I’ll write it as: **prefix + key**

---

## 1) Start / attach to your persistent tmux session

### From iTerm2 (Harmony profile)

- Open a new tab/window with profile **Harmony (tmux)**
- It runs:

```tmux
tmux new-session -A -s harmony
```

### From any terminal (manual)

```tmux
tmux new -As harmony
```

### List sessions

```tmux
tmux ls
```

### Detach (leave session running)

- **prefix + d**

### Kill session (careful)

```tmux
tmux kill-session -t harmony
```

---

## 2) tmux panes + windows (multi-pane muscle memory)

### Create panes

- Split horizontally (left/right):

  - **prefix + |**
- Split vertically (top/bottom):

  - **prefix + -**

### Move between panes

- **prefix + h/j/k/l** (left/down/up/right)

### Resize panes (quick + common)

If you didn’t bind resize keys, use built-ins:

- **prefix + ⌥ + Arrow** (often works depending on terminal settings)
  Or enter resize mode:
- **prefix + :** then type:

  ```tmux
  resize-pane -L 10
  ```

  (change direction/amount as needed)

### Create windows (tabs)

- **prefix + c** = new window
- **prefix + n / p** = next/prev window
- **prefix + 1..9** = jump to window number

### Rename window

- **prefix + ,**

---

## 3) “Long Claude Code run” pattern (recommended layout)

### In `harmony` session

Window 1: **Agent + logs**

- Pane A: run Claude Code / agent
- Pane B: tail logs / run greps

Example:

```tmux
# Pane A
claude
# or whatever your Claude Code entrypoint is

# Pane B (logs)
tail -f /path/to/logfile
```

Window 2: **Build/tests**

```tmux
npm test -- --watch
# or
pytest -q
# or
go test ./...
```

Window 3: **Files + Git**

- Pane A: `y` (yazi)
- Pane B: `lazygit`

---

## 4) Cursor integration (open files fast)

### A) From terminal output inside Cursor terminal

Make output look like:

- `path/to/file:line:col`

Use:

```tmux
rgv "pattern"
```

Example:

```tmux
rgv "TODO"
```

Output:

```tmux
src/main.ts:12:3:    // TODO: refactor
```

**Open it:**

- Hold **⌘** and click `src/main.ts:12:3`

### B) From iTerm2 anywhere (Semantic History)

If you see:

```tmux
src/main.ts:12
```

Open it:

- **⌘-click**
  If tmux mouse ever eats it:
- **⌥⌘-click**

Your script parses `file:line[:col]` and opens Cursor at the right location.

### C) Direct “goto” from shell

```tmux
code -g src/main.ts:12:3
```

(If `code` isn’t available, `cursor src/main.ts` still opens the file.)

---

## 5) Search → pick result → jump (fast triage)

### Clickable search

```tmux
rgv "Error:"
```

Then **⌘-click** the result.

### Optional fzf picker flow (if you added `cj`)

```tmux
cj TODO
```

- Use arrows to select
- Press **Enter**
- Cursor opens at the right location

---

## 6) File navigation + management (yazi)

### Launch

```tmux
y
```

### Common keys (good defaults)

- **↑/↓**: move selection
- **Enter**: open directory
- **Backspace**: parent directory
- **Space**: select/multi-select (if enabled by config)
- **O**: “Open with…” (choose Cursor / nvim opener if configured)
- **q**: quit

**Magic behavior you enabled:** when you exit yazi with `q`, your shell **cd’s to the last directory** you were browsing.

---

## 7) Diffing + reviewing changes

### Beautiful diffs with delta (pager)

```tmux
git diff
git show
```

(These will be “prettified” through delta if you set it as pager.)

### Structural diffs with difftastic (git difftool)

```tmux
git difftool
```

### Quick one-off difftastic

```tmux
difft fileA fileB
```

### Quick in-editor diff (nvim)

```tmux
nvim -d fileA fileB
```

---

## 8) Git workflow (lazygit)

Launch:

```tmux
lazygit
```

Common flow:

- stage hunks/files
- commit
- view diffs
- switch branches

It’s perfect in a tmux pane.

---

## 9) “Something’s eating my clicks” (tmux mouse)

### Toggle tmux mouse (if you added the binding)

- **prefix + m**
  You should see:
- `tmux mouse: ON` / `OFF`

If you need to do it manually:

```tmux
tmux set -g mouse off
# later
tmux set -g mouse on
```

---

## 10) Recovery / persistence playbook

### Detach without stopping anything

- **prefix + d**

### Reattach later

```tmux
tmux attach -t harmony
# or
tmux new -As harmony
```

### If using tmux-resurrect

- Save:

  - **prefix + ⌃s**
- Restore:

  - **prefix + ⌃r**

---

## “One perfect loop” example (end-to-end)

1. Open iTerm2 **Harmony (tmux)** → lands in tmux session
2. Split panes: **prefix + |**
3. In left pane, run Claude Code / agent
4. In right pane, search errors:

   ```tmux
   rgv "TypeError|Exception|ERROR"
   ```

5. **⌘-click** a result like `src/api/foo.ts:88:17` → Cursor opens exactly there
6. Edit in Cursor
7. Back to terminal:

   ```tmux
   git diff
   lazygit
   ```

8. Navigate files quickly:

   ```tmux
   y
   ```

   press **O** → “Open in Cursor”
9. Detach when done: **prefix + d** (everything keeps running)
