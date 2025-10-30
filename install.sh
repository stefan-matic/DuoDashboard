#!/bin/bash
# Installation script for Raspberry Pi DuoDashboard dual monitor setup
# This script automates the installation process

set -e  # Exit on error

echo "=========================================="
echo "DuoDashboard Dual Monitor Setup Installer"
echo "=========================================="
echo ""

# Get username
CURRENT_USER=$(whoami)
echo "Installing for user: $CURRENT_USER"
echo ""

# Check if we're on a Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo; then
    echo "Warning: This doesn't appear to be a Raspberry Pi."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if X11 is running
if [ "$XDG_SESSION_TYPE" != "x11" ]; then
    echo "Warning: You're not running X11 (current: $XDG_SESSION_TYPE)"
    echo "This setup is designed for X11. Consider switching with raspi-config."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Chromium if not present
if ! command -v chromium &> /dev/null; then
    echo "Chromium not found. Installing..."
    sudo apt update
    sudo apt install -y chromium-browser
else
    echo "✓ Chromium is installed"
fi

# Create scripts directory
echo ""
echo "Creating scripts directory..."
mkdir -p ~/scripts

# Copy scripts
echo "Copying scripts..."
cp chromium-autostart.sh ~/
cp scripts/start-chromium-monitor1.sh ~/scripts/
cp scripts/start-chromium-monitor2.sh ~/scripts/

# Make scripts executable
echo "Making scripts executable..."
chmod +x ~/chromium-autostart.sh
chmod +x ~/scripts/start-chromium-monitor1.sh
chmod +x ~/scripts/start-chromium-monitor2.sh

echo "✓ Scripts installed"

# Update scripts with current username
echo ""
echo "Updating scripts with your username..."
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/chromium-autostart.sh
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/scripts/start-chromium-monitor1.sh
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/scripts/start-chromium-monitor2.sh

# Detect desktop session
DESKTOP_SESSION_TYPE=$(echo $DESKTOP_SESSION)
echo ""
echo "Detected desktop session: $DESKTOP_SESSION_TYPE"

# Set up autostart based on desktop session
if [ "$DESKTOP_SESSION_TYPE" = "rpd-x" ]; then
    echo "Setting up autostart for rpd-x..."
    mkdir -p ~/.config/lxsession/rpd-x
    cp autostart/rpd-x-autostart ~/.config/lxsession/rpd-x/autostart
    sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/.config/lxsession/rpd-x/autostart
    echo "✓ Autostart configured for rpd-x"
    elif [ "$DESKTOP_SESSION_TYPE" = "LXDE-pi" ]; then
    echo "Setting up autostart for LXDE-pi..."
    mkdir -p ~/.config/lxsession/LXDE-pi
    cp autostart/LXDE-pi-autostart ~/.config/lxsession/LXDE-pi/autostart
    sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/.config/lxsession/LXDE-pi/autostart
    echo "✓ Autostart configured for LXDE-pi"
else
    echo "Warning: Unknown desktop session type."
    echo "You may need to manually configure autostart."
    echo "See README.md for instructions."
fi

# Prompt for Home Assistant URL
echo ""
echo "=========================================="
echo "Configuration"
echo "=========================================="
echo ""
read -p "Enter your Home Assistant URL (e.g., https://homeassistant.local): " HA_URL

if [ ! -z "$HA_URL" ]; then
    echo "Updating scripts with your Home Assistant URL..."
    sed -i "s|https://<your-home-assistant-url>|$HA_URL|g" ~/scripts/start-chromium-monitor1.sh
    sed -i "s|https://<your-home-assistant-url>|$HA_URL|g" ~/scripts/start-chromium-monitor2.sh
    echo "✓ Home Assistant URL updated"
fi

# Check GPU memory
echo ""
echo "Checking GPU memory allocation..."
GPU_MEM=$(vcgencmd get_mem gpu | cut -d'=' -f2 | cut -d'M' -f1)
echo "Current GPU memory: ${GPU_MEM}M"

if [ "$GPU_MEM" -lt 128 ]; then
    echo "Warning: GPU memory is quite low for dual monitors."
    read -p "Would you like to set GPU memory to 256M? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Configuring GPU memory..."
        if ! grep -q "^gpu_mem=" /boot/firmware/config.txt; then
            sudo sed -i "/^\[cm4\]/i gpu_mem=256" /boot/firmware/config.txt
            echo "✓ GPU memory set to 256M"
            REBOOT_NEEDED=true
        else
            echo "gpu_mem already set in config.txt. Please check manually."
        fi
    fi
fi

# Check monitor layout
echo ""
echo "Checking monitor layout..."
echo "Running xrandr..."
xrandr | grep " connected"
echo ""
echo "The default configuration assumes:"
echo "  - Monitor 1 at position 0,0"
echo "  - Monitor 2 at position 768,0"
echo ""
echo "If your layout is different, edit the scripts:"
echo "  ~/scripts/start-chromium-monitor1.sh"
echo "  ~/scripts/start-chromium-monitor2.sh"
echo ""
read -p "Press Enter to continue..."

# Installation complete
echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review and edit the scripts if needed:"
echo "   - ~/scripts/start-chromium-monitor1.sh"
echo "   - ~/scripts/start-chromium-monitor2.sh"
echo ""
echo "2. Test the setup manually:"
echo "   ~/chromium-autostart.sh"
echo ""
echo "3. If everything works, reboot to enable autostart:"
echo "   sudo reboot"
echo ""

