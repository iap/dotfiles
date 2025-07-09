# Bash configuration
# Minimal, secure, and cross-platform setup
# Optional alternative to zsh

# Load environment configuration
if [ -f "$(dirname "$(readlink -f "$HOME/.bashrc")")/shell.d/env.sh" ] 2>/dev/null; then
  source "$(dirname "$(readlink -f "$HOME/.bashrc")")/shell.d/env.sh"
fi

# Bash-specific options
set -o emacs          # Emacs key bindings
set -o noclobber      # Prevent overwriting files with redirection
shopt -s checkwinsize # Check window size after each command
shopt -s histappend   # Append to history file, don't overwrite
shopt -s cmdhist      # Save multi-line commands in history as single line
shopt -s cdspell      # Correct minor errors in directory names

# History settings
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT='%F %T '

# Simple prompt with color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # Color support
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  # No color
  PS1='\u@\h:\w\$ '
fi

# Aliases are loaded via shell.d/env.sh which sources shell.d/aliases.sh

# Bash completion setup
if [ "$OS_TYPE" = "macOS" ]; then
  # Enable bash completion if available
  if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    source /opt/local/etc/profile.d/bash_completion.sh
  fi
else
  # Enable bash completion if available
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      source /etc/bash_completion
    fi
  fi
fi

