#!/usr/bin/env bash

export DISPLAY=:1
PORT="${PORT:-10000}"
PASSWORD="${BROWSER_PASSWORD:-changeme123}"

mkdir -p "$HOME/.vnc"
x11vnc -storepasswd "$PASSWORD" "$HOME/.vnc/passwd"

Xvfb :1 -screen 0 1280x720x16 -ac &
for i in $(seq 1 20); do
  xdpyinfo -display :1 >/dev/null 2>&1 && break
  sleep 1
done

x11vnc \
  -display :1 \
  -forever \
  -shared \
  -rfbauth "$HOME/.vnc/passwd" \
  -rfbport 5900 \
  -noxrecord -noxfixes -noxdamage \
  &
sleep 2

chromium \
  --display=:1 \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --single-process \
  --memory-pressure-off \
  --max-old-space-size=200 \
  --window-size=1280,720 \
  about:blank &

exec websockify --web=/usr/share/novnc/ "$PORT" localhost:5900
