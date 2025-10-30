#!/bin/bash
# Chromium startup script for Monitor 1 (Left/Primary)
# Configure DISPLAY environment variable for X11
export DISPLAY=:0

# Launch Chromium with kiosk-friendly settings
# - noerrdialogs: Suppress error dialogs
# - disable-infobars: Hide information bars
# - app: Launch in app mode (minimal UI)
# - start-fullscreen: Open in fullscreen mode
# - window-position: Place window at specific coordinates
# - user-data-dir: Use separate profile to allow multiple instances

chromium --noerrdialogs \
--disable-infobars \
--app="https://<your-home-assistant-url>/dashboard-duodashboard/1" \
--start-fullscreen \
--window-position=0,0 \
--user-data-dir=/home/pi/.chromium-monitor1
