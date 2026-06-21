# The Claude Key

<p align="center">
  <img src="claude-key.webp" alt="The Claude Key" width="220">
</p>

Press **F13** and Claude Code launches in a new [Ghostty](https://ghostty.org) window at your home directory, ready to type.

It's wired to my particular stack. Feel free to adapt it to yours.

## Prerequisites

- macOS (uses Automator Services + `pbs` + AppleScript)
- [Ghostty](https://ghostty.org) at `/Applications/Ghostty.app` (1.3+, for the AppleScript dictionary)
- [Claude Code](https://claude.com/claude-code) on your `PATH` or at `~/.local/bin/claude`
- A way to press **F13** (a full keyboard, or remap a key to F13 in Karabiner-Elements)

## Install

```sh
git clone <this-repo>
cd the-claude-key
./install.sh
```

The installer copies `start-claude.sh` to `~/Library/Scripts/`, installs the Automator Quick Action into `~/Library/Services/`, binds **F13** to it, and reloads `pbs`/`cfprefsd`.

### First run

The first F13 may show one-time prompts. Click **Allow**:

- an Automation prompt ("... wants to control Ghostty")
- Ghostty asking to allow executing `start-claude.sh`

If F13 does nothing, open **System Settings > Keyboard > Keyboard Shortcuts > Services**, confirm the action is enabled (toggle it once if needed), or log out and back in so the hotkey registers.

## Customize

- **The command:** edit `start-claude.sh`. It runs `exec claude --dangerously-skip-permissions`. Change the flags, model, or `cd` target here, then re-run `./install.sh`.
- **The hotkey:** the binding is the `key_equivalent` in `install.sh`, set to codepoint **U+F710** (F13). Change that codepoint for another key (F14 = U+F711, F15 = U+F712), or set it by hand in System Settings > Keyboard Shortcuts > Services.

## Uninstall

```sh
./uninstall.sh
```
