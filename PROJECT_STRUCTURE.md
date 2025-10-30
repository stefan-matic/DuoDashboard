# Project Structure

This document describes the organization of files in this repository.

## Repository Layout

```
duodashboard-dual-screen/
├── README.md                          # Main documentation
├── QUICKSTART.md                      # Quick installation guide
├── LICENSE                            # WTFPL license
├── CHANGELOG.md                       # Version history
├── CONTRIBUTING.md                    # Contribution guidelines
├── .gitignore                         # Git ignore rules
├── .gitlab-ci.yml                     # GitLab CI/CD configuration
├── install.sh                         # Automated installation script
├── chromium-autostart.sh              # Main autostart wrapper script
│
├── scripts/                           # Chromium startup scripts
│   ├── start_chromium-monitor1.sh    # Monitor 1 (left/primary)
│   └── start_chromium-monitor2.sh    # Monitor 2 (right/secondary)
│
├── autostart/                         # Desktop session autostart files
│   ├── rpd-x-autostart               # For rpd-x desktop session
│   └── LXDE-pi-autostart             # For LXDE-pi desktop session
│
└── docs/                              # Additional documentation
    ├── MONITOR_POSITIONS.md          # Monitor positioning examples
    └── WAYLAND_SETUP.md              # Wayland setup guide (experimental)
```

## File Descriptions

### Root Files

- **README.md**: Comprehensive setup guide, troubleshooting, and configuration instructions
- **QUICKSTART.md**: Simplified 5-minute installation guide for quick setup
- **LICENSE**: WTFPL (Do What The Fuck You Want To Public License)
- **CHANGELOG.md**: Version history and release notes
- **CONTRIBUTING.md**: Guidelines for contributing to the project
- **.gitignore**: Specifies files Git should ignore
- **.gitlab-ci.yml**: GitLab CI/CD pipeline for validating scripts
- **install.sh**: Automated installation script that sets up everything
- **chromium-autostart.sh**: Main wrapper script that launches both Chromium instances

### scripts/

Contains the individual Chromium startup scripts:

- **start_chromium-monitor1.sh**: Launches Chromium for the first monitor
  - Configured for window position 0,0
  - Uses separate user data directory
- **start_chromium-monitor2.sh**: Launches Chromium for the second monitor
  - Configured for window position based on first monitor width
  - Uses separate user data directory

### autostart/

Desktop session autostart configurations:

- **rpd-x-autostart**: For modern Raspberry Pi Desktop (X11)
- **LXDE-pi-autostart**: For legacy LXDE desktop sessions

These files are copied to `~/.config/lxsession/[SESSION]/autostart` during installation.

### docs/

Additional documentation:

- **MONITOR_POSITIONS.md**: Examples of different monitor configurations and how to calculate window positions
- **WAYLAND_SETUP.md**: Experimental guide for using Wayland instead of X11

## Installation Locations

After running `install.sh`, files are installed to:

```
~/
├── chromium-autostart.sh              # Main wrapper script
│
├── scripts/
│   ├── start_chromium-monitor1.sh
│   └── start_chromium-monitor2.sh
│
├── .config/
│   └── lxsession/
│       ├── rpd-x/
│       │   └── autostart              # Autostart for rpd-x
│       └── LXDE-pi/
│           └── autostart              # Autostart for LXDE-pi
│
├── .chromium-monitor1/                # Chromium profile for monitor 1
│   └── [profile data]
│
└── .chromium-monitor2/                # Chromium profile for monitor 2
    └── [profile data]
```

## Customization

### To Change Monitor Layout

Edit these files:

- `scripts/start_chromium-monitor1.sh` - adjust `--window-position`
- `scripts/start_chromium-monitor2.sh` - adjust `--window-position`

### To Change Dashboard URLs

Edit these files:

- `scripts/start_chromium-monitor1.sh` - change the `--app` URL
- `scripts/start_chromium-monitor2.sh` - change the `--app` URL

### To Change Startup Delays

Edit these files:

- `chromium-autostart.sh` - adjust `sleep` values
- Autostart files in `~/.config/lxsession/*/autostart`

## Development

### Testing Changes

Test scripts manually without rebooting:

```bash
# Kill existing instances
pkill chromium

# Test main script
~/chromium-autostart.sh

# Or test individual scripts
~/scripts/start_chromium-monitor1.sh &
~/scripts/start_chromium-monitor2.sh &
```

### Adding Features

1. Create a new branch
2. Make changes to appropriate files
3. Test thoroughly on Raspberry Pi hardware
4. Update documentation (README.md, CHANGELOG.md)
5. Submit a merge request

### CI/CD

The `.gitlab-ci.yml` file runs automatic checks:

- Shell script syntax validation
- Documentation completeness check
- Required files verification

## Version Control

### Branches

- `main`: Stable, tested releases
- `develop`: Integration branch for features
- `feature/*`: Individual feature branches

### Tags

Releases are tagged with semantic versioning: `v1.0.0`

## Support Files

The repository includes common Git-related files:

- `.gitignore`: Prevents committing user-specific configs, logs, and temporary files
- `.gitlab-ci.yml`: Automated testing pipeline

## License

All files in this repository are licensed under the WTFPL. See [LICENSE](LICENSE) for details.
