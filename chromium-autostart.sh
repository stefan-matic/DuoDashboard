#!/bin/bash
# Main autostart script for dual monitor DuoDashboard setup
# This script launches both Chromium instances with appropriate delays

# Configure DISPLAY environment variable for X11
export DISPLAY=:0

# Launch first monitor (left/primary)
echo "Starting Chromium for Monitor 1..."
~/scripts/start-chromium-monitor1.sh &

# Wait a moment before launching second instance
sleep 3

# Launch second monitor (right/secondary)  
echo "Starting Chromium for Monitor 2..."
~/scripts/start-chromium-monitor2.sh &

echo "DuoDashboard startup complete"