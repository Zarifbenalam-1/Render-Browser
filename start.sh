#!/usr/bin/env bash
# no strict exit - let background processes fail individually

export DISPLAY=:1
PORT="${PORT:-10000}"
PASSWORD="${BROWSER_PASSWORD:-007}"

mkdir -p "$HOME/.vnc"
x11vnc -storepasswd "$PASSWORD" "$HOME/.vnc/passwd" || true

Xvfb :1 -screen 0 1024x600x16 -ac &
sleep 3

x11vnc \
  -display :1 \
  -forever \
  -shared \
  -rfbauth "$HOME/.vnc/passwd" \
  -rfbport 5900 \
  -noxrecord -noxfixes -noxdamage \
  -quiet &
sleep 3

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
  --renderer-process-limit=1 \
  --js-flags="--max-old-space-size=128" \
  --window-size=1024,600 \
  about:blank &

sleep 2

exec websockify --web=/usr/share/novnc/ "$PORT" localhost:5900
