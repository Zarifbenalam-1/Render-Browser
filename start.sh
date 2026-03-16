#!/usr/bin/env bash

# Remove broken repo
sudo rm -f /etc/apt/sources.list.d/yarn.list
sudo apt-get update -qq
sudo apt-get install -y -qq xvfb x11vnc novnc websockify

# Install Chrome if not present
if ! command -v google-chrome &>/dev/null; then
  wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
  rm -f google-chrome-stable_current_amd64.deb
fi

# Kill any previous instances
pkill Xvfb || true
pkill x11vnc || true
pkill websockify || true
pkill google-chrome || true
sleep 1

# Start display
Xvfb :1 -screen 0 1280x720x16 -ac &
sleep 2
export DISPLAY=:1

# Start VNC
x11vnc -display :1 -forever -shared -nopw -rfbport 5900 -quiet &
sleep 1

# Start websockify on HARDCODED 6080 (not $PORT)
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &
sleep 1

# Start Chrome
google-chrome \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --window-size=1280,720 \
  about:blank &

echo "✅ Done! Ports tab → globe icon → port 6080"
