# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Pressing F13 while Ghostty is closed no longer opens an extra empty Ghostty window
  next to the Claude one: a cold start now launches Ghostty with the Claude command
  as its first window.

## [1.0.0] - 2026-06-21

### Added
- Initial public release.
- `install.sh` — installs the F13 → Claude Code in Ghostty launcher (idempotent, no sudo).
- `uninstall.sh` — cleanly removes the launcher and key binding.
- `start-claude.sh` — the command run inside the new Ghostty window.
- `claudeGhostty.workflow` — Automator Quick Action that opens Ghostty via AppleScript.

[Unreleased]: https://github.com/JaimeOrtegaxyz/the-claude-key/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/JaimeOrtegaxyz/the-claude-key/releases/tag/v1.0.0
