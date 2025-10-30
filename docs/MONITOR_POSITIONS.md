# Monitor Position Examples

This file contains examples of different monitor configurations and the corresponding `--window-position` parameters to use in your scripts.

## How to Determine Your Layout

Run this command to see your monitor configuration:
```bash
xrandr
```

Look for the position information, for example:
```
HDMI-1 connected primary 1920x1080+0+0
HDMI-2 connected 1920x1080+1920+0
```

The numbers after the `+` symbols indicate position:
- `+0+0` = X position 0, Y position 0
- `+1920+0` = X position 1920, Y position 0

## Common Configurations

### Side-by-Side (Horizontal)

Two 1920x1080 monitors side-by-side:
```
Monitor 1: --window-position=0,0
Monitor 2: --window-position=1920,0
```

Two 1360x768 monitors side-by-side:
```
Monitor 1: --window-position=0,0
Monitor 2: --window-position=1360,0
```

### Stacked (Vertical)

Two 1920x1080 monitors stacked:
```
Monitor 1 (top): --window-position=0,0
Monitor 2 (bottom): --window-position=0,1080
```

### With Rotated Display

Monitor 1 rotated 270° (portrait, 1080x1920 effective):
```
Monitor 1: --window-position=0,0
Monitor 2: --window-position=1080,0
```

Monitor 1 rotated 90° (portrait, 1080x1920 effective):
```
Monitor 1: --window-position=0,0
Monitor 2: --window-position=1080,0
```

### Offset Monitors

If monitors are at different heights:
```
Monitor 1: --window-position=0,0
Monitor 2: --window-position=1920,100  (100 pixels down)
```

## Current Setup (Default)

The default configuration in this repository:
```
Monitor 1 (HDMI-A-1, Toshiba TV, rotated 270°): --window-position=0,0
Monitor 2 (HDMI-A-2, LG Monitor): --window-position=768,0
```

This assumes:
- Monitor 1 is 768 pixels wide when rotated
- Monitor 2 starts at X position 768
- Both monitors have Y position 0 (same vertical alignment)

## How to Configure

1. Run `xrandr` to see your layout
2. Note the positions of each monitor
3. Edit the scripts:
   - `~/scripts/start-chromium-monitor1.sh`
   - `~/scripts/start-chromium-monitor2.sh`
4. Update the `--window-position=X,Y` parameters
5. Test with: `~/chromium-autostart.sh`

## Tips

- The values are in pixels
- X increases to the right
- Y increases downward
- Use `xrandr --output HDMI-X --pos XxY` to reposition monitors if needed
- Chromium may remember window positions after first manual positioning
