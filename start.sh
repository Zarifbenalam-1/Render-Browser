#!/usr/bin/env bash

export DISPLAY=:1
PORT="${PORT:-10000}"
PASSWORD="${BROWSER_PASSWORD:-007}"

mkdir -p "$HOME/.vnc"
x11vnc -storepasswd "$PASSWORD" "$HOME/.vnc/passwd"

# Low resolution = less VRAM used by Xvfb
Xvfb :1 -screen 0 1024x600x16 -ac &
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
  -quiet \
  &
sleep 2

# Chromium with maximum memory reduction flags
chromium \
  --display=:1 \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --single-process \
  --no-zygote \
  --disable-extensions \
  --disable-background-networking \
  --disable-default-apps \
  --disable-sync \
  --disable-translate \
  --disable-plugins \
  --disable-hang-monitor \
  --disable-prompt-on-repost \
  --disable-client-side-phishing-detection \
  --renderer-process-limit=1 \
  --js-flags="--max-old-space-size=128" \
  --window-size=1024,600 \
  about:blank &

exec websockify --web=/usr/share/novnc/ "$PORT" localhost:5900
