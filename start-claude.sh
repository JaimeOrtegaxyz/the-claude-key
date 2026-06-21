#!/bin/zsh
cd ~
export PATH="$HOME/.local/bin:$PATH"
export CLAUDE_CODE_NO_FLICKER=1
exec claude --dangerously-skip-permissions
