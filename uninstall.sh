#!/bin/bash
# Removes The Claude Key (F13 -> Claude Code in Ghostty) from this Mac.
set -euo pipefail

rm -f  "$HOME/Library/Scripts/start-claude.sh"
rm -rf "$HOME/Library/Services/claudeGhostty.workflow"

python3 - <<'PY'
import plistlib, os
p = os.path.expanduser('~/Library/Preferences/pbs.plist')
try:
    with open(p, 'rb') as f: d = plistlib.load(f)
except FileNotFoundError:
    raise SystemExit
d.get('NSServicesStatus', {}).pop('(null) - claudeGhostty - runWorkflowAsService', None)
with open(p, 'wb') as f: plistlib.dump(d, f, fmt=plistlib.FMT_BINARY)
print('removed F13 binding from', p)
PY

killall cfprefsd 2>/dev/null || true
killall pbs 2>/dev/null || true
echo "Uninstalled. (Your other Ghostty windows / Services are untouched.)"
