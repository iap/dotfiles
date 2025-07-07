#!/bin/sh
# Interactive shell environment loader
# POSIX-compatible for both bash and zsh
# Note: .profile should already have loaded the main environment

# Load local environment overrides for interactive shells only
if [ -f "$HOME/.config/env.d/default.local.sh" ]; then
  . "$HOME/.config/env.d/default.local.sh"
fi

# Ensure core environment is loaded if .profile wasn't sourced
# (fallback for non-login shells)
if [ -z "$OS_TYPE" ] && [ -f "$HOME/.config/env.d/default.sh" ]; then
  . "$HOME/.config/env.d/default.sh"
fi

# Load shared aliases (requires OS_TYPE to be set)
# Use shell-agnostic method to find dotfiles directory
if [ -n "$ZSH_VERSION" ]; then
  # Running in zsh
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  # Running in bash
  SHELL_CONFIG="$HOME/.bashrc"
else
  # Fallback for other POSIX shells
  SHELL_CONFIG="$HOME/.profile"
fi

ALIASES_PATH="$(dirname "$(readlink -f "$SHELL_CONFIG")")/shell.d/aliases.sh"
if [ -f "$ALIASES_PATH" ]; then
  . "$ALIASES_PATH"
fi
