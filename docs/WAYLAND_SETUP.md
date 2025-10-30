# Wayland Setup Guide (Experimental)

This guide provides instructions for setting up the dual monitor DuoDashboard on Wayland instead of X11.

⚠️ **Warning**: Wayland support is experimental. Window positioning is less reliable than X11, and you may need to manually position windows on first launch.

## Why Wayland?

- Modern display server protocol
- Better security model
- Improved multi-monitor support (in theory)
- Native HiDPI support

## Why Not Wayland?

- Window positioning APIs are less mature
- Not all applications support Wayland well
- Kiosk mode can be problematic
- More complex to configure

**Recommendation**: Stick with X11 for kiosk setups unless you have specific Wayland requirements.

## Switching to Wayland

```bash
sudo raspi-config
```

Navigate to:

- Advanced Options → Wayland
- Choose either:
  - **Wayfire**: Feature-rich compositor
  - **Labwc**: Lightweight, Openbox-like compositor

Reboot after changing.

## Compositor-Specific Setup

### Labwc (Recommended for Kiosk)

Labwc is lightweight and easier to configure for kiosk setups.

#### 1. Create Labwc Autostart

```bash
mkdir -p ~/.config/labwc
nano ~/.config/labwc/autostart
```

Add:

```bash
#!/bin/bash

# Wait for compositor to be ready
sleep 5

# Set Wayland environment
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Configure displays (adjust for your setup)
# Use wlr-randr to see available outputs
wlr-randr --output HDMI-A-1 --transform 270 --pos 0,0 &
wlr-randr --output HDMI-A-2 --pos 768,0 &

# Wait for display configuration to apply
sleep 2

# Start Chromium instances
/home/pi/scripts/start_chromium-monitor1-wayland.sh &
sleep 3
/home/pi/scripts/start_chromium-monitor2-wayland.sh &
```

Make it executable:

```bash
chmod +x ~/.config/labwc/autostart
```

#### 2. Create Wayland-Specific Chromium Scripts

Create `~/scripts/start_chromium-monitor1-wayland.sh`:

```bash
#!/bin/bash
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

chromium --noerrdialogs \
  --disable-infobars \
  --app="https://<your-home-assistant-url>/dashboard-duodashboard/1" \
  --start-fullscreen \
  --window-position=0,0 \
  --user-data-dir=/home/pi/.chromium-monitor1 \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland
```

Create `~/scripts/start_chromium-monitor2-wayland.sh`:

```bash
#!/bin/bash
export WAYLAND_DISPLAY=wayland-0
export XDG_RUNTIME_DIR=/run/user/$(id -u)

chromium --noerrdialogs \
  --disable-infobars \
  --app="https://<your-home-assistant-url>/dashboard-duodashboard/2" \
  --start-fullscreen \
  --window-position=768,0 \
  --user-data-dir=/home/pi/.chromium-monitor2 \
  --enable-features=UseOzonePlatform \
  --ozone-platform=wayland
```

Make executable:

```bash
chmod +x ~/scripts/start_chromium-monitor1-wayland.sh
chmod +x ~/scripts/start_chromium-monitor2-wayland.sh
```

#### 3. Optional: Window Rules (May Not Work Reliably)

Create `~/.config/labwc/rc.xml`:

```xml
<?xml version="1.0"?>
<labwc_config>
  <windowRules>
    <!-- Attempt to position windows on specific outputs -->
    <windowRule identifier="chromium-monitor1">
      <action name="MoveTo" output="HDMI-A-1"/>
      <action name="Maximize"/>
    </windowRule>

    <windowRule identifier="chromium-monitor2">
      <action name="MoveTo" output="HDMI-A-2"/>
      <action name="Maximize"/>
    </windowRule>
  </windowRules>
</labwc_config>
```

And add `--class=chromium-monitor1` and `--class=chromium-monitor2` to your scripts.

**Note**: Window rules on Wayland are often ignored or unreliable.

### Wayfire

Wayfire has more features but is more resource-intensive.

#### Configuration

Create `~/.config/wayfire.ini`:

```ini
[autostart]
chromium1 = /home/pi/scripts/start_chromium-monitor1-wayland.sh
chromium2 = /home/pi/scripts/start_chromium-monitor2-wayland.sh

[output:HDMI-A-1]
mode = 1360x768@60
position = 0,0
transform = 270

[output:HDMI-A-2]
mode = 1360x768@60
position = 768,0
transform = normal
```

## Display Configuration

Use `wlr-randr` to configure displays:

```bash
# List available outputs
wlr-randr

# Configure a display
wlr-randr --output HDMI-A-1 --mode 1920x1080@60 --pos 0,0

# Rotate a display
wlr-randr --output HDMI-A-1 --transform 90

# Save configuration (add to autostart)
```

Valid transform values:

- `normal` (0°)
- `90`
- `180`
- `270`
- `flipped` (horizontal flip)
- `flipped-90`, `flipped-180`, `flipped-270`

## VNC on Wayland

For remote access on Wayland, use `wayvnc`:

```bash
# Install wayvnc
sudo apt install wayvnc

# Create systemd service for each monitor
```

See the main README for x11vnc setup (for X11 only).

For Wayland, create separate wayvnc instances per output.

## Troubleshooting

### Chromium Won't Start

Check that Wayland environment variables are set:

```bash
echo $WAYLAND_DISPLAY
echo $XDG_RUNTIME_DIR
ls -la $XDG_RUNTIME_DIR/wayland-*
```

### Windows on Wrong Monitor

1. Launch Chromium instances
2. Manually drag to correct monitors
3. Close properly (Chromium may remember positions)
4. Relaunch

### Performance Issues

Wayland can be slower on Raspberry Pi 4:

- Reduce animation in Home Assistant
- Lower dashboard complexity
- Consider switching back to X11

### Window Positioning Not Working

This is expected on Wayland. The `--window-position` parameter is often ignored by Wayland compositors. Manual positioning on first launch may be required.

## Switching Back to X11

If Wayland doesn't work well:

```bash
sudo raspi-config
```

Navigate to: Advanced Options → Wayland → X11

Then use the main setup scripts from this repository.

## Comparison: X11 vs Wayland

| Feature            | X11             | Wayland        |
| ------------------ | --------------- | -------------- |
| Window positioning | Reliable        | Unreliable     |
| Kiosk mode         | Excellent       | Variable       |
| Performance        | Good            | Variable       |
| Security           | Adequate        | Better         |
| Maturity           | Very mature     | Still evolving |
| Configuration      | Straightforward | More complex   |

**For DuoDashboard/kiosk use: X11 is recommended.**

## References

- [Labwc Documentation](https://labwc.github.io/)
- [Wayfire Documentation](https://github.com/WayfireWM/wayfire)
- [wlr-randr](https://sr.ht/~emersion/wlr-randr/)
- [Wayland on Raspberry Pi](https://www.raspberrypi.com/news/raspberry-pi-os-bookworm/)
