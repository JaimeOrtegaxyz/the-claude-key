#!/bin/bash
# Installs the F13 -> "Claude in Ghostty" launcher on this Mac.
# Idempotent: safe to re-run. Does not require sudo.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$HOME/Library/Scripts"
SERVICES_DIR="$HOME/Library/Services"
WF="claudeGhostty.workflow"
LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"

echo "==> Installing Claude-in-Ghostty F13 launcher"

# --- 1. Prerequisite checks (warn only) ---
[ -d "/Applications/Ghostty.app" ] || echo "  ! WARNING: /Applications/Ghostty.app not found — install Ghostty first."
if ! command -v claude >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/claude" ]; then
  echo "  ! WARNING: 'claude' CLI not found in PATH or ~/.local/bin — install Claude Code first."
fi

# --- 2. start-claude.sh (runs inside the new Ghostty window) ---
mkdir -p "$SCRIPTS_DIR"
cp "$REPO_DIR/start-claude.sh" "$SCRIPTS_DIR/start-claude.sh"
chmod +x "$SCRIPTS_DIR/start-claude.sh"
echo "  installed $SCRIPTS_DIR/start-claude.sh"

# --- 3. Automator Quick Action (the Service), with $HOME substituted in ---
mkdir -p "$SERVICES_DIR"
rm -rf "$SERVICES_DIR/$WF"
cp -R "$REPO_DIR/$WF" "$SERVICES_DIR/$WF"
sed -i '' "s|__HOME__|$HOME|g" "$SERVICES_DIR/$WF/Contents/document.wflow"
echo "  installed $SERVICES_DIR/$WF"

# --- 4. Register the service so macOS Services sees it ---
[ -x "$LSREGISTER" ] && "$LSREGISTER" -f "$SERVICES_DIR/$WF" 2>/dev/null || true

# --- 5. Bind F13 to the service in pbs.plist (key_equivalent = U+F710 = NSF13FunctionKey) ---
python3 - <<'PY'
import plistlib, os
p = os.path.expanduser('~/Library/Preferences/pbs.plist')
try:
    with open(p, 'rb') as f: d = plistlib.load(f)
except FileNotFoundError:
    d = {}
st = d.setdefault('NSServicesStatus', {})
st['(null) - claudeGhostty - runWorkflowAsService'] = {
    'key_equivalent': '',  # F13. F14='', F15='', ...
    'presentation_modes': {'ContextMenu': True, 'ServicesMenu': True, 'TouchBar': True},
}
with open(p, 'wb') as f: plistlib.dump(d, f, fmt=plistlib.FMT_BINARY)
print('  bound F13 -> claudeGhostty in', p)
PY

# --- 6. Reload caches so the binding takes effect ---
killall cfprefsd 2>/dev/null || true
killall pbs 2>/dev/null || true

cat <<'EOF'
==> Done.

Press F13 to test. On the FIRST run you may see one-time prompts — click Allow:
  - an Automation prompt ("... wants to control Ghostty")
  - Ghostty asking to allow executing start-claude.sh

If F13 does nothing, open:
  System Settings > Keyboard > Keyboard Shortcuts > Services
  and confirm "claudeGhostty" is enabled / shows F13 (toggle it once if needed),
  or log out and back in so the Services hotkey registers.
EOF
