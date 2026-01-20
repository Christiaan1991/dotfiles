---
description: Sync OpenCode configuration with remote dotfiles repository
agent: shell-automation
---

Sync OpenCode config in /Users/chris/dotfiles with direction: $1

Available directions:
- status: Check git status of opencode/ directory and compare with remote
- pull: Pull latest changes from remote, stash if needed, restow package
- push: Stage opencode/ changes and show commit/push instructions

Execute the appropriate git commands and stow operations.
