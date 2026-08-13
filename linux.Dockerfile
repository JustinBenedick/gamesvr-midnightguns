FROM lacledeslan/steamcmd AS midgun-downloader

# Download MightNight Guns Dedicated Server
RUN mkdir --parents /output && \
    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 232370 validate +quit;


#---------------------------------
FROM debian:trixie-slim

ARG BUILD_DATE=unspecified \
    BUILD_NODE=unspecified \
    GIT_REVISION=unspecified

HEALTHCHECK NONE

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

LABEL architecture="amd64" \
      com.lacledeslan.build-node="$BUILD_NODE" \
      maintainer="Laclede's LAN <contact@lacledeslan.com>" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.description="Midnight Guns Dedicated Server" \
      org.opencontainers.image.revision="$GIT_REVISION" \
      org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-midnightguns" \
      org.opencontainers.image.vendor="Laclede's LAN"

RUN dpkg --add-architecture i386 && \
    apt-get update && \
        apt-get install -y --no-install-recommends --no-install-suggests --no-upgrade \
            ca-certificates libsdl2-2.0-0:i386 libstdc++6:i386 && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    # Symlink the Steam client library to prevent srcds_run errors
    mkdir -p /app/.steam/sdk32/ && \
        ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so && \
        test -L /app/.steam/sdk32/steamclient.so && \
    # Make sure logs directory exists
    mkdir -p /app/mguns/logs && \
    # Update username, home directory, and permissions for the MIDGUN user
    useradd --home /app --gid root --system MIDGUN && \
        chown MIDGUN:root -R /app;

COPY --chown=MIDGUN:root --from=midgun-downloader /output /app

USER MIDGUN

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
