# Dotfiles Makefile
# Minimal POSIX-compatible development environment management

.PHONY: bootstrap validate link-dotfiles clean-cache backup setup-templates auto-cleanup help

# Default target
help:
	@echo "Available targets:"
	@echo "  bootstrap      - Setup complete environment"
	@echo "  validate       - Check system configuration"
	@echo "  link-dotfiles  - Create symbolic links"
	@echo "  clean-cache    - Clear cache directory"
	@echo "  backup         - Backup essential files"
	@echo "  setup-templates - Setup local configuration templates"
	@echo "  auto-cleanup   - Clean old logs and backups (7+ days)"

# Full environment setup
bootstrap: link-dotfiles setup-templates validate clean-cache auto-cleanup
	@echo "Dotfiles environment setup complete"
	@echo "Please restart your shell or run: source ~/.zshrc"
	@echo ""
	@echo "Local configuration files created from templates:"
	@echo "  ~/.gitconfig.local  - Git user settings (name, email, GPG key)"
	@echo "  ~/.ssh/config.local - SSH host configurations"
	@echo "  ~/.forward.local    - Email forwarding addresses"

# Validate system configuration
validate:
	@echo "Validating system configuration..."
	@test -d "$(HOME)" || (echo "ERROR: HOME directory not found"; exit 1)
	@if [ "$$(uname)" = "Darwin" ]; then \
		test "$$(stat -f '%p' $(HOME) 2>/dev/null | tail -c 4)" = "711" || echo "WARNING: HOME permissions should be 711"; \
	else \
		test "$$(stat -c '%a' $(HOME) 2>/dev/null)" = "711" || echo "WARNING: HOME permissions should be 711"; \
	fi
	@test -x "$$(which vim)" || (echo "ERROR: vim not found"; exit 1)
	@test -x "$$(which git)" || (echo "ERROR: git not found"; exit 1)
	@if [ -d "$(HOME)/.backup" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.backup 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .backup should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.backup 2>/dev/null)" = "700" || echo "WARNING: .backup should have 700 permissions"; \
		fi; \
	fi
	@echo "Validating GPG configuration..."
	@if [ -d "$(HOME)/.gnupg" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.gnupg 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .gnupg should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.gnupg 2>/dev/null)" = "700" || echo "WARNING: .gnupg should have 700 permissions"; \
		fi; \
	fi
	@test -f "$(HOME)/.gnupg/gpg.conf" || echo "WARNING: GPG config not found"
	@test -x "$$(which gpg)" || echo "WARNING: GPG not found - install with: sudo port install gnupg2"
	@echo "Validating SSH configuration..."
	@if [ -d "$(HOME)/.ssh" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.ssh 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .ssh should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.ssh 2>/dev/null)" = "700" || echo "WARNING: .ssh should have 700 permissions"; \
		fi; \
	fi
	@test -f "$(HOME)/.ssh/config" || echo "WARNING: SSH config not found"
	@echo "System validation complete"

