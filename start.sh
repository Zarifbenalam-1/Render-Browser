#!/usr/bin/env bash
set -euo pipefail

export DISPLAY=:1
PORT="${PORT:-10000}"
PASSWORD="${BROWSER_PASSWORD:-changeme123}"

mkdir -p "$HOME/.vnc"
mkdir -p /tmp/.X11-unix || true

x11vnc -storepasswd "$PASSWORD" "$HOME/.vnc/passwd" >/dev/null

Xvfb :1 -screen 0 1366x768x24 >/tmp/xvfb.log 2>&1 &
sleep 2

openbox >/tmp/openbox.log 2>&1 &

x11vnc \
  -display :1 \
  -forever \
  -shared \
  -rfbauth "$HOME/.vnc/passwd" \
  -rfbport 5900 \
  -listen 127.0.0.1 \
  >/tmp/x11vnc.log 2>&1 &

sleep 2

firefox-esr --display=:1 --no-remote --new-instance about:blank >/tmp/firefox.log 2>&1 &

exec websockify --web=/usr/share/novnc/ "$PORT" localhost:5900
