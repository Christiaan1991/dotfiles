---
description: Manage GNU Stow packages in dotfiles repository
agent: shell-automation
---

Manage GNU Stow packages in /Users/chris/dotfiles with action: $1 and package: $2

Available actions:
- list: Show available packages
- install: Install a package (requires package name)
- uninstall: Uninstall a package (requires package name)
- restow: Restow package(s) to update symlinks
- conflicts: Check for stow conflicts

Execute the appropriate stow command in the dotfiles directory.
