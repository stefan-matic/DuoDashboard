#!/bin/bash
# Chromium startup script for Monitor 2 (Right/Secondary)
# Configure DISPLAY environment variable for X11
export DISPLAY=:0

# Launch Chromium with kiosk-friendly settings
# - noerrdialogs: Suppress error dialogs
# - disable-infobars: Hide information bars
# - app: Launch in app mode (minimal UI)
# - start-fullscreen: Open in fullscreen mode
# - window-position: Place window at specific coordinates (768 = width of monitor 1)
# - user-data-dir: Use separate profile to allow multiple instances

chromium --noerrdialogs \
--disable-infobars \
--app="https://<your-home-assistant-url>/dashboard-magicmirror/2" \
--start-fullscreen \
--window-position=768,0 \
--user-data-dir=/home/pi/.chromium-monitor2
