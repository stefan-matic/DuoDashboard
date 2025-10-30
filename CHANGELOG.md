# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2024-10-30

### Added
- **Project Rebranding**: Renamed from "Magic Mirror" to "DuoDashboard"
- **GitHub Actions CI/CD**: Added comprehensive GitHub Actions workflows
  - Automated shell script validation with ShellCheck
  - Bash syntax checking for all scripts
  - Documentation and file presence verification
  - Integration testing with dependency installation
  - Automated release creation on version tags
- **Improved Documentation**: Consolidated README files into single comprehensive guide
- **Enhanced CI/CD**: Dual support for both GitLab CI and GitHub Actions

### Changed
- **Naming Standardization**: Unified all naming conventions across the project
  - Script files now use consistent `kebab-case` naming
  - Updated all file references throughout documentation
  - Standardized `start-chromium-monitor1.sh` and `start-chromium-monitor2.sh` naming
- **Documentation Structure**: Merged GITLAB_README.md and README.md into single comprehensive guide
- **Project URLs**: Updated all repository references to use consistent naming

### Fixed
- **CI Pipeline**: Resolved GitLab CI bash_syntax job failures
  - Removed duplicate content from install.sh script
  - Fixed syntax errors with unmatched conditional statements
  - Verified all scripts pass bash syntax validation
- **File Corruption**: Restored corrupted autostart configuration files

### Technical Improvements
- Enhanced error handling in installation scripts
- Improved script organization and maintainability
- Better integration testing coverage
- Standardized file permissions and executability checks

## [1.0.0] - 2025-10-30

### Added
- Initial release
- Dual monitor Chromium kiosk setup for Raspberry Pi
- Support for X11 display server
- Automatic startup configuration for rpd-x and LXDE-pi desktop sessions
- Separate Chromium profiles for each monitor to maintain independent sessions
- Installation script for automated setup
- Comprehensive README with troubleshooting guide
- Optional x11vnc configuration for remote access
- Experimental Wayland support documentation
- WTFPL license

### Features
- Fullscreen Home Assistant dashboard display on two monitors
- Persistent login sessions across reboots
- Automatic screen blanking prevention
- Configurable window positioning for different monitor layouts
- Support for rotated displays
