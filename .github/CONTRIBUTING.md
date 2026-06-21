# Contributing to The Claude Key

Thanks for your interest in contributing! This is a small macOS utility, so the
process is light. This document explains how to get set up and propose changes.

## Code of Conduct

This project is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By
participating you agree to uphold it. Report unacceptable behavior to
jaime.ortc@gmail.com.

## Getting set up

There's no build step — it's shell scripts plus an Automator workflow.

```bash
git clone https://github.com/JaimeOrtegaxyz/the-claude-key.git
cd the-claude-key
```

To try your changes on your own Mac, run the installer (it's idempotent and
needs no `sudo`):

```bash
./install.sh     # press F13 to test, then ./uninstall.sh to revert
```

## Before you push

This repo is intentionally dependency-free, so the checks are simple:

- **Lint the shell scripts** with [ShellCheck](https://www.shellcheck.net/):
  ```bash
  shellcheck install.sh uninstall.sh
  ```
  (`start-claude.sh` is a zsh script and is exempt from ShellCheck.)
- **Validate the workflow XML** is well-formed:
  ```bash
  xmllint --noout claudeGhostty.workflow/Contents/*.plist claudeGhostty.workflow/Contents/document.wflow
  ```
- **Test by hand**: run `./install.sh`, press F13, confirm Claude Code opens in a
  new Ghostty window, then `./uninstall.sh`.

CI runs ShellCheck and the XML check on every push and pull request.

## Making a change

1. **Open an issue first** for anything non-trivial, so we can agree on the
   approach before you invest time.
2. Fork the repo and create a branch: `git checkout -b feature/short-description`.
3. Keep it focused — one logical change per pull request.
4. Use clear commit messages (we follow
   [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`,
   `docs:`, `refactor:`, `chore:`).

## Submitting a pull request

- Push your branch and open a PR against `main`.
- Fill out the PR template and link the issue it closes.
- CI must be green before a PR can be merged.

## Developer Certificate of Origin

By contributing, you certify that you wrote the code or otherwise have the right
to submit it under the project's license. Sign off your commits with
`git commit -s` (adds a `Signed-off-by:` line).
