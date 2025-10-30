# DuoDashboard - Dual Monitor Home Assistant Dashboard

[![License: WTFPL](https://img.shields.io/badge/License-WTFPL-brightgreen.svg)](http://www.wtfpl.net/about/)

A complete, production-ready setup for running dual Home Assistant dashboards on a Raspberry Pi 4 with two monitors in fullscreen kiosk mode. Perfect for DuoDashboard setups in hallways, entryways, or anywhere you need persistent dashboard displays.

## What is DuoDashboard?

DuoDashboard is a streamlined alternative to MagicMirror2 that focuses specifically on Home Assistant integration. Instead of requiring custom modules, DuoDashboard simply displays Home Assistant dashboards in fullscreen kiosk mode on dual monitors. This approach leverages Home Assistant's powerful built-in dashboard capabilities while maintaining the simplicity of a dedicated display system.

## ✨ Features

- 🖥️ **Dual Monitor Support** - Independent dashboards on two separate monitors
- 🔄 **Auto-Start on Boot** - Launches automatically after power loss
- 💾 **Persistent Login** - Sessions saved across reboots
- 🎯 **Kiosk Mode** - Fullscreen, distraction-free display
- ⚡ **Optimized Performance** - GPU acceleration and memory tuning
- 🔧 **Easy Installation** - Automated setup script
- 📖 **Comprehensive Docs** - Detailed guides and troubleshooting
- 🌊 **Wayland Support** - Experimental Wayland compositor support

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://gitlab.com/stefan-matic/duodashboard-dual-screen.git
cd duodashboard-dual-screen

# Run the installer
chmod +x install.sh
./install.sh

# Reboot
sudo reboot
```

That's it! Your dashboards will auto-start on both monitors.

See [QUICKSTART.md](QUICKSTART.md) for the full 5-minute setup guide.

## 📋 Requirements

### Hardware Requirements

- Raspberry Pi 4 (4GB RAM recommended, 2GB should work)
- 2x HDMI monitors (or use adapters for other connections)
- MicroSD card (16GB minimum, 32GB+ recommended)
- Power supply for Raspberry Pi

### Software Requirements

- Raspberry Pi OS (Bookworm or later)
- Chromium browser (pre-installed on Raspberry Pi OS)
- X11 display server (recommended) or Wayland (experimental)
- Home Assistant instance (accessible via network)
- Basic command line knowledge

## 📚 Documentation

- **[QUICKSTART.md](QUICKSTART.md)** - 5-minute installation guide
- **[docs/MONITOR_POSITIONS.md](docs/MONITOR_POSITIONS.md)** - Monitor layout examples
- **[docs/WAYLAND_SETUP.md](docs/WAYLAND_SETUP.md)** - Experimental Wayland guide
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Repository organization
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[CHANGELOG.md](CHANGELOG.md)** - Version history

## 🎯 Use Cases

Perfect for:

- DuoDashboard displays in hallways or entryways
- Information displays in offices or lobbies
- Kitchen displays with recipes and calendars
- Home automation dashboards
- Security camera displays
- Weather stations
- Any always-on dashboard display

## 🛠️ What's Included

- **Automated Installation Script** - One command setup
- **Chromium Startup Scripts** - Optimized for kiosk use
- **Desktop Autostart Configuration** - Starts on boot
- **VNC Setup Guide** - Remote access instructions
- **Monitor Position Calculator** - Easy multi-monitor setup
- **Performance Tuning Tips** - GPU memory optimization
- **Comprehensive Troubleshooting** - Solutions to common issues

## 📸 Dashboard Ideas

Great for displaying:

- 🌤️ Weather forecasts
- 📅 Calendar and appointments
- 📰 News headlines
- 🚌 Transit/commute times
- 🗑️ Trash collection schedules
- 📦 Package tracking
- 🚪 Door/window status
- 💡 Smart home controls
- 📊 Home energy monitoring
- 👨‍👩‍👧‍👦 Family photos carousel
- ✅ Todo lists
- 🎵 Now playing

## 🔧 Installation & Configuration

### Initial Raspberry Pi Setup

```bash
# Update system
sudo apt update
sudo apt upgrade -y

# Ensure Chromium is installed
sudo apt install chromium-browser -y

# Install x11vnc for remote access (optional)
sudo apt install x11vnc -y
```

### Ensure X11 is Being Used

```bash
# Check current display server
echo $XDG_SESSION_TYPE

# If using Wayland, switch to X11
sudo raspi-config
# Navigate to: Advanced Options -> Wayland -> X11
# Reboot after changing
```

### Clone and Install

```bash
cd ~
git clone https://gitlab.com/stefan-matic/duodashboard-dual-screen.git
cd duodashboard-dual-screen

# Run automated installer
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

### Configure Your URLs

Edit the scripts to point to your dashboards:

```bash
nano ~/scripts/start_chromium-monitor1.sh
nano ~/scripts/start_chromium-monitor2.sh
```

Change:
- `https://<your-home-assistant-url>/dashboard-duodashboard/1`
- `https://<your-home-assistant-url>/dashboard-duodashboard/2`

To your actual Home Assistant dashboard URLs.

### Display Configuration

This setup is configured for:

- **Monitor 1 (HDMI-A-1)**: Primary monitor, positioned at 0,0
- **Monitor 2 (HDMI-A-2)**: Secondary monitor, positioned at calculated offset

Adjust the `--window-position` parameters in the scripts according to your monitor layout. Use `xrandr` to determine your monitor positions:

```bash
xrandr
```

### Set Up Autostart

The installer automatically detects your desktop session type and configures autostart. If you need to do this manually:

```bash
# Check desktop session
echo $DESKTOP_SESSION

# For rpd-x
mkdir -p ~/.config/lxsession/rpd-x
cp autostart/rpd-x-autostart ~/.config/lxsession/rpd-x/autostart

# For LXDE-pi
mkdir -p ~/.config/lxsession/LXDE-pi
cp autostart/LXDE-pi-autostart ~/.config/lxsession/LXDE-pi/autostart
```

### Configure GPU Memory (Recommended)

Edit the boot config:

```bash
sudo nano /boot/firmware/config.txt
```

Add before the `[cm4]` section:

```
gpu_mem=256
```

Save and reboot:

```bash
sudo reboot
```

### First Login

After the first boot with autostart enabled:

1. Both Chromium windows will open
2. Log in to Home Assistant on **both** monitors
3. Chromium will remember your credentials using separate profiles

## Monitor Position Reference

The `--window-position=X,Y` parameter places the top-left corner of the window:

- **Single monitor**: `--window-position=0,0`
- **Dual monitors side-by-side**:
  - Left monitor: `--window-position=0,0`
  - Right monitor: `--window-position=1920,0` (where 1920 is the width of the left monitor)
- **Dual monitors with rotation**: Calculate based on effective width after rotation

Use `xrandr` to see your exact layout. See [docs/MONITOR_POSITIONS.md](docs/MONITOR_POSITIONS.md) for detailed examples.

## Optional: x11vnc Setup for Remote Access

To access your DuoDashboard remotely:

```bash
# Set VNC password
x11vnc -storepasswd

# Create systemd service
sudo nano /etc/systemd/system/x11vnc.service
```

Paste the following:

```ini
[Unit]
Description=x11vnc VNC Server
After=display-manager.service

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -display :0 -auth guess -forever -loop -noxdamage -repeat -rfbauth /home/pi/.vnc/passwd -rfbport 5900 -shared
User=pi
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable x11vnc.service
sudo systemctl start x11vnc.service
```

## Wayland Alternative (Experimental)

If you prefer to use Wayland instead of X11, see [docs/WAYLAND_SETUP.md](docs/WAYLAND_SETUP.md) for detailed instructions.

**Note**: Window positioning on Wayland can be unreliable. X11 is recommended for reliable dual-monitor kiosk setups.

## 🐛 Troubleshooting

### Chromium Doesn't Start on Boot

Check the logs:

```bash
cat ~/.cache/lxsession/rpd-x/run.log
# or
cat ~/.cache/lxsession/LXDE-pi/run.log
```

Test scripts manually:

```bash
~/scripts/start_chromium-monitor1.sh
~/scripts/start_chromium-monitor2.sh
```

Verify desktop session:

```bash
echo $DESKTOP_SESSION
```

### Both Windows Open on Same Monitor

1. Check your monitor layout with `xrandr`
2. Verify the `--window-position` values match your layout
3. Try manually positioning windows once, Chromium may remember their positions

### Performance Issues

1. Increase GPU memory in `/boot/firmware/config.txt`:

   ```
   gpu_mem=256
   ```

2. Check for throttling:

   ```bash
   vcgencmd get_throttled
   ```

3. Monitor temperature:

   ```bash
   vcgencmd measure_temp
   ```

4. Reduce dashboard complexity in Home Assistant (fewer animations, smaller images)

### Need to Re-login After Reboot

This usually means:

- The user data directories are being cleared
- Verify `--user-data-dir` paths are permanent (not using `$(mktemp -d)`)
- Check that the directories exist: `ls -la ~/.chromium-monitor1 ~/.chromium-monitor2`

### VNC Shows Gray Screen

The VNC service might have started before the display was ready. Restart it:

```bash
sudo systemctl restart x11vnc.service
```

## Customization

### Change Dashboard URLs

Edit the scripts and update the URLs:

```bash
nano ~/scripts/start_chromium-monitor1.sh
nano ~/scripts/start_chromium-monitor2.sh
```

### Adjust Startup Delays

Edit the main autostart script:

```bash
nano ~/chromium-autostart.sh
```

Modify the `sleep` values if windows aren't opening reliably.

### Disable Screen Blanking

The autostart file already includes:

```
@xset s off
@xset -dpms
@xset s noblank
```

If screen still blanks, also check:

```bash
sudo nano /etc/lightdm/lightdm.conf
```

Add under `[Seat:*]`:

```
xserver-command=X -s 0 -dpms
```

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📝 License

This project is licensed under the WTFPL (Do What The Fuck You Want To Public License).

See [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- Raspberry Pi Foundation
- Home Assistant community
- Dashboard project enthusiasts
- Everyone who contributed ideas and testing

## 🔗 Related Projects

- [Home Assistant](https://www.home-assistant.io/)
- [MagicMirror²](https://magicmirror.builders/) (inspiration for dashboard concepts)
- [Raspberry Pi](https://www.raspberrypi.org/)

## 📧 Support

- 🐛 [Report Issues](https://gitlab.com/stefan-matic/duodashboard-dual-screen/-/issues)
- 💬 [Discussions](https://gitlab.com/stefan-matic/duodashboard-dual-screen/-/issues)
- 📖 [Documentation](docs/)

## ⭐ Star This Project

If you find this useful, please consider starring the repository!

---

**Made with ❤️ for the Home Assistant and Raspberry Pi communities**