if [ "$REBOOT_NEEDED" = true ]; then
    echo "NOTE: A reboot is required for GPU memory changes to take effect."
    echo ""
    read -p "Reboot now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
fi

echo "Installation script finished. See README.md for more information."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if X11 is running
if [ "$XDG_SESSION_TYPE" != "x11" ]; then
    echo "Warning: You're not running X11 (current: $XDG_SESSION_TYPE)"
    echo "This setup is designed for X11. Consider switching with raspi-config."
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Install Chromium if not present
if ! command -v chromium &> /dev/null; then
    echo "Chromium not found. Installing..."
    sudo apt update
    sudo apt install -y chromium-browser
else
    echo "✓ Chromium is installed"
fi

# Create scripts directory
echo ""
echo "Creating scripts directory..."
mkdir -p ~/scripts

# Copy scripts
echo "Copying scripts..."
cp chromium-autostart.sh ~/
cp scripts/start-chromium-monitor1.sh ~/scripts/
cp scripts/start-chromium-monitor2.sh ~/scripts/

# Make scripts executable
echo "Making scripts executable..."
chmod +x ~/chromium-autostart.sh
chmod +x ~/scripts/start-chromium-monitor1.sh
chmod +x ~/scripts/start-chromium-monitor2.sh

echo "✓ Scripts installed"

# Update scripts with current username
echo ""
echo "Updating scripts with your username..."
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/chromium-autostart.sh
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/scripts/start-chromium-monitor1.sh
sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/scripts/start-chromium-monitor2.sh

# Detect desktop session
DESKTOP_SESSION_TYPE=$(echo $DESKTOP_SESSION)
echo ""
echo "Detected desktop session: $DESKTOP_SESSION_TYPE"

# Set up autostart based on desktop session
if [ "$DESKTOP_SESSION_TYPE" = "rpd-x" ]; then
    echo "Setting up autostart for rpd-x..."
    mkdir -p ~/.config/lxsession/rpd-x
    cp autostart/rpd-x-autostart ~/.config/lxsession/rpd-x/autostart
    sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/.config/lxsession/rpd-x/autostart
    echo "✓ Autostart configured for rpd-x"
elif [ "$DESKTOP_SESSION_TYPE" = "LXDE-pi" ]; then
    echo "Setting up autostart for LXDE-pi..."
    mkdir -p ~/.config/lxsession/LXDE-pi
    cp autostart/LXDE-pi-autostart ~/.config/lxsession/LXDE-pi/autostart
    sed -i "s|/home/pi|/home/$CURRENT_USER|g" ~/.config/lxsession/LXDE-pi/autostart
    echo "✓ Autostart configured for LXDE-pi"
else
    echo "Warning: Unknown desktop session type."
    echo "You may need to manually configure autostart."
    echo "See README.md for instructions."
fi

# Prompt for Home Assistant URL
echo ""
echo "=========================================="
echo "Configuration"
echo "=========================================="
echo ""
read -p "Enter your Home Assistant URL (e.g., https://homeassistant.local): " HA_URL

if [ ! -z "$HA_URL" ]; then
    echo "Updating scripts with your Home Assistant URL..."
    sed -i "s|https://<your-home-assistant-url>|$HA_URL|g" ~/scripts/start-chromium-monitor1.sh
    sed -i "s|https://<your-home-assistant-url>|$HA_URL|g" ~/scripts/start-chromium-monitor2.sh
    echo "✓ Home Assistant URL updated"
fi

# Check GPU memory
echo ""
echo "Checking GPU memory allocation..."
GPU_MEM=$(vcgencmd get_mem gpu | cut -d'=' -f2 | cut -d'M' -f1)
echo "Current GPU memory: ${GPU_MEM}M"

if [ "$GPU_MEM" -lt 128 ]; then
    echo "Warning: GPU memory is quite low for dual monitors."
    read -p "Would you like to set GPU memory to 256M? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Configuring GPU memory..."
        if ! grep -q "^gpu_mem=" /boot/firmware/config.txt; then
            sudo sed -i "/^\[cm4\]/i gpu_mem=256" /boot/firmware/config.txt
            echo "✓ GPU memory set to 256M"
            REBOOT_NEEDED=true
        else
            echo "gpu_mem already set in config.txt. Please check manually."
        fi
    fi
fi

# Check monitor layout
echo ""
echo "Checking monitor layout..."
echo "Running xrandr..."
xrandr | grep " connected"
echo ""
echo "The default configuration assumes:"
echo "  - Monitor 1 at position 0,0"
echo "  - Monitor 2 at position 768,0"
echo ""
echo "If your layout is different, edit the scripts:"
echo "  ~/scripts/start-chromium-monitor1.sh"
echo "  ~/scripts/start-chromium-monitor2.sh"
echo ""
read -p "Press Enter to continue..."

# Installation complete
echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review and edit the scripts if needed:"
echo "   - ~/scripts/start-chromium-monitor1.sh"
echo "   - ~/scripts/start-chromium-monitor2.sh"
echo ""
echo "2. Test the setup manually:"
echo "   ~/chromium-autostart.sh"
echo ""
echo "3. If everything works, reboot to enable autostart:"
echo "   sudo reboot"
echo ""

if [ "$REBOOT_NEEDED" = true ]; then
    echo "NOTE: A reboot is required for GPU memory changes to take effect."
    echo ""
    read -p "Reboot now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo reboot
    fi
fi

echo "Installation script finished. See README.md for more information."
