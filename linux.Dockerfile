FROM lacledeslan/steamcmd AS midgun-downloader

# Download MightNight Guns Dedicated Server
#RUN mkdir --parents /output && \
#    /app/steamcmd.sh +force_install_dir /output +login anonymous +app_update 1877600 validate +quit;
#    /app/steamcmd.sh +force_install_dir /output +login username password +app_update 1877600 validate +quit

#This is a temporary solution until I can download Midnightguns via steamcmd without login.  Just download midnight guns server into the output directly outside of docker.
COPY /output /output

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

# The midnightguns server benefits from libtinfo.so.5, which is not available in Debian 12+ (Bookworm).
# COPY ./dist/libtinfo.5_6.4.4/i386/lib/i386-linux-gnu/libtinfo.so.5.9 /lib/i386-linux-gnu/libtinfo.so.5

RUN dpkg --add-architecture i386 && \
    apt-get update && \
        apt-get install -y --no-install-recommends --no-install-suggests --no-upgrade \
            ca-certificates libsdl2-2.0-0:i386 libstdc++6:i386 wget && \
        apt-get clean && \
        rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    # Symlink the Steam client library to the SDK paths expected by the server
    mkdir -p /app/.steam/sdk32 /app/.steam/sdk64 && \
        ln -s /app/steamclient.so /app/.steam/sdk32/steamclient.so && \
        ln -s /app/steamclient.so /app/.steam/sdk64/steamclient.so && \
        test -L /app/.steam/sdk32/steamclient.so && \
        test -L /app/.steam/sdk64/steamclient.so && \
    # Make sure logs directory exists
mkdir -p /app/mguns/logs && \
    # Update username, home directory, and permissions for the midgun user
    useradd --home /app --gid root --system midgun && \
        chown midgun:root -R /app;

COPY --chown=midgun:root --from=midgun-downloader /output /app
# Use the SteamCMD client's current interface instead of the stale bundled copy.
COPY --chown=midgun:root --from=midgun-downloader /app/linux64/steamclient.so /app/steamclient.so

# Download Midnight Guns maps from the map depot.
RUN mkdir -p /app/mguns/maps /tmp/midnight-guns-map-depot && \
    wget --quiet --output-document=- https://github.com/Jehar/midnight-guns-map-depot/archive/refs/heads/main.tar.gz | \
    tar --extract --gzip --directory=/tmp/midnight-guns-map-depot && \
    find /tmp/midnight-guns-map-depot/midnight-guns-map-depot-main/maps -type f \( -name '*.pk3' -o -name '*.map' \) -exec cp -- {} /app/mguns/maps/ \; && \
    rm -rf /tmp/midnight-guns-map-depot

USER midgun


WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
