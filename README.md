# claude-ghostty-launcher

Press **F13** -> a new [Ghostty](https://ghostty.org) window opens running **Claude Code**.

The new window is created **inside the already-running Ghostty instance** (via Ghostty's
AppleScript interface), so it never spawns a second app instance -- which means macOS never
restores/duplicates your existing windows, and your normal Ghostty window-restore behavior
is left untouched.

```
F13 (macOS Services hotkey)
  -> claudeGhostty Automator Quick Action
       -> osascript: tell Ghostty to open a new window
            -> runs start-claude.sh  ->  exec claude
```

## Prerequisites

- macOS (uses Automator Services + `pbs` + AppleScript)
- [Ghostty](https://ghostty.org) at `/Applications/Ghostty.app` (1.3+; needs the AppleScript dictionary)
- [Claude Code](https://claude.com/claude-code) `claude` on your `PATH` or at `~/.local/bin/claude`
- A way to actually press **F13** (a full keyboard, or remap a key to F13 in Karabiner-Elements)

## Install

```sh
git clone <this-repo>
cd claude-ghostty-launcher
./install.sh
```

The installer:
1. copies `start-claude.sh` -> `~/Library/Scripts/`
2. copies `claudeGhostty.workflow` -> `~/Library/Services/` (substituting your `$HOME`)
3. registers the Service and binds **F13** to it in `~/Library/Preferences/pbs.plist`
4. reloads `pbs`/`cfprefsd`

### First run
The first F13 may show one-time prompts -- click **Allow**:
- an Automation prompt ("... wants to control Ghostty")
- Ghostty asking to allow executing `start-claude.sh`

If F13 does nothing, open **System Settings -> Keyboard -> Keyboard Shortcuts -> Services**,
confirm **claudeGhostty** is enabled (toggle once if needed), or log out/in so the hotkey registers.

## Customize

- **The command** -- edit `start-claude.sh`. It currently runs
  `exec claude --dangerously-skip-permissions`; change flags/model/`cd` target here.
  Re-run `./install.sh` after editing.
- **The hotkey** -- the binding is the `key_equivalent` in `install.sh`, set to codepoint
  **U+F710** (F13). For another key change that codepoint in the Python block
  (F14 = U+F711, F15 = U+F712, ...), or just set it by hand in
  System Settings -> Keyboard Shortcuts -> Services after installing.

## Uninstall

```sh
./uninstall.sh
```

## How the no-duplication trick works

Earlier versions used `open -na Ghostty --args -e start-claude.sh`. The `-n` forces a **new
Ghostty instance**, and a fresh instance re-restores all your open windows (so the first F13
after a reboot duplicated every window). On macOS there's no way to open a new window *with a
command* in the existing instance via `open`/the CLI, so instead we drive Ghostty's AppleScript
dictionary (`new surface configuration` + `command`, `new window with configuration`,
`activate window`) -- which targets the running instance and never triggers restoration.
