# Quick Start Guide

Get your dual monitor DuoDashboard up and running in 5 minutes!

## Prerequisites

- Raspberry Pi 4 with Raspberry Pi OS installed
- Two monitors connected via HDMI
- Network connection
- Home Assistant instance accessible on your network

## Installation

### 1. Clone the Repository

```bash
cd ~
git clone https://gitlab.com/stefan-matic/duodashboard-dual-screen.git
cd duodashboard-dual-screen
```

### 2. Run the Installer

```bash
chmod +x install.sh
./install.sh
```

The installer will:

- Check system requirements
- Install dependencies
- Copy scripts to the correct locations
- Configure autostart
- Prompt for your Home Assistant URL
- Optionally configure GPU memory

### 3. Configure Your URLs

Edit the scripts to point to your dashboards:

```bash
nano ~/scripts/start_chromium-monitor1.sh
nano ~/scripts/start_chromium-monitor2.sh
```

Change:

- `https://<your-home-assistant-url>/dashboard-duodashboard/1`
- `https://<your-home-assistant-url>/dashboard-duodashboard/2`

To your actual Home Assistant dashboard URLs.

### 4. Test It

Before rebooting, test manually:

```bash
~/chromium-autostart.sh
```

Both Chromium windows should open on your monitors. Press Alt+F4 to close them.

### 5. Reboot

If everything looks good:

```bash
sudo reboot
```

After reboot, Chromium should automatically start on both monitors!

### 6. First Login

On first boot:

1. Both Chromium windows will open
2. Log in to Home Assistant on **both** monitors
3. Sessions will be saved for future reboots

## Common Issues

### Wrong Monitor Layout?

Check your monitor positions:

```bash
xrandr
```

Then edit the `--window-position` values in your scripts. See [docs/MONITOR_POSITIONS.md](docs/MONITOR_POSITIONS.md) for examples.

### Chromium Not Starting?

Check the logs:

```bash
cat ~/.cache/lxsession/rpd-x/run.log
```

Test scripts manually:

```bash
~/scripts/start_chromium-monitor1.sh
```

### Need Help?

See the full [README.md](README.md) for detailed troubleshooting.

## Next Steps

- Set up [x11vnc for remote access](README.md#optional-x11vnc-setup-for-remote-access)
- Customize your Home Assistant dashboards
- Adjust screen blanking settings if needed
- Configure GPU memory for better performance

## Uninstall

To remove the setup:

```bash
# Remove scripts
rm ~/chromium-autostart.sh
rm -rf ~/scripts

# Remove autostart (adjust path based on your desktop session)
rm ~/.config/lxsession/rpd-x/autostart
# or
rm ~/.config/lxsession/LXDE-pi/autostart

# Remove Chromium profiles (optional, loses saved logins)
rm -rf ~/.chromium-monitor1 ~/.chromium-monitor2
```

---

**Having trouble?** Open an issue on GitLab or check the [full documentation](README.md).
