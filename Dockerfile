FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    chromium \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    xauth \
    x11-utils \
    ca-certificates \
    fonts-dejavu \
    procps \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

COPY --chown=appuser:appuser start.sh ./start.sh
RUN chmod +x ./start.sh

CMD ["./start.sh"]
