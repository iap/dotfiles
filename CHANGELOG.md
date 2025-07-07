# Changelog

All notable changes to this dotfiles configuration are documented here.

## [1.0.0] - 2025-07-07

### Added
- Terminal-first pinentry fallback system for GPG
- Cross-platform SSH configuration with security hardening  
- MacPorts-only package management compliance
- GPG agent configuration with secure pinentry ordering
- Git configuration with GPG signing enabled
- User configuration templates for local customization

### Security
- SSH IdentitiesOnly disabled for GitHub (controlled exception)
- Pinentry priority: terminal-first, GUI fallback only
- GPG agent cache: 10min default, 2hr maximum
- File permissions: 700/600 for sensitive directories/files
- No hardcoded paths, dynamic resolution only

### Configuration
- SSH GitHub authentication working
- GPG signing and encryption tested and functional
- Terminal-based pinentry confirmed working (pinentry-curses)
- All security rules compliance verified

### Infrastructure
- Symlinked configuration files for instant updates
- Copied GPG agent config for security isolation
- Makefile automation for reproducible setup
- Cross-platform compatibility (macOS/Linux)

---
*Format: [Version] - YYYY-MM-DD*  
*Categories: Added, Changed, Deprecated, Removed, Fixed, Security*
