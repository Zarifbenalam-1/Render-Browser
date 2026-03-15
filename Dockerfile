FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    firefox-esr \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    openbox \
    xauth \
    ca-certificates \
    fonts-dejavu \
    procps \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash appuser
USER appuser
WORKDIR /home/appuser

COPY --chown=appuser:appuser start.sh ./start.sh
RUN chmod +x ./start.sh

CMD ["./start.sh"]
