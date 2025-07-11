# Changelog

All notable changes to this dotfiles configuration are documented here.

## [2.0.2] - 2025-07-11

### Intelligent Terminal Default Switching
- **OS-Aware Shell Detection**: Bootstrap now detects OS type and recommends appropriate shell
- **Smart Recommendations**: macOS defaults to zsh, Linux prefers zsh if available or falls back to bash
- **User-Friendly Feedback**: Clear status messages about current vs recommended shell
- **Non-Intrusive**: Informational guidance only, respects user choice

### Added
- **check-shell-defaults Target**: New Makefile target for shell recommendation system
- **Cross-Platform Logic**: Intelligent shell detection for macOS, Linux, and unknown systems
- **Bootstrap Integration**: Shell checking seamlessly integrated into bootstrap workflow
- **Clear Instructions**: Provides exact commands for shell switching when needed

### Enhanced
- **Bootstrap UX**: Better out-of-box experience with OS-appropriate defaults
- **Documentation**: Real-time feedback about system configuration
- **Cross-Platform Support**: Improved compatibility across different operating systems

## [2.0.1] - 2025-07-11

### Dynamic Path Resolution and Permission Consistency
- **GPG Template System**: Replaced static gpg-agent.conf with dynamic template using %h placeholder
- **Permission Consistency**: Fixed pinentry symlink permissions (711) to match bin directory
- **Bootstrap Improvements**: Unified umask strategy between bootstrap and fix-permissions
- **Validation Updates**: Corrected validation checks for new template system

### Added
- **Dynamic GPG Configuration**: Template-based gpg-agent.conf with automatic path substitution
- **Consistent Permission Strategy**: All symlinks now use umask 066 for 711 permissions
- **Template Validation**: Proper validation of GPG template placeholder usage

### Fixed
- **Permission Inconsistency**: Bootstrap now uses umask 066 matching fix-permissions
- **GPG Agent Path**: Dynamic path resolution eliminates hardcoded home directory
- **Validation Errors**: Updated checks to work with new template system
- **Symlink Permissions**: Pinentry symlinks now correctly have 711 permissions

### Removed
- **Static GPG Config**: Removed redundant gnupg/gpg-agent.conf in favor of template
- **Backup Files**: Cleaned up old dotfiles backup files

## [2.0.0] - 2025-07-11

### Major Architecture Update
- **Modular Makefile System**: Restructured from 320-line monolithic Makefile to modular 17-line system
- **Safety Features**: Added comprehensive shell safety with timeout protection, retry logic, and crash prevention
- **Dry-Run Support**: All destructive operations now support `DRY_RUN=1` for safe preview
- **Server Compatibility**: Enhanced pinentry-fallback with headless detection and better Linux support

### Added
- **make.d/ directory structure**: 6 modular components (safety, help, validation, permissions, setup, maintenance)
- **Process locking**: Prevents concurrent dotfiles operations
- **Resource monitoring**: Disk and memory usage checks before operations
- **Network safety**: Connectivity checks with offline mode support
- **Enhanced logging**: Debug logs for pinentry selection and operations

### Fixed
- **Critical GPG SSH Authentication**: Fixed pinentry-fallback symlink permissions
- **Server pinentry**: Prioritized terminal-based pinentry for headless environments
- **Error handling**: Graceful exit on interrupt (Ctrl+C) with automatic cleanup

## [1.2.1] - 2025-07-11

### Fixed
- **GPG SSH Authentication**: Fixed pinentry-fallback permissions
- **Network Mode**: Changed default from offline to network enabled
- **Script Consistency**: Unified environment variable handling

## [1.2.0] - 2025-07-10

### Fixed
- **macOS Compatibility**: Fixed `readlink -f` issues with proper fallbacks
- **GPG SSH Authentication**: Resolved pinentry path issues
- **SSH Configuration**: Removed redundant Port 22 specifications
- **Cross-Platform**: Enhanced compatibility across macOS/Linux/older systems

### Enhanced
- **SSH Templates**: Improved config.local template with platform examples
- **Security**: Better GPG agent path resolution and SSH integration
- **Performance**: Optimized shell loading and SSH connection multiplexing

## [1.1.1] - 2025-07-09

### Documentation
- **Enhanced README**: Added MacPorts integration and local configuration examples
- **Fixed references**: Corrected `zshrc.d/bashrc.d` to `shell.d/`
- **Project structure**: Added missing files (CHANGELOG.md, VERSION, templates)

### Added
- **Package management**: MacPorts and Linux package manager examples
- **Local customization**: Improved `.local` file configuration system

## [1.1.0] - 2025-07-07

### Fixed
- **Critical**: Shell aliases not loading due to path resolution issues
- Template system and dynamic path resolution

### Added
- Complete template system for local overrides
- Shell syntax validation in compliance checks
- Optimized Makefile validation targets

## [1.0.0] - 2025-07-07

### Initial Release
- Terminal-first pinentry fallback system for GPG
- Cross-platform SSH configuration with security hardening
- MacPorts-only package management compliance
- GPG agent configuration with secure pinentry ordering
- Git configuration with GPG signing enabled
- User configuration templates for local customization
- Makefile automation for reproducible setup
- Cross-platform compatibility (macOS/Linux)
