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
if [ -f "$(dirname "$(readlink -f "$HOME/.zshrc")")/../shell.d/aliases.sh" ] 2>/dev/null; then
  . "$(dirname "$(readlink -f "$HOME/.zshrc")")/../shell.d/aliases.sh"
fi
