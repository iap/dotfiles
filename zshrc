# Zsh configuration
# Minimal, secure, and cross-platform setup

# Load environment configuration
if [ -f "$(dirname "$(readlink -f "$HOME/.zshrc")")/../shell.d/env.sh" ] 2>/dev/null; then
  source "$(dirname "$(readlink -f "$HOME/.zshrc")")/../shell.d/env.sh"
fi

# Zsh options
setopt AUTO_CD
setopt CORRECT
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY

# Key bindings
bindkey -e  # Emacs key bindings

# Completion system
autoload -Uz compinit
compinit

# Simple prompt
PROMPT='%n@%m:%~%# '

# Aliases and platform-specific configurations are loaded via shell.d/env.sh
# which sources shell.d/aliases.sh