# Create symbolic links for dotfiles
link-dotfiles:
	@echo "Linking dotfiles..."
	@echo "Setting secure permissions..."
	@chmod 711 "$(HOME)"
	@echo "Creating required directories..."
	@mkdir -p "$(HOME)/.config/env.d"
	@mkdir -p "$(HOME)/.logs" "$(HOME)/.cache" "$(HOME)/Projects"
	@mkdir -p "$(HOME)/.backup/system" "$(HOME)/.backup/projects" "$(HOME)/.backup/gpg" "$(HOME)/.backup/logs"
	@chmod 700 "$(HOME)/.backup" "$(HOME)/.logs"
	@ln -sf "$(HOME)/.dotfiles/config/env.d/default.sh" "$(HOME)/.config/env.d/default.sh"
	@ln -sf "$(HOME)/.dotfiles/zshrc" "$(HOME)/.zshrc"
	@ln -sf "$(HOME)/.dotfiles/bashrc" "$(HOME)/.bashrc"
	@ln -sf "$(HOME)/.dotfiles/profile" "$(HOME)/.profile"
	@ln -sf "$(HOME)/.dotfiles/vimrc" "$(HOME)/.vimrc"
	@ln -sf "$(HOME)/.dotfiles/gitconfig" "$(HOME)/.gitconfig"
	@ln -sf "$(HOME)/.dotfiles/gitignore_global" "$(HOME)/.gitignore_global"
	@git config --global core.excludesfile "$(HOME)/.gitignore_global" 2>/dev/null || true
	@ln -sf "$(HOME)/.dotfiles/hushlogin" "$(HOME)/.hushlogin"
	@echo "Linking GPG configuration..."
	@mkdir -p "$(HOME)/.gnupg"
	@chmod 700 "$(HOME)/.gnupg"
	@ln -sf "$(HOME)/.dotfiles/gnupg/gpg.conf" "$(HOME)/.gnupg/gpg.conf"
	@cp "$(HOME)/.dotfiles/gnupg/gpg-agent.conf" "$(HOME)/.gnupg/gpg-agent.conf"
	@if ! grep -q "pinentry-program $(HOME)/bin/pinentry-fallback" "$(HOME)/.gnupg/gpg-agent.conf" 2>/dev/null; then \
		grep -v "pinentry-program" "$(HOME)/.gnupg/gpg-agent.conf" > "$(HOME)/.gnupg/gpg-agent.conf.tmp" 2>/dev/null || true; \
		mv "$(HOME)/.gnupg/gpg-agent.conf.tmp" "$(HOME)/.gnupg/gpg-agent.conf" 2>/dev/null || true; \
		echo "pinentry-program $(HOME)/bin/pinentry-fallback" >> "$(HOME)/.gnupg/gpg-agent.conf"; \
	fi
	@chmod 600 "$(HOME)/.gnupg/gpg.conf" "$(HOME)/.gnupg/gpg-agent.conf"
	@echo "Linking SSH configuration..."
	@mkdir -p "$(HOME)/.ssh"
	@chmod 700 "$(HOME)/.ssh"
	@ln -sf "$(HOME)/.dotfiles/ssh/config" "$(HOME)/.ssh/config"
	@chmod 600 "$(HOME)/.ssh/config"
	@touch "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
	@chmod 600 "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
	@echo "Linking bin scripts..."
	@mkdir -p "$(HOME)/bin"
	@ln -sf "$(HOME)/.dotfiles/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback"
	@ln -sf "$(HOME)/.dotfiles/bin/ssh-keygen-secure" "$(HOME)/bin/ssh-keygen-secure"
	@ln -sf "$(HOME)/.dotfiles/bin/git-provider" "$(HOME)/bin/git-provider"
	@ln -sf "$(HOME)/.dotfiles/bin/gpg-setup" "$(HOME)/bin/gpg-setup"
	@ln -sf "$(HOME)/.dotfiles/bin/gpg-ssh" "$(HOME)/bin/gpg-ssh"
	@chmod +x "$(HOME)/bin/pinentry-fallback" "$(HOME)/bin/ssh-keygen-secure" "$(HOME)/bin/gpg-setup" "$(HOME)/bin/git-provider" "$(HOME)/bin/gpg-ssh"
	@echo "Dotfiles linked successfully"

# Clean cache directory
clean-cache:
	@echo "Cleaning cache directory..."
	@rm -rf "$(HOME)/.cache"
	@mkdir -p "$(HOME)/.cache"
	@echo "Cache cleaned"

# Backup essential files
backup:
	@echo "Creating backup..."
	@mkdir -p "$(HOME)/.backup/system"
	@cp -r "$(HOME)/.dotfiles" "$(HOME)/.backup/system/" 2>/dev/null || true
	@test -f "$(HOME)/.zsh_history" && cp "$(HOME)/.zsh_history" "$(HOME)/.backup/system/" || true
	@echo "Backup created in $(HOME)/.backup/system/"

# Setup local configuration templates
setup-templates:
	@echo "Setting up local configuration templates..."
	@if [ ! -f "$(HOME)/.gitconfig.local" ]; then \
		cp "$(HOME)/.dotfiles/template/gitconfig.local" "$(HOME)/.gitconfig.local"; \
		echo "Created ~/.gitconfig.local from template"; \
	else \
		echo "~/.gitconfig.local already exists"; \
	fi
	@if [ ! -f "$(HOME)/.ssh/config.local" ]; then \
		cp "$(HOME)/.dotfiles/template/config.local" "$(HOME)/.ssh/config.local"; \
		echo "Created ~/.ssh/config.local from template"; \
	else \
		echo "~/.ssh/config.local already exists"; \
	fi
	@if [ ! -f "$(HOME)/.forward.local" ]; then \
		cp "$(HOME)/.dotfiles/template/forward.local" "$(HOME)/.forward.local"; \
		echo "Created ~/.forward.local from template"; \
	else \
		echo "~/.forward.local already exists"; \
	fi
	@ln -sf "$(HOME)/.forward.local" "$(HOME)/.forward"
	@echo "Local configuration templates setup complete"

# Auto-cleanup old logs and backups (per rules: 7+ days)
auto-cleanup:
	@echo "Cleaning old logs and backups (7+ days)..."
	@find "$(HOME)/.logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
	@find "$(HOME)/.backup/logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
	@echo "Auto-cleanup complete"